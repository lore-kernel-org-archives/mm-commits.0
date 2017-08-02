From: akpm@linux-foundation.org
Subject: + zram-convert-to-using-memset_l.patch added to -mm tree
Date: Wed, 02 Aug 2017 13:57:08 -0700
Message-ID: <59823ca4.EsXdFFS/481y5QQK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52806 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbdHBU5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, minchan@kernel.org, mingo@elte.hu, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/block/zram/zram_drv.c: convert to using memset_l
has been added to the -mm tree.  Its filename is
     zram-convert-to-using-memset_l.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-convert-to-using-memset_l.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-convert-to-using-memset_l.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: drivers/block/zram/zram_drv.c: convert to using memset_l

zram was the motivation for creating memset_l().  Minchan Kim sees a 7%
performance improvement on x86 with 100MB of non-zero deduplicatable data:

        perf stat -r 10 dd if=/dev/zram0 of=/dev/null

vanilla:        0.232050465 seconds time elapsed ( +-  0.51% )
memset_l:	0.217219387 seconds time elapsed ( +-  0.07% )

Link: http://lkml.kernel.org/r/20170720184539.31609-7-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Tested-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-convert-to-using-memset_l drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-convert-to-using-memset_l
+++ a/drivers/block/zram/zram_drv.c
@@ -175,20 +175,11 @@ static inline void update_used_max(struc
 	} while (old_max != cur_max);
 }
 
-static inline void zram_fill_page(char *ptr, unsigned long len,
+static inline void zram_fill_page(void *ptr, unsigned long len,
 					unsigned long value)
 {
-	int i;
-	unsigned long *page = (unsigned long *)ptr;
-
 	WARN_ON_ONCE(!IS_ALIGNED(len, sizeof(unsigned long)));
