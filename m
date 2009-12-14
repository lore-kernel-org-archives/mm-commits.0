From: akpm@linux-foundation.org
Subject: [merged] omap-return-ptr_err-rather-than-is_err.patch removed from -mm tree
Date: Mon, 14 Dec 2009 13:23:29 -0800
Message-ID: <200912142123.nBELNTb9016764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbZLNVXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 16:23:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, khilman@deeprootsystems.com, linux@arm.linux.org.uk, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     omap: return PTR_ERR rather than IS_ERR
has been removed from the -mm tree.  Its filename was
     omap-return-ptr_err-rather-than-is_err.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap: return PTR_ERR rather than IS_ERR
From: Roel Kluin <roel.kluin@gmail.com>

IS_ERR returns only 1 or 0, and the functions return a negative error in
other cases anyways.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/powerdomain.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/arm/mach-omap2/powerdomain.c~omap-return-ptr_err-rather-than-is_err arch/arm/mach-omap2/powerdomain.c
--- a/arch/arm/mach-omap2/powerdomain.c~omap-return-ptr_err-rather-than-is_err
+++ a/arch/arm/mach-omap2/powerdomain.c
@@ -480,7 +480,7 @@ int pwrdm_add_wkdep(struct powerdomain *
 	if (IS_ERR(p)) {
 		pr_debug("powerdomain: hardware cannot set/clear wake up of "
 			 "%s when %s wakes up\n", pwrdm1->name, pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	pr_debug("powerdomain: hardware will wake up %s when %s wakes up\n",
@@ -513,7 +513,7 @@ int pwrdm_del_wkdep(struct powerdomain *
 	if (IS_ERR(p)) {
 		pr_debug("powerdomain: hardware cannot set/clear wake up of "
 			 "%s when %s wakes up\n", pwrdm1->name, pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	pr_debug("powerdomain: hardware will no longer wake up %s after %s "
@@ -550,7 +550,7 @@ int pwrdm_read_wkdep(struct powerdomain 
 	if (IS_ERR(p)) {
 		pr_debug("powerdomain: hardware cannot set/clear wake up of "
 			 "%s when %s wakes up\n", pwrdm1->name, pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	return prm_read_mod_bits_shift(pwrdm1->prcm_offs, PM_WKDEP,
@@ -584,7 +584,7 @@ int pwrdm_add_sleepdep(struct powerdomai
 		pr_debug("powerdomain: hardware cannot set/clear sleep "
 			 "dependency affecting %s from %s\n", pwrdm1->name,
 			 pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	pr_debug("powerdomain: will prevent %s from sleeping if %s is active\n",
@@ -623,7 +623,7 @@ int pwrdm_del_sleepdep(struct powerdomai
 		pr_debug("powerdomain: hardware cannot set/clear sleep "
 			 "dependency affecting %s from %s\n", pwrdm1->name,
 			 pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	pr_debug("powerdomain: will no longer prevent %s from sleeping if "
@@ -666,7 +666,7 @@ int pwrdm_read_sleepdep(struct powerdoma
 		pr_debug("powerdomain: hardware cannot set/clear sleep "
 			 "dependency affecting %s from %s\n", pwrdm1->name,
 			 pwrdm2->name);
-		return IS_ERR(p);
+		return PTR_ERR(p);
 	}
 
 	return prm_read_mod_bits_shift(pwrdm1->prcm_offs, OMAP3430_CM_SLEEPDEP,
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-85xx-wrong-variable-returned-on-error.patch
hidp-ptr_err-return-of-wrong-pointer-in-hidp_setup_hid.patch
imx-bit-confusion.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

