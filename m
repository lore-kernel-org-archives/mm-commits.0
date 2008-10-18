From: akpm@linux-foundation.org
Subject: - w1-ds1wmc-msleep-for-reset.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:05 -0700
Message-ID: <200810182320.m9INK5Qu029662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906AbYJRXUZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: ds1wm.c msleep for reset
has been removed from the -mm tree.  Its filename was
     w1-ds1wmc-msleep-for-reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: ds1wm.c msleep for reset
From: David Fries <david@fries.net>

Like the previous w1_io.c reset coments and msleep patch, I don't have the
hardware to verify the change, but I think it is safe.  It also helps to
see a comment like this in the code.  "We'll wait a bit longer just to be
sure." If they are going to calculate delaying 324.9us, but actually delay
500us, why not just give up the CPU and sleep?  This is designed for a
battery powered ARM system, avoiding busywaiting has to be good for
battery life.

I sent a request for testers March 7, 2008 to the Linux kernel mailing
list and two developers who have patches for ds1wm.c, but I didn't get
any respons.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/w1/masters/ds1wm.c~w1-ds1wmc-msleep-for-reset drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~w1-ds1wmc-msleep-for-reset
+++ a/drivers/w1/masters/ds1wm.c
@@ -160,8 +160,10 @@ static int ds1wm_reset(struct ds1wm_data
 	 *     625 us - 60 us - 240 us - 100 ns = 324.9 us
 	 *
 	 * We'll wait a bit longer just to be sure.
+	 * Was udelay(500), but if it is going to busywait the cpu that long,
+	 * might as well come back later.
 	 */
-	udelay(500);
+	msleep(1);
 
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
 		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
_

Patches currently in -mm which might be from david@fries.net are

origin.patch

