From: akpm@linux-foundation.org
Subject: - cpufreq-fix-section-mismatch-warnings.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:21:32 -0800
Message-ID: <200803062221.m26MLWx0020726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbYCFWWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:22:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: fix section mismatch warnings
has been removed from the -mm tree.  Its filename was
     cpufreq-fix-section-mismatch-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: fix section mismatch warnings
From: Sam Ravnborg <sam@ravnborg.org>

Fix the following warnings:
WARNING: vmlinux.o(.text+0xfe6711): Section mismatch in reference from the function cpufreq_unregister_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
WARNING: vmlinux.o(.text+0xfe68af): Section mismatch in reference from the function cpufreq_register_driver() to the variable .cpuinit.data:cpufreq_cpu_notifier
WARNING: vmlinux.o(.exit.text+0xc4fa): Section mismatch in reference from the function cpufreq_stats_exit() to the variable .cpuinit.data:cpufreq_stat_cpu_notifier

The warnings were casued by references to unregister_hotcpu_notifier() from
normal functions or exit functions.  This is flagged by modpost as a potential
error because it does not know that for the non HOTPLUG_CPU scenario the
unregister_hotcpu_notifier() is a nop.  Silence the warning by replacing the
__initdata annotation with a __refdata annotation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c       |    2 +-
 drivers/cpufreq/cpufreq_stats.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-fix-section-mismatch-warnings drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-fix-section-mismatch-warnings
+++ a/drivers/cpufreq/cpufreq.c
@@ -1778,7 +1778,7 @@ static int __cpuinit cpufreq_cpu_callbac
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cpufreq_cpu_notifier =
+static struct notifier_block __refdata cpufreq_cpu_notifier =
 {
     .notifier_call = cpufreq_cpu_callback,
 };
diff -puN drivers/cpufreq/cpufreq_stats.c~cpufreq-fix-section-mismatch-warnings drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~cpufreq-fix-section-mismatch-warnings
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -323,7 +323,7 @@ static int __cpuinit cpufreq_stat_cpu_ca
 	return NOTIFY_OK;
 }
 
-static struct notifier_block cpufreq_stat_cpu_notifier __cpuinitdata =
+static struct notifier_block cpufreq_stat_cpu_notifier __refdata =
 {
 	.notifier_call = cpufreq_stat_cpu_callback,
 };
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-x86.patch
git-acpi.patch
git-alsa.patch
drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch
tags-add-menuconfig-symbols-as-well.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
scsi-fix-section-mismatch-in-aic94xx.patch
rcu-move-preempt_rcu-config-option-back-under-preempt.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
tpm-fix-section-mismatch-warning.patch
serial-silence-section-mismatch-warnings-in-8250_pci.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
ipmi-remove-unused-target-and-action-in-makefile.patch

