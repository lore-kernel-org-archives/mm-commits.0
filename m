From: akpm@linux-foundation.org
Subject: - i386-remove-maccumulate-outgoing-args.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:29 -0700
Message-ID: <200708141914.l7EJETil016621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37527 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765776AbXHNTUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     i386: remove -maccumulate-outgoing-args
has been removed from the -mm tree.  Its filename was
     i386-remove-maccumulate-outgoing-args.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: remove -maccumulate-outgoing-args
From: Adrian Bunk <bunk@stusta.de>

Contrary to the comment "newer gccs do it by default", newer gcc versions
default to -maccumulate-outgoing-args only with CONFIG_CC_OPTIMIZE_FOR_SIZE=n,
and then only with some CPU settings.

Measured with an i386 defconfig, gcc 4.2.1 and kernel 2.6.23-rc1 ("orig" is
the plain kernel, "changed is with -maccumulate-outgoing-args removed):

$ ls -la vmlinux*
-rwxrwxr-x 1 bunk bunk 6269713 2007-07-24 22:19 vmlinux.changed
-rwxrwxr-x 1 bunk bunk 6425361 2007-07-24 22:19 vmlinux.orig
$ size vmlinux.*
   text    data     bss     dec     hex filename
4493465  504108  614400 5611973  55a1c5 vmlinux.changed
4646160  504108  614400 5764668  57f63c vmlinux.orig
$

That's a 2.5% size increase that does for sure hurt small systems.

If the stack unwinder ever comes back and needs this as indicated in the
comment, adding it to the cflags when the user enabled the unwinder should be
a better option.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Makefile |    4 ----
 1 files changed, 4 deletions(-)

diff -puN arch/i386/Makefile~i386-remove-maccumulate-outgoing-args arch/i386/Makefile
--- a/arch/i386/Makefile~i386-remove-maccumulate-outgoing-args
+++ a/arch/i386/Makefile
@@ -42,10 +42,6 @@ include $(srctree)/arch/i386/Makefile.cp
 # temporary until string.h is fixed
 cflags-y += -ffreestanding
 
-# this works around some issues with generating unwind tables in older gccs
-# newer gccs do it by default
-cflags-y += -maccumulate-outgoing-args
-
 # Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
 # a lot more stack due to the lack of sharing of stacklots:
 CFLAGS				+= $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
kernel-auditscc-fix-an-off-by-one.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
git-netdev-all.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
git-backlight.patch
parisc-extern-inline-static-inline.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
git-cryptodev.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
