From: akpm@linux-foundation.org
Subject: + ia64-implement-atomic64_dec_if_positive.patch added to -mm tree
Date: Mon, 12 Sep 2016 14:59:36 -0700
Message-ID: <57d72548.kgoeeAGD0hTYdhVk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51151 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbcILV7h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2016 17:59:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, fengguang.wu@intel.com, fenghua.yu@intel.com, mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: implement atomic64_dec_if_positive
has been added to the -mm tree.  Its filename is
     ia64-implement-atomic64_dec_if_positive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ia64-implement-atomic64_dec_if_positive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ia64-implement-atomic64_dec_if_positive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
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

ia64-implement-atomic64_dec_if_positive.patch
atomic64-no-need-for-config_arch_has_atomic64_dec_if_positive.patch

