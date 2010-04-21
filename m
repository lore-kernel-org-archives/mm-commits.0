From: akpm@linux-foundation.org
Subject: + max732x-correct-nr_port-checking-off-by-one-error.patch added to -mm tree
Date: Wed, 21 Apr 2010 14:55:58 -0700
Message-ID: <201004212155.o3LLtwHu011752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756811Ab0DUV5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 17:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, ben-linux@fluff.org, eric.miao@marvell.com


The patch titled
     max732x: correct nr_port checking off by one error
has been added to the -mm tree.  Its filename is
     max732x-correct-nr_port-checking-off-by-one-error.patch

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
Subject: max732x: correct nr_port checking off by one error
From: Axel Lin <axel.lin@gmail.com>

Setup both client_group_a and client_group_b if nr_port > 8 (not including
nr_port==8).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max732x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/max732x.c~max732x-correct-nr_port-checking-off-by-one-error drivers/gpio/max732x.c
--- a/drivers/gpio/max732x.c~max732x-correct-nr_port-checking-off-by-one-error
+++ a/drivers/gpio/max732x.c
@@ -285,14 +285,14 @@ static int __devinit max732x_probe(struc
 	switch (client->addr & 0x70) {
 	case 0x60:
 		chip->client_group_a = client;
-		if (nr_port > 7) {
+		if (nr_port > 8) {
 			c = i2c_new_dummy(client->adapter, addr_b);
 			chip->client_group_b = chip->client_dummy = c;
 		}
 		break;
 	case 0x50:
 		chip->client_group_b = client;
-		if (nr_port > 7) {
+		if (nr_port > 8) {
 			c = i2c_new_dummy(client->adapter, addr_a);
 			chip->client_group_a = chip->client_dummy = c;
 		}
@@ -307,7 +307,7 @@ static int __devinit max732x_probe(struc
 	mutex_init(&chip->lock);
 
 	max732x_read(chip, is_group_a(chip, 0), &chip->reg_out[0]);
-	if (nr_port > 7)
+	if (nr_port > 8)
 		max732x_read(chip, is_group_a(chip, 8), &chip->reg_out[1]);
 
 	ret = gpiochip_add(&chip->gpio_chip);
_

Patches currently in -mm which might be from axel.lin@gmail.com are

linux-next.patch
pl061-fix-offset-value-range-checking.patch
max732x-correct-nr_port-checking-off-by-one-error.patch

