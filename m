From: akpm@linux-foundation.org
Subject: [merged] alpha-fix-the-bug-macro.patch removed from -mm tree
Date: Fri, 30 Jan 2009 11:14:10 -0800
Message-ID: <200901301914.n0UJEA5b027004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbZA3TOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 14:14:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: fix the BUG() macro
has been removed from the -mm tree.  Its filename was
     alpha-fix-the-bug-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: fix the BUG() macro
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

The commit "alpha: teach the compiler that BUG doesn't return"
(ed6b9b97f42c091630335bfb71a2931e6f86388b) moved the asm code into inline
function which takes __FILE__ and __LINE__ as arguments.  This violates
asm constrains there ("i" - an immediate operand with constant value), so
that compile may result in warning or error, depending on compiler
version.

Just adding an infinite loop to the BUG() is sufficient.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/bug.h |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN arch/alpha/include/asm/bug.h~alpha-fix-the-bug-macro arch/alpha/include/asm/bug.h
--- a/arch/alpha/include/asm/bug.h~alpha-fix-the-bug-macro
+++ a/arch/alpha/include/asm/bug.h
@@ -8,17 +8,12 @@
 
 /* ??? Would be nice to use .gprel32 here, but we can't be sure that the
    function loaded the GP, so this could fail in modules.  */
-static inline void ATTRIB_NORET __BUG(const char *file, int line)
-{
-	__asm__ __volatile__(
-		"call_pal %0  # bugchk\n\t"
-		".long %1\n\t.8byte %2"
-		       : : "i" (PAL_bugchk), "i"(line), "i"(file));
-	for ( ; ; )
-		;
-}
