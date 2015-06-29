From: akpm@linux-foundation.org
Subject: [merged] zram-trivial-correct-flag-operations-comment.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:24 -0700
Message-ID: <5591aea0.TVOpCR/fgwAhJ/Re%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbbF2UqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: trivial: correct flag operations comment
has been removed from the -mm tree.  Its filename was
     zram-trivial-correct-flag-operations-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: trivial: correct flag operations comment

We don't have meta->tb_lock anymore and use meta table entry bit_spin_lock
instead. update corresponding comment.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-trivial-correct-flag-operations-comment drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-trivial-correct-flag-operations-comment
+++ a/drivers/block/zram/zram_drv.c
@@ -70,7 +70,7 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
-/* flag operations needs meta->tb_lock */
+/* flag operations require table entry bit_spin_lock() being held */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

