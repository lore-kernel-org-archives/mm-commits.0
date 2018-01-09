From: akpm@linux-foundation.org
Subject: +
 mm-page_owner-remove-drain_all_pages-from-init_early_allocated_pages.patch
 added to -mm tree
Date: Tue, 09 Jan 2018 15:30:54 -0800
Message-ID: <5a5550ae.aR9FiQP3iFKHJ1EC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759187AbeAIXaz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:30:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osalvador@techadventures.net, ayush.m@samsung.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: remove drain_all_pages from init_early_allocated_pages
has been added to the -mm tree.  Its filename is
     mm-page_owner-remove-drain_all_pages-from-init_early_allocated_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-remove-drain_all_pages-from-init_early_allocated_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-remove-drain_all_pages-from-init_early_allocated_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@techadventures.net>
Subject: mm/page_owner.c: remove drain_all_pages from init_early_allocated_pages

When setting page_owner = on, the following warning can be seen in the
boot log:

 WARNING: CPU: 0 PID: 0 at mm/page_alloc.c:2537 drain_all_pages+0x171/0x1a0
 Modules linked in:
 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.15.0-rc7-next-20180109-1-default+ #7
 Hardware name: Dell Inc. Latitude E7470/0T6HHJ, BIOS 1.11.3 11/09/2016
 RIP: 0010:drain_all_pages+0x171/0x1a0
 RSP: 0000:ffffffff82003ea8 EFLAGS: 00010246
 RAX: 000000000000000f RBX: ffffffffffffffff RCX: ffffffff8205b388
 RDX: 0000000000000001 RSI: 0000000000000096 RDI: 0000000000000202
 RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000000af
 R10: 0000000000000004 R11: 00000000000000ae R12: ffff88024dfdcec0
 R13: ffffffff82530740 R14: 0000000000000000 R15: 00000000a8831448
 FS:  0000000000000000(0000) GS:ffff88024dc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffff88024dfff000 CR3: 000000000200a001 CR4: 00000000000606b0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  init_page_owner+0x4e/0x260
  start_kernel+0x3e6/0x4a6
  ? set_init_arg+0x55/0x55
  secondary_startup_64+0xa5/0xb0
 Code: c5 ed ff 89 df 48 c7 c6 20 3b 71 82 e8 f9 4b 52 00 3b 05 d7 0b f8 00 89 c3 72 d5 5b 5d 41 5
 ---[ end trace 45da7f0cb4aef07b ]---

This warning is shown because we are calling drain_all_pages() in
init_early_allocated_pages(), but mm_percpu_wq is not up yet, it is being
set up later on in kernel_init_freeable() -> init_mm_internals().

Link: http://lkml.kernel.org/r/20180109153921.GA13070@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ayush Mittal <ayush.m@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_owner.c~mm-page_owner-remove-drain_all_pages-from-init_early_allocated_pages mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-remove-drain_all_pages-from-init_early_allocated_pages
+++ a/mm/page_owner.c
@@ -616,7 +616,6 @@ static void init_early_allocated_pages(v
 {
 	pg_data_t *pgdat;
 
-	drain_all_pages(NULL);
 	for_each_online_pgdat(pgdat)
 		init_zones_in_node(pgdat);
 }
_

Patches currently in -mm which might be from osalvador@techadventures.net are

mm-page_owner-remove-drain_all_pages-from-init_early_allocated_pages.patch
mm-slab-remove-redundant-assignments-for-slab_state.patch
mm-memory_hotplug-remove-unnecesary-check-from-register_page_bootmem_info_section.patch
mm-memory_hotplug-remove-second-__nr_to_section-in-register_page_bootmem_info_section.patch

