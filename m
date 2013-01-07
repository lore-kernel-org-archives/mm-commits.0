From: akpm@linux-foundation.org
Subject: + drivers-video-ssd1307fbc-fix-bit-order-bug-in-the-byte-translation-function.patch added to -mm tree
Date: Mon, 07 Jan 2013 11:47:00 -0800
Message-ID: <20130107194700.B0E6982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:39291 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3AGTrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:47:02 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so1805483ghb.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:47:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxime.ripard@free-electrons.com, FlorianSchandinat@gmx.de, brian@crystalfontz.com, gregkh@linux-foundation.org, thomas@free-electrons.com, tomi.valkeinen@ti.com


The patch titled
     Subject: drivers/video/ssd1307fb.c: fix bit order bug in the byte translation function
has been added to the -mm tree.  Its filename is
     drivers-video-ssd1307fbc-fix-bit-order-bug-in-the-byte-translation-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-video-ssd1307fbc-fix-bit-order-bug-in-the-byte-translation-function.patch

