From: akpm@linux-foundation.org
Subject: + drivers-acpi-processor_throttlingc-make-2-functions.patch added to -mm tree
Date: Mon, 25 Jun 2007 11:33:15 -0700
Message-ID: <200706251833.l5PIXFdD007985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421AbXFYSdg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 14:33:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, lenb@kernel.org


The patch titled
     drivers/acpi/processor_throttling.c: make 2 functions static
has been added to the -mm tree.  Its filename is
     drivers-acpi-processor_throttlingc-make-2-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/acpi/processor_throttling.c: make 2 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes 2 needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~drivers-acpi-processor_throttlingc-make-2-functions drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~drivers-acpi-processor_throttlingc-make-2-functions
+++ a/drivers/acpi/processor_throttling.c
@@ -410,7 +410,8 @@ static int acpi_processor_get_throttling
 	return pr->throttling.acpi_processor_get_throttling(pr);
 }
 
-int acpi_processor_set_throttling_fadt(struct acpi_processor *pr, int state)
+static int acpi_processor_set_throttling_fadt(struct acpi_processor *pr,
+					      int state)
 {
 	u32 value = 0;
 	u32 duty_mask = 0;
@@ -482,7 +483,8 @@ int acpi_processor_set_throttling_fadt(s
 	return 0;
 }
 
-int acpi_processor_set_throttling_ptc(struct acpi_processor *pr, int state)
+static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
+					     int state)
 {
 	u32 value = 0;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-acpi-oslcosi_linux-static.patch
drivers-acpi-processor_throttlingc-make-2-functions.patch
drivers-cpuidle-governors-menuc-make-a-struct-static.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
drivers-ata-sata_nvc-make-3-functions-static.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
mark-calibrate_xor_blocks-__init.patch
git-mmc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
cafe_nandc-the-olpc-laptop-is-not-available-for-100.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
mm-slabc-start_cpu_timer-should-be-__cpuinit.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
remove-sonypi_camera_command.patch
make-drivers-char-selectioncstore_utf8-static.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
remove-options-depending-on-oss_obsolete.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
