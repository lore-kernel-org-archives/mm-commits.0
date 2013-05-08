From: akpm@linux-foundation.org
Subject: + mm-thp-use-the-right-function-when-updating-access-flags.patch added to -mm tree
Date: Wed, 08 May 2013 13:05:56 -0700
Message-ID: <20130508200556.73FEF31C078@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39021 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3EHUF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 16:05:57 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so218207ggm.3
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 13:05:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com


The patch titled
     Subject: mm/thp: use the correct function when updating access flags
has been added to the -mm tree.  Its filename is
     mm-thp-use-the-right-function-when-updating-access-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/thp: use the correct function when updating access flags

We should use pmdp_set_access_flags to update access flags.  Archs like
powerpc use extra checks(_PAGE_BUSY) when updating a hugepage PTE.  A
set_pmd_at doesn't do those checks.  We should use set_pmd_at only when
updating a none hugepage PTE.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-thp-use-the-right-function-when-updating-access-flags mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-use-the-right-function-when-updating-access-flags
+++ a/mm/huge_memory.c
@@ -1265,7 +1265,9 @@ struct page *follow_trans_huge_pmd(struc
 		 * young bit, instead of the current set_pmd_at.
 		 */
 		_pmd = pmd_mkyoung(pmd_mkdirty(*pmd));
-		set_pmd_at(mm, addr & HPAGE_PMD_MASK, pmd, _pmd);
+		if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
+					  pmd, _pmd,  1))
+			update_mmu_cache_pmd(vma, addr, pmd);
 	}
 	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
 		if (page->mapping && trylock_page(page)) {
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
mm-thp-use-the-right-function-when-updating-access-flags.patch

