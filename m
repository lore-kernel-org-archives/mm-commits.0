From: akpm@linux-foundation.org
Subject: + alpha-fix-boot-mainc-warning.patch added to -mm tree
Date: Mon, 30 Jul 2007 13:27:15 -0700
Message-ID: <200707302027.l6UKRFgW028981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937364AbXG3U2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 16:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mroos@linux.ee, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net


The patch titled
     alpha: fix boot/main.c warning
has been added to the -mm tree.  Its filename is
     alpha-fix-boot-mainc-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alpha: fix boot/main.c warning
From: Meelis Roos <mroos@linux.ee>

In current 2.6.23-rc1+git, make bootimage gives the following warning while
compiling arch/alpha/boot/main.c.  The patch below fixes the warning by
casting callback argument explicitly to void*.  The original value comes from
START_ADDR macro and is clearly numeric so only cast it for the callback.

  CC      arch/alpha/boot/main.o
arch/alpha/boot/main.c: In function 'load':
arch/alpha/boot/main.c:135: warning: passing argument 3 of 'callback_read' makes pointer from integer without a cast

Signed-off-by: Meelis Roos <mroos@linux.ee>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/boot/main.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/alpha/boot/main.c~alpha-fix-boot-mainc-warning arch/alpha/boot/main.c
--- a/arch/alpha/boot/main.c~alpha-fix-boot-mainc-warning
+++ a/arch/alpha/boot/main.c
@@ -132,7 +132,7 @@ static inline long load(long dev, unsign
 	if (result)
 		srm_printk("Boot file specification (%s) not implemented\n",
 		       bootfile);
-	return callback_read(dev, count, addr, boot_size/512 + 1);
+	return callback_read(dev, count, (void *)addr, boot_size/512 + 1);
 }
 
 /*
_

Patches currently in -mm which might be from mroos@linux.ee are

alpha-fix-mkbb-compilation-warnings.patch
alpha-fix-objstripc-compilation-warnings.patch
alpha-fix-boot-mainc-warning.patch
acpi-cure-run-together-printk-lines.patch
fix-integer-overflow-warning-in-i2o_block.patch
