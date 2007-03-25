From: akpm@linux-foundation.org
Subject: + revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:25:43 -0800
Message-ID: <200703250925.l2P9PhRG024643@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37418 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933234AbXCYJ3D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, penberg@cs.helsinki.fi


The patch titled
     fs/revoke.c: cleanups (and bugfix for 64bit systems)
has been added to the -mm tree.  Its filename is
     revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
