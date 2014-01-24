From: akpm@linux-foundation.org
Subject: [merged] mips-use-generic-fixmaph.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:11 -0800
Message-ID: <52e2b83b.45up4gXvNhfdlvbd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXTAL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, msalter@redhat.com

Subject: [merged] mips-use-generic-fixmaph.patch removed from -mm tree
To: msalter@redhat.com,ralf@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:11 -0800


The patch titled
     Subject: mips: use generic fixmap.h
has been removed from the -mm tree.  Its filename was
     mips-use-generic-fixmaph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: mips: use generic fixmap.h

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/fixmap.h |   33 -------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff -puN arch/mips/include/asm/fixmap.h~mips-use-generic-fixmaph arch/mips/include/asm/fixmap.h
--- a/arch/mips/include/asm/fixmap.h~mips-use-generic-fixmaph
+++ a/arch/mips/include/asm/fixmap.h
@@ -71,38 +71,7 @@ enum fixed_addresses {
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
 
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-/*
- * 'index to address' translation. If anyone tries to use the idx
- * directly without tranlation, we catch the bug with a NULL-deference
- * kernel oops. Illegal ranges of incoming indices are caught too.
- */
-static inline unsigned long fix_to_virt(const unsigned int idx)
-{
-	/*
-	 * this branch gets completely eliminated after inlining,
-	 * except when someone tries to use fixaddr indices in an
-	 * illegal way. (such as mixing up address types or using
-	 * out-of-range indices).
-	 *
-	 * If it doesn't get removed, the linker will complain
-	 * loudly with a reasonably clear error message..
-	 */
-	if (idx >= __end_of_fixed_addresses)
-		__this_fixmap_does_not_exist();
-
-	return __fix_to_virt(idx);
-}
