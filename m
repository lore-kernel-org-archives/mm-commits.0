From: akpm@linux-foundation.org
Subject: - kconfig-powernow-k8-driver-should-depend-on-acpi-p-states-driver.patch removed from -mm tree
Date: Thu, 17 May 2007 15:03:36 -0700
Message-ID: <200705172203.l4HM3aYi001553@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbXEQWHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 18:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhoblitt@ifa.hawaii.edu, davej@codemonkey.org.uk, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Kconfig powernow-k8 driver should depend on ACPI P-States driver
has been removed from the -mm tree.  Its filename was
     kconfig-powernow-k8-driver-should-depend-on-acpi-p-states-driver.patch

This patch was dropped because an updated version will be merged

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
