From: akpm@linux-foundation.org
Subject: + mm-page-writeback-fix-dirty_ratelimit-calculation.patch added
 to -mm tree
Date: Mon, 25 Jan 2016 13:48:28 -0800
Message-ID: <56a6982c.QlQUM77RxV+iv6br%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbcAYVs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jan 2016 16:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, andy.shevchenko@gmail.com, fengguang.wu@intel.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: fix dirty_ratelimit calculation
has been added to the -mm tree.  Its filename is
     mm-page-writeback-fix-dirty_ratelimit-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writeback-fix-dirty_ratelimit-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writeback-fix-dirty_ratelimit-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/page-writeback: fix dirty_ratelimit calculation

Calculation of dirty_ratelimit sometimes is not correct.
E.g. initial values of dirty_ratelimit == INIT_BW and step == 0,
lead to the following result:

   UBSAN: Undefined behaviour in ../mm/page-writeback.c:1286:7
   shift exponent 25600 is too large for 64-bit type 'long unsigned int'

The fix is straightforward - make step 0 if the shift exponent is too big.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/page-writeback.c~mm-page-writeback-fix-dirty_ratelimit-calculation mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writeback-fix-dirty_ratelimit-calculation
+++ a/mm/page-writeback.c
@@ -1169,6 +1169,7 @@ static void wb_update_dirty_ratelimit(st
 	unsigned long balanced_dirty_ratelimit;
 	unsigned long step;
 	unsigned long x;
+	unsigned long shift;
 
 	/*
 	 * The dirty rate will match the writeout rate in long term, except
@@ -1293,11 +1294,11 @@ static void wb_update_dirty_ratelimit(st
 	 * rate itself is constantly fluctuating. So decrease the track speed
 	 * when it gets close to the target. Helps eliminate pointless tremors.
 	 */
-	step >>= dirty_ratelimit / (2 * step + 1);
-	/*
-	 * Limit the tracking speed to avoid overshooting.
-	 */
-	step = (step + 7) / 8;
+	shift = dirty_ratelimit / (2 * step + 1);
+	if (shift < BITS_PER_LONG)
+		step = DIV_ROUND_UP(step >> shift, 8);
+	else
+		step = 0;
 
 	if (dirty_ratelimit < balanced_dirty_ratelimit)
 		dirty_ratelimit += step;
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-page-writeback-fix-dirty_ratelimit-calculation.patch
ubsan-fix-tree-wide-wmaybe-uninitialized-false-positives.patch

