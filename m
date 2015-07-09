From: akpm@linux-foundation.org
Subject: + slub-fix-spelling-succedd-to-succeed.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:03:05 -0700
Message-ID: <559ec569.6FeLorWmAw8KX6cm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbbGITDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:03:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix spelling succedd to succeed
has been added to the -mm tree.  Its filename is
     slub-fix-spelling-succedd-to-succeed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-fix-spelling-succedd-to-succeed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-fix-spelling-succedd-to-succeed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: slub: fix spelling succedd to succeed

With this patchset the SLUB allocator now has both bulk alloc and free
implemented.

This patchset mostly optimizes the "fastpath" where objects are available
on the per CPU fastpath page.  This mostly amortize the less-heavy
none-locked cmpxchg_double used on fastpath.

The "fallback" bulking (e.g __kmem_cache_free_bulk) provides a good basis
for comparison.  Measurements[1] of the fallback functions
__kmem_cache_{free,alloc}_bulk have been copied from slab_common.c and
forced "noinline" to force a function call like slab_common.c.

Measurements on CPU CPU i7-4790K @ 4.00GHz
Baseline normal fastpath (alloc+free cost): 42 cycles(tsc) 10.601 ns

Measurements last-patch with disabled debugging:

Bulk- fallback                   - this-patch
  1 -  57 cycles(tsc) 14.448 ns  -  44 cycles(tsc) 11.236 ns  improved 22.8%
  2 -  51 cycles(tsc) 12.768 ns  -  28 cycles(tsc)  7.019 ns  improved 45.1%
  3 -  48 cycles(tsc) 12.232 ns  -  22 cycles(tsc)  5.526 ns  improved 54.2%
  4 -  48 cycles(tsc) 12.025 ns  -  19 cycles(tsc)  4.786 ns  improved 60.4%
  8 -  46 cycles(tsc) 11.558 ns  -  18 cycles(tsc)  4.572 ns  improved 60.9%
 16 -  45 cycles(tsc) 11.458 ns  -  18 cycles(tsc)  4.658 ns  improved 60.0%
 30 -  45 cycles(tsc) 11.499 ns  -  18 cycles(tsc)  4.568 ns  improved 60.0%
 32 -  79 cycles(tsc) 19.917 ns  -  65 cycles(tsc) 16.454 ns  improved 17.7%
 34 -  78 cycles(tsc) 19.655 ns  -  63 cycles(tsc) 15.932 ns  improved 19.2%
 48 -  68 cycles(tsc) 17.049 ns  -  50 cycles(tsc) 12.506 ns  improved 26.5%
 64 -  80 cycles(tsc) 20.009 ns  -  63 cycles(tsc) 15.929 ns  improved 21.3%
128 -  94 cycles(tsc) 23.749 ns  -  86 cycles(tsc) 21.583 ns  improved  8.5%
158 -  97 cycles(tsc) 24.299 ns  -  90 cycles(tsc) 22.552 ns  improved  7.2%
250 - 102 cycles(tsc) 25.681 ns  -  98 cycles(tsc) 24.589 ns  improved  3.9%

Benchmarking shows impressive improvements in the "fastpath" with a small
number of objects in the working set.  Once the working set increases,
resulting in activating the "slowpath" (that contains the heavier locked
cmpxchg_double) the improvement decreases.

I'm currently working on also optimizing the "slowpath" (as network stack
use-case hits this), but this patchset should provide a good foundation
for further improvements.  Rest of my patch queue in this area needs some
more work, but preliminary results are good.  I'm attending Netfilter
Workshop[2] next week, and I'll hopefully return working on further
improvements in this area.



This patch (of 6):

s/succedd/succeed/

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-fix-spelling-succedd-to-succeed mm/slub.c
--- a/mm/slub.c~slub-fix-spelling-succedd-to-succeed
+++ a/mm/slub.c
@@ -2712,7 +2712,7 @@ redo:
 	 * Determine the currently cpus per cpu slab.
 	 * The cpu may change afterward. However that does not matter since
 	 * data is retrieved via this pointer. If we are on the same cpu
-	 * during the cmpxchg then the free will succedd.
+	 * during the cmpxchg then the free will succeed.
 	 */
 	do {
 		tid = this_cpu_read(s->cpu_slab->tid);
_

Patches currently in -mm which might be from brouer@redhat.com are

slub-fix-spelling-succedd-to-succeed.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-improve-bulk-alloc-strategy.patch
slub-initial-bulk-free-implementation.patch
slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch

