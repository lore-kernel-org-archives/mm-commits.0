From: akpm@linux-foundation.org
Subject: + mm-zram-correct-zram_zero-flag-bit-position.patch added to -mm
 tree
Date: Tue, 18 Nov 2014 15:45:37 -0800
Message-ID: <546bda21.aIcDIq8f2W98Y0dq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbaKRXpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 18:45:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zram: correct ZRAM_ZERO flag bit position
has been added to the -mm tree.  Its filename is
     mm-zram-correct-zram_zero-flag-bit-position.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zram-correct-zram_zero-flag-bit-position.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-zram-correct-zram_zero-flag-bit-position.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch

