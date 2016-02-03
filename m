From: akpm@linux-foundation.org
Subject: + um-asm-pageh-remove-the-pte_high-member-from-struct-pte_t.patch added to -mm tree
Date: Tue, 02 Feb 2016 19:32:12 -0800
Message-ID: <56b174bc.lWsEZJXRVBsHiUP2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbcBCDcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 22:32:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicstange@gmail.com, dan.j.williams@intel.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um: asm/page.h: remove the pte_high member from struct pte_t
has been added to the -mm tree.  Its filename is
     um-asm-pageh-remove-the-pte_high-member-from-struct-pte_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/um-asm-pageh-remove-the-pte_high-member-from-struct-pte_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/um-asm-pageh-remove-the-pte_high-member-from-struct-pte_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolai Stange <nicstange@gmail.com>
Subject: um: asm/page.h: remove the pte_high member from struct pte_t

Commit 16da306849d0 ("um: kill pfn_t")
introduced a compile warning for defconfig (SUBARCH=i386):

  arch/um/kernel/skas/mmu.c:38:206:
      warning: right shift count >= width of type [-Wshift-count-overflow]

Aforementioned patch changes the definition of the phys_to_pfn() macro from

  ((pfn_t) ((p) >> PAGE_SHIFT))

to

  ((p) >> PAGE_SHIFT)

This effectively changes the phys_to_pfn() expansion's type from
unsigned long long to unsigned long.

Through the callchain init_stub_pte() => mk_pte(), the expansion of
phys_to_pfn() is (indirectly) fed into the 'phys' argument of the
pte_set_val(pte, phys, prot) macro, eventually leading to

  (pte).pte_high = (phys) >> 32;

This results in the warning from above.

Since UML only deals with 32 bit addresses, the upper 32 bits from 'phys'
used to be always zero anyway. Also, all page protection flags defined by
UML don't use any bits beyond bit 9. Since the contents of a PTE are
defined within architecture scope only, the ->pte_high member can be safely
removed.

Remove the ->pte_high member from struct pte_t.
Rename ->pte_low to ->pte.
Adapt the pte helper macros in arch/um/include/asm/page.h.

Noteworthy is the pte_copy() macro where a smp_wmb() gets dropped.  This
write barrier doesn't seem to be paired with any read barrier though and
thus, was useless anyway.

Fixes: 16da306849d0 ("um: kill pfn_t")
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Nicolai Stange <nicstange@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/page.h |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff -puN arch/um/include/asm/page.h~um-asm-pageh-remove-the-pte_high-member-from-struct-pte_t arch/um/include/asm/page.h
--- a/arch/um/include/asm/page.h~um-asm-pageh-remove-the-pte_high-member-from-struct-pte_t
+++ a/arch/um/include/asm/page.h
@@ -34,21 +34,18 @@ struct page;
 
 #if defined(CONFIG_3_LEVEL_PGTABLES) && !defined(CONFIG_64BIT)
 
-typedef struct { unsigned long pte_low, pte_high; } pte_t;
+typedef struct { unsigned long pte; } pte_t;
 typedef struct { unsigned long pmd; } pmd_t;
 typedef struct { unsigned long pgd; } pgd_t;
-#define pte_val(x) ((x).pte_low | ((unsigned long long) (x).pte_high << 32))
+#define pte_val(p) ((p).pte)
 
-#define pte_get_bits(pte, bits) ((pte).pte_low & (bits))
-#define pte_set_bits(pte, bits) ((pte).pte_low |= (bits))
-#define pte_clear_bits(pte, bits) ((pte).pte_low &= ~(bits))
-#define pte_copy(to, from) ({ (to).pte_high = (from).pte_high; \
-			      smp_wmb(); \
-			      (to).pte_low = (from).pte_low; })
-#define pte_is_zero(pte) (!((pte).pte_low & ~_PAGE_NEWPAGE) && !(pte).pte_high)
-#define pte_set_val(pte, phys, prot) \
-	({ (pte).pte_high = (phys) >> 32; \
-	   (pte).pte_low = (phys) | pgprot_val(prot); })
+#define pte_get_bits(p, bits) ((p).pte & (bits))
+#define pte_set_bits(p, bits) ((p).pte |= (bits))
+#define pte_clear_bits(p, bits) ((p).pte &= ~(bits))
+#define pte_copy(to, from) ({ (to).pte = (from).pte; })
+#define pte_is_zero(p) (!((p).pte & ~_PAGE_NEWPAGE))
+#define pte_set_val(p, phys, prot) \
+	({ (p).pte = (phys) | pgprot_val(prot); })
 
 #define pmd_val(x)	((x).pmd)
 #define __pmd(x) ((pmd_t) { (x) } )
_

Patches currently in -mm which might be from nicstange@gmail.com are

um-asm-pageh-remove-the-pte_high-member-from-struct-pte_t.patch

