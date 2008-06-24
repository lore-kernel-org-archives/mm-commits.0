From: akpm@linux-foundation.org
Subject: + vfs-fix-coding-style-in-dcachec.patch added to -mm tree
Date: Mon, 23 Jun 2008 19:11:48 -0700
Message-ID: <200806240211.m5O2BmPj027850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756880AbYFXCLz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 22:11:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: k-makita@np.css.fujitsu.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: fix coding style in dcache.c
has been added to the -mm tree.  Its filename is
     vfs-fix-coding-style-in-dcachec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix coding style in dcache.c
From: Kentaro Makita <k-makita@np.css.fujitsu.com>

Fix coding style at dcache.c. No behavior changed.

Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN fs/dcache.c~vfs-fix-coding-style-in-dcachec fs/dcache.c
--- a/fs/dcache.c~vfs-fix-coding-style-in-dcachec
+++ a/fs/dcache.c
@@ -452,15 +452,15 @@ static void __shrink_dcache_sb(struct su
 	int cnt = 0;
 
 	BUG_ON(!sb);
-	BUG_ON((flags & DCACHE_REFERENCED) && count == NULL);
+	BUG_ON((flags & DCACHE_REFERENCED) && !count);
 	spin_lock(&dcache_lock);
-	if (count != NULL)
+	if (count)
 		/* called from prune_dcache() and shrink_dcache_parent() */
 		cnt = *count;
 restart:
-	if (count == NULL)
+	if (!count) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
-	else {
+	} else {
 		while (!list_empty(&sb->s_dentry_lru)) {
 			dentry = list_entry(sb->s_dentry_lru.prev,
 					struct dentry, d_lru);
@@ -472,16 +472,15 @@ restart:
 			 * the dentry has this flag set, don't free it. Clear
 			 * the flag and put it back on the LRU.
 			 */
-			if ((flags & DCACHE_REFERENCED)
-				&& (dentry->d_flags & DCACHE_REFERENCED)) {
+			if ((flags & DCACHE_REFERENCED) &&
+			    (dentry->d_flags & DCACHE_REFERENCED)) {
 				dentry->d_flags &= ~DCACHE_REFERENCED;
 				list_move_tail(&dentry->d_lru, &referenced);
 				spin_unlock(&dentry->d_lock);
 			} else {
 				list_move_tail(&dentry->d_lru, &tmp);
 				spin_unlock(&dentry->d_lock);
-				cnt--;
-				if (!cnt)
+				if (--cnt == 0)
 					break;
 			}
 		}
@@ -503,10 +502,10 @@ restart:
 		/* dentry->d_lock was dropped in prune_one_dentry() */
 		cond_resched_lock(&dcache_lock);
 	}
-	if (count == NULL && !list_empty(&sb->s_dentry_lru))
-		goto restart;
-	if (count != NULL)
+	if (count)
 		*count = cnt;
+	else if (!list_empty(&sb->s_dentry_lru))
+		goto restart;
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
 	spin_unlock(&dcache_lock);
_

Patches currently in -mm which might be from k-makita@np.css.fujitsu.com are

fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries.patch
fix-soft-lock-up-at-nfs-mount-by-per-sb-lru-list-of-unused-dentries-fix.patch
vfs-fix-coding-style-in-dcachec.patch
vfs-add-cond_resched_lock-while-scanning-dentry-lru-lists.patch

