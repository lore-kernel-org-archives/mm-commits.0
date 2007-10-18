From: akpm@linux-foundation.org
Subject: - shrink_dcache_sb-speedup.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:00:30 -0700
Message-ID: <200710180700.l9I70UpP031104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932133AbXJRHhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, amirkin@openvz.org, dev@openvz.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     shrink_dcache_sb speedup
has been removed from the -mm tree.  Its filename was
     shrink_dcache_sb-speedup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: shrink_dcache_sb speedup
From: Denis V. Lunev <den@openvz.org>

This patch makes shrink_dcache_sb consistent with dentry pruning policy.

On the first pass we iterate over dentry unused list and prepare some
dentries for removal.

However, since the existing code moves evicted dentries to the beginning of
the LRU it can happen that fresh dentries from other superblocks will be
inserted *before* our dentries.

This can result in significant slowdown of shrink_dcache_sb().  Moreover,
for virtual filesystems like unionfs which can call dput() during dentries
kill existing code results in O(n^2) complexity.

We observed 2 minutes shrink_dcache_sb() with only 35000 dentries.

To avoid this effects we propose to isolate sb dentries at the end
of LRU list.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Andrey Mirkin <amirkin@openvz.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c          |    6 +++---
 include/linux/list.h |   12 ++++++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff -puN fs/dcache.c~shrink_dcache_sb-speedup fs/dcache.c
--- a/fs/dcache.c~shrink_dcache_sb-speedup
+++ a/fs/dcache.c
@@ -553,18 +553,18 @@ void shrink_dcache_sb(struct super_block
 	 * superblock to the most recent end of the unused list.
 	 */
 	spin_lock(&dcache_lock);
-	list_for_each_safe(tmp, next, &dentry_unused) {
+	list_for_each_prev_safe(tmp, next, &dentry_unused) {
 		dentry = list_entry(tmp, struct dentry, d_lru);
 		if (dentry->d_sb != sb)
 			continue;
-		list_move(tmp, &dentry_unused);
+		list_move_tail(tmp, &dentry_unused);
 	}
 
 	/*
 	 * Pass two ... free the dentries for this superblock.
 	 */
 repeat:
-	list_for_each_safe(tmp, next, &dentry_unused) {
+	list_for_each_prev_safe(tmp, next, &dentry_unused) {
 		dentry = list_entry(tmp, struct dentry, d_lru);
 		if (dentry->d_sb != sb)
 			continue;
diff -puN include/linux/list.h~shrink_dcache_sb-speedup include/linux/list.h
--- a/include/linux/list.h~shrink_dcache_sb-speedup
+++ a/include/linux/list.h
@@ -478,6 +478,18 @@ static inline void list_splice_init_rcu(
 		pos = n, n = pos->next)
 
 /**
+ * list_for_each_prev_safe - iterate over a list backwards safe against removal
+			of list entry
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @n:		another &struct list_head to use as temporary storage
+ * @head:	the head for your list.
+ */
+#define list_for_each_prev_safe(pos, n, head) \
+	for (pos = (head)->prev, n = pos->prev; \
+	     prefetch(pos->prev), pos != (head); \
+	     pos = n, n = pos->prev)
+
+/**
  * list_for_each_entry	-	iterate over list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
_

Patches currently in -mm which might be from den@openvz.org are

origin.patch
