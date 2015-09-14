From: akpm@linux-foundation.org
Subject: + alpha-lib-export-__delay.patch added to -mm tree
Date: Mon, 14 Sep 2015 13:20:09 -0700
Message-ID: <55f72bf9.upAZ4usg/gOuPxdB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbINUUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 16:20:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: lib: export __delay
has been added to the -mm tree.  Its filename is
     alpha-lib-export-__delay.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/alpha-lib-export-__delay.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/alpha-lib-export-__delay.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: alpha: lib: export __delay

__delay was not exported as a result while building with allmodconfig we
were getting build error of undefined symbol. __delay is being used by:
drivers/net/phy/mdio-octeon.c

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/udelay.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/alpha/lib/udelay.c~alpha-lib-export-__delay arch/alpha/lib/udelay.c
--- a/arch/alpha/lib/udelay.c~alpha-lib-export-__delay
+++ a/arch/alpha/lib/udelay.c
@@ -30,6 +30,7 @@ __delay(int loops)
 		"	bgt %0,1b"
 		: "=&r" (tmp), "=r" (loops) : "1"(loops));
 }
+EXPORT_SYMBOL(__delay);
 
 #ifdef CONFIG_SMP
 #define LPJ	 cpu_data[smp_processor_id()].loops_per_jiffy
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

alpha-io-define-ioremap_uc.patch
alpha-lib-export-__delay.patch

