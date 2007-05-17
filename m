From: akpm@linux-foundation.org
Subject: + kconfig-powernow-k8-driver-should-depend-on-acpi-p-states-driver.patch added to -mm tree
Date: Thu, 17 May 2007 11:36:37 -0700
Message-ID: <200705171836.l4HIabf9030135@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41216 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbXEQSk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:40:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhoblitt@ifa.hawaii.edu, davej@codemonkey.org.uk, lenb@kernel.org


The patch titled
     Kconfig powernow-k8 driver should depend on ACPI P-States driver
has been added to the -mm tree.  Its filename is
     kconfig-powernow-k8-driver-should-depend-on-acpi-p-states-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Kconfig powernow-k8 driver should depend on ACPI P-States driver
From: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>

Below is a one line patch to possibly fix this bug:

http://bugs.gentoo.org/show_bug.cgi?id=178585
http://bugzilla.kernel.org/show_bug.cgi?id=8075

If the kernel is configured with:

CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_ACPI_CPUFREQ=m

Which is currently an allowed configuration, the powernow-k8 driver on
an SMP system will fail with a warning like:

powernow-k8: Found 4 Dual Core AMD Opteron(tm) Processor 285 processors (version 2.00.00)
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure
powernow-k8: MP systems not supported by PSB BIOS structure

Which mimics that failure you get when powernow/cool'n'quiet is disabled
in the BIOS.  I don't know if this config combination is valid on a
uniprocessor system so this dependency may need to be enforced only if
SMP in enabled.  The other powernow-* drivers likely have the same
requirements as -k8 but I am unable to test them.

Signed-off-by: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/i386/kernel/cpu/cpufreq/Kconfig~kconfig-powernow-k8-driver-should-depend-on-acpi-p-states-driver arch/i386/kernel/cpu/cpufreq/Kconfig
--- a/arch/i386/kernel/cpu/cpufreq/Kconfig~kconfig-powernow-k8-driver-should-depend-on-acpi-p-states-driver
+++ a/arch/i386/kernel/cpu/cpufreq/Kconfig
@@ -82,6 +82,7 @@ config X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
 	select CPU_FREQ_TABLE
 	depends on EXPERIMENTAL
+	depends on X86_ACPI_CPUFREQ
 	help
 	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.
 
_

Patches currently in -mm which might be from jhoblitt@ifa.hawaii.edu are

kconfig-powernow-k8-driver-should-depend-on-acpi-p-states-driver.patch
