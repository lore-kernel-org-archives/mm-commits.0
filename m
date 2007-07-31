From: akpm@linux-foundation.org
Subject: - alpha-fix-boot-mainc-warning.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:13 -0700
Message-ID: <200707312356.l6VNuDOK029301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764263AbXHAARj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mroos@linux.ee, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix boot/main.c warning
has been removed from the -mm tree.  Its filename was
     alpha-fix-boot-mainc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
acpi-cure-run-together-printk-lines.patch
fix-runtogether-printks-in-cmd64x-ide-driver.patch
