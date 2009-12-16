From: akpm@linux-foundation.org
Subject: [merged] autofs4-use-helper-functions-for-expiring-list.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:33:41 -0800
Message-ID: <200912162033.nBGKXfwn012957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754251AbZLPUd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:33:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: use helper functions for expiring list
has been removed from the -mm tree.  Its filename was
     autofs4-use-helper-functions-for-expiring-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: use helper functions for expiring list
From: Ian Kent <raven@themaw.net>

Define some simple helper functions for adding and deleting entries on the
expiring dentry list.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |   26 ++++++++++++++++++++++++++
 fs/autofs4/root.c     |   15 +++------------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-use-helper-functions-for-expiring-list fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-use-helper-functions-for-expiring-list
+++ a/fs/autofs4/autofs_i.h
@@ -266,5 +266,31 @@ out:
 	return ret;
 }
 
+static inline void autofs4_add_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (list_empty(&ino->expiring))
+			list_add(&ino->expiring, &sbi->expiring_list);
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
+static inline void autofs4_del_expiring(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino) {
+		spin_lock(&sbi->lookup_lock);
+		if (!list_empty(&ino->expiring))
+			list_del_init(&ino->expiring);
+		spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
 void autofs4_dentry_release(struct dentry *);
 extern void autofs4_kill_sb(struct super_block *);
diff -puN fs/autofs4/root.c~autofs4-use-helper-functions-for-expiring-list fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-use-helper-functions-for-expiring-list
+++ a/fs/autofs4/root.c
@@ -563,10 +563,7 @@ static struct dentry *autofs4_lookup(str
 			 */
 			ino = autofs4_dentry_ino(expiring);
 			autofs4_expire_wait(expiring);
-			spin_lock(&sbi->lookup_lock);
-			if (!list_empty(&ino->expiring))
-				list_del_init(&ino->expiring);
-			spin_unlock(&sbi->lookup_lock);
+			autofs4_del_expiring(expiring);
 			dput(expiring);
 		}
 
@@ -732,10 +729,7 @@ static int autofs4_dir_unlink(struct ino
 	dir->i_mtime = CURRENT_TIME;
 
 	spin_lock(&dcache_lock);
-	spin_lock(&sbi->lookup_lock);
-	if (list_empty(&ino->expiring))
-		list_add(&ino->expiring, &sbi->expiring_list);
-	spin_unlock(&sbi->lookup_lock);
+	autofs4_add_expiring(dentry);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -761,10 +755,7 @@ static int autofs4_dir_rmdir(struct inod
 		spin_unlock(&dcache_lock);
 		return -ENOTEMPTY;
 	}
-	spin_lock(&sbi->lookup_lock);
-	if (list_empty(&ino->expiring))
-		list_add(&ino->expiring, &sbi->expiring_list);
-	spin_unlock(&sbi->lookup_lock);
+	autofs4_add_expiring(dentry);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch

