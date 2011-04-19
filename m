From: akpm@linux-foundation.org
Subject: + mm-thp-optimize-memcg-charge-in-khugepaged.patch added to -mm tree
Date: Tue, 19 Apr 2011 16:08:43 -0700
Message-ID: <201104192308.p3JN8hFJ031054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab1DSXIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 19:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, minchan.kim@gmail.com, rientjes@google.com


The patch titled
     mm: thp: optimize memcg charge in khugepaged
has been added to the -mm tree.  Its filename is
     mm-thp-optimize-memcg-charge-in-khugepaged.patch

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
Subject: mm: thp: optimize memcg charge in khugepaged
From: Andrea Arcangeli <aarcange@redhat.com>

We don't need to hold the mmmap_sem through mem_cgroup_newpage_charge(),
the mmap_sem is only hold for keeping the vma stable and we don't need the
vma stable anymore after we return from alloc_hugepage_vma().

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-optimize-memcg-charge-in-khugepaged mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-optimize-memcg-charge-in-khugepaged
+++ a/mm/huge_memory.c
@@ -1771,12 +1771,9 @@ static void collapse_huge_page(struct mm
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 #ifndef CONFIG_NUMA
+	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
 	new_page = *hpage;
-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
-		up_read(&mm->mmap_sem);
-		return;
-	}
 #else
 	VM_BUG_ON(*hpage);
 	/*
@@ -1791,22 +1788,22 @@ static void collapse_huge_page(struct mm
 	 */
 	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
 				      node, __GFP_OTHER_NODE);
+	/* after allocating the hugepage upgrade to mmap_sem write mode */
+	up_read(&mm->mmap_sem);
 	if (unlikely(!new_page)) {
-		up_read(&mm->mmap_sem);
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
+#endif
+
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
-		up_read(&mm->mmap_sem);
+#ifdef CONFIG_NUMA
 		put_page(new_page);
+#endif
 		return;
 	}
-#endif
