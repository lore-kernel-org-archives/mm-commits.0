From: akpm@linux-foundation.org
Subject: + cma-page_isolation-check-buddy-before-access-it.patch added to
 -mm tree
Date: Fri, 08 May 2015 15:52:47 -0700
Message-ID: <554d3e3f.QBwQnQJ9Hq8Z3S36%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbbEHWws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2015 18:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhuhui@xiaomi.com, iamjoonsoo.kim@lge.com, labbott@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: CMA: page_isolation: check buddy before accessing it
has been added to the -mm tree.  Its filename is
     cma-page_isolation-check-buddy-before-access-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-page_isolation-check-buddy-before-access-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-page_isolation-check-buddy-before-access-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Zhu <zhuhui@xiaomi.com>
Subject: CMA: page_isolation: check buddy before accessing it

I had an issue:

[  214.294917] Unable to handle kernel NULL pointer dereference at virtual address 0000082a
[  214.303013] pgd = cc970000
[  214.305721] [0000082a] *pgd=00000000
[  214.309316] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[  214.335704] PC is at get_pageblock_flags_group+0x5c/0xb0
[  214.341030] LR is at unset_migratetype_isolate+0x148/0x1b0
[  214.346523] pc : [<c00cc9a0>]    lr : [<c0109874>]    psr: 80000093
[  214.346523] sp : c7029d00  ip : 00000105  fp : c7029d1c
[  214.358005] r10: 00000001  r9 : 0000000a  r8 : 00000004
[  214.363231] r7 : 60000013  r6 : 000000a4  r5 : c0a357e4  r4 : 00000000
[  214.369761] r3 : 00000826  r2 : 00000002  r1 : 00000000  r0 : 0000003f
[  214.376291] Flags: Nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  214.383516] Control: 10c5387d  Table: 2cb7006a  DAC: 00000015
[  214.949720] Backtrace:
[  214.952192] [<c00cc944>] (get_pageblock_flags_group+0x0/0xb0) from [<c0109874>] (unset_migratetype_isolate+0x148/0x1b0)
[  214.962978]  r7:60000013 r6:c0a357c0 r5:c0a357e4 r4:c1555000
[  214.968693] [<c010972c>] (unset_migratetype_isolate+0x0/0x1b0) from [<c0109adc>] (undo_isolate_page_range+0xd0/0xdc)
[  214.979222] [<c0109a0c>] (undo_isolate_page_range+0x0/0xdc) from [<c00d097c>] (__alloc_contig_range+0x254/0x34c)
[  214.989398]  r9:000abc00 r8:c7028000 r7:000b1f53 r6:000b3e00 r5:00000005
r4:c7029db4
[  214.997308] [<c00d0728>] (__alloc_contig_range+0x0/0x34c) from [<c00d0a88>] (alloc_contig_range+0x14/0x18)
[  215.006973] [<c00d0a74>] (alloc_contig_range+0x0/0x18) from [<c0398148>] (dma_alloc_from_contiguous_addr+0x1ac/0x304)

This issue is because when calling unset_migratetype_isolate() to unset a
part of CMA memory, it try to access the buddy page to get its status:

		if (order >= pageblock_order) {
			page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
			buddy_idx = __find_buddy_index(page_idx, order);
			buddy = page + (buddy_idx - page_idx);

			if (!is_migrate_isolate_page(buddy)) {

But the begin addr of this part of CMA memory is very close to a part of
memory that is reserved at boot time (not in buddy system).  So add a
check before accessing it.

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Suggested-by: Laura Abbott <labbott@redhat.com>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_isolation.c~cma-page_isolation-check-buddy-before-access-it mm/page_isolation.c
--- a/mm/page_isolation.c~cma-page_isolation-check-buddy-before-access-it
+++ a/mm/page_isolation.c
@@ -101,7 +101,8 @@ void unset_migratetype_isolate(struct pa
 			buddy_idx = __find_buddy_index(page_idx, order);
 			buddy = page + (buddy_idx - page_idx);
 
-			if (!is_migrate_isolate_page(buddy)) {
+			if (pfn_valid_within(page_to_pfn(buddy))
+			    && !is_migrate_isolate_page(buddy)) {
 				__isolate_free_page(page, order);
 				kernel_map_pages(page, (1 << order), 1);
 				set_page_refcounted(page);
_

Patches currently in -mm which might be from zhuhui@xiaomi.com are

cma-page_isolation-check-buddy-before-access-it.patch

