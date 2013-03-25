From: akpm@linux-foundation.org
Subject: [merged] mm-zone_end_pfn-is-too-small.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:45:07 -0700
Message-ID: <20130325194507.E263C5A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:36485 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab3CYTpJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:45:09 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so110870ves.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:45:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rja@sgi.com, cody@linux.vnet.ibm.com, gbeshers@sgi.com, hedi@sgi.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: zone_end_pfn is too small
has been removed from the -mm tree.  Its filename was
     mm-zone_end_pfn-is-too-small.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Russ Anderson <rja@sgi.com>
Subject: mm: zone_end_pfn is too small

Booting with 32 TBytes memory hits BUG at mm/page_alloc.c:552! (output below).

The key hint is "page 4294967296 outside zone".
4294967296 = 0x100000000 (bit 32 is set).

The problem is in include/linux/mmzone.h:

530 static inline unsigned zone_end_pfn(const struct zone *zone)
531 {
532         return zone->zone_start_pfn + zone->spanned_pages;
533 }

zone_end_pfn is "unsigned" (32 bits).  Changing it to
"unsigned long" (64 bits) fixes the problem.

zone_end_pfn() was added recently in commit 108bcc96ef70 ("mm: add & use
zone_end_pfn() and zone_spans_pfn()")
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/include/linux/mmzone.h?id=108bcc96ef7047c02cad4d229f04da38186a3f3f

Output from the failure.

  No AGP bridge found
  page 4294967296 outside zone [ 4294967296 - 4327469056 ]
  ------------[ cut here ]------------
  kernel BUG at mm/page_alloc.c:552!
  invalid opcode: 0000 [#1] SMP
  Modules linked in:
  CPU 0
  Pid: 0, comm: swapper Not tainted 3.9.0-rc2.dtp+ #10
  RIP: 0010:[<ffffffff811477d2>]  [<ffffffff811477d2>] free_one_page+0x382/0x430
  RSP: 0000:ffffffff81943d98  EFLAGS: 00010002
  RAX: 0000000000000001 RBX: ffffea4000000000 RCX: 000000000000b3d9
  RDX: 0000000000000000 RSI: 0000000000000086 RDI: 0000000000000046
  RBP: ffffffff81943df8 R08: 0000000000000040 R09: 0000000000000023
  R10: 00000000000034bf R11: 00000000000034bf R12: ffffea4000000000
  R13: ffff981efefd9d80 R14: 0000000000000006 R15: 0000000000000006
  FS:  0000000000000000(0000) GS:ffffc90000000000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffffc7defefff000 CR3: 000000000194e000 CR4: 00000000000406b0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process swapper (pid: 0, threadinfo ffffffff81942000, task ffffffff81955420)
  Stack:
   00000000000000ff ffffc900000100a0 ffffc900000100d0 ffffffff00000040
   0000000000000000 0000000081148809 0000000000000097 ffffea4000000000
   0000000000000006 0000000000000002 0000000101e82bc0 ffffea4000001000
  Call Trace:
   [<ffffffff81149176>] __free_pages_ok+0x96/0xb0
   [<ffffffff8114c585>] __free_pages+0x25/0x50
   [<ffffffff8164c006>] __free_pages_bootmem+0x8a/0x8c
   [<ffffffff81a9684f>] __free_memory_core+0xea/0x131
   [<ffffffff81a968e0>] free_low_memory_core_early+0x4a/0x98
   [<ffffffff81a96973>] free_all_bootmem+0x45/0x47
   [<ffffffff81a87cff>] mem_init+0x7b/0x14c
   [<ffffffff81a70051>] start_kernel+0x216/0x433
   [<ffffffff81a6fc59>] ? repair_env_string+0x5b/0x5b
   [<ffffffff81a6f5f7>] x86_64_start_reservations+0x2a/0x2c
   [<ffffffff81a6f73d>] x86_64_start_kernel+0x144/0x153
  Code: 89 f1 ba 01 00 00 00 31 f6 d3 e2 4c 89 ef e8 66 a4 01 00 e9 2c fe ff ff 0f 0b eb fe 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 eb f3 <0f> 0b eb fe 0f 0b 0f 1f 84 00 00 00 00 00 eb f6 0f 0b eb fe 49
  RIP  [<ffffffff811477d2>] free_one_page+0x382/0x430
   RSP <ffffffff81943d98>
  ---[ end trace a7919e7f17c0a725 ]---
  Kernel panic - not syncing: Attempted to kill the idle task!

Signed-off-by: Russ Anderson <rja@sgi.com>
Reported-by: George Beshers <gbeshers@sgi.com>
Acked-by: Hedi Berriche <hedi@sgi.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-zone_end_pfn-is-too-small include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-zone_end_pfn-is-too-small
+++ a/include/linux/mmzone.h
@@ -527,7 +527,7 @@ static inline int zone_is_oom_locked(con
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
 }
 
-static inline unsigned zone_end_pfn(const struct zone *zone)
+static inline unsigned long zone_end_pfn(const struct zone *zone)
 {
 	return zone->zone_start_pfn + zone->spanned_pages;
 }
_

Patches currently in -mm which might be from rja@sgi.com are

mm-speedup-in-__early_pfn_to_nid.patch

