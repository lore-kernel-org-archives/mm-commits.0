From: akpm@linux-foundation.org
Subject: + x86-use-generic-fixmaph.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:55 -0800
Message-ID: <52af5acb.xm+btlt/nYGNfAwO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3LPTzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, msalter@redhat.com

Subject: + x86-use-generic-fixmaph.patch added to -mm tree
To: msalter@redhat.com,hpa@zytor.com,mingo@redhat.com,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:54 -0800


The patch titled
     Subject: x86: use generic fixmap.h
has been added to the -mm tree.  Its filename is
     x86-use-generic-fixmaph.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-use-generic-fixmaph.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-use-generic-fixmaph.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
