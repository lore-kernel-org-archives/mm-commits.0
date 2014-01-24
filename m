From: akpm@linux-foundation.org
Subject: [merged] x86-use-generic-fixmaph.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:00:03 -0800
Message-ID: <52e2b833.xlN62R0dyAmnQhbM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXTAE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:00:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, msalter@redhat.com

Subject: [merged] x86-use-generic-fixmaph.patch removed from -mm tree
To: msalter@redhat.com,hpa@zytor.com,mingo@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:00:03 -0800


The patch titled
     Subject: x86: use generic fixmap.h
has been removed from the -mm tree.  Its filename was
     x86-use-generic-fixmaph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: x86: use generic fixmap.h

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/fixmap.h |   59 --------------------------------
 1 file changed, 1 insertion(+), 58 deletions(-)

diff -puN arch/x86/include/asm/fixmap.h~x86-use-generic-fixmaph arch/x86/include/asm/fixmap.h
--- a/arch/x86/include/asm/fixmap.h~x86-use-generic-fixmaph
+++ a/arch/x86/include/asm/fixmap.h
@@ -175,64 +175,7 @@ static inline void __set_fixmap(enum fix
 }
 #endif
 
-#define set_fixmap(idx, phys)				\
-	__set_fixmap(idx, phys, PAGE_KERNEL)
-
-/*
- * Some hardware wants to get fixmapped without caching.
- */
-#define set_fixmap_nocache(idx, phys)			\
-	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
-
-#define clear_fixmap(idx)			\
-	__set_fixmap(idx, 0, __pgprot(0))
-
-#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
-#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
-
-extern void __this_fixmap_does_not_exist(void);
-
-/*
- * 'index to address' translation. If anyone tries to use the idx
- * directly without translation, we catch the bug with a NULL-deference
- * kernel oops. Illegal ranges of incoming indices are caught too.
- */
-static __always_inline unsigned long fix_to_virt(const unsigned int idx)
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
-
-static inline unsigned long virt_to_fix(const unsigned long vaddr)
-{
-	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
-	return __virt_to_fix(vaddr);
-}
-
-/* Return an pointer with offset calculated */
-static __always_inline unsigned long
-__set_fixmap_offset(enum fixed_addresses idx, phys_addr_t phys, pgprot_t flags)
-{
-	__set_fixmap(idx, phys, flags);
-	return fix_to_virt(idx) + (phys & (PAGE_SIZE - 1));
-}
-
-#define set_fixmap_offset(idx, phys)			\
-	__set_fixmap_offset(idx, phys, PAGE_KERNEL)
