From: akpm@linux-foundation.org
Subject: +
 zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch added to -mm tree
Date: Wed, 25 Mar 2015 14:04:55 -0700
Message-ID: <551322f7.NKD32wiEgibfD9dR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbCYVE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, gunho.lee@lge.com, heesub.shin@samsung.com, juno.choi@lge.com, ngupta@vflare.org, opensource.ganesh@gmail.com, semenzato@google.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove unnecessary insertion/removal of zspage in compaction
has been added to the -mm tree.  Its filename is
     zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch

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
Subject: zsmalloc: remove unnecessary insertion/removal of zspage in compaction

In putback_zspage, we don't need to insert a zspage into list of zspage
in size_class again to just fix fullness group. We could do directly
without reinsertion so we could save some instuctions.

Reported-by: Heesub Shin <heesub.shin@samsung.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Gunho Lee <gunho.lee@lge.com>
Cc: Juneho Choi <juno.choi@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction
+++ a/mm/zsmalloc.c
@@ -1676,14 +1676,14 @@ static struct page *alloc_target_page(st
 static void putback_zspage(struct zs_pool *pool, struct size_class *class,
 				struct page *first_page)
 {
-	int class_idx;
 	enum fullness_group fullness;
 
 	BUG_ON(!is_first_page(first_page));
 
-	get_zspage_mapping(first_page, &class_idx, &fullness);
+	fullness = get_fullness_group(first_page);
 	insert_zspage(first_page, class, fullness);
-	fullness = fix_fullness_group(class, first_page);
+	set_zspage_mapping(first_page, class->index, fullness);
+
 	if (fullness == ZS_EMPTY) {
 		zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
 			class->size, class->pages_per_zspage));
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
zsmalloc-do-not-remap-dst-page-while-prepare-next-src-page.patch
zsmalloc-micro-optimize-zs_object_copy.patch
zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch
linux-next.patch

