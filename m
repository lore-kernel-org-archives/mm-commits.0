From: akpm@linux-foundation.org
Subject: + frv-add-missing-atomic64-operations.patch added to -mm tree
Date: Mon, 23 Jan 2017 14:24:36 -0800
Message-ID: <588682a4.7hAemj7jEC5bZDRH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43012 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbdAWWYh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 17:24:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, dhowells@redhat.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: add missing atomic64 operations
has been added to the -mm tree.  Its filename is
     frv-add-missing-atomic64-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-add-missing-atomic64-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-add-missing-atomic64-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

frv-add-atomic64_add_unless.patch
m32r-fix-build-warning.patch
frv-pci-frv-fix-build-warning.patch
frv-add-missing-atomic64-operations.patch

