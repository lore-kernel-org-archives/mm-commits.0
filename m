From: akpm@linux-foundation.org
Subject: + cpufreq-fix-section-mismatch-warnings.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:56:50 -0800
Message-ID: <200802180957.m1I9vmJR018793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52697 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148AbYBRJ6b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 04:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, davej@codemonkey.org.uk


The patch titled
     cpufreq: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     cpufreq-fix-section-mismatch-warnings.patch

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

samples-build-fix.patch
git-acpi.patch
acpi-fix-section-mismatch-in-acpi_pci_root_add.patch
acpi-fix-section-mismatch-in-processor_corecacpi_processor_hotplug_notify.patch
acer-wmi-fix-section-mismatch-warnings.patch
alsa-caiaq-fix-section-mismatch-warning.patch
cpufreq-fix-section-mismatch-warnings.patch
drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch
git-kbuild.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
serial-silence-section-mismatch-warnings-in-8250_pci.patch
pci-fix-section-mismatch-warning-in-pci_scan_child_bus.patch
scsi-fix-section-mismatch-in-aic94xx.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
tpm-fix-section-mismatch-warning.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
