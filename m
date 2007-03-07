From: akpm@linux-foundation.org
Subject: + cpu_idle-fix-build-break.patch added to -mm tree
Date: Tue, 06 Mar 2007 16:39:40 -0800
Message-ID: <200703070039.l270deA6014391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39783 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161048AbXCGAoJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 19:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, bunk@stusta.de, lenb@kernel.org


The patch titled
     cpu_idle: fix build break
has been added to the -mm tree.  Its filename is
     cpu_idle-fix-build-break.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpu_idle: fix build break
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

This patch fixes a build breakage with !CONFIG_HOTPLUG_CPU and
CONFIG_CPU_IDLE.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~cpu_idle-fix-build-break drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpu_idle-fix-build-break
+++ a/drivers/cpuidle/cpuidle.c
@@ -189,10 +189,6 @@ static struct sysdev_driver cpuidle_sysd
 	.remove		= cpuidle_remove_device,
 };
 
-#ifdef CONFIG_SMP
-
-#ifdef CONFIG_HOTPLUG_CPU
-
 static int cpuidle_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
@@ -224,7 +220,7 @@ static struct notifier_block __cpuinitda
     .notifier_call = cpuidle_cpu_callback,
 };
 
-#endif /* CONFIG_HOTPLUG_CPU */
+#ifdef CONFIG_SMP
 
 static void smp_callback(void *v)
 {
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
git-acpi-fix-cpuidle-borkage-2.patch
cpu_idle-fix-build-break.patch
drivers-cpuidle-make-code-static.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
