From: akpm@linux-foundation.org
Subject: + clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch added to -mm tree
Date: Fri, 11 Jul 2008 18:05:54 -0700
Message-ID: <200807120105.m6C15scT013707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbYGLBMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 21:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     clocksource: fix a print format error in the ACPI PM clocksource driver and check range
has been added to the -mm tree.  Its filename is
     clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: fix a print format error in the ACPI PM clocksource driver and check range
From: David Howells <dhowells@redhat.com>

Fix a print format error in the ACPI PM clocksource driver:

drivers/clocksource/acpi_pm.c:231: warning: format '%04lx' expects type 'long unsigned int', but argument 2 has type 'u32'

This was introduced in patch 6b148507d3d042a3c11f4c3f6c0f649c6a89220d.

And check that the value being passed to parse_pmtmr() does not exceed the
limits of pmtmr_ioport.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/clocksource/acpi_pm.c~clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range
+++ a/drivers/clocksource/acpi_pm.c
@@ -227,7 +227,12 @@ static int __init parse_pmtmr(char *arg)
 	if (strict_strtoul(arg, 16, &base))
 		return -EINVAL;
 
-	printk(KERN_INFO "PMTMR IOPort override: 0x%04lx -> 0x%04lx\n",
+#ifdef CONFIG_X86_64
+	if (base > UINT_MAX)
+		return -ERANGE;
+#endif
+
+	printk(KERN_INFO "PMTMR IOPort override: 0x%04x -> 0x%04lx\n",
 	       pmtmr_ioport, base);
 	pmtmr_ioport = base;
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

