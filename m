From: akpm@linux-foundation.org
Subject: - fix-pciehp_free_irq.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:46:39 -0700
Message-ID: <200809130746.m8D7kdZX026866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146AbYIMHqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, jbarnes@virtuousgeek.org, kaneshige.kenji@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     fix pciehp_free_irq()
has been removed from the -mm tree.  Its filename was
     fix-pciehp_free_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix pciehp_free_irq()
From: Adrian Bunk <bunk@kernel.org>

This patch fixes an obvious bug (loop was never entered) caused by

commit 820943b6fc4781621dee52ba026106758a727dd3
Author:     Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
AuthorDate: Fri Jun 20 12:04:33 2008 +0900
Commit:     Jesse Barnes <jbarnes@virtuousgeek.org>
CommitDate: Wed Jun 25 15:54:30 2008 -0700

    pciehp: cleanup pcie_poll_cmd

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp_hpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/hotplug/pciehp_hpc.c~fix-pciehp_free_irq drivers/pci/hotplug/pciehp_hpc.c
--- a/drivers/pci/hotplug/pciehp_hpc.c~fix-pciehp_free_irq
+++ a/drivers/pci/hotplug/pciehp_hpc.c
@@ -258,7 +258,7 @@ static int pcie_poll_cmd(struct controll
 			return 1;
 		}
 	}
-	while (timeout > 1000) {
+	while (timeout > 0) {
 		msleep(10);
 		timeout -= 10;
 		if (!pciehp_readw(ctrl, SLOTSTATUS, &slot_status)) {
_

Patches currently in -mm which might be from bunk@kernel.org are

linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
the-overdue-eepro100-removal.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
misdn-dsp_cmxc-fix-size-checks.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
binfmt_somc-add-module_license.patch
make-probe_serial_gsc-static.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
make-ptrace_untrace-static.patch
fs-partitions-acornc-remove-dead-code.patch
parport-remove-cvs-keywords.patch
make-mm-rmapc-anon_vma_cachep-static.patch
ipc-semc-make-free_un-static.patch
make-fs-proc-proc_sysctlc-grab_header-static.patch
make-hp_wmi_notify-static.patch
make-kprobesc-kretprobe_table_lock-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch
reiser4.patch

