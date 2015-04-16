From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:54:02 -0700
Message-ID: <552fe92a.M/mWM1X5LdO1AocD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbbDPQsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, gunho.lee@lge.com, heesub.shin@samsung.com, juno.choi@lge.com, ngupta@vflare.org, opensource.ganesh@gmail.com, semenzato@google.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove unnecessary insertion/removal of zspage in compaction
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-unnecessary-insertion-removal-of-zspage-in-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1678,14 +1678,14 @@ static struct page *alloc_target_page(st
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

origin.patch
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
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
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

