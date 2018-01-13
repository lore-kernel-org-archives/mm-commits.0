From: akpm@linux-foundation.org
Subject: [patch 2/4] kmemleak: allow to coexist with fault injection
Date: Fri, 12 Jan 2018 16:53:10 -0800
Message-ID: <5a595876.zkjO/bD3bCHJrSZl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965265AbeAMAxM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 19:53:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dvyukov@google.com, catalin.marinas@arm.com

From: Dmitry Vyukov <dvyukov@google.com>
Subject: kmemleak: allow to coexist with fault injection

kmemleak does one slab allocation per user allocation.  So if slab fault
injection is enabled to any degree, kmemleak instantly fails to allocate
and turns itself off.  However, it's useful to use kmemleak with fault
injection to find leaks on error paths.  On the other hand, checking
kmemleak itself is not so useful because (1) it's a debugging tool and (2)
it has a very regular allocation pattern (basically a single allocation
site, so it either works or not).

Turn off fault injection for kmemleak allocations.

Link: http://lkml.kernel.org/r/20180109192243.19316-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~kmemleak-allow-to-coexist-with-fault-injection mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-allow-to-coexist-with-fault-injection
+++ a/mm/kmemleak.c
@@ -127,7 +127,7 @@
 /* GFP bitmask for kmemleak internal allocations */
 #define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC)) | \
 				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
-				 __GFP_NOWARN)
+				 __GFP_NOWARN | __GFP_NOFAIL)
 
 /* scanning area inside a memory block */
 struct kmemleak_scan_area {
_
