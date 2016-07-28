From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 28 Jul 2016 15:42:36 -0700
Message-ID: <20160728154236.7e9c6a6a3c6ef5de29904b05@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Jul_2016_15_42_36_-0700_JaN7X5K82ED1uyWX"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbcG1Wmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Thu__28_Jul_2016_15_42_36_-0700_JaN7X5K82ED1uyWX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


- the rest of MM

101 patches, based on 194dc870a5890e855ecffb30f3b80ba7c88f96d6:

Subject: proc, oom: drop bogus task_lock and mm check
Subject: proc, oom: drop bogus sighand lock
Subject: proc, oom_adj: extract oom_score_adj setting into a helper
Subject: mm, oom_adj: make sure processes sharing mm have same view of oom_=
score_adj
Subject: mm, oom: skip vforked tasks from being selected
Subject: mm, oom: kill all tasks sharing the mm
Subject: mm, oom: fortify task_will_free_mem()
Subject: mm, oom: task_will_free_mem should skip oom_reaped tasks
Subject: mm, oom_reaper: do not attempt to reap a task more than twice
Subject: mm, oom: hide mm which is shared with kthread or global init
Subject: mm, oom: tighten task_will_free_mem() locking
Subject: mm: update the comment in __isolate_free_page
Subject: mm: fix vm-scalability regression in cgroup-aware workingset code
Subject: mm/compaction: remove unnecessary order check in try_to_compact_pa=
ges()
Subject: freezer, oom: check TIF_MEMDIE on the correct task
Subject: cpuset, mm: fix TIF_MEMDIE check in cpuset_change_task_nodemask
Subject: mm, meminit: remove early_page_nid_uninitialised
Subject: mm, vmstat: add infrastructure for per-node vmstats
Subject: mm, vmscan: move lru_lock to the node
Subject: mm, vmscan: move LRU lists to node
Subject: mm, mmzone: clarify the usage of zone padding
Subject: mm, vmscan: begin reclaiming pages on a per-node basis
Subject: mm, vmscan: have kswapd only scan based on the highest requested z=
one
Subject: mm, vmscan: make kswapd reclaim in terms of nodes
Subject: mm, vmscan: remove balance gap
Subject: mm, vmscan: simplify the logic deciding whether kswapd sleeps
Subject: mm, vmscan: by default have direct reclaim only shrink once per no=
de
Subject: mm, vmscan: remove duplicate logic clearing node congestion and di=
rty state
Subject: mm: vmscan: do not reclaim from kswapd if there is any eligible zo=
ne
Subject: mm, vmscan: make shrink_node decisions more node-centric
Subject: mm, memcg: move memcg limit enforcement from zones to nodes
Subject: mm, workingset: make working set detection node-aware
Subject: mm, page_alloc: consider dirtyable memory in terms of nodes
Subject: mm: move page mapped accounting to the node
Subject: mm: rename NR_ANON_PAGES to NR_ANON_MAPPED
Subject: mm: move most file-based accounting to the node
Subject: mm: move vmscan writes and file write accounting to the node
Subject: mm, vmscan: only wakeup kswapd once per node for the requested cla=
sszone
Subject: mm, page_alloc: wake kswapd based on the highest eligible zone
Subject: mm: convert zone_reclaim to node_reclaim
Subject: mm, vmscan: avoid passing in classzone_idx unnecessarily to shrink=
_node
Subject: mm, vmscan: avoid passing in classzone_idx unnecessarily to compac=
tion_ready
Subject: mm, vmscan: avoid passing in `remaining' unnecessarily to prepare_=
kswapd_sleep()
Subject: mm, vmscan: Have kswapd reclaim from all zones if reclaiming and b=
uffer_heads_over_limit
Subject: mm, vmscan: add classzone information to tracepoints
Subject: mm, page_alloc: remove fair zone allocation policy
Subject: mm: page_alloc: cache the last node whose dirty limit is reached
Subject: mm: vmstat: replace __count_zone_vm_events with a zone id equivale=
nt
Subject: mm: vmstat: account per-zone stalls and pages skipped during recla=
im
Subject: mm, vmstat: print node-based stats in zoneinfo file
Subject: mm, vmstat: remove zone and node double accounting by approximatin=
g retries
Subject: mm, page_alloc: fix dirtyable highmem calculation
Subject: mm, pagevec: release/reacquire lru_lock on pgdat change
Subject: mm: show node_pages_scanned per node, not zone
Subject: mm, vmscan: Update all zone LRU sizes before updating memcg
Subject: mm, vmscan: remove redundant check in shrink_zones()
Subject: mm, vmscan: release/reacquire lru_lock on pgdat change
Subject: mm: add per-zone lru list stat
Subject: mm, vmscan: remove highmem_file_pages
Subject: mm: remove reclaim and compaction retry approximations
Subject: mm: consider whether to decivate based on eligible zones inactive =
ratio
Subject: mm, vmscan: account for skipped pages as a partial scan
Subject: mm: bail out in shrink_inactive_list()
Subject: mm/zsmalloc: use obj_index to keep consistent with others
Subject: mm/zsmalloc: take obj index back from find_alloced_obj
Subject: mm/zsmalloc: use class->objs_per_zspage to get num of max objects
Subject: mm/zsmalloc: avoid calculate max objects of zspage twice
Subject: mm/zsmalloc: keep comments consistent with code
Subject: mm/zsmalloc: add __init,__exit attribute
Subject: mm/zsmalloc: use helper to clear page->flags bit
Subject: mm, THP: clean up return value of madvise_free_huge_pmd
Subject: memblock: include <asm/sections.h> instead of <asm-generic/section=
s.h>
Subject: mm: CONFIG_ZONE_DEVICE stop depending on CONFIG_EXPERT
Subject: mm: cleanup ifdef guards for vmem_altmap
Subject: mm: track NR_KERNEL_STACK in KiB instead of number of stacks
Subject: mm: fix memcg stack accounting for sub-page stacks
Subject: kdb: use task_cpu() instead of task_thread_info()->cpu
Subject: printk: when dumping regs, show the stack, not thread_info
Subject: mm/memblock.c: add new infrastructure to address the mem limit iss=
ue
Subject: arm64:acpi: fix the acpi alignment exception when 'mem=3D' specifi=
ed
Subject: kmemleak: don't hang if user disables scanning early
Subject: make __section_nr() more efficient
Subject: mm: hwpoison: remove incorrect comments
Subject: mm, compaction: don't isolate PageWriteback pages in MIGRATE_SYNC_=
LIGHT mode
Subject: Revert "mm, mempool: only set __GFP_NOMEMALLOC if there are free e=
lements"
Subject: mm: add cond_resched() to generic_swapfile_activate()
Subject: mm: optimize copy_page_to/from_iter_iovec
Subject: mem-hotplug: alloc new page from a nearest neighbor node when mem-=
offline
Subject: mm/memblock.c: fix index adjustment error in  __next_mem_range_rev=
()
Subject: zsmalloc: Delete an unnecessary check before the function call "ip=
ut"
Subject: mm: fix use-after-free if memory allocation failed in vma_adjust()
Subject: mm, kasan: account for object redzone in SLUB's nearest_obj()
Subject: mm, kasan: switch SLUB to stackdepot, enable memory quarantine for=
 SLUB
Subject: lib/stackdepot.c: use __GFP_NOWARN for stack allocations
Subject: mm, page_alloc: set alloc_flags only once in slowpath
Subject: mm, page_alloc: don't retry initial attempt in slowpath
Subject: mm, page_alloc: restructure direct compaction handling in slowpath
Subject: mm, page_alloc: make THP-specific decisions more generic
Subject: mm, thp: remove __GFP_NORETRY from khugepaged and madvised allocat=
ions
Subject: mm, compaction: introduce direct compaction priority
Subject: mm, compaction: simplify contended compaction handling




--Signature=_Thu__28_Jul_2016_15_42_36_-0700_JaN7X5K82ED1uyWX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXmopiAAoJEJxZ78cCqAIHtXsQAIPhmGFZtIDYAkgox5DovB1O
8jYJQ7j7pI1kAV1qN1UdOxChebjpPDpZkql2HUmeIsaej+fU4odxxJXppFULrfdJ
PayCTKLw99U/LqqdQmRZysOvFef5rDkOVyRQUIebPZT7F59PZZvYEiUZHOCyQbNV
MxOQtOZTV5kpfIsGb/zW5I0Xnj0H0McfLyts/xSAwwnlyR3oMrR9RgD4510Qt/s6
k0J1II99Eamv9+3aQ669pQzx9DnOBLBh8K4TIM2T0i9HrybN2kcJqXkaWsVnGZ5B
4xXD4Y1KSkTEIYU9VTAgiDkIstQ99sDbMdlTOi2RacL8Z5ArFliqNwxJuckK9fI6
SI5XgyAxu+scN8fXB7mrGKcdnlOtcV3S6FYvH/LwkglLM3Wz4X0SibnpPGVlVON6
1Kgky5cUAtR8S0R1GGeLKOknhVpl427asocODPf+4ThAUzPGOQrYYnaodNCak4Cv
fq72YIhzQxNMaGIjn6TjpkTJ0nnHgkClxHoYcfHMS/irlvtiTqEJocZwn962VVMs
/Qoh7vCXp2rOvHmiUeBu43HTEih4tzew8LdKgiKYkOcGvoJndvbLT64xKzByHr4S
CaN6lUgX54x2A4mOgHIjuB//swkTOAYuRjhmJux9s0DJdymdpCl9H8X7/2/KpBjl
HXJXLPJwh9/L9e21yU4c
=BKIf
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Jul_2016_15_42_36_-0700_JaN7X5K82ED1uyWX--
