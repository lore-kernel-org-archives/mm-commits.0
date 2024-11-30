Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7320335D3
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 03:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732936959; cv=none; b=uEU98o7lgpt0u0xBbqOYucnczbniGnFzsTYFBBYNIpchuia7ZdxEkSzX2Nv6UiMOTAgJMnTUjI9pLBq74BBYfcD4iAJ8VmMugSArQPmbFTpuBzrzTyI4D/V8JdgiZfcGKeenapDLfs/zI/a+kZjIfwWKNhAzYNYc2T19iEEAAyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732936959; c=relaxed/simple;
	bh=BUx22ynGhQiIRJUb7WidLK3ore80gOfEVJ69r9Z1Dfo=;
	h=Date:To:From:Subject:Message-Id; b=HeMS0Kht7YhBLPIXjQuqBr/p6M6INwP5H1JSuSjC+bX0WCd0wgonj+XxI2h4jHkuky9L5fmD2F9ZJt3v+P6YvGUGN1lf66Y+OXnJbc1EOsbhjj9Okh0QkQiXs/VpmlYsa6FoU2eTJ0W1euv0AYjE72HGno+o8/+eOBxIFNHs61I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eGHeZYPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eGHeZYPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381F8C4CECC;
	Sat, 30 Nov 2024 03:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732936959;
	bh=BUx22ynGhQiIRJUb7WidLK3ore80gOfEVJ69r9Z1Dfo=;
	h=Date:To:From:Subject:From;
	b=eGHeZYPGCrFJN0CswJTyyB11zQPIqZ7ugDskM7MjLSXCPoWcnGWmYZlpkvpsEujun
	 Kg1BFo3rCi2p7v2KLRqKl7PYLBAh+OxvLTpmuA2c3V5GhEiVNuGcvcWcVIwRQnO/CO
	 IEUOfXbDt6Dlrx0ve+KwHHyyeQoyNZUPED/OZi/o=
Date: Fri, 29 Nov 2024 19:22:38 -0800
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,mgorman@techsingularity.net,hughd@google.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20241130032239.381F8C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: fix hard LOCKUP in function isolate_lru_folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: liuye <liuye@kylinos.cn>
Subject: mm/vmscan: fix hard LOCKUP in function isolate_lru_folios
Date: Tue, 19 Nov 2024 14:08:42 +0800

This fixes the following hard lockup in isolate_lru_folios() during memory
reclaim.  If the LRU mostly contains ineligible folios this may trigger
watchdog.

watchdog: Watchdog detected hard LOCKUP on cpu 173
RIP: 0010:native_queued_spin_lock_slowpath+0x255/0x2a0
Call Trace:
	_raw_spin_lock_irqsave+0x31/0x40
	folio_lruvec_lock_irqsave+0x5f/0x90
	folio_batch_move_lru+0x91/0x150
	lru_add_drain_per_cpu+0x1c/0x40
	process_one_work+0x17d/0x350
	worker_thread+0x27b/0x3a0
	kthread+0xe8/0x120
	ret_from_fork+0x34/0x50
	ret_from_fork_asm+0x1b/0x30

lruvec->lru_lock owner：

PID: 2865     TASK: ffff888139214d40  CPU: 40   COMMAND: "kswapd0"
 #0 [fffffe0000945e60] crash_nmi_callback at ffffffffa567a555
 #1 [fffffe0000945e68] nmi_handle at ffffffffa563b171
 #2 [fffffe0000945eb0] default_do_nmi at ffffffffa6575920
 #3 [fffffe0000945ed0] exc_nmi at ffffffffa6575af4
 #4 [fffffe0000945ef0] end_repeat_nmi at ffffffffa6601dde
    [exception RIP: isolate_lru_folios+403]
    RIP: ffffffffa597df53  RSP: ffffc90006fb7c28  RFLAGS: 00000002
    RAX: 0000000000000001  RBX: ffffc90006fb7c60  RCX: ffffea04a2196f88
    RDX: ffffc90006fb7c60  RSI: ffffc90006fb7c60  RDI: ffffea04a2197048
    RBP: ffff88812cbd3010   R8: ffffea04a2197008   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000001  R12: ffffea04a2197008
    R13: ffffea04a2197048  R14: ffffc90006fb7de8  R15: 0000000003e3e937
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
    <NMI exception stack>
 #5 [ffffc90006fb7c28] isolate_lru_folios at ffffffffa597df53
 #6 [ffffc90006fb7cf8] shrink_active_list at ffffffffa597f788
 #7 [ffffc90006fb7da8] balance_pgdat at ffffffffa5986db0
 #8 [ffffc90006fb7ec0] kswapd at ffffffffa5987354
 #9 [ffffc90006fb7ef8] kthread at ffffffffa5748238
crash>

Scenario:
User processe are requesting a large amount of memory and keep page active.
Then a module continuously requests memory from ZONE_DMA32 area.
Memory reclaim will be triggered due to ZONE_DMA32 watermark alarm reached.
However pages in the LRU(active_anon) list are mostly from
the ZONE_NORMAL area.

Reproduce:
Terminal 1: Construct to continuously increase pages active(anon).
mkdir /tmp/memory
mount -t tmpfs -o size=1024000M tmpfs /tmp/memory
dd if=/dev/zero of=/tmp/memory/block bs=4M
tail /tmp/memory/block

Terminal 2:
vmstat -a 1
active will increase.
procs ---memory--- ---swap-- ---io---- -system-- ---cpu--- ...
 r  b   swpd   free  inact active   si   so    bi    bo
 1  0   0 1445623076 45898836 83646008    0    0     0
 1  0   0 1445623076 43450228 86094616    0    0     0
 1  0   0 1445623076 41003480 88541364    0    0     0
 1  0   0 1445623076 38557088 90987756    0    0     0
 1  0   0 1445623076 36109688 93435156    0    0     0
 1  0   0 1445619552 33663256 95881632    0    0     0
 1  0   0 1445619804 31217140 98327792    0    0     0
 1  0   0 1445619804 28769988 100774944    0    0     0
 1  0   0 1445619804 26322348 103222584    0    0     0
 1  0   0 1445619804 23875592 105669340    0    0     0

cat /proc/meminfo | head
Active(anon) increase.
MemTotal:       1579941036 kB
MemFree:        1445618500 kB
MemAvailable:   1453013224 kB
Buffers:            6516 kB
Cached:         128653956 kB
SwapCached:            0 kB
Active:         118110812 kB
Inactive:       11436620 kB
Active(anon):   115345744 kB
Inactive(anon):   945292 kB

When the Active(anon) is 115345744 kB, insmod module triggers
the ZONE_DMA32 watermark.

perf record -e vmscan:mm_vmscan_lru_isolate -aR
perf script
isolate_mode=0 classzone=1 order=1 nr_requested=32 nr_scanned=2
nr_skipped=2 nr_taken=0 lru=active_anon
isolate_mode=0 classzone=1 order=1 nr_requested=32 nr_scanned=0
nr_skipped=0 nr_taken=0 lru=active_anon
isolate_mode=0 classzone=1 order=0 nr_requested=32 nr_scanned=28835844
nr_skipped=28835844 nr_taken=0 lru=active_anon
isolate_mode=0 classzone=1 order=1 nr_requested=32 nr_scanned=28835844
nr_skipped=28835844 nr_taken=0 lru=active_anon
isolate_mode=0 classzone=1 order=0 nr_requested=32 nr_scanned=29
nr_skipped=29 nr_taken=0 lru=active_anon
isolate_mode=0 classzone=1 order=0 nr_requested=32 nr_scanned=0
nr_skipped=0 nr_taken=0 lru=active_anon

See nr_scanned=28835844.
28835844 * 4k = 115343376KB approximately equal to 115345744 kB.

If increase Active(anon) to 1000G then insmod module triggers
the ZONE_DMA32 watermark. hard lockup will occur.

In my device nr_scanned = 0000000003e3e937 when hard lockup.
Convert to memory size 0x0000000003e3e937 * 4KB = 261072092 KB.

   [ffffc90006fb7c28] isolate_lru_folios at ffffffffa597df53
    ffffc90006fb7c30: 0000000000000020 0000000000000000
    ffffc90006fb7c40: ffffc90006fb7d40 ffff88812cbd3000
    ffffc90006fb7c50: ffffc90006fb7d30 0000000106fb7de8
    ffffc90006fb7c60: ffffea04a2197008 ffffea0006ed4a48
    ffffc90006fb7c70: 0000000000000000 0000000000000000
    ffffc90006fb7c80: 0000000000000000 0000000000000000
    ffffc90006fb7c90: 0000000000000000 0000000000000000
    ffffc90006fb7ca0: 0000000000000000 0000000003e3e937
    ffffc90006fb7cb0: 0000000000000000 0000000000000000
    ffffc90006fb7cc0: 8d7c0b56b7874b00 ffff88812cbd3000

About the Fixes:
Why did it take eight years to be discovered?

The problem requires the following conditions to occur:
1. The device memory should be large enough.
2. Pages in the LRU(active_anon) list are mostly from the ZONE_NORMAL area.
3. The memory in ZONE_DMA32 needs to reach the watermark.

If the memory is not large enough, or if the usage design of ZONE_DMA32
area memory is reasonable, this problem is difficult to detect.

notes:
The problem is most likely to occur in ZONE_DMA32 and ZONE_NORMAL,
but other suitable scenarios may also trigger the problem.

Link: https://lkml.kernel.org/r/20241119060842.274072-1-liuye@kylinos.cn
Fixes: b2e18757f2c9 ("mm, vmscan: begin reclaiming pages on a per-node basis")
Signed-off-by: liuye <liuye@kylinos.cn>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <yang@os.amperecomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/vmscan.c          |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios
+++ a/include/linux/swap.h
@@ -223,6 +223,7 @@ enum {
 };
 
 #define SWAP_CLUSTER_MAX 32UL
+#define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
 #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
 
 /* Bit flag in swap_map */
--- a/mm/vmscan.c~mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios
+++ a/mm/vmscan.c
@@ -1657,6 +1657,7 @@ static unsigned long isolate_lru_folios(
 	unsigned long nr_skipped[MAX_NR_ZONES] = { 0, };
 	unsigned long skipped = 0;
 	unsigned long scan, total_scan, nr_pages;
+	unsigned long max_nr_skipped = 0;
 	LIST_HEAD(folios_skipped);
 
 	total_scan = 0;
@@ -1671,9 +1672,12 @@ static unsigned long isolate_lru_folios(
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
 
-		if (folio_zonenum(folio) > sc->reclaim_idx) {
+		/* Using max_nr_skipped to prevent hard LOCKUP*/
+		if (max_nr_skipped < SWAP_CLUSTER_MAX_SKIPPED &&
+		    (folio_zonenum(folio) > sc->reclaim_idx)) {
 			nr_skipped[folio_zonenum(folio)] += nr_pages;
 			move_to = &folios_skipped;
+			max_nr_skipped++;
 			goto move;
 		}
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios.patch

