From: akpm@linux-foundation.org
Subject: [merged] zram-avoid-kunmap_atomic-a-null-pointer.patch removed
 from -mm tree
Date: Mon, 17 Nov 2014 12:50:29 -0800
Message-ID: <546a5f95./6MEMLCo4iHhyejm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaKQUub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 15:50:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weijie.yang@samsung.com, ddstreet@ieee.org, jmarchan@redhat.com, ngupta@vflare.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, weijie.yang.kh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: avoid kunmap_atomic() of a NULL pointer
has been removed from the -mm tree.  Its filename was
     zram-avoid-kunmap_atomic-a-null-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-page_isolation-check-pfn-validity-before-access.patch
mm-mincore-add-hwpoison-page-handle.patch
mm-mincore-add-hwpoison-page-handle-checkpatch-fixes.patch

