From: akpm@linux-foundation.org
Subject: + wm971x-check-for-pen-up-on-both-axes.patch added to -mm tree
Date: Mon, 31 Mar 2008 15:55:37 -0700
Message-ID: <200803312255.m2VMtbft030213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290AbYCaWzv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 18:55:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lars@segv.dk, broonie@opensource.wolfsonmicro.com, dtor@mail.ru


The patch titled
     wm971x: check for pen up on both axes
has been added to the -mm tree.  Its filename is
     wm971x-check-for-pen-up-on-both-axes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wm971x: check for pen up on both axes
From: Lars Munch <lars@segv.dk>

This prevents sending wrong Y coordinates if pen up happens exactly between
sampling for X coordinates and Y coordinates.

Signed-off-by: Lars Munch <lars@segv.dk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm9712.c |    2 +-
 drivers/input/touchscreen/wm9713.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/touchscreen/wm9712.c~wm971x-check-for-pen-up-on-both-axes drivers/input/touchscreen/wm9712.c
--- a/drivers/input/touchscreen/wm9712.c~wm971x-check-for-pen-up-on-both-axes
+++ a/drivers/input/touchscreen/wm9712.c
@@ -362,7 +362,7 @@ static int wm9712_poll_coord(struct wm97
 	if (pil && !(data->p & WM97XX_ADCSEL_PRES))
 		goto err;
 
-	if (!(data->x & WM97XX_PEN_DOWN)) {
+	if (!(data->x & WM97XX_PEN_DOWN) || !(data->y & WM97XX_PEN_DOWN)) {
 		wm->pen_probably_down = 0;
 		return RC_PENUP;
 	}
diff -puN drivers/input/touchscreen/wm9713.c~wm971x-check-for-pen-up-on-both-axes drivers/input/touchscreen/wm9713.c
--- a/drivers/input/touchscreen/wm9713.c~wm971x-check-for-pen-up-on-both-axes
+++ a/drivers/input/touchscreen/wm9713.c
@@ -359,7 +359,7 @@ static int wm9713_poll_coord(struct wm97
 	if (pil && !(data->p & WM97XX_ADCSEL_PRES))
 		goto err;
 
-	if (!(data->x & WM97XX_PEN_DOWN)) {
+	if (!(data->x & WM97XX_PEN_DOWN) || !(data->y & WM97XX_PEN_DOWN)) {
 		wm->pen_probably_down = 0;
 		return RC_PENUP;
 	}
_

Patches currently in -mm which might be from lars@segv.dk are

wm971x-check-for-pen-up-on-both-axes.patch

