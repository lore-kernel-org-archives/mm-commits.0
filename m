From: akpm@linux-foundation.org
Subject: + mips-make-bug-__noreturn.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:01:04 -0800
Message-ID: <200811212301.mALN14qD009984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbYKUXBo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:01:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ddaney@caviumnetworks.com, ralf@linux-mips.org


The patch titled
     mips: make BUG() __noreturn
has been added to the -mm tree.  Its filename is
     mips-make-bug-__noreturn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: make BUG() __noreturn
From: David Daney <ddaney@caviumnetworks.com>

Often we do things like put BUG() in the default clause of a case
statement.  Since it was not declared __noreturn, this could sometimes
lead to bogus compiler warnings that variables were used uninitialized.

There is a small problem in that we have to put a magic while(1); loop to
fool GCC into really thinking it is noreturn.  This makes the new BUG()
function 3 instructions long instead of just 1, but I think it is worth it
as it is now unnecessary to do extra work to silence the 'used
uninitialized' warnings.

I also re-wrote BUG_ON so that if it is given a constant condition, it
just does BUG() instead of loading a constant value in to a register and
testing it.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/bug.h |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff -puN arch/mips/include/asm/bug.h~mips-make-bug-__noreturn arch/mips/include/asm/bug.h
--- a/arch/mips/include/asm/bug.h~mips-make-bug-__noreturn
+++ a/arch/mips/include/asm/bug.h
@@ -7,20 +7,31 @@
 
 #include <asm/break.h>
 
-#define BUG()								\
-do {									\
-	__asm__ __volatile__("break %0" : : "i" (BRK_BUG));		\
-} while (0)
+static inline void __noreturn BUG(void)
+{
+	__asm__ __volatile__("break %0" : : "i" (BRK_BUG));
+	/* Fool GCC into thinking the function doesn't return. */
+	while (1)
+		;
+}
 
 #define HAVE_ARCH_BUG
 
 #if (_MIPS_ISA > _MIPS_ISA_MIPS1)
 
-#define BUG_ON(condition)						\
-do {									\
-	__asm__ __volatile__("tne $0, %0, %1"				\
-			     : : "r" (condition), "i" (BRK_BUG));	\
-} while (0)
+static inline void  __BUG_ON(unsigned long condition)
+{
+	if (__builtin_constant_p(condition)) {
+		if (condition)
+			BUG();
+		else
+			return;
+	}
+	__asm__ __volatile__("tne $0, %0, %1"
+			     : : "r" (condition), "i" (BRK_BUG));
+}
+
+#define BUG_ON(C) __BUG_ON((unsigned long)(C))
 
 #define HAVE_ARCH_BUG_ON
 
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

mips-make-bug-__noreturn.patch

