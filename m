From: akpm@linux-foundation.org
Subject: - ice1712-build-fixes.patch removed from -mm tree
Date: Thu, 15 Mar 2007 14:00:03 -0800
Message-ID: <200703152200.l2FM03H5027889@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42745 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbXCOWDa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:03:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     ice1712: build fixes
has been removed from the -mm tree.  Its filename was
     ice1712-build-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ice1712: build fixes
From: Ralf Baechle <ralf@linux-mips.org>

  CC [M]  sound/pci/ice1712/ice1712.o
sound/pci/ice1712/ice1712.c:290: error: snd_ice1712_mixer_digmix_route_ac97 causes a section type conflict
sound/pci/ice1712/ice1712.c:1630: error: snd_ice1712_eeprom causes a section type conflict
sound/pci/ice1712/ice1712.c:1894: error: snd_ice1712_pro_internal_clock causes a section type conflict
sound/pci/ice1712/ice1712.c:1965: error: snd_ice1712_pro_internal_clock_default causes a section type conflict
sound/pci/ice1712/ice1712.c:2004: error: snd_ice1712_pro_rate_locking causes a section type conflict
sound/pci/ice1712/ice1712.c:2043: error: snd_ice1712_pro_rate_reset causes a section type conflict
sound/pci/ice1712/ice1712.c:2210: error: snd_ice1712_mixer_pro_analog_route causes a section type conflict
sound/pci/ice1712/ice1712.c:2218: error: snd_ice1712_mixer_pro_spdif_route causes a section type conflict
sound/pci/ice1712/ice1712.c:2260: error: snd_ice1712_mixer_pro_volume_rate causes a section type conflict
sound/pci/ice1712/ice1712.c:2293: error: snd_ice1712_mixer_pro_peak causes a section type conflict
sound/pci/ice1712/ice1712.c:1666: error: snd_ice1712_spdif_default causes a section type conflict
sound/pci/ice1712/ice1712.c:1717: error: snd_ice1712_spdif_maskc causes a section type conflict
sound/pci/ice1712/ice1712.c:1726: error: snd_ice1712_spdif_maskp causes a section type conflict
sound/pci/ice1712/ice1712.c:1753: error: snd_ice1712_spdif_stream causes a section type conflict

Gcc like its __devinitdata readable not const, it seems.  An alternative
fix would be to remove the __devinitdata attribute but that would result in
slight runtime bloat.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/ice1712/delta.c    |   34 ++++++++++++------------
 sound/pci/ice1712/delta.h    |    2 -
 sound/pci/ice1712/ews.c      |   24 ++++++++---------
 sound/pci/ice1712/ews.h      |    2 -
 sound/pci/ice1712/hoontech.c |    6 ++--
 sound/pci/ice1712/hoontech.h |    2 -
 sound/pci/ice1712/ice1712.c  |   46 ++++++++++++++++-----------------
 7 files changed, 58 insertions(+), 58 deletions(-)

diff -puN sound/pci/ice1712/delta.c~ice1712-build-fixes sound/pci/ice1712/delta.c
--- a/sound/pci/ice1712/delta.c~ice1712-build-fixes
+++ a/sound/pci/ice1712/delta.c
@@ -416,7 +416,7 @@ static int snd_ice1712_delta1010lt_wordc
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_delta1010lt_wordclock_status __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_delta1010lt_wordclock_status __devinitdata =
 {
 	.access =	(SNDRV_CTL_ELEM_ACCESS_READ),
 	.iface =	SNDRV_CTL_ELEM_IFACE_MIXER,
@@ -429,7 +429,7 @@ static const struct snd_kcontrol_new snd
  * initialize the chips on M-Audio cards
  */
 
-static const struct snd_akm4xxx akm_audiophile __devinitdata = {
+static struct snd_akm4xxx akm_audiophile __devinitdata = {
 	.type = SND_AK4528,
 	.num_adcs = 2,
 	.num_dacs = 2,
@@ -438,7 +438,7 @@ static const struct snd_akm4xxx akm_audi
 	}
 };
 
-static const struct snd_ak4xxx_private akm_audiophile_priv __devinitdata = {
+static struct snd_ak4xxx_private akm_audiophile_priv __devinitdata = {
 	.caddr = 2,
 	.cif = 0,
 	.data_mask = ICE1712_DELTA_AP_DOUT,
@@ -450,7 +450,7 @@ static const struct snd_ak4xxx_private a
 	.mask_flags = 0,
 };
 
-static const struct snd_akm4xxx akm_delta410 __devinitdata = {
+static struct snd_akm4xxx akm_delta410 __devinitdata = {
 	.type = SND_AK4529,
 	.num_adcs = 2,
 	.num_dacs = 8,
@@ -459,7 +459,7 @@ static const struct snd_akm4xxx akm_delt
 	}
 };
 
-static const struct snd_ak4xxx_private akm_delta410_priv __devinitdata = {
+static struct snd_ak4xxx_private akm_delta410_priv __devinitdata = {
 	.caddr = 0,
 	.cif = 0,
 	.data_mask = ICE1712_DELTA_AP_DOUT,
@@ -471,7 +471,7 @@ static const struct snd_ak4xxx_private a
 	.mask_flags = 0,
 };
 
-static const struct snd_akm4xxx akm_delta1010lt __devinitdata = {
+static struct snd_akm4xxx akm_delta1010lt __devinitdata = {
 	.type = SND_AK4524,
 	.num_adcs = 8,
 	.num_dacs = 8,
@@ -481,7 +481,7 @@ static const struct snd_akm4xxx akm_delt
 	}
 };
 
-static const struct snd_ak4xxx_private akm_delta1010lt_priv __devinitdata = {
+static struct snd_ak4xxx_private akm_delta1010lt_priv __devinitdata = {
 	.caddr = 2,
 	.cif = 0, /* the default level of the CIF pin from AK4524 */
 	.data_mask = ICE1712_DELTA_1010LT_DOUT,
@@ -493,7 +493,7 @@ static const struct snd_ak4xxx_private a
 	.mask_flags = 0,
 };
 
-static const struct snd_akm4xxx akm_delta44 __devinitdata = {
+static struct snd_akm4xxx akm_delta44 __devinitdata = {
 	.type = SND_AK4524,
 	.num_adcs = 4,
 	.num_dacs = 4,
@@ -503,7 +503,7 @@ static const struct snd_akm4xxx akm_delt
 	}
 };
 
-static const struct snd_ak4xxx_private akm_delta44_priv __devinitdata = {
+static struct snd_ak4xxx_private akm_delta44_priv __devinitdata = {
 	.caddr = 2,
 	.cif = 0, /* the default level of the CIF pin from AK4524 */
 	.data_mask = ICE1712_DELTA_CODEC_SERIAL_DATA,
@@ -515,7 +515,7 @@ static const struct snd_ak4xxx_private a
 	.mask_flags = 0,
 };
 
-static const struct snd_akm4xxx akm_vx442 __devinitdata = {
+static struct snd_akm4xxx akm_vx442 __devinitdata = {
 	.type = SND_AK4524,
 	.num_adcs = 4,
 	.num_dacs = 4,
@@ -525,7 +525,7 @@ static const struct snd_akm4xxx akm_vx44
 	}
 };
 
-static const struct snd_ak4xxx_private akm_vx442_priv __devinitdata = {
+static struct snd_ak4xxx_private akm_vx442_priv __devinitdata = {
 	.caddr = 2,
 	.cif = 0,
 	.data_mask = ICE1712_VX442_DOUT,
@@ -650,15 +650,15 @@ static int __devinit snd_ice1712_delta_i
  * additional controls for M-Audio cards
  */
 
-static const struct snd_kcontrol_new snd_ice1712_delta1010_wordclock_select __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_delta1010_wordclock_select __devinitdata =
 ICE1712_GPIO(SNDRV_CTL_ELEM_IFACE_MIXER, "Word Clock Sync", 0, ICE1712_DELTA_WORD_CLOCK_SELECT, 1, 0);
-static const struct snd_kcontrol_new snd_ice1712_delta1010lt_wordclock_select __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_delta1010lt_wordclock_select __devinitdata =
 ICE1712_GPIO(SNDRV_CTL_ELEM_IFACE_MIXER, "Word Clock Sync", 0, ICE1712_DELTA_1010LT_WORDCLOCK, 0, 0);
-static const struct snd_kcontrol_new snd_ice1712_delta1010_wordclock_status __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_delta1010_wordclock_status __devinitdata =
 ICE1712_GPIO(SNDRV_CTL_ELEM_IFACE_MIXER, "Word Clock Status", 0, ICE1712_DELTA_WORD_CLOCK_STATUS, 1, SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE);
-static const struct snd_kcontrol_new snd_ice1712_deltadio2496_spdif_in_select __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_deltadio2496_spdif_in_select __devinitdata =
 ICE1712_GPIO(SNDRV_CTL_ELEM_IFACE_MIXER, "IEC958 Input Optical", 0, ICE1712_DELTA_SPDIF_INPUT_SELECT, 0, 0);
-static const struct snd_kcontrol_new snd_ice1712_delta_spdif_in_status __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_delta_spdif_in_status __devinitdata =
 ICE1712_GPIO(SNDRV_CTL_ELEM_IFACE_MIXER, "Delta IEC958 Input Status", 0, ICE1712_DELTA_SPDIF_IN_STAT, 1, SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE);
 
 
@@ -735,7 +735,7 @@ static int __devinit snd_ice1712_delta_a
 
 
 /* entry point */
-const struct snd_ice1712_card_info snd_ice1712_delta_cards[] __devinitdata = {
+struct snd_ice1712_card_info snd_ice1712_delta_cards[] __devinitdata = {
 	{
 		.subvendor = ICE1712_SUBDEVICE_DELTA1010,
 		.name = "M Audio Delta 1010",
diff -puN sound/pci/ice1712/delta.h~ice1712-build-fixes sound/pci/ice1712/delta.h
--- a/sound/pci/ice1712/delta.h~ice1712-build-fixes
+++ a/sound/pci/ice1712/delta.h
@@ -46,7 +46,7 @@
 #define ICE1712_SUBDEVICE_MEDIASTATION	0x694c0100
 
 /* entry point */
-extern const struct snd_ice1712_card_info snd_ice1712_delta_cards[];
+extern struct snd_ice1712_card_info snd_ice1712_delta_cards[];
 
 
 /*
diff -puN sound/pci/ice1712/ews.c~ice1712-build-fixes sound/pci/ice1712/ews.c
--- a/sound/pci/ice1712/ews.c~ice1712-build-fixes
+++ a/sound/pci/ice1712/ews.c
@@ -332,7 +332,7 @@ static void ews88_setup_spdif(struct snd
 
 /*
  */
-static const struct snd_akm4xxx akm_ews88mt __devinitdata = {
+static struct snd_akm4xxx akm_ews88mt __devinitdata = {
 	.num_adcs = 8,
 	.num_dacs = 8,
 	.type = SND_AK4524,
@@ -342,7 +342,7 @@ static const struct snd_akm4xxx akm_ews8
 	}
 };
 
-static const struct snd_ak4xxx_private akm_ews88mt_priv __devinitdata = {
+static struct snd_ak4xxx_private akm_ews88mt_priv __devinitdata = {
 	.caddr = 2,
 	.cif = 1, /* CIF high */
 	.data_mask = ICE1712_EWS88_SERIAL_DATA,
@@ -354,7 +354,7 @@ static const struct snd_ak4xxx_private a
 	.mask_flags = 0,
 };
 
-static const struct snd_akm4xxx akm_ewx2496 __devinitdata = {
+static struct snd_akm4xxx akm_ewx2496 __devinitdata = {
 	.num_adcs = 2,
 	.num_dacs = 2,
 	.type = SND_AK4524,
@@ -363,7 +363,7 @@ static const struct snd_akm4xxx akm_ewx2
 	}
 };
 
-static const struct snd_ak4xxx_private akm_ewx2496_priv __devinitdata = {
+static struct snd_ak4xxx_private akm_ewx2496_priv __devinitdata = {
 	.caddr = 2,
 	.cif = 1, /* CIF high */
 	.data_mask = ICE1712_EWS88_SERIAL_DATA,
@@ -375,7 +375,7 @@ static const struct snd_ak4xxx_private a
 	.mask_flags = 0,
 };
 
-static const struct snd_akm4xxx akm_6fire __devinitdata = {
+static struct snd_akm4xxx akm_6fire __devinitdata = {
 	.num_adcs = 6,
 	.num_dacs = 6,
 	.type = SND_AK4524,
@@ -384,7 +384,7 @@ static const struct snd_akm4xxx akm_6fir
 	}
 };
 
-static const struct snd_ak4xxx_private akm_6fire_priv __devinitdata = {
+static struct snd_ak4xxx_private akm_6fire_priv __devinitdata = {
 	.caddr = 2,
 	.cif = 1, /* CIF high */
 	.data_mask = ICE1712_6FIRE_SERIAL_DATA,
@@ -578,7 +578,7 @@ static int snd_ice1712_ewx_io_sense_put(
 	return val != nval;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_ewx2496_controls[] __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_ewx2496_controls[] __devinitdata = {
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 		.name = "Input Sensitivity Switch",
@@ -678,7 +678,7 @@ static int snd_ice1712_ews88mt_input_sen
 	return ndata != data;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_ews88mt_input_sense __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_ews88mt_input_sense __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Input Sensitivity Switch",
 	.info = snd_ice1712_ewx_io_sense_info,
@@ -687,7 +687,7 @@ static const struct snd_kcontrol_new snd
 	.count = 8,
 };
 
-static const struct snd_kcontrol_new snd_ice1712_ews88mt_output_sense __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_ews88mt_output_sense __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Output Sensitivity Switch",
 	.info = snd_ice1712_ewx_io_sense_info,
@@ -769,7 +769,7 @@ static int snd_ice1712_ews88d_control_pu
   .private_value = xshift | (xinvert << 8),\
 }
 
-static const struct snd_kcontrol_new snd_ice1712_ews88d_controls[] __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_ews88d_controls[] __devinitdata = {
 	EWS88D_CONTROL(SNDRV_CTL_ELEM_IFACE_MIXER, "IEC958 Input Optical", 0, 1, 0), /* inverted */
 	EWS88D_CONTROL(SNDRV_CTL_ELEM_IFACE_MIXER, "ADAT Output Optical", 1, 0, 0),
 	EWS88D_CONTROL(SNDRV_CTL_ELEM_IFACE_MIXER, "ADAT External Master Clock", 2, 0, 0),
@@ -909,7 +909,7 @@ static int snd_ice1712_6fire_select_inpu
   .private_value = xshift | (xinvert << 8),\
 }
 
-static const struct snd_kcontrol_new snd_ice1712_6fire_controls[] __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_6fire_controls[] __devinitdata = {
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 		.name = "Analog Input Select",
@@ -989,7 +989,7 @@ static int __devinit snd_ice1712_ews_add
 
 
 /* entry point */
-const struct snd_ice1712_card_info snd_ice1712_ews_cards[] __devinitdata = {
+struct snd_ice1712_card_info snd_ice1712_ews_cards[] __devinitdata = {
 	{
 		.subvendor = ICE1712_SUBDEVICE_EWX2496,
 		.name = "TerraTec EWX24/96",
diff -puN sound/pci/ice1712/ews.h~ice1712-build-fixes sound/pci/ice1712/ews.h
--- a/sound/pci/ice1712/ews.h~ice1712-build-fixes
+++ a/sound/pci/ice1712/ews.h
@@ -40,7 +40,7 @@
 #define ICE1712_SUBDEVICE_PHASE88	0x3b155111
 
 /* entry point */
-extern const struct snd_ice1712_card_info snd_ice1712_ews_cards[];
+extern struct snd_ice1712_card_info snd_ice1712_ews_cards[];
 
 
 /* TerraTec EWX 24/96 configuration definitions */
diff -puN sound/pci/ice1712/hoontech.c~ice1712-build-fixes sound/pci/ice1712/hoontech.c
--- a/sound/pci/ice1712/hoontech.c~ice1712-build-fixes
+++ a/sound/pci/ice1712/hoontech.c
@@ -239,7 +239,7 @@ static void stdsp24_ak4524_lock(struct s
 static int __devinit snd_ice1712_value_init(struct snd_ice1712 *ice)
 {
 	/* Hoontech STDSP24 with modified hardware */
-	static const struct snd_akm4xxx akm_stdsp24_mv __devinitdata = {
+	static struct snd_akm4xxx akm_stdsp24_mv __devinitdata = {
 		.num_adcs = 2,
 		.num_dacs = 2,
 		.type = SND_AK4524,
@@ -248,7 +248,7 @@ static int __devinit snd_ice1712_value_i
 		}
 	};
 
-	static const struct snd_ak4xxx_private akm_stdsp24_mv_priv __devinitdata = {
+	static struct snd_ak4xxx_private akm_stdsp24_mv_priv __devinitdata = {
 		.caddr = 2,
 		.cif = 1, /* CIF high */
 		.data_mask = ICE1712_STDSP24_SERIAL_DATA,
@@ -298,7 +298,7 @@ static int __devinit snd_ice1712_ez8_ini
 
 
 /* entry point */
-const struct snd_ice1712_card_info snd_ice1712_hoontech_cards[] __devinitdata = {
+struct snd_ice1712_card_info snd_ice1712_hoontech_cards[] __devinitdata = {
 	{
 		.subvendor = ICE1712_SUBDEVICE_STDSP24,
 		.name = "Hoontech SoundTrack Audio DSP24",
diff -puN sound/pci/ice1712/hoontech.h~ice1712-build-fixes sound/pci/ice1712/hoontech.h
--- a/sound/pci/ice1712/hoontech.h~ice1712-build-fixes
+++ a/sound/pci/ice1712/hoontech.h
@@ -35,7 +35,7 @@
 #define ICE1712_SUBDEVICE_STDSP24_MEDIA7_1	0x16141217	/* Hoontech ST Audio DSP24 Media 7.1 */
 #define ICE1712_SUBDEVICE_EVENT_EZ8		0x00010001	/* A dummy id for EZ8 */
 
-extern const struct snd_ice1712_card_info snd_ice1712_hoontech_cards[];
+extern struct snd_ice1712_card_info snd_ice1712_hoontech_cards[];
 
 
 /* Hoontech SoundTrack Audio DSP 24 GPIO definitions */
diff -puN sound/pci/ice1712/ice1712.c~ice1712-build-fixes sound/pci/ice1712/ice1712.c
--- a/sound/pci/ice1712/ice1712.c~ice1712-build-fixes
+++ a/sound/pci/ice1712/ice1712.c
@@ -287,7 +287,7 @@ static int snd_ice1712_digmix_route_ac97
 	return val != nval;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_digmix_route_ac97 __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_digmix_route_ac97 __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Digital Mixer To AC97",
 	.info = snd_ice1712_digmix_route_ac97_info,
@@ -1378,7 +1378,7 @@ static int snd_ice1712_pro_mixer_volume_
 
 static const DECLARE_TLV_DB_SCALE(db_scale_playback, -14400, 150, 0);
 
-static const struct snd_kcontrol_new snd_ice1712_multi_playback_ctrls[] __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_playback_ctrls[] __devinitdata = {
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 		.name = "Multi Playback Switch",
@@ -1402,7 +1402,7 @@ static const struct snd_kcontrol_new snd
 	},
 };
 
-static const struct snd_kcontrol_new snd_ice1712_multi_capture_analog_switch __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_capture_analog_switch __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "H/W Multi Capture Switch",
 	.info = snd_ice1712_pro_mixer_switch_info,
@@ -1411,7 +1411,7 @@ static const struct snd_kcontrol_new snd
 	.private_value = 10,
 };
 
-static const struct snd_kcontrol_new snd_ice1712_multi_capture_spdif_switch __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_capture_spdif_switch __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = SNDRV_CTL_NAME_IEC958("Multi ",CAPTURE,SWITCH),
 	.info = snd_ice1712_pro_mixer_switch_info,
@@ -1421,7 +1421,7 @@ static const struct snd_kcontrol_new snd
 	.count = 2,
 };
 
-static const struct snd_kcontrol_new snd_ice1712_multi_capture_analog_volume __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_capture_analog_volume __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = (SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		   SNDRV_CTL_ELEM_ACCESS_TLV_READ),
@@ -1433,7 +1433,7 @@ static const struct snd_kcontrol_new snd
 	.tlv = { .p = db_scale_playback }
 };
 
-static const struct snd_kcontrol_new snd_ice1712_multi_capture_spdif_volume __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_multi_capture_spdif_volume __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = SNDRV_CTL_NAME_IEC958("Multi ",CAPTURE,VOLUME),
 	.info = snd_ice1712_pro_mixer_volume_info,
@@ -1625,7 +1625,7 @@ static int snd_ice1712_eeprom_get(struct
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_eeprom __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_eeprom __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_CARD,
 	.name = "ICE1712 EEPROM",
 	.access = SNDRV_CTL_ELEM_ACCESS_READ,
@@ -1661,7 +1661,7 @@ static int snd_ice1712_spdif_default_put
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_spdif_default __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_spdif_default __devinitdata =
 {
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
 	.name =         SNDRV_CTL_NAME_IEC958("",PLAYBACK,DEFAULT),
@@ -1712,7 +1712,7 @@ static int snd_ice1712_spdif_maskp_get(s
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_spdif_maskc __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_spdif_maskc __devinitdata =
 {
 	.access =	SNDRV_CTL_ELEM_ACCESS_READ,
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
@@ -1721,7 +1721,7 @@ static const struct snd_kcontrol_new snd
 	.get =		snd_ice1712_spdif_maskc_get,
 };
 
-static const struct snd_kcontrol_new snd_ice1712_spdif_maskp __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_spdif_maskp __devinitdata =
 {
 	.access =	SNDRV_CTL_ELEM_ACCESS_READ,
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
@@ -1748,7 +1748,7 @@ static int snd_ice1712_spdif_stream_put(
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_spdif_stream __devinitdata =
+static struct snd_kcontrol_new snd_ice1712_spdif_stream __devinitdata =
 {
 	.access =	(SNDRV_CTL_ELEM_ACCESS_READWRITE |
 			 SNDRV_CTL_ELEM_ACCESS_INACTIVE),
@@ -1889,7 +1889,7 @@ static int snd_ice1712_pro_internal_cloc
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_pro_internal_clock __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_pro_internal_clock __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Internal Clock",
 	.info = snd_ice1712_pro_internal_clock_info,
@@ -1960,7 +1960,7 @@ static int snd_ice1712_pro_internal_cloc
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_pro_internal_clock_default __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_pro_internal_clock_default __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Internal Clock Default",
 	.info = snd_ice1712_pro_internal_clock_default_info,
@@ -1999,7 +1999,7 @@ static int snd_ice1712_pro_rate_locking_
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_pro_rate_locking __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_pro_rate_locking __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Rate Locking",
 	.info = snd_ice1712_pro_rate_locking_info,
@@ -2038,7 +2038,7 @@ static int snd_ice1712_pro_rate_reset_pu
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_pro_rate_reset __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_pro_rate_reset __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Rate Reset",
 	.info = snd_ice1712_pro_rate_reset_info,
@@ -2205,7 +2205,7 @@ static int snd_ice1712_pro_route_spdif_p
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_pro_analog_route __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_pro_analog_route __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "H/W Playback Route",
 	.info = snd_ice1712_pro_route_info,
@@ -2213,7 +2213,7 @@ static const struct snd_kcontrol_new snd
 	.put = snd_ice1712_pro_route_analog_put,
 };
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_pro_spdif_route __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_pro_spdif_route __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = SNDRV_CTL_NAME_IEC958("",PLAYBACK,NONE) "Route",
 	.info = snd_ice1712_pro_route_info,
@@ -2255,7 +2255,7 @@ static int snd_ice1712_pro_volume_rate_p
 	return change;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_pro_volume_rate __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_pro_volume_rate __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Volume Rate",
 	.info = snd_ice1712_pro_volume_rate_info,
@@ -2288,7 +2288,7 @@ static int snd_ice1712_pro_peak_get(stru
 	return 0;
 }
 
-static const struct snd_kcontrol_new snd_ice1712_mixer_pro_peak __devinitdata = {
+static struct snd_kcontrol_new snd_ice1712_mixer_pro_peak __devinitdata = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Multi Track Peak",
 	.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
@@ -2303,7 +2303,7 @@ static const struct snd_kcontrol_new snd
 /*
  * list of available boards
  */
-static const struct snd_ice1712_card_info *card_tables[] __devinitdata = {
+static struct snd_ice1712_card_info *card_tables[] __devinitdata = {
 	snd_ice1712_hoontech_cards,
 	snd_ice1712_delta_cards,
 	snd_ice1712_ews_cards,
@@ -2327,7 +2327,7 @@ static int __devinit snd_ice1712_read_ee
 {
 	int dev = 0xa0;		/* EEPROM device address */
 	unsigned int i, size;
-	const struct snd_ice1712_card_info **tbl, *c;
+	struct snd_ice1712_card_info **tbl, *c;
 
 	if (! modelname || ! *modelname) {
 		ice->eeprom.subvendor = 0;
@@ -2656,7 +2656,7 @@ static int __devinit snd_ice1712_create(
  *
  */
 
-static const struct snd_ice1712_card_info no_matched __devinitdata;
+static struct snd_ice1712_card_info no_matched __devinitdata;
 
 static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 				       const struct pci_device_id *pci_id)
@@ -2665,7 +2665,7 @@ static int __devinit snd_ice1712_probe(s
 	struct snd_card *card;
 	struct snd_ice1712 *ice;
 	int pcm_dev = 0, err;
-	const struct snd_ice1712_card_info **tbl, *c;
+	struct snd_ice1712_card_info **tbl, *c;
 
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-alsa.patch
git-netdev-all.patch
div64_64-common-code.patch
serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
simplify-the-stacktrace-code.patch
serial-allocate-minor-device-numbers-for.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
tgafb-turbochannel-support.patch
