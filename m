From: akpm@linux-foundation.org
Subject: +
 log2-make-order_base_2-behave-correctly-on-const-input-value-zero.patch
 added to -mm tree
Date: Thu, 02 Feb 2017 14:51:26 -0800
Message-ID: <5893b7ee.1W/hJNKWGq5YzbW2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdBBWv1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 17:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, gregory.clement@free-electrons.com, james.greenhalgh@arm.com, labbott@fedoraproject.org, markus@trippelsdorf.de, mingo@kernel.org, peterz@infradead.org, sboyd@codeaurora.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: log2: make order_base_2() behave correctly on const input value zero
has been added to the -mm tree.  Its filename is
     log2-make-order_base_2-behave-correctly-on-const-input-value-zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/log2-make-order_base_2-behave-correctly-on-const-input-value-zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/log2-make-order_base_2-behave-correctly-on-const-input-value-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: log2: make order_base_2() behave correctly on const input value zero

The function order_base_2() is defined (according to the comment block) as
returning zero on input zero, but subsequently passes the input into
roundup_pow_of_two(), which is explicitly undefined for input zero.

This has gone unnoticed until now, but optimization passes in GCC 7 may
produce constant folded function instances where a constant value of zero
is passed into order_base_2(), resulting in link errors against the
deliberately undefined '____ilog2_NaN'.

So update order_base_2() to adhere to its own documented interface.

Link: http://lkml.kernel.org/r/1486058726-7262-1-git-send-email-ard.biesheuvel@linaro.org
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@fedoraproject.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: James Greenlaigh <james.greenhalgh@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/log2.h~log2-make-order_base_2-behave-correctly-on-const-input-value-zero include/linux/log2.h
--- a/include/linux/log2.h~log2-make-order_base_2-behave-correctly-on-const-input-value-zero
+++ a/include/linux/log2.h
@@ -203,6 +203,17 @@ unsigned long __rounddown_pow_of_two(uns
  *  ... and so on.
  */
 
-#define order_base_2(n) ilog2(roundup_pow_of_two(n))
+static inline __attribute_const__
+int __order_base_2(unsigned long n)
+{
+	return n > 1 ? ilog2(n - 1) + 1 : 0;
+}
 
+#define order_base_2(n)				\
+(						\
+	__builtin_constant_p(n) ? (		\
+		((n) == 0 || (n) == 1) ? 0 :	\
+		ilog2((n) - 1) + 1) :		\
+	__order_base_2(n)			\
+)
 #endif /* _LINUX_LOG2_H */
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

log2-make-order_base_2-behave-correctly-on-const-input-value-zero.patch

