From: akpm@linux-foundation.org
Subject: + w1-remove-unused-and-confusing-variable.patch added to -mm tree
Date: Fri, 11 Jan 2008 16:18:40 -0800
Message-ID: <200801120018.m0C0IeHi005128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760225AbYALAZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 19:25:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnpol@2ka.mipt.ru, hjm03r@ecs.soton.ac.uk


The patch titled
     w1: remove unused and confusing variable.
has been added to the -mm tree.  Its filename is
     w1-remove-unused-and-confusing-variable.patch

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
Subject: w1: remove unused and confusing variable.
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Remvoe variable which actually is not used (except assigning it a value)
and confusing break out of the family checking loop.  Found by Harry Mason.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Harry J Mason <hjm03r@ecs.soton.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/w1/w1.c~w1-remove-unused-and-confusing-variable drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-remove-unused-and-confusing-variable
+++ a/drivers/w1/w1.c
@@ -675,7 +675,6 @@ static void w1_slave_found(void *data, u
 	struct w1_slave *sl;
 	struct list_head *ent;
 	struct w1_reg_num *tmp;
-	int family_found = 0;
 	struct w1_master *dev;
 	u64 rn_le = cpu_to_le64(rn);
 
@@ -698,9 +697,6 @@ static void w1_slave_found(void *data, u
 		    sl->reg_num.crc == tmp->crc) {
 			set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
 			break;
-		} else if (sl->reg_num.family == tmp->family) {
-			family_found = 1;
-			break;
 		}
 
 		slave_count++;
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

w1-decrement-slave-counter-only-in-release-callback.patch
git-cryptodev.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
ds1wm-decouple-host-irq-and-intr-active-state-settings.patch
w1-remove-unused-and-confusing-variable.patch
