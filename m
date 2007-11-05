From: akpm@linux-foundation.org
Subject: + introduce-path_put-unionfs.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:18:27 -0800
Message-ID: <200711052118.lA5LISXk020218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbXKEVSl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:18:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, hch@lst.de


The patch titled
     Introduce path_put() (unionfs)
has been added to the -mm tree.  Its filename is
     introduce-path_put-unionfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Introduce path_put() (unionfs)
From: Jan Blunck <jblunck@suse.de>

* Add path_put() functions for releasing a reference to the dentry and
  vfsmount of a struct path in the right order

* Switch from path_release(nd) to path_put(&nd->path)

* Rename dput_path() to path_put_conditional()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
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
 
@@ -788,7 +788,7 @@ out_release:
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
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
one-less-parameter-to-__d_path.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
