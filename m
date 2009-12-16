From: akpm@linux-foundation.org
Subject: [merged] autofs4-rename-dentry-to-active-in-autofs4_lookup_active.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:33:59 -0800
Message-ID: <200912162033.nBGKXxji012990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763184AbZLPUeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:34:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: rename dentry to active in autofs4_lookup_active()
has been removed from the -mm tree.  Its filename was
     autofs4-rename-dentry-to-active-in-autofs4_lookup_active.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: rename dentry to active in autofs4_lookup_active()
From: Ian Kent <raven@themaw.net>

In autofs4_lookup_active() a declaration within the list traversal loop
uses a declaration that has the same name as the function parameter.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-rename-dentry-to-active-in-autofs4_lookup_active fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-rename-dentry-to-active-in-autofs4_lookup_active
+++ a/fs/autofs4/root.c
@@ -419,23 +419,23 @@ static struct dentry *autofs4_lookup_act
 	head = &sbi->active_list;
 	list_for_each(p, head) {
 		struct autofs_info *ino;
-		struct dentry *dentry;
+		struct dentry *active;
 		struct qstr *qstr;
 
 		ino = list_entry(p, struct autofs_info, active);
-		dentry = ino->dentry;
+		active = ino->dentry;
 
-		spin_lock(&dentry->d_lock);
+		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (atomic_read(&dentry->d_count) == 0)
+		if (atomic_read(&active->d_count) == 0)
 			goto next;
 
-		qstr = &dentry->d_name;
+		qstr = &active->d_name;
 
-		if (dentry->d_name.hash != hash)
+		if (active->d_name.hash != hash)
 			goto next;
-		if (dentry->d_parent != parent)
+		if (active->d_parent != parent)
 			goto next;
 
 		if (qstr->len != len)
@@ -443,15 +443,15 @@ static struct dentry *autofs4_lookup_act
 		if (memcmp(qstr->name, str, len))
 			goto next;
 
-		if (d_unhashed(dentry)) {
-			dget(dentry);
-			spin_unlock(&dentry->d_lock);
+		if (d_unhashed(active)) {
+			dget(active);
+			spin_unlock(&active->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			spin_unlock(&dcache_lock);
-			return dentry;
+			return active;
 		}
 next:
-		spin_unlock(&dentry->d_lock);
+		spin_unlock(&active->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
 	spin_unlock(&dcache_lock);
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch

