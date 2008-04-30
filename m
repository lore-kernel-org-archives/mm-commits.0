From: akpm@linux-foundation.org
Subject: - allow-use-of-the-powersave-governor-as-the-default-one.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:59 -0700
Message-ID: <200804300550.m3U5oxBH030173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757960AbYD3FvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alessandro.guido@gmail.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: allow use of the powersave governor as the default one
has been removed from the -mm tree.  Its filename was
     allow-use-of-the-powersave-governor-as-the-default-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: allow use of the powersave governor as the default one
From: Alessandro Guido <alessandro.guido@gmail.com>

Allow use of the powersave cpufreq governor as the default one for EMBEDDED
configs.

Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/Kconfig             |    9 +++++++++
 drivers/cpufreq/cpufreq_powersave.c |    8 ++++++--
 include/linux/cpufreq.h             |    3 +++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff -puN drivers/cpufreq/Kconfig~allow-use-of-the-powersave-governor-as-the-default-one drivers/cpufreq/Kconfig
--- a/drivers/cpufreq/Kconfig~allow-use-of-the-powersave-governor-as-the-default-one
+++ a/drivers/cpufreq/Kconfig
@@ -69,6 +69,15 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 	  the frequency statically to the highest frequency supported by
 	  the CPU.
 
+config CPU_FREQ_DEFAULT_GOV_POWERSAVE
+	bool "powersave"
+	depends on EMBEDDED
+	select CPU_FREQ_GOV_POWERSAVE
+	help
+	  Use the CPUFreq governor 'powersave' as default. This sets
+	  the frequency statically to the lowest frequency supported by
+	  the CPU.
+
 config CPU_FREQ_DEFAULT_GOV_USERSPACE
 	bool "userspace"
 	select CPU_FREQ_GOV_USERSPACE
diff -puN drivers/cpufreq/cpufreq_powersave.c~allow-use-of-the-powersave-governor-as-the-default-one drivers/cpufreq/cpufreq_powersave.c
--- a/drivers/cpufreq/cpufreq_powersave.c~allow-use-of-the-powersave-governor-as-the-default-one
+++ a/drivers/cpufreq/cpufreq_powersave.c
@@ -35,12 +35,12 @@ static int cpufreq_governor_powersave(st
 	return 0;
 }
 
-static struct cpufreq_governor cpufreq_gov_powersave = {
+struct cpufreq_governor cpufreq_gov_powersave = {
 	.name		= "powersave",
 	.governor	= cpufreq_governor_powersave,
 	.owner		= THIS_MODULE,
 };
-
+EXPORT_SYMBOL(cpufreq_gov_powersave);
 
 static int __init cpufreq_gov_powersave_init(void)
 {
@@ -58,5 +58,9 @@ MODULE_AUTHOR("Dominik Brodowski <linux@
 MODULE_DESCRIPTION("CPUfreq policy governor 'powersave'");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE
+fs_initcall(cpufreq_gov_powersave_init);
+#else
 module_init(cpufreq_gov_powersave_init);
+#endif
 module_exit(cpufreq_gov_powersave_exit);
diff -puN include/linux/cpufreq.h~allow-use-of-the-powersave-governor-as-the-default-one include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~allow-use-of-the-powersave-governor-as-the-default-one
+++ a/include/linux/cpufreq.h
@@ -308,6 +308,9 @@ extern struct cpufreq_governor cpufreq_g
 #endif
 #ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 #define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_performance)
+#elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE)
+extern struct cpufreq_governor cpufreq_gov_powersave;
+#define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_powersave)
 #elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE)
 extern struct cpufreq_governor cpufreq_gov_userspace;
 #define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_userspace)
_

Patches currently in -mm which might be from alessandro.guido@gmail.com are

origin.patch

