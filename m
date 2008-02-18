From: akpm@linux-foundation.org
Subject: + drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:57:11 -0800
Message-ID: <200802180958.m1I9w82A018805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbYBRJ6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 04:58:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, gregkh@suse.de


The patch titled
     drivers/base/cpu: fix section mismatch in cpu.c:store_online
has been added to the -mm tree.  Its filename is
     drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch

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
