From: akpm@linux-foundation.org
Subject: + drivers-acpi-sbsc-remove-dead-code.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:43:51 -0700
Message-ID: <200706261943.l5QJhp9i000852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757286AbXFZToG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, len.brown@intel.com, vladimir.p.lebedev@intel.com


The patch titled
     drivers/acpi/sbs.c: remove dead code
has been added to the -mm tree.  Its filename is
     drivers-acpi-sbsc-remove-dead-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/acpi/sbs.c: remove dead code
From: Adrian Bunk <bunk@stusta.de>

Remove dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/acpi/sbs.c~drivers-acpi-sbsc-remove-dead-code drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~drivers-acpi-sbsc-remove-dead-code
+++ a/drivers/acpi/sbs.c
@@ -1409,7 +1409,7 @@ static int acpi_sbs_update_run(struct ac
 	char dir_name[32];
 	int do_battery_init = 0, do_ac_init = 0;
 	int old_remaining_capacity = 0;
-	int update_ac = 1, update_battery = 1;
+	int update_battery = 1;
 	int up_tm = update_time;
 
 	if (sbs_zombie(sbs)) {
@@ -1429,10 +1429,6 @@ static int acpi_sbs_update_run(struct ac
 
 	sbs->run_cnt++;
 
-	if (!update_ac && !update_battery) {
-		goto end;
-	}
-
 	old_ac_present = sbs->ac.ac_present;
 
 	result = acpi_ac_get_present(sbs);
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-acpi-oslcosi_linux-static.patch
drivers-acpi-processor_throttlingc-make-2-functions.patch
drivers-cpuidle-governors-menuc-make-a-struct-static.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
git-kvm.patch
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
remove-the-dead-cyberstormiii_scsi-option.patch
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
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
kernel-sys_nic-should-include-linux-syscallsh.patch
fs-namespacec-should-include-internalh.patch
proper-prototype-for-proc_nr_files.patch
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
