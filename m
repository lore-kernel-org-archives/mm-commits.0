From: akpm@linux-foundation.org
Subject: + snd-hda-intel-dont-print-using-snd_printdd-on-device-open.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:56:11 -0800
Message-ID: <200802180957.m1I9v8cI018783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbYBRJ62 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 04:58:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adel.gadllah@gmail.com, cebbert@redhat.com, perex@suse.cz, tiwai@suse.de


The patch titled
     snd-hda-intel: don't print using snd_printdd on device open
has been added to the -mm tree.  Its filename is
     snd-hda-intel-dont-print-using-snd_printdd-on-device-open.patch

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
Subject: snd-hda-intel: don't print using snd_printdd on device open
From: Adel Gadllah <adel.gadllah@gmail.com>

When CONFIG_SND_DEBUG_DETECT is set the hda-intel driver prints verbose
info like this:

ALSA sound/pci/hda/hda_intel.c:1259: azx_pcm_prepare: bufsize=0x4400,
fragsize=0x1100, format=0x11
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x7,
stream=0x5, channel=0, format=0x11
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x3,
stream=0x5, channel=0, format=0x11
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x3,
stream=0x0, channel=0, format=0x0
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x7,
stream=0x0, channel=0, format=0x0
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x3,
stream=0x0, channel=0, format=0x0

Every time when an app opens the sound device.  This makes it impossible
for distribution to enable this config option (to get more debug
information for bug reports), because its way too noisy.  SND_DEBUG_DETECT
should only print stuff once when loading the driver.

There are some options to fix this:

1) don't print anything in functions that gets called when the device
   gets opened/prepared for output.

2) use snd_printd instead of snd_printdd and make
   CONFIG_SND_DEBUG_DETECT not depend on CONFIG_SND_DEBUG (this should be
   done anyway)

3) introduce a CONFIG_SND_DEBUG_DETECT_VERBOSE and snd_printddv and use
   it in this places (this one should be disabled by distributions then)

The attached patch implements 1).

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_codec.c |    3 ---
 sound/pci/hda/hda_intel.c |    2 --
 2 files changed, 5 deletions(-)

diff -puN sound/pci/hda/hda_codec.c~snd-hda-intel-dont-print-using-snd_printdd-on-device-open sound/pci/hda/hda_codec.c
--- a/sound/pci/hda/hda_codec.c~snd-hda-intel-dont-print-using-snd_printdd-on-device-open
+++ a/sound/pci/hda/hda_codec.c
@@ -686,9 +686,6 @@ void snd_hda_codec_setup_stream(struct h
 	if (!nid)
 		return;
 
-	snd_printdd("hda_codec_setup_stream: "
-		    "NID=0x%x, stream=0x%x, channel=%d, format=0x%x\n",
-		    nid, stream_tag, channel_id, format);
 	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_CHANNEL_STREAMID,
 			    (stream_tag << 4) | channel_id);
 	msleep(1);
diff -puN sound/pci/hda/hda_intel.c~snd-hda-intel-dont-print-using-snd_printdd-on-device-open sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~snd-hda-intel-dont-print-using-snd_printdd-on-device-open
+++ a/sound/pci/hda/hda_intel.c
@@ -1308,8 +1308,6 @@ static int azx_pcm_prepare(struct snd_pc
 		return -EINVAL;
 	}
 
-	snd_printdd("azx_pcm_prepare: bufsize=0x%x, format=0x%x\n",
-		    azx_dev->bufsize, azx_dev->format_val);
 	if (azx_setup_periods(substream, azx_dev) < 0)
 		return -EINVAL;
 	azx_setup_controller(chip, azx_dev);
_

Patches currently in -mm which might be from adel.gadllah@gmail.com are

snd-hda-intel-dont-print-using-snd_printdd-on-device-open.patch
