From: akpm@linux-foundation.org
Subject: [merged] rtc-max77686-use-ffs-to-calculate-tm_wday.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:20:46 -0700
Message-ID: <543d697e.0Y7DRjBE1OTJ9dlv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaJNSUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.martinez@collabora.co.uk, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: max77686: Use ffs() to calculate tm_wday
has been removed from the -mm tree.  Its filename was
     rtc-max77686-use-ffs-to-calculate-tm_wday.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: rtc: max77686: Use ffs() to calculate tm_wday

max77686_rtc_calculate_wday() is used to calculate the day of the week to
be filled in struct rtc_time but that function only calculates the number
of bits shifted.  So the ffs() function can be used to find the first bit
set instead of a special function.

[akpm@linux-foundation.org: add comment clarifying ffs() use]
Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-use-ffs-to-calculate-tm_wday drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-use-ffs-to-calculate-tm_wday
+++ a/drivers/rtc/rtc-max77686.c
@@ -70,16 +70,6 @@ enum MAX77686_RTC_OP {
 	MAX77686_RTC_READ,
 };
 
-static inline int max77686_rtc_calculate_wday(u8 shifted)
-{
-	int counter = -1;
-	while (shifted) {
-		shifted >>= 1;
-		counter++;
-	}
-	return counter;
-}
