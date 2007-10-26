From: akpm@linux-foundation.org
Subject: - introduce-path_put-unionfs.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:58:58 -0700
Message-ID: <200710261858.l9QIwwhj009563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbXJZS7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, agruen@suse.de, bharata@linux.vnet.ibm.com, ezk@cs.sunysb.edu, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Introduce path_put()
has been removed from the -mm tree.  Its filename was
     introduce-path_put-unionfs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Introduce path_put()
From: Jan Blunck <jblunck@suse.de>

* Add path_put() functions for releasing a reference to the dentry and
  vfsmount of a struct path in the right order

* Switch from path_release(nd) to path_put(&nd->path)

* Rename dput_path() to path_put_conditional()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/main.c  |    2 +-
 fs/unionfs/super.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/unionfs/main.c~introduce-path_put-unionfs fs/unionfs/main.c
--- a/fs/unionfs/main.c~introduce-path_put-unionfs
+++ a/fs/unionfs/main.c
@@ -368,7 +368,7 @@ static int parse_dirs_option(struct supe
 		if (err) {
 			printk(KERN_ERR "unionfs: lower directory "
 			       "'%s' is not a valid branch\n", name);
-			path_release(&nd);
+			path_put(&nd.path);
 			goto out;
 		}
 
diff -puN fs/unionfs/super.c~introduce-path_put-unionfs fs/unionfs/super.c
--- a/fs/unionfs/super.c~introduce-path_put-unionfs
+++ a/fs/unionfs/super.c
@@ -205,7 +205,7 @@ static noinline int do_remount_mode_opti
 		if (nd.path.mnt == new_lower_paths[idx].mnt &&
 		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
-	path_release(&nd);	/* no longer needed */
+	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
 		err = -ENOENT;	/* err may have been reset above */
 		printk(KERN_ERR "unionfs: branch \"%s\" "
@@ -248,7 +248,7 @@ static noinline int do_remount_del_optio
 		if (nd.path.mnt == new_lower_paths[idx].mnt &&
 		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
-	path_release(&nd);	/* no longer needed */
+	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
 		printk(KERN_ERR "unionfs: branch \"%s\" "
 		       "not found\n", optarg);
@@ -267,7 +267,7 @@ static noinline int do_remount_del_optio
 	 * new_data and new_lower_paths one to the left.  Finally, adjust
 	 * cur_branches.
 	 */
-	pathput(&new_lower_paths[idx]);
+	path_put(&new_lower_paths[idx]);
 
 	if (idx < cur_branches - 1) {
 		/* if idx==cur_branches-1, we delete last branch: easy */
@@ -332,7 +332,7 @@ static noinline int do_remount_add_optio
 		if (nd.path.mnt == new_lower_paths[idx].mnt &&
 		    nd.path.dentry == new_lower_paths[idx].dentry)
 			break;
-	path_release(&nd);	/* no longer needed */
+	path_put(&nd.path);	/* no longer needed */
 	if (idx == cur_branches) {
 		printk(KERN_ERR "unionfs: branch \"%s\" "
 		       "not found\n", optarg);
@@ -375,7 +375,7 @@ found_insertion_point:
 	if (err) {
 		printk(KERN_ERR "unionfs: lower directory "
 		       "\"%s\" is not a valid branch\n", optarg);
-		path_release(&nd);
+		path_put(&nd.path);
 		goto out;
 	}
 
@@ -789,7 +789,7 @@ out_release:
 	/* no need to cleanup/release anything in tmp_data */
 	if (tmp_lower_paths)
 		for (i = 0; i < new_branches; i++)
-			pathput(&tmp_lower_paths[i]);
+			path_put(&tmp_lower_paths[i]);
 out_free:
 	kfree(tmp_lower_paths);
 	kfree(tmp_data);
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
