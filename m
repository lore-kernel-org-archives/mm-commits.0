From: akpm@linux-foundation.org
Subject: [merged] mm-zram-correct-zram_zero-flag-bit-position.patch
 removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:53 -0800
Message-ID: <548d0d55.2uJqCTS78ejJWTvx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaLNEIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zram: correct ZRAM_ZERO flag bit position
has been removed from the -mm tree.  Its filename was
     mm-zram-correct-zram_zero-flag-bit-position.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: mm/zram: correct ZRAM_ZERO flag bit position

In struct zram_table_entry, the element *value* contains obj size and obj
zram flags.  Bit 0 to bit (ZRAM_FLAG_SHIFT - 1) represent obj size, and
bit ZRAM_FLAG_SHIFT to the highest bit of unsigned long represent obj
zram_flags.  So the first zram flag(ZRAM_ZERO) should be from
ZRAM_FLAG_SHIFT instead of (ZRAM_FLAG_SHIFT + 1).

This patch fixes this cosmetic issue.

Also fix a typo, "page in now accessed" -> "page is now accessed"

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.h~mm-zram-correct-zram_zero-flag-bit-position drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~mm-zram-correct-zram_zero-flag-bit-position
+++ a/drivers/block/zram/zram_drv.h
@@ -66,8 +66,8 @@ static const size_t max_zpage_size = PAG
 /* Flags for zram pages (table[page_no].value) */
 enum zram_pageflags {
 	/* Page consists entirely of zeros */
-	ZRAM_ZERO = ZRAM_FLAG_SHIFT + 1,
-	ZRAM_ACCESS,	/* page in now accessed */
+	ZRAM_ZERO = ZRAM_FLAG_SHIFT,
+	ZRAM_ACCESS,	/* page is now accessed */
 
 	__NR_ZRAM_PAGEFLAGS,
 };
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

origin.patch

