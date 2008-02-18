From: akpm@linux-foundation.org
Subject: + cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:10:22 -0800
Message-ID: <200802181011.m1IABJs2019457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbYBRKMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:12:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, ego@in.ibm.com


The patch titled
     cpu: fix section mismatch warnings in hotcpu_register
has been added to the -mm tree.  Its filename is
     cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch

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
Subject: cpu: fix section mismatch warnings in hotcpu_register
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.data+0x5020): Section mismatch in reference from the variable cpu_vsyscall_notifier_nb.12876 to the function .cpuinit.text:cpu_vsyscall_notifier()
WARNING: vmlinux.o(.data+0x9ce0): Section mismatch in reference from the variable profile_cpu_callback_nb.17654 to the function .devinit.text:profile_cpu_callback()
WARNING: vmlinux.o(.data+0xd380): Section mismatch in reference from the variable workqueue_cpu_callback_nb.15004 to the function .devinit.text:workqueue_cpu_callback()
WARNING: vmlinux.o(.data+0x11d00): Section mismatch in reference from the variable relay_hotcpu_callback_nb.19626 to the function .cpuinit.text:relay_hotcpu_callback()
WARNING: vmlinux.o(.data+0x12970): Section mismatch in reference from the variable cpu_callback_nb.24694 to the function .devinit.text:cpu_callback()
WARNING: vmlinux.o(.data+0x3fee0): Section mismatch in reference from the variable percpu_counter_hotcpu_callback_nb.10903 to the function .cpuinit.text:percpu_counter_hotcpu_callback()
WARNING: vmlinux.o(.data+0x74ce0): Section mismatch in reference from the variable topology_cpu_callback_nb.12506 to the function .cpuinit.text:topology_cpu_callback()

Functions used as argument are by definition only used in HOTPLUG_CPU
situations so thay are annotated __cpuinit.  Annotate the static variable used
by hotcpu_register with __cpuinitdata to match this definition.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/cpu.h~cpu-fix-section-mismatch-warnings-in-hotcpu_register include/linux/cpu.h
--- a/include/linux/cpu.h~cpu-fix-section-mismatch-warnings-in-hotcpu_register
+++ a/include/linux/cpu.h
@@ -109,7 +109,7 @@ static inline void cpuhotplug_mutex_unlo
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb =			\
+	static struct notifier_block fn##_nb __cpuinitdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
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
