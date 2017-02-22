From: akpm@linux-foundation.org
Subject: [patch 017/142] m32r: fix build warning
Date: Wed, 22 Feb 2017 15:40:35 -0800
Message-ID: <58ae2173.M0KRdd/Nq72zVvb1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934321AbdBVXlz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: m32r: fix build warning

Some m32r builds were having a warning:

arch/m32r/include/asm/cmpxchg.h:191:3:
	warning: value computed is not used

arch/m32r/include/asm/cmpxchg.h:68:3:
	warning: value computed is not used

Taking the idea from e001bbae7147 ("ARM: cmpxchg: avoid warnings from
macro-ized cmpxchg() implementations") the m32r implementation is
changed to use a similar construct with a compound expression instead
of a typecast, which causes the compiler to not complain about an
unused result.

Link: http://lkml.kernel.org/r/1484432664-7015-1-git-send-email-sudipm.mukherjee@gmail.com
Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/cmpxchg.h |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN arch/m32r/include/asm/cmpxchg.h~m32r-fix-build-warning arch/m32r/include/asm/cmpxchg.h
--- a/arch/m32r/include/asm/cmpxchg.h~m32r-fix-build-warning
+++ a/arch/m32r/include/asm/cmpxchg.h
@@ -64,8 +64,10 @@ __xchg(unsigned long x, volatile void *p
 	return (tmp);
 }
 
-#define xchg(ptr, x)							\
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+#define xchg(ptr, x) ({							\
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr),		\
+				    sizeof(*(ptr))));			\
+})
 
 static __always_inline unsigned long
 __xchg_local(unsigned long x, volatile void *ptr, int size)
@@ -187,9 +189,12 @@ __cmpxchg(volatile void *ptr, unsigned l
 	return old;
 }
 
-#define cmpxchg(ptr, o, n)						 \
-	((__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)(o),	 \
-			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg(ptr, o, n) ({				\
+	((__typeof__(*(ptr)))				\
+		 __cmpxchg((ptr), (unsigned long)(o),	\
+			   (unsigned long)(n),		\
+			   sizeof(*(ptr))));		\
+})
 
 #include <asm-generic/cmpxchg-local.h>
 
_
