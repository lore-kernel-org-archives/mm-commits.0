From: akpm@linux-foundation.org
Subject: - usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:22 -0700
Message-ID: <200804150910.m3F9AMwF020616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755974AbYDOJLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb audio: make quirk handling more readable, and fix commented-out code
has been removed from the -mm tree.  Its filename was
     usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb audio: make quirk handling more readable, and fix commented-out code
From: Pavel Machek <pavel@suse.cz>

usb audio contains useful debugging code, protected by #if 0.  Unfortunately,
it will not compile because variable names changed; fix it.

Dallas workaround is formatted in a way where it is not quite obvious what is
normal code and what is quirk.  Reformat it to make it obvious.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/usb/usbaudio.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN sound/usb/usbaudio.c~usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code sound/usb/usbaudio.c
--- a/sound/usb/usbaudio.c~usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code
+++ a/sound/usb/usbaudio.c
@@ -1427,8 +1427,8 @@ static int set_format(struct snd_usb_sub
 	subs->cur_audiofmt = fmt;
 
 #if 0
-	printk("setting done: format = %d, rate = %d, channels = %d\n",
-	       fmt->format, fmt->rate, fmt->channels);
+	printk("setting done: format = %d, rate = %d..%d, channels = %d\n",
+	       fmt->format, fmt->rate_min, fmt->rate_max, fmt->channels);
 	printk("  datapipe = 0x%0x, syncpipe = 0x%0x\n",
 	       subs->datapipe, subs->syncpipe);
 #endif
@@ -2468,11 +2468,12 @@ static int parse_audio_format_i_type(str
 		}
 		break;
 	case USB_AUDIO_FORMAT_PCM8:
-		/* Dallas DS4201 workaround */
+		pcm_format = SNDRV_PCM_FORMAT_U8;
+
+		/* Dallas DS4201 workaround: it advertises U8 format, but really
+		   supports S8. */
 		if (chip->usb_id == USB_ID(0x04fa, 0x4201))
 			pcm_format = SNDRV_PCM_FORMAT_S8;
-		else
-			pcm_format = SNDRV_PCM_FORMAT_U8;
 		break;
 	case USB_AUDIO_FORMAT_IEEE_FLOAT:
 		pcm_format = SNDRV_PCM_FORMAT_FLOAT_LE;
_

Patches currently in -mm which might be from pavel@suse.cz are

git-acpi.patch
git-x86.patch
git-alsa-tiwai.patch
s2ram-warn-when-interrupts-should-be-disabled-but-are-not.patch
git-net.patch
hci_usb-do-not-initialize-static-variables-to-0.patch
hci_usb-remove-code-obfuscation.patch
hci_usbh-fix-hard-to-trigger-race.patch

