From: akpm@linux-foundation.org
Subject: [merged] envctrl-ignore-orderly_poweroff-return-value.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:28 -0700
Message-ID: <552fe944.G0hEEMijeHEF6FW8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbbDPQs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joel@jms.id.au, benh@kernel.crashing.org, davem@davemloft.net, fabf@skynet.be, jk@ozlabs.org, mpe@ellerman.id.au, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/sbus/char/envctrl.c: ignore orderly_poweroff return value
has been removed from the -mm tree.  Its filename was
     envctrl-ignore-orderly_poweroff-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joel Stanley <joel@jms.id.au>
Subject: drivers/sbus/char/envctrl.c: ignore orderly_poweroff return value

orderly_poweroff() unconditionally returns 0, so remove the dead code that
checks the return value.

A future patch will change the return type to void.

Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sbus/char/bbc_envctrl.c |    3 +--
 drivers/sbus/char/envctrl.c     |    7 +------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/sbus/char/bbc_envctrl.c~envctrl-ignore-orderly_poweroff-return-value drivers/sbus/char/bbc_envctrl.c
--- a/drivers/sbus/char/bbc_envctrl.c~envctrl-ignore-orderly_poweroff-return-value
+++ a/drivers/sbus/char/bbc_envctrl.c
@@ -160,8 +160,7 @@ static void do_envctrl_shutdown(struct b
 	printk(KERN_CRIT "kenvctrld: Shutting down the system now.\n");
 
 	shutting_down = 1;
-	if (orderly_poweroff(true) < 0)
-		printk(KERN_CRIT "envctrl: shutdown execution failed\n");
+	orderly_poweroff(true);
 }
 
 #define WARN_INTERVAL	(30 * HZ)
diff -puN drivers/sbus/char/envctrl.c~envctrl-ignore-orderly_poweroff-return-value drivers/sbus/char/envctrl.c
--- a/drivers/sbus/char/envctrl.c~envctrl-ignore-orderly_poweroff-return-value
+++ a/drivers/sbus/char/envctrl.c
@@ -970,18 +970,13 @@ static struct i2c_child_t *envctrl_get_i
 static void envctrl_do_shutdown(void)
 {
 	static int inprog = 0;
-	int ret;
 
 	if (inprog != 0)
 		return;
 
 	inprog = 1;
 	printk(KERN_CRIT "kenvctrld: WARNING: Shutting down the system now.\n");
-	ret = orderly_poweroff(true);
-	if (ret < 0) {
-		printk(KERN_CRIT "kenvctrld: WARNING: system shutdown failed!\n"); 
-		inprog = 0;  /* unlikely to succeed, but we could try again */
-	}
+	orderly_poweroff(true);
 }
 
 static struct task_struct *kenvctrld_task;
_

Patches currently in -mm which might be from joel@jms.id.au are

origin.patch
linux-next.patch

