From: akpm@linux-foundation.org
Subject: + hpet-use-for_each_set_bit.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:25:57 -0800
Message-ID: <201002012225.o11MPvcJ016291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556Ab0BAW0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:26:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, bob.picco@hp.com, clemens@ladisch.de


The patch titled
     hpet: use for_each_set_bit()
has been added to the -mm tree.  Its filename is
     hpet-use-for_each_set_bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
