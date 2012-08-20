From: akpm@linux-foundation.org
Subject: + thp-release-page-in-page-pre-alloc-path.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:08:28 -0700
Message-ID: <20120820210829.4D7111E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:51393 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab2HTVIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:08:30 -0400
Received: by mail-iy0-f202.google.com with SMTP id o24so925435ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:08:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com


The patch titled
     Subject: thp: release page in page pre-alloc path
has been added to the -mm tree.  Its filename is
     thp-release-page-in-page-pre-alloc-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1874,15 +1874,12 @@ static void collapse_huge_page(struct mm
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
@@ -1983,9 +1980,8 @@ static void collapse_huge_page(struct mm
 	prepare_pmd_huge_pte(pgtable, mm);
 	spin_unlock(&mm->page_table_lock);
 
-#ifndef CONFIG_NUMA
 	*hpage = NULL;
-#endif
+
 	khugepaged_pages_collapsed++;
 out_up_write:
 	up_write(&mm->mmap_sem);
@@ -1993,9 +1989,6 @@ out_up_write:
 
 out:
 	mem_cgroup_uncharge_page(new_page);
-#ifdef CONFIG_NUMA
-	put_page(new_page);
-#endif
 	goto out_up_write;
 }
 
@@ -2261,8 +2254,6 @@ static void khugepaged_do_scan(void)
 	barrier(); /* write khugepaged_pages_to_scan to local stack */
 
 	while (progress < pages) {
-		cond_resched();
-
 #ifndef CONFIG_NUMA
 		if (!hpage)
 			hpage = khugepaged_alloc_hugepage(&wait);
@@ -2275,8 +2266,12 @@ static void khugepaged_do_scan(void)
 				break;
 			wait = false;
 			khugepaged_alloc_sleep();
+		} else if (hpage) {
+			put_page(hpage);
+			hpage = NULL;
 		}
 #endif
+		cond_resched();
 
 		if (unlikely(kthread_should_stop() || freezing(current)))
 			break;
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

linux-next.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch

