From: akpm@linux-foundation.org
Subject: + introduce-path_get-unionfs.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:03:13 -0800
Message-ID: <200711052103.lA5L3Dr3019606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbXKEVDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:03:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, agruen@suse.de, hch@lst.de


The patch titled
     From: Jan Blunck <jblunck@suse.de>
has been added to the -mm tree.  Its filename is
     introduce-path_get-unionfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Jan Blunck <jblunck@suse.de>


This introduces the symmetric function to path_put() for getting a reference
to the dentry and vfsmount of a struct path in the right order.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
---

Index: b/fs/namei.c
===================================================================
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/unionfs/super.c~introduce-path_get-unionfs fs/unionfs/super.c
--- a/fs/unionfs/super.c~introduce-path_get-unionfs
+++ a/fs/unionfs/super.c
@@ -544,7 +544,7 @@ static int unionfs_remount_fs(struct sup
 	memcpy(tmp_lower_paths, UNIONFS_D(sb->s_root)->lower_paths,
 	       cur_branches * sizeof(struct path));
 	for (i = 0; i < cur_branches; i++)
-		pathget(&tmp_lower_paths[i]); /* drop refs at end of fxn */
+		path_get(&tmp_lower_paths[i]); /* drop refs at end of fxn */
 
 	/*******************************************************************
 	 * For each branch command, do path_lookup on the requested branch,
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
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
