From: akpm@linux-foundation.org
Subject: - dont-touch-fs_struct-in-usermodehelper.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:58:18 -0700
Message-ID: <200710261858.l9QIwIUV009518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbXJZS7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:59:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, agruen@suse.de, bharata@linux.vnet.ibm.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Don't touch fs_struct in usermodehelper
has been removed from the -mm tree.  Its filename was
     dont-touch-fs_struct-in-usermodehelper.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Don't touch fs_struct in usermodehelper
From: Jan Blunck <jblunck@suse.de>

This test seems to be unnecessary since we always have rootfs mounted before
calling a usermodehelper.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/kmod.c~dont-touch-fs_struct-in-usermodehelper kernel/kmod.c
--- a/kernel/kmod.c~dont-touch-fs_struct-in-usermodehelper
+++ a/kernel/kmod.c
@@ -173,10 +173,7 @@ static int ____call_usermodehelper(void 
 	 */
 	set_user_nice(current, 0);
 
-	retval = -EPERM;
-	if (current->fs->root)
-		retval = kernel_execve(sub_info->path,
-				sub_info->argv, sub_info->envp);
+	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
 	sub_info->retval = retval;
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
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
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
