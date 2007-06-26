From: akpm@linux-foundation.org
Subject: - drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch removed from -mm tree
Date: Mon, 25 Jun 2007 18:58:53 -0700
Message-ID: <200706260158.l5Q1wruc016044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbXFZB7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 21:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, htejun@gmail.com, jeff@garzik.org, kluo@nvidia.com, pchen@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     drivers/ata/sata_nv.c: make 3 functions static
has been removed from the -mm tree.  Its filename was
     drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: drivers/ata/sata_nv.c: make 3 functions static
From: Adrian Bunk <bunk@stusta.de>

This patch makes 3 needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Kuan Luo <kluo@nvidia.com>
Cc: Peer Chen <pchen@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix
+++ a/drivers/ata/sata_nv.c
@@ -314,7 +314,7 @@ static int nv_ncqintr_sdbfis(struct ata_
 static int nv_ncqintr_dmasetupfis(struct ata_port *ap);
 static void ncq_clear_singlefis(struct ata_port *ap, u32 val);
 static u32 ncq_ownfisintr_value (struct ata_port *ap);
-void ncq_hotplug(struct ata_port *ap, u32 fis);
+static void ncq_hotplug(struct ata_port *ap, u32 fis);
 static irqreturn_t nv_mcp55_interrupt(int irq, void *dev_instance);
 static int ncq_interrupt(struct ata_port *ap, u32 fis);
 static int nv_scsi_queuecmd(struct scsi_cmnd *cmd,
@@ -1931,7 +1931,7 @@ static void ncq_stop(struct ata_port *ap
 	ncq_clear(ap);
 }
 
-int nv_std_prereset(struct ata_port *ap, unsigned long deadline)
+static int nv_std_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	struct ata_eh_context *ehc = &ap->eh_context;
 
@@ -2265,7 +2265,7 @@ back_out:
 	return 0;
 }
 
-u32 ncq_valid_dhfisflag(struct nv_port_priv *pp)
+static u32 ncq_valid_dhfisflag(struct nv_port_priv *pp)
 {
 	u32 valid = (pp->dhfis_flags == pp->qc_active);
 
@@ -2332,7 +2332,7 @@ static void fis_dump(struct ata_port *ap
 #endif
 
 
-void ncq_hotplug(struct ata_port *ap, u32 fis)
+static void ncq_hotplug(struct ata_port *ap, u32 fis)
 {
 	u32 serror;
 	struct ata_eh_info *ehi = &ap->eh_info;
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
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
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
kernel-utf-8-handling-fix.patch
remove-sonypi_camera_command.patch
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
