From: akpm@linux-foundation.org
Subject: [patch 14/26] frv: add atomic64_add_unless()
Date: Tue, 24 Jan 2017 15:18:21 -0800
Message-ID: <5887e0bd.Hdr2r98OggtkGTL3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdAXXSW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:18:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, dhowells@redhat.com, sudip.mukherjee@codethink.co.uk

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
