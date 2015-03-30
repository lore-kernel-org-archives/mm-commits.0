From: akpm@linux-foundation.org
Subject: + mm-move-lazy-free-pages-to-inactive-list-fix.patch added to -mm tree
Date: Mon, 30 Mar 2015 14:19:32 -0700
Message-ID: <5519bde4.tkF5Bq4yFj/s3ek6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbbC3VTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Mar 2015 17:19:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, Yalin.Wang@sonymobile.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document deactivate_page
has been added to the -mm tree.  Its filename is
     mm-move-lazy-free-pages-to-inactive-list-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-lazy-free-pages-to-inactive-list-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-lazy-free-pages-to-inactive-list-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: document deactivate_page

This patch adds function description for deactivate_page.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Wang, Yalin <Yalin.Wang@sonymobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/swap.c~mm-move-lazy-free-pages-to-inactive-list-fix mm/swap.c
--- a/mm/swap.c~mm-move-lazy-free-pages-to-inactive-list-fix
+++ a/mm/swap.c
@@ -866,6 +866,13 @@ void deactivate_file_page(struct page *p
 	}
 }
 
+/**
+ * deactivate_page - deactivate a page
+ * @page: page to deactivate
+ *
+ * This function moves @page to inactive list if @page was on active list and
+ * was not unevictable page to accelerate to reclaim @page.
+ */
 void deactivate_page(struct page *page)
 {
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-change-deactivate_page-with-deactivate_file_page.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-support-compaction-fix.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
zsmalloc-zsmalloc-documentation.patch
mm-zsmallocc-fix-comment-for-get_pages_per_zspage.patch
zram-remove-num_migrated-device-attr.patch
zram-move-compact_store-to-sysfs-functions-area.patch
zram-use-generic-start-end-io-accounting.patch
zram-describe-device-attrs-in-documentation.patch
zram-export-new-io_stat-sysfs-attrs.patch
zram-export-new-mm_stat-sysfs-attrs.patch
zram-deprecate-zram-attrs-sysfs-nodes.patch
zsmalloc-remove-synchronize_rcu-from-zs_compact.patch
zsmalloc-micro-optimize-zs_object_copy.patch
zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch
zsmalloc-fix-fatal-corruption-due-to-wrong-size-class-selection.patch
zsmalloc-remove-extra-cond_resched-in-__zs_compact.patch
linux-next.patch

