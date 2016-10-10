From: akpm@linux-foundation.org
Subject: [merged] ia64-implement-atomic64_dec_if_positive.patch removed
 from -mm tree
Date: Mon, 10 Oct 2016 15:57:14 -0700
Message-ID: <57fc1cca.NP6Ltip/lQzmaphn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37959 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbcJJW5P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, fengguang.wu@intel.com, fenghua.yu@intel.com, mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: implement atomic64_dec_if_positive
has been removed from the -mm tree.  Its filename was
     ia64-implement-atomic64_dec_if_positive.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: ia64: implement atomic64_dec_if_positive

This is based on s390 version and needed to get rid of
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE

Link: http://lkml.kernel.org/r/1473703083-8625-2-git-send-email-vgupta@synopsys.com
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/atomic.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN arch/ia64/include/asm/atomic.h~ia64-implement-atomic64_dec_if_positive arch/ia64/include/asm/atomic.h
--- a/arch/ia64/include/asm/atomic.h~ia64-implement-atomic64_dec_if_positive
+++ a/arch/ia64/include/asm/atomic.h
@@ -269,6 +269,22 @@ static __inline__ long atomic64_add_unle
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
+static __inline__ long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long c, old, dec;
+	c = atomic64_read(v);
+	for (;;) {
+		dec = c - 1;
+		if (unlikely(dec < 0))
+			break;
+		old = atomic64_cmpxchg((v), c, dec);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return dec;
+}
+
 /*
  * Atomically add I to V and return TRUE if the resulting value is
  * negative.
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are


