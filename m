From: akpm@linux-foundation.org
Subject: [merged] hpet-use-for_each_set_bit.patch removed from -mm tree
Date: Fri, 19 Mar 2010 12:49:08 -0400
Message-ID: <201003191949.o2JJnpaU009005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab0CSTuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 15:50:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, bob.picco@hp.com, clemens@ladisch.de, mm-commits@vger.kernel.org


The patch titled
     hpet: use for_each_set_bit()
has been removed from the -mm tree.  Its filename was
     hpet-use-for_each_set_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpet: use for_each_set_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/char/hpet.c~hpet-use-for_each_set_bit drivers/char/hpet.c
--- a/drivers/char/hpet.c~hpet-use-for_each_set_bit
+++ a/drivers/char/hpet.c
@@ -215,9 +215,7 @@ static void hpet_timer_set_irq(struct hp
 	else
 		v &= ~0xffff;
 
-	for (irq = find_first_bit(&v, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
-		irq = find_next_bit(&v, HPET_MAX_IRQ, 1 + irq)) {
