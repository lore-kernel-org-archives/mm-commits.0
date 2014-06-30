From: akpm@linux-foundation.org
Subject: + zram-use-size_t-instead-of-u16.patch added to -mm tree
Date: Mon, 30 Jun 2014 15:46:24 -0700
Message-ID: <53b1e8c0.wqPJTERi1vkU4QvN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:44848 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaF3WqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jun 2014 18:46:25 -0400
Received: by mail-pd0-f201.google.com with SMTP id v10so1461945pde.0
        for <mm-commits@vger.kernel.org>; Mon, 30 Jun 2014 15:46:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, jmarchan@redhat.com, ngupta@vflare.org, sergey.senozhatsky@gmail.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use size_t instead of u16
has been added to the -mm tree.  Its filename is
     zram-use-size_t-instead-of-u16.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-size_t-instead-of-u16.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-size_t-instead-of-u16.patch

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
Subject: zram: use size_t instead of u16

Some architectures (eg, hexagon and PowerPC) could use PAGE_SHIFT of 16 or
more.  In these cases u16 is not sufficiently large to represent a
compressed page's size so use size_t.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Weijie Yang <weijie.yang@samsung.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-size_t-instead-of-u16 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-size_t-instead-of-u16
+++ a/drivers/block/zram/zram_drv.c
@@ -337,7 +337,7 @@ static int zram_decompress_page(struct z
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle;
-	u16 size;
+	size_t size;
 
 	read_lock(&meta->tb_lock);
 	handle = meta->table[index].handle;
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-revalidate-disk-after-capacity-change.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
zram-rename-struct-table-to-zram_table_entry.patch
zram-remove-unused-sector_size-define.patch
zram-use-size_t-instead-of-u16.patch
zram-remove-global-tb_lock-with-fine-grain-lock.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

