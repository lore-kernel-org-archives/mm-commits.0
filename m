From: akpm@osdl.org
Subject: - saa7134-add-support-for-the-encore-enl-tv.patch removed from -mm tree
Date: Thu, 21 Dec 2006 12:10:12 -0800
Message-ID: <200612212010.kBLKACoT003540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36529 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423072AbWLUUKR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:10:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stevenrwalter@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     saa7134: add support for the Encore ENL-TV
has been removed from the -mm tree.  Its filename was
     saa7134-add-support-for-the-encore-enl-tv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: saa7134: add support for the Encore ENL-TV
From: "Steven Walter" <stevenrwalter@gmail.com>

Add a board definition for the Encore ENL-TV card, and
adds its PCI subdevice to the ID table.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/saa7134/saa7134-cards.c |   24 ++++++++++++++++++
 drivers/media/video/saa7134/saa7134.h       |    1 
 2 files changed, 25 insertions(+)

diff -puN drivers/media/video/saa7134/saa7134-cards.c~saa7134-add-support-for-the-encore-enl-tv drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c~saa7134-add-support-for-the-encore-enl-tv
+++ a/drivers/media/video/saa7134/saa7134-cards.c
@@ -3177,6 +3177,24 @@ struct saa7134_board saa7134_boards[] = 
 			.amux   = LINE1,
 		}},
 	},
+	[SAA7134_BOARD_ENCORE_ENLTV] = {
+		/* Steven Walter <stevenrwalter@gmail.com> */
+		.name           = "Encore ENLTV",
+		.tuner_type     = TUNER_TNF_5335MF,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.inputs         = {{
+		        .name = name_tv,
+		        .vmux = 1,
+		        .amux = LINE2,
+		        .tv   = 1,
+		},{
+		        .name = name_svideo,
+		        .vmux = 6,
+		        .amux = LINE1,
+		}},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -3816,6 +3834,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subdevice    = 0x1172,
 		.driver_data  = SAA7134_BOARD_CINERGY_HT_PCMCIA,
 	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = PCI_VENDOR_ID_PHILIPS,
+		.subdevice    = 0x2342,
+		.driver_data  = SAA7134_BOARD_ENCORE_ENLTV,
+	},{
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff -puN drivers/media/video/saa7134/saa7134.h~saa7134-add-support-for-the-encore-enl-tv drivers/media/video/saa7134/saa7134.h
--- a/drivers/media/video/saa7134/saa7134.h~saa7134-add-support-for-the-encore-enl-tv
+++ a/drivers/media/video/saa7134/saa7134.h
@@ -232,6 +232,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_VIDEOMATE_DVBT_200A  103
 #define SAA7134_BOARD_HAUPPAUGE_HVR1110    104
 #define SAA7134_BOARD_CINERGY_HT_PCMCIA    105
+#define SAA7134_BOARD_ENCORE_ENLTV 106
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8
_

Patches currently in -mm which might be from stevenrwalter@gmail.com are

git-dvb.patch

