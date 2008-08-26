From: akpm@linux-foundation.org
Subject: - clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:40 -0700
Message-ID: <200808261845.m7QIjehB021418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759899AbYHZTBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 15:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: check range
has been removed from the -mm tree.  Its filename was
     clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: check range
From: David Howells <dhowells@redhat.com>

Check that the value being passed to parse_pmtmr() does not exceed the
limits of pmtmr_ioport.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/clocksource/acpi_pm.c~clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range
+++ a/drivers/clocksource/acpi_pm.c
@@ -226,9 +226,12 @@ static int __init parse_pmtmr(char *arg)
 
 	if (strict_strtoul(arg, 16, &base))
 		return -EINVAL;
-
+#ifdef CONFIG_X86_64
+	if (base > UINT_MAX)
+		return -ERANGE;
+#endif
 	printk(KERN_INFO "PMTMR IOPort override: 0x%04x -> 0x%04lx\n",
-	       (unsigned int)pmtmr_ioport, base);
+	       pmtmr_ioport, base);
 	pmtmr_ioport = base;
 
 	return 1;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
cifs-fix-range-check.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
mn10300-use-bcd2bin-bin2bcd.patch
mutex-subsystem-synchro-test-module.patch

