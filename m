From: akpm@linux-foundation.org
Subject: [merged] mm-pageattr-convert-noop-to-functional-fix.patch removed from -mm tree
Date: Mon, 15 Apr 2013 13:04:44 -0700
Message-ID: <20130415200444.761F231C056@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34190 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3DOUEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 16:04:45 -0400
Received: by mail-vc0-f202.google.com with SMTP id m16so504449vca.3
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 13:04:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bp@suse.de, stefan.bader@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pageattr: convert noop to functional fix
has been removed from the -mm tree.  Its filename was
     mm-pageattr-convert-noop-to-functional-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: pageattr: convert noop to functional fix

Commit a8aed3e0752b4beb ("x86/mm/pageattr: Prevent PSE and GLOABL
leftovers to confuse pmd/pte_present and pmd_huge") introduced some valid
fix but one location that didn't trigger the bug that lead to finding
those (small) problems, wasn't updated using the right variable.

The wrong variable was also initialized for no good reason, that may have
been the source of the confusion.  Remove the noop initialization
accordingly.

a8aed3e0752b4beb also erroneously removed one canon_pgprot pass meant to
clear pmd bitflags not supported in hardware by older CPUs, that
automatically gets corrected by this patch too by applying it to the right
variable in the new location.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/mm/pageattr.c~mm-pageattr-convert-noop-to-functional-fix arch/x86/mm/pageattr.c
--- a/arch/x86/mm/pageattr.c~mm-pageattr-convert-noop-to-functional-fix
+++ a/arch/x86/mm/pageattr.c
@@ -467,7 +467,7 @@ try_preserve_large_page(pte_t *kpte, uns
 	 * We are safe now. Check whether the new pgprot is the same:
 	 */
 	old_pte = *kpte;
-	old_prot = new_prot = req_prot = pte_pgprot(old_pte);
+	old_prot = req_prot = pte_pgprot(old_pte);
 
 	pgprot_val(req_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
@@ -478,12 +478,12 @@ try_preserve_large_page(pte_t *kpte, uns
 	 * a non present pmd. The canon_pgprot will clear _PAGE_GLOBAL
 	 * for the ancient hardware that doesn't support it.
 	 */
-	if (pgprot_val(new_prot) & _PAGE_PRESENT)
-		pgprot_val(new_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
+	if (pgprot_val(req_prot) & _PAGE_PRESENT)
+		pgprot_val(req_prot) |= _PAGE_PSE | _PAGE_GLOBAL;
 	else
-		pgprot_val(new_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
+		pgprot_val(req_prot) &= ~(_PAGE_PSE | _PAGE_GLOBAL);
 
-	new_prot = canon_pgprot(new_prot);
+	req_prot = canon_pgprot(req_prot);
 
 	/*
 	 * old_pte points to the large page base address. So we need
_

Patches currently in -mm which might be from aarcange@redhat.com are

thp-fix-comment-about-memory-barrier.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch

