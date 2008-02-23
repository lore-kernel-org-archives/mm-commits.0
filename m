From: akpm@linux-foundation.org
Subject: - alsa-caiaq-fix-section-mismatch-warning.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:21:33 -0800
Message-ID: <200802232021.m1NKLXpu013344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760837AbYBWUWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:22:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, daniel@caiaq.de, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: caiaq: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     alsa-caiaq-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
samples-build-fix.patch
git-acpi.patch
git-alsa.patch
cpufreq-fix-section-mismatch-warnings.patch
drivers-base-cpu-fix-section-mismatch-in-cpucstore_online.patch
m32r-cleanup-drop-dataidt-section-in-vmlinuxlds-script.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
pci-fix-section-mismatch-warning-in-pci_scan_child_bus.patch
scsi-fix-section-mismatch-in-aic94xx.patch
solve-section-mismatch-for-free_area_init_core.patch
cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch
cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch
cpu-fix-section-mismatch-warnings-in-cpu_down.patch
cpu-fix-section-mismatch-warning-in-reference-to-register_cpu_notifier.patch
tpm-fix-section-mismatch-warning.patch
serial-silence-section-mismatch-warnings-in-8250_pci.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
