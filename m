From: akpm@linux-foundation.org
Subject: + fuse-fix-node-id-type.patch added to -mm tree
Date: Sun, 27 Apr 2008 19:26:32 -0700
Message-ID: <200804280226.m3S2QWUd003425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbYD1C1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 22:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix node ID type
has been added to the -mm tree.  Its filename is
     fuse-fix-node-id-type.patch

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
Subject: fuse: fix node ID type
From: Miklos Szeredi <mszeredi@suse.cz>

Node ID is 64bit but it is passed as unsigned long to some functions.  This
breakage wasn't noticed, because libfuse uses unsigned long too.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/fuse_i.h |    4 ++--
 fs/fuse/inode.c  |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/fuse/fuse_i.h~fuse-fix-node-id-type fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-fix-node-id-type
+++ a/fs/fuse/fuse_i.h
@@ -464,7 +464,7 @@ extern const struct file_operations fuse
 /**
  * Get a filled in inode
  */
-struct inode *fuse_iget(struct super_block *sb, unsigned long nodeid,
+struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 			int generation, struct fuse_attr *attr,
 			u64 attr_valid, u64 attr_version);
 
@@ -472,7 +472,7 @@ struct inode *fuse_iget(struct super_blo
  * Send FORGET command
  */
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
-		      unsigned long nodeid, u64 nlookup);
+		      u64 nodeid, u64 nlookup);
 
 /**
  * Initialize READ or READDIR request
diff -puN fs/fuse/inode.c~fuse-fix-node-id-type fs/fuse/inode.c
--- a/fs/fuse/inode.c~fuse-fix-node-id-type
+++ a/fs/fuse/inode.c
@@ -84,7 +84,7 @@ static void fuse_destroy_inode(struct in
 }
 
 void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
-		      unsigned long nodeid, u64 nlookup)
+		      u64 nodeid, u64 nlookup)
 {
 	struct fuse_forget_in *inarg = &req->misc.forget_in;
 	inarg->nlookup = nlookup;
@@ -207,7 +207,7 @@ static void fuse_init_inode(struct inode
 
 static int fuse_inode_eq(struct inode *inode, void *_nodeidp)
 {
-	unsigned long nodeid = *(unsigned long *) _nodeidp;
+	u64 nodeid = *(u64 *) _nodeidp;
 	if (get_node_id(inode) == nodeid)
 		return 1;
 	else
@@ -216,12 +216,12 @@ static int fuse_inode_eq(struct inode *i
 
 static int fuse_inode_set(struct inode *inode, void *_nodeidp)
 {
-	unsigned long nodeid = *(unsigned long *) _nodeidp;
+	u64 nodeid = *(u64 *) _nodeidp;
 	get_fuse_inode(inode)->nodeid = nodeid;
 	return 0;
 }
 
-struct inode *fuse_iget(struct super_block *sb, unsigned long nodeid,
+struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 			int generation, struct fuse_attr *attr,
 			u64 attr_valid, u64 attr_version)
 {
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-nfsd.patch
mm-rotate_reclaimable_page-cleanup.patch
vfs-remove-lives_below_in_same_fs.patch
ecryptfs-add-missing-lock-around-notify_change.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-add-nr_writeback_temp-counter-fix.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch
fuse-update-file-size-on-short-read-fix.patch
fuse-fix-max-i-o-size-calculation.patch
fuse-fix-node-id-type.patch
fuse-fix-race-in-llseek.patch
fuse-fix-race-in-llseek-fix.patch
fuse-fix-sparse-warnings.patch

