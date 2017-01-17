From: akpm@linux-foundation.org
Subject: + m32r-fix-build-warning.patch added to -mm tree
Date: Tue, 17 Jan 2017 15:31:10 -0800
Message-ID: <587ea93e.3pmRwFKOcS1W4Rfk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751819AbdAQXbO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 18:31:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, sudip.mukherjee@codethink.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: fix build warning
has been added to the -mm tree.  Its filename is
     m32r-fix-build-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-fix-build-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-fix-build-warning.patch

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

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

m32r-fix-build-warning.patch
frv-pci-frv-fix-build-warning.patch

