From: akpm@linux-foundation.org
Subject: + alsa-caiaq-fix-section-mismatch-warning.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:56:05 -0800
Message-ID: <200802180957.m1I9v2dq018775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242AbYBRJ6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 04:58:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, daniel@caiaq.de, perex@perex.cz, tiwai@suse.de


The patch titled
     alsa: caiaq: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     alsa-caiaq-fix-section-mismatch-warning.patch

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
Subject: alsa: caiaq: fix section mismatch warning
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x11ec01a): Section mismatch in reference from the function setup_card() to the function .devinit.text:snd_usb_caiaq_control_init()

setup_card() are only used by init_card().
init_card() are only used by snd_probe()
snd_probe() are used for the .probe parameter in usb_driver.probe

Annotate them all __devinit to fix the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/usb/caiaq/caiaq-device.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN sound/usb/caiaq/caiaq-device.c~alsa-caiaq-fix-section-mismatch-warning sound/usb/caiaq/caiaq-device.c
--- a/sound/usb/caiaq/caiaq-device.c~alsa-caiaq-fix-section-mismatch-warning
+++ a/sound/usb/caiaq/caiaq-device.c
@@ -245,7 +245,7 @@ int snd_usb_caiaq_set_auto_msg (struct s
 					  tmp, sizeof(tmp));
 }
 
-static void setup_card(struct snd_usb_caiaqdev *dev)
+static void __devinit setup_card(struct snd_usb_caiaqdev *dev)
 {
 	int ret;
 	char val[4];
@@ -359,7 +359,7 @@ static struct snd_card* create_card(stru
 	return card;
 }
 
-static int init_card(struct snd_usb_caiaqdev *dev)
+static int __devinit init_card(struct snd_usb_caiaqdev *dev)
 {
 	char *c;
 	struct usb_device *usb_dev = dev->chip.dev;
@@ -428,7 +428,7 @@ static int init_card(struct snd_usb_caia
 	return 0;
 }
 
-static int snd_probe(struct usb_interface *intf, 
+static int __devinit snd_probe(struct usb_interface *intf,
 		     const struct usb_device_id *id)
 {
 	int ret;
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
