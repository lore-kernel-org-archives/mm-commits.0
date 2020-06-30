From: akpm@linux-foundation.org
Subject: + mm-page_alloc-silence-a-kasan-false-positive.patch added
 to -mm tree
Date: Tue, 30 Jun 2020 16:46:01 -0700
Message-ID: <20200630234601.HpqRh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbgF3XqD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 30 Jun 2020 19:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com, glider@google.com, dvyukov@google.com, borntraeger@de.ibm.com, cai@lca.pw


The patch titled
     Subject: mm/page_alloc: silence a KASAN false positive
has been added to the -mm tree.  Its filename is
     mm-page_alloc-silence-a-kasan-false-positive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-silence-a-kasan-false-positive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-silence-a-kasan-false-positive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm/page_alloc: silence a KASAN false positive

kernel_init_free_pages() will use memset() on s390 to clear all pages from
kmalloc_order() which will override KASAN redzones because a redzone was
setup from the end of the allocation size to the end of the last page. 
Silence it by not reporting it there.  An example of the report is,

 BUG: KASAN: slab-out-of-bounds in __free_pages_ok
 Write of size 4096 at addr 000000014beaa000
 Call Trace:
 show_stack+0x152/0x210
 dump_stack+0x1f8/0x248
 print_address_description.isra.13+0x5e/0x4d0
 kasan_report+0x130/0x178
 check_memory_region+0x190/0x218
 memset+0x34/0x60
 __free_pages_ok+0x894/0x12f0
 kfree+0x4f2/0x5e0
 unpack_to_rootfs+0x60e/0x650
 populate_rootfs+0x56/0x358
 do_one_initcall+0x1f4/0xa20
 kernel_init_freeable+0x758/0x7e8
 kernel_init+0x1c/0x170
 ret_from_fork+0x24/0x28
 Memory state around the buggy address:
 000000014bea9f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 000000014bea9f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>000000014beaa000: 03 fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
                    ^
 000000014beaa080: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
 000000014beaa100: fe fe fe fe fe fe fe fe fe fe fe fe fe fe

Link: http://lkml.kernel.org/r/20200610052154.5180-1-cai@lca.pw
Fixes: 6471384af2a6 ("mm: security: introduce init_on_alloc=1 and init_on_free=1 boot options")
Signed-off-by: Qian Cai <cai@lca.pw>
Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Vasily Gorbik <gor@linux.ibm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-silence-a-kasan-false-positive
+++ a/mm/page_alloc.c
@@ -1158,8 +1158,11 @@ static void kernel_init_free_pages(struc
 {
 	int i;
 
+	/* s390's use of memset() could override KASAN redzones. */
+	kasan_disable_current();
 	for (i = 0; i < numpages; i++)
 		clear_highpage(page + i);
+	kasan_enable_current();
 }
 
 static __always_inline bool free_pages_prepare(struct page *page,
_

Patches currently in -mm which might be from cai@lca.pw are

mm-page_alloc-silence-a-kasan-false-positive.patch
mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
mm-annotate-a-data-race-in-page_zonenum.patch
