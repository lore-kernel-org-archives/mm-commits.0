From: akpm@linux-foundation.org
Subject: [merged]
 kmemleak-allow-to-coexist-with-fault-injection.patch removed from -mm tree
Date: Tue, 16 Jan 2018 11:30:28 -0800
Message-ID: <20180116193028.Dv5kDI5wO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751816AbeAPTa3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jan 2018 14:30:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: allow to coexist with fault injection
has been removed from the -mm tree.  Its filename was
     kmemleak-allow-to-coexist-with-fault-injection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dvyukov@google.com are

kasan-detect-invalid-frees-for-large-objects.patch
kasan-dont-use-__builtin_return_address1.patch
kasan-detect-invalid-frees-for-large-mempool-objects.patch
kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch
kasan-detect-invalid-frees.patch

