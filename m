Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792472433;
	b=VxOLaljRuyi4cpZDKealSPIuvEQFFkrKaxxdIdiWkGDTxjriQ9WYd4flxySQyhEFgb98
	 FFmzY/NUmEXoDbJ36DZROMFYXjbINWNC80K7bXB3LJqUzZJEi4uTokEEhBZZhzr8fRXHb
	 N8kCT6h2q11viY3Y6Xa/mufHDIAX8c5cHcPl3lnaluBjba97Xdhq1YHuSUKwE7gNeQmPw
	 NNFlE6Wu19njPlMhtpd/IDGotqzHAj09GWh9YJmJtYwdHNabLMPpiz2TJuaqBVye7C71G
	 FKN41SKpLCqBv0KFEoW4g2lkfiQbGdmmo7RfLc0zwAQusu6BWPJ1zJHsVVwKCzdqOjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792472433;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:X-Mailer:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ggb1MN0tz6ZlbKvb6VSxiBdgXuI4lF7PtIyxEuaRpG8=;
	b=GKl/v583brsI4D03BvoGEQ8N0paQl+n4jj2DcNDZzDPcrRQ2ufgrYjykDS1Uc0vUmhoW
	 lsptoIIo4BNnpdZDwjiwCXrLI0CD6SoBVJA1ps55ehhZYxT1NmuJcj/FAK+rucUG6MaUg
	 wqx2nIUIM+0Yx+nbYLTvijrZ0zlv+Gb7PIJ4zDa+qL4oR3oMkeWW6lUTyeTKp2pO+Xmuv
	 yL3yQ2GK/XM66Ed+JfQutWtaGEdKwUewgWSE+uwvGSAa63YuceQTYnGM71K2rkkONtnJH
	 ppgMC/dyc+30J2rBEePqY0fgcO/LG/pai7KinFmFRiELxfac75SgHCF2niCMPFqqEWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EBN8PTLB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D1E606A31B;
	Tue, 20 Oct 2026 05:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=EBN8PTLB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CEF1F000C4;
	Tue, 20 Oct 2026 05:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792472431;
	bh=Ggb1MN0tz6ZlbKvb6VSxiBdgXuI4lF7PtIyxEuaRpG8=;
	h=Date:From:To:Cc:Subject;
	b=EBN8PTLBxxBdwe/Hnt3/TyrfRYTIgK3VLUPxFesRmvSgmUWCKkrtwPH8Kv5P8CI/w
	 5Zn/uZnGiJs/3SiXrwmg2XEBkmngkwsNfum9LUvRaI7UJLpQBdOH8Knx8s80GlQe/f
	 deztzrvs+bAPUzeiR5/mDuvfB1tvHcS9kTX5Yac0=
Date: Mon, 19 Oct 2026 22:00:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 7.4-rc1
Message-Id: <20261019220030.056b79bf972b9d6a9c1aa931@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this first and main batch of MM updates for the
upcoming -rc cycle.

539 patches here and ~220 are queued for next week's batch.

I'm seeing no merge conflicts at this time.


Possible upcoming merge issues and their linux-next resolutions are:

arch/riscv/Kconfig, vs riscv tree:
https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk

mm/hugetlb.c
mm/mm_init.c, vs liveupdate tree:
https://lore.kernel.org/amjYWetl6_WVyumg@sirena.org.uk

drivers/misc/sgi-xp/xpc_uv.c, vs char-misc tree:
https://lore.kernel.org/anSSANY5zZu4kytE@sirena.org.uk

fs/f2fs/f2fs.h, vs fs-next tree:
https://lore.kernel.org/aqv9gg4J1n0sB0GU@sirena.org.uk

fs/coredump.c, vs fs-next tree:
https://lore.kernel.org/aqv9s5QlajVW6i3T@sirena.org.uk

fs/fuse/dax.c, vs fs-next tree:
https://lore.kernel.org/aqv9vKbIDQ1gYVwz@sirena.org.uk

mm/internal.h, vs bpf-next tree:
https://lore.kernel.org/arD9mGTj9upScb9t@sirena.co.uk

fs/f2fs/f2fs.h, vs fs-next tree:
https://lore.kernel.org/arOlLKx-29GNPJ-m@sirena.co.uk

fs/xfs/libxfs/xfs_btree.c, vs fs-next tree:
https://lore.kernel.org/arUS5b85ed6L01qc@sirena.org.uk
(read down a bit for Sasha's resolution)

mm/mm_init.c, vs liveupdate tree:
https://lore.kernel.org/arVZKNJKTwEqrFsF@sirena.org.uk

arch/arm64/mm/pageattr.c, vs arm64 tree:
https://lore.kernel.org/arZgwGn5MfEneJsb@sirena.org.uk

arch/um/Kconfig, vs uml tree:
https://lore.kernel.org/arZg--vlHZ0LAzKg@sirena.org.uk

arch/arm64/kvm/mmu.c, vs kvm-arm-fixes tree:
https://lore.kernel.org/ar5ZsSo2ybT39BEQ@sirena.org.uk

drivers/video/fbdev/ssd1307fb.c, vs fbdev tree:
https://lore.kernel.org/as5bwyKpGQaBZ3CO@sirena.org.uk

mm/sparse-vmemmap.c, vs memblock/for-next tree:
https://lore.kernel.org/836fd90a-4417-4457-97bd-e540f41de597@kernel.org

Thanks.


The following changes since commit 80ce29104123be4d61b5912dae543c70af0fcb75:

  mailmap: update entry for Andy Yan (2026-10-06 16:44:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-10-19-21-33

for you to fetch changes up to 2967f3ccdb5fae956f1b085370ec292bab5c7e25:

  mm: shmem: assign a lock class to the unused huge shrinklist (2026-10-12 21:29:59 -0700)

----------------------------------------------------------------
mm.git review status for linus..mm-stable

Everything:

Total patches:       539
Fixes: tags:         101
cc:stable patches:   67
Reviews/patch:       1.62
Reviewed rate:       76%

Excluding DAMON:

Total patches:       407
Fixes: tags:         84
cc:stable patches:   44
Reviews/patch:       2.00
Reviewed rate:       87%

Excluding DAMON and selftests:

Total patches:       360
Fixes: tags:         78
cc:stable patches:   44
Reviews/patch:       2.02
Reviewed rate:       89%

Summary of patch series in this merge, ordered by descending size:

- "selftests/mm: improve khugepaged coverage" (Kiryl Shutsemau (Meta)):

  Give khugepaged a proper workout.  Extend the tests to all supported mTHP
  orders, check exactly which windows collapsed, and make scan completion
  deterministic.  Race collapse against faults, pinning, fork and remap;
  verify that the contents survive.

  Add coverage for whole-page-table zaps and memory pressure too.

- "selftests/mm: separate GUP microbenchmarking from functional testing"
  (Sarthak Sharma):

  Untangle GUP benchmarking from correctness testing.  Move the benchmark
  into tools/mm, add a standalone harness-based GUP selftest, and move shared
  helpers into tools/lib/mm.  Give each tool one job instead of mixing timing
  measurements with correctness checks.

  Cover the mapping, pinning and batch-size combinations explicitly.

- "mm: Switch device DAX to section-based vmemmap optimization" (Muchun Song):

  Apply section-based vmemmap optimization to device DAX.  Rework the backing
  metadata layout to save memory while preserving the handling of device
  memory hotplug and its different alignment and lifetime requirements.

- "mm: Introduce section-based vmemmap optimization for HugeTLB" (Muchun
  Song):

  Cut the memory consumed by HugeTLB's struct page array with section-based
  vmemmap optimization.  Arrange the metadata so large huge pages need fewer
  backing pages, while keeping initialization, teardown and the various
  hugepage configurations straight.

- "mm/huge_memory: clean up and decouple the anon and file split helpers"
  (Kairui Song):

  Separate anonymous and file-backed folio splitting, which have rather
  different locking and bookkeeping requirements.  Move the work into
  separate helpers, drop dead checks and tidy swap-cache handling.  Fix error
  paths, including one that could leave a folio frozen.

  Keep the swap cache cases separate from file-cache splitting.

- "mm: Unconditional per-VMA locks and cleanups" (Dave Hansen):

  Make per-VMA locking unconditional and clean up the old conditional code
  around it.  This removes configuration-dependent plumbing and lets callers
  depend on one locking model rather than carrying both cases along.

- "memcg: remove the v1 soft limit" (Shakeel Butt):

  Remove the old cgroup v1 memory soft-limit machinery.  This has long since
  been superseded by the newer memory-control interfaces; hauling around a
  separate reclaim scheme for it no longer buys us much.

- "read proc/pid/smaps_rollup under per-vma lock" (Suren Baghdasaryan):

  Read /proc/PID/smaps_rollup using per-VMA locks where possible, rather than
  holding mmap_lock across the entire walk.  Retain the contention fallback
  and add tearing tests.  This considerably reduces latency when another
  thread is busy changing its mappings.

- "mm/damon: introduce data access-as-a-data attribute" (SJ Park):

  Teach DAMON to expose memory access observations as data attributes, making
  them available to the probe and filtering machinery.  Extend the
  interfaces, documentation and tests so the new information can be used
  rather than merely collected.

- "Remove PG_private by using page/folio->private checks instead" (Zi Yan):

  Get rid of PG_private and use the folio's private pointer to say whether
  private data is attached.  Convert the filesystem users, including erofs,
  f2fs and md, and clean up the old accessors and flags.  There are a few
  special cases, notably swapcache and hugetlb, which need explicit care.

- "mm: make userland page table freeing RCU-safe" (Lorenzo Stoakes (ARM)):

  Make freeing userspace page tables safe against RCU readers.  Sort out the
  page-table lifetime and locking rules so walkers cannot stumble over freed
  tables while mappings are being torn down.

- "make unused huge shrinker memcg aware" (Qi Zheng):

  Make shmem's unused-huge-folio shrinker aware of memory cgroups, so reclaim
  can find those folios under the right memcg.  Wire up the per-memcg
  tracking and its lifetime rules, and give the shrinklist its own lockdep
  class to avoid spurious dependency reports.

- "mm: Drop pxd_ERROR()" (Anshuman Khandual):

  Remove the old pxd_ERROR() page-table checks and their
  architecture-specific baggage.  Simplify the common page-table interfaces
  and callers now that these checks no longer serve a useful purpose.

- "memcg: group struct fields by access pattern" (Shakeel Butt):

  Rearrange memcg's hot and cold fields according to how they're actually
  accessed.  Keep frequently updated counters and their neighboring state
  from fighting over cachelines and reduce needless cacheline traffic.

- "mm/damon/core: fix the size charged for a filter-trimmed region" (Donggeun
  Yoo):

  Fix DAMOS quota accounting when a filter trims a monitoring region.  Charge
  only the part left after filtering, not the original region, and add KUnit
  coverage.  Previously the excluded memory could eat into the quota and make
  schemes run more slowly than requested.

- "mm/damon: add kunit and selftests for probes and probe weights" (SJ Park):

  Add more tests for DAMON probes and their weights, including validation and
  the results reported to userspace.  This is mostly about catching
  regressions in the newer probe infrastructure before they become harder to
  diagnose.

- "mm: memcontrol: constify the read side of the read side of the memcg API"
  (Tal Zussman):

  Mark the read-only parts of the memcg interface const, from folio and
  lruvec accessors to counters and swap helpers.  Most of this is mechanical,
  but it makes the contracts clearer and lets the compiler catch accidental
  writes.

- "mm/damon/vaddr: support {prep,apply}_probes" (SJ Park):

  Support the new prepare/apply probe operations in DAMON's virtual-address
  backend.  This brings vaddr monitoring into line with the probe
  infrastructure and makes the added probe types useful there too.

- "mm/mglru: clean up folio counters and flag usage" (Kairui Song):

  Simplify MGLRU's folio counters and flag handling.  Remove redundant
  accounting paths and make the state transitions easier to follow without
  changing the intended reclaim policy.

- "arch, mm/execmem: resolve confusion about set_direct_map_valid_noflush()"
  (Mike Rapoport (Microsoft)):

  Clarify and straighten out the set_direct_map_valid_noflush() interface
  across architectures and execmem.  Make the requested mapping changes and
  the callers' expectations agree, rather than relying on subtly different
  architecture behavior.

- "mm: zswap: free cold writeback folios promptly" (Alexandre Ghiti):

  Free zswap writeback folios as soon as their disk write completes.  They
  are cold temporary buffers, so putting them on the LRU only makes reclaim
  rediscover them later.  Extend swap-cache dropbehind and let zswap keep
  these folios off the LRU altogether.

- "mm: gup: cleanup gup_fast call chain" (Aristeu Rozanski):

  Clean up the GUP-fast call chain and simplify how the fast-path helpers
  pass their arguments and results around.  Keep the page-pin behavior the
  same while making the call sequence easier to maintain.

- "mm: optimize zone-device memmap initialization" (Li Zhe):

  Speed up initialization of zone-device struct pages.  Avoid redundant work
  when setting up large device-memory ranges, where touching every descriptor
  can get expensive.

- "mm/zswap: shrink zswap_entry via a pool id" (Jianyue Wu):

  Reduce the size of zswap_entry by storing a compact pool identifier instead
  of a full pointer.  Keep the pool lookup and lifetime handling correct
  while saving per-entry metadata.

- "mm/damon: support access monitoring of hugetlb-backed memory" (Krishna
  Iyer):

  Let DAMON monitor hugetlb-backed memory too.  Extend the relevant access
  checks and add coverage so those mappings no longer fall through a hole in
  the monitoring machinery.

- "mm/execmem: fixes and cleanups for the ROX cache" (Mike Rapoport
  (Microsoft)):

  Tidy execmem's read-only-executable cache and fix its handling of the
  awkward allocation and release cases.  The aim is to make the cache's
  ownership and permission transitions more predictable.

- "zsmallc: remove old object read API" (Sergey Senozhatsky):

  Drop zsmalloc's old object-read API and move its remaining users to the
  supported access mechanism.  This removes a duplicate interface which we no
  longer need.

- "mm/mempolicy: stop copying state in the interleave paths" (Gregory Price):

  Stop copying mempolicy state in the interleave paths when a reference to
  the existing policy will do.  This avoids extra work and makes the
  ownership rules less obscure.

- "mm/mglru: speed up inc_min_seq() and fix cold/hot inversions" (Barry Song
  (Xiaomi)):

  Make MGLRU's generation advancement cheaper and fix cases where cold and
  hot folios end up in the wrong order.  Adjust the counter and list handling
  so reclaim doesn't keep passing over the better eviction candidates.

- "mm: Fix MF_DELAYED handling on memory failure" (Lisa Wang):

  Treat MF_DELAYED as a partially completed memory-failure operation, not an
  outright failure.  Propagate that result correctly through shmem and the
  generic handler, fix the extra-reference accounting, and add tests for the
  resulting SIGBUS behavior.

- "tools/mm/page_owner_sort: fix --sort, add module filter, improve usage" (Ye
  Liu):

  Fix page_owner_sort's --sort handling, add module-based filtering and make
  the usage output more helpful.  This makes the tool less frustrating when
  tracking down who is holding on to pages.

- "mm/damon: move damos filter range arguments validation to core" (SJ Park):

  Move DAMOS filter range validation into the core, where all callers can
  share it.  Also close the sysfs read-twice races which could pass
  inconsistent ranges, and add tests for invalid input.

- "mm/damon: misc cleanups" (Zenghui Yu (Huawei)):

  Clean up a collection of small DAMON rough edges in the core, interfaces
  and tests.  No large behavior change here, just simpler code and fewer
  opportunities for confusion.

- "mm/damon: cleanup code, add test cases, and update guidances in docs" (SJ
  Park):

  Clean up DAMON's core and interfaces, add missing test cases and bring the
  documentation into line with the code.  These changes should make the newer
  facilities easier to understand and maintain.

- "mm/damon: introduce hugepage_size probe filter" (SJ Park):

  Add a DAMON probe filter for hugepage size.  Let users select a range of
  folio sizes through sysfs, validate the range and document the new
  interface, so monitoring can concentrate on memory backed by the desired
  hugepage sizes.

- "selftests/mm: pagemap_ioctl test fixes and cleanups" (Zenghui Yu (Huawei)):

  Fix some pagemap ioctl test assumptions and clean up their setup and
  reporting.  Make failures point to the operation that went wrong rather
  than to test harness bookkeeping.

- "mm: avoid large folio splits when swap is unavailable" (Johannes Weiner):

  Avoid splitting large folios merely to attempt swap when no swap space is
  available.  There is little point paying for an expensive split when
  reclaim cannot actually swap the resulting pages out.

- "mm: workingset: fix the shadow node budget under MGLRU" (Hui Zhu):

  Fix the workingset shadow-node budget with MGLRU enabled.  Keep the shadow
  entries within the intended limits so refault tracking does not quietly
  consume more metadata than it should.

- "selftests/mm: TAP output and global-state fixes" (Song Hu):

  Fix selftests which produce misleading TAP output or fail to restore global
  settings after a run.  A test ought to leave the system as it found it,
  particularly when a whole suite follows behind.

- "mm: remove page_swap_entry()" (Tal Zussman):

  Remove page_swap_entry() and convert its remaining users to the folio and
  swap-entry helpers.  Lose an old page-level interface and make the swap
  paths a little more consistent.

- "mm: refactor zonelist constructors and iterators" (Gregory Price):

  Refactor the zonelist construction and walk helpers to reduce duplicated
  logic.  Keep the allocation ordering rules intact while making it clearer
  how zones are selected.

- "mm: kmemleak: batch the struct page scan" (Breno Leitao):

  Scan adjacent struct pages in batches instead of taking kmemleak_lock once
  for every single page.  This preserves scan coverage and the lock-hold
  bound, while cutting overhead substantially on debug kernels.

- "mm/damon: misc improvements in tests and documents" (Zenghui Yu (Huawei)):

  Fix some DAMON selftests which leave kdamond running or fail under Python
  safe-path mode, and improve the KUnit coverage and documentation.  Nothing
  especially glamorous, but these are worth doing.

- "mm/damon: introduce probe_hits_wsum DAMOS core filter" (SJ Park):

  Add a DAMOS core filter using weighted probe-hit counts.  This gives
  schemes another way to select regions based on what the monitoring probes
  observed.

- "mm/mglru: fix ineffective memory protection for non-kswapd reclaim" (Ridong
  Chen):

  Fix MGLRU's memory protection handling for reclaim outside kswapd.  The
  protection settings weren't having the intended effect in these paths,
  leaving protected memory more exposed than requested.

- "mm/damon: improve readability, clarity and test coverage" (SJ Park):

  Simplify a handful of DAMON core helpers, clarify their behavior and expand
  test coverage.  There are no intended userspace-visible changes in this
  batch.

- "mm: replace PF_KCOMPACTD/PF_KSWAPD with kthread_func()" (Kefeng Wang):

  Stop identifying reclaim and compaction workers through the PF_KSWAPD and
  PF_KCOMPACTD task flags.  Use their kthread functions instead and remove
  the redundant flag plumbing.

- "mm/hugetlb: fix surplus accounting and availability checks during demotion"
  (Longlong Xia):

  Fix HugeTLB surplus accounting and availability checks when demoting huge
  pages.  Keep the counters and reservation decisions consistent as one huge
  page turns into several smaller ones.

- "mm/damon: add kunit tests for probe_hits handling and probe params
  validation" (Jason Angelov):

  Add KUnit tests for DAMON probe-hit handling and invalid probe parameters.
  These cover edge cases that were too easy to miss in ordinary monitoring
  tests.

- "mm/damon: fix misc bugs in kunit, quota goals and sysfs refresh_ms" (SJ
  Park):

  Fix a few DAMON bugs in KUnit tests, quota-goal handling and the sysfs
  refresh interval.  Small fixes, but the incorrect results and control
  behavior were real.

- "mm: zswap: optimize zswap invalidate and store" (Kefeng Wang):

  Simplify zswap's invalidate and store paths to avoid avoidable lookups and
  work.  Keep the entry lifetime rules intact while making those frequent
  operations cheaper.

- "mm: replace custom ratelimiting logic" (Pedro Falcato):

  Replace hand-rolled MM rate limiting with the common kernel helpers.  There
  is no need to maintain another local version of the same mechanism.

- "mm/vmalloc: minor cleanups" (Ye Liu):

  Tidy some vmalloc initialization and reporting code, and pull duplicated
  vmap-area insertion work into a helper.  No functional changes are
  intended.

- "mm/mglru: clean up isolate_folios for readability and clarity" (Ridong
  Chen):

  Clean up MGLRU's isolate_folios() so the decisions are easier to read and
  verify.  Keep reclaim behavior unchanged while removing unnecessary twists
  in the control flow.

- "Catch automatic storage in IDA and Maple Tree definitions" (Yury Norov):

  Catch IDA and maple-tree definitions placed in automatic storage where the
  lifetime rules are wrong or easy to get wrong.  Add checks so such mistakes
  are harder to slip through unnoticed.

- "mm, swap: some random fixes and cleanups" (Kemeng Shi):

  Fix and simplify a few unrelated swap paths, removing redundant work and
  tidying up error handling.  A small collection of things which were better
  fixed than left lying around.

- "mm/page_io: folio conversion cleanups" (Tal Zussman):

  Finish some page-to-folio conversions in swap I/O, removing obsolete
  wrappers and using folio operations consistently.  The I/O behavior is
  intended to remain the same.

- "mm/swap: skip empty clusters in the swapoff scan" (Youngjun Park):

  Skip empty swap clusters during swapoff instead of walking slots which have
  nothing to release.  This avoids pointless work on sparsely used swap
  devices.

- "mm: trace: decode architecture-specific VMA flags" (Meijing Zhao):

  Teach the VMA trace output to decode architecture-specific flags, rather
  than leaving them as unexplained bits.  That should make tracing a good
  deal more useful when debugging unusual mappings.

- "mm, swap: don't spin on a bad swap entry" (Breno Leitao):

  Stop repeatedly retrying a swap entry which is already known to be bad.
  Make the error path terminate cleanly instead of wasting CPU chasing an
  entry that cannot be used.

- "mm/page_isolation: fix UBSAN shift-out-of-bounds in
  isolate_single_pageblock" (Qi Xi):

  Fix an out-of-range shift in isolate_single_pageblock() and tighten its
  associated boundary handling.  UBSAN found the issue; the result should be
  more robust pageblock isolation.

- "mm: khugepaged: fix tracepoint UAF" (Vernon Yang):

  Fix a use-after-free in khugepaged tracepoint handling.  Make sure the
  information recorded by tracing stays valid for as long as the trace event
  needs it.

- "mm/damon: fix DAMOS bugs in core, paddr and vaddr" (SJ Park):

  Fix several DAMOS problems across the core and physical- and
  virtual-address backends.  The changes close error cases and bring the
  implementations back into agreement.

- "mm/hugetlb_cgroup: move the per-node usage along with the folio" (Hongfu
  Li):

  Move HugeTLB per-node usage accounting when folios migrate between nodes or
  are reparented to another cgroup.  Otherwise numa_stat can retain stale
  charges and even underflow when the folio is freed.

- "docs/core-api: memory-allocation: add k[mz]alloc_obj() and clarify kmalloc"
  (Mike Rapoport (Microsoft)):

  Document the typed k[mz]alloc_obj() allocation helpers and clear up some
  kmalloc guidance.  Make it easier for callers to choose the right
  interface.

- "selftests/mm: Validate selections and scope memfd_secret setup" (Tianyi
  Chen):

  Check selftest selections before running and confine memfd_secret setup to
  the cases that actually need it.  Avoid confusing failures caused by the
  test harness itself.

- "mm/damon: move zero damos quota target_value handling to the core layer"
  (SJ Park):

  Handle a zero DAMOS quota goal target in the core rather than making each
  user of the interface invent its own rule.  Keep quota decisions consistent
  across callers.

- "mm/damon: Introduce a huge page collapsing mechanism using auto tuning"
  (Asier Gutierrez):

  Add an auto-tuned DAMON mechanism for collapsing huge pages.  Use
  monitoring feedback to decide when collapse is worthwhile rather than
  forcing one fixed policy onto every workload.

- "kmemleak: fix stale documentation and raise the verbose default" (Breno
  Leitao):

  Bring the kmemleak documentation up to date and require a third confirming
  scan before verbose kernels print a suspected leak.  The extra scan helps
  suppress transient false positives in noisy debug builds.

- "mm/memory: improve insert_pages() error handling" (Avi Weiss):

  Tighten insert_pages() error handling so partial failures are reported and
  cleaned up consistently.  The caller should not have to guess how far the
  operation got.

- "mm/damon: allow NULL or unstarted damon_ctx parameter for damon_call()" (SJ
  Park):

  Make damon_call() handle NULL and not-yet-started contexts safely.
  Simplify the rules for callers and avoid an indefinite wait on an invalid
  state.

- "mm/damon: introduce pgidle_set probe filter type" (SJ Park):

  Add a pgidle_set DAMON probe filter, giving monitoring users another way to
  select pages by their idle-tracking state.  Wire it through the filter
  interfaces and tests.

- "mm/damon/core: remove unused helper functions" (Cheng-Han Wu):

  Remove DAMON core helpers which no longer have callers.  Keep the API
  surface smaller rather than retaining dead code just in case.

- "mm: stop calling pmd_folio() on special PMDs" (Gregory Price):

  Avoid calling pmd_folio() on special PMD mappings that have no struct page.
  The old assumption could fault in procfs walkers; use the normal-folio
  checks and handle those mappings properly.

- "mm: remove three unused helpers from mm.h" (Tal Zussman):

  Remove three unused helpers from mm.h.  Fewer obsolete interfaces for the
  next person to stumble over.

- "mm/damon: improvements in efficiency, error handling, documents" (Liew Rui
  Yan):

  Skip needless DAMOS quota work once the quota is full, propagate a missing
  sysfs error and tidy a couple of comments.  The ignored error could make a
  monitoring-start request appear successful when it wasn't.

- "docs/mm/damon/design: add explanation of nr_snapshots" (Liew Rui Yan):

  Explain DAMON's nr_snapshots accounting in the design documentation and
  straighten out the associated terminology.  Make it clearer what users
  should expect from that counter.

- "selftests/cgroup: fixes for test_zswap on single core VM" (Wilson Felipe
  Pereira):

  Fix two test_zswap failures on single-CPU VMs.  Wait for the exiting
  child's cgroup to become unpopulated before reconfiguring it, and avoid
  another test assumption which breaks under constrained scheduling.

- "docs/ksm: fix advisor documentation and comment" (Jinjiang Tu):

  Correct the KSM advisor documentation and a misleading code comment.  Keep
  the description aligned with how the advisor actually works.

- "Fix bugs in HugeTLB allocation when mem_cgroup_charge_hugetlb() fails"
  (Ackerley Tng):

  Fix HugeTLB allocation cleanup when the memcg charge fails.  Make sure
  failure exits undo what was allocated rather than leaving stale accounting
  or resources behind.

- "mm, memcg: fix memory.peak reset clobbering other fds' watermark" (Ridong
  Chen):

  Fix memory.peak reset handling so resetting one file descriptor doesn't
  overwrite the watermark kept for another.  Keep those per-open measurements
  independent as intended.

- "mm: reject zone device folios in more folio walkers" (Gregory Price):

  Reject zone-device folios in page walkers that cannot safely handle them.
  Extend the existing checks rather than assuming every folio has ordinary
  system-memory backing.

- "percpu: remove code with no effect" (Sang-Heon Jeon):

  Remove a few pieces of percpu code which no longer do anything.  There is
  no reason to keep maintaining dead paths.

----------------------------------------------------------------
Ackerley Tng (2):
      mm: hugetlb: return -ENOSPC on memcg charge failure
      mm: hugetlb: drop refcount before freeing on memcg charge failure

Adrian Huang (Lenovo) (1):
      mm/damon: fix typos in comments

Alexandre Ghiti (3):
      mm: swap: move LRU insertion out of the swap cache allocator
      mm: swap: drop dropbehind swap cache folios on writeback completion
      mm: zswap: drop cold writeback folios via swap dropbehind

Anastasios Papagiannis (1):
      mm/nommu: reject wrapping ranges in access_remote_vm()

Andrew Morton (1):
      Merge branch 'mm-hotfixes-stable' to pick up

Anshuman (1):
      selftests/mm: fix line buffer leak in mremap_test is_range_mapped()

Anshuman Khandual (9):
      mm: make ptval_to_str() generally available
      mm: stop using pxd_ERROR()
      loongarch/mm: stop using pte_ERROR()
      parisc/mm: directly use generic [pmd|pgd]_clear_bad()
      sh/mm: stop using pte_ERROR()
      sh/mm: stop using [p4d|pud|pmd]_ERROR()
      sh/mm: stop using pgd_ERROR()
      mm: drop pxd_ERROR()
      mm: constify arguments in default pxdp_get()

Aristeu Rozanski (2):
      mm: gup: move pmd_protnone() into gup_fast_pmd_leaf()
      mm: gup: cleanup the gup_fast_*() call chain

Arnd Bergmann (1):
      mm/vmscan: avoid false-positive -Wuninitialized warning, again

Asier Gutierrez (3):
      mm/damon: introduce DAMOS_QUOTA_HUGEPAGE auto tuning
      mm/damon/sysfs: support hugepage_mem_bp quota goal metric
      Docs/mm/damon/design: cocument hugepage_mem_bp target metric

Avi Weiss (2):
      mm/memory: simplify error handling in insert_pages()
      mm/memory: return -ENOMEM for page-table allocation failure in insert_pages()

Baolin Wang (1):
      mm: mglru: clear the reference counter for rejected folios

Baoquan He (1):
      mm: zswap: return -ENOENT when the swap device is gone

Barry Song (Xiaomi) (11):
      mm/mglru: make retry logic explicit in isolate_folios()
      mm: revert slight behavior change for swappiness 1-200
      mm/vmscan: avoid pointless large folio splits without swap
      mm/mglru: separate folio generation update from LRU accounting
      mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
      mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
      mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
      mm/mglru: make LRU folio prefetch helper an inline function
      mm/mglru: move folios from oldest gen to second-oldest gen from head to tail
      mm/mglru: batch move folios to the second-oldest gen's LRU
      mm/mglru: restore accidentally removed seq < max_seq check

Bingfang Guo (1):
      mm/memcg: clear folio memcg after changing per memcg stats

Bo Zhang (1):
      mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache

Breno Leitao (8):
      mm, swap: distinguish a malformed swap entry from a dying device
      mm: fail the fault on a malformed swap entry instead of retrying it
      Documentation: kmemleak: describe the metadata pool, not the early log
      Documentation: kmemleak: fix stale statements about scanning
      mm: kmemleak: raise min_unref_scans to 3 for verbose auto-scan
      mm/shmem: report RCU-tasks quiescent states while undoing a range
      mm: kmemleak: move the struct page scan into a helper
      mm: kmemleak: scan the struct page array in MAX_SCAN_SIZE batches

Cheng-Han Wu (2):
      mm/damon/core: remove unused damon_targets_empty()
      mm/damon/core: remove unused damon_nr_running_ctxs()

Chengfeng Ye (1):
      mm/ksm: mark migration stores with WRITE_ONCE()

Christos Skarlos (1):
      mm/huge_memory: fix various coding style warnings

Dan Carpenter (1):
      mm/hmm/test: reject overflowing page counts

Dave Hansen (5):
      mm: make per-VMA locks available universally
      binder: make shrinker rely solely on per-VMA lock
      mm: add RCU-based VMA lookup helper that waits for writers
      binder: remove mmap_lock fallback
      tcp: remove mmap_lock fallback path

David Carlier (1):
      mm/shmem: don't release a swapin-error marker as a swap entry

David Hildenbrand (Arm) (1):
      selftests/mm: khugepaged: remove str_dup() usage

David Stevens (1):
      memcg: don't call schedule_work when no spinning is allowed

Dev Jain (1):
      mm/rmap: remove stale hugetlb check in try_to_unmap_one

Donggeun Yoo (2):
      mm/damon/core: charge only the part of a region the filter left
      mm/damon/tests/core-kunit: test the size charged for a filter-trimmed region

Eamon Sippy (1):
      mm: cma: make mm/cma.h self-contained and conditionalize includes

Enze Li (2):
      mm/damon/core: introduce damon_set_target_pid()
      samples/damon/mtier: add comment for struct region_range

Eva Kurchatova (1):
      selftests/damon: add script dir to sys.path for PYTHONSAFEPATH compatibility

Gregory Price (14):
      mm/mempolicy: take a cpuset cookie for the interleave node count
      mm/mempolicy: use SRCU for the weighted interleave state
      mm/mempolicy: stop copying the nodemask in the interleave paths
      mm/huge_memory: skip zone device folios in madvise_free_huge_pmd()
      mm/madvise: skip zone device folios in cold/pageout PMD range
      mm/mempolicy: skip zone device folios when queueing folios
      mm/memory_hotplug: factor out node_is_memoryless()
      mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()
      mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range
      mm: refactor find_next_best_node to find_next_best_node_in
      mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
      proc/task_mmu: handle special PMDs in clear_refs and pagemap
      mm/madvise: reclaim isolated folios if PTE restart fails
      mm/madvise: use folio_trylock() in the cold/pageout PMD split

Guillaume Morin (1):
      selftests/mm: hugetlb_madv_vs_map: add underflow test

Hao Ge (1):
      mm/alloc_tag: account for reserved tag ids in the kernel tag check

Hao Jia (1):
      zram: fix idle age_sec underflow in idle_store()

Hao Li (1):
      mm: remove unused anon_vma_trylock_write()

Hari Mishal (1):
      selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test

Harry Yoo (Meta) (1):
      selftests/cgroup: ignore memory.reclaim -EAGAIN for zswap writeback test

Hemanth Selam (1):
      selftests/mm: remove the local PKEY_UNRESTRICTED fallback

Hongfu Li (8):
      mm: use a folio in the softleaf_is_device_private path
      mm/hugetlb: fix resv_huge_pages double decrement in memfd error path
      mm/memcontrol: remove unused memcg parameter in calculate_high_delay()
      selftests/mm: khugepaged: consolidate error exits via kselftest helpers
      mm/page_owner: preserve original free_pid/free_tgid during folio migration
      selftests/mm: fix ptrace PEEKDATA check in memfd_secret test
      mm/hugetlb_cgroup: move per-node usage on cross node migration
      mm/hugetlb_cgroup: move per-node usage on cgroup reparenting

Huaisheng Ye (1):
      mm/hugetlb: account for allowed nodes when gathering surplus pages

Hui Zhu (5):
      mm/vmstat: annotate data race for per-cpu pageset fields
      mm: memcg: redirect stats updates of dying memcgs for all hierarchies
      mm: workingset: use lruvec_page_state_local() to count lru pages
      mm: memcg: skip the RCU lock when the memcg is not dying
      mm: memcg: reparent non-hierarchical lruvec stats on cgroup v2

Jaeyeon Lee (2):
      mm/damon/tests: use scoped_guard() for damon_test_ops_registration
      selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable

Jason Angelov (2):
      mm/damon/core-kunit: test probe_hits handling at region split and merge
      mm/damon/core-kunit: test damon_valid_probe_params()

Jianyue Wu (3):
      mm/zswap: release retired pools via queue_rcu_work() instead of synchronize_rcu()
      mm/zswap: replace the zswap_pools list with an allocating xarray
      mm/zswap: reference the pool by id to shrink struct zswap_entry

Jiayuan Chen (1):
      mm/memcontrol: fix data-race on reading jiffies_64

Jinjiang Tu (2):
      docs: ksm: fix typos in sysfs knob names
      mm/ksm: fix advisor_min_pages_to_scan description

Jinmeng Zhou (2):
      mm/hugetlb: charge folios to the target mm's memcg
      mm/hugetlb: fix subpool minimum reservation rollback

Joanne Koong (1):
      mm/memcontrol: skip non-hierarchical memcg-wide stats when v1 is unavailable

Joe Damato (1):
      mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming

Johannes Weiner (1):
      mm: add page_counter_margin()

Kairui Song (23):
      mm/memcontrol: move the lru_zone_size sanity check to the reader side
      mm/mglru: introduce helpers for manipulating gen and refs flags
      mm/migrate: copy all referenced state via folio_migrate_lru_refs
      mm/mglru: move max_seq read into walk_update_folio
      mm/mglru: use explicit tier range in read_ctrl_pos()
      mm/mglru: fix potential generation folio number leak
      mm/swap: fix off-by-one in swap cache replace sanity check
      mm/huge_memory: fix rejection of swap cache folios with a mapping
      mm/huge_memory: invert folio_ref_freeze() check to reduce indentation
      mm/huge_memory: split the routine for splitting anon and file folio
      mm/huge_memory: rename __split_unmapped_folio() to __split_frozen_folio()
      mm/huge_memory: consolidate irq and locking for folio split
      mm/huge_memory: move EOF trimming into the file split helper
      mm/huge_memory: move unmap and remap into the split helpers
      mm/huge_memory: rename remap_page() to remap_anon_folio()
      mm/huge_memory: move the racy refcount check into unmap_folio()
      mm/huge_memory: move filemap management into the file split helper
      mm/huge_memory: move anon_vma handling into the anon split helper
      mm/huge_memory: move memcg switch into the file split helper
      mm/huge_memory: drop the unused do_lru argument of the file split helper
      mm/huge_memory: clean up after-split folio freeing in __folio_split
      mm/huge_memory: count only swap cache refs in anon folio split
      mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio

Kaitao Cheng (2):
      mm/hugetlb: use hugetlb_vmemmap_optimizable() in boolean contexts
      mm/page-flags: define HWPoison test-and-change helpers unconditionally

Karl Mehltretter (3):
      mm/damon/core: keep the temporal tuner quota over an unmeasured PSI round
      docs/mm: ksm: use the renamed ksm structure names
      mm/secretmem: fix the enable parameter description

Karthikeyan KS (1):
      mm/damon: document that a zero sample_interval is accepted

Kefeng Wang (8):
      xfs: remove dead kswapd flag inheritance from btree split worker
      iomap: simplify writepages reclaim guard
      mm: replace PF_KSWAPD flag with kthread_func() check
      mm: replace PF_KCOMPACTD flag with kthread_func() check
      mm: zswap: convert zswap_invalidate() to take a range
      mm: zswap: skip xarray walk in zswap_invalidate() when zswap is unused
      mm: zswap: reuse zswap_invalidate() in zswap_store()
      mm: mincore: use per-vma lock during page table walk

Kemeng Shi (4):
      mm, swap: fix potential NULL dereference when trying a sleep table allocation
      mm, swap: move setup_swap_clusters_info() after SWP_SOLIDSTATE initialization
      mm, swap: return early from swap_extend_table_try_free() on first non-zero entry
      mm, swap: remove unneeded swap_extend_table_try_free() in swap_dup_entries_cluster()

Kiryl Shutsemau (Meta) (22):
      mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
      mm/huge_memory: dequeue the deferred split after the split freeze
      mm/huge_memory: add folio_reset_partially_mapped()
      selftests/mm: raise the khugepaged test-case cap
      selftests/mm: skip collapse_compound_extreme() where the PMD is too large
      selftests/mm: scale khugepaged's collapse wait with the PMD size
      selftests/mm: skip khugepaged page cache cases without a PMD folio
      selftests/mm: make the swap cases' swapout reliable
      selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
      selftests/mm: move is_backed_by_folio() into vm_util
      selftests/mm: add folio-order check for address ranges
      selftests/mm: add folio-order detection self-check
      selftests/mm: add khugepaged completion barrier helper
      selftests/mm: add order-parameterized khugepaged collapse cases
      selftests/mm: parameterize the mixed-source collapse case by source order
      selftests/mm: cover a shared-source collapse write race
      selftests/mm: run every supported collapse order by default
      selftests/mm: check that one khugepaged pass collapses one window
      selftests/mm: add khugepaged race harness
      selftests/mm: race the collapse of windows with holes
      selftests/mm: add memory-pressure threads to the khugepaged race harness
      selftests/mm: zap whole PTE tables in the khugepaged race harness

Krishna Iyer (3):
      mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
      mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap walkers
      mm/damon/paddr: support hugetlb folios in access monitoring

Kunwu Chan (1):
      mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation

Lance Yang (2):
      mm/huge_memory: simplify pgtable deposit detection
      mm: disallow raw PFN mappings of huge/shared zeropage

Li Youhong (1):
      mm/damon/ops-common: factor out damon_putback_folio_list()

Li Zhe (7):
      mm: fix stale ZONE_DEVICE refcount comment
      mm: add a set_page_section_from_pfn() helper
      mm: add a template-based fast path for zone-device page init
      mm: extend the template fast path to zone-device compound tails
      string: introduce memcpy_nontemporal()
      mm: use memcpy_nontemporal() in zone-device template copies
      x86/string: extend memcpy_flushcache() fixed-size fastpaths

Liew Rui Yan (6):
      docs/mm/damon/design: accurate semantics of nr_snapshots
      docs/mm/damon/design: difference between watermarks and nr_snapshots
      docs/mm/damon/design: fix typo of max_nr_snapshots
      Docs/mm/damon/design: clarify when qt_exceeds increases
      Docs/mm/damon/design: fix typos in temporal auto-tuning algorithm section
      mm/damon/core: skip quota score setup when the quota is full

Lisa Wang (5):
      mm: memory_failure: clarify the MF_DELAYED definition
      mm: memory_failure: Allow truncate_error_folio to return MF_DELAYED
      mm: shmem: Update shmem handler to the MF_DELAYED definition
      mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
      mm: selftests: Add shmem into memory failure test

Longlong Xia (5):
      mm/hugetlb: warn instead of silently bailing gigantic pages without runtime support
      mm/hugetlb: preserve source surplus accounting during demotion
      mm/hugetlb: cap demotion at currently available free pages
      mm/zswap: publish the initial pool with list_add_rcu()
      mm/zswap: enable zswap_ever_enabled in zswap_pool_create()

Lorenzo Stoakes (ARM) (21):
      mm/vmpressure: remove window size TODO
      tools/testing/selftests/mm: add missing .gitignore entries
      mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on MADV_WILLNEED
      mm/khugepaged: deposit a newly allocated page table on collapse
      mm: enable MMU_GATHER_RCU_TABLE_FREE for most 2-level architectures
      mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU riscv
      mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
      mm: enable MMU_GATHER_RCU_TABLE_FREE for arc, microblaze, xtensa
      mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc64
      mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-coldfire
      mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
      mm: enable MMU_GATHER_RCU_TABLE_FREE for m68k-motorola
      mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc32
      mm: userland pgtable freeing is RCU-safe now, remove leftover bits
      mm: change the contract for free_pgtables(), update docs
      mm: move drivers/char/mem.c to mm/char-mem.c
      mm: implement file_is_dev_zero() to uniquely identify /dev/zero
      mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
      mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
      tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
      tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests

Luxiao Xu (1):
      mm/memory: constrain generic_access_phys() to page boundary

Matthew Wilcox (Oracle) (3):
      md: use folio_alloc_buffers()
      md: use folio APIs in free_page()
      md: remove the last use of page_buffers()

Meijing Zhao (3):
      mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
      mm: trace: decode MTE and shadow stack VMA flags
      mm: trace: name protection key encoding bits

Mike Rapoport (Microsoft) (15):
      set_memory: add number of pages parameter to set_direct_map APIs
      mm/vmalloc: set area's page_order after allocation succeeds
      mm/vmalloc: constify vm parameter of get_vm_area_page_order()
      mm/vmalloc: make set_area_direct_map HUGE_VMAP friendly
      mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache allocations
      Revert "arch: introduce set_direct_map_valid_noflush()"
      mm/execmem: free ROX cache chunks only when they span an entire vm area
      mm/execmem: handle potential allocation errors in the maple tree
      mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE
      mm/vmalloc: add DEFINE_FREE() for vfree()
      mm/execmem: use cleanup infrastructure in ROX cache functions
      docs/core-api: memory-allocation: add k[mz]alloc_obj() and clarify kmalloc
      MAINTAINERS: add memory related docs in core-mm/ to MM - MISC section
      docs/core-api: memory-allocation: clarify when to use kzalloc_obj and kzalloc
      docs/mm: describe set_memory() and set_direct_map() APIs

Muchun Song (29):
      mm/sparse: relax struct mem_section size constraints
      mm/sparse-vmemmap: rename HVO order macros
      mm/mm_init: skip initializing shared vmemmap tail pages
      mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
      mm/sparse-vmemmap: support section-based vmemmap accounting
      mm/mm_init: factor out pfn_to_zone()
      mm/sparse-vmemmap: move helpers ahead of future callers
      mm/sparse-vmemmap: support section-based vmemmap optimization
      mm/sparse: initialize memory sections earlier
      mm/hugetlb: switch HugeTLB to section-based vmemmap optimization
      mm/sparse-vmemmap: remove SPARSEMEM_VMEMMAP_PREINIT support
      mm/sparse: inline usemap allocation into sparse_init_nid()
      mm/sparse: remove section_map_size()
      mm/hugetlb: remove HUGE_BOOTMEM_HVO
      mm/hugetlb: remove HUGE_BOOTMEM_CMA
      mm/hugetlb: localize struct huge_bootmem_page
      mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
      mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
      mm/sparse-vmemmap: allocate shared tail page array dynamically
      mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
      mm/sparse-vmemmap: open-code init_compound_tail()
      mm/sparse-vmemmap: prepare DAX vmemmap population for compound page orders
      mm/sparse-vmemmap: set compound page order for device DAX
      mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
      mm/sparse-vmemmap: move vmemmap optimization helpers to a public header
      powerpc/mm: switch device DAX to shared tail vmemmap pages
      mm/sparse-vmemmap: drop the extra tail page from device DAX reservation
      mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
      Documentation/mm: update DAX vmemmap deduplication docs

Pedro Falcato (2):
      mm: replace custom bad page map ratelimiting logic
      mm/page_alloc: replace custom bad page ratelimiting logic

Qi Xi (3):
      mm: drop stale MAX_ORDER references
      mm/page_isolation: fix UBSAN shift-out-of-bounds warning
      mm/page_isolation: guard compound_order() against racing

Qi Zheng (4):
      mm: memcontrol: make obj_cgroup_memcg() handle NULL objcg
      mm: shmem: move unused huge shrinklist queuing past the truncation check
      mm: shmem: make unused huge shrinker memcg aware
      mm: shmem: assign a lock class to the unused huge shrinklist

Qinyun Tan (2):
      mm/list_lru: disable memcg awareness under cgroup_disable=memory
      mm/list_lru: don't copy stale shrinker id from non-memcg-aware shrinkers

Qiqi Liu (2):
      mm: page_alloc: add missing hooks to bulk allocation path
      mm/page_alloc: apply per-task GFP context in bulk allocator

Ridong Chen (8):
      mm/vmscan: drop the combined limit gate in __node_reclaim()
      mm/mglru: preserve inactive placement when enabling MGLRU
      mm/mglru: make type fallback logic explicit in isolate_folios()
      memcg: acquire peaks_lock when reading memory.peak
      mm, memcg: fix memory.peak reset clobbering other fds' watermark
      mm/page_counter: avoid integer overflow in effective_protection()
      mm/mglru: fix ineffective memory protection for non-kswapd reclaim
      mm: vmscan: put rotation-missed folios at the LRU tail

Rik van Riel (1):
      mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus

SJ Park (98):
      mm/damon/core: skip applying scheme if region split for quota fails
      mm/damon/paddr: respect folio end for DAMOS_STAT
      mm/damon/paddr: respect folio end for DAMOS actions except STAT
      mm/damon/vaddr: respect folio end for DAMOS_STAT
      mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
      mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
      mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
      mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
      mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
      mm/damon/paddr: support PGIDLE_UNSET probe filter type
      mm/damon/sysfs: support pgidle_unset probe filter type
      Docs/mm/damon/design: document pgidle_unset probe filter type
      mm/damon/core: introduce damon_prep struct
      mm/damon/core: commit preps
      mm/damon/core: introduce damon_operations->prep_probes()
      mm/damon/paddr: support damon_prep
      mm/damon/sysfs: implement preps directory
      mm/damon/sysfs: implement preps/nr_preps file
      mm/damon/sysfs: create directories for nr_preps writes
      mm/damon/sysfs: implement prep_action file
      mm/damon/sysfs: pass preps to DAMON core
      selftests/damon/sysfs.sh: test probe prep sysfs files
      Docs/mm/damon/design: document probe preps
      Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
      Docs/ABI/damon: document probe prep sysfs files
      mm/damon/tests/core-kunit: test committing psi goal to psi goal
      mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
      mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
      mm/damon/sysfs: set next refresh jiffies per sysfs context
      mm/damon/tests/core-kunit: test damon_commit_filter()
      mm/damon/tests/core-kunit: add damon_commit_probes() test
      selftests/damon/_damon_sysfs: implement DamonProbes
      selftests/damon/drgn_dump_damon_status: dump probes
      selftests/damon/sysfs.py: extend commit assertion function for probes
      selftests/damon/sysfs.py: test damon probes
      mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
      mm/damon/core: remove debug messages
      mm/damon/core: remove string_choices.h include
      mm/damon/vaddr: remove a debug message
      mm/damon/core: validate number of probes in valid_probe_params()
      mm/damon/sysfs: remove probes number validation
      mm/damon/tests/core-kunit: extend set_regions() test for error case
      mm/damon/tests/core-kunit: test <=0 size damon_set_regions() inputs
      mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
      mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
      selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
      Docs/mm/damon/maintainer-profile: update AI review for Sashiko replies
      Docs/ABI/damon: recommend subsystem doc instead of admin-guide
      mm/damon/core: error damos_commit_quota_goal() for zero target_value
      Revert "mm/damon/lru_sort: error out for >10000 active_mem_bp"
      Revert "samples/damon/mtier: error out for zero quota goal target values"
      mm/damon/core: handle NULL ctx parameter in damon_call()
      mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()
      mm/damon/reclaim: remove unnecessary damon_call() param validation
      mm/damon/lru_sort: remove unnecessary damon_call() param validation
      mm/damon/vaddr: support prep_probes
      mm/damon/paddr: move probe filter handling to ops-common
      mm/damon/vaddr: support apply_probe
      mm/damon/vaddr: extend apply_probes() for hugetlb
      mm/damon/vaddr: support pgidle_unset probe filter type
      mm/damon/api: introduce DAMON_FILTER_TYPE_PGIDLE_SET
      mm/damon/paddr: support DAMON_FILTER_TYPE_PGIDLE_SET
      mm/damon/vaddr: support DAMON_FILTER_TYPE_PGIDLE_SET
      mm/damon/sysfs: support DAMON_FILTER_TYPE_PGIDLE_SET
      Docs/mm/damon/design: update for pgidle_set probe filter
      mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
      mm/damon/core: extend probe_hits_wsum() for moving sum based calculation
      mm/damon/core: support probe_hits_wsum damos core filter
      mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to range_{min,max}
      mm/damon/sysfs-schemes: support probe_hits_wsum damos core filter
      Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
      Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS filter
      mm/damon/sysfs-schemes: read sysfs_filter->addr_range only once
      mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
      mm/damon/core: return an error from damos_commit_filter_arg()
      mm/damon/core: disallow max < min damos filter range arguments commit
      mm/damon/sysfs-schemes: drop centralized filter range arg validations
      mm/damon/sysfs-schemes: use switch-case in add_scheme_filters()
      mm/damon/core-kunit: extend damos_commit_filter_for() for wrong input
      mm/damon/core-kunit: test invalid damos filter commits
      mm/damon/api: introduce DAMON_FILTER_TYPE_HUGEPAGE_SIZE
      mm/damon/core: commit hugepage_size type damon filter
      mm/damon/ops-common: support hugepage_size damon filter matching
      mm/damon/sysfs: add min,max files under probe filter directory
      mm/damon/sysfs: support hugepage_size probe filter
      Docs/mm/damon/design: update for hugepage_size probe filter
      Docs/admin-guide/mm/damon/usage: update for hugepage_size
      Docs/ABI/damon: update for hugepage_size probe filter
      mm/damon/api: remove NR_DAMOS_FILTER_TYPES
      mm/damon/core: use abs_diff() in damon_feed_loop_next_input()
      mm/damon/core: use mult_frac() in damon_feed_loop_next_input()
      mm/damon/core: set damon_ctx->walk_control_obsolete in damon_new_ctx()
      mm/damon/core: document damon_call()/damon_start() race hang issue
      mm/damon/paddr: remove pa parameter from damon_pa_filter_pass()
      mm/damon/tests/core-kunit: test eligible_mem_bp commitment
      mm/damon/tests/core-kunit: add probe_hits_wsum damos filter commit test
      selftests/damon/sysfs_memcg_path_leak: fail only for real DAMON leak
      Docs/mm/damon/design: clarify bp is basis point

Sang-Heon Jeon (6):
      percpu: fix the comment about which sizes share a slot
      percpu: remove redundant assignments to bits
      percpu: remove unnecessary initialization in pcpu_build_alloc_info()
      percpu: remove unnecessary cpumask_clear() in pcpu_build_alloc_info()
      percpu: remove unnecessary return in pcpu_populate_pte()
      mm/swapops: remove unused is_hwpoison_entry()

Sarthak Sharma (8):
      mm/gup_test: report actual pinned bytes
      mm/gup_test: safely calculate GUP batch size
      selftests/mm: make file helpers return errors
      tools/lib/mm: add shared file helpers
      tools/lib/mm: move hugepage_settings out of selftests
      tools/mm: move gup_test from selftests/mm to tools/mm
      tools/mm: make gup_bench a benchmark only tool
      selftests/mm: add a GUP selftest

Sebastian Andrzej Siewior (1):
      mm/vmalloc: use %p for pointer formatting

Sergey Senozhatsky (3):
      zram: remove unreachable kernel_read_file_from_path() return check
      zram: convert to SG-list zsmalloc object read API
      zsmalloc: remove old object read API

Shakeel Butt (16):
      memcg: clear FLUSHING_CACHED_CHARGE on cpu offline
      memcg: trim the per-cpu charge stock instead of draining it
      memcg: remove v1 soft limit reclaim
      memcg: remove mem_cgroup_shrink_node()
      memcg: remove the soft limit reclaim tracepoints
      memcg: remove the soft limit rbtree
      memcg: remove lru_gen_soft_reclaim()
      memcg: remove the per-node soft limit tree fields
      memcg: remove mem_cgroup->soft_limit
      memcg: simplify v1 event ratelimiting
      memcg: move per-node objcg to the read-mostly fields
      memcg: split mem_cgroup_private_id into two fields
      memcg: group the write-hot fields of struct mem_cgroup
      memcg: group the cold fields of struct mem_cgroup
      memcg: group the read-mostly fields of struct mem_cgroup
      memcg: group the fields of struct mem_cgroup_per_node

Song Hu (3):
      selftests/mm: emit TAP header in uffd-wp-mremap
      selftests/mm: emit TAP header and use TAP skip in mremap_test
      selftests/mm: restore enable_soft_offline in hugetlb-soft-offline

Suren Baghdasaryan (7):
      proc/task_mmu: remove unnecessary helpers
      proc/task_mmu: remove unnecessary inlines in function definitions
      proc/task_mmu: clarify shmem mapping walk conditions in smap_gather_stats()
      proc/task_mmu: remove special-casing of smap_gather_stats() start parameter
      proc/task_mmu: change proc_get_vma() to stop returning gate VMA at the end
      proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock
      selftests/proc: add /proc/pid/smaps_rollup tearing tests

Tal Zussman (29):
      mm/page_io: convert write completion handlers to folios
      mm: remove PageReclaim
      mm/page_io: use swap entries directly in zeromap helpers
      mm/page_io: rename bio_associate_blkg_from_page()
      mm/page_io: refer to folios in swap_writeout() comments
      mm/swap: rename __swap_writepage() to __swap_writeout()
      mm: remove unused mark_page_reserved()
      mm: remove unused totalram_pages_inc() and totalram_pages_dec()
      mm: remove PageWriteback
      mm/swap: add folio_swap_entry() and folio_page_swap_entry()
      mm/huge_memory: add a comment to the open-coded swap entry
      mm/rmap: use folio_page_swap_entry() in ttu_anon_swapbacked_folio()
      mm/zswap: use folio_swap_entry() in zswap_store_page()
      mm/swapfile: use folio_page_swap_entry()
      arm64: mte: make mte_save_tags() and mte_restore_tags() static
      arm64: mte: pass the swap entry to mte_save_tags()
      mm/swap: remove page_swap_entry()
      mm: memcontrol: take a const folio in folio_memcg() and friends
      mm: memcontrol: constify obj_cgroup_memcg() and friends
      mm: memcontrol: constify the lruvec helpers
      mm/page_io: take a const folio in bio_associate_blkg_from_folio()
      mm: memcontrol: constify the mem_cgroup accessors
      mm: page_counter: constify page_counter_read() and page_counter_margin()
      mm: memcontrol: constify the reclaim protection helpers
      mm: memcontrol: constify the memcg and lruvec stat readers
      mm: memcontrol: constify the swap accounting helpers
      mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
      mm: memcontrol: constify the zswap and socket pressure helpers
      vmcore: convert mmap_vmcore_fault() to use folios

Tao Cui (1):
      docs: cgroup: document empty-write behavior of memory limit knobs

Tianyi Chen (3):
      selftests/mm: reject invalid test selections before running tests
      selftests/mm: only prepare ptrace_scope when memfd_secret is selected
      tools/testing/vma: cover hole filling through __mmap_region()

Usama Arif (2):
      mm: zswap: don't fail a large-folio swapin whose range is not in zswap
      mm: filemap: move lruvec accounting outside the xarray lock

Vernon Yang (3):
      mm: khugepaged: fix swap entry value to folio_pfn()
      mm: khugepaged: fix folio is used after pte_unmap_unlock()
      mm: khugepaged: fix folio is used after folio_put/unlock()

Wei Yang (2):
      mm: adjust out-dated document of __GFP_NOFAIL
      mm/page_vma_mapped: guard check_pmd() with CONFIG_TRANSPARENT_HUGEPAGE

Wilson Felipe Pereira (3):
      selftests/cgroup: test_zswap: wait for cgroup to unpopulate in test_zswap_writeback
      selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass
      mm/zswap: convert zswap_store_page() and zswap_compress() to take a folio

Xuewen Wang (1):
      mm/damon/sysfs: propagate damon_call() error in turn_damon_on

Xueyuan Chen (2):
      mm: distinguish large folio swap allocation failures
      mm/shmem: split large folios only on -E2BIG

Ye Liu (9):
      tools/mm/page_owner_sort: fix --sort option being silently ignored
      tools/mm/page_owner_sort: add module name sort/cull/filter support
      tools/mm/page_owner_sort: show available sort keys in usage text
      mm/oom_kill: remove unreachable __GFP_THISNODE check in constrained_alloc()
      mm/oom_kill, proc: replace magic number 1000 with OOM_SCORE_ADJ_MAX
      mm/page_table_check: add explicit pmd_none check in pte_clear_range
      mm/vmalloc: group xa_init with vbq field initializations
      mm/vmalloc: extract vmap_insert_free_area helper
      mm/vmalloc: extract show_busy_info from vmalloc_info_show

Yeoreum Yun (2):
      kselftest: mm: fix potential failure for merged VMA in guard-regions
      kselftest: mm: remove exclusion of building soft-dirty test in arm64

Youngjun Park (2):
      mm/swap: fix stale comment on swap_info_struct::cluster_info
      mm/swap: scan by cluster in find_next_to_unuse()

Yuanhe Shu (1):
      mm/page_alloc: do not boost watermarks in kdump capture kernels

Yue Haibing (1):
      mm/swap: remove unused declaration swapcache_clear()

Yury Norov (4):
      lib: fix lock initialization in region allocation benchmark
      compiler.h: add ASSERT_STATIC_STORAGE()
      idr: assert static storage for DEFINE_IDA()
      maple_tree: assert static storage for DEFINE_MTREE()

Zenghui Yu (Huawei) (9):
      selftests/mm: fix incorrect skip output in pkey_sighandler_tests
      mm/damon/core: remove declaration of __damon_commit_ctx()
      selftests/mm: remove unreachable returns after ksft exit helpers
      Docs/mm/damon/design: fix broken :ref: usage and a typo
      selftests/mm: fix size truncation in pagemap_ioctl test
      selftests/mm: mark file-local symbols of pagemap_ioctl.c static
      selftests/mm: init page sizes early in pagemap_ioctl test
      selftests/damon: stop kdamond on error exits of no-op commit test
      selftests/damon: ignore test-generated damon_dump_output

Zhenghui Hao (1):
      mm/hugetlb: fix misspelled parameter names in comment

Zhiling Zou (1):
      mm/page_table_check: skip zero pages

Zi Yan (14):
      mm/zsmalloc: replace PG_private with pointer comparison
      perf/ring_buffer: stop using PG_private as AUX page high-order marker
      xen/grant-table: stop setting PG_private on pages for grant mapping
      fscrypt: stop setting PG_private on bounce page
      mm/hugetlb: use direct assignment instead of folio_change_private()
      f2fs: stop using PG_private
      f2fs: convert the ->private flag helpers to folio-only
      erofs: mm/pagemap: add readahead_folio_last() to avoid folio->private
      erofs: use folio_attach/detach_private() instead of direct assignment
      mm/page-flags: check page/folio->private instead of PG_private
      treewide: remove folio_set/clear_private() usage
      ceph: replace PagePrivate() with page_private()
      treewide: remove PagePrivate() and PG_private from comments and docs
      mm/page-flags: remove PG_private

zhaozhengzhuo (2):
      selftests/damon: prevent remaining cross-object state pollution
      mm/migrate_device: fix function name in kernel-doc

 Documentation/ABI/testing/sysfs-kernel-mm-damon    |  29 +-
 Documentation/admin-guide/cgroup-v2.rst            |   4 +
 Documentation/admin-guide/kdump/vmcoreinfo.rst     |   2 +-
 Documentation/admin-guide/mm/damon/usage.rst       |  26 +-
 Documentation/admin-guide/mm/ksm.rst               |   8 +-
 Documentation/arch/powerpc/vmemmap_dedup.rst       |  90 +--
 Documentation/core-api/memory-allocation.rst       |  32 +-
 Documentation/core-api/mm-api.rst                  |   9 +
 Documentation/core-api/pin_user_pages.rst          |   9 -
 Documentation/dev-tools/kmemleak.rst               |  24 +-
 Documentation/filesystems/vfs.rst                  |   6 +-
 Documentation/mm/damon/design.rst                  |  49 +-
 Documentation/mm/damon/maintainer-profile.rst      |  19 +-
 Documentation/mm/index.rst                         |   1 +
 Documentation/mm/kernel-page-tables.rst            | 410 ++++++++++++
 Documentation/mm/ksm.rst                           |   2 +-
 Documentation/mm/page_owner.rst                    |   8 +-
 Documentation/mm/process_addrs.rst                 |  11 +
 Documentation/mm/vmemmap_dedup.rst                 |  32 +-
 MAINTAINERS                                        |  11 +-
 arch/Kconfig                                       |   8 -
 arch/alpha/Kconfig                                 |   1 -
 arch/alpha/include/asm/pgtable.h                   |   7 -
 arch/arc/include/asm/pgalloc.h                     |   6 +-
 arch/arc/include/asm/pgtable-levels.h              |  11 -
 arch/arm/Kconfig                                   |   2 -
 arch/arm/include/asm/pgtable.h                     |   7 -
 arch/arm/kernel/traps.c                            |  17 -
 arch/arm64/Kconfig                                 |   2 -
 arch/arm64/include/asm/mte.h                       |   2 -
 arch/arm64/include/asm/pgtable.h                   |  15 -
 arch/arm64/include/asm/set_memory.h                |   5 +-
 arch/arm64/mm/mteswap.c                            |  32 +-
 arch/arm64/mm/pageattr.c                           |  24 +-
 arch/csky/include/asm/pgtable.h                    |   4 -
 arch/hexagon/include/asm/pgtable.h                 |   3 -
 arch/loongarch/Kconfig                             |   2 -
 arch/loongarch/include/asm/pgtable.h               |  14 +-
 arch/loongarch/include/asm/set_memory.h            |   5 +-
 arch/loongarch/mm/init.c                           |   4 +-
 arch/loongarch/mm/pageattr.c                       |  27 +-
 arch/m68k/Kconfig                                  |   1 +
 arch/m68k/include/asm/mcf_pgalloc.h                |   5 +-
 arch/m68k/include/asm/mcf_pgtable.h                |   6 -
 arch/m68k/include/asm/motorola_pgalloc.h           |   9 +-
 arch/m68k/include/asm/motorola_pgtable.h           |   8 -
 arch/m68k/include/asm/sun3_pgtable.h               |   7 -
 arch/m68k/mm/motorola.c                            | 119 ++--
 arch/microblaze/include/asm/pgalloc.h              |   2 +-
 arch/microblaze/include/asm/pgtable.h              |   7 -
 arch/mips/Kconfig                                  |   1 -
 arch/mips/include/asm/pgtable-32.h                 |  10 -
 arch/mips/include/asm/pgtable-64.h                 |  13 -
 arch/nios2/include/asm/pgtable.h                   |   7 -
 arch/openrisc/include/asm/pgtable.h                |   7 -
 arch/parisc/Kconfig                                |   1 -
 arch/parisc/include/asm/pgtable.h                  |   9 -
 arch/parisc/kernel/pci-dma.c                       |   6 +-
 arch/powerpc/Kconfig                               |   1 -
 arch/powerpc/include/asm/book3s/32/pgtable.h       |   2 -
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   7 -
 arch/powerpc/include/asm/nohash/32/pgtable.h       |   2 -
 arch/powerpc/include/asm/nohash/64/pgtable-4k.h    |   3 -
 arch/powerpc/include/asm/nohash/64/pgtable.h       |   5 -
 arch/powerpc/mm/book3s64/radix_pgtable.c           | 132 +---
 arch/powerpc/platforms/powernv/Kconfig             |   1 -
 arch/powerpc/platforms/pseries/Kconfig             |   1 -
 arch/riscv/Kconfig                                 |   2 -
 arch/riscv/include/asm/page.h                      |   6 -
 arch/riscv/include/asm/pgtable-64.h                |   9 -
 arch/riscv/include/asm/pgtable.h                   |   4 -
 arch/riscv/include/asm/set_memory.h                |   5 +-
 arch/riscv/mm/init.c                               |   1 +
 arch/riscv/mm/pageattr.c                           |  23 +-
 arch/s390/Kconfig                                  |   2 -
 arch/s390/include/asm/pgtable.h                    |  11 -
 arch/s390/include/asm/set_memory.h                 |   5 +-
 arch/s390/mm/pageattr.c                            |  20 +-
 arch/sh/Kconfig                                    |   1 +
 arch/sh/include/asm/pgalloc.h                      |   6 +-
 arch/sh/include/asm/pgtable-3level.h               |   3 -
 arch/sh/include/asm/pgtable_32.h                   |  13 -
 arch/sh/mm/init.c                                  |  16 +-
 arch/sh/mm/pgtable.c                               |  20 +
 arch/sparc/Kconfig                                 |   4 +-
 arch/sparc/include/asm/pgalloc_32.h                |   7 +-
 arch/sparc/include/asm/pgalloc_64.h                |   8 -
 arch/sparc/include/asm/pgtable_32.h                |   3 -
 arch/sparc/include/asm/pgtable_64.h                |  10 -
 arch/sparc/include/asm/tlb_64.h                    |   2 -
 arch/sparc/lib/bitext.c                            |  14 +-
 arch/sparc/mm/srmmu.c                              |  32 +-
 arch/um/Kconfig                                    |   1 -
 arch/um/include/asm/pgtable-2level.h               |   7 -
 arch/um/include/asm/pgtable-4level.h               |  13 -
 arch/x86/Kconfig                                   |   4 -
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h      |   2 +-
 arch/x86/events/intel/bts.c                        |   3 -
 arch/x86/events/intel/pt.c                         |   6 +-
 arch/x86/include/asm/pgtable-2level.h              |   5 -
 arch/x86/include/asm/pgtable-3level.h              |  11 -
 arch/x86/include/asm/pgtable_64.h                  |  18 -
 arch/x86/include/asm/set_memory.h                  |   5 +-
 arch/x86/include/asm/string_64.h                   |  83 ++-
 arch/x86/mm/pat/set_memory.c                       |  16 +-
 arch/xtensa/include/asm/pgtable.h                  |   4 -
 arch/xtensa/include/asm/tlb.h                      |   2 +-
 drivers/android/binder/page_range.rs               |  19 +-
 drivers/android/binder_alloc.c                     |  63 +-
 drivers/block/zram/zcomp.c                         |  23 +-
 drivers/block/zram/zcomp.h                         |   4 +-
 drivers/block/zram/zram_drv.c                      |  82 +--
 drivers/char/Makefile                              |   2 +-
 drivers/hid/hid-core.c                             |   4 +-
 drivers/md/md-bitmap.c                             |  18 +-
 drivers/nvdimm/pmem.c                              |   2 +-
 drivers/nvdimm/pmem.h                              |  12 -
 drivers/xen/grant-table.c                          |  11 +-
 fs/Kconfig                                         |   2 +-
 fs/buffer.c                                        |   8 -
 fs/ceph/addr.c                                     |   8 +-
 fs/crypto/crypto.c                                 |   2 -
 fs/erofs/data.c                                    |  16 +-
 fs/erofs/zdata.c                                   |  13 +-
 fs/f2fs/compress.c                                 |  35 +-
 fs/f2fs/data.c                                     |   2 +-
 fs/f2fs/f2fs.h                                     |  99 ++-
 fs/f2fs/segment.c                                  |   2 +-
 fs/iomap/buffered-io.c                             |   3 +-
 fs/nfs/file.c                                      |   4 +-
 fs/nfs/write.c                                     |   2 -
 fs/proc/base.c                                     |   3 +-
 fs/proc/internal.h                                 |   2 -
 fs/proc/page.c                                     |   1 -
 fs/proc/task_mmu.c                                 | 440 +++++--------
 fs/proc/vmcore.c                                   |  27 +-
 fs/ubifs/file.c                                    |   8 +-
 fs/xfs/libxfs/xfs_btree.c                          |  18 +-
 fs/xfs/xfs_platform.h                              |   4 -
 include/asm-generic/pgtable-nop4d.h                |   1 -
 include/asm-generic/pgtable-nopmd.h                |   1 -
 include/asm-generic/pgtable-nopud.h                |   1 -
 include/asm-generic/tlb.h                          |  66 +-
 include/linux/buffer_head.h                        |   8 +-
 include/linux/cgroup.h                             |   3 +
 include/linux/compaction.h                         |  11 +-
 include/linux/compiler.h                           |   5 +
 include/linux/damon.h                              |  90 ++-
 include/linux/gfp_types.h                          |   2 +-
 include/linux/hugetlb.h                            |   8 +-
 include/linux/idr.h                                |   5 +-
 include/linux/kernel-page-flags.h                  |   1 -
 include/linux/maple_tree.h                         |   4 +-
 include/linux/memcontrol.h                         | 443 +++++++------
 include/linux/mm.h                                 |  98 ++-
 include/linux/mm_inline.h                          | 115 +++-
 include/linux/mm_types.h                           |  12 +-
 include/linux/mmap_lock.h                          |  94 ++-
 include/linux/mmzone.h                             | 107 +---
 include/linux/page-flags.h                         |  64 +-
 include/linux/page_counter.h                       |   3 +-
 include/linux/pagemap.h                            |  67 +-
 include/linux/pgtable.h                            |  24 +-
 include/linux/sched.h                              |   4 +-
 include/linux/set_memory.h                         | 120 +++-
 include/linux/shmem_fs.h                           |  12 +-
 include/linux/string.h                             |  13 +
 include/linux/swap.h                               |  59 +-
 include/linux/swapops.h                            |   9 -
 include/linux/vmalloc.h                            |   4 +
 include/linux/vmemmap-optimization.h               | 115 ++++
 include/linux/zsmalloc.h                           |   4 -
 include/linux/zswap.h                              |   8 +-
 include/net/mana/mana.h                            |   4 +-
 include/trace/events/huge_memory.h                 |  18 +-
 include/trace/events/mmflags.h                     |  45 +-
 include/trace/events/pagemap.h                     |   2 +-
 include/trace/events/vmscan.h                      |  14 -
 kernel/bpf/stackmap.c                              |  17 +-
 kernel/bpf/task_iter.c                             |   2 +-
 kernel/cgroup/cgroup-internal.h                    |   1 -
 kernel/events/ring_buffer.c                        |   7 +-
 kernel/fork.c                                      |   2 -
 kernel/power/snapshot.c                            |   4 +-
 kernel/vmcore_info.c                               |   1 -
 lib/interval_tree_test.c                           |   2 +-
 lib/region_alloc_benchmark.c                       |   8 +-
 lib/test_hmm.c                                     |   2 +
 mm/Kconfig                                         |  41 +-
 mm/Kconfig.debug                                   |   1 -
 mm/Makefile                                        |   3 +-
 mm/alloc_tag.c                                     |   2 +-
 drivers/char/mem.c => mm/char-mem.c                |  21 +-
 mm/cma.h                                           |  23 +-
 mm/compaction.c                                    |   9 +-
 mm/damon/core.c                                    | 375 ++++++++---
 mm/damon/lru_sort.c                                |  12 +-
 mm/damon/ops-common.c                              | 195 +++++-
 mm/damon/ops-common.h                              |  12 +
 mm/damon/paddr.c                                   |  79 ++-
 mm/damon/reclaim.c                                 |   8 -
 mm/damon/sysfs-schemes.c                           |  51 +-
 mm/damon/sysfs.c                                   | 364 ++++++++++-
 mm/damon/tests/core-kunit.h                        | 685 +++++++++++++++++++-
 mm/damon/vaddr.c                                   | 299 +++++++--
 mm/debug.c                                         |   4 -
 mm/execmem.c                                       | 148 +++--
 mm/filemap.c                                       |  34 +-
 mm/folio.c                                         |  19 +-
 mm/gup.c                                           | 192 +++---
 mm/gup_test.c                                      |  11 +-
 mm/huge_memory.c                                   | 688 +++++++++++----------
 mm/hugetlb.c                                       | 210 ++++---
 mm/hugetlb_cgroup.c                                |  33 +
 mm/hugetlb_sysfs.c                                 |  10 +-
 mm/hugetlb_vmemmap.c                               | 130 +---
 mm/hugetlb_vmemmap.h                               |  13 +-
 mm/init-mm.c                                       |   2 -
 mm/internal.h                                      |  51 +-
 mm/khugepaged.c                                    |  55 +-
 mm/kmemleak.c                                      |  72 ++-
 mm/ksm.c                                           |   7 +-
 mm/list_lru.c                                      |   9 +-
 mm/madvise.c                                       |  21 +-
 mm/memcontrol-v1.c                                 | 392 +-----------
 mm/memcontrol-v1.h                                 |  23 +-
 mm/memcontrol.c                                    | 528 +++++++++++-----
 mm/memory-failure.c                                |  29 +-
 mm/memory-tiers.c                                  |   7 +-
 mm/memory.c                                        | 106 ++--
 mm/memory_hotplug.c                                |  67 +-
 mm/mempolicy.c                                     | 186 +++---
 mm/migrate.c                                       |   9 +-
 mm/migrate_device.c                                |   6 +-
 mm/mincore.c                                       |  31 +-
 mm/mm_init.c                                       | 155 +++--
 mm/mm_init.h                                       |   1 +
 mm/mmap_lock.c                                     |  61 +-
 mm/mmu_gather.c                                    |  30 +-
 mm/nommu.c                                         |   6 +-
 mm/oom_kill.c                                      |  15 +-
 mm/page-writeback.c                                |   2 +-
 mm/page_alloc.c                                    | 121 ++--
 mm/page_counter.c                                  |  41 +-
 mm/page_io.c                                       |  57 +-
 mm/page_isolation.c                                |  40 +-
 mm/page_owner.c                                    |   6 +-
 mm/page_table_check.c                              |   6 +-
 mm/page_vma_mapped.c                               |   7 +
 mm/pagewalk.c                                      |   2 -
 mm/percpu.c                                        |   9 +-
 mm/pgtable-generic.c                               |  35 +-
 mm/rmap.c                                          |  11 +-
 mm/secretmem.c                                     |   8 +-
 mm/shmem.c                                         | 409 +++++++++---
 mm/sparse-vmemmap.c                                | 383 ++++++------
 mm/sparse.c                                        |  92 +--
 mm/sparse.h                                        |  13 +
 mm/swap.h                                          |  17 +-
 mm/swap_state.c                                    |  82 ++-
 mm/swapfile.c                                      | 149 +++--
 mm/userfaultfd.c                                   |  65 +-
 mm/vma.c                                           |  39 +-
 mm/vma.h                                           |   3 -
 mm/vmalloc.c                                       | 103 +--
 mm/vmalloc.h                                       |   2 +-
 mm/vmpressure.c                                    |   3 -
 mm/vmscan.c                                        | 614 +++++++++++-------
 mm/vmstat.c                                        |  17 +-
 mm/workingset.c                                    |   5 +-
 mm/zpdesc.h                                        |   2 +-
 mm/zsmalloc.c                                      | 101 +--
 mm/zswap.c                                         | 361 ++++++-----
 net/ipv4/tcp.c                                     |  31 +-
 rust/kernel/mm.rs                                  |  58 +-
 samples/damon/mtier.c                              |   8 +-
 samples/damon/prcl.c                               |   5 +-
 samples/damon/wsse.c                               |   5 +-
 scripts/gdb/linux/mm.py                            |  14 +-
 tools/include/linux/compiler.h                     |   5 +
 tools/include/linux/mm.h                           |   4 -
 tools/lib/mm/file_utils.c                          | 106 ++++
 tools/lib/mm/file_utils.h                          |  13 +
 .../selftests => lib}/mm/hugepage_settings.c       | 188 +++++-
 .../selftests => lib}/mm/hugepage_settings.h       |  12 +
 tools/mm/.gitignore                                |   1 +
 tools/mm/Makefile                                  |  11 +-
 .../selftests/mm/gup_test.c => mm/gup_bench.c}     | 190 +++---
 tools/mm/page-types.c                              |   2 -
 tools/mm/page_owner_sort.c                         | 134 +++-
 tools/sched_ext/include/scx/common.bpf.h           |   2 -
 tools/testing/radix-tree/idr-test.c                |  20 +-
 tools/testing/radix-tree/maple.c                   |  12 +-
 tools/testing/selftests/cgroup/test_zswap.c        |  26 +-
 tools/testing/selftests/damon/.gitignore           |   1 +
 tools/testing/selftests/damon/_damon_sysfs.py      | 161 ++++-
 tools/testing/selftests/damon/damon_nr_regions.py  |   3 +
 .../selftests/damon/damos_apply_interval.py        |   3 +
 tools/testing/selftests/damon/damos_quota.py       |   3 +
 tools/testing/selftests/damon/damos_quota_goal.py  |   3 +
 .../testing/selftests/damon/damos_tried_regions.py |   3 +
 .../selftests/damon/drgn_dump_damon_status.py      |  32 +
 tools/testing/selftests/damon/sysfs.py             |  39 +-
 tools/testing/selftests/damon/sysfs.sh             |  28 +
 .../selftests/damon/sysfs_memcg_path_leak.sh       |   7 +
 .../selftests/damon/sysfs_no_op_commit_break.py    |  35 +-
 .../sysfs_update_schemes_tried_regions_hang.py     |   3 +
 ..._update_schemes_tried_regions_wss_estimation.py |   3 +
 tools/testing/selftests/mm/.gitignore              |   2 +
 tools/testing/selftests/mm/Makefile                |  21 +-
 tools/testing/selftests/mm/compaction_test.c       |   2 +-
 tools/testing/selftests/mm/cow.c                   |   1 -
 tools/testing/selftests/mm/folio_order_check.c     | 122 ++++
 tools/testing/selftests/mm/folio_split_race_test.c |   3 -
 tools/testing/selftests/mm/guard-regions.c         |  15 +-
 tools/testing/selftests/mm/gup.c                   | 262 ++++++++
 tools/testing/selftests/mm/gup_longterm.c          |   1 -
 tools/testing/selftests/mm/hmm-tests.c             |   7 +-
 tools/testing/selftests/mm/hugetlb-madvise.c       |   1 -
 tools/testing/selftests/mm/hugetlb-mmap.c          |   1 -
 tools/testing/selftests/mm/hugetlb-mremap.c        |   1 -
 tools/testing/selftests/mm/hugetlb-shm.c           |   1 -
 tools/testing/selftests/mm/hugetlb-soft-offline.c  |  59 +-
 tools/testing/selftests/mm/hugetlb_dio.c           |   1 -
 .../selftests/mm/hugetlb_fault_after_madv.c        |   1 -
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c   | 142 ++++-
 tools/testing/selftests/mm/khugepaged.c            | 525 ++++++++++++++--
 tools/testing/selftests/mm/khugepaged_race.c       | 538 ++++++++++++++++
 tools/testing/selftests/mm/khugepaged_sync_check.c | 179 ++++++
 tools/testing/selftests/mm/ksm_tests.c             |   1 -
 tools/testing/selftests/mm/memfd_secret.c          |   3 +-
 tools/testing/selftests/mm/memory-failure.c        | 114 +++-
 tools/testing/selftests/mm/merge.c                 |  95 +++
 tools/testing/selftests/mm/migration.c             |   3 +-
 tools/testing/selftests/mm/mlock-random-test.c     |   1 -
 tools/testing/selftests/mm/mremap_test.c           |  44 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  95 +--
 tools/testing/selftests/mm/pkey-helpers.h          |   7 -
 tools/testing/selftests/mm/pkey_sighandler_tests.c |   4 +-
 tools/testing/selftests/mm/prctl_thp_disable.c     |   1 -
 tools/testing/selftests/mm/protection_keys.c       |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh          |  90 ++-
 tools/testing/selftests/mm/soft-dirty.c            |   1 -
 tools/testing/selftests/mm/split_huge_page_test.c  |  71 +--
 tools/testing/selftests/mm/thuge-gen.c             |   1 -
 tools/testing/selftests/mm/transhuge-stress.c      |   1 -
 tools/testing/selftests/mm/uffd-common.h           |   1 -
 tools/testing/selftests/mm/uffd-wp-mremap.c        |   4 +-
 tools/testing/selftests/mm/va_high_addr_switch.c   |   1 -
 tools/testing/selftests/mm/vm_util.c               | 267 +++++---
 tools/testing/selftests/mm/vm_util.h               |  18 +-
 tools/testing/selftests/proc/proc-maps-race.c      | 186 +++++-
 .../selftests/proc/proc-self-map-files-001.c       |   2 +-
 .../selftests/proc/proc-self-map-files-002.c       |   2 +-
 tools/testing/vma/include/dup.h                    |  15 +-
 tools/testing/vma/shared.c                         |   9 +
 tools/testing/vma/tests/mmap.c                     | 105 ++++
 tools/testing/vma/vma_internal.h                   |   1 -
 358 files changed, 10971 insertions(+), 5984 deletions(-)
 create mode 100644 Documentation/mm/kernel-page-tables.rst
 create mode 100644 include/linux/vmemmap-optimization.h
 rename drivers/char/mem.c => mm/char-mem.c (97%)
 create mode 100644 tools/lib/mm/file_utils.c
 create mode 100644 tools/lib/mm/file_utils.h
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.c (76%)
 rename tools/{testing/selftests => lib}/mm/hugepage_settings.h (90%)
 rename tools/{testing/selftests/mm/gup_test.c => mm/gup_bench.c} (50%)
 create mode 100644 tools/testing/selftests/mm/folio_order_check.c
 create mode 100644 tools/testing/selftests/mm/gup.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_race.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c

