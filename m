From: akpm@linux-foundation.org
Subject: [merged] thermal-cpufreq-fix-build-when-cpu_freq_table-isnt-configured.patch removed from -mm tree
Date: Tue, 16 Oct 2012 14:32:44 -0700
Message-ID: <20121016213245.D7DF95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57188 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2JPVct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Oct 2012 17:32:49 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so418016bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 16 Oct 2012 14:32:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, amit.kachhap@linaro.org, len.brown@intel.com, rui.zhang@intel.com, viresh.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal, cpufreq: Fix build when CPU_FREQ_TABLE isn't configured
has been removed from the -mm tree.  Its filename was
     thermal-cpufreq-fix-build-when-cpu_freq_table-isnt-configured.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: thermal, cpufreq: Fix build when CPU_FREQ_TABLE isn't configured

Commit 02361418 ("thermal: add generic cpufreq cooling implementation")
requires cpufreq_frequency_get_table(), but that function is only defined
for CONFIG_CPU_FREQ_TABLE resulting in the following build error:

drivers/built-in.o: In function `cpufreq_get_max_state':
drivers/thermal/cpu_cooling.c:259: undefined reference to `cpufreq_frequency_get_table'
drivers/built-in.o: In function `get_cpu_frequency':
drivers/thermal/cpu_cooling.c:129: undefined reference to `cpufreq_frequency_get_table'

Fix it by selecting CONFIG_CPU_FREQ_TABLE for such a configuration.

It turns out CONFIG_EXYNOS_THERMAL also needs CONFIG_CPU_FREQ_TABLE, so
select it there as well.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/thermal/Kconfig~thermal-cpufreq-fix-build-when-cpu_freq_table-isnt-configured drivers/thermal/Kconfig
--- a/drivers/thermal/Kconfig~thermal-cpufreq-fix-build-when-cpu_freq_table-isnt-configured
+++ a/drivers/thermal/Kconfig
@@ -22,6 +22,7 @@ config THERMAL_HWMON
 config CPU_THERMAL
 	bool "generic cpu cooling support"
 	depends on THERMAL && CPU_FREQ
+	select CPU_FREQ_TABLE
 	help
 	  This implements the generic cpu cooling mechanism through frequency
 	  reduction, cpu hotplug and any other ways of reducing temperature. An
@@ -50,6 +51,7 @@ config RCAR_THERMAL
 config EXYNOS_THERMAL
 	tristate "Temperature sensor on Samsung EXYNOS"
 	depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5) && THERMAL
+	select CPU_FREQ_TABLE
 	help
 	  If you say yes here you get support for TMU (Thermal Managment
 	  Unit) on SAMSUNG EXYNOS series of SoC.
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
memory-hotplug-suppress-device-memoryx-does-not-have-a-release-function-warning.patch
memory-hotplug-suppress-device-nodex-does-not-have-a-release-function-warning.patch
mm-memcg-make-mem_cgroup_out_of_memory-static.patch

