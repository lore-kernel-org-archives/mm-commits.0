From: akpm@linux-foundation.org
Subject: - alsa-fix-isa_bus-conversion.patch removed from -mm tree
Date: Wed, 16 May 2007 20:47:39 -0700
Message-ID: <200705170347.l4H3lcQ9016526@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758687AbXEQDuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 23:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rene.herman@gmail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: fix isa_bus conversion
has been removed from the -mm tree.  Its filename was
     alsa-fix-isa_bus-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: alsa: fix isa_bus conversion
From: Rene Herman <rene.herman@gmail.com>

The conversion of the mixed legacy/pnp ALSA drivers to the isa_bus
framework is not quite right.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/isa/cmi8330.c             |   15 +++++++++++----
 sound/isa/cs423x/cs4236.c       |   20 ++++++++++++++------
 sound/isa/es18xx.c              |   19 +++++++++++++------
 sound/isa/gus/interwave.c       |   15 ++++++++++-----
 sound/isa/opl3sa2.c             |   15 +++++++++++----
 sound/isa/sb/sb16.c             |   15 ++++++++++-----
 sound/isa/sscape.c              |   28 +++++++++++++++-------------
 sound/isa/wavefront/wavefront.c |   14 ++++++++++----
 8 files changed, 94 insertions(+), 47 deletions(-)

diff -puN sound/isa/cmi8330.c~alsa-fix-isa_bus-conversion sound/isa/cmi8330.c
--- a/sound/isa/cmi8330.c~alsa-fix-isa_bus-conversion
+++ a/sound/isa/cmi8330.c
@@ -109,6 +109,7 @@ module_param_array(wssdma, int, NULL, 04
 MODULE_PARM_DESC(wssdma, "DMA for CMI8330 WSS driver.");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 #endif
 
@@ -686,14 +687,18 @@ static int __init alsa_card_cmi8330_init
 	int err;
 
 	err = isa_register_driver(&snd_cmi8330_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_card_driver(&cmi8330_pnpc_driver);
 	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_cmi8330_exit(void)
@@ -701,8 +706,10 @@ static void __exit alsa_card_cmi8330_exi
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&cmi8330_pnpc_driver);
+
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_cmi8330_driver);
+		isa_unregister_driver(&snd_cmi8330_driver);
 }
 
 module_init(alsa_card_cmi8330_init)
diff -puN sound/isa/cs423x/cs4236.c~alsa-fix-isa_bus-conversion sound/isa/cs423x/cs4236.c
--- a/sound/isa/cs423x/cs4236.c~alsa-fix-isa_bus-conversion
+++ a/sound/isa/cs423x/cs4236.c
@@ -127,6 +127,7 @@ module_param_array(dma2, int, NULL, 0444
 MODULE_PARM_DESC(dma2, "DMA2 # for " IDENT " driver.");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnpc_registered;
 #ifdef CS4232
 static int pnp_registered;
@@ -770,9 +771,9 @@ static int __init alsa_card_cs423x_init(
 	int err;
 
 	err = isa_register_driver(&cs423x_isa_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
 #ifdef CS4232
 	err = pnp_register_driver(&cs4232_pnp_driver);
 	if (!err)
@@ -781,8 +782,14 @@ static int __init alsa_card_cs423x_init(
 	err = pnp_register_card_driver(&cs423x_pnpc_driver);
 	if (!err)
 		pnpc_registered = 1;
-#endif /* CONFIG_PNP */
-	return 0;
+#ifdef CS4232
+	if (pnp_registered)
+		err = 0;
+#endif
+	if (isa_registered)
+		err = 0;
+#endif
+	return err;
 }
 
 static void __exit alsa_card_cs423x_exit(void)
@@ -794,8 +801,9 @@ static void __exit alsa_card_cs423x_exit
 	if (pnp_registered)
 		pnp_unregister_driver(&cs4232_pnp_driver);
 #endif
-#endif /* CONFIG_PNP */
-	isa_unregister_driver(&cs423x_isa_driver);
+	if (isa_registered)
+#endif
+		isa_unregister_driver(&cs423x_isa_driver);
 }
 
 module_init(alsa_card_cs423x_init)
diff -puN sound/isa/es18xx.c~alsa-fix-isa_bus-conversion sound/isa/es18xx.c
--- a/sound/isa/es18xx.c~alsa-fix-isa_bus-conversion
+++ a/sound/isa/es18xx.c
@@ -2036,7 +2036,9 @@ module_param_array(dma2, int, NULL, 0444
 MODULE_PARM_DESC(dma2, "DMA 2 # for ES18xx driver.");
 
 #ifdef CONFIG_PNP
-static int pnp_registered, pnpc_registered;
+static int isa_registered;
+static int pnp_registered;
+static int pnpc_registered;
 
 static struct pnp_device_id snd_audiodrive_pnpbiosids[] = {
 	{ .id = "ESS1869" },
@@ -2466,18 +2468,22 @@ static int __init alsa_card_es18xx_init(
 	int err;
 
 	err = isa_register_driver(&snd_es18xx_isa_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
-
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_driver(&es18xx_pnp_driver);
 	if (!err)
 		pnp_registered = 1;
+
 	err = pnp_register_card_driver(&es18xx_pnpc_driver);
 	if (!err)
 		pnpc_registered = 1;
+
+	if (isa_registered || pnp_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_es18xx_exit(void)
@@ -2487,8 +2493,9 @@ static void __exit alsa_card_es18xx_exit
 		pnp_unregister_card_driver(&es18xx_pnpc_driver);
 	if (pnp_registered)
 		pnp_unregister_driver(&es18xx_pnp_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_es18xx_isa_driver);
+		isa_unregister_driver(&snd_es18xx_isa_driver);
 }
 
 module_init(alsa_card_es18xx_init)
diff -puN sound/isa/gus/interwave.c~alsa-fix-isa_bus-conversion sound/isa/gus/interwave.c
--- a/sound/isa/gus/interwave.c~alsa-fix-isa_bus-conversion
+++ a/sound/isa/gus/interwave.c
@@ -135,6 +135,7 @@ struct snd_interwave {
 
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 
 static struct pnp_card_device_id snd_interwave_pnpids[] = {
@@ -934,15 +935,18 @@ static int __init alsa_card_interwave_in
 	int err;
 
 	err = isa_register_driver(&snd_interwave_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
-	/* ISA PnP cards */
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_card_driver(&interwave_pnpc_driver);
 	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_interwave_exit(void)
@@ -950,8 +954,9 @@ static void __exit alsa_card_interwave_e
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&interwave_pnpc_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_interwave_driver);
+		isa_unregister_driver(&snd_interwave_driver);
 }
 
 module_init(alsa_card_interwave_init)
diff -puN sound/isa/opl3sa2.c~alsa-fix-isa_bus-conversion sound/isa/opl3sa2.c
--- a/sound/isa/opl3sa2.c~alsa-fix-isa_bus-conversion
+++ a/sound/isa/opl3sa2.c
@@ -92,6 +92,7 @@ module_param_array(opl3sa3_ymode, int, N
 MODULE_PARM_DESC(opl3sa3_ymode, "Speaker size selection for 3D Enhancement mode: Desktop/Large Notebook/Small Notebook/HiFi.");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 static int pnpc_registered;
 #endif
@@ -967,17 +968,22 @@ static int __init alsa_card_opl3sa2_init
 	int err;
 
 	err = isa_register_driver(&snd_opl3sa2_isa_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_driver(&opl3sa2_pnp_driver);
 	if (!err)
 		pnp_registered = 1;
+
 	err = pnp_register_card_driver(&opl3sa2_pnpc_driver);
 	if (!err)
 		pnpc_registered = 1;
+
+	if (isa_registered || pnp_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_opl3sa2_exit(void)
@@ -987,8 +993,9 @@ static void __exit alsa_card_opl3sa2_exi
 		pnp_unregister_card_driver(&opl3sa2_pnpc_driver);
 	if (pnp_registered)
 		pnp_unregister_driver(&opl3sa2_pnp_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_opl3sa2_isa_driver);
+		isa_unregister_driver(&snd_opl3sa2_isa_driver);
 }
 
 module_init(alsa_card_opl3sa2_init)
diff -puN sound/isa/sb/sb16.c~alsa-fix-isa_bus-conversion sound/isa/sb/sb16.c
--- a/sound/isa/sb/sb16.c~alsa-fix-isa_bus-conversion
+++ a/sound/isa/sb/sb16.c
@@ -129,6 +129,7 @@ MODULE_PARM_DESC(seq_ports, "Number of s
 #endif
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 #endif
 
@@ -702,15 +703,18 @@ static int __init alsa_card_sb16_init(vo
 	int err;
 
 	err = isa_register_driver(&snd_sb16_isa_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
-	/* PnP cards at last */
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_card_driver(&sb16_pnpc_driver);
 	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_sb16_exit(void)
@@ -718,8 +722,9 @@ static void __exit alsa_card_sb16_exit(v
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&sb16_pnpc_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_sb16_isa_driver);
+		isa_unregister_driver(&snd_sb16_isa_driver);
 }
 
 module_init(alsa_card_sb16_init)
diff -puN sound/isa/sscape.c~alsa-fix-isa_bus-conversion sound/isa/sscape.c
--- a/sound/isa/sscape.c~alsa-fix-isa_bus-conversion
+++ a/sound/isa/sscape.c
@@ -69,7 +69,9 @@ module_param_array(dma, int, NULL, 0444)
 MODULE_PARM_DESC(dma, "DMA # for SoundScape driver.");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
+
 static struct pnp_card_device_id sscape_pnpids[] = {
 	{ .id = "ENS3081", .devs = { { "ENS0000" } } },
 	{ .id = "" }	/* end */
@@ -1405,22 +1407,21 @@ static struct pnp_card_driver sscape_pnp
 
 static int __init sscape_init(void)
 {
-	int ret;
+	int err;
 
-	/*
-	 * First check whether we were passed any parameters.
-	 * These MUST take precedence over ANY automatic way
-	 * of allocating cards, because the operator is
-	 * S-P-E-L-L-I-N-G it out for us...
-	 */
-	ret = isa_register_driver(&snd_sscape_driver, SNDRV_CARDS);
-	if (ret < 0)
-		return ret;
+	err = isa_register_driver(&snd_sscape_driver, SNDRV_CARDS);
 #ifdef CONFIG_PNP
-	if (pnp_register_card_driver(&sscape_pnpc_driver) == 0)
+	if (!err)
+		isa_registered = 1;
+
+	err = pnp_register_card_driver(&sscape_pnpc_driver);
+	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit sscape_exit(void)
@@ -1428,8 +1429,9 @@ static void __exit sscape_exit(void)
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&sscape_pnpc_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_sscape_driver);
+		isa_unregister_driver(&snd_sscape_driver);
 }
 
 module_init(sscape_init);
diff -puN sound/isa/wavefront/wavefront.c~alsa-fix-isa_bus-conversion sound/isa/wavefront/wavefront.c
--- a/sound/isa/wavefront/wavefront.c~alsa-fix-isa_bus-conversion
+++ a/sound/isa/wavefront/wavefront.c
@@ -86,6 +86,7 @@ module_param_array(use_cs4232_midi, bool
 MODULE_PARM_DESC(use_cs4232_midi, "Use CS4232 MPU-401 interface (inaccessibly located inside your computer)");
 
 #ifdef CONFIG_PNP
+static int isa_registered;
 static int pnp_registered;
 
 static struct pnp_card_device_id snd_wavefront_pnpids[] = {
@@ -706,14 +707,18 @@ static int __init alsa_card_wavefront_in
 	int err;
 
 	err = isa_register_driver(&snd_wavefront_driver, SNDRV_CARDS);
-	if (err < 0)
-		return err;
 #ifdef CONFIG_PNP
+	if (!err)
+		isa_registered = 1;
+
 	err = pnp_register_card_driver(&wavefront_pnpc_driver);
 	if (!err)
 		pnp_registered = 1;
+
+	if (isa_registered)
+		err = 0;
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_wavefront_exit(void)
@@ -721,8 +726,9 @@ static void __exit alsa_card_wavefront_e
 #ifdef CONFIG_PNP
 	if (pnp_registered)
 		pnp_unregister_card_driver(&wavefront_pnpc_driver);
+	if (isa_registered)
 #endif
-	isa_unregister_driver(&snd_wavefront_driver);
+		isa_unregister_driver(&snd_wavefront_driver);
 }
 
 module_init(alsa_card_wavefront_init)
_

Patches currently in -mm which might be from rene.herman@gmail.com are

git-alsa.patch
