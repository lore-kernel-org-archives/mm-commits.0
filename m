From: akpm@linux-foundation.org
Subject: - git-alsa-fixup.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:25:03 -0700
Message-ID: <200707242325.l6ONP32J006331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757601AbXGXXZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:25:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     git-alsa-fixup
has been removed from the -mm tree.  Its filename was
     git-alsa-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-alsa-fixup
From: Andrew Morton <akpm@linux-foundation.org>

try to fix mainline vs git-alsa rejects

Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/Makefile                |    4 
 sound/pci/hda/patch_realtek.c |  513 --------------------------------
 sound/soc/s3c24xx/Kconfig     |   30 -
 3 files changed, 547 deletions(-)

diff -puN sound/Makefile~git-alsa-fixup sound/Makefile
--- a/sound/Makefile~git-alsa-fixup
+++ a/sound/Makefile
@@ -5,12 +5,8 @@ obj-$(CONFIG_SOUND) += soundcore.o
 obj-$(CONFIG_SOUND_PRIME) += sound_firmware.o
 obj-$(CONFIG_SOUND_PRIME) += oss/
 obj-$(CONFIG_DMASOUND) += oss/
-<<<<<<< HEAD/sound/Makefile
-obj-$(CONFIG_SND) += core/ i2c/ drivers/ isa/ pci/ ppc/ arm/ sh/ synth/ usb/ sparc/ parisc/ pcmcia/ mips/ soc/
-=======
 obj-$(CONFIG_SND) += core/ i2c/ drivers/ isa/ pci/ ppc/ arm/ sh/ synth/ usb/ \
 	sparc/ spi/ parisc/ pcmcia/ mips/ soc/
->>>>>>> /sound/Makefile
 obj-$(CONFIG_SND_AOA) += aoa/
 
 # This one must be compilable even if sound is configured out
diff -puN sound/pci/hda/patch_realtek.c~git-alsa-fixup sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c~git-alsa-fixup
+++ a/sound/pci/hda/patch_realtek.c
@@ -8128,520 +8128,7 @@ static int patch_alc262(struct hda_codec
 }
 
 /*
-<<<<<<< HEAD/sound/pci/hda/patch_realtek.c
- *  ALC268 channel source setting (2 channel)
-=======
- *  ALC268 channel source setting (2 channel)
- */
-#define ALC268_DIGOUT_NID	ALC880_DIGOUT_NID
-#define alc268_modes		alc260_modes
-	
-static hda_nid_t alc268_dac_nids[2] = {
-	/* front, hp */
-	0x02, 0x03
-};
-
-static hda_nid_t alc268_adc_nids[2] = {
-	/* ADC0-1 */
-	0x08, 0x07
-};
-
-static hda_nid_t alc268_adc_nids_alt[1] = {
-	/* ADC0 */
-	0x08
-};
-
-static struct snd_kcontrol_new alc268_base_mixer[] = {
-	/* output mixer control */
-	HDA_CODEC_VOLUME("Front Playback Volume", 0x2, 0x0, HDA_OUTPUT),
-	HDA_CODEC_MUTE("Front Playback Switch", 0x14, 0x0, HDA_OUTPUT),
-	HDA_CODEC_VOLUME("Headphone Playback Volume", 0x3, 0x0, HDA_OUTPUT),
-	HDA_CODEC_MUTE("Headphone Playback Switch", 0x15, 0x0, HDA_OUTPUT),
-	{ }
-};
-
-/*
- * generic initialization of ADC, input mixers and output mixers
- */
-static struct hda_verb alc268_base_init_verbs[] = {
-	/* Unmute DAC0-1 and set vol = 0 */
-	{0x02, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
-	{0x02, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-	{0x02, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
-	{0x03, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
-	{0x03, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-	{0x03, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
-
-	/*
-	 * Set up output mixers (0x0c - 0x0e)
-	 */
-	/* set vol=0 to output mixers */
-	{0x0e, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-	{0x0e, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
-	{0x0e, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
-        {0x0e, AC_VERB_SET_CONNECT_SEL, 0x00},
-
-	{0x0f, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-	{0x10, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-
-	{0x14, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x40},
-	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, 0xc0},
-	{0x16, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x40},
-	{0x18, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24},
-	{0x19, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24},
-	{0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x20},
-	{0x1c, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x20},
-	{0x1d, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x20},
-
-	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x15, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x16, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x18, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x19, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x1a, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x1c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x1d, AC_VERB_SET_AMP_GAIN_MUTE, (0x7000 | (0x00 << 8))},
-
-	/* FIXME: use matrix-type input source selection */
-	/* Mixer elements: 0x18, 19, 1a, 1c, 14, 15, 0b */
-	/* Input mixer1: unmute Mic, F-Mic, Line, CD inputs */
-	/* Input mixer2 */
-	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, (0x7000 | (0x00 << 8))},
-	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, (0x7000 | (0x01 << 8))},
-	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, (0x7000 | (0x02 << 8))},
-	{0x23, AC_VERB_SET_AMP_GAIN_MUTE, (0x7000 | (0x03 << 8))},
-
-	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, (0x7000 | (0x00 << 8))},
-	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, (0x7000 | (0x01 << 8))},
-	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, (0x7000 | (0x02 << 8))},
-	{0x24, AC_VERB_SET_AMP_GAIN_MUTE, (0x7000 | (0x03 << 8))},
-	{ }
-};
-
-/*
- * generic initialization of ADC, input mixers and output mixers
- */
-static struct hda_verb alc268_volume_init_verbs[] = {
-	/* set output DAC */
-	{0x02, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-	{0x02, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
-	{0x03, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-	{0x03, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
-
-	{0x18, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24},
-	{0x19, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24},
-	{0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x20},
-	{0x1c, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x20},
-	{0x1d, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x20},
-
-	{0x0e, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
-	{0x0e, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-	{0x0e, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
-	{0x0f, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-	{0x10, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
-
-	{0x18, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x19, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x1a, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-	{0x1c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
-
-	/* set PCBEEP vol = 0 */
-	{0x1d, AC_VERB_SET_AMP_GAIN_MUTE, (0xb000 | (0x00 << 8))},
-
-	{ }
-};
-
-#define alc268_mux_enum_info alc_mux_enum_info
-#define alc268_mux_enum_get alc_mux_enum_get
-
-static int alc268_mux_enum_put(struct snd_kcontrol *kcontrol,
-			       struct snd_ctl_elem_value *ucontrol)
-{
-	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
-	struct alc_spec *spec = codec->spec;
-	const struct hda_input_mux *imux = spec->input_mux;
-	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
-	static hda_nid_t capture_mixers[3] = { 0x23, 0x24 };
-	hda_nid_t nid = capture_mixers[adc_idx];
-	unsigned int *cur_val = &spec->cur_mux[adc_idx];
-	unsigned int i, idx;
-
-	idx = ucontrol->value.enumerated.item[0];
-	if (idx >= imux->num_items)
-		idx = imux->num_items - 1;
-	if (*cur_val == idx && !codec->in_resume)
-		return 0;
-	for (i = 0; i < imux->num_items; i++) {
-		unsigned int v = (i == idx) ? 0x7000 : 0x7080;
-		snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_AMP_GAIN_MUTE,
-				    v | (imux->items[i].index << 8));
-                snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_CONNECT_SEL,
-				    idx );
-	}
-	*cur_val = idx;
-	return 1;
-}
-
-static struct snd_kcontrol_new alc268_capture_alt_mixer[] = {
-	HDA_CODEC_VOLUME("Capture Volume", 0x23, 0x0, HDA_OUTPUT),
-	HDA_CODEC_MUTE("Capture Switch", 0x23, 0x0, HDA_OUTPUT),
-	{
-		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-		/* The multiple "Capture Source" controls confuse alsamixer
-		 * So call somewhat different..
-		 * FIXME: the controls appear in the "playback" view!
-		 */
-		/* .name = "Capture Source", */
-		.name = "Input Source",
-		.count = 1,
-		.info = alc268_mux_enum_info,
-		.get = alc268_mux_enum_get,
-		.put = alc268_mux_enum_put,
-	},
-	{ } /* end */
-};
-
-static struct snd_kcontrol_new alc268_capture_mixer[] = {
-	HDA_CODEC_VOLUME("Capture Volume", 0x23, 0x0, HDA_OUTPUT),
-	HDA_CODEC_MUTE("Capture Switch", 0x23, 0x0, HDA_OUTPUT),
-	HDA_CODEC_VOLUME_IDX("Capture Volume", 1, 0x24, 0x0, HDA_OUTPUT),
-	HDA_CODEC_MUTE_IDX("Capture Switch", 1, 0x24, 0x0, HDA_OUTPUT),
-	{
-		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-		/* The multiple "Capture Source" controls confuse alsamixer
-		 * So call somewhat different..
-		 * FIXME: the controls appear in the "playback" view!
-		 */
-		/* .name = "Capture Source", */
-		.name = "Input Source",
-		.count = 2,
-		.info = alc268_mux_enum_info,
-		.get = alc268_mux_enum_get,
-		.put = alc268_mux_enum_put,
-	},
-	{ } /* end */
-};
-
-static struct hda_input_mux alc268_capture_source = {
-	.num_items = 4,
-	.items = {
-		{ "Mic", 0x0 },
-		{ "Front Mic", 0x1 },
-		{ "Line", 0x2 },
-		{ "CD", 0x3 },
-	},
-};
-
-/* create input playback/capture controls for the given pin */
-static int alc268_new_analog_output(struct alc_spec *spec, hda_nid_t nid,
-				    const char *ctlname, int idx)
-{
-	char name[32];
-	int err;
-
-	sprintf(name, "%s Playback Volume", ctlname);
-	if (nid == 0x14) {
-		err = add_control(spec, ALC_CTL_WIDGET_VOL, name,
-				  HDA_COMPOSE_AMP_VAL(0x02, 3, idx,
-						      HDA_OUTPUT));
-		if (err < 0)
-			return err;
-	} else if (nid == 0x15) {
-		err = add_control(spec, ALC_CTL_WIDGET_VOL, name,
-				  HDA_COMPOSE_AMP_VAL(0x03, 3, idx,
-						      HDA_OUTPUT));
-		if (err < 0)
-			return err;
-	} else
-		return -1;
-	sprintf(name, "%s Playback Switch", ctlname);
-	err = add_control(spec, ALC_CTL_WIDGET_MUTE, name,
-			  HDA_COMPOSE_AMP_VAL(nid, 3, idx, HDA_OUTPUT));
-	if (err < 0)
-		return err;
-	return 0;
-}
-
-/* add playback controls from the parsed DAC table */
-static int alc268_auto_create_multi_out_ctls(struct alc_spec *spec,
-					     const struct auto_pin_cfg *cfg)
-{
-	hda_nid_t nid;
-	int err;
-
-	spec->multiout.num_dacs = 2;	/* only use one dac */
-	spec->multiout.dac_nids = spec->private_dac_nids;
-	spec->multiout.dac_nids[0] = 2;
-	spec->multiout.dac_nids[1] = 3;
-
-	nid = cfg->line_out_pins[0];
-	if (nid)
-		alc268_new_analog_output(spec, nid, "Front", 0);	
-
-	nid = cfg->speaker_pins[0];
-	if (nid == 0x1d) {
-		err = add_control(spec, ALC_CTL_WIDGET_VOL,
-				  "Speaker Playback Volume",
-				  HDA_COMPOSE_AMP_VAL(nid, 3, 0, HDA_INPUT));
-		if (err < 0)
-			return err;
-	}
-	nid = cfg->hp_pins[0];
-	if (nid)
-		alc268_new_analog_output(spec, nid, "Headphone", 0);
-
-	nid = cfg->line_out_pins[1] | cfg->line_out_pins[2];
-	if (nid == 0x16) {
-		err = add_control(spec, ALC_CTL_WIDGET_MUTE,
-				  "Mono Playback Switch",
-				  HDA_COMPOSE_AMP_VAL(nid, 2, 0, HDA_INPUT));
-		if (err < 0)
-			return err;
-	}
-	return 0;	
-}
-
-/* create playback/capture controls for input pins */
-static int alc268_auto_create_analog_input_ctls(struct alc_spec *spec,
-						const struct auto_pin_cfg *cfg)
-{
-	struct hda_input_mux *imux = &spec->private_imux;
-	int i, idx1;
-
-	for (i = 0; i < AUTO_PIN_LAST; i++) {
-		switch(cfg->input_pins[i]) {
-		case 0x18:
-			idx1 = 0;	/* Mic 1 */
-			break;
-		case 0x19:
-			idx1 = 1;	/* Mic 2 */
-			break;
-		case 0x1a:
-			idx1 = 2;	/* Line In */
-			break;
-		case 0x1c:	
-			idx1 = 3;	/* CD */
-			break;
-		default:
-			continue;
-		}
-		imux->items[imux->num_items].label = auto_pin_cfg_labels[i];
-		imux->items[imux->num_items].index = idx1;
-		imux->num_items++;	
-	}
-	return 0;
-}
-
-static void alc268_auto_init_mono_speaker_out(struct hda_codec *codec)
-{
-	struct alc_spec *spec = codec->spec;
-	hda_nid_t speaker_nid = spec->autocfg.speaker_pins[0];
-	hda_nid_t hp_nid = spec->autocfg.hp_pins[0];
-	hda_nid_t line_nid = spec->autocfg.line_out_pins[0];
-	unsigned int	dac_vol1, dac_vol2;
-
-	if (speaker_nid) {
-		snd_hda_codec_write(codec, speaker_nid, 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT);
-		snd_hda_codec_write(codec, 0x0f, 0,
-				    AC_VERB_SET_AMP_GAIN_MUTE,
-				    AMP_IN_UNMUTE(1));
-		snd_hda_codec_write(codec, 0x10, 0,
-				    AC_VERB_SET_AMP_GAIN_MUTE,
-				    AMP_IN_UNMUTE(1));
-	} else {
-		snd_hda_codec_write(codec, 0x0f, 0,
-				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1));
-		snd_hda_codec_write(codec, 0x10, 0,
-				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_MUTE(1));
-	}
-
-	dac_vol1 = dac_vol2 = 0xb000 | 0x40;	/* set max volume  */
-	if (line_nid == 0x14)	
-		dac_vol2 = AMP_OUT_ZERO;
-	else if (line_nid == 0x15)
-		dac_vol1 = AMP_OUT_ZERO;
-	if (hp_nid == 0x14)	
-		dac_vol2 = AMP_OUT_ZERO;
-	else if (hp_nid == 0x15)
-		dac_vol1 = AMP_OUT_ZERO;
-	if (line_nid != 0x16 || hp_nid != 0x16 ||
-	    spec->autocfg.line_out_pins[1] != 0x16 ||
-	    spec->autocfg.line_out_pins[2] != 0x16)
-		dac_vol1 = dac_vol2 = AMP_OUT_ZERO;
-
-	snd_hda_codec_write(codec, 0x02, 0,
-			    AC_VERB_SET_AMP_GAIN_MUTE, dac_vol1);
-	snd_hda_codec_write(codec, 0x03, 0,
-			    AC_VERB_SET_AMP_GAIN_MUTE, dac_vol2);
-}
-
-/* pcm configuration: identiacal with ALC880 */
-#define alc268_pcm_analog_playback	alc880_pcm_analog_playback
-#define alc268_pcm_analog_capture	alc880_pcm_analog_capture
-#define alc268_pcm_digital_playback	alc880_pcm_digital_playback
-
-/*
- * BIOS auto configuration
- */
-static int alc268_parse_auto_config(struct hda_codec *codec)
-{
-	struct alc_spec *spec = codec->spec;
-	int err;
-	static hda_nid_t alc268_ignore[] = { 0 };
-
-	err = snd_hda_parse_pin_def_config(codec, &spec->autocfg,
-					   alc268_ignore);
-	if (err < 0)
-		return err;
-	if (!spec->autocfg.line_outs)
-		return 0; /* can't find valid BIOS pin config */
-
-	err = alc268_auto_create_multi_out_ctls(spec, &spec->autocfg);
-	if (err < 0)
-		return err;
-	err = alc268_auto_create_analog_input_ctls(spec, &spec->autocfg);
-	if (err < 0)
-		return err;
-
-	spec->multiout.max_channels = 2;
-
-	/* digital only support output */
-	if (spec->autocfg.dig_out_pin)
-		spec->multiout.dig_out_nid = ALC268_DIGOUT_NID;
-
-	if (spec->kctl_alloc)
-		spec->mixers[spec->num_mixers++] = spec->kctl_alloc;
-
-	spec->init_verbs[spec->num_init_verbs++] = alc268_volume_init_verbs;
-	spec->num_mux_defs = 1;
-	spec->input_mux = &spec->private_imux;
-
-	return 1;
-}
-
-#define alc268_auto_init_multi_out	alc882_auto_init_multi_out
-#define alc268_auto_init_hp_out		alc882_auto_init_hp_out
-#define alc268_auto_init_analog_input	alc882_auto_init_analog_input
-
-/* init callback for auto-configuration model -- overriding the default init */
-static void alc268_auto_init(struct hda_codec *codec)
-{
-	alc268_auto_init_multi_out(codec);
-	alc268_auto_init_hp_out(codec);
-	alc268_auto_init_mono_speaker_out(codec);
-	alc268_auto_init_analog_input(codec);
-}
-
-/*
- * configuration and preset
- */
-static const char *alc268_models[ALC268_MODEL_LAST] = {
-	[ALC268_3ST]		= "3stack",
-	[ALC268_AUTO]		= "auto",
-};
-
-static struct snd_pci_quirk alc268_cfg_tbl[] = {
-	SND_PCI_QUIRK(0x1043, 0x1205, "ASUS W7J", ALC268_3ST),
-	{}
-};
-
-static struct alc_config_preset alc268_presets[] = {
-	[ALC268_3ST] = {
-		.mixers = { alc268_base_mixer, alc268_capture_alt_mixer },
-		.init_verbs = { alc268_base_init_verbs },
-		.num_dacs = ARRAY_SIZE(alc268_dac_nids),
-		.dac_nids = alc268_dac_nids,
-                .num_adc_nids = ARRAY_SIZE(alc268_adc_nids_alt),
-                .adc_nids = alc268_adc_nids_alt,
-		.hp_nid = 0x03,
-		.dig_out_nid = ALC268_DIGOUT_NID,
-		.num_channel_mode = ARRAY_SIZE(alc268_modes),
-		.channel_mode = alc268_modes,
-		.input_mux = &alc268_capture_source,
-	},
-};
-
-static int patch_alc268(struct hda_codec *codec)
-{
-	struct alc_spec *spec;
-	int board_config;
-	int err;
-
-	spec = kcalloc(1, sizeof(*spec), GFP_KERNEL);
-	if (spec == NULL)
-		return -ENOMEM;
-
-	codec->spec = spec;
-
-	board_config = snd_hda_check_board_config(codec, ALC268_MODEL_LAST,
-						  alc268_models,
-						  alc268_cfg_tbl);
-
-	if (board_config < 0 || board_config >= ALC268_MODEL_LAST) {
-		printk(KERN_INFO "hda_codec: Unknown model for ALC268, "
-		       "trying auto-probe from BIOS...\n");
-		board_config = ALC268_AUTO;
-	}
-
-	if (board_config == ALC268_AUTO) {
-		/* automatic parse from the BIOS config */
-		err = alc268_parse_auto_config(codec);
-		if (err < 0) {
-			alc_free(codec);
-			return err;
-		} else if (!err) {
-			printk(KERN_INFO
-			       "hda_codec: Cannot set up configuration "
-			       "from BIOS.  Using base mode...\n");
-			board_config = ALC268_3ST;
-		}
-	}
-
-	if (board_config != ALC268_AUTO)
-		setup_preset(spec, &alc268_presets[board_config]);
-
-	spec->stream_name_analog = "ALC268 Analog";
-	spec->stream_analog_playback = &alc268_pcm_analog_playback;
-	spec->stream_analog_capture = &alc268_pcm_analog_capture;
-
-	spec->stream_name_digital = "ALC268 Digital";
-	spec->stream_digital_playback = &alc268_pcm_digital_playback;
-
-	if (board_config == ALC268_AUTO) {
-		if (!spec->adc_nids && spec->input_mux) {
-			/* check whether NID 0x07 is valid */
-			unsigned int wcap = get_wcaps(codec, 0x07);
-
-			/* get type */
-			wcap = (wcap & AC_WCAP_TYPE) >> AC_WCAP_TYPE_SHIFT;
-			if (wcap != AC_WID_AUD_IN) {
-				spec->adc_nids = alc268_adc_nids_alt;
-				spec->num_adc_nids =
-					ARRAY_SIZE(alc268_adc_nids_alt);
-				spec->mixers[spec->num_mixers] =
-					alc268_capture_alt_mixer;
-				spec->num_mixers++;
-			} else {
-				spec->adc_nids = alc268_adc_nids;
-				spec->num_adc_nids =
-					ARRAY_SIZE(alc268_adc_nids);
-				spec->mixers[spec->num_mixers] =
-					alc268_capture_mixer;
-				spec->num_mixers++;
-			}
-		}
-	}
-	codec->patch_ops = alc_patch_ops;
-	if (board_config == ALC268_AUTO)
-		spec->init_hook = alc268_auto_init;
-		
-	return 0;
-}
-
-/*
  *  ALC861 channel source setting (2/6 channel selection for 3-stack)
->>>>>>> /sound/pci/hda/patch_realtek.c
  */
 #define ALC268_DIGOUT_NID	ALC880_DIGOUT_NID
 #define alc268_modes		alc260_modes
diff -puN sound/soc/s3c24xx/Kconfig~git-alsa-fixup sound/soc/s3c24xx/Kconfig
--- a/sound/soc/s3c24xx/Kconfig~git-alsa-fixup
+++ a/sound/soc/s3c24xx/Kconfig
@@ -9,34 +9,6 @@ config SND_S3C24XX_SOC
 
 config SND_S3C24XX_SOC_I2S
 	tristate
-<<<<<<< HEAD/sound/soc/s3c24xx/Kconfig
-
-config SND_S3C2443_SOC_AC97
-	tristate
-	select AC97_BUS
-	select SND_AC97_CODEC
-	select SND_SOC_AC97_BUS
-	
-config SND_S3C24XX_SOC_NEO1973_WM8753
-	tristate "SoC I2S Audio support for NEO1973 - WM8753"
-	depends on SND_S3C24XX_SOC && MACH_GTA01
-	select SND_S3C24XX_SOC_I2S
-	select SND_SOC_WM8753
-	help
-	  Say Y if you want to add support for SoC audio on smdk2440
-	  with the WM8753.
-
-config SND_S3C24XX_SOC_SMDK2443_WM9710
-	tristate "SoC AC97 Audio support for SMDK2443 - WM9710"
-	depends on SND_S3C24XX_SOC && MACH_SMDK2443
-	select SND_S3C2443_SOC_AC97
-	select SND_SOC_AC97_CODEC
-	help
-	  Say Y if you want to add support for SoC audio on smdk2443
-	  with the WM9710.
-
-
-=======
 
 config SND_S3C2443_SOC_AC97
 	tristate
@@ -62,5 +34,3 @@ config SND_S3C24XX_SOC_SMDK2443_WM9710
 	  Say Y if you want to add support for SoC audio on smdk2443
 	  with the WM9710.
 
-
->>>>>>> /sound/soc/s3c24xx/Kconfig
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-stk17ta8-update-for-sysfs-api-change.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
mmc-build-fix.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
git-net.patch
ip_auto_config-fix-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-scsi-target-fixup.patch
git-unionfs.patch
git-watchdog.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
