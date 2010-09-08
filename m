From: akpm@linux-foundation.org
Subject: + bounce-call-flush_dcache_page-after-bounce_copy_vec.patch added to -mm tree
Date: Wed, 08 Sep 2010 12:47:24 -0700
Message-ID: <201009081947.o88JlOk5005070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002Ab0IHTrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2010 15:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gking@nvidia.com, axboe@kernel.dk, rmk@arm.linux.org.uk, stable@kernel.org, tj@kernel.org


The patch titled
     bounce: call flush_dcache_page() after bounce_copy_vec()
has been added to the -mm tree.  Its filename is
     bounce-call-flush_dcache_page-after-bounce_copy_vec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bounce: call flush_dcache_page() after bounce_copy_vec()
From: Gary King <gking@nvidia.com>

I have been seeing problems on Tegra 2 (ARMv7 SMP) systems with HIGHMEM
enabled on 2.6.35 (plus some patches targetted at 2.6.36 to perform cache
maintenance lazily), and the root cause appears to be that the mm bouncing
code is calling flush_dcache_page before it copies the bounce buffer into
the bio.

The bounced page needs to be flushed after data is copied into it, to
ensure that architecture implementations can synchronize instruction and
data caches if necessary.

Signed-off-by: Gary King <gking@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bounce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/bounce.c~bounce-call-flush_dcache_page-after-bounce_copy_vec mm/bounce.c
--- a/mm/bounce.c~bounce-call-flush_dcache_page-after-bounce_copy_vec
+++ a/mm/bounce.c
@@ -116,8 +116,8 @@ static void copy_to_high_bio_irq(struct 
 		 */
 		vfrom = page_address(fromvec->bv_page) + tovec->bv_offset;
 
-		flush_dcache_page(tovec->bv_page);
 		bounce_copy_vec(tovec, vfrom);
+		flush_dcache_page(tovec->bv_page);
 	}
 }
 
_

Patches currently in -mm which might be from gking@nvidia.com are

linux-next.patch
bounce-call-flush_dcache_page-after-bounce_copy_vec.patch

