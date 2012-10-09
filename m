From: akpm@linux-foundation.org
Subject: [merged] thp-release-page-in-page-pre-alloc-path.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:07:56 -0700
Message-ID: <20121009180757.3B087200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:58651 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:07:59 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so364507wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:07:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: release page in page pre-alloc path
has been removed from the -mm tree.  Its filename was
     thp-release-page-in-page-pre-alloc-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: thp: release page in page pre-alloc path

If NUMA is enabled, we can release the page in the page pre-alloc
operation, then the CONFIG_NUMA dependent code can be reduced

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN mm/huge_memory.c~thp-release-page-in-page-pre-alloc-path mm/huge_memory.c
--- a/mm/huge_memory.c~thp-release-page-in-page-pre-alloc-path
+++ a/mm/huge_memory.c
@@ -1873,15 +1873,12 @@ static void collapse_huge_page(struct mm
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
+	*hpage = new_page;
 	count_vm_event(THP_COLLAPSE_ALLOC);
 #endif
 
-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
-#ifdef CONFIG_NUMA
-		put_page(new_page);
-#endif
+	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
 		return;
-	}
 
 	/*
 	 * Prevent all access to pagetables with the exception of
@@ -1982,9 +1979,8 @@ static void collapse_huge_page(struct mm
 	prepare_pmd_huge_pte(pgtable, mm);
 	spin_unlock(&mm->page_table_lock);
 
-#ifndef CONFIG_NUMA
 	*hpage = NULL;
-#endif
+
 	khugepaged_pages_collapsed++;
 out_up_write:
 	up_write(&mm->mmap_sem);
@@ -1992,9 +1988,6 @@ out_up_write:
 
 out:
 	mem_cgroup_uncharge_page(new_page);
-#ifdef CONFIG_NUMA
-	put_page(new_page);
-#endif
 	goto out_up_write;
 }
 
@@ -2260,8 +2253,6 @@ static void khugepaged_do_scan(void)
 	barrier(); /* write khugepaged_pages_to_scan to local stack */
 
 	while (progress < pages) {
-		cond_resched();
