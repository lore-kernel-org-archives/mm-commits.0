From: akpm@linux-foundation.org
Subject: [withdrawn]
 zsmalloc-do-not-remap-dst-page-while-prepare-next-src-page.patch removed
 from -mm tree
Date: Wed, 25 Mar 2015 14:16:26 -0700
Message-ID: <551325aa.A1LjrHvqHBpn9l6j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbbCYVQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:16:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, heesub.shin@samsung.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: do not remap dst page while prepare next src page
has been removed from the -mm tree.  Its filename was
     zsmalloc-do-not-remap-dst-page-while-prepare-next-src-page.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: do not remap dst page while prepare next src page

The object may belong to different pages.  zs_object_copy() handles this
case and maps a new source page (get_next_page() and kmap_atomic()) when
object crosses boundaries of the current source page.  But it also
performs unnecessary kunmap/kmap_atomic of the destination page (it
remains unchanged), which can be avoided.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Heesub Shin <heesub.shin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-do-not-remap-dst-page-while-prepare-next-src-page mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-do-not-remap-dst-page-while-prepare-next-src-page
+++ a/mm/zsmalloc.c
@@ -1538,12 +1538,10 @@ static void zs_object_copy(unsigned long
 			break;
 
 		if (s_off + size >= PAGE_SIZE) {
-			kunmap_atomic(d_addr);
 			kunmap_atomic(s_addr);
 			s_page = get_next_page(s_page);
 			BUG_ON(!s_page);
 			s_addr = kmap_atomic(s_page);
-			d_addr = kmap_atomic(d_page);
 			s_size = class->size - written;
 			s_off = 0;
 		} else {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

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
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
zsmalloc-zsmalloc-documentation.patch
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
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

