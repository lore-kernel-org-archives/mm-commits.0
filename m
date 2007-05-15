From: akpm@linux-foundation.org
Subject: - v4l-saa7134-add-support-for-10moons-tm300-card.patch removed from -mm tree
Date: Tue, 15 May 2007 01:49:47 -0700
Message-ID: <200705150849.l4F8nlLc005540@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758527AbXEOIt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 04:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wankai@sjtu.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l: saa7134: add support for 10moons TM300 card
has been removed from the -mm tree.  Its filename was
     v4l-saa7134-add-support-for-10moons-tm300-card.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: v4l: saa7134: add support for 10moons TM300 card
From: Tony Wan <wankai@sjtu.org>

Support the 10moons TM300 TV card (so called TV Master 3), which is a 10moons
saa7130 based board.  Here not include features for the IR-remote.

It has been tested using TVTIME.  The card was auto-detected and all the input
sources worked correct with sound.

Signed-off-by: Tony Wan <wankai@sjtu.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-cards.c |   38 ++++++++++++++++++
 drivers/media/video/saa7134/saa7134.h       |    1 
 2 files changed, 39 insertions(+)

diff -puN drivers/media/video/saa7134/saa7134-cards.c~v4l-saa7134-add-support-for-10moons-tm300-card drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c~v4l-saa7134-add-support-for-10moons-tm300-card
+++ a/drivers/media/video/saa7134/saa7134-cards.c
@@ -3502,6 +3502,38 @@ struct saa7134_board saa7134_boards[] = 
 			.amux = TV,
 		},
 	},
+	[SAA7134_BOARD_10MOONSTVMASTER3] = {
+		/* Tony Wan <aloha_cn@hotmail.com> */
+		.name           = "10MOONS TM300 TV Card",
+		.audio_clock    = 0x00200000,
+		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.gpiomask       = 0x7000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = LINE2,
+			.gpio = 0x0000,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+			.gpio = 0x2000,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+			.gpio = 0x2000,
+		}},
+		.mute = {
+			.name = name_mute,
+			.amux = LINE2,
+			.gpio = 0x3000,
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -4219,6 +4251,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subdevice    = 0x2003, /* OEM cardbus */
 		.driver_data  = SAA7134_BOARD_SABRENT_TV_PCB05,
 	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+		.subvendor    = PCI_VENDOR_ID_PHILIPS,
+		.subdevice    = 0x2304,
+		.driver_data  = SAA7134_BOARD_10MOONSTVMASTER3,
+	},{
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
diff -puN drivers/media/video/saa7134/saa7134.h~v4l-saa7134-add-support-for-10moons-tm300-card drivers/media/video/saa7134/saa7134.h
--- a/drivers/media/video/saa7134/saa7134.h~v4l-saa7134-add-support-for-10moons-tm300-card
+++ a/drivers/media/video/saa7134/saa7134.h
@@ -238,6 +238,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_ECS_TVP3XP_4CB6  113
 #define SAA7134_BOARD_KWORLD_DVBT_210 114
 #define SAA7134_BOARD_SABRENT_TV_PCB05     115
+#define SAA7134_BOARD_10MOONSTVMASTER3     116
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8
_

Patches currently in -mm which might be from wankai@sjtu.org are

git-dvb.patch
