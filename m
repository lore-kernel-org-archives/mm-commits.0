From: akpm@linux-foundation.org
Subject: [patch 34/94] lib/int_sqrt: adjust comments
Date: Fri, 17 Nov 2017 15:28:12 -0800
Message-ID: <20171117232812.hC1OtNpFP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55542 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966927AbdKQX2O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aksgarg1989@gmail.com, dave@stgolabs.net, davem@davemloft.net, joe@perches.com, keescook@chromium.org, mawilcox@microsoft.com, md@google.com, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, will.deacon@arm.com

From: Peter Zijlstra <peterz@infradead.org>
Subject: lib/int_sqrt: adjust comments

Our current int_sqrt() is not rough nor any approximation; it calculates
the exact value of: floor(sqrt()).  Document this.

Link: http://lkml.kernel.org/r/20171020164645.001652117@infradead.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anshul Garg <aksgarg1989@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Michael Davidson <md@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/int_sqrt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/int_sqrt.c~lib-int_sqrt-adjust-comments lib/int_sqrt.c
--- a/lib/int_sqrt.c~lib-int_sqrt-adjust-comments
+++ a/lib/int_sqrt.c
@@ -11,10 +11,10 @@
 #include <linux/bitops.h>
 
 /**
- * int_sqrt - rough approximation to sqrt
+ * int_sqrt - computes the integer square root
  * @x: integer of which to calculate the sqrt
  *
- * A very rough approximation to the sqrt() function.
+ * Computes: floor(sqrt(x))
  */
 unsigned long int_sqrt(unsigned long x)
 {
_
