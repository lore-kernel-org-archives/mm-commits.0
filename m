From: akpm@linux-foundation.org
Subject: + alsa-cs5535audio-fix-acc_bm_cmd-register-handling.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:39:09 -0700
Message-ID: <200708311939.l7VJd9kI023339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58469 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbXHaTjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:39:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, jayakumar.alsa@gmail.com, jordan.crouse@amd.com, perex@suse.cz, tiwai@suse.de


The patch titled
     ALSA: cs5535audio: fix ACC_BM[x]_CMD register handling
has been added to the -mm tree.  Its filename is
     alsa-cs5535audio-fix-acc_bm_cmd-register-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALSA: cs5535audio: fix ACC_BM[x]_CMD register handling
From: Andres Salomon <dilinger@queued.net>

ACcording to 6.3.2.7 of the cs5535/cs5536 data sheets, the ACC_BM[x]_CMD
registers are only 8 bits wide.  This driver treats them as 32 bits wide, and
also has bits in the wrong place.  Simple fix to the definitions.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Acked-by: Jaya Kumar <jayakumar.alsa@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/cs5535audio/cs5535audio.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN sound/pci/cs5535audio/cs5535audio.h~alsa-cs5535audio-fix-acc_bm_cmd-register-handling sound/pci/cs5535audio/cs5535audio.h
--- a/sound/pci/cs5535audio/cs5535audio.h~alsa-cs5535audio-fix-acc_bm_cmd-register-handling
+++ a/sound/pci/cs5535audio/cs5535audio.h
@@ -62,11 +62,11 @@
 #define EOP				(1<<0)
 #define BM_EOP_ERR			(1<<1)
 /* ACC_BMX_CTL */
-#define BM_CTL_EN			0x00000001
-#define BM_CTL_PAUSE			0x00000011
-#define BM_CTL_DIS			0x00000000
-#define BM_CTL_BYTE_ORD_LE		0x00000000
-#define BM_CTL_BYTE_ORD_BE		0x00000100
+#define BM_CTL_EN			0x01
+#define BM_CTL_PAUSE			0x03
+#define BM_CTL_DIS			0x00
+#define BM_CTL_BYTE_ORD_LE		0x00
+#define BM_CTL_BYTE_ORD_BE		0x04
 /* cs5535 specific ac97 codec register defines */
 #define CMD_MASK			0xFF00FFFF
 #define CMD_NEW				0x00010000
_

Patches currently in -mm which might be from dilinger@queued.net are

alsa-cs5535audio-correctly-set-dma-substream.patch
alsa-cs5535audio-fix-prd-register-save-restore-power-management-race.patch
alsa-cs5535audio-update-pci-device-handling-in-suspend-resume.patch
alsa-cs5535audio-fix-acc_bm_cmd-register-handling.patch
alsa-cs5535audio-drop-unused-bus-master-stuff.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
