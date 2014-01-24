From: akpm@linux-foundation.org
Subject: [merged] metag-use-generic-fixmaph.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:07 -0800
Message-ID: <52e2b837.2H8ljy1vOFyiePHF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXTAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, james.hogan@imgtec.com, msalter@redhat.com

Subject: [merged] metag-use-generic-fixmaph.patch removed from -mm tree
To: msalter@redhat.com,james.hogan@imgtec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:07 -0800


The patch titled
     Subject: metag: use generic fixmap.h
has been removed from the -mm tree.  Its filename was
     metag-use-generic-fixmaph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: metag: use generic fixmap.h

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/metag/include/asm/fixmap.h |   32 ------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff -puN arch/metag/include/asm/fixmap.h~metag-use-generic-fixmaph arch/metag/include/asm/fixmap.h
--- a/arch/metag/include/asm/fixmap.h~metag-use-generic-fixmaph
+++ a/arch/metag/include/asm/fixmap.h
@@ -51,37 +51,7 @@ enum fixed_addresses {
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_START	((FIXADDR_TOP - FIXADDR_SIZE) & PMD_MASK)
 
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
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
