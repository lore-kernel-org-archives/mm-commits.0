From: akpm@linux-foundation.org
Subject: [patch 03/17] mm/kmemleak.c: make cond_resched() rate-limiting
 more efficient
Date: Thu, 14 Dec 2017 15:32:31 -0800
Message-ID: <5a330a0f.OLbVlN292NfGlohY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54242 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754438AbdLNXcc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:32:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, catalin.marinas@arm.com, mhocko@kernel.org, xieyisheng1@huawei.com

From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/kmemleak.c: make cond_resched() rate-limiting more efficient

bde5f6bc68db5 ("kmemleak: add scheduling point to kmemleak_scan()") tries
to rate-limit the frequency of cond_resched() calls, but does it in a way
which might incur an expensive division operation in the inner loop. 
Simplify this.

Fixes: bde5f6bc68db5 ("kmemleak: add scheduling point to kmemleak_scan()")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient
+++ a/mm/kmemleak.c
@@ -1523,7 +1523,7 @@ static void kmemleak_scan(void)
 			if (page_count(page) == 0)
 				continue;
 			scan_block(page, page + 1, NULL);
-			if (!(pfn % (MAX_SCAN_SIZE / sizeof(*page))))
+			if (!(pfn & 63))
 				cond_resched();
 		}
 	}
_
