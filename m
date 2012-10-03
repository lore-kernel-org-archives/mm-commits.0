From: akpm@linux-foundation.org
Subject: + mm-thp-fix-mlock-statistics-fix.patch added to -mm tree
Date: Wed, 03 Oct 2012 14:24:32 -0700
Message-ID: <20121003212433.3A9B15C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:48778 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab2JCVYg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2012 17:24:36 -0400
Received: by lbol12 with SMTP id l12so419332lbo.1
        for <mm-commits@vger.kernel.org>; Wed, 03 Oct 2012 14:24:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, walken@google.com


The patch titled
     Subject: mm, thp: fix mlock statistics fix
has been added to the -mm tree.  Its filename is
     mm-thp-fix-mlock-statistics-fix.patch

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
Subject: mm, thp: fix mlock statistics fix

On Wed, 3 Oct 2012, Andrew Morton wrote:

> The free_page_mlock() hunk gets dropped because free_page_mlock() is
> removed.  And clear_page_mlock() doesn't need this treatment.  But
> please check my handiwork.
>

I reviewed what was merged into -mm and clear_page_mlock() does need this
fix as well.  It's an easy fix, there's no need to pass "anon" into
clear_page_mlock() since PageHuge() is already checked in its only caller.

mm, thp: fix mlock statistics fix

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-thp-fix-mlock-statistics-fix mm/mlock.c
--- a/mm/mlock.c~mm-thp-fix-mlock-statistics-fix
+++ a/mm/mlock.c
@@ -56,7 +56,8 @@ void clear_page_mlock(struct page *page)
 	if (!TestClearPageMlocked(page))
 		return;
 
-	dec_zone_page_state(page, NR_MLOCK);
+	mod_zone_page_state(page_zone(page), NR_MLOCK,
+			    -hpage_nr_pages(page));
 	count_vm_event(UNEVICTABLE_PGCLEARED);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
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
make-gfp_notrack-definition-unconditional.patch
memory-hotplug-preparation-to-notify-memory-blocks-state-at-memory-hot-remove.patch
memory-hotplug-update-memory-blocks-state-and-notfy-theinformation-to-userspace.patch
mm-huge_memoryc-fix-build-warning-for-uma-kernels.patch
mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock.patch
mm-thp-fix-mlock-statistics.patch
mm-thp-fix-mlock-statistics-fix.patch
mm-use-%pk-for-proc-vmallocinfo.patch
mm-document-pagehuge-somewhat.patch

