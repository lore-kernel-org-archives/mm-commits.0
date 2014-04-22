From: akpm@linux-foundation.org
Subject: + zram-correct-offset-usage-in-zram_bio_discard.patch added to
 -mm tree
Date: Tue, 22 Apr 2014 12:57:02 -0700
Message-ID: <5356c98e.sINYgEZSZWbKqILC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaDVT5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, iamjoonsoo.kim@lge.com, bob.liu@oracle.com, weijie.yang@samsung.com

Subject: + zram-correct-offset-usage-in-zram_bio_discard.patch added to -mm tree
To: weijie.yang@samsung.com,bob.liu@oracle.com,iamjoonsoo.kim@lge.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:57:02 -0700


The patch titled
     Subject: zram: correct offset usage in zram_bio_discard
has been added to the -mm tree.  Its filename is
     zram-correct-offset-usage-in-zram_bio_discard.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-correct-offset-usage-in-zram_bio_discard.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-correct-offset-usage-in-zram_bio_discard.patch

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
Subject: zram: correct offset usage in zram_bio_discard

We want to skip the logical block which is partially covered by the
discard bio, so check the remaining size and subtract it if there is a
need to goto the next logical block.

This patch corrects the offset usage in zram_bio_discard.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-correct-offset-usage-in-zram_bio_discard drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-correct-offset-usage-in-zram_bio_discard
+++ a/drivers/block/zram/zram_drv.c
@@ -572,10 +572,10 @@ static void zram_bio_discard(struct zram
 	 * skipping this logical block is appropriate here.
 	 */
 	if (offset) {
-		if (n < offset)
+		if (n <= (PAGE_SIZE - offset))
 			return;
 
-		n -= offset;
+		n -= (PAGE_SIZE - offset);
 		index++;
 	}
 
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

zram-correct-offset-usage-in-zram_bio_discard.patch

