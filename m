From: akpm@linux-foundation.org
Subject: + olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch added to -mm tree
Date: Wed, 24 Feb 2010 15:50:59 -0800
Message-ID: <201002242350.o1ONoxhT027684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758622Ab0BXXvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 18:51:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@collabora.co.uk, gardner.ben@gmail.com, jayakumar.alsa@gmail.com, tiwai@suse.de


The patch titled
     OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
has been added to the -mm tree.  Its filename is
     olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
From: Andres Salomon <dilinger@collabora.co.uk>

Previously the MIC GPIO was set to output mode, and when checking the
status after setting it we were checking OUTPUT_VAL.  This worked, though
I'm not quite sure why.  Instead, if we actually check the READ_BACK
value, it doesn't work unless the GPIO is in bidirectional mode.  Thus,
enable input mode as well.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Ben Gardner <gardner.ben@gmail.com>
Cc: Jaya Kumar <jayakumar.alsa@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/cs5535audio/cs5535audio_olpc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN sound/pci/cs5535audio/cs5535audio_olpc.c~olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input sound/pci/cs5535audio/cs5535audio_olpc.c
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c~olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input
+++ a/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -157,6 +157,7 @@ int __devinit olpc_quirks(struct snd_car
 		return -EIO;
 	}
 	gpio_direction_output(OLPC_GPIO_MIC_AC, 0);
+	gpio_direction_input(OLPC_GPIO_MIC_AC);
 
 	/* drop the original AD1888 HPF control */
 	memset(&elem, 0, sizeof(elem));
_

Patches currently in -mm which might be from dilinger@collabora.co.uk are

origin.patch
linux-next.patch
olpc-alsa-fix-cs5535audios-mic-gpio-to-enable-input.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch
mfgpt-move-clocksource-menu.patch
cs5535_gpio-gpio_chipget-should-return-the-input-value.patch

