From: akpm@linux-foundation.org
Subject: [patch 32/94] lib/int_sqrt: optimize small argument
Date: Fri, 17 Nov 2017 15:28:04 -0800
Message-ID: <20171117232804.zLm8B9-td%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966927AbdKQX2G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aksgarg1989@gmail.com, dave@stgolabs.net, davem@davemloft.net, joe@perches.com, keescook@chromium.org, mawilcox@microsoft.com, md@google.com, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, will.deacon@arm.com

From: Peter Zijlstra <peterz@infradead.org>
Subject: lib/int_sqrt: optimize small argument

The current int_sqrt() computation is sub-optimal for the case of small
@x.  Which is the interesting case when we're going to do cumulative
distribution functions on idle times, which we assume to be a random
variable, where the target residency of the deepest idle state gives an
upper bound on the variable (5e6ns on recent Intel chips).

In the case of small @x, the compute loop:

	while (m != 0) {
		b = y + m;
		y >>= 1;

		if (x >= b) {
			x -= b;
			y += m;
		}
		m >>= 2;
	}

can be reduced to:

	while (m > x)
		m >>= 2;

Because y==0, b==m and until x>=m y will remain 0.

And while this is computationally equivalent, it runs much faster
because there's less code, in particular less branches.

      cycles:                 branches:              branch-misses:

OLD:

hot:   45.109444 +- 0.044117  44.333392 +- 0.002254  0.018723 +- 0.000593
cold: 187.737379 +- 0.156678  44.333407 +- 0.002254  6.272844 +- 0.004305

PRE:

hot:   67.937492 +- 0.064124  66.999535 +- 0.000488  0.066720 +- 0.001113
cold: 232.004379 +- 0.332811  66.999527 +- 0.000488  6.914634 +- 0.006568

POST:

hot:   43.633557 +- 0.034373  45.333132 +- 0.002277  0.023529 +- 0.000681
cold: 207.438411 +- 0.125840  45.333132 +- 0.002277  6.976486 +- 0.004219

Averages computed over all values <128k using a LFSR to generate order. 
Cold numbers have a LFSR based branch trace buffer 'confuser' ran between
each int_sqrt() invocation.

Link: http://lkml.kernel.org/r/20171020164644.876503355@infradead.org
Fixes: 30493cc9dddb ("lib/int_sqrt.c: optimize square root algorithm")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Suggested-by: Anshul Garg <aksgarg1989@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Davidson <md@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/int_sqrt.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/int_sqrt.c~lib-int_sqrt-optimize-small-argument lib/int_sqrt.c
--- a/lib/int_sqrt.c~lib-int_sqrt-optimize-small-argument
+++ a/lib/int_sqrt.c
@@ -23,6 +23,9 @@ unsigned long int_sqrt(unsigned long x)
 		return x;
 
 	m = 1UL << (BITS_PER_LONG - 2);
+	while (m > x)
+		m >>= 2;
+
 	while (m != 0) {
 		b = y + m;
 		y >>= 1;
_
