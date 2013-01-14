From: akpm@linux-foundation.org
Subject: [merged] drivers-video-ssd1307fbc-fix-bit-order-bug-in-the-byte-translation-function.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:38:19 -0800
Message-ID: <20130114203819.B45A582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:65057 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab3ANUiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:38:20 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so537372yen.4
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:38:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxime.ripard@free-electrons.com, FlorianSchandinat@gmx.de, brian@crystalfontz.com, gregkh@linux-foundation.org, thomas@free-electrons.com, tomi.valkeinen@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/ssd1307fb.c: fix bit order bug in the byte translation function
has been removed from the -mm tree.  Its filename was
     drivers-video-ssd1307fbc-fix-bit-order-bug-in-the-byte-translation-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: drivers/video/ssd1307fb.c: fix bit order bug in the byte translation function

This was leading to a strange behaviour when using the fbcon driver on top
of this one: the letters were in the right order, but each letter had a
vertical symmetry.

This was because the addressing was right for the byte, but the addressing
of each individual bit was inverted.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Brian Lilly <brian@crystalfontz.com>
Cc: Greg Kroah-Hartman <gregkh@linux-foundation.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Thomas Petazzoni <thomas@free-electrons.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ssd1307fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/ssd1307fb.c~drivers-video-ssd1307fbc-fix-bit-order-bug-in-the-byte-translation-function drivers/video/ssd1307fb.c
--- a/drivers/video/ssd1307fb.c~drivers-video-ssd1307fbc-fix-bit-order-bug-in-the-byte-translation-function
+++ a/drivers/video/ssd1307fb.c
@@ -145,8 +145,8 @@ static void ssd1307fb_update_display(str
 				u32 page_length = SSD1307FB_WIDTH * i;
 				u32 index = page_length + (SSD1307FB_WIDTH * k + j) / 8;
 				u8 byte = *(vmem + index);
-				u8 bit = byte & (1 << (7 - (j % 8)));
-				bit = bit >> (7 - (j % 8));
+				u8 bit = byte & (1 << (j % 8));
+				bit = bit >> (j % 8);
 				buf |= bit << k;
 			}
 			ssd1307fb_write_data(par->client, buf);
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

origin.patch
linux-next.patch

