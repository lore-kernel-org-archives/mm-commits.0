From: akpm@linux-foundation.org
Subject: + thp-fix-the-count-of-thp_collapse_alloc.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:08:04 -0700
Message-ID: <20120820210805.A461A5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38171 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2HTVII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:08:08 -0400
Received: by eekd4 with SMTP id d4so300064eek.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:08:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, hughd@google.com, rientjes@google.com


The patch titled
     Subject: thp: fix the count of THP_COLLAPSE_ALLOC
has been added to the -mm tree.  Its filename is
     thp-fix-the-count-of-thp_collapse_alloc.patch

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
Subject: thp: fix the count of THP_COLLAPSE_ALLOC

THP_COLLAPSE_ALLOC is double counted if NUMA is disabled since it has
already been calculated in khugepaged_alloc_hugepage

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-fix-the-count-of-thp_collapse_alloc mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-the-count-of-thp_collapse_alloc
+++ a/mm/huge_memory.c
@@ -1875,9 +1875,9 @@ static void collapse_huge_page(struct mm
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
+	count_vm_event(THP_COLLAPSE_ALLOC);
 #endif
 
-	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 #ifdef CONFIG_NUMA
 		put_page(new_page);
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

