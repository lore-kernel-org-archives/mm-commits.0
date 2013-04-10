From: akpm@linux-foundation.org
Subject: + mm-pageattr-convert-noop-to-functional-fix.patch added to -mm tree
Date: Wed, 10 Apr 2013 14:57:45 -0700
Message-ID: <20130410215745.884CA31C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:53357 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761894Ab3DJV5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 17:57:47 -0400
Received: by mail-ie0-f202.google.com with SMTP id x12so150572ief.5
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 14:57:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, bp@suse.de, stefan.bader@canonical.com


The patch titled
     Subject: mm: pageattr: convert noop to functional fix
has been added to the -mm tree.  Its filename is
     mm-pageattr-convert-noop-to-functional-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-pageattr-convert-noop-to-functional-fix.patch
thp-fix-comment-about-memory-barrier.patch

