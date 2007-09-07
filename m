From: akpm@linux-foundation.org
Subject: - alsa-cs5535audio-update-pci-device-handling-in-suspend-resume.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:42:10 -0700
Message-ID: <200709070042.l870gAvm016020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964848AbXIGAmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, jayakumar.alsa@gmail.com, jordan.crouse@amd.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     ALSA: cs5535audio: update PCI device handling in suspend/resume
has been removed from the -mm tree.  Its filename was
     alsa-cs5535audio-update-pci-device-handling-in-suspend-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALSA: cs5535audio: update PCI device handling in suspend/resume
From: Andres Salomon <dilinger@queued.net>

Save the PCI state before disabling the device, and add some error checking.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Acked-by: Jaya Kumar <jayakumar.alsa@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/cs5535audio/cs5535audio_pm.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff -puN sound/pci/cs5535audio/cs5535audio_pm.c~alsa-cs5535audio-update-pci-device-handling-in-suspend-resume sound/pci/cs5535audio/cs5535audio_pm.c
--- a/sound/pci/cs5535audio/cs5535audio_pm.c~alsa-cs5535audio-update-pci-device-handling-in-suspend-resume
+++ a/sound/pci/cs5535audio/cs5535audio_pm.c
@@ -74,8 +74,11 @@ int snd_cs5535audio_suspend(struct pci_d
 	/* save important regs, then disable aclink in hw */
 	snd_cs5535audio_stop_hardware(cs5535au);
 
+	if (pci_save_state(pci)) {
+		printk(KERN_ERR "cs5535audio: pci_save_state failed!\n");
+		return -EIO;
+	}
 	pci_disable_device(pci);
-	pci_save_state(pci);
 	pci_set_power_state(pci, pci_choose_state(pci, state));
 	return 0;
 }
@@ -89,7 +92,12 @@ int snd_cs5535audio_resume(struct pci_de
 	int i;
 
 	pci_set_power_state(pci, PCI_D0);
-	pci_restore_state(pci);
+	if (pci_restore_state(pci) < 0) {
+		printk(KERN_ERR "cs5535audio: pci_restore_state failed, "
+		       "disabling device\n");
+		snd_card_disconnect(card);
+		return -EIO;
+	}
 	if (pci_enable_device(pci) < 0) {
 		printk(KERN_ERR "cs5535audio: pci_enable_device failed, "
 		       "disabling device\n");
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
