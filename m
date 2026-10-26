Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053282;
	b=1E5D7UllumOTYrYsO7YMaawkoX7yTjdN+5qpjOv9kpy2tzYG9kUH1RthRsmLRpDCqHum
	 NbQ2VEfUvo98lLcLz2lr+YxB0u4itjm6AmFx3/P93/kamhyKF7PuKvdqcLUu9MWWCogUZ
	 2wi0cvNo/wWvpKFULoKOexqLNChZJvEucWteUWH5ggW5HVXb8a1xo/6YjUWrVFiAVdzZ0
	 nJvRMuG0NXVG8wEJ0HhydNbNNrsygyZEzVaWVih0W5TSYfsoJ4ip4bpQAlp25YFd5G0kZ
	 Z4cBOXKrDtYjzvLd1vJCjrnhiS2O2S0R7UaC1filclDi7IXz9Fh1pgCKQPqdv6LdKDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053282;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:X-Mailer:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=N68yWgo37jRV2hFvBdyqviARv9Ell1fw+6b+7Wq4vSw=;
	b=GukRIxGR/b/sXBCciguCGqZ1XGwhNTPaFDwjTZOs7156UaNrOv2NgRLAd0ExnYNUoKR0
	 Miv2x5LAOtqiZG7fiQpbqUnD3irn+ObE+9MkgvUZiImGial5ZkTkR0B/Fp/PGD+DxWw+f
	 ZEWg8DubGmM0km0aTUh0IgqJS+7hUpgMJxcNWbSueWSinO4VaagP2cohL6GjA6906hs7U
	 Ktp3N8Ojh3iZp9ciEzmtQWuiA9xwYfpaAZdtHqOejiF6Wc9Utr22NUCghtdNaj1pbmlZQ
	 QeOuGv3B7K5iXrbQzmt3dy20MiIMG++tU+Z11Mpj7mfKDzs5Zaz6BXQLa3pD2unZ90A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Kf7GcXfm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D2E606A31D;
	Mon, 26 Oct 2026 22:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Kf7GcXfm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A40D1F01825;
	Mon, 26 Oct 2026 22:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793053281;
	bh=N68yWgo37jRV2hFvBdyqviARv9Ell1fw+6b+7Wq4vSw=;
	h=Date:From:To:Cc:Subject;
	b=Kf7GcXfmxJFGKYAE3tBb/36jSsYpvV6WfTcOEl4nx3VdpKgAgafVBhw46tUBaFJHu
	 OW04oafS1f4XpsHdmJLsLfkc2lZ2DyKWgACSP8eDUfDRdl71kCMHzA635DOu7MZgp4
	 FRVtbaOkvHqtop1ahcRFSbEEoTbhMg/eZkcG3fuw=
Date: Mon, 26 Oct 2026 15:21:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] Additional MM updates for 7.4-rc1
Message-Id: <20261026152120.c6ed2222b64943914563232f@linux-foundation.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this second and final batch of MM updates for the
upcoming -rc cycle, thanks.


I'm seeing two conflicts at this time:

drivers/video/fbdev/ssd1307fb.c, vs fbdev tree:
https://lore.kernel.org/as5bwyKpGQaBZ3CO@sirena.org.uk

fs/coredump.c, vs fs-next tree:
https://lore.kernel.org/aqv9s5QlajVW6i3T@sirena.org.uk


Possible future merge issues and their linux-next resolutions are:

arch/riscv/Kconfig, vs riscv tree:
https://lore.kernel.org/akzo2N-H1mm4U7kw@sirena.org.uk

mm/hugetlb.c
mm/mm_init.c, vs liveupdate tree:
https://lore.kernel.org/amjYWetl6_WVyumg@sirena.org.uk

drivers/misc/sgi-xp/xpc_uv.c, vs char-misc tree:
https://lore.kernel.org/anSSANY5zZu4kytE@sirena.org.uk

fs/f2fs/f2fs.h, vs fs-next tree:
https://lore.kernel.org/aqv9gg4J1n0sB0GU@sirena.org.uk

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

mm/sparse-vmemmap.c, vs memblock/for-next tree:
https://lore.kernel.org/836fd90a-4417-4457-97bd-e540f41de597@kernel.org



The following changes since commit 2967f3ccdb5fae956f1b085370ec292bab5c7e25:

  mm: shmem: assign a lock class to the unused huge shrinklist (2026-10-12 =
21:29:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026=
-10-25-19-27

for you to fetch changes up to 183895979c441e52dbd651b388553b09eaa35cfa:

  mm: multi-gen LRU: fix NULL lruvec->pgdat deref with memcg disabled on cm=
dline (2026-10-24 01:56:43 -0700)

----------------------------------------------------------------
mm.git review status for linus..mm-stable

Everything:

Total patches:       213
Fixes: tags:         69
cc:stable patches:   43
Reviews/patch:       2.04
Reviewed rate:       86%

Excluding DAMON:

Total patches:       192
Fixes: tags:         63
cc:stable patches:   39
Reviews/patch:       2.18
Reviewed rate:       89%

Excluding DAMON and selftests:

Total patches:       182
Fixes: tags:         57
cc:stable patches:   39
Reviews/patch:       2.23
Reviewed rate:       89%

Summary of series in this merge:

- "mm: make VMA flag semantics explicit, eliminate VM_SPECIAL"
  (Lorenzo Stoakes (ARM)):

  Replace VM_SPECIAL with helpers describing mapping ownership and
  behavior.  Enforce the mmap flag rules and convert affected drivers,
  removing ambiguous tests shared by driver mappings and ordinary memory.

- "support kselftest on nommu platform" (Hajime Tazaki):

  Add opt-in mmap and mremap tests for NOMMU systems.  Teach the runner to
  avoid its fork-dependent timeout command and document the build and
  runtime requirements.

- "mm/collapse: separate a collapse from its callers"
  (Kiryl Shutsemau (Meta)):

  Separate huge-page collapse from caller policy.  Replace khugepaged
  identity checks with explicit permissions, and separate scanning from
  collapse with the mmap_lock drop in one place.

- "mm: implement and use vma_has_anon_rmap(), silence KCSAN"
  (Lorenzo Stoakes (ARM)):

  Provide a common helper for testing whether a VMA has anonymous reverse
  mappings.  Document the locking rules, annotate intentional concurrent
  reads for KCSAN, and convert the core MM callers.

- "mm/sparse: remove SECTION_MARKED_PRESENT and further cleanups"
  (David Hildenbrand (Arm)):

  Remove SECTION_MARKED_PRESENT in favor of the early-section flag.
  Simplify sparse memory initialization, section metadata handling and
  related PFN validity checks.

- "sh: remove NUMA and SPARSEMEM support" (Mike Rapoport (Microsoft)):

  Remove SuperH NUMA and SPARSEMEM support.  The extra memory banks have
  been unusable since the NO_BOOTMEM conversion, leaving only the code and
  data overhead.

- "mm: Unify device DAX and HugeTLB vmemmap population paths"
  (Muchun Song):

  Unify the generic device DAX and HugeTLB vmemmap population paths and
  shared tail-page handling.  Remove the duplicate DAX machinery while
  retaining the powerpc radix implementation.

- "kselftest: mm: fix some failure of split_huge_page_test" (Yeoreum Yun):

  Fix huge-page split tests racing with khugepaged recollapse.  Use pagemap
  and page flags instead of VMA-boundary assumptions which fail when glibc
  has already enabled THP.

- "memcg: move memcgid refcount to objcg to unpin dying memcgs"
  (Bingfang Guo):

  Let dying memcgs be freed while swapped-out shmem still holds their IDs.
  Move ID references to reparentable objcgs, with the necessary swap
  accounting and RCU lifetime changes.

- "mm/truncate: fix data loss when truncating straddling large folios"
  (Zhang Yi):

  Preserve out-of-range data when truncating straddling large folios.  Fix
  a lookup race and split-failure handling, and handle minimum folio orders
  for the forthcoming ext4 iomap buffered I/O path.

- "mm/damon: introduce damos quota goal target metric complement flag"
  (SJ Park):

  Let DAMOS quota goals use a metric's complement, so utilization can also
  express free-memory goals without adding separate metrics.  Add the sysfs
  interface, documentation and tests.

- "arm64/mm: Standardize printing for pgtable entries" (Anshuman Khandual):

  Use the generic formatter for arm64 page-table entries, ready for future
  wider entries.  Move the safe-PTE-update check out of the header to avoid
  an include cycle.

- "mm: kmsan: fix iounmap metadata teardown" (Dima Koziuk):

  Fix KMSAN metadata leaks on iounmap and failed ioremap allocations.  Free
  backing pages before removing their mappings, and share the teardown with
  partial-allocation cleanup.

- "mm/damon/core: preserve quota state when constructing schemes"
  (Karl Mehltretter):

  Preserve running DAMOS quota state while validating parameter updates.
  Even rejected updates could reset accounting and exceed the quota window;
  add tests for both accepted and rejected updates.

- "mm/vmalloc: fix vmalloc_dump_obj VA lookup" (Ye Liu):

  Fix vmalloc_dump_obj() lookups for last-page addresses and allocations
  spanning vmap zones.  These allocations were being missed in diagnostic
  output.

- "mm: various (urgent?) fixes" (David Hildenbrand (Arm)):

  Fix mmap charge leaks and hugetlb use-after-free, wrong-address
  unmapping, stuck locks and endless faults.  Also preserve reservations on
  failed mremap and handle stale userfaultfd bits.

- "maple_tree: fix maple_range_64 crashes in RCU mode" (Dimitris Charisis):

  Fix pointer and metadata confusion during RCU destruction of
  maple_range_64 nodes, avoiding double frees and invalid accesses.  Add a
  regression test; no in-tree user currently uses this combination.

- "mm: fix hugetlb NR_HUGETLB accounting on folio migration" (Hongfu Li):

  Fix hugetlb migration and preallocation accounting so /proc/vmstat
  retains the correct count and memory.numa_stat follows the folio to its
  new node.

- "mm/damon: fix a minor bug, clean code, and add a test" (SJ Park):

  Fix 32-bit DAMON age overflow which made old regions look young.  Share
  hugetlb folio acquisition code and add a regression test for the
  previously fixed last-region skipping bug.

- "mm/damon/core: cleanup code, reduce stack usage, and add kunit"
  (SJ Park):

  Reduce kdamond stack usage and remove unused enums.  Add deterministic
  PSI quota-goal tests which do not depend on the machine's current memory
  pressure.

- "mm/damon: fix the temporal goal tuner's size quota conversion"
  (Donggeun Yoo):

  Bound the temporal tuner's quota conversion to prevent overflow and zero
  effective quotas, which could stop schemes making progress.  Add boundary
  tests.

- "Don't use GFP_DMA when calling dma_alloc_coherent" (Baoquan He):

  Remove redundant GFP_DMA flags from coherent DMA allocation calls.  The
  DMA API already selects the zone from device limits and ignores the
  caller's flag.

- "kselftest: mm: fix intermittent failure khugepaged test" (Yeoreum Yun):

  Propagate child-process failures in the khugepaged tests and prevent
  background collapse from racing their checks.  This removes false passes
  and intermittent failures.

- "MAINTAINERS: cover all hugetlb headers under HUGETLB SUBSYSTEM"
  (Enze Li):

  Cover all hugetlb headers in MAINTAINERS so get_maintainer.pl finds the
  right maintainers.  Also label the closing hugetlb_cgroup.h include
  guard.

Summary of the 65 singletons in this merge:

The singletons include a few worthwhile performance fixes. Avoiding
unnecessary reverse-map tree updates gave a reported 15.9% improvement
in UnixBench's execl test on a 192-core x86 system. A reclaim retry fix
stops defrag_mode from spinning under memory.low protection; a reported
file-creation stress test ran 5.7 times faster, with far less memory
pressure. Narrower hugetlb invalidations also spare KVM guests needless
refaults: the reported Redis-in-VM P99 QPS penalty while punching holes
fell from 7.09% to 1.45%.

Several fixes prevent lost data or corrupted memory. Lazyfree huge-page
races with mremap()/munmap() could lose data or access freed memory, and
MADV_COLD could lose a concurrent write's dirty bit. Another fix
prevents stale migration entries from outliving large folios. On
filesystems with blocks smaller than a page, extending a file by 4 GiB
or more could expose bytes written past the old EOF through mmap instead
of zeroes. That is fixed, along with use-after-free races in
PAGEMAP_SCAN during process exit and in memory-cgroup accounting on
PREEMPT_RT kernels.

Other fixes stop UFFDIO_MOVE spinning forever on pinned large folios,
which could wedge other memory operations, and stop mremap() leaking
commit charges until allocations fail under strict overcommit. A further
fix keeps userfaultfd tracking intact on neighboring mappings. NUMA
binding no longer prevents long-term pins when the chosen node has only
movable memory, fixing QEMU/VFIO startup and io_uring buffer
registration failures. MGLRU also gets a fix for early-boot crashes with
memory cgroups disabled at boot, notably in small crash kernels.

----------------------------------------------------------------
Alexandre Ghiti (1):
      mm/swap: submit the last readahead batch before unplugging

Anshuman Khandual (2):
      arm64/mm: move __check_safe_pte_update()
      arm64/mm: standardize printing for pgtable entries

Arnd Bergmann (1):
      mm/damon/core: reduce stack usage further

Aveline Noir (1):
      selftests/mm: mrelease_test: fix retry limit

Baoquan He (12):
      gpu: ipu-v3: don't use GFP_DMA when calling dma_alloc_coherent()
      drm/sti: don't use GFP_DMA when calling dma_alloc_wc()
      spi: spi-ti-qspi: don't use GFP_DMA when calling dma_alloc_coherent()
      fbdev: fsl-diu-fb: don't use GFP_DMA when calling dmam_alloc_coherent=
()
      usb: gadget: lpc32xx_udc: don't use GFP_DMA when calling dma_alloc_co=
herent()
      usb: cdns3: don't use GFP_DMA when calling dma_alloc_coherent()
      media: staging: imx: don't use GFP_DMA when calling dma_alloc_coheren=
t()
      spi: atmel: don't use GFP_DMA when calling dma_alloc_coherent()
      media: imx7-media-csi: don't use GFP_DMA when calling dma_alloc_coher=
ent()
      media: nxp: imx8-isi: don't use GFP_DMA when calling dma_alloc_cohere=
nt()
      mtd: rawnand: gpmi: don't use GFP_DMA when calling dma_alloc_coherent=
()
      usb: cdns2: don't use GFP_DMA when calling dma_alloc_coherent()

Bingfang Guo (4):
      memcg: keep swap charging under RCU protection
      memcg: base swap charge accounting on memcgid root status
      memcg: manipulate memcg private ID references by ID
      memcg: move memcg private ID refcount to objcg

Cen Zhang (Microsoft) (1):
      userfaultfd: fix UFFDIO_MOVE livelock on large folio with extra refer=
ences

David Carlier (1):
      mm/swap, PM: hibernate: atomically replace hibernation pin

David Hildenbrand (Arm) (20):
      mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
      mm/hugetlb: tolerate uffd bits set without uffd for PROT_NONE PTEs
      mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp VMAs
      mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA
      mm/sparse: move mem_section init to sparse_extreme_init()
      mm/sparse: refactor sparse_sections_init()
      mm/sparse: move initialization of section metadata to sparse_metadata=
_init()
      mm/sparse: rename and cleanup sparse_init_nid()
      mm/sparse: cleanup sparse_init_one_section()
      mm/sparse: rename __highest_present_section_nr to __highest_used_sect=
ion_nr
      mm/sparse: remove pfn_in_present_section()
      mm/sparse: move __highest_used_section_nr handling
      scripts/gdb: mm.py: remove fallbacks for SECTION_HAS_MEM_MAP and SECT=
ION_IS_EARLY
      mm/sparse: remove SECTION_MARKED_PRESENT
      mm/sparse: remove flags parameter from sparse_init_one_section()
      fs/proc/page: clarify comment in get_max_dump_pfn()
      mm/memory_hotplug: drop CONFIG_HAVE_ARCH_PFN_VALID handling from pfn_=
to_online_page()
      vmcoreinfo: export SECTION_HAS_MEM_MAP
      mm: disallow ioremap'ing ordinary RAM in generic_access_phys()
      mm/userfaultfd: only allocate anon_vma in CoW mappings

Dheeraj Kumar Srivastava (1):
      mm/hugetlb: use kvmalloc_objs for hugetlb_fault_mutex_table

Dima Koziuk (2):
      mm: kmsan: fix iounmap metadata teardown
      mm: kmsan: fix ioremap error cleanup

Dimitris Charisis (2):
      maple_tree: fix maple_range_64 crashes in RCU mode
      test_maple_tree: test maple_range_64 node in RCU mode

Donggeun Yoo (2):
      mm/damon/core: prevent size quota overflow in the temporal goal tuner
      mm/damon/tests/core-kunit: test the temporal tuner's size quota conve=
rsion

Enze Li (6):
      MAINTAINERS: cover all hugetlb headers under HUGETLB SUBSYSTEM
      mm/hugetlb_cgroup: add trailing #endif comment for include guard
      docs: hugetlbpage.rst: fix typo in per-node attribute description
      mm/hugetlb: prefix log messages via pr_fmt
      mm/hugetlb: move hugetlb_sysfs_initialized into hugetlb_register_all_=
nodes()
      mm/hugetlb: use sizeof(buf) in string_get_size() calls

Gregory Price (1):
      mm/damon: use damon_get_monitor_folio() for hugetlb entries

Gregory Price (Meta) (2):
      mm/vmscan: reclaim every zone in per-node proactive reclaim
      mm/mempolicy: apply bind policies against the scoped allocation zone

Hajime Tazaki (2):
      selftests: run tests on nommu architecture
      selftests/nommu: add nommu mmap and mremap behavior tests

Harry Yoo (Meta) (1):
      mm/percpu: account full object size for percpu memory allocations

Hongfu Li (3):
      mm/hugetlb: account migration target folio in per-node NR_HUGETLB vms=
tat
      mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb =
folio
      mm/memfd: fix hugetlb reservation accounting in error paths

Hui Zhu (1):
      mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim pa=
th

Jaeyeon Lee (2):
      selftests/mm: hugetlb-read-hwpoison: add setup of HugeTLB pages
      mm/damon/ops-common: fix age_in_sec overflow on 32-bit

Jiayuan Chen (1):
      mm/swap: fix swap_cache_get_folio() returning a folio that left the s=
wap cache

Jose A. Perez de Azpillaga (1):
      selftests/mm: check MREMAP_DONTUNMAP mlock accounting

Josef Bacik (6):
      mm/vma: don't leak the commit charge on mmap failure
      mm/hugetlb: fix use-after-free of a new anon folio
      mm/hugetlb: unmap the page where the other VMA maps it
      mm/hugetlb: don't clear the resv_map of a VMA whose lock is held
      mm/hugetlb: fix endless write fault on a leftover uffd bit
      mm/hugetlb: don't leave a uffd-wp marker when zapping an RWP entry

Joshua Hahn (1):
      mm/memcontrol: publish null pointer before dropping css reference

Karl Mehltretter (3):
      mm/damon/core: preserve the quota passed to damon_new_scheme()
      mm/damon/tests/core-kunit: test preservation of quota state
      mm/damon/tests/core-kunit: test PSI goal values with explicit samples

Kiryl Shutsemau (Meta) (10):
      mm: page_alloc: make defrag_mode retries follow the promoted order
      mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
      mm/khugepaged: count collapses where khugepaged makes them
      mm/khugepaged: rename mthp_present_ptes bitmap to eligible_ptes
      mm/collapse: add collapse.h for the collapse interface
      mm/collapse: state what a collapse may do in the policy
      mm/collapse: drop the collapse_possible() wrapper
      mm/collapse: name the per-table scan reset for what it resets
      mm/collapse: call collapse_file() from collapse_single_pmd()
      mm/collapse: separate scanning a PTE table from collapsing it

Konstantin Khorenko (1):
      mm/shrinker: allocate shrinker_info_unit from a dedicated kmem_cache

Kyle Zeng (1):
      mm/page_vma_mapped: continue past nonmatching huge PMDs

Li Zhe (1):
      mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs

Liam R. Howlett (Google) (1):
      tools/testing/shared: catch a failed posix_memalign()

Liew Rui Yan (1):
      mm/damon/tests/core-kunit: add test for unconditionally skipping the =
last region

Lorenzo Stoakes (ARM) (48):
      ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
      mm/vma: fix mmap_prepare file handling, remove file_doesnt_need_get
      mm/vma: introduce and use vma_[flags_]can_merge()
      mm: consistently validate VMA state after mmap[_prepare] hooks
      mm/vma: ensure mmap_prepare doesn't set actions on a mergeable vma
      mm: make map_kernel_pages_[prepare,complete] internal and unexported
      mm/vma: tidy up map kernel pages enum values
      mm: assert mmap lock held, use new flags API in vm_insert_page[s]
      mm: add mmap action for discontiguous kernel page mapping
      docs: filesystems: update mmap_prepare docs for discontig kernel pgs
      drivers/usb/mon: update to use mmap_prepare + map kernel pages
      infiniband: update hfi1 to use remap_vmalloc_range()
      selinux: reject writable opens of policy file, drop mmap shared/write=
 check
      ALSA: pcm: use vm_insert_page() to map PCM status page
      bpf: arena: mark arena_map_mmap() mappings VM_MIXEDMAP
      mm/vma: add vma[_flags]_is_mm_managed() predicates
      mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if not mm-managed
      mm/vma: add and use vma_[flags]_is_fixed_mapping
      scsi: sg: convert mmap hook to mmap_prepare and rework
      fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP
      HSI: cmt_speech: convert mmap hook to mmap_prepare, refactor
      mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
      uprobes: remove VM_IO, set VM_MIXEDMAP for mapped kernel pages
      mm/mlock: clear VMA_LOCKED_MASK over mmap callback
      mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify
      mm/vma: enforce that mm-managed mappings may not set VMA_IO_BIT
      mm: remove VMA_IO_BIT check in vma[_flags]_is_mm_managed()
      mm: remove hugetlb_inline.h
      mm: rename is_vm_hugetlb_page() to vma_is_hugetlb()
      mm: drop some redundant checks around hugetlb VMAs
      mm/vma: introduce vma[_flags]_is_mm_backed()
      mm/madvise: update is_valid_guard_vma() to use vma_is_mm_backed()
      mm/uffd: use predicates for userfaultfd checks
      mm/madvise: use predicates for madvise(..., MADV_DOFORK)
      mm: eliminate VMA_SPECIAL_FLAGS usage when hugetlb explicitly tested
      mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
      mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
      mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
      fuse: dax: do not set VM_MIXEDMAP
      mm/huge_memory: remove vma_is_special_huge()
      mm/vma: const-ify vma_assert_stabilised() and associated functions
      mm: implement and use vma_has_anon_rmap(), silence KCSAN
      mm: update comments to refer to anon rmap rather than anon_vma
      mm/vma: don't remove VMA from rmap if pgoff unchanged
      mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
      mm/mremap: populate calculated fields in vrm state correctly
      mm/mremap: correctly uncharge accountable VMAs in error path
      mm/vma: avoid broken uffd merge on mremap

Mike Rapoport (Microsoft) (12):
      arch, mm: promote DEBUG_WX to CHECK_WX
      sh: remove CONFIG_NUMA and related configuration options
      sh: mm: remove numa.c
      sh: mm: drop allocate_pgdat()
      sh: remove setup_bootmem_node() and plat_mem_setup()
      sh: drop dead code guarded by #ifdef CONFIG_NUMA
      sh: drop include/asm/mmzone.h
      init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
      sh: init: remove call the memblock_set_node()
      sh: remove SPARSEMEM related entries from Kconfig
      sh: drop include/asm/sparsemem.h
      MAINTAINERS: add an entry for MEMORY MANAGEMENT - MEMORY MAP

Muchun Song (7):
      mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
      mm/sparse-vmemmap: support device DAX in common vmemmap path
      mm/sparse-vmemmap: drop Device DAX-specific population path
      mm/sparse-vmemmap: remove the unused ptpfn argument
      mm/sparse-vmemmap: open-code vmemmap_populate_address()
      mm/mm_init: add zone mismatch warning during page init
      mm: warn on unaligned compound zone device ranges

Ngoc Quy (1):
      fs/proc/task_mmu: pin mm_users in do_pagemap_scan()

Nickolai Zeldovich (4):
      mm/mlock: use a long for the page count in mlock_fixup()
      mm/truncate: fix the zeroing end of pagecache_isize_extended()
      resource: report a devm_request_resource() conflict under the lock
      mm: bdi: reset min_ratio after the sysfs attributes are gone

Nimrod Oren (1):
      mm: stop recalculating min_free_kbytes once set by userspace

Palla Raghunath (1):
      mm/vmalloc: do not warn on -ENOMEM from va_clip() in pcpu_get_vm_area=
s()

Park Tae-sun (1):
      selftests/mm: fix mlock2 errno handling and false PASS on ENOSYS

Pedro Falcato (1):
      mm/madvise: atomically clear the young bit on THP MADV_COLD

Pooyan Azad (1):
      zram: fix short reads from block_state

Qiliang Yuan (1):
      selftests/mm: skip hugetlb cgroup v2 tests without the needed control=
lers

Ren Tamura (1):
      tools/cgroup: sum shrinker object counts across NUMA nodes

Ricardo B. Marli=E8re (SUSE) (1):
      selftests/mm: mremap_test: Validate the preamble region before mappin=
g it

Rik van Riel (1):
      mm/page_alloc: count guard pages as free again when their buddy merges

SJ Park (10):
      mm/damon/core: introduce damos_quota_goal->complement
      mm/damon/core: add complement argument to damos_new_quota_goal()
      mm/damon/sysfs-schemes: support quota goal complement flag
      mm/damon/tests/core-kunit: test quota_goal->complement commit
      selftests/damon/sysfs.sh: test quota goal complement flag file
      Docs/mm/damon/design: document damos quota goal complement flag
      Docs/admin-guide/mm/damon/usage: update for quota goal complement file
      Docs/ABI/damon: update for quota goal metric complement sysfs file
      mm/damon/core: filter out damos address filter-split failed region
      mm/damon/core: remove unreachable damos charge_{target,addr}_from

Sasha Levin (1):
      selftests/mm: report the configuration check on stderr

Shakeel Butt (1):
      mm/page_counter: use WRITE_ONCE() for emin/elow when parent is the ro=
ot

Siddharth Chintamaneni (1):
      mm: multi-gen LRU: fix NULL lruvec->pgdat deref with memcg disabled o=
n cmdline

Usama Arif (1):
      mm: remove the unused zone->unaccepted_cleanup

Vernon Yang (1):
      mm: vmscan: don't count per-node proactive reclaim as memory pressure

Vlastimil Babka (SUSE) (1):
      MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT - MISC

Wei Yang (1):
      mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageo=
ut_pte_range()

Weilin Tong (1):
      ipc/shm: fix RSS accounting for hugetlb shared memory

Wen Jiang (1):
      mm/vmalloc: bail out early on invalid page_shift in __vmap_pages_rang=
e_noflush()

Ye Liu (2):
      mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page look=
ups
      mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup

Yeoreum Yun (6):
      kselftest: mm: return fail when child test result is fail in khugepag=
ed
      kselftest: mm: fix intermittent failure khugepaged test
      kselftest: mm: prevent random failure of huge page split for khugepag=
ed
      kselftest: mm: replace usage of /proc/self/smaps for __check_pmd_huge=
()
      kselftest: mm: integrate huge page checks
      kselftest: mm: remove check_huge_shmem()

Yunhui Cui (1):
      riscv: mm: exclude invalid THP PMDs from page table check

Zenghui Yu (Huawei) (2):
      mm/damon/api: remove unused NR_DAMOS_* enumerators
      selftests/mm: fix uffd move-pmd test crash on 64K base page systems

Zhang Yi (4):
      mm/truncate: align truncation boundaries to mapping minimum folio ord=
er
      mm/truncate: look up the end-edge straddler by index
      mm/truncate: fix data loss when splitting straddling large folios fai=
ls
      mm/truncate: clarify return value of truncate_inode_partial_folio()

Zhenghui Hao (1):
      hugetlbfs: fix stale comment in hugetlbfs_file_mmap()

Zhijian Han (1):
      mm: fix typos in various comments

Zi Yan (1):
      mm/rmap: don't discard lazyfree THPs at PMD level

 .clang-format                                      |   2 +-
 Documentation/ABI/testing/sysfs-kernel-mm-damon    |   6 +
 Documentation/admin-guide/mm/damon/usage.rst       |  15 +-
 Documentation/admin-guide/mm/hugetlbpage.rst       |   6 +-
 Documentation/admin-guide/sysctl/vm.rst            |   7 +
 Documentation/dev-tools/kselftest.rst              |  18 +
 Documentation/filesystems/mmap_prepare.rst         |  81 ++++
 Documentation/mm/damon/design.rst                  |  15 +-
 Documentation/mm/process_addrs.rst                 |  14 +-
 MAINTAINERS                                        |  23 +-
 arch/arm/Kconfig.debug                             |   2 +-
 arch/arm/configs/aspeed_g4_defconfig               |   2 +-
 arch/arm/configs/aspeed_g5_defconfig               |   2 +-
 arch/arm/configs/shmobile_defconfig                |   2 +-
 arch/arm/include/asm/ptdump.h                      |   6 +-
 arch/arm/mm/init.c                                 |   2 +-
 arch/arm64/Kconfig                                 |   2 +-
 arch/arm64/include/asm/pgtable.h                   |  49 +--
 arch/arm64/kvm/mmu.c                               |   2 +-
 arch/arm64/mm/fault.c                              |  16 +-
 arch/arm64/mm/mmu.c                                |  48 +++
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/configs/ppc64_defconfig               |   2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   3 +
 arch/powerpc/mm/book3s64/radix_tlb.c               |   6 +-
 arch/powerpc/mm/nohash/e500_hugetlbpage.c          |   2 +-
 arch/powerpc/mm/nohash/tlb.c                       |   2 +-
 arch/powerpc/mm/ptdump/ptdump.c                    |   2 +-
 arch/riscv/Kconfig                                 |   2 +-
 arch/riscv/include/asm/pgtable.h                   |   9 +-
 arch/riscv/kvm/mmu.c                               |   2 +-
 arch/riscv/mm/tlbflush.c                           |   2 +-
 arch/s390/Kconfig                                  |   2 +-
 arch/s390/configs/debug_defconfig                  |   2 +-
 arch/s390/configs/defconfig                        |   2 +-
 arch/s390/mm/dump_pagetables.c                     |   2 +-
 arch/s390/mm/gmap_helpers.c                        |   6 +-
 arch/sh/Kconfig                                    |  12 -
 arch/sh/configs/migor_defconfig                    |   1 -
 arch/sh/configs/sdk7786_defconfig                  |   1 -
 arch/sh/configs/se7722_defconfig                   |   1 -
 arch/sh/configs/shx3_defconfig                     |   1 -
 arch/sh/configs/ul2_defconfig                      |   1 -
 arch/sh/include/asm/mmu.h                          |   2 +
 arch/sh/include/asm/mmzone.h                       |  42 --
 arch/sh/include/asm/setup.h                        |   3 +
 arch/sh/include/asm/sparsemem.h                    |  12 -
 arch/sh/include/asm/topology.h                     |  13 -
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c             |   5 -
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c             |   7 -
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c             |   1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c             |   1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c             |   5 -
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c             |   7 -
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c             |   5 -
 arch/sh/kernel/cpu/sh4a/setup-shx3.c               |  18 -
 arch/sh/kernel/setup.c                             |   7 -
 arch/sh/kernel/topology.c                          |  12 -
 arch/sh/kernel/vmcore_info.c                       |   4 -
 arch/sh/mm/Kconfig                                 |  29 --
 arch/sh/mm/Makefile                                |   1 -
 arch/sh/mm/init.c                                  |  24 --
 arch/sh/mm/numa.c                                  |  53 ---
 arch/sh/mm/sram.c                                  |   3 +-
 arch/sparc/mm/init_64.c                            |   2 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/configs/x86_64_defconfig                  |   2 +-
 arch/x86/include/asm/pgtable.h                     |   6 +-
 arch/x86/kernel/uprobes.c                          |   2 +-
 arch/x86/mm/pti.c                                  |   2 +-
 drivers/base/memory.c                              |   2 +-
 drivers/block/zram/zram_drv.c                      | 102 ++---
 drivers/gpu/drm/drm_gpusvm.c                       |   5 +-
 drivers/gpu/drm/sti/sti_cursor.c                   |   4 +-
 drivers/gpu/drm/sti/sti_hqvdp.c                    |   2 +-
 drivers/gpu/ipu-v3/ipu-image-convert.c             |   2 +-
 drivers/hsi/clients/cmt_speech.c                   |  33 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |  83 ++--
 drivers/media/platform/nxp/imx7-media-csi.c        |   2 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   |   2 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   2 +-
 drivers/scsi/sg.c                                  | 115 +++---
 drivers/spi/spi-atmel.c                            |   4 +-
 drivers/spi/spi-ti-qspi.c                          |   2 +-
 drivers/staging/media/imx/imx-media-utils.c        |   2 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |   2 +-
 drivers/usb/gadget/udc/cdns2/cdns2-gadget.c        |   2 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c               |   2 +-
 drivers/usb/mon/mon_bin.c                          |  82 ++--
 drivers/video/fbdev/core/fb_defio.c                |   6 +-
 drivers/video/fbdev/fsl-diu-fb.c                   |   2 +-
 drivers/video/fbdev/ssd1307fb.c                    |   2 +
 fs/coredump.c                                      |   2 +-
 fs/fuse/dax.c                                      |   2 +-
 fs/hugetlbfs/inode.c                               |  10 +-
 fs/proc/page.c                                     |   7 +-
 fs/proc/task_mmu.c                                 |  17 +-
 include/asm-generic/tlb.h                          |   4 +-
 include/linux/cache.h                              |   1 +
 include/linux/damon.h                              |  12 +-
 include/linux/hugetlb.h                            |  42 +-
 include/linux/hugetlb_cgroup.h                     |   2 +-
 include/linux/hugetlb_inline.h                     |  28 --
 include/linux/memcontrol.h                         |  16 +-
 include/linux/mm.h                                 | 248 ++++++++++-
 include/linux/mm_types.h                           |  64 ++-
 include/linux/mmap_lock.h                          |  36 +-
 include/linux/mmzone.h                             |  46 +--
 include/linux/pagemap.h                            |   1 -
 include/linux/ptdump.h                             |   4 +-
 include/linux/rmap.h                               |   2 +-
 include/linux/swap.h                               |   2 +
 include/linux/userfaultfd_k.h                      |   1 -
 init/Kconfig                                       |   7 -
 init/main.c                                        |   2 +-
 ipc/shm.c                                          |  23 +-
 kernel/bpf/arena.c                                 |   3 +-
 kernel/configs/debug.config                        |   2 +-
 kernel/events/core.c                               |   2 +-
 kernel/events/uprobes.c                            |   4 +-
 kernel/power/user.c                                |  17 +-
 kernel/resource.c                                  |   9 +-
 kernel/sched/fair.c                                |   3 +-
 kernel/vmcore_info.c                               |   1 +
 lib/maple_tree.c                                   |  43 +-
 lib/test_maple_tree.c                              |  32 ++
 mm/Kconfig                                         |  41 ++
 mm/Kconfig.debug                                   |  39 --
 mm/backing-dev.c                                   |  15 +-
 mm/collapse.h                                      | 121 ++++++
 mm/compaction.c                                    |   2 +-
 mm/damon/core.c                                    |  88 +++-
 mm/damon/lru_sort.c                                |   5 +-
 mm/damon/ops-common.c                              |  11 +-
 mm/damon/reclaim.c                                 |   5 +-
 mm/damon/sysfs-schemes.c                           |  30 ++
 mm/damon/tests/core-kunit.h                        | 254 +++++++++++-
 mm/damon/vaddr.c                                   |  10 +-
 mm/folio.c                                         |   2 +-
 mm/gup.c                                           |   8 +-
 mm/huge_memory.c                                   |  44 +-
 mm/hugetlb.c                                       | 247 +++++++----
 mm/hugetlb_sysfs.c                                 |   5 +-
 mm/internal.h                                      |  85 ++--
 mm/interval_tree.c                                 | 101 +++++
 mm/kfence/core.c                                   |   2 +-
 mm/khugepaged.c                                    | 460 ++++++++++-------=
----
 mm/kmsan/core.c                                    |   8 +-
 mm/kmsan/hooks.c                                   |  86 ++--
 mm/ksm.c                                           |  21 +-
 mm/list_lru.c                                      |   4 +-
 mm/madvise.c                                       |  49 ++-
 mm/memcontrol-v1.c                                 |  21 +-
 mm/memcontrol-v1.h                                 |   8 +-
 mm/memcontrol.c                                    | 138 +++++--
 mm/memfd.c                                         |  31 +-
 mm/memory-failure.c                                |   2 +-
 mm/memory.c                                        | 177 ++++++--
 mm/memory_hotplug.c                                |   9 +-
 mm/mempolicy.c                                     |   4 +-
 mm/migrate.c                                       |  12 +-
 mm/migrate_device.c                                |  12 +-
 mm/mlock.c                                         |  53 +--
 mm/mm_init.c                                       |  18 +-
 mm/mmap.c                                          |   8 +-
 mm/mmap_lock.c                                     |  89 +++-
 mm/mmu_gather.c                                    |   2 +-
 mm/mprotect.c                                      |  11 +-
 mm/mremap.c                                        |  54 ++-
 mm/page_alloc.c                                    |  77 ++--
 mm/page_alloc.h                                    |   2 +
 mm/page_counter.c                                  |   4 +-
 mm/page_io.c                                       |   2 +-
 mm/page_vma_mapped.c                               |  32 +-
 mm/pagewalk.c                                      |   2 +-
 mm/percpu.c                                        |   5 +-
 mm/pgtable-generic.c                               |   2 +-
 mm/rmap.c                                          |  41 +-
 mm/shmem.c                                         |  13 +-
 mm/shrinker.c                                      |  11 +-
 mm/sparse-vmemmap.c                                | 212 +++-------
 mm/sparse.c                                        | 160 ++++---
 mm/sparse.h                                        |  19 +-
 mm/swap_state.c                                    |  20 +-
 mm/swapfile.c                                      |  63 ++-
 mm/truncate.c                                      | 134 +++---
 mm/userfaultfd.c                                   |  67 +--
 mm/util.c                                          |  51 ++-
 mm/vma.c                                           | 455 ++++++++++++-----=
---
 mm/vma.h                                           |  62 ++-
 mm/vma_internal.h                                  |   1 -
 mm/vmalloc.c                                       | 145 ++++---
 mm/vmalloc.h                                       |   1 +
 mm/vmscan.c                                        |  23 +-
 mm/workingset.c                                    |   2 +-
 samples/damon/mtier.c                              |   2 +-
 scripts/gdb/linux/mm.py                            |   8 +-
 security/selinux/selinuxfs.c                       |  11 +-
 sound/core/pcm_native.c                            |  38 +-
 sound/usb/usx2y/us122l.c                           |   2 +-
 tools/cgroup/memcg_shrinker.py                     |   2 +-
 tools/testing/selftests/damon/sysfs.sh             |   3 +
 tools/testing/selftests/kselftest/runner.sh        |  11 +-
 tools/testing/selftests/mm/Makefile                |   2 +-
 .../selftests/mm/charge_reserved_hugetlb.sh        |   8 +
 tools/testing/selftests/mm/folio_split_race_test.c |   2 +-
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c |   8 +
 .../selftests/mm/hugetlb_reparenting_test.sh       |  10 +
 tools/testing/selftests/mm/khugepaged.c            |  57 ++-
 tools/testing/selftests/mm/mlock2-tests.c          |   2 +-
 tools/testing/selftests/mm/mlock2.h                |   8 +-
 tools/testing/selftests/mm/mrelease_test.c         |   2 +-
 tools/testing/selftests/mm/mremap_dontunmap.c      |  63 ++-
 tools/testing/selftests/mm/mremap_test.c           |   6 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  16 +
 tools/testing/selftests/mm/uffd-common.c           |   4 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       |   5 +
 tools/testing/selftests/mm/vm_util.c               | 113 +++--
 tools/testing/selftests/mm/vm_util.h               |   1 -
 tools/testing/selftests/nommu/Makefile             |   7 +
 tools/testing/selftests/nommu/nommu.h              |  33 ++
 tools/testing/selftests/nommu/nommu_mmap_test.c    | 264 ++++++++++++
 tools/testing/selftests/nommu/nommu_mremap_test.c  | 356 ++++++++++++++++
 tools/testing/shared/linux.c                       |   4 +-
 tools/testing/vma/include/dup.h                    | 110 ++++-
 tools/testing/vma/include/stubs.h                  |  37 +-
 tools/testing/vma/shared.c                         |   8 +-
 tools/testing/vma/tests/merge.c                    |  10 +-
 228 files changed, 4606 insertions(+), 2415 deletions(-)
 delete mode 100644 arch/sh/include/asm/mmzone.h
 delete mode 100644 arch/sh/include/asm/sparsemem.h
 delete mode 100644 arch/sh/mm/numa.c
 delete mode 100644 include/linux/hugetlb_inline.h
 create mode 100644 mm/collapse.h
 create mode 100644 tools/testing/selftests/nommu/Makefile
 create mode 100644 tools/testing/selftests/nommu/nommu.h
 create mode 100644 tools/testing/selftests/nommu/nommu_mmap_test.c
 create mode 100644 tools/testing/selftests/nommu/nommu_mremap_test.c

