From: akpm@linux-foundation.org
Subject: [merged] mm-slub-fix-lockups-on-preempt-smp-kernels.patch removed from -mm tree
Date: Fri, 27 Mar 2015 11:16:52 -0700
Message-ID: <55159e94.3mkQAS5o7vxjrmrx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbbC0SQx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Mar 2015 14:16:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.rutland@arm.com, brouer@redhat.com, catalin.marinas@arm.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, steve.capper@linaro.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: fix lockups on PREEMPT && !SMP kernels
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-lockups-on-preempt-smp-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Rutland <mark.rutland@arm.com>
Subject: mm/slub: fix lockups on PREEMPT && !SMP kernels

Commit 9aabf810a67cd97e ("mm/slub: optimize alloc/free fastpath by
removing preemption on/off") introduced an occasional hang for kernels
built with CONFIG_PREEMPT && !CONFIG_SMP.

The problem is the following loop the patch introduced to slab_alloc_node
and slab_free:

do {
        tid = this_cpu_read(s->cpu_slab->tid);
        c = raw_cpu_ptr(s->cpu_slab);
} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));

GCC 4.9 has been observed to hoist the load of c and c->tid above the loop
for !SMP kernels (as in this case raw_cpu_ptr(x) is compile-time constant
and does not force a reload).  On arm64 the generated assembly looks like:

ffffffc00016d3c4:       f9400404        ldr     x4, [x0,#8]
ffffffc00016d3c8:       f9400401        ldr     x1, [x0,#8]
ffffffc00016d3cc:       eb04003f        cmp     x1, x4
ffffffc00016d3d0:       54ffffc1        b.ne    ffffffc00016d3c8 <slab_alloc_node.constprop.82+0x30>

If the thread is preempted between the load of c->tid (into x1) and tid
(into x4), and an allocation or free occurs in another thread (bumping the
cpu_slab's tid), the thread will be stuck in the loop until
s->cpu_slab->tid wraps, which may be forever in the absence of
allocations/frees on the same CPU.

This patch changes the loop condition to access c->tid with READ_ONCE. 
This ensures that the value is reloaded even when the compiler would
otherwise assume it could cache the value, and also ensures that the load
will not be torn.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~mm-slub-fix-lockups-on-preempt-smp-kernels mm/slub.c
--- a/mm/slub.c~mm-slub-fix-lockups-on-preempt-smp-kernels
+++ a/mm/slub.c
@@ -2449,7 +2449,8 @@ redo:
 	do {
 		tid = this_cpu_read(s->cpu_slab->tid);
 		c = raw_cpu_ptr(s->cpu_slab);
-	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
+	} while (IS_ENABLED(CONFIG_PREEMPT) &&
+		 unlikely(tid != READ_ONCE(c->tid)));
 
 	/*
 	 * Irqless object alloc/free algorithm used here depends on sequence
@@ -2718,7 +2719,8 @@ redo:
 	do {
 		tid = this_cpu_read(s->cpu_slab->tid);
 		c = raw_cpu_ptr(s->cpu_slab);
-	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
+	} while (IS_ENABLED(CONFIG_PREEMPT) &&
+		 unlikely(tid != READ_ONCE(c->tid)));
 
 	/* Same with comment on barrier() in slab_alloc_node() */
 	barrier();
_

Patches currently in -mm which might be from mark.rutland@arm.com are

origin.patch
mm-move-memtest-under-mm.patch
memtest-use-phys_addr_t-for-physical-addresses.patch
arm64-add-support-for-memtest.patch
arm-add-support-for-memtest.patch
kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
documentation-update-arch-list-in-the-memtest-entry.patch
rtc-mediatek-add-mt63xx-rtc-driver.patch
linux-next.patch

