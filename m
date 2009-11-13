From: akpm@linux-foundation.org
Subject: [merged] rtc-v3020-fix-v3020_mmio_read_bit.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:17 -0800
Message-ID: <200911131927.nADJRHmv030242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757227AbZKMT2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:28:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: svalentine@concentris-systems.com, a.zummo@towertech.it, p_gortmaker@yahoo.com, raph@8d.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc: v3020: fix v3020_mmio_read_bit()
has been removed from the -mm tree.  Its filename was
     rtc-v3020-fix-v3020_mmio_read_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: v3020: fix v3020_mmio_read_bit()
From: "Scott Valentine" <svalentine@concentris-systems.com>

v3020_mmio_read_bit() always returns 0 when left_shift > 7.

v3020_mmio_read_bit()'s return type is (unsigned char).  The code returns
a value masked by (1 << left_shift) that is casted to the return type.  If
left_shift is larger than 7, the cast will always result in a 0 return
value.  The problem was discovered with left_shift = 16, and the included
patch corrects the problem.

The bug was introduced in the last (Apr 3 2009) commit of the file, kernel
versions 2.6.30 and later.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Raphael Assenat <raph@8d.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/rtc/rtc-v3020.c~rtc-v3020-fix-v3020_mmio_read_bit drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-v3020-fix-v3020_mmio_read_bit
+++ a/drivers/rtc/rtc-v3020.c
@@ -96,7 +96,7 @@ static void v3020_mmio_write_bit(struct 
 
 static unsigned char v3020_mmio_read_bit(struct v3020 *chip)
 {
-	return readl(chip->ioaddress) & (1 << chip->leftshift);
+	return !!(readl(chip->ioaddress) & (1 << chip->leftshift));
 }
 
 static struct v3020_chip_ops v3020_mmio_ops = {
_

Patches currently in -mm which might be from svalentine@concentris-systems.com are


