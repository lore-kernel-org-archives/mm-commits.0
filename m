From: akpm@linux-foundation.org
Subject: + mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch added
 to -mm tree
Date: Wed, 27 Apr 2016 14:17:23 -0700
Message-ID: <57212c63.SLlZWLSGZjk6sBt1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcD0VRZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 17:17:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, boaz@plexistor.com, ebru.akagunduz@gmail.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix
has been added to the -mm tree.  Its filename is
     mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix

tweak comment text

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix
+++ a/mm/huge_memory.c
@@ -2488,8 +2488,8 @@ static void collapse_huge_page(struct mm
 	swap = get_mm_counter(mm, MM_SWAPENTS);
 	curr_allocstall = sum_vm_event(ALLOCSTALL);
 	/*
-	 * When system under pressure, don't swapin readahead.
-	 * So that avoid unnecessary resource consuming.
+	 * Don't perform swapin readahead when the system is under pressure,
+	 * to avoid unnecessary resource consumption.
 	 */
 	if (allocstall == curr_allocstall && swap != 0)
 		__collapse_huge_page_swapin(mm, vma, address, pmd);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
fsnotify-avoid-spurious-emfile-errors-from-inotify_init-checkpatch-fixes.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
procfs-fixes-pthread-cross-thread-naming-if-pr_dumpable-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

