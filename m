From: akpm@linux-foundation.org
Subject: - drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:32 -0700
Message-ID: <200803131859.m2DIxWQ3027961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbYCMTAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:00:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/base/cpu: fix section mismatch in cpu.c:store_online
has been removed from the -mm tree.  Its filename was
     drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/base/cpu: fix section mismatch in cpu.c:store_online
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x64609c): Section mismatch in reference from the function store_online() to the function .cpuinit.text:cpu_up()

store_online() is defined inside a HOTPLUG_CPU block so references are OK. 
Ignore references by annotating store_online() with __ref.

Note: This is needed because cpu_up() most likely should not have been
__cpuinit but all the hotplug cpu code misuses the __cpuinit annotation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/base/cpu.c~drivers-base-cpu-fix-section-mismatch-in-cpucstore_online drivers/base/cpu.c
--- a/drivers/base/cpu.c~drivers-base-cpu-fix-section-mismatch-in-cpucstore_online
+++ a/drivers/base/cpu.c
@@ -28,7 +28,7 @@ static ssize_t show_online(struct sys_de
 	return sprintf(buf, "%u\n", !!cpu_online(cpu->sysdev.id));
 }
 
-static ssize_t store_online(struct sys_device *dev, const char *buf,
+static ssize_t __ref store_online(struct sys_device *dev, const char *buf,
 			    size_t count)
 {
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
@@ -55,7 +55,7 @@ static ssize_t store_online(struct sys_d
 }
 static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
-static void __devinit register_cpu_control(struct cpu *cpu)
+static void __cpuinit register_cpu_control(struct cpu *cpu)
 {
 	sysdev_create_file(&cpu->sysdev, &attr_online);
 }
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-x86.patch
git-acpi.patch
tags-add-menuconfig-symbols-as-well.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
scsi-fix-section-mismatch-in-aic94xx.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
git-watchdog.patch
kernel-doc-set-verbose-mode-via-environment.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
tpm-fix-section-mismatch-warning.patch
kvm-provide-kvmh-for-all-architecture-fixes-headers_install.patch
serial-silence-section-mismatch-warnings-in-8250_pci.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
ipmi-remove-unused-target-and-action-in-makefile.patch

