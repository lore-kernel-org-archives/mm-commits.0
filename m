From: akpm@linux-foundation.org
Subject: + zram-remove-unnecessary-free.patch added to -mm tree
Date: Mon, 13 Jan 2014 15:59:59 -0800
Message-ID: <52d47dff.ATxspoayoYyuabia%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaANAAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 19:00:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: + zram-remove-unnecessary-free.patch added to -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 15:59:59 -0800


The patch titled
     Subject: zram: remove unnecessary free
has been added to the -mm tree.  Its filename is
     zram-remove-unnecessary-free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-remove-unnecessary-free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-remove-unnecessary-free.patch

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
Subject: zram: remove unnecessary free

a0c516cbfc ("zram: don't grab mutex in zram_slot_free_noity") introduced
pending zram slot free in zram's write path in case of missing slot free
by memory allocation failure in zram_slot_free_notify but it is not
necessary because we have already freed the slot right before overwriting.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-unnecessary-free drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-unnecessary-free
+++ a/drivers/block/zram/zram_drv.c
@@ -441,14 +441,6 @@ static int zram_bvec_write(struct zram *
 		goto out;
 	}
 
-	/*
-	 * zram_slot_free_notify could miss free so that let's
-	 * double check.
-	 */
-	if (unlikely(meta->table[index].handle ||
-			zram_test_flag(meta, index, ZRAM_ZERO)))
-		zram_free_page(zram, index);
-
 	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       meta->compress_workmem);
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-remove-bug_on-from-mlock_vma_page.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-zswapc-change-params-from-hidden-to-ro.patch
mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch
zram-remove-old-private-project-comment.patch
zram-add-copyright.patch
zsmalloc-add-copyright.patch
zram-add-zram-maintainers.patch
zsmalloc-add-maintainers.patch
zram-fix-race-between-reset-and-flushing-pending-work.patch
zram-delay-pending-free-request-in-read-path.patch
zram-remove-unnecessary-free.patch
debugging-keep-track-of-page-owners.patch
zram-use-atomic-operation-for-stat.patch

