From: akpm@linux-foundation.org
Subject: - w1-recode-w1_slave_found-logic.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:54 -0700
Message-ID: <200810182319.m9INJsRK029580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbYJRXUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: recode w1_slave_found logic
has been removed from the -mm tree.  Its filename was
     w1-recode-w1_slave_found-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: recode w1_slave_found logic
From: David Fries <david@fries.net>

Simplified the logic in w1_slave_found by using the new
w1_attach_slave_device function to find a slave and mark it as active or
add the device if the crc checks.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff -puN drivers/w1/w1.c~w1-recode-w1_slave_found-logic drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-recode-w1_slave_found-logic
+++ a/drivers/w1/w1.c
@@ -845,9 +845,7 @@ void w1_reconnect_slaves(struct w1_famil
 
 static void w1_slave_found(struct w1_master *dev, u64 rn)
 {
-	int slave_count;
 	struct w1_slave *sl;
-	struct list_head *ent;
 	struct w1_reg_num *tmp;
 	u64 rn_le = cpu_to_le64(rn);
 
@@ -855,24 +853,12 @@ static void w1_slave_found(struct w1_mas
 
 	tmp = (struct w1_reg_num *) &rn;
 
-	slave_count = 0;
-	list_for_each(ent, &dev->slist) {
-
-		sl = list_entry(ent, struct w1_slave, w1_slave_entry);
-
-		if (sl->reg_num.family == tmp->family &&
-		    sl->reg_num.id == tmp->id &&
-		    sl->reg_num.crc == tmp->crc) {
-			set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
-			break;
-		}
-
-		slave_count++;
-	}
