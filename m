From: akpm@linux-foundation.org
Subject: [patch 21/26] frv: add missing atomic64 operations
Date: Tue, 24 Jan 2017 15:18:43 -0800
Message-ID: <5887e0d3.vpdRB7kf82gtm9vg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41560 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdAXXSo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, dhowells@redhat.com, sudip.mukherjee@codethink.co.uk

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: frv: add missing atomic64 operations

Some more atomic64 operations were missing and as a result
frv allmodconfig was failing. Add the missing operations.

Link: http://lkml.kernel.org/r/1485193844-12850-1-git-send-email-sudip.mukherjee@codethink.co.uk
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/atomic.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff -puN arch/frv/include/asm/atomic.h~frv-add-missing-atomic64-operations arch/frv/include/asm/atomic.h
--- a/arch/frv/include/asm/atomic.h~frv-add-missing-atomic64-operations
+++ a/arch/frv/include/asm/atomic.h
@@ -139,7 +139,7 @@ static inline void atomic64_dec(atomic64
 #define atomic64_sub_and_test(i,v)	(atomic64_sub_return((i), (v)) == 0)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 #define atomic64_inc_and_test(v)	(atomic64_inc_return((v)) == 0)
-
+#define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
 
 #define atomic_cmpxchg(v, old, new)	(cmpxchg(&(v)->counter, old, new))
 #define atomic_xchg(v, new)		(xchg(&(v)->counter, new))
@@ -177,6 +177,23 @@ static inline int atomic64_add_unless(at
 	return c != u;
 }
 
+static inline long long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long long c, old, dec;
+
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
+		return dec;
+}
+
 #define ATOMIC_OP(op)							\
 static inline int atomic_fetch_##op(int i, atomic_t *v)			\
 {									\
_
