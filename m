From: akpm@linux-foundation.org
Subject: [merged] zram-convert-to-using-memset_l.patch removed from
 -mm tree
Date: Mon, 11 Sep 2017 12:41:04 -0700
Message-ID: <20170911194104.BuFIBtJ_x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdIKTlF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:41:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mattst88@gmail.com, mawilcox@microsoft.com, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, mpe@ellerman.id.au, ralf@linux-mips.org, rmk+kernel@armlinux.org.uk, rth@twiddle.net, sam@ravnborg.org, sergey.senozhatsky@gmail.com, tglx@linutronix.de


The patch titled
     Subject: drivers/block/zram/zram_drv.c: convert to using memset_l
has been removed from the -mm tree.  Its filename was
     zram-convert-to-using-memset_l.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
