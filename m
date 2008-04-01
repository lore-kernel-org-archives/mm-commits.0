From: akpm@linux-foundation.org
Subject: + usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code.patch added to -mm tree
Date: Tue, 01 Apr 2008 12:20:08 -0700
Message-ID: <200804011920.m31JK9dF009033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbYDATUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 15:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, perex@suse.cz, tiwai@suse.de


The patch titled
     usb audio: make quirk handling more readable, and fix commented-out code
has been added to the -mm tree.  Its filename is
     usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code.patch

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

git-x86.patch
git-acpi.patch
usb-audio-fix-another-dallas-quirk.patch
usb-audio-make-quirk-handling-more-readable-and-fix-commented-out-code.patch
pm-remove-legacy-pm-fix.patch

