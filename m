From: akpm@linux-foundation.org
Subject: + zram-avoid-kunmap_atomic-a-null-pointer.patch added to -mm tree
Date: Thu, 30 Oct 2014 14:22:16 -0700
Message-ID: <5452ac08.XJM9hx2STvU/FrM+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbaJ3VWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 17:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, ddstreet@ieee.org, jmarchan@redhat.com, ngupta@vflare.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, weijie.yang.kh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: avoid kunmap_atomic() of a NULL pointer
has been added to the -mm tree.  Its filename is
     zram-avoid-kunmap_atomic-a-null-pointer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-avoid-kunmap_atomic-a-null-pointer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-avoid-kunmap_atomic-a-null-pointer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: zram: avoid kunmap_atomic() of a NULL pointer

zram could kunmap_atomic() a NULL pointer in a rare situation: a zram page
becomes a full-zeroed page after a partial write io.  The current code
doesn't handle this case and performs kunmap_atomic() on a NULL pointer,
which panics the kernel.

This patch fixes this issue.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Weijie Yang <weijie.yang.kh@gmail.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-avoid-kunmap_atomic-a-null-pointer drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-avoid-kunmap_atomic-a-null-pointer
+++ a/drivers/block/zram/zram_drv.c
@@ -560,7 +560,8 @@ static int zram_bvec_write(struct zram *
 	}
 
 	if (page_zero_filled(uncmem)) {
-		kunmap_atomic(user_mem);
+		if (user_mem)
+			kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
 		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 		zram_free_page(zram, index);
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch
zram-avoid-kunmap_atomic-a-null-pointer.patch
linux-next.patch

