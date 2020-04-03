From: akpm@linux-foundation.org
Subject: [merged]
 slub-relocate-freelist-pointer-to-middle-of-object.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:35:55 -0700
Message-ID: <20200403203555.LtYfAya00%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUf5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, silvio.cesare@gmail.com, vnik@duasynt.com


The patch titled
     Subject: slub: relocate freelist pointer to middle of object
has been removed from the -mm tree.  Its filename was
     slub-relocate-freelist-pointer-to-middle-of-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: slub: relocate freelist pointer to middle of object

In a recent discussion[1] with Vitaly Nikolenko and Silvio Cesare, it
became clear that moving the freelist pointer away from the edge of
allocations would likely improve the overall defensive posture of the
inline freelist pointer.  My benchmarks show no meaningful change to
performance (they seem to show it being faster), so this looks like a
reasonable change to make.

Instead of having the freelist pointer at the very beginning of an
allocation (offset 0) or at the very end of an allocation (effectively
offset -sizeof(void *) from the next allocation), move it away from the
edges of the allocation and into the middle.  This provides some
protection against small-sized neighboring overflows (or underflows), for
which the freelist pointer is commonly the target.  (Large or well
controlled overwrites are much more likely to attack live object contents,
instead of attempting freelist corruption.)

The vaunted kernel build benchmark, across 5 runs. Before:

	Mean: 250.05
	Std Dev: 1.85

and after, which appears mysteriously faster:

	Mean: 247.13
	Std Dev: 0.76

Attempts at running "sysbench --test=memory" show the change to be well in
the noise (sysbench seems to be pretty unstable here -- it's not really
measuring allocation).

Hackbench is more allocation-heavy, and while the std dev is above the
difference, it looks like may manifest as an improvement as well:

20 runs of "hackbench -g 20 -l 1000", before:

	Mean: 36.322
	Std Dev: 0.577

and after:

	Mean: 36.056
	Std Dev: 0.598

[1] https://twitter.com/vnik5287/status/1235113523098685440

Link: http://lkml.kernel.org/r/202003051624.AAAC9AECC@keescook
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Vitaly Nikolenko <vnik@duasynt.com>
Cc: Silvio Cesare <silvio.cesare@gmail.com>
Cc: Christoph Lameter <cl@linux.com>Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/slub.c~slub-relocate-freelist-pointer-to-middle-of-object
+++ a/mm/slub.c
@@ -3581,6 +3581,13 @@ static int calculate_sizes(struct kmem_c
 		 */
 		s->offset = size;
 		size += sizeof(void *);
+	} else if (size > sizeof(void *)) {
+		/*
+		 * Store freelist pointer near middle of object to keep
+		 * it away from the edges of the object to avoid small
+		 * sized over/underflows from neighboring allocations.
+		 */
+		s->offset = ALIGN(size / 2, sizeof(void *));
 	}
 
 #ifdef CONFIG_SLUB_DEBUG
_

Patches currently in -mm which might be from keescook@chromium.org are

shmem-distribute-switch-variables-for-initialization.patch
lib-test_stackinitc-xfail-switch-variable-init-tests.patch
ubsan-add-trap-instrumentation-option.patch
ubsan-split-bounds-checker-from-other-options.patch
lkdtm-bugs-add-arithmetic-overflow-and-array-bounds-checks.patch
ubsan-check-panic_on_warn.patch
kasan-unset-panic_on_warn-before-calling-panic.patch
ubsan-include-bug-type-in-report-header.patch
