From: akpm@linux-foundation.org
Subject: - drivers-media-radio-convert-to-generic-boolean-values.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:51:35 -0800
Message-ID: <200702071951.l17JpZ09025169@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33522 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161418AbXBGTvo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:51:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/media/radio/: Convert to generic boolean-values
has been removed from the -mm tree.  Its filename was
     drivers-media-radio-convert-to-generic-boolean-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/media/radio/: Convert to generic boolean-values
From: Richard Knutsson <ricknu-0@student.ltu.se>

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/radio-gemtek-pci.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN drivers/media/radio/radio-gemtek-pci.c~drivers-media-radio-convert-to-generic-boolean-values drivers/media/radio/radio-gemtek-pci.c
--- a/drivers/media/radio/radio-gemtek-pci.c~drivers-media-radio-convert-to-generic-boolean-values
+++ a/drivers/media/radio/radio-gemtek-pci.c
@@ -89,14 +89,6 @@ static struct v4l2_queryctrl radio_qctrl
 #define GEMTEK_PCI_RANGE_HIGH (108*16000)
 #endif
 
-#ifndef TRUE
-#define TRUE (1)
-#endif
-
-#ifndef FALSE
-#define FALSE (0)
-#endif
-
 struct gemtek_pci_card {
 	struct video_device *videodev;
 
@@ -146,12 +138,12 @@ static void __gemtek_pci_cmd( u16 value,
 
 static inline void gemtek_pci_nil( u32 port, u8 *last_byte )
 {
-	__gemtek_pci_cmd( 0x00, port, last_byte, FALSE );
+	__gemtek_pci_cmd( 0x00, port, last_byte, false );
 }
 
 static inline void gemtek_pci_cmd( u16 cmd, u32 port, u8 *last_byte )
 {
-	__gemtek_pci_cmd( cmd, port, last_byte, TRUE );
+	__gemtek_pci_cmd( cmd, port, last_byte, true );
 }
 
 static void gemtek_pci_setfrequency( struct gemtek_pci_card *card, unsigned long frequency )
@@ -184,14 +176,14 @@ static void gemtek_pci_setfrequency( str
 static inline void gemtek_pci_mute( struct gemtek_pci_card *card )
 {
 	outb( 0x1f, card->iobase );
-	card->mute = TRUE;
+	card->mute = true;
 }
 
 static inline void gemtek_pci_unmute( struct gemtek_pci_card *card )
 {
 	if ( card->mute ) {
 		gemtek_pci_setfrequency( card, card->current_frequency );
-		card->mute = FALSE;
+		card->mute = false;
 	}
 }
 
@@ -259,7 +251,7 @@ static int gemtek_pci_do_ioctl(struct in
 
 			gemtek_pci_setfrequency( card, f->frequency );
 			card->current_frequency = f->frequency;
-			card->mute = FALSE;
+			card->mute = false;
 			return 0;
 		}
 		case VIDIOC_QUERYCTRL:
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

git-dvb.patch
git-netdev-all.patch
drivers-scsi-buslogic-replace-boolean-by-bool.patch
git-cryptodev.patch
drivers-block-dac960-converted-boolean-to-bool.patch
include-linux-kernelh-remove-labs.patch
drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch
drivers-isdn-hisax-convert-to-generic-boolean-values.patch
drivers-video-sis-convert-to-generic-boolean.patch
