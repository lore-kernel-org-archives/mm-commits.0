From: akpm@linux-foundation.org
Subject: + omap-cs-should-be-positive-in-gpmc_cs_free.patch added to -mm tree
Date: Mon, 09 Nov 2009 15:12:31 -0800
Message-ID: <200911092312.nA9NCVKh002586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754521AbZKIXMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 18:12:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, rmk@arm.linux.org.uk, tony@atomide.com


The patch titled
     OMAP: cs should be positive in gpmc_cs_free()
has been added to the -mm tree.  Its filename is
     omap-cs-should-be-positive-in-gpmc_cs_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OMAP: cs should be positive in gpmc_cs_free()
From: Roel Kluin <roel.kluin@gmail.com>

The index `cs' is signed, test whether it is negative before we release
gpmc_cs_mem[cs].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/arm/mach-omap2/gpmc.c~omap-cs-should-be-positive-in-gpmc_cs_free arch/arm/mach-omap2/gpmc.c
--- a/arch/arm/mach-omap2/gpmc.c~omap-cs-should-be-positive-in-gpmc_cs_free
+++ a/arch/arm/mach-omap2/gpmc.c
@@ -378,7 +378,7 @@ EXPORT_SYMBOL(gpmc_cs_request);
 void gpmc_cs_free(int cs)
 {
 	spin_lock(&gpmc_mem_lock);
-	if (cs >= GPMC_CS_NUM || !gpmc_cs_reserved(cs)) {
+	if (cs >= GPMC_CS_NUM || cs < 0 || !gpmc_cs_reserved(cs)) {
 		printk(KERN_ERR "Trying to free non-reserved GPMC CS%d\n", cs);
 		BUG();
 		spin_unlock(&gpmc_mem_lock);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
pxa-add-missing-underscores-in-define.patch
omap-cs-should-be-positive-in-gpmc_cs_free.patch
powernow-k8-fix-test-in-get_transition_latency.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
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
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch

