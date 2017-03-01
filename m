From: akpm@linux-foundation.org
Subject: + mm-vmstats-add-thp_split_pud-event-for-clarify.patch added to
 -mm tree
Date: Tue, 28 Feb 2017 16:00:04 -0800
Message-ID: <58b60f04.JERpbAVdbmKqoC3J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751816AbdCAABa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 19:01:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, bigeasy@linutronix.de, cl@linux.com, ebru.akagunduz@gmail.com, guohanjun@huawei.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstats: add thp_split_pud event for clarity
has been added to the -mm tree.  Its filename is
     mm-vmstats-add-thp_split_pud-event-for-clarify.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmstats-add-thp_split_pud-event-for-clarify.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstats-add-thp_split_pud-event-for-clarify.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/vmstats: add thp_split_pud event for clarity

We added support for PUD-sized transparent hugepages, however we count the
event "thp split pud" into thp_split_pmd event.

To separate the event count of thp split pud from pmd, add a new event
named thp_split_pud.

Link: http://lkml.kernel.org/r/1488282380-5076-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    3 +++
 mm/huge_memory.c              |    2 +-
 mm/vmstat.c                   |    3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/vm_event_item.h~mm-vmstats-add-thp_split_pud-event-for-clarify include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-vmstats-add-thp_split_pud-event-for-clarify
+++ a/include/linux/vm_event_item.h
@@ -79,6 +79,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		THP_SPLIT_PAGE_FAILED,
 		THP_DEFERRED_SPLIT_PAGE,
 		THP_SPLIT_PMD,
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+		THP_SPLIT_PUD,
+#endif
 		THP_ZERO_PAGE_ALLOC,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 #endif
diff -puN mm/huge_memory.c~mm-vmstats-add-thp_split_pud-event-for-clarify mm/huge_memory.c
--- a/mm/huge_memory.c~mm-vmstats-add-thp_split_pud-event-for-clarify
+++ a/mm/huge_memory.c
@@ -1826,7 +1826,7 @@ static void __split_huge_pud_locked(stru
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PUD_SIZE, vma);
 	VM_BUG_ON(!pud_trans_huge(*pud) && !pud_devmap(*pud));
 
-	count_vm_event(THP_SPLIT_PMD);
+	count_vm_event(THP_SPLIT_PUD);
 
 	pudp_huge_clear_flush_notify(vma, haddr, pud);
 }
diff -puN mm/vmstat.c~mm-vmstats-add-thp_split_pud-event-for-clarify mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstats-add-thp_split_pud-event-for-clarify
+++ a/mm/vmstat.c
@@ -1065,6 +1065,9 @@ const char * const vmstat_text[] = {
 	"thp_split_page_failed",
 	"thp_deferred_split_page",
 	"thp_split_pmd",
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	"thp_split_pud",
+#endif
 	"thp_zero_page_alloc",
 	"thp_zero_page_alloc_failed",
 #endif
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

mm-vmstats-add-thp_split_pud-event-for-clarify.patch

