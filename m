From: akpm@linux-foundation.org
Subject: + fix-mux-setup-for-composite-sound-on-avertv-307.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:33:01 -0700
Message-ID: <200708202033.l7KKX1bp021726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764301AbXHTUeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stsp@aknet.ru, mchehab@infradead.org, nshmyrev@yandex.ru, peter.missel@onlinehome.de, zolotarev_andrey@mail.ru


The patch titled
     fix mux setup for composite sound on AverTV 307
has been added to the -mm tree.  Its filename is
     fix-mux-setup-for-composite-sound-on-avertv-307.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/media/video/saa7134/saa7134-cards.c~fix-mux-setup-for-composite-sound-on-avertv-307 drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c~fix-mux-setup-for-composite-sound-on-avertv-307
+++ a/drivers/media/video/saa7134/saa7134-cards.c
@@ -1537,18 +1537,18 @@ struct saa7134_board saa7134_boards[] = 
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

fix-mux-setup-for-composite-sound-on-avertv-307.patch
