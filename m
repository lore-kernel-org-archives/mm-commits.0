From: akpm@linux-foundation.org
Subject: - i8k-make-fan-multiplier-tunable-with-a-module-parameter.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:51 -0700
Message-ID: <200805021942.m42Jgp3A011231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764608AbYEBTnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jochen@penguin-breeder.org, mm-commits@vger.kernel.org


The patch titled
     i8k: make fan multiplier tunable with a module parameter
has been removed from the -mm tree.  Its filename was
     i8k-make-fan-multiplier-tunable-with-a-module-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i8k: make fan multiplier tunable with a module parameter
From: Jochen Eisinger <jochen@penguin-breeder.org>

The i8k driver multiplies the fan speed reported by the BIOS with a factor of
30.  On my Dell Latitude D800, this factor is not required.

I'd suggest to make this configurable.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/char/i8k.c~i8k-make-fan-multiplier-tunable-with-a-module-parameter drivers/char/i8k.c
--- a/drivers/char/i8k.c~i8k-make-fan-multiplier-tunable-with-a-module-parameter
+++ a/drivers/char/i8k.c
@@ -77,6 +77,10 @@ static int power_status;
 module_param(power_status, bool, 0600);
 MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
 
+static int fan_mult = I8K_FAN_MULT;
+module_param(fan_mult, int, 0);
+MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
+
 static int i8k_open_fs(struct inode *inode, struct file *file);
 static int i8k_ioctl(struct inode *, struct file *, unsigned int,
 		     unsigned long);
@@ -239,7 +243,7 @@ static int i8k_get_fan_speed(int fan)
 	struct smm_regs regs = { .eax = I8K_SMM_GET_SPEED, };
 
 	regs.ebx = fan & 0xff;
-	return i8k_smm(&regs) ? : (regs.eax & 0xffff) * I8K_FAN_MULT;
+	return i8k_smm(&regs) ? : (regs.eax & 0xffff) * fan_mult;
 }
 
 /*
_

Patches currently in -mm which might be from jochen@penguin-breeder.org are

origin.patch

