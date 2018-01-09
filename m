From: akpm@linux-foundation.org
Subject: + kmemleak-allow-to-coexist-with-fault-injection.patch added to
 -mm tree
Date: Tue, 09 Jan 2018 15:18:08 -0800
Message-ID: <5a554db0.c2n1TOl45HNam2jv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56928 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932091AbeAIXSJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:18:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: allow to coexist with fault injection
has been added to the -mm tree.  Its filename is
     kmemleak-allow-to-coexist-with-fault-injection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemleak-allow-to-coexist-with-fault-injection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-allow-to-coexist-with-fault-injection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kmemleak-allow-to-coexist-with-fault-injection.patch
kasan-detect-invalid-frees-for-large-objects.patch
kasan-dont-use-__builtin_return_address1.patch
kasan-detect-invalid-frees-for-large-mempool-objects.patch
kasan-unify-code-between-kasan_slab_free-and-kasan_poison_kfree.patch
kasan-detect-invalid-frees.patch

