From: akpm@linux-foundation.org
Subject: [merged] m32r-remove-redundant-tests-on-unsigned.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:44:26 -0700
Message-ID: <200909222044.n8MKiQID013622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753163AbZIVUoc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:44:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     m32r: remove redundant tests on unsigned
has been removed from the -mm tree.  Its filename was
     m32r-remove-redundant-tests-on-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m32r: remove redundant tests on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

`off' and `max_cpus' are unsigned.  When negative they are wrapped and
caught by the other test.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/kernel/ptrace.c  |    5 ++---
 arch/m32r/kernel/smpboot.c |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/m32r/kernel/ptrace.c~m32r-remove-redundant-tests-on-unsigned arch/m32r/kernel/ptrace.c
--- a/arch/m32r/kernel/ptrace.c~m32r-remove-redundant-tests-on-unsigned
+++ a/arch/m32r/kernel/ptrace.c
@@ -77,7 +77,7 @@ static int ptrace_read_user(struct task_
 	struct user * dummy = NULL;
 #endif
 
-	if ((off & 3) || (off < 0) || (off > sizeof(struct user) - 3))
+	if ((off & 3) || off > sizeof(struct user) - 3)
 		return -EIO;
 
 	off >>= 2;
@@ -139,8 +139,7 @@ static int ptrace_write_user(struct task
 	struct user * dummy = NULL;
 #endif
 
-	if ((off & 3) || off < 0 ||
-	    off > sizeof(struct user) - 3)
+	if ((off & 3) || off > sizeof(struct user) - 3)
 		return -EIO;
 
 	off >>= 2;
diff -puN arch/m32r/kernel/smpboot.c~m32r-remove-redundant-tests-on-unsigned arch/m32r/kernel/smpboot.c
--- a/arch/m32r/kernel/smpboot.c~m32r-remove-redundant-tests-on-unsigned
+++ a/arch/m32r/kernel/smpboot.c
@@ -213,7 +213,7 @@ void __init smp_prepare_cpus(unsigned in
 		if (!physid_isset(phys_id, phys_cpu_present_map))
 			continue;
 
-		if ((max_cpus >= 0) && (max_cpus <= cpucount + 1))
+		if (max_cpus <= cpucount + 1)
 			continue;
 
 		do_boot_cpu(phys_id);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch

