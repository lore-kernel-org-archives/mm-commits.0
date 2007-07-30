From: akpm@linux-foundation.org
Subject: + i386-alternativec-really-stop-mces-during-code.patch added to -mm tree
Date: Mon, 30 Jul 2007 14:58:54 -0700
Message-ID: <200707302158.l6ULwsO7032557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49696 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968326AbXG3V7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 17:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     i386 alternative.c: really stop MCEs during code patching
has been added to the -mm tree.  Its filename is
     i386-alternativec-really-stop-mces-during-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 alternative.c: really stop MCEs during code patching
From: Adrian Bunk <bunk@stusta.de>

It's CONFIG_X86_MCE, not CONFIG_MCE.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/alternative.c~i386-alternativec-really-stop-mces-during-code arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~i386-alternativec-really-stop-mces-during-code
+++ a/arch/i386/kernel/alternative.c
@@ -379,7 +379,7 @@ void __init alternative_instructions(voi
 	   that might execute the to be patched code.
 	   Other CPUs are not running. */
 	stop_nmi();
-#ifdef CONFIG_MCE
+#ifdef CONFIG_X86_MCE
 	stop_mce();
 #endif
 
@@ -417,7 +417,7 @@ void __init alternative_instructions(voi
 	local_irq_restore(flags);
 
 	restart_nmi();
-#ifdef CONFIG_MCE
+#ifdef CONFIG_X86_MCE
 	restart_mce();
 #endif
 }
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
