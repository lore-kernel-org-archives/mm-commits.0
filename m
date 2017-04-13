From: akpm@linux-foundation.org
Subject: + zram-do-not-use-copy_page-with-non-page-alinged-address.patch
 added to -mm tree
Date: Thu, 13 Apr 2017 13:29:28 -0700
Message-ID: <58efdfa8.uC9cNoFxYHK5xmcO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755261AbdDMU3a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 16:29:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: do not use copy_page with non-page aligned address
has been added to the -mm tree.  Its filename is
     zram-do-not-use-copy_page-with-non-page-alinged-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-do-not-use-copy_page-with-non-page-alinged-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-do-not-use-copy_page-with-non-page-alinged-address.patch

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
Subject: zram: do not use copy_page with non-page aligned address

The copy_page is optimized memcpy for page-alinged address.  If it is used
with non-page aligned address, it can corrupt memory which means system
corruption.  With zram, it can happen with

1. 64K architecture
2. partial IO
3. slub debug

Partial IO need to allocate a page and zram allocates it via kmalloc. 
With slub debug, kmalloc(PAGE_SIZE) doesn't return page-size aligned
address.  And finally, copy_page(mem, cmem) corrupts memory.

So, this patch changes it to memcpy.

Acutaully, we don't need to change zram_bvec_write part because zsmalloc
returns page-aligned address in case of PAGE_SIZE class but it's not good
to rely on the internal of zsmalloc.

Note:
When this patch is merged to stable, clear_page should be fixed, too.
Unfortunately, recent zram removes it by "same page merge" feature
so it's hard to backport this patch to -stable tree.

I will handle it when I receive the mail from stable tree maintainer to
merge this patch to backport.

Fixes: 42e99bd ("zram: optimize memory operations with clear_page()/copy_page()")
Link: http://lkml.kernel.org/r/1492042622-12074-2-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-do-not-use-copy_page-with-non-page-alinged-address drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-do-not-use-copy_page-with-non-page-alinged-address
+++ a/drivers/block/zram/zram_drv.c
@@ -523,7 +523,7 @@ static int zram_decompress_page(struct z
 
 	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
-		copy_page(mem, cmem);
+		memcpy(mem, cmem, PAGE_SIZE);
 	} else {
 		struct zcomp_strm *zstrm = zcomp_stream_get(zram->comp);
 
@@ -717,7 +717,7 @@ compress_again:
 
 	if ((clen == PAGE_SIZE) && !is_partial_io(bvec)) {
 		src = kmap_atomic(page);
-		copy_page(cmem, src);
+		memcpy(cmem, src, PAGE_SIZE);
 		kunmap_atomic(src);
 	} else {
 		memcpy(cmem, src, clen);
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-operator-precedence-to-get-offset.patch
zram-do-not-use-copy_page-with-non-page-alinged-address.patch
zsmalloc-expand-class-bit.patch
mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-make-the-try_to_munlock-void-function-fix.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch
mm-remove-swap_-fix.patch
zram-handle-multiple-pages-attached-bios-bvec.patch
zram-partial-io-refactoring.patch
zram-use-zram_slot_lock-instead-of-raw-bit_spin_lock-op.patch
zram-remove-zram_meta-structure.patch
zram-introduce-zram-data-accessor.patch
zram-use-zram_free_page-instead-of-open-coded.patch

