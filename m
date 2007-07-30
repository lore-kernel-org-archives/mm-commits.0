From: akpm@linux-foundation.org
Subject: + i386-remove-maccumulate-outgoing-args.patch added to -mm tree
Date: Mon, 30 Jul 2007 14:58:48 -0700
Message-ID: <200707302158.l6ULwmAT032543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47612 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968298AbXG3V7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 17:59:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     i386: remove -maccumulate-outgoing-args
has been added to the -mm tree.  Its filename is
     i386-remove-maccumulate-outgoing-args.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
drivers-base-power-make-2-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
drivers-i2c-i2c-corec-make-code-static.patch
