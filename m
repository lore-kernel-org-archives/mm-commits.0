From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-track-number-of-mount-writers-fix.patch removed from -mm tree
Date: Mon, 05 Nov 2007 15:07:40 -0800
Message-ID: <200711052307.lA5N7ewJ024380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754567AbXKEXJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:09:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: Accept passing a mnt NULL pointer to mnt_drop_write()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-track-number-of-mount-writers-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: Accept passing a mnt NULL pointer to mnt_drop_write()
From: Jan Blunck <jblunck@suse.de>

In case of somebody opens a file with dentry_open(dentry, NULL, ...) we
don't want to stumble on the NULL pointer mnt in struct file.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-fix fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-fix
+++ a/fs/namespace.c
@@ -249,6 +249,9 @@ void mnt_drop_write(struct vfsmount *mnt
 	int must_check_underflow = 0;
 	struct mnt_writer *cpu_writer;
 
+	if (!mnt)
+		return;
+
 	cpu_writer = &get_cpu_var(mnt_writers);
 	spin_lock(&cpu_writer->lock);
 
_

Patches currently in -mm which might be from jblunck@suse.de are

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
