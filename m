From: akpm@linux-foundation.org
Subject: + add-an-anonymous-inode-source-tidy.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:33:32 -0800
Message-ID: <200703072233.l27MXWPr011308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992476AbXCGWde (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davidel@xmailserver.org


The patch titled
     add-an-anonymous-inode-source-tidy
has been added to the -mm tree.  Its filename is
     add-an-anonymous-inode-source-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-an-anonymous-inode-source-tidy
From: Andrew Morton <akpm@linux-foundation.org>

- use magic.h

- 80 cols

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/anon_inodes.c      |   20 +++-----------------
 include/linux/magic.h |    1 +
 2 files changed, 4 insertions(+), 17 deletions(-)

diff -puN fs/anon_inodes.c~add-an-anonymous-inode-source-tidy fs/anon_inodes.c
--- a/fs/anon_inodes.c~add-an-anonymous-inode-source-tidy
+++ a/fs/anon_inodes.c
@@ -9,6 +9,7 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/magic.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/module.h>
@@ -17,18 +18,11 @@
 
 #include <asm/uaccess.h>
 
-
-
-#define AINOFS_MAGIC 0x09041934
-
-
 static int ainofs_delete_dentry(struct dentry *dentry);
 static struct inode *aino_getinode(void);
 static struct inode *aino_mkinode(void);
 static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
-			     const char *dev_name, void *data, struct vfsmount *mnt);
-
-
+			const char *dev_name, void *data, struct vfsmount *mnt);
 
 static struct vfsmount *aino_mnt __read_mostly;
 static struct inode *aino_inode;
@@ -43,7 +37,6 @@ static struct dentry_operations ainofs_d
 };
 
 
-
 int aino_getfd(int *pfd, struct inode **pinode, struct file **pfile,
 	       char const *name, const struct file_operations *fops, void *priv)
 {
@@ -113,7 +106,6 @@ eexit_1:
 	return error;
 }
 
-
 static int ainofs_delete_dentry(struct dentry *dentry)
 {
 	/*
@@ -124,13 +116,11 @@ static int ainofs_delete_dentry(struct d
 	return 1;
 }
 
-
 static struct inode *aino_getinode(void)
 {
 	return igrab(aino_inode);
 }
 
-
 /*
  * A single inode exist for all aino files. On the contrary of pipes,
  * aino inodes has no per-instance data associated, so we can avoid
@@ -163,17 +153,14 @@ eexit_1:
 	return ERR_PTR(error);
 }
 
-
 static int ainofs_get_sb(struct file_system_type *fs_type, int flags,
-			     const char *dev_name, void *data, struct vfsmount *mnt)
+			const char *dev_name, void *data, struct vfsmount *mnt)
 {
 	return get_sb_pseudo(fs_type, "aino:", NULL, AINOFS_MAGIC, mnt);
 }
 
-
 static int __init aino_init(void)
 {
-
 	if (register_filesystem(&aino_fs_type))
 		goto epanic;
 
@@ -191,7 +178,6 @@ epanic:
 	panic("aino_init() failed\n");
 }
 
-
 static void __exit aino_exit(void)
 {
 	iput(aino_inode);
diff -puN include/linux/magic.h~add-an-anonymous-inode-source-tidy include/linux/magic.h
--- a/include/linux/magic.h~add-an-anonymous-inode-source-tidy
+++ a/include/linux/magic.h
@@ -39,5 +39,6 @@
 
 #define SMB_SUPER_MAGIC		0x517B
 #define USBDEVICE_SUPER_MAGIC	0x9fa2
+#define AINOFS_MAGIC		0x09041934
 
 #endif /* __LINUX_MAGIC_H__ */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ivtv-warning-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-md-accel-fixup.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
b44-warning-fixes.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
