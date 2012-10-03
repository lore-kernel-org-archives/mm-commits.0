From: akpm@linux-foundation.org
Subject: + mm-thp-fix-mlock-statistics.patch added to -mm tree
Date: Wed, 03 Oct 2012 13:10:30 -0700
Message-ID: <20121003201031.13B375C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:59551 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2JCUKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2012 16:10:34 -0400
Received: by lahj13 with SMTP id j13so196601lah.1
        for <mm-commits@vger.kernel.org>; Wed, 03 Oct 2012 13:10:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, walken@google.com


The patch titled
     Subject: mm, thp: fix mlock statistics
has been added to the -mm tree.  Its filename is
     mm-thp-fix-mlock-statistics.patch

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
Subject: mm, thp: fix mlock statistics

NR_MLOCK is only accounted in single page units: there's no logic to
handle transparent hugepages.  This patch checks the appropriate number of
pages to adjust the statistics by so that the correct amount of memory is
reflected.

Currently:

		$ grep Mlocked /proc/meminfo
		Mlocked:           19636 kB

	#define MAP_SIZE	(4 << 30)	/* 4GB */

	void *ptr = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
			 MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
	mlock(ptr, MAP_SIZE);

		$ grep Mlocked /proc/meminfo
		Mlocked:           29844 kB

	munlock(ptr, MAP_SIZE);

		$ grep Mlocked /proc/meminfo
		Mlocked:           19636 kB

And with this patch:

		$ grep Mlock /proc/meminfo
		Mlocked:           19636 kB

	mlock(ptr, MAP_SIZE);

		$ grep Mlock /proc/meminfo
		Mlocked:         4213664 kB

	munlock(ptr, MAP_SIZE);

		$ grep Mlock /proc/meminfo
		Mlocked:           19636 kB

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Hugh Dickens <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    3 ++-
 mm/mlock.c    |    6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/internal.h~mm-thp-fix-mlock-statistics mm/internal.h
--- a/mm/internal.h~mm-thp-fix-mlock-statistics
+++ a/mm/internal.h
@@ -180,7 +180,8 @@ static inline int mlocked_vma_newpage(st
 		return 0;
 
 	if (!TestSetPageMlocked(page)) {
-		inc_zone_page_state(page, NR_MLOCK);
+		mod_zone_page_state(page_zone(page), NR_MLOCK,
+				    hpage_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 	}
 	return 1;
diff -puN mm/mlock.c~mm-thp-fix-mlock-statistics mm/mlock.c
--- a/mm/mlock.c~mm-thp-fix-mlock-statistics
+++ a/mm/mlock.c
@@ -78,7 +78,8 @@ void mlock_vma_page(struct page *page)
 	BUG_ON(!PageLocked(page));
 
 	if (!TestSetPageMlocked(page)) {
-		inc_zone_page_state(page, NR_MLOCK);
+		mod_zone_page_state(page_zone(page), NR_MLOCK,
+				    hpage_nr_pages(page));
 		count_vm_event(UNEVICTABLE_PGMLOCKED);
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
@@ -105,7 +106,8 @@ void munlock_vma_page(struct page *page)
 	BUG_ON(!PageLocked(page));
 
 	if (TestClearPageMlocked(page)) {
-		dec_zone_page_state(page, NR_MLOCK);
+		mod_zone_page_state(page_zone(page), NR_MLOCK,
+				    -hpage_nr_pages(page));
 		if (!isolate_lru_page(page)) {
 			int ret = SWAP_AGAIN;
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
acpi_memhotplugc-fix-memory-leak-when-memory-device-is-unbound-from-the-module-acpi_memhotplug.patch
acpi_memhotplugc-free-memory-device-if-acpi_memory_enable_device-failed.patch
acpi_memhotplugc-remove-memory-info-from-list-before-freeing-it.patch
acpi_memhotplugc-dont-allow-to-eject-the-memory-device-if-it-is-being-used.patch
acpi_memhotplugc-bind-the-memory-device-when-the-driver-is-being-loaded.patch
acpi_memhotplugc-auto-bind-the-memory-device-which-is-hotplugged-before-the-driver-is-loaded.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch
oom-remove-deprecated-oom_adj.patch
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
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-fix-up-zone-present-pages.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch
hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio_tree_foreach.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
kpageflags-fix-wrong-kpf_thp-on-non-huge-compound-pages.patch
memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove.patch
memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace.patch
mm-huge_memoryc-fix-build-warning-for-uma-kernels.patch
mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock.patch
mm-thp-fix-mlock-statistics.patch

