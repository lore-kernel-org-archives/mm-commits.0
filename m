From: akpm@linux-foundation.org
Subject: + sparc64-simplify-vmemmap_populate.patch added to -mm tree
Date: Fri, 13 Oct 2017 14:18:45 -0700
Message-ID: <59e12db5.KlVl/EY+8YoPlcbO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdJMVSr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 17:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, will.deacon@arm.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc64: simplify vmemmap_populate
has been added to the -mm tree.  Its filename is
     sparc64-simplify-vmemmap_populate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc64-simplify-vmemmap_populate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc64-simplify-vmemmap_populate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: sparc64: simplify vmemmap_populate

Remove duplicating code by using common functions vmemmap_pud_populate and
vmemmap_pgd_populate.

Link: http://lkml.kernel.org/r/20171013173214.27300-5-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Bob Picco <bob.picco@oracle.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_64.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff -puN arch/sparc/mm/init_64.c~sparc64-simplify-vmemmap_populate arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~sparc64-simplify-vmemmap_populate
+++ a/arch/sparc/mm/init_64.c
@@ -2643,30 +2643,19 @@ int __meminit vmemmap_populate(unsigned
 	vstart = vstart & PMD_MASK;
 	vend = ALIGN(vend, PMD_SIZE);
 	for (; vstart < vend; vstart += PMD_SIZE) {
-		pgd_t *pgd = pgd_offset_k(vstart);
+		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
 		unsigned long pte;
 		pud_t *pud;
 		pmd_t *pmd;
 
-		if (pgd_none(*pgd)) {
-			pud_t *new = vmemmap_alloc_block(PAGE_SIZE, node);
+		if (!pgd)
+			return -ENOMEM;
 
-			if (!new)
-				return -ENOMEM;
-			pgd_populate(&init_mm, pgd, new);
-		}
-
-		pud = pud_offset(pgd, vstart);
-		if (pud_none(*pud)) {
-			pmd_t *new = vmemmap_alloc_block(PAGE_SIZE, node);
-
-			if (!new)
-				return -ENOMEM;
-			pud_populate(&init_mm, pud, new);
-		}
+		pud = vmemmap_pud_populate(pgd, vstart, node);
+		if (!pud)
+			return -ENOMEM;
 
 		pmd = pmd_offset(pud, vstart);
