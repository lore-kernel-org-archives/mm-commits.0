From: akpm@linux-foundation.org
Subject: + arm-fix-freeing-of-page-tables-in-free_pgd_slow.patch added to -mm tree
Date: Wed, 27 Feb 2008 10:58:57 -0800
Message-ID: <200802271858.m1RIwvY2024709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755266AbYB0TAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 14:00:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, rmk@arm.linux.org.uk, schwidefsky@de.ibm.com


The patch titled
     arm: fix freeing of page tables in free_pgd_slow
has been added to the -mm tree.  Its filename is
     arm-fix-freeing-of-page-tables-in-free_pgd_slow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: arm: fix freeing of page tables in free_pgd_slow
=46rom: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>

Since 2f569af (CONFIG_HIGHPTE vs.  sub-page page tables.) pte_free() ca=
lls
pte_lock_deinit() and dec_zone_page_state().  So free_pgd_slow must not=
 call
the latter two when calling the first.

Signed-off-by: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/pgd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN arch/arm/mm/pgd.c~arm-fix-freeing-of-page-tables-in-free_pgd_=
slow arch/arm/mm/pgd.c
--- a/arch/arm/mm/pgd.c~arm-fix-freeing-of-page-tables-in-free_pgd_slow
+++ a/arch/arm/mm/pgd.c
@@ -75,7 +75,7 @@ no_pgd:
 void free_pgd_slow(struct mm_struct *mm, pgd_t *pgd)
 {
 	pmd_t *pmd;
-	struct page *pte;
+	pgtable_t pte;
=20
 	if (!pgd)
 		return;
@@ -90,10 +90,8 @@ void free_pgd_slow(struct mm_struct *mm,
 		goto free;
 	}
=20
-	pte =3D pmd_page(*pmd);
+	pte =3D pmd_pgtable(*pmd);
 	pmd_clear(pmd);
-	dec_zone_page_state(virt_to_page((unsigned long *)pgd), NR_PAGETABLE)=
;
-	pte_lock_deinit(pte);
 	pte_free(mm, pte);
 	pmd_free(mm, pmd);
 free:
_

Patches currently in -mm which might be from Uwe.Kleine-Koenig@digi.com=
 are

arm-fix-freeing-of-page-tables-in-free_pgd_slow.patch
