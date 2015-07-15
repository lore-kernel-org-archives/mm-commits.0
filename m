From: akpm@linux-foundation.org
Subject: + mm-page_owner-fix-possible-access-violation.patch added to -mm
 tree
Date: Wed, 15 Jul 2015 14:16:36 -0700
Message-ID: <55a6cdb4.oRGOVp19z1BMBYkn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbbGOVQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 17:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: fix possible access violation
has been added to the -mm tree.  Its filename is
     mm-page_owner-fix-possible-access-violation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-fix-possible-access-violation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-fix-possible-access-violation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/page_owner: fix possible access violation

When I tested my new patches, I found that page pointer which is used for
setting page_owner information is changed.  This is because page pointer
is used to set new migratetype in loop.  After this work, page pointer
could be out of bound.  If this wrong pointer is used for page_owner,
access violation happens.  Below is error message that I got.

[ 6175.025217] BUG: unable to handle kernel paging request at 0000000000b00018
[ 6175.026400] IP: [<ffffffff81025f30>] save_stack_address+0x30/0x40
[ 6175.027341] PGD 1af2d067 PUD 166e0067 PMD 0
[ 6175.028129] Oops: 0002 [#1] SMP
snip...
[ 6175.055349] Call Trace:
[ 6175.055780]  [<ffffffff81018c0f>] print_context_stack+0xcf/0x100
[ 6175.056794]  [<ffffffff810f8552>] ? __module_text_address+0x12/0x70
[ 6175.057848]  [<ffffffff810177cf>] dump_trace+0x15f/0x320
[ 6175.058751]  [<ffffffff8106b140>] ? do_flush_tlb_all+0x50/0x50
[ 6175.059732]  [<ffffffff810f5529>] ? smp_call_function_single+0xb9/0x120
[ 6175.060856]  [<ffffffff81025e3f>] save_stack_trace+0x2f/0x50
[ 6175.061812]  [<ffffffff811e3366>] __set_page_owner+0x46/0x70
[ 6175.062774]  [<ffffffff8117bd47>] __isolate_free_page+0x1f7/0x210
[ 6175.063804]  [<ffffffff8117bd81>] split_free_page+0x21/0xb0
[ 6175.064757]  [<ffffffff8119aa82>] isolate_freepages_block+0x1e2/0x410
[ 6175.065855]  [<ffffffff8119b53d>] compaction_alloc+0x22d/0x2d0
[ 6175.066850]  [<ffffffff811d3779>] migrate_pages+0x289/0x8b0
[ 6175.067798]  [<ffffffff8119c16a>] ? isolate_migratepages_block+0x28a/0x6e0
[ 6175.068960]  [<ffffffff8119a000>] ? kmalloc_slab+0xa0/0xa0
[ 6175.069892]  [<ffffffff8119b310>] ? ftrace_raw_event_mm_compaction_deplete_template+0xc0/0xc0
[ 6175.071327]  [<ffffffff8119ce49>] compact_zone+0x409/0x880
[ 6175.072261]  [<ffffffff8119d32d>] compact_zone_order+0x6d/0x90
[ 6175.073250]  [<ffffffff8119d5d0>] try_to_compact_pages+0x110/0x210
[ 6175.074297]  [<ffffffff8176e9e8>] __alloc_pages_direct_compact+0x3d/0xe6
[ 6175.075427]  [<ffffffff8117d42d>] __alloc_pages_nodemask+0x6cd/0x9a0
[ 6175.076517]  [<ffffffff811c2bf1>] alloc_pages_current+0x91/0x100
[ 6175.077545]  [<ffffffff811e7216>] runtest_store+0x296/0xa50
[ 6175.078497]  [<ffffffff813a553c>] ? simple_strtoull+0x2c/0x50
[ 6175.079465]  [<ffffffff812130bd>] simple_attr_write+0xbd/0xe0
[ 6175.080458]  [<ffffffff811eb038>] __vfs_write+0x28/0xf0
[ 6175.081349]  [<ffffffff811edc39>] ? __sb_start_write+0x49/0xf0
[ 6175.082345]  [<ffffffff8130fe25>] ? security_file_permission+0x45/0xd0
[ 6175.083453]  [<ffffffff811eb729>] vfs_write+0xa9/0x1b0
[ 6175.084334]  [<ffffffff811ec4f6>] SyS_write+0x46/0xb0
[ 6175.085196]  [<ffffffff81172803>] ? context_tracking_user_enter+0x13/0x20
[ 6175.086339]  [<ffffffff81024c55>] ? syscall_trace_leave+0xa5/0x120
[ 6175.087389]  [<ffffffff81779472>] system_call_fastpath+0x16/0x75

This patch fixes this error by moving up set_page_owner().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_owner-fix-possible-access-violation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_owner-fix-possible-access-violation
+++ a/mm/page_alloc.c
@@ -1994,6 +1994,8 @@ int __isolate_free_page(struct page *pag
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
+	set_page_owner(page, order, 0);
+
 	/* Set the pageblock if the isolated page is at least a pageblock */
 	if (order >= pageblock_order - 1) {
 		struct page *endpage = page + (1 << order) - 1;
@@ -2005,7 +2007,7 @@ int __isolate_free_page(struct page *pag
 		}
 	}
 
-	set_page_owner(page, order, 0);
+
 	return 1UL << order;
 }
 
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-page_owner-fix-possible-access-violation.patch
mm-page_owner-set-correct-gfp_mask-on-page_owner.patch

