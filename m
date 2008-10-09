From: akpm@linux-foundation.org
Subject: - alsa-sigmatel-stac92hd71b7-low-hp-volume.patch removed from -mm tree
Date: Wed, 08 Oct 2008 22:56:57 -0700
Message-ID: <200810090556.m995uvGF007658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079AbYJIF5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 01:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klaasdc@gmail.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: Sigmatel stac92hd71b7 low HP volume
has been removed from the -mm tree.  Its filename was
     alsa-sigmatel-stac92hd71b7-low-hp-volume.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alsa: Sigmatel stac92hd71b7 low HP volume
From: Klaas De Craemer <klaasdc@gmail.com>

Fix an issue on Dell E6500 notebooks with the Sigmatel stac92hd71b7 codec.

In the default snd-hda-intel configuration, the sound going to the
headphone jack goes comes directly from the DAC, resulting in very low
volume output.  The patch changes the codec's widget connections so that
the internal mixer is put in between and sets its input amplifiers to the
maximum value.  The output to the internal speaker port has been left
untouched.  I have tested this and it gives a much better output.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/patch_sigmatel.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN sound/pci/hda/patch_sigmatel.c~alsa-sigmatel-stac92hd71b7-low-hp-volume sound/pci/hda/patch_sigmatel.c
--- a/sound/pci/hda/patch_sigmatel.c~alsa-sigmatel-stac92hd71b7-low-hp-volume
+++ a/sound/pci/hda/patch_sigmatel.c
@@ -855,6 +855,22 @@ static struct hda_verb stac92hd83xxx_cor
 	{ 0x01, AC_VERB_SET_EAPD, 1 << 2},
 };
 
+static struct hda_verb stac92hd71b7_core_init[] = {
+	/* set master volume and direct control */
+	{ 0x28, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xff},
+	/* connect headphone jack to mixer */
+	{ 0x0a, AC_VERB_SET_CONNECT_SEL, 0x02},
+	/* unmute right and left channels for nodes 0x0a, 0xd, 0x0f */
+	{ 0x0a, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{ 0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{ 0x0f, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+
+	/* Increase mixer volume for the two dac's */
+	{ 0x17, 0x370, 0x7f },
+	{ 0x17, 0x371, 0x7f },
+	{}
+};
+
 static struct hda_verb stac92hd71bxx_core_init[] = {
 	/* set master volume and direct control */
 	{ 0x28, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xff},
@@ -4354,6 +4370,10 @@ again:
 		spec->init = stac92hd71bxx_core_init;
 		codec->slave_dig_outs = stac92hd71bxx_slave_dig_outs;
 		break;
+	case 0x111d76b2: /* Dell E6500 stac92hd71b7 configuration */
+		spec->mixer = stac92hd71bxx_mixer;
+		spec->init = stac92hd71b7_core_init;
+		break;
 	case 0x111d7608: /* 5 Port with Analog Mixer */
 		if ((codec->revision_id & 0xf) == 0 ||
 				(codec->revision_id & 0xf) == 1) {
_

Patches currently in -mm which might be from klaasdc@gmail.com are

alsa-sigmatel-stac92hd71b7-low-hp-volume.patch

