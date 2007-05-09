From: akpm@linux-foundation.org
Subject: - revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch removed from -mm tree
Date: Wed, 09 May 2007 02:55:44 -0700
Message-ID: <200705090955.l499tiqw020521@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755519AbXEIJ4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:56:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     fs/revoke.c: cleanups (and bugfix for 64bit systems)
has been removed from the -mm tree.  Its filename was
     revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch

This patch was dropped because it was folded into revoke-core-code.patch

------------------------------------------------------
Subject: fs/revoke.c: cleanups (and bugfix for 64bit systems)
From: Adrian Bunk <bunk@stusta.de>

On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc3-mm1:
>...
> +revoke-core-code.patch
>...
>  revoke() syscall
>...

This patch contains the following:
- every file should #include the headers containing the prototypes for
  it's global functions
- fix the wrong return value of sys_frevoke() gcc was now able to detect
- make 2 needlessly global structs static

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems
+++ a/fs/revoke.c
@@ -16,6 +16,7 @@
 #include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/revoked_fs_i.h>
+#include <linux/syscalls.h>
 
 /*
  * This is used for pre-allocating an array of file pointers so that we don't
@@ -28,7 +29,7 @@ struct revoke_table {
 	unsigned long restore_start;
 };
 
-struct kmem_cache *revokefs_inode_cache;
+static struct kmem_cache *revokefs_inode_cache;
 
 /*
  * Revoked file descriptors point to inodes in the revokefs filesystem.
@@ -551,7 +552,7 @@ asmlinkage long sys_revokeat(int dfd, co
 	return err;
 }
 
-asmlinkage int sys_frevoke(unsigned int fd)
+asmlinkage long sys_frevoke(unsigned int fd)
 {
 	struct file *file = fget(fd);
 	int err = -EBADF;
@@ -618,7 +619,7 @@ static int revokefs_get_sb(struct file_s
 			     REVOKEFS_MAGIC, mnt);
 }
 
-struct file_system_type revokefs_fs_type = {
+static struct file_system_type revokefs_fs_type = {
 	.name = "revokefs",
 	.get_sb = revokefs_get_sb,
 	.kill_sb = kill_anon_super
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-nfs4_acl_add_ace.patch
compiler-introduce-__used-and-__maybe_unused.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
ibmtr_cs-fix-hang-on-eject.patch
git-battery.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
drivers-scsi-ipsc-remove-kernel-24-code.patch
drivers-scsi-nsp32c-remove-kernel-24-code.patch
git-unionfs.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
unexport-pci_proc_attach_device.patch
ext2-reservations.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
slim-main-patch.patch
slim-debug-output.patch
mutex-subsystem-synchro-test-module.patch
