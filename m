From: akpm@linux-foundation.org
Subject: + frv-add-atomic64_add_unless.patch added to -mm tree
Date: Wed, 18 Jan 2017 15:17:51 -0800
Message-ID: <587ff79f.34bBFdFJqbp6h9g2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdARXna (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 18:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, dhowells@redhat.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: frv: add atomic64_add_unless()
has been added to the -mm tree.  Its filename is
     frv-add-atomic64_add_unless.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/frv-add-atomic64_add_unless.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/frv-add-atomic64_add_unless.patch

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
Subject: frv: add atomic64_add_unless()

The build of frv allmodconfig was failing with the error:
lib/atomic64_test.c:209:9: error:

	implicit declaration of function 'atomic64_add_unless'

All the atomic64 operations were defined in frv, but atomic64_add_unless()
was not done.  Implement atomic64_add_unless() as done in other arches.

Link: http://lkml.kernel.org/r/1484781236-6698-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/atomic.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN arch/frv/include/asm/atomic.h~frv-add-atomic64_add_unless arch/frv/include/asm/atomic.h
--- a/arch/frv/include/asm/atomic.h~frv-add-atomic64_add_unless
+++ a/arch/frv/include/asm/atomic.h
@@ -161,6 +161,22 @@ static __inline__ int __atomic_add_unles
 	return c;
 }
 
+static inline int atomic64_add_unless(atomic64_t *v, long long i, long long u)
+{
+	long long c, old;
+
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == u))
+			break;
+		old = atomic64_cmpxchg(v, c, c + i);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != u;
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

