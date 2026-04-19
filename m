Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67447344DB7;
	Sun, 19 Apr 2026 05:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776577114; cv=none; b=XUBB1OEa//iWgq3o3iricteFzPdS4OulbCiRDE129ckFfe3HeflL1Q4BaV26GKLYVaWcAA3Mik0LmRG/1PdtnTgLLrpVBOdVHbZEAzThf14qDmc4QS+6M5L/VP08fXUscP8rBooEwiqi4dvuVBfVG44SqfPrdVIDsuaC1D4zlpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776577114; c=relaxed/simple;
	bh=0NwBsdA7LZmndbXYN/qCpSAJZ3G6zzFVkjh5OzglQWs=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=U/RVD2sv+yyZ1MZsWB7MtdsUMBM38g3anXYP9xnX7r71hHrFuovxhxKWgWi5ws4IkbzloVuGIW9YI48RtsJYWmQNKI+eGd2rNdzDumVi2f/QrNfajOEAt85X6PnWW5G6SrQzvZ3LBw8a27lwsxStgaerkOh0Szg8bFEClElh+rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YB74JiBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YB74JiBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7D3C2BCAF;
	Sun, 19 Apr 2026 05:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776577114;
	bh=0NwBsdA7LZmndbXYN/qCpSAJZ3G6zzFVkjh5OzglQWs=;
	h=Date:From:To:Cc:Subject:From;
	b=YB74JiBGVkfvd1XTrJL5caoJu7NNzVg0EoNiNouiunf4dpkV5+XoB0P+FvjsLX5Pe
	 X2fWjBZxL7WYt6qrsjUwyajQ331xWMB6eayB6TLYyJqpYTfFLRjOBeNsqfXVYNGxVm
	 ohbHnU8O+564e9lr1X+hWYB/T+xkJlGwpzU/Cs0E=
Date: Sat, 18 Apr 2026 22:38:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] Additional MM updates for 7.1-rc1
Message-Id: <20260418223823.b45ef6a83267fa886d182ed7@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this second batch of MM updates for the current
merge window, thanks.

I'm seeing no conflicts against mainline at this time.  If some do pop
up, they will hopefully be addressed in the first-round merge at

	https://lore.kernel.org/20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org


The following changes since commit 3bac01168982ec3e3bf87efdc1807c7933590a85:

  mm: fix deferred split queue races during migration (2026-04-05 13:53:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-04-18-02-14

for you to fetch changes up to 0b5e8d7999076ac3c490fc18376a404e2626abff:

  MAINTAINERS: add page cache reviewer (2026-04-18 00:10:56 -0700)

----------------------------------------------------------------
mm.git review status for linus..mm-stable

Everything:

Total patches:       121
Reviews/patch:       2.11
Reviewed rate:       90%

Excluding DAMON:

Total patches:       113
Reviews/patch:       2.25
Reviewed rate:       96%

- The 33 patch series "Eliminate Dying Memory Cgroup" from Qi Zheng and
  Muchun Song addresses the longstanding "dying memcg problem".  A
  situation wherein a no-longer-used memory control group will hang around
  for an extended period pointlessly consuming memory.  The [0/N]
  changelog has a good overview of this work.

- The 3 patch series "fix unexpected type conversions and potential
  overflows" from Qi Zheng fixes a couple of potential 32-bit/64-bit
  issues which were identified during review of the "Eliminate Dying
  Memory Cgroup" series.

- The 6 patch series "kho: history: track previous kernel version and
  kexec boot count" from Breno Leitao uses Kexec Handover (KHO) to pass
  the previous kernel's version string and the number of kexec reboots
  since the last cold boot to the next kernel, and prints it at boot time.

- The 4 patch series "liveupdate: prevent double preservation" from
  Pasha Tatashin teaches LUO to avoid managing the same file across
  different active sessions.

- The 10 patch series "liveupdate: Fix module unloading and unregister
  API" from Pasha Tatashin addresses an issue with how LUO handles module
  reference counting and unregistration during module unloading.

- The 2 patch series "zswap pool per-CPU acomp_ctx simplifications" from
  Kanchana Sridhar simplifies and cleans up the zswap crypto compression
  handling and improves the lifecycle management of zswap pool's per-CPU
  acomp_ctx resources.

- The 2 patch series "mm/damon/core: fix damon_call()/damos_walk() vs
  kdmond exit race" from SeongJae Park addresses unlikely but possible
  leaks and deadlocks in damon_call() and damon_walk().

- The 2 patch series "mm/damon/core: validate damos_quota_goal->nid"
  from SeongJae Park fixes a couple of root-only wild pointer
  dereferences.

- The 2 patch series "Docs/admin-guide/mm/damon: warn commit_inputs vs
  other params race" from SeongJae Park updates the DAMON documentation to
  warn operators about potential races which can occur if the
  commit_inputs parameter is altered at the wrong time.

- The 3 patch series "Minor hmm_test fixes and cleanups" from Alistair
  Popple implements two bugfixes a cleanup for the HMM kernel selftests.

- The 6 patch series "Modify memfd_luo code" from Chenghao Duan provides
  cleanups, simplifications and speedups in the memfd_lou code.

- The 4 patch series "mm, kvm: allow uffd support in guest_memfd" from
  Mike Rapoport enables support for userfaultfd in guest_memfd.

- The 6 patch series "selftests/mm: skip several tests when thp is not
  available" from Chunyu Hu fixes several issues in the selftests code
  which were causing breakage when the tests were run on CONFIG_THP=n
  kernels.

- The 2 patch series "mm/mprotect: micro-optimization work" from Pedro
  Falcato implements a couple of nice speedups for mprotect().

- The 3 patch series "MAINTAINERS: update KHO and LIVE UPDATE entries"
  from Pratyush Yadav reflects upcoming changes in the maintenance of KHO,
  LUO, memfd_luo, kexec, crash, kdump and probably other kexec-based
  things - they are being moved out of mm.git and into a new git tree.

----------------------------------------------------------------
Alistair Popple (3):
      lib: test_hmm: evict device pages on file close to avoid use-after-free
      selftests/mm: hmm-tests: don't hardcode THP size to 2MB
      lib: test_hmm: implement a device release method

Andrew Stellman (1):
      zram: reject unrecognized type= values in recompress_store()

Arnd Bergmann (1):
      mm/vmscan: avoid false-positive -Wuninitialized warning

Baolin Wang (1):
      mm: vmscan: fix dirty folios throttling on cgroup v1 for MGLRU

Breno Leitao (8):
      mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build option
      kho: add size parameter to kho_add_subtree()
      kho: rename fdt parameter to blob in kho_add/remove_subtree()
      kho: persist blob size in KHO FDT
      kho: fix kho_in_debugfs_init() to handle non-FDT blobs
      kho: kexec-metadata: track previous kernel chain
      kho: document kexec-metadata tracking feature
      mm/vmstat: fix vmstat_shepherd double-scheduling vmstat_update

Cao Ruichuang (1):
      selftests: mm: skip charge_reserved_hugetlb without killall

Chenghao Duan (6):
      mm/memfd: use folio_nr_pages() for shmem inode accounting
      mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
      mm/memfd_luo: remove unnecessary memset in zero-size memfd path
      mm/memfd_luo: use i_size_write() to set inode size during retrieve
      mm/memfd_luo: fix physical address conversion in put_folios cleanup
      mm/memfd_luo: remove folio from page cache when accounting fails

Chunyu Hu (6):
      selftests/mm/guard-regions: skip collapse test when thp not enabled
      selftests/mm: soft-dirty: skip two tests when thp is not available
      selftests/mm: move write_file helper to vm_util
      selftests/mm/vm_util: robust write_file()
      selftests/mm: split_huge_page_test: skip the test when thp is not available
      selftests/mm: transhuge_stress: skip the test when thp not available

Dave Young (1):
      MAINTAINERS: update Dave's kdump reviewer email address

David Carlier (1):
      mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()

Davidlohr Bueso (1):
      mm/migrate_device: remove dead migration entry check in migrate_vma_collect_huge_pmd()

Denis M. Karpov (1):
      userfaultfd: allow registration of ranges below mmap_min_addr

Hao Ge (1):
      mm/alloc_tag: clear codetag for pages allocated before page_ext initialization

Jackie Liu (2):
      mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()
      mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()

Jan Kara (1):
      MAINTAINERS: add page cache reviewer

Kanchana P. Sridhar (2):
      mm: zswap: remove redundant checks in zswap_cpu_comp_dead()
      mm: zswap: tie per-CPU acomp_ctx lifetime to the pool

Kevin Brodsky (1):
      docs: proc: document ProtectionKey in smaps

Li Wang (1):
      selftests/mm: skip hugetlb_dio tests when DIO alignment is incompatible

Lorenzo Stoakes (1):
      mm/vma: remove __vma_check_mmap_hook()

Lorenzo Stoakes (Oracle) (2):
      MAINTAINERS: update MGLRU entry to reflect current status
      tools/testing/selftests: add merge test for partial msealed range

Mike Rapoport (Microsoft) (11):
      userfaultfd: introduce mfill_copy_folio_locked() helper
      userfaultfd: introduce struct mfill_state
      userfaultfd: introduce mfill_establish_pmd() helper
      userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
      userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
      userfaultfd: move vma_can_userfault out of line
      userfaultfd: introduce vm_uffd_ops
      shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE
      userfaultfd: introduce vm_uffd_ops->alloc_folio()
      shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
      userfaultfd: mfill_atomic(): remove retry logic

Muchun Song (24):
      mm: memcontrol: remove dead code of checking parent memory cgroup
      mm: workingset: use folio_lruvec() in workingset_refault()
      mm: rename unlock_page_lruvec_irq and its variants
      mm: vmscan: refactor move_folios_to_lru()
      mm: memcontrol: allocate object cgroup for non-kmem case
      mm: memcontrol: return root object cgroup for root memory cgroup
      mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
      buffer: prevent memory cgroup release in folio_alloc_buffers()
      writeback: prevent memory cgroup release in writeback module
      mm: memcontrol: prevent memory cgroup release in count_memcg_folio_events()
      mm: page_io: prevent memory cgroup release in page_io module
      mm: migrate: prevent memory cgroup release in folio_migrate_mapping()
      mm: mglru: prevent memory cgroup release in mglru
      mm: memcontrol: prevent memory cgroup release in mem_cgroup_swap_full()
      mm: workingset: prevent memory cgroup release in lru_gen_eviction()
      mm: workingset: prevent lruvec release in workingset_refault()
      mm: zswap: prevent lruvec release in zswap_folio_swapin()
      mm: swap: prevent lruvec release in lru_gen_clear_refs()
      mm: workingset: prevent lruvec release in workingset_activation()
      mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
      mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios
      mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
      mm/sparse: fix preinited section_mem_map clobbering on failure path
      mm/sparse: fix comment for section map alignment

Pasha Tatashin (14):
      liveupdate: prevent double management of files
      memfd: implement get_id for memfd_luo
      selftests: liveupdate: add test for double preservation
      liveupdate: safely print untrusted strings
      liveupdate: synchronize lazy initialization of FLB private state
      liveupdate: protect file handler list with rwsem
      liveupdate: protect FLB lists with luo_register_rwlock
      liveupdate: defer FLB module refcounting to active sessions
      liveupdate: remove luo_session_quiesce()
      liveupdate: auto unregister FLBs on file handler unregistration
      liveupdate: remove liveupdate_test_unregister()
      liveupdate: make unregister functions return void
      liveupdate: defer file handler module refcounting to active sessions
      MAINTAINERS: update kexec/kdump maintainers entries

Pedro Falcato (2):
      mm/mprotect: move softleaf code out of the main function
      mm/mprotect: special-case small folios when applying permissions

Pratyush Yadav (Google) (3):
      MAINTAINERS: update KHO and LIVE UPDATE maintainers
      MAINTAINERS: drop include/linux/kho/abi/ from KHO
      MAINTAINERS: drop include/linux/liveupdate from LIVE UPDATE

Qi Zheng (14):
      mm: vmscan: prepare for the refactoring the move_folios_to_lru()
      mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
      mm: zswap: prevent memory cgroup release in zswap_compress()
      mm: do not open-code lruvec lock
      mm: vmscan: prepare for reparenting traditional LRU folios
      mm: vmscan: prepare for reparenting MGLRU folios
      mm: memcontrol: refactor memcg_reparent_objcgs()
      mm: workingset: use lruvec_lru_size() to get the number of lru pages
      mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()
      mm: memcontrol: prepare for reparenting non-hierarchical stats
      mm: memcontrol: convert objcg to be per-memcg per-node type
      mm: memcontrol: correct the type of stats_updates to unsigned long
      mm: memcontrol: change val type to long in __mod_memcg_{lruvec_}state()
      mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()

SeongJae Park (7):
      mm/damon/core: fix damon_call() vs kdamond_fn() exit race
      mm/damon/core: fix damos_walk() vs kdamond_fn() exit race
      mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
      mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
      mm/damon/core: use time_in_range_open() for damos quota window start
      Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
      Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race

Sergey Senozhatsky (1):
      zram: do not forget to endio for partial discard requests

Suren Baghdasaryan (1):
      mm/vmscan: prevent MGLRU reclaim from pinning address space

Thorsten Blum (1):
      mm/hugetlb: fix early boot crash on parameters without '=' separator

Zhaoyang Huang (1):
      mm: remove '!root_reclaim' checking in should_abort_scan()

 CREDITS                                            |   8 +
 Documentation/admin-guide/mm/damon/lru_sort.rst    |   4 +
 Documentation/admin-guide/mm/damon/reclaim.rst     |   4 +
 Documentation/admin-guide/mm/kho.rst               |  41 +-
 Documentation/filesystems/proc.rst                 |   4 +
 MAINTAINERS                                        |  29 +-
 drivers/block/zram/zram_drv.c                      |   5 +-
 fs/buffer.c                                        |   4 +-
 fs/fs-writeback.c                                  |  22 +-
 fs/userfaultfd.c                                   |   2 -
 include/linux/alloc_tag.h                          |   2 +
 include/linux/damon.h                              |   2 +
 include/linux/fs.h                                 |   9 +-
 include/linux/kexec_handover.h                     |  13 +-
 include/linux/kho/abi/kexec_handover.h             |  20 +-
 include/linux/kho/abi/kexec_metadata.h             |  46 ++
 include/linux/liveupdate.h                         |  17 +-
 include/linux/memcontrol.h                         | 191 +++---
 include/linux/mm.h                                 |   5 +
 include/linux/mm_inline.h                          |   6 +
 include/linux/mmzone.h                             |  42 +-
 include/linux/pgalloc_tag.h                        |   2 +-
 include/linux/sched.h                              |   2 +-
 include/linux/shmem_fs.h                           |  14 -
 include/linux/swap.h                               |  25 +-
 include/linux/userfaultfd_k.h                      |  73 ++-
 include/trace/events/memcg.h                       |  10 +-
 include/trace/events/writeback.h                   |   3 +
 kernel/cgroup/cgroup.c                             |   9 +-
 kernel/liveupdate/kexec_handover.c                 | 158 ++++-
 kernel/liveupdate/kexec_handover_debugfs.c         |  55 +-
 kernel/liveupdate/kexec_handover_internal.h        |  15 +-
 kernel/liveupdate/luo_core.c                       |  11 +-
 kernel/liveupdate/luo_file.c                       | 112 ++--
 kernel/liveupdate/luo_flb.c                        | 182 +++---
 kernel/liveupdate/luo_internal.h                   |   7 +-
 kernel/liveupdate/luo_session.c                    |  46 +-
 lib/alloc_tag.c                                    | 109 ++++
 lib/test_hmm.c                                     | 130 ++--
 lib/test_kho.c                                     |   5 +-
 lib/tests/liveupdate.c                             |  18 -
 mm/Kconfig.debug                                   |  11 +
 mm/compaction.c                                    |  43 +-
 mm/damon/core.c                                    |  88 +--
 mm/damon/stat.c                                    |   5 +-
 mm/huge_memory.c                                   |  22 +-
 mm/hugetlb.c                                       |  18 +
 mm/kmemleak.c                                      |   2 +-
 mm/memblock.c                                      |   4 +-
 mm/memcontrol-v1.c                                 |  31 +-
 mm/memcontrol-v1.h                                 |   7 +
 mm/memcontrol.c                                    | 632 ++++++++++++-------
 mm/memfd_luo.c                                     |  34 +-
 mm/mempolicy.c                                     |  23 +-
 mm/migrate.c                                       |   2 +
 mm/migrate_device.c                                |   6 -
 mm/mlock.c                                         |   2 +-
 mm/mprotect.c                                      | 218 ++++---
 mm/page_alloc.c                                    |  10 +-
 mm/page_io.c                                       |  10 +-
 mm/percpu.c                                        |   2 +-
 mm/shmem.c                                         | 176 +++---
 mm/shrinker.c                                      |   6 +-
 mm/sparse.c                                        |   1 -
 mm/swap.c                                          |  59 +-
 mm/userfaultfd.c                                   | 682 ++++++++++++---------
 mm/util.c                                          |  10 -
 mm/vmscan.c                                        | 303 ++++++---
 mm/vmstat.c                                        |   2 +-
 mm/workingset.c                                    |  30 +-
 mm/zswap.c                                         | 187 +++---
 tools/testing/selftests/liveupdate/liveupdate.c    |  41 ++
 .../selftests/mm/charge_reserved_hugetlb.sh        |   5 +
 tools/testing/selftests/mm/guard-regions.c         |   4 +
 tools/testing/selftests/mm/hmm-tests.c             |  83 +--
 tools/testing/selftests/mm/hugetlb_dio.c           |  91 ++-
 tools/testing/selftests/mm/merge.c                 |  88 +++
 tools/testing/selftests/mm/soft-dirty.c            |   4 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  19 +-
 tools/testing/selftests/mm/thp_settings.c          |  35 +-
 tools/testing/selftests/mm/thp_settings.h          |   1 -
 tools/testing/selftests/mm/transhuge-stress.c      |   4 +
 tools/testing/selftests/mm/vm_util.c               |  24 +
 tools/testing/selftests/mm/vm_util.h               |   2 +
 84 files changed, 2814 insertions(+), 1675 deletions(-)
 create mode 100644 include/linux/kho/abi/kexec_metadata.h

