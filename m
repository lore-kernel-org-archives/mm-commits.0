From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch added to -mm tree
Date: Fri, 21 Sep 2007 01:02:18 -0700
Message-ID: <200709210802.l8L82IcY025715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754279AbXIUICj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 04:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@lst.de


The patch titled
     r/o bind mounts: elevate write count during entire ncp_ioctl()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: elevate write count during entire ncp_ioctl()
From: Dave Hansen <haveblue@us.ibm.com>

Some ioctls need write access, but others don't.  Make a helper function to
decide when write access is needed, and take it.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ioctl.c |   54 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff -puN fs/ncpfs/ioctl.c~r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl
+++ a/fs/ncpfs/ioctl.c
@@ -14,6 +14,7 @@
 #include <linux/ioctl.h>
 #include <linux/time.h>
 #include <linux/mm.h>
+#include <linux/mount.h>
 #include <linux/highuid.h>
 #include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
@@ -261,7 +262,7 @@ ncp_get_charsets(struct ncp_server* serv
 }
 #endif /* CONFIG_NCPFS_NLS */
 
-int ncp_ioctl(struct inode *inode, struct file *filp,
+static int __ncp_ioctl(struct inode *inode, struct file *filp,
 	      unsigned int cmd, unsigned long arg)
 {
 	struct ncp_server *server = NCP_SERVER(inode);
@@ -822,6 +823,57 @@ outrel:			
 	return -EINVAL;
 }
 
+static int ncp_ioctl_need_write(unsigned int cmd)
+{
+	switch (cmd) {
+	case NCP_IOC_GET_FS_INFO:
+	case NCP_IOC_GET_FS_INFO_V2:
+	case NCP_IOC_NCPREQUEST:
+	case NCP_IOC_SETDENTRYTTL:
+	case NCP_IOC_SIGN_INIT:
+	case NCP_IOC_LOCKUNLOCK:
+	case NCP_IOC_SET_SIGN_WANTED:
+		return 1;
+	case NCP_IOC_GETOBJECTNAME:
+	case NCP_IOC_SETOBJECTNAME:
+	case NCP_IOC_GETPRIVATEDATA:
+	case NCP_IOC_SETPRIVATEDATA:
+	case NCP_IOC_SETCHARSETS:
+	case NCP_IOC_GETCHARSETS:
+	case NCP_IOC_CONN_LOGGED_IN:
+	case NCP_IOC_GETDENTRYTTL:
+	case NCP_IOC_GETMOUNTUID2:
+	case NCP_IOC_SIGN_WANTED:
+	case NCP_IOC_GETROOT:
+	case NCP_IOC_SETROOT:
+		return 0;
+	default:
+		/* unkown IOCTL command, assume write */
+	}
+	return 1;
+}
+
+int ncp_ioctl(struct inode *inode, struct file *filp,
+	      unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	if (ncp_ioctl_need_write(cmd)) {
+		/*
+		 * inside the ioctl(), any failures which
+		 * are because of file_permission() are
+		 * -EACCESS, so it seems consistent to keep
+		 *  that here.
+		 */
+		if (mnt_want_write(filp->f_vfsmnt))
+			return -EACCES;
+	}
+	ret = __ncp_ioctl(inode, filp, cmd, arg);
+	if (ncp_ioctl_need_write(cmd))
+		mnt_drop_write(filp->f_vfsmnt);
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 long ncp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch
r-o-bind-mounts-give-may_open-a-local-mnt-variable.patch
r-o-bind-mounts-create-cleanup-helper-svc_msnfs.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-opend-files.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
page-owner-tracking-leak-detector.patch
