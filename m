From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 =?US-ASCII?Q?mm-memmap=5Finit-iterate-over-memblock-regions-rather-tha?=
 =?US-ASCII?Q?t-check-each-pfn-fix-2.patch?= removed from -mm tree
Date: Wed, 03 Jun 2020 15:08:34 -0700
Message-ID: <20200603220834.pB50hRbI1%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgFCWIg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 18:08:36 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, cai@lca.pw, hoan@os.amperecomputing.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, sfr@canb.auug.org.au


The patch titled
     Subject: mm/compaction: fix the incorrect hole in fast_isolate_freepages()
has been removed from the -mm tree.  Its filename was
     mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix-2.patch

This patch was dropped because it was folded into mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/compaction: fix the incorrect hole in fast_isolate_freepages()

Qian reported that a crash happened in compaction.
http://lkml.kernel.org/r/8C537EB7-85EE-4DCF-943E-3CC0ED0DF56D@lca.pw

LTP: starting swapping01 (swapping01 -i 5)
page:ffffea0000aa0000 refcount:1 mapcount:0 mapping:000000002243743b index:0x0
flags: 0x1fffe000001000(reserved)
raw: 001fffe000001000 ffffea0000aa0008 ffffea0000aa0008 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn))
page_owner info is not present (never set?)
------------[ cut here ]------------
kernel BUG at mm/page_alloc.c:533!
...
CPU: 17 PID: 218 Comm: kcompactd0 Not tainted 5.7.0-rc2-next-20200423+ #7
...
RIP: 0010:set_pfnblock_flags_mask+0x150/0x210
...
RSP: 0018:ffffc900042ff858 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff9a002382
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff8884535b8e6c
RBP: ffffc900042ff8b8 R08: ffffed108a6b8459 R09: ffffed108a6b8459
R10: ffff8884535c22c7 R11: ffffed108a6b8458 R12: 000000000002a800
R13: ffffea0000aa0000 R14: ffff88847fff3000 R15: ffff88847fff3040
FS:  0000000000000000(0000) GS:ffff888453580000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd1eb4a1000 CR3: 000000083154c000 CR4: 00000000003406e0
Call Trace:
 isolate_freepages+0xb20/0x1140
 ? isolate_freepages_block+0x730/0x730
 ? mark_held_locks+0x34/0xb0
 ? free_unref_page+0x7d/0x90
 ? free_unref_page+0x7d/0x90
 ? check_flags.part.28+0x86/0x220
 compaction_alloc+0xdd/0x100
 migrate_pages+0x304/0x17e0
 ? __ClearPageMovable+0x100/0x100
 ? isolate_freepages+0x1140/0x1140
 compact_zone+0x1249/0x1e90
 ? compaction_suitable+0x260/0x260
 kcompactd_do_work+0x231/0x650
 ? sysfs_compact_node+0x80/0x80
 ? finish_wait+0xe6/0x110
 kcompactd+0x162/0x490
 ? kcompactd_do_work+0x650/0x650
 ? finish_wait+0x110/0x110
 ? __kasan_check_read+0x11/0x20
 ? __kthread_parkme+0xd4/0xf0
 ? kcompactd_do_work+0x650/0x650
 kthread+0x1f7/0x220
 ? kthread_create_worker_on_cpu+0xc0/0xc0
 ret_from_fork+0x27/0x50

After investigation, it turns out that this is introduced by commit of
linux-next: commit f6edbdb71877 ("mm: memmap_init: iterate over memblock
regions rather that check each PFN").

After investigation, it turns out that this is introduced by commit of
linux-next, the patch subject is:
  "mm: memmap_init: iterate over memblock regions rather that check each PFN".

Qian added debugging code. The debugging log shows that the fault page is
0x2a800000. From the system e820 map which is pasted at bottom, the page
is in e820 reserved range:
	BIOS-e820: [mem 0x0000000029ffe000-0x000000002a80afff] reserved
And it's in section [0x28000000, 0x2fffffff]. In that secion, there are
several usable ranges and some e820 reserved ranges.

For this kind of e820 reserved range, it won't be added to memblock allocator.
However, init_unavailable_mem() will initialize to add them into node 0,
zone 0. Before that commit, later, memmap_init() will add e820 reserved
ranges into the zone where they are contained, because it can pass
the checking of early_pfn_valid() and early_pfn_in_nid(). In this case,
the e820 reserved range where fault page 0x2a800000 is located is added
into DMA32 zone. After that commit, the e820 reserved rgions are kept
in node 0, zone 0, since we iterate over memblock regions to iniatialize
in memmap_init() instead, their node and zone won't be changed.

Now, fast_isolate_freepages() will use min mark directly as the migration
target if no page is found from buddy. However, the min mark is not checked
carefully, it could be in e820 reserved range, and trigger the
VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn)) when try to mark it
as skip.

Here, let's call pageblock_pfn_to_page() to get page of min_pfn, since it
will do careful checks and return NULL if the pfn is not qualified.

[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008c000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000028328fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000028329000-0x0000000028568fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000028569000-0x0000000028d85fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000028d86000-0x0000000028ee5fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000028ee6000-0x0000000029a04fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000029a05000-0x0000000029a08fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000029a09000-0x0000000029ee4fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000029ee5000-0x0000000029ef2fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000029ef3000-0x0000000029f22fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000029f23000-0x0000000029f23fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000029f24000-0x0000000029f24fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000029f25000-0x0000000029f28fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000029f29000-0x0000000029f29fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000029f2a000-0x0000000029f2bfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000029f2c000-0x0000000029f2cfff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000029f2d000-0x0000000029f2ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000029f30000-0x0000000029ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000029ffe000-0x000000002a80afff] reserved
[    0.000000] BIOS-e820: [mem 0x000000002a80b000-0x000000002a80efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000002a80f000-0x000000002a81ffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000002a820000-0x000000002a822fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000002a823000-0x0000000033a22fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000033a23000-0x0000000033a32fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000033a33000-0x0000000033a42fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000033a43000-0x0000000033a52fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000033a53000-0x0000000077ffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000078000000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed80fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000087effffff] usable
[    0.000000] BIOS-e820: [mem 0x000000087f000000-0x000000087fffffff] reserved

Link: http://lkml.kernel.org/r/20200521014407.29690-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Qian Cai <cai@lca.pw>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Hoan Tran <hoan@os.amperecomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn-fix-2
+++ a/mm/compaction.c
@@ -1418,7 +1418,9 @@ fast_isolate_freepages(struct compact_co
 				cc->free_pfn = highest;
 			} else {
 				if (cc->direct_compaction && pfn_valid(min_pfn)) {
-					page = pfn_to_page(min_pfn);
+					page = pageblock_pfn_to_page(min_pfn,
+						pageblock_end_pfn(min_pfn),
+						cc->zone);
 					cc->free_pfn = min_pfn;
 				}
 			}
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-memmap_init-iterate-over-memblock-regions-rather-that-check-each-pfn.patch
mm-remove-unused-free_bootmem_with_active_regions.patch
mm-page_allocc-only-tune-sysctl_lowmem_reserve_ratio-value-once-when-changing-it.patch
mm-page_allocc-clear-out-zone-lowmem_reserve-if-the-zone-is-empty.patch
mm-vmstatc-do-not-show-lowmem-reserve-protection-information-of-empty-zone.patch
