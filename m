From: akpm@linux-foundation.org
Subject: + drivers-input-touchscreen-ads7846c-optimize-order-of-calculating-rt-in-ads7846_rx.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:19:58 -0700
Message-ID: <200807130619.m6D6Jw28007609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbYGMGU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hans-christian.egtvedt@atmel.com, dbrownell@users.sourceforge.net, dtor@mail.ru, imre.deak@solidboot.com, juha.yrjola@solidboot.com, semih.hazar@indefia.com


The patch titled
     drivers/input/touchscreen/ads7846.c: optimize order of calculating Rt in ads7846_rx()
has been added to the -mm tree.  Its filename is
     drivers-input-touchscreen-ads7846c-optimize-order-of-calculating-rt-in-ads7846_rx.patch

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
Subject: drivers/input/touchscreen/ads7846.c: optimize order of calculating Rt in ads7846_rx()
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

Alter the if expression for calculating Rt.  The old implementation would
run unnecessary code when the ADS7843 device was used.

The patch also fixes the code style to kernel standard.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Imre Deak <imre.deak@solidboot.com>
Cc: Semih Hazar <semih.hazar@indefia.com>
Cc: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/input/touchscreen/ads7846.c~drivers-input-touchscreen-ads7846c-optimize-order-of-calculating-rt-in-ads7846_rx drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~drivers-input-touchscreen-ads7846c-optimize-order-of-calculating-rt-in-ads7846_rx
+++ a/drivers/input/touchscreen/ads7846.c
@@ -517,7 +517,9 @@ static void ads7846_rx(void *ads)
 	if (x == MAX_12BIT)
 		x = 0;
 
-	if (likely(x && z1)) {
+	if (ts->model == 7843) {
+		Rt = ts->pressure_max / 2;
+	} else if (likely(x && z1)) {
 		/* compute touch pressure resistance using equation #2 */
 		Rt = z2;
 		Rt -= z1;
@@ -525,11 +527,9 @@ static void ads7846_rx(void *ads)
 		Rt *= ts->x_plate_ohms;
 		Rt /= z1;
 		Rt = (Rt + 2047) >> 12;
-	} else
+	} else {
 		Rt = 0;
