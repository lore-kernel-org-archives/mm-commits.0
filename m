From: akpm@linux-foundation.org
Subject: + mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch added to -mm tree
Date: Thu, 26 Apr 2012 16:39:30 -0700
Message-ID: <20120426233930.C399EA03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60637 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2DZXjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Apr 2012 19:39:32 -0400
Received: by qabg24 with SMTP id g24so4419qab.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Apr 2012 16:39:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: mm, thp: drop page_table_lock to uncharge memcg pages
has been added to the -mm tree.  Its filename is
     mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, thp: drop page_table_lock to uncharge memcg pages

mm->page_table_lock is hotly contested for page fault tests and isn't
necessary to do mem_cgroup_uncharge_page() in do_huge_pmd_wp_page().

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/huge_memory.c~mm-thp-drop-page_table_lock-to-uncharge-memcg-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-drop-page_table_lock-to-uncharge-memcg-pages
+++ a/mm/huge_memory.c
@@ -973,8 +973,10 @@ int do_huge_pmd_wp_page(struct mm_struct
 	spin_lock(&mm->page_table_lock);
 	put_page(page);
 	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
+		spin_unlock(&mm->page_table_lock);
 		mem_cgroup_uncharge_page(new_page);
 		put_page(new_page);
+		goto out;
 	} else {
 		pmd_t entry;
 		VM_BUG_ON(!PageHead(page));
_
Subject: Subject: mm, thp: drop page_table_lock to uncharge memcg pages

Patches currently in -mm which might be from rientjes@google.com are

mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma.patch
linux-next.patch
mm-memory_failure-let-the-compiler-add-the-function-name.patch
mm-mempolicyc-use-enum-value-mpol_rebind_once-instead-of-0-in-mpol_rebind_policy.patch
mm-hugetlbc-cleanup-to-use-long-vars-instead-of-int-in-region_count.patch
mm-thp-remove-unnecessary-ret-variable.patch
mm-thp-allow-fallback-when-pte_alloc_one-fails-for-huge-pmd.patch
mm-vmstatc-remov-debug-fs-entries-on-failure-of-file-creation-and-made-extfrag_debug_root-dentry-local.patch
thp-memcg-split-hugepage-for-memcg-oom-on-cow.patch
mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch

