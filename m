From: akpm@linux-foundation.org
Subject: [merged]
 log2-make-order_base_2-behave-correctly-on-const-input-value-zero.patch
 removed from -mm tree
Date: Fri, 03 Feb 2017 12:05:31 -0800
Message-ID: <5894e28b.SYotGEVqL8EY6ryX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35554 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdBCUFd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2017 15:05:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, gregory.clement@free-electrons.com, james.greenhalgh@arm.com, labbott@fedoraproject.org, markus@trippelsdorf.de, mingo@kernel.org, peterz@infradead.org, sboyd@codeaurora.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: log2: make order_base_2() behave correctly on const input value zero
has been removed from the -mm tree.  Its filename was
     log2-make-order_base_2-behave-correctly-on-const-input-value-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


