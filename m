From: akpm@linux-foundation.org
Subject: [merged] lib-int_sqrt-optimize-initial-value-compute.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:24:12 -0800
Message-ID: <20171120212412.ehLe5V0vi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752937AbdKTVYO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aksgarg1989@gmail.com, dave@stgolabs.net, davem@davemloft.net, joe@perches.com, keescook@chromium.org, mawilcox@microsoft.com, md@google.com, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, will.deacon@arm.com


The patch titled
     Subject: lib/int_sqrt: optimize initial value compute
has been removed from the -mm tree.  Its filename was
     lib-int_sqrt-optimize-initial-value-compute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: lib/int_sqrt: optimize initial value compute

The initial value (@m) compute is:

	m = 1UL << (BITS_PER_LONG - 2);
	while (m > x)
		m >>= 2;

Which is a linear search for the highest even bit smaller or equal to @x
We can implement this using a binary search using __fls() (or better when
its hardware implemented).

	m = 1UL << (__fls(x) & ~1UL);

Especially for small values of @x; which are the more common arguments
when doing a CDF on idle times; the linear search is near to worst case,
while the binary search of __fls() is a constant 6 (or 5 on 32bit)
branches.

      cycles:                 branches:              branch-misses:

PRE:

hot:   43.633557 +- 0.034373  45.333132 +- 0.002277  0.023529 +- 0.000681
cold: 207.438411 +- 0.125840  45.333132 +- 0.002277  6.976486 +- 0.004219

SOFTWARE FLS:

hot:   29.576176 +- 0.028850  26.666730 +- 0.004511  0.019463 +- 0.000663
cold: 165.947136 +- 0.188406  26.666746 +- 0.004511  6.133897 +- 0.004386

HARDWARE FLS:

hot:   24.720922 +- 0.025161  20.666784 +- 0.004509  0.020836 +- 0.000677
cold: 132.777197 +- 0.127471  20.666776 +- 0.004509  5.080285 +- 0.003874

Averages computed over all values <128k using a LFSR to generate order. 
Cold numbers have a LFSR based branch trace buffer 'confuser' ran between
each int_sqrt() invocation.

Link: http://lkml.kernel.org/r/20171020164644.936577234@infradead.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anshul Garg <aksgarg1989@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Michael Davidson <md@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/int_sqrt.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN lib/int_sqrt.c~lib-int_sqrt-optimize-initial-value-compute lib/int_sqrt.c
--- a/lib/int_sqrt.c~lib-int_sqrt-optimize-initial-value-compute
+++ a/lib/int_sqrt.c
@@ -8,6 +8,7 @@
 
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <linux/bitops.h>
 
 /**
  * int_sqrt - rough approximation to sqrt
@@ -22,10 +23,7 @@ unsigned long int_sqrt(unsigned long x)
 	if (x <= 1)
 		return x;
 
-	m = 1UL << (BITS_PER_LONG - 2);
-	while (m > x)
-		m >>= 2;
