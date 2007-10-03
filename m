From: akpm@linux-foundation.org
Subject: - fix-mux-setup-for-composite-sound-on-avertv-307.patch removed from -mm tree
Date: Wed, 03 Oct 2007 10:22:52 -0700
Message-ID: <200710031722.l93HMq8f032070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbXJCRXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 13:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stsp@aknet.ru, mchehab@infradead.org, nshmyrev@yandex.ru, peter.missel@onlinehome.de, zolotarev_andrey@mail.ru, mm-commits@vger.kernel.org


The patch titled
     fix mux setup for composite sound on AverTV 307
has been removed from the -mm tree.  Its filename was
     fix-mux-setup-for-composite-sound-on-avertv-307.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix mux setup for composite sound on AverTV 307
From: Stas Sergeev <stsp@aknet.ru>

Right now the composite sound input doesn't work on AverTV 307 because of
the wrong mux setup.  The composite sound is routed via an external
4channel multiplexer controlled by GPIO, while the code assumes an internal
multiplexer instead.

Presumably this was a copy/paste error, and noone have ever tested the
functionality.

With the attached patch it works properly, which gives me an ability to
finally watch the cable TV under linux.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Cc: Nickolay V. Shmyrev <nshmyrev@yandex.ru>
Cc: Andrey Zolotarev <zolotarev_andrey@mail.ru>
Cc: Peter Missel <peter.missel@onlinehome.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/saa7134/saa7134-cards.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/media/video/saa7134/saa7134-cards.c~fix-mux-setup-for-composite-sound-on-avertv-307 drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c~fix-mux-setup-for-composite-sound-on-avertv-307
+++ a/drivers/media/video/saa7134/saa7134-cards.c
@@ -3164,18 +3164,18 @@ struct saa7134_board saa7134_boards[] = 
 		},{
 			.name = name_comp1,
 			.vmux = 0,
-			.amux = LINE2,
-			.gpio = 0x00,
+			.amux = LINE1,
+			.gpio = 0x02,
 		},{
 			.name = name_comp2,
 			.vmux = 3,
-			.amux = LINE2,
-			.gpio = 0x00,
+			.amux = LINE1,
+			.gpio = 0x02,
 		},{
 			.name = name_svideo,
 			.vmux = 8,
-			.amux = LINE2,
-			.gpio = 0x00,
+			.amux = LINE1,
+			.gpio = 0x02,
 		}},
 		.radio = {
 			.name = name_radio,
_

Patches currently in -mm which might be from stsp@aknet.ru are

git-dvb.patch
fix-mux-setup-for-composite-sound-on-avertv-307.patch
