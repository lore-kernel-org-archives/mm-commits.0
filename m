From: akpm@google.com
Subject: + mm-huge_memory-fix-typo-when-updating-mmu-cache.patch added to -mm tree
Date: Fri, 14 Oct 2011 13:36:26 -0700
Message-ID: <201110142036.p9EKaQfv013698@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:49308 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1JNUga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Oct 2011 16:36:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, jweiner@redhat.com


The patch titled
     Subject: mm/huge_memory: fix typo when updating mmu cache
has been added to the -mm tree.  Its filename is
     mm-huge_memory-fix-typo-when-updating-mmu-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/huge_memory: fix typo when updating mmu cache

There are three cases of update_mmu_cache() in the file, and the case in
function collapse_huge_page() has a typo, namely the last parameter used,
which is corrected based on the other two cases.

Due to the define of update_mmu_cache by X86, the only arch that
implements THP currently, the change here has no really crystal point, but
one or two minutes of efforts could be saved for those archs that are
likely to support THP in future.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-huge_memory-fix-typo-when-updating-mmu-cache mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memory-fix-typo-when-updating-mmu-cache
+++ a/mm/huge_memory.c
@@ -1967,7 +1967,7 @@ static void collapse_huge_page(struct mm
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address);
 	set_pmd_at(mm, address, pmd, _pmd);
-	update_mmu_cache(vma, address, entry);
+	update_mmu_cache(vma, address, _pmd);
 	prepare_pmd_huge_pte(pgtable, mm);
 	mm->nr_ptes--;
 	spin_unlock(&mm->page_table_lock);
_
Subject: Subject: mm/huge_memory: fix typo when updating mmu cache

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
mm-huge_memory-fix-copying-user-highpage.patch
mm-huge_memory-fix-typo-when-updating-mmu-cache.patch

