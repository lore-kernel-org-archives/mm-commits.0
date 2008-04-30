From: akpm@linux-foundation.org
Subject: - cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:12 -0700
Message-ID: <200804300539.m3U5dCZs028817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbYD3Fjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpu: fix section mismatch warning in reference to register_cpu_notifier
has been removed from the -mm tree.  Its filename was
     cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: fix section mismatch warning in reference to register_cpu_notifier
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.text+0xc60): Section mismatch in reference from the function kvm_init() to the function .cpuinit.text:register_cpu_notifier()
WARNING: vmlinux.o(.text+0x33869a): Section mismatch in reference from the function xfs_icsb_init_counters() to the function .cpuinit.text:register_cpu_notifier()
WARNING: vmlinux.o(.text+0x5556a1): Section mismatch in reference from the function acpi_processor_install_hotplug_notify() to the function .cpuinit.text:register_cpu_notifier()
WARNING: vmlinux.o(.text+0xfe6b28): Section mismatch in reference from the function cpufreq_register_driver() to the function .cpuinit.text:register_cpu_notifier()

register_cpu_notifier() are only really defined when HOTPLUG_CPU is enabled. 
So references to the function are OK.

Annotate it with __ref so we do not get warnings from callers and do not get
warnings for the functions/data used by register_cpu_notifier().

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpu.c~cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier kernel/cpu.c
--- a/kernel/cpu.c~cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier
+++ a/kernel/cpu.c
@@ -136,7 +136,7 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 /* Need to know about CPUs going up/down? */
-int __cpuinit register_cpu_notifier(struct notifier_block *nb)
+int __ref register_cpu_notifier(struct notifier_block *nb)
 {
 	int ret;
 	cpu_maps_update_begin();
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-x86.patch
git-m32r.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
git-pci.patch
git-s390.patch
git-sh.patch
scsi-fix-section-mismatch-in-aic94xx.patch
git-watchdog.patch
documentation-build-source-files-in-documentation-sub-dir.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch

