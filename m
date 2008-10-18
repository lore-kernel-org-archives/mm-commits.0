From: akpm@linux-foundation.org
Subject: - char-ds1286-eliminate-busy-waiting.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:55 -0700
Message-ID: <200810182318.m9INItJV029374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYJRXTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Char: ds1286, eliminate busy waiting
has been removed from the -mm tree.  Its filename was
     char-ds1286-eliminate-busy-waiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: ds1286, eliminate busy waiting
From: Jiri Slaby <jirislaby@gmail.com>

ds1286_get_time(); is not called from atomic context, sleep for 20 ms is
better choice than a (home-made) busy waiting for such a situation.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ds1286.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/char/ds1286.c~char-ds1286-eliminate-busy-waiting drivers/char/ds1286.c
--- a/drivers/char/ds1286.c~char-ds1286-eliminate-busy-waiting
+++ a/drivers/char/ds1286.c
@@ -443,7 +443,6 @@ static void ds1286_get_time(struct rtc_t
 {
 	unsigned char save_control;
 	unsigned long flags;
-	unsigned long uip_watchdog = jiffies;
 
 	/*
 	 * read RTC once any update in progress is done. The update
@@ -456,8 +455,7 @@ static void ds1286_get_time(struct rtc_t
 	 */
 
 	if (ds1286_is_updating() != 0)
-		while (time_before(jiffies, uip_watchdog + 2*HZ/100))
-			barrier();
+		msleep(20);
 
 	/*
 	 * Only the values that we read from the RTC are set. We leave
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-sx-remove-bogus-iomap.patch

