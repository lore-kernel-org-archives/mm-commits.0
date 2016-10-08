From: akpm@linux-foundation.org
Subject: [patch 105/127] ia64: implement atomic64_dec_if_positive
Date: Fri, 07 Oct 2016 17:02:07 -0700
Message-ID: <57f8377f.vz4wngeGDI8fBLb/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39537 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932593AbcJHACI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:02:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, Vineet.Gupta1@synopsys.com, fengguang.wu@intel.com, fenghua.yu@intel.com, mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com, vgupta@synopsys.com

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
