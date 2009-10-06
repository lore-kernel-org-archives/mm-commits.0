From: akpm@linux-foundation.org
Subject: + autofs4-use-helper-functions-for-expiring-list.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:50:25 -0700
Message-ID: <200910062050.n96KoPAB009451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933338AbZJFUvd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:51:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net


The patch titled
     autofs4: use helper functions for expiring list
has been added to the -mm tree.  Its filename is
     autofs4-use-helper-functions-for-expiring-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch
autofs4-use-helper-functions-for-active-list-handling.patch
autofs4-use-helper-functions-for-expiring-list.patch
autofs4-use-helper-function-for-need-mount-check.patch
autofs4-use-autofs_info-for-pending-flag.patch
autofs4-renamer-unhashed-to-active-in-autofs4_lookup.patch
autofs4-cleanup-active-and-expire-lookup.patch
autofs4-eliminate-d_unhashed-in-path-walk-checks.patch
autofs4-rename-dentry-to-active-in-autofs4_lookup_active.patch
autofs4-rename-dentry-to-expiring-in-autofs4_lookup_expiring.patch
autofs4-always-use-lookup-for-lookup.patch

