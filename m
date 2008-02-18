From: akpm@linux-foundation.org
Subject: + cpu-fix-section-mismatch-warnings-in-cpu_down.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:10:33 -0800
Message-ID: <200802181011.m1IABU0r019463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40156 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162AbYBRKMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:12:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, ego@in.ibm.com


The patch titled
     cpu: fix section mismatch warnings in *cpu_down
has been added to the -mm tree.  Its filename is
     cpu-fix-section-mismatch-warnings-in-cpu_down.patch

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
Subject: cpu: fix section mismatch warnings in *cpu_down
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.text+0x75c8d): Section mismatch in reference from the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75d2a): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75d4d): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75de4): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75e33): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain

cpu_down is only used from code surrounded by HOTPLUG_CPU so any references to
__cpuinit is OK.

Add a few __ref to tech modpost to ignore the references.

This is just papering over the fact that the cpu hotplug code is fragile with
respect to use of HOTPLUG_CPU and in many cases rely on __cpuinit to get rid
of code when HOTPLUG_CPU is not enabled.  For now this is the least invasive
change.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/cpu.c~cpu-fix-section-mismatch-warnings-in-cpu_down kernel/cpu.c
--- a/kernel/cpu.c~cpu-fix-section-mismatch-warnings-in-cpu_down
+++ a/kernel/cpu.c
@@ -180,7 +180,7 @@ struct take_cpu_down_param {
 };
 
 /* Take this CPU down. */
-static int take_cpu_down(void *_param)
+static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
 	int err;
@@ -199,7 +199,7 @@ static int take_cpu_down(void *_param)
 }
 
 /* Requires cpu_add_remove_lock to be held */
-static int _cpu_down(unsigned int cpu, int tasks_frozen)
+static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
 	struct task_struct *p;
@@ -274,7 +274,7 @@ out_release:
 	return err;
 }
 
-int cpu_down(unsigned int cpu)
+int __ref cpu_down(unsigned int cpu)
 {
 	int err = 0;
 
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
