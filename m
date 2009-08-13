From: akpm@linux-foundation.org
Subject: [merged] drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j.patch removed from -mm tree
Date: Thu, 13 Aug 2009 12:19:34 -0700
Message-ID: <200908131919.n7DJJYUt012661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755428AbZHMTUV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 15:20:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vlasta.labsky@gmail.com, kraxel@bytesex.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/video/cx88/cx88: add support for WinFast DTV2000H rev. J
has been removed from the -mm tree.  Its filename was
     drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/media/video/cx88/cx88: add support for WinFast DTV2000H rev. J
From: Vlastimil Labsky <vlasta.labsky@gmail.com>

I updated and simplyfied patch from Zbynek Hrabovsky for recent kernel. 
It enables autodetection of card, sound in analog TV , sound in FM radio
and switching between antenna and cable RF input.  Radio tuner still
doesn't work, I don't even know how it works.  Some guys wrote me that FM
radio works with TV tuner used instead of radio part (symlink video0 ->
radio0).

Signed-off-by: Vlastimil Labsky <vlasta.labsky@gmail.com>
Cc: Gerd Knorr <kraxel@bytesex.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-cards.c |   49 ++++++++++++++++++++++++
 drivers/media/video/cx88/cx88-dvb.c   |    1 
 drivers/media/video/cx88/cx88-input.c |    1 
 drivers/media/video/cx88/cx88.h       |    1 
 4 files changed, 52 insertions(+)

diff -puN drivers/media/video/cx88/cx88-cards.c~drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j drivers/media/video/cx88/cx88-cards.c
--- a/drivers/media/video/cx88/cx88-cards.c~drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j
+++ a/drivers/media/video/cx88/cx88-cards.c
@@ -1283,6 +1283,51 @@ static const struct cx88_board cx88_boar
 		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_WINFAST_DTV2000H_J] = {
+		.name           = "WinFast DTV2000 H rev. J",
+		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.input          = {{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00017300,
+			.gpio1  = 0x00008207,
+			.gpio2	= 0x00000000,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00018300,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		},{
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x00018301,
+			.gpio1  = 0x0000f207,
+			.gpio2	= 0x00017304,
+			.gpio3  = 0x02000000,
+		}},
+		.radio = {
+			 .type  = CX88_RADIO,
+			 .gpio0 = 0x00015702,
+			 .gpio1 = 0x0000f207,
+			 .gpio2 = 0x00015702,
+			 .gpio3 = 0x02000000,
+		},
+		.mpeg           = CX88_MPEG_DVB,
+	},
 	[CX88_BOARD_GENIATECH_DVBS] = {
 		.name          = "Geniatech DVB-S",
 		.tuner_type    = TUNER_ABSENT,
@@ -2282,6 +2327,10 @@ static const struct cx88_subid cx88_subi
 		.subdevice = 0x665e,
 		.card      = CX88_BOARD_WINFAST_DTV2000H,
 	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6f2b,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_J,
+	},{
 		.subvendor = 0x18ac,
 		.subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
 		.card      = CX88_BOARD_DVICO_FUSIONHDTV_3_GOLD_Q,
diff -puN drivers/media/video/cx88/cx88-dvb.c~drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j drivers/media/video/cx88/cx88-dvb.c
--- a/drivers/media/video/cx88/cx88-dvb.c~drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j
+++ a/drivers/media/video/cx88/cx88-dvb.c
@@ -695,6 +695,7 @@ static int dvb_register(struct cx8802_de
 		}
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_J:
 	case CX88_BOARD_HAUPPAUGE_HVR1100:
 	case CX88_BOARD_HAUPPAUGE_HVR1100LP:
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
diff -puN drivers/media/video/cx88/cx88-input.c~drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j drivers/media/video/cx88/cx88-input.c
--- a/drivers/media/video/cx88/cx88-input.c~drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j
+++ a/drivers/media/video/cx88/cx88-input.c
@@ -225,6 +225,7 @@ int cx88_ir_init(struct cx88_core *core,
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_J:
 	case CX88_BOARD_WINFAST_DTV1800H:
 		ir_codes = ir_codes_winfast;
 		ir->gpio_addr = MO_GP0_IO;
diff -puN drivers/media/video/cx88/cx88.h~drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j drivers/media/video/cx88/cx88.h
--- a/drivers/media/video/cx88/cx88.h~drivers-media-video-cx88-cx88-add-support-for-winfast-dtv2000h-rev-j
+++ a/drivers/media/video/cx88/cx88.h
@@ -237,6 +237,7 @@ extern struct sram_channel cx88_sram_cha
 #define CX88_BOARD_TERRATEC_CINERGY_HT_PCI_MKII 79
 #define CX88_BOARD_HAUPPAUGE_IRONLY        80
 #define CX88_BOARD_WINFAST_DTV1800H        81
+#define CX88_BOARD_WINFAST_DTV2000H_J      82
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
_

Patches currently in -mm which might be from vlasta.labsky@gmail.com are

linux-next.patch

