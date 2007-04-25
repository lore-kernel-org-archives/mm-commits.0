From: akpm@linux-foundation.org
Subject: - cleanup-cpufreq-kconfig-options.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:21 -0700
Message-ID: <200704252039.l3PKdLCv012300@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993133AbXDYUjz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     clean up cpufreq kconfig options
has been removed from the -mm tree.  Its filename was
     cleanup-cpufreq-kconfig-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clean up cpufreq kconfig options
From: Mike Frysinger <vapier@gentoo.org>

Adds proper lines to help output of kconfig so people can find the module
names.  Also fixed some broken leading spaces versus tabs.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/cpufreq/Kconfig |   19 ++++++--
 drivers/cpufreq/Kconfig            |   61 +++++++++++++++++++--------
 2 files changed, 58 insertions(+), 22 deletions(-)

diff -puN arch/x86_64/kernel/cpufreq/Kconfig~cleanup-cpufreq-kconfig-options arch/x86_64/kernel/cpufreq/Kconfig
--- a/arch/x86_64/kernel/cpufreq/Kconfig~cleanup-cpufreq-kconfig-options
+++ a/arch/x86_64/kernel/cpufreq/Kconfig
@@ -16,6 +16,9 @@ config X86_POWERNOW_K8
 	help
 	  This adds the CPUFreq driver for mobile AMD Opteron/Athlon64 processors.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called powernow-k8.
+
 	  For details, take a look at <file:Documentation/cpu-freq/>. 
 
 	  If in doubt, say N.
@@ -38,6 +41,9 @@ config X86_SPEEDSTEP_CENTRINO
 	  mobile CPUs.  This means Intel Pentium M (Centrino) CPUs
 	  or 64bit enabled Intel Xeons.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called speedstep-centrino.
+
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
 	  If in doubt, say N.
@@ -55,6 +61,9 @@ config X86_ACPI_CPUFREQ
 	  Processor Performance States.
 	  This driver also supports Intel Enhanced Speedstep.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called acpi-cpufreq.
+
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
 	  If in doubt, say N.
@@ -62,7 +71,7 @@ config X86_ACPI_CPUFREQ
 comment "shared options"
 
 config X86_ACPI_CPUFREQ_PROC_INTF
-        bool "/proc/acpi/processor/../performance interface (deprecated)"
+	bool "/proc/acpi/processor/../performance interface (deprecated)"
 	depends on PROC_FS
 	depends on X86_ACPI_CPUFREQ || X86_SPEEDSTEP_CENTRINO_ACPI || X86_POWERNOW_K8_ACPI
 	help
@@ -86,16 +95,18 @@ config X86_P4_CLOCKMOD
 	  slowdowns and noticeable latencies.  Normally Speedstep should be used
 	  instead.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called p4-clockmod.
+
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
 	  Unless you are absolutely sure say N.
 
 
 config X86_SPEEDSTEP_LIB
-        tristate
-        default X86_P4_CLOCKMOD
+	tristate
+	default X86_P4_CLOCKMOD
 
 endif
 
 endmenu
-
diff -puN drivers/cpufreq/Kconfig~cleanup-cpufreq-kconfig-options drivers/cpufreq/Kconfig
--- a/drivers/cpufreq/Kconfig~cleanup-cpufreq-kconfig-options
+++ a/drivers/cpufreq/Kconfig
@@ -9,6 +9,9 @@ config CPU_FREQ
 	  clock speed, you need to either enable a dynamic cpufreq governor
 	  (see below) after boot, or use a userspace tool.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpufreq.
+
 	  For details, take a look at <file:Documentation/cpu-freq>.
 
 	  If in doubt, say N.
@@ -16,7 +19,7 @@ config CPU_FREQ
 if CPU_FREQ
 
 config CPU_FREQ_TABLE
-       tristate
+	tristate
 
 config CPU_FREQ_DEBUG
 	bool "Enable CPUfreq debugging"
@@ -32,19 +35,26 @@ config CPU_FREQ_DEBUG
 	       4 to activate CPUfreq governor debugging
 
 config CPU_FREQ_STAT
-       tristate "CPU frequency translation statistics"
-       select CPU_FREQ_TABLE
-       default y
-       help
-         This driver exports CPU frequency statistics information through sysfs
-         file system
+	tristate "CPU frequency translation statistics"
+	select CPU_FREQ_TABLE
+	default y
+	help
+	  This driver exports CPU frequency statistics information through sysfs
+	  file system.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpufreq_stats.
+
+	  If in doubt, say N.
 
 config CPU_FREQ_STAT_DETAILS
-       bool "CPU frequency translation statistics details"
-       depends on CPU_FREQ_STAT
-       help
-         This will show detail CPU frequency translation table in sysfs file
-         system
+	bool "CPU frequency translation statistics details"
+	depends on CPU_FREQ_STAT
+	help
+	  This will show detail CPU frequency translation table in sysfs file
+	  system.
+
+	  If in doubt, say N.
 
 # Note that it is not currently possible to set the other governors (such as ondemand)
 # as the default, since if they fail to initialise, cpufreq will be
@@ -78,29 +88,38 @@ config CPU_FREQ_DEFAULT_GOV_USERSPACE
 endchoice
 
 config CPU_FREQ_GOV_PERFORMANCE
-       tristate "'performance' governor"
-       help
+	tristate "'performance' governor"
+	help
 	  This cpufreq governor sets the frequency statically to the
 	  highest available CPU frequency.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpufreq_performance.
+
 	  If in doubt, say Y.
 
 config CPU_FREQ_GOV_POWERSAVE
-       tristate "'powersave' governor"
-       help
+	tristate "'powersave' governor"
+	help
 	  This cpufreq governor sets the frequency statically to the
 	  lowest available CPU frequency.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpufreq_powersave.
+
 	  If in doubt, say Y.
 
 config CPU_FREQ_GOV_USERSPACE
-       tristate "'userspace' governor for userspace frequency scaling"
-       help
+	tristate "'userspace' governor for userspace frequency scaling"
+	help
 	  Enable this cpufreq governor when you either want to set the
 	  CPU frequency manually or when an userspace program shall
 	  be able to set the CPU dynamically, like on LART 
 	  <http://www.lartmaker.nl/>.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpufreq_userspace.
+
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
 	  If in doubt, say Y.
@@ -116,6 +135,9 @@ config CPU_FREQ_GOV_ONDEMAND
 	  do fast frequency switching (i.e, very low latency frequency
 	  transitions). 
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpufreq_ondemand.
+
 	  For details, take a look at linux/Documentation/cpu-freq.
 
 	  If in doubt, say N.
@@ -136,6 +158,9 @@ config CPU_FREQ_GOV_CONSERVATIVE
 	  step-by-step latency issues between the minimum and maximum frequency
 	  transitions in the CPU) you will probably want to use this governor.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called cpufreq_conservative.
+
 	  For details, take a look at linux/Documentation/cpu-freq.
 
 	  If in doubt, say N.
_

Patches currently in -mm which might be from vapier@gentoo.org are

git-cpufreq.patch
git-kbuild.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
