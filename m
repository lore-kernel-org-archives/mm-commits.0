Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D26533F3;
	Sun,  1 Jun 2025 22:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748815944; cv=none; b=L3mfSZNa8d30SkAVzFRkO6N7d6GQOxQamuTy8ML36pGQT3abejXB4RHNUjfLEYstyb0vFRQULyQdpVXPWGEl8Uf1gaWj5gYrB+ejrLV2yAjkv6aJXi3LWkvtQ1trcBNPpiX0bwxlSUcJQxDDmiaJWzObzuSauAoaWbUzAd7D+xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748815944; c=relaxed/simple;
	bh=fAf/q1jVkKfBy5haShMDNUDL+HSBehBjMaLT6ynyJSw=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=V9gMcupngswUFxrekockSHN2wnJwSD9QXkqZTl/MHRrgRYv7NfmcoAzAp+NEudUGKvt7RSyyqC3UhdVvWnWCiJXpKyUj0siP7jkmWeJcxtiR0EmDGBCbB5RX9/+73zM/aW2IvfKJMpKYtj+w3QCLUFn+GffFwRAJFPHXLU3EIc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qFVY1Ui1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qFVY1Ui1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF695C4CEE7;
	Sun,  1 Jun 2025 22:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748815944;
	bh=fAf/q1jVkKfBy5haShMDNUDL+HSBehBjMaLT6ynyJSw=;
	h=Date:From:To:Cc:Subject:From;
	b=qFVY1Ui1IgVDjR9BCqVwyYxH50FpCrqBoZ7VN/Ks9ZJmfQjIq7b16vvRhYtqWEy6h
	 19yyhheRsHp2qDblJdc+aQOy7uExBK+LBFfg/Q0OlE2YnnaKtmUhRus3kZTAiEWs/n
	 gsJL/9JL6cBKg0PI29PdSrx8KihDQzy5Fj9DgW3U=
Date: Sun, 1 Jun 2025 15:12:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] Additional MM updates for 6.16-rc1
Message-Id: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this second batch of MM updates for the 6.16-rcX cycle.

I'm seeing a single small conflict in mm/memcontrol.c.  Stephen's
resolution is at
https://lore.kernel.org/all/20250529111223.3987a514@canb.auug.org.au/T/#u

Thanks.


The following changes since commit c544a952ba61b1a025455098033c17e0573ab085:

  mm: pcp: increase pcp->free_count threshold to trigger free_high (2025-05-27 19:38:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-06-01-14-06

for you to fetch changes up to 0b43b8bc8ef88bb45b018b2d4853d38bfc5ce2a7:

  mm/khugepaged: clean up refcount check using folio_expected_ref_count() (2025-05-31 22:46:16 -0700)

----------------------------------------------------------------
- The 2 patch series "zram: support algorithm-specific parameters" from
  Sergey Senozhatsky adds infrastructure for passing algorithm-specific
  parameters into zram.  A single parameter `winbits' is implemented at
  this time.

- The 5 patch series "memcg: nmi-safe kmem charging" from Shakeel Butt
  makes memcg charging nmi-safe, which is required by BFP, which can
  operate in NMI context.

- The 5 patch series "Some random fixes and cleanup to shmem" from
  Kemeng Shi implements small fixes and cleanups in the shmem code.

- The 2 patch series "Skip mm selftests instead when kernel features are
  not present" from Zi Yan fixes some issues in the MM selftest code.

- The 2 patch series "mm/damon: build-enable essential DAMON components
  by default" from SeongJae Park reworks DAMON Kconfig to make it easier
  to enable CONFIG_DAMON.

- The 2 patch series "sched/numa: add statistics of numa balance task
  migration" from Libo Chen adds more info into sysfs and procfs files to
  improve visibility into the NUMA balancer's task migration activity.

- The 4 patch series "selftests/mm: cow and gup_longterm cleanups" from
  Mark Brown provides various updates to some of the MM selftests to make
  them play better with the overall containing framework.

----------------------------------------------------------------
Akinobu Mita (1):
      mm/damon/core: avoid destroyed target reference from DAMOS quota

Alice Ryhl (2):
      mm: rust: make CONFIG_MMU ifdefs more narrow
      kcov: rust: add flags for KCOV with Rust

Chen Yu (1):
      sched/numa: add statistics of numa balance task

Dan Carpenter (1):
      tools/testing: check correct variable in open_procmap()

David Hildenbrand (1):
      selftests/mm: two fixes for the pfnmap test

Enze Li (1):
      selftests/damon/_damon_sysfs: skip testcases if CONFIG_DAMON_SYSFS is disabled

Jann Horn (2):
      mmu_notifiers: remove leftover stub macros
      mm/gup: update comment explaining why gup_fast() disables IRQs

Juan Yescas (1):
      mm: add CONFIG_PAGE_BLOCK_ORDER to select page block order

Kemeng Shi (5):
      mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()
      mm: shmem: add missing shmem_unacct_size() in __shmem_file_setup()
      mm/shmem: fix potential dead loop in shmem_unuse()
      mm: shmem: only remove inode from swaplist when it's swapped page count is 0
      mm/shmem: remove unneeded xa_is_value() check in shmem_unuse_swap_entries()

Libo Chen (1):
      sched/numa: fix task swap by skipping kernel threads

Lorenzo Stoakes (1):
      tools/testing/vma: add missing function stub

Mark Brown (7):
      selftests/mm: deduplicate test logging in test_mlock_lock()
      selftests/mm: deduplicate default page size test results in thuge-gen
      selftests/mm: deduplicate test names in madv_populate
      selftests/mm: use standard ksft_finished() in cow and gup_longterm
      selftests/mm: add helper for logging test start and results
      selftests/mm: report unique test names for each cow test
      selftests/mm: fix test result reporting in gup_longterm

Matthew Wilcox (Oracle) (4):
      m68k: remove use of page->index
      mm: rename page->index to page->__folio_index
      ntfs3: use folios more in ntfs_compress_write()
      iov: remove copy_page_from_iter_atomic()

Roman Gushchin (1):
      mmu_gather: move tlb flush for VM_PFNMAP/VM_MIXEDMAP vmas into free_pgtables()

SeongJae Park (2):
      mm/damon/Kconfig: set DAMON_{VADDR,PADDR,SYSFS} default to DAMON
      mm/damon/Kconfig: enable CONFIG_DAMON by default

Sergey Senozhatsky (2):
      zram: rename ZCOMP_PARAM_NO_LEVEL
      zram: support deflate-specific params

Shakeel Butt (5):
      memcg: disable kmem charging in nmi for unsupported arch
      memcg: nmi safe memcg stats for specific archs
      memcg: add nmi-safe update for MEMCG_KMEM
      memcg: nmi-safe slab stats updates
      memcg: make memcg_rstat_updated nmi safe

Shivank Garg (2):
      mm/khugepaged: fix race with folio split/free using temporary reference
      mm/khugepaged: clean up refcount check using folio_expected_ref_count()

Wenjie Xu (1):
      hugetlb: show nr_huge_pages in report_hugepages()

Zi Yan (2):
      selftests/mm: skip guard_regions.uffd tests when uffd is not present
      selftests/mm: skip hugevm test if kernel config file is not present

 Documentation/admin-guide/cgroup-v2.rst           |   6 +
 arch/arm/mm/flush.c                               |   4 +-
 arch/m68k/mm/motorola.c                           |   3 +-
 drivers/block/zram/backend_deflate.c              |  12 +-
 drivers/block/zram/backend_lz4.c                  |   2 +-
 drivers/block/zram/backend_lz4hc.c                |   2 +-
 drivers/block/zram/backend_zstd.c                 |   2 +-
 drivers/block/zram/zcomp.h                        |   9 +-
 drivers/block/zram/zram_drv.c                     |  21 +-
 fs/ntfs3/file.c                                   |  31 +-
 include/asm-generic/tlb.h                         |  46 ++-
 include/linux/memcontrol.h                        |  10 +
 include/linux/mm.h                                |   6 +-
 include/linux/mm_types.h                          |   6 +-
 include/linux/mmu_notifier.h                      |   3 -
 include/linux/mmzone.h                            |  16 +
 include/linux/pageblock-flags.h                   |   8 +-
 include/linux/sched.h                             |   4 +
 include/linux/uio.h                               |  10 +-
 include/linux/vm_event_item.h                     |   2 +
 init/Kconfig                                      |  14 +
 kernel/futex/core.c                               |   2 +-
 kernel/sched/core.c                               |   9 +-
 kernel/sched/debug.c                              |   4 +
 kernel/sched/fair.c                               |   3 +-
 lib/iov_iter.c                                    |  29 +-
 mm/Kconfig                                        |  34 +++
 mm/damon/Kconfig                                  |   4 +
 mm/damon/core.c                                   |   8 +
 mm/filemap.c                                      |   4 +-
 mm/gup.c                                          |   2 +-
 mm/hugetlb.c                                      |   2 +-
 mm/khugepaged.c                                   |  35 ++-
 mm/memcontrol.c                                   | 127 +++++++-
 mm/memory.c                                       |   6 +-
 mm/mm_init.c                                      |   2 +-
 mm/mmu_gather.c                                   |   1 +
 mm/page-writeback.c                               |   6 +-
 mm/shmem.c                                        |  23 +-
 mm/truncate.c                                     |   2 +-
 mm/vmstat.c                                       |   2 +
 mm/zpdesc.h                                       |   4 +-
 rust/Makefile                                     |   1 +
 rust/kernel/mm.rs                                 |  56 +---
 rust/kernel/mm/mmput_async.rs                     |  68 +++++
 scripts/Makefile.kcov                             |   6 +
 scripts/Makefile.lib                              |   3 +
 tools/testing/selftests/damon/_damon_sysfs.py     |   4 +
 tools/testing/selftests/mm/cow.c                  | 340 ++++++++++++++--------
 tools/testing/selftests/mm/guard-regions.c        |  17 +-
 tools/testing/selftests/mm/gup_longterm.c         | 158 ++++++----
 tools/testing/selftests/mm/madv_populate.c        |  18 +-
 tools/testing/selftests/mm/mlock2-tests.c         |   2 +-
 tools/testing/selftests/mm/pfnmap.c               |  61 +++-
 tools/testing/selftests/mm/thuge-gen.c            |   4 +-
 tools/testing/selftests/mm/va_high_addr_switch.sh |  26 +-
 tools/testing/selftests/mm/vm_util.c              |   2 +-
 tools/testing/selftests/mm/vm_util.h              |  20 ++
 tools/testing/vma/vma_internal.h                  |   5 +
 59 files changed, 909 insertions(+), 408 deletions(-)
 create mode 100644 rust/kernel/mm/mmput_async.rs

