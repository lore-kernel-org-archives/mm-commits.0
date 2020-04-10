From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-math-avoid-trailing-n-hidden-in-pr_fmt.patch added
 to -mm tree
Date: Thu, 09 Apr 2020 21:53:37 -0700
Message-ID: <20200410045337.iQndFbAdG%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgDJExi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 00:53:38 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org, mchehab+samsung@kernel.org, mm-commits@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: lib/math: avoid trailing newline hidden in pr_fmt()
has been added to the -mm tree.  Its filename is
     lib-math-avoid-trailing-n-hidden-in-pr_fmt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-math-avoid-trailing-n-hidden-in-pr_fmt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-math-avoid-trailing-n-hidden-in-pr_fmt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: lib/math: avoid trailing newline hidden in pr_fmt()

pr_xxx() functions usually have a newline at the end of the logging
message.

Here, this newline is added via the 'pr_fmt' macro.

In order to be more consistent with other files, use a more standard
convention and put these newlines back in the messages themselves and
remove it from the pr_fmt macro.

While at it, use __func__ instead of hardcoding a function name in the
last message.

Link: http://lkml.kernel.org/r/20200409163234.22830-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/prime_numbers.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/math/prime_numbers.c~lib-math-avoid-trailing-n-hidden-in-pr_fmt
+++ a/lib/math/prime_numbers.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#define pr_fmt(fmt) "prime numbers: " fmt "\n"
+#define pr_fmt(fmt) "prime numbers: " fmt
 
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -253,7 +253,7 @@ static void dump_primes(void)
 
 	if (buf)
 		bitmap_print_to_pagebuf(true, buf, p->primes, p->sz);
-	pr_info("primes.{last=%lu, .sz=%lu, .primes[]=...x%lx} = %s",
+	pr_info("primes.{last=%lu, .sz=%lu, .primes[]=...x%lx} = %s\n",
 		p->last, p->sz, p->primes[BITS_TO_LONGS(p->sz) - 1], buf);
 
 	rcu_read_unlock();
@@ -273,7 +273,7 @@ static int selftest(unsigned long max)
 		bool fast = is_prime_number(x);
 
 		if (slow != fast) {
-			pr_err("inconsistent result for is-prime(%lu): slow=%s, fast=%s!",
+			pr_err("inconsistent result for is-prime(%lu): slow=%s, fast=%s!\n",
 			       x, slow ? "yes" : "no", fast ? "yes" : "no");
 			goto err;
 		}
@@ -282,14 +282,14 @@ static int selftest(unsigned long max)
 			continue;
 
 		if (next_prime_number(last) != x) {
-			pr_err("incorrect result for next-prime(%lu): expected %lu, got %lu",
+			pr_err("incorrect result for next-prime(%lu): expected %lu, got %lu\n",
 			       last, x, next_prime_number(last));
 			goto err;
 		}
 		last = x;
 	}
 
-	pr_info("selftest(%lu) passed, last prime was %lu", x, last);
+	pr_info("%s(%lu) passed, last prime was %lu\n", __func__, x, last);
 	return 0;
 
 err:
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

lib-math-avoid-trailing-n-hidden-in-pr_fmt.patch
