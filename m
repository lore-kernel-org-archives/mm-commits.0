From: akpm@linux-foundation.org
Subject: + mm-numa-disable-change-protection-for-vmavm_hugetlb.patch added to -mm tree
Date: Tue, 31 Mar 2015 14:35:29 -0700
Message-ID: <551b1321.fgHoR5M+ChHoN5ki%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbbCaVfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Mar 2015 17:35:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, a.p.zijlstra@chello.nl, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, mingo@elte.hu, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: disable change protection for vma(VM_HUGETLB)
has been added to the -mm tree.  Its filename is
     mm-numa-disable-change-protection-for-vmavm_hugetlb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-disable-change-protection-for-vmavm_hugetlb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-disable-change-protection-for-vmavm_hugetlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: numa: disable change protection for vma(VM_HUGETLB)

Currently when a process accesses a hugetlb range protected with PROTNONE,
unexpected COWs are triggered, which finally puts the hugetlb subsystem
into a broken/uncontrollable state, where for example h->resv_huge_pages
is subtracted too much and wraps around to a very large number, and the
free hugepage pool is no longer maintainable.

This patch simply stops changing protection for vma(VM_HUGETLB) to fix the
problem.  And this also allows us to avoid useless overhead of minor
faults.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Suggested-by: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "David Rientjes" <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/sched/fair.c~mm-numa-disable-change-protection-for-vmavm_hugetlb kernel/sched/fair.c
--- a/kernel/sched/fair.c~mm-numa-disable-change-protection-for-vmavm_hugetlb
+++ a/kernel/sched/fair.c
@@ -2165,8 +2165,10 @@ void task_numa_work(struct callback_head
 		vma = mm->mmap;
 	}
 	for (; vma; vma = vma->vm_next) {
-		if (!vma_migratable(vma) || !vma_policy_mof(vma))
+		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
+			is_vm_hugetlb_page(vma)) {
 			continue;
+		}
 
 		/*
 		 * Shared library pages mapped by multiple processes are not
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-numa-disable-change-protection-for-vmavm_hugetlb.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-v3.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-dont-call-__page_cache_release-for-hugetlb.patch
mm-hugetlb-introduce-pagehugeactive-flag.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

