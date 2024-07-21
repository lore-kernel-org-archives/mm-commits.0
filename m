Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8797C8D1;
	Sun, 21 Jul 2024 22:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721599814; cv=none; b=rcYSpHccuOZHJ7rdfIB4+7D2kUkT0UWwvgknijaJXlxbwZGYBoa6+kB7gTCGuMeKkiFJJaN/Wpffy13jkQQWOwVqAqIjU2EB2jfmbzldw/m0mJgynhudVPY1fIdbKKeAIYnr4TcBteycvpysTlYLyUIbVuO+79EqJsmy9FW0sLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721599814; c=relaxed/simple;
	bh=rh4gZJla1OqLb5Q9pFch1Wg+OntzQAAQUDG06Z7CApU=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=F6il0PpAlPGWnG0D+9QIDtKkq8YV8gVHMriErJ24rjllyP8n8KfdnJI3h8dp3Ak3T4nXMfIuh85X7ATGFYiL31RHO3bKmwsVx+J8malNfdjqU/1O0rMwNkqtQPYQOIrDBFBiJ0tCQcXhzj7ZuOSTlUvlFhHMj6PGyxd2AlxATB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xVzRK0cQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xVzRK0cQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEF7C116B1;
	Sun, 21 Jul 2024 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721599814;
	bh=rh4gZJla1OqLb5Q9pFch1Wg+OntzQAAQUDG06Z7CApU=;
	h=Date:From:To:Cc:Subject:From;
	b=xVzRK0cQk1p7u27TdsFKm6RACQuMvFSeE6iIpRE9tgXYZ28DcUL8LZruXOxGVUCFO
	 6Ye/CdiRfgtDSErMhC3cF1ZRywnEKO9aBlBD4/cQQeAvuwtZ4I8xImsRu2Ac4m1guc
	 wTMZ3HzlB/1CbrdzF0jJkGeV5m+/t+VObnORTXsg=
Date: Sun, 21 Jul 2024 15:10:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 6.11-rc1
Message-Id: <20240721151013.b9b331ce79f5f60c54c69636@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull this batch of other-than-MM updates for this
development cycle, thanks.


I'm seeing three conflicts during a test merge.  I'd incorrectly
attributed these to the mm-stble branch but these are actually issues
in this mm-nonmm-stable pull.  Those, along with their linux-next
resolutions are:

include/linux/interrupt.h, vs input tree:
https://lkml.kernel.org/r/20240612103235.5ef64950@canb.auug.org.au

include/linux/cacheinfo.h, vs tip tree:
https://lkml.kernel.org/r/20240612112746.3130d68b@canb.auug.org.au

fs/bcachefs/clock.c, vs bcachefs tree:
https://lkml.kernel.org/r/20240712105711.6dc900a2@canb.auug.org.au





The following changes since commit f2661062f16b2de5d7b6a5c42a9a5c96326b8454:

  Linux 6.10-rc5 (2024-06-23 17:08:54 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2024-07-21-15-07

for you to fetch changes up to 67856f44da381973caf4eb692ad2cca1de7b2d37:

  ia64: scrub ia64 from poison.h (2024-07-17 21:11:34 -0700)

----------------------------------------------------------------
- In the series "treewide: Refactor heap related implementation",
  Kuan-Wei Chiu has significantly reworked the min_heap library code and
  has taught bcachefs to use the new more generic implementation.

- Yury Norov's series "Cleanup cpumask.h inclusion in core headers"
  reworks the cpumask and nodemask headers to make things generally more
  rational.

- Kuan-Wei Chiu has sent along some maintenance work against our sorting
  library code in the series "lib/sort: Optimizations and cleanups".

- More library maintainance work from Christophe Jaillet in the series
  "Remove usage of the deprecated ida_simple_xx() API".

- Ryusuke Konishi continues with the nilfs2 fixes and clanups in the
  series "nilfs2: eliminate the call to inode_attach_wb()".

- Kuan-Ying Lee has some fixes to the gdb scripts in the series "Fix GDB
  command error".

- Plus the usual shower of singleton patches all over the place.  Please
  see the relevant changelogs for details.

----------------------------------------------------------------
Alexey Dobriyan (4):
      proc: test "Kthread:" field
      build-id: require program headers to be right after ELF header
      compiler.h: simplify data_race() macro
      ia64: scrub ia64 from poison.h

Amer Al Shanawany (1):
      selftests: proc: remove unreached code and fix build warning

Brian Masney (1):
      lib/Kconfig.debug: document panic= command line option and procfs entry for PANIC_TIMEOUT

Chen Ni (1):
      test_bpf: convert comma to semicolon

Christophe JAILLET (6):
      fsi: occ: remove usage of the deprecated ida_simple_xx() API
      most: remove usage of the deprecated ida_simple_xx() API
      proc: remove usage of the deprecated ida_simple_xx() API
      ocfs2: constify struct ocfs2_lock_res_ops
      ocfs2: constify struct ocfs2_stack_operations
      nilfs2: Constify struct kobj_type

Dan Carpenter (1):
      checkpatch: check for missing Fixes tags

Ferry Meng (2):
      ocfs2: add bounds checking to ocfs2_xattr_find_entry()
      ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()

Hsin Chang Yu (1):
      lib/rbtree.c: fix the example typo

I Hsin Cheng (2):
      lib/plist.c: enforce memory ordering in plist_check_list
      lib/plist.c: avoid worst case scenario in plist_add

Jani Nikula (4):
      kernel/panic: return early from print_tainted() when not tainted
      kernel/panic: convert print_tainted() to use struct seq_buf internally
      kernel/panic: initialize taint_flags[] using a macro
      kernel/panic: add verbose logging of kernel taints in backtraces

Jeff Johnson (17):
      backtracetest: add MODULE_DESCRIPTION()
      lib/ts: add missing MODULE_DESCRIPTION() macros
      kunit/fortify: add missing MODULE_DESCRIPTION() macros
      KUnit: add missing MODULE_DESCRIPTION() macros for lib/*_test.ko
      lib/asn1_encoder: add missing MODULE_DESCRIPTION() macro
      kunit: add missing MODULE_DESCRIPTION() macros to lib/*.c
      uuid: add missing MODULE_DESCRIPTION() macro
      siphash: add missing MODULE_DESCRIPTION() macro
      lib/test_kmod: add missing MODULE_DESCRIPTION() macro
      lib/test_linear_ranges: add missing MODULE_DESCRIPTION() macro
      KUnit: add missing MODULE_DESCRIPTION() macros for lib/test_*.ko
      kfifo: add missing MODULE_DESCRIPTION() macros
      resource: add missing MODULE_DESCRIPTION()
      selftests/fpu: add missing MODULE_DESCRIPTION() macro
      fs: ufs: add MODULE_DESCRIPTION()
      lib/zlib: add missing MODULE_DESCRIPTION() macro
      math: rational: add missing MODULE_DESCRIPTION() macro

Jesse Brandeburg (1):
      kernel-wide: fix spelling mistakes like "assocative" -> "associative"

John Hubbard (1):
      selftests/mqueue: fix 5 warnings about signed/unsigned mismatches

Kees Cook (1):
      tsacct: replace strncpy() with strscpy()

Kuan-Wei Chiu (21):
      perf/core: fix several typos
      bcache: fix typo
      bcachefs: fix typo
      lib min_heap: add type safe interface
      lib min_heap: add min_heap_init()
      lib min_heap: add min_heap_peek()
      lib min_heap: add min_heap_full()
      lib min_heap: add args for min_heap_callbacks
      lib min_heap: add min_heap_sift_up()
      lib min_heap: add min_heap_del()
      lib min_heap: update min_heap_push() and min_heap_pop() to return bool values
      lib min_heap: rename min_heapify() to min_heap_sift_down()
      lib min_heap: update min_heap_push() to use min_heap_sift_up()
      lib/test_min_heap: add test for heap_del()
      bcache: remove heap-related macros and switch to generic min_heap
      bcachefs: remove heap-related macros and switch to generic min_heap
      lib/sort: remove unused pr_fmt macro
      lib/sort: fix outdated comment regarding glibc qsort()
      lib/sort: optimize heapsort for handling final 2 or 3 elements
      lib/test_sort: add a testcase to ensure code coverage
      tools/lib/list_sort: remove redundant code for cond_resched handling

Kuan-Ying Lee (6):
      scripts/gdb: redefine MAX_ORDER sanely
      scripts/gdb: rework module VA range
      scripts/gdb: change the layout of vmemmap
      scripts/gdb: set vabits_actual based on TCR_EL1
      scripts/gdb: change VA_BITS_MIN when we use 16K page
      scripts/gdb: rename pool_index to pool_index_plus_1

Masahiro Yamada (2):
      init: remove unused __MEMINIT* macros
      init/modpost: conditionally check section mismatch to __meminit*

Mateusz Guzik (1):
      percpu_counter: add a cmpxchg-based _add_batch variant

Oleg Nesterov (1):
      coredump: simplify zap_process()

Ryusuke Konishi (3):
      nilfs2: prepare backing device folios for writing after adding checksums
      nilfs2: do not call inode_attach_wb() directly
      nilfs2: avoid undefined behavior in nilfs_cnt32_ge macro

Sidhartha Kumar (2):
      tools/testing/radix-tree: add missing MODULE_DESCRIPTION definition
      tools/testing/radix-tree/idr-test: add missing MODULE_DESCRIPTION define

Suren Baghdasaryan (1):
      lib/dump_stack: report process UID in dump_stack_print_info()

Thomas Gleixner (1):
      watchdog/perf: properly initialize the turbo mode timestamp and rearm counter

Thorsten Blum (1):
      lib/bch.c: use swap() to improve code

Uros Bizjak (1):
      fork: use this_cpu_try_cmpxchg() in try_release_thread_stack_to_cache()

Wei-Hsin Yeh (1):
      include/linux/jhash.h: fix typos

Wen Yang (1):
      selftests: introduce additional eventfd test coverage

Wenchao Hao (1):
      crash: remove header files which are included more than once

Wolfram Sang (1):
      checkpatch: really skip LONG_LINE_* when LONG_LINE is ignored

Xiong Nandi (2):
      scripts/decode_stacktrace.sh: wrap nm with UTIL_PREFIX and UTIL_SUFFIX
      scripts/decode_stacktrace.sh: better support to ARM32 module stack trace

Yang Li (1):
      fs: add kernel-doc comments to ocfs2_prepare_orphan_dir()

Yongliang Gao (1):
      hung_task: ignore hung_task_warnings when hung_task_panic is enabled

Yury Norov (6):
      MAINTAINERS: add linux/nodemask_types.h to BITMAP API
      sched: avoid using ilog2() in sched.h
      cpumask: split out include/linux/cpumask_types.h
      sched: drop sched.h dependency on cpumask
      cpumask: cleanup core headers inclusion
      cpumask: make core headers including cpumask_types.h where possible

lei lu (1):
      ocfs2: add bounds checking to ocfs2_check_dir_entry()

 MAINTAINERS                                        |   2 +
 arch/powerpc/kernel/vmlinux.lds.S                  |   2 -
 drivers/fsi/fsi-occ.c                              |  17 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   2 +-
 drivers/md/bcache/alloc.c                          |  64 +++++--
 drivers/md/bcache/bcache.h                         |   2 +-
 drivers/md/bcache/bset.c                           | 124 +++++++++-----
 drivers/md/bcache/bset.h                           |  40 ++---
 drivers/md/bcache/btree.c                          |  69 ++++----
 drivers/md/bcache/extents.c                        |  53 +++---
 drivers/md/bcache/movinggc.c                       |  41 +++--
 drivers/md/bcache/super.c                          |   3 +-
 drivers/md/bcache/sysfs.c                          |   4 +-
 drivers/md/bcache/util.c                           |   2 +-
 drivers/md/bcache/util.h                           |  67 +-------
 drivers/md/bcache/writeback.c                      |  13 +-
 drivers/md/dm-vdo/repair.c                         |  19 ++-
 drivers/md/dm-vdo/slab-depot.c                     |  14 +-
 drivers/most/core.c                                |  10 +-
 drivers/most/most_cdev.c                           |   6 +-
 drivers/net/wireless/ti/wl1251/acx.h               |   2 +-
 drivers/scsi/qedf/qedf_main.c                      |   2 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   2 +-
 drivers/staging/rtl8723bs/core/rtw_pwrctrl.c       |   2 +-
 fs/bcachefs/clock.c                                |  47 ++++--
 fs/bcachefs/clock_types.h                          |   2 +-
 fs/bcachefs/ec.c                                   |  76 ++++++---
 fs/bcachefs/ec_types.h                             |   2 +-
 fs/bcachefs/util.c                                 |   2 +-
 fs/bcachefs/util.h                                 | 118 +------------
 fs/coredump.c                                      |  14 +-
 fs/nilfs2/segment.c                                |  91 ++++++----
 fs/nilfs2/sysfs.c                                  |   6 +-
 fs/ocfs2/dir.c                                     |  46 +++--
 fs/ocfs2/dlmglue.c                                 |  28 +--
 fs/ocfs2/namei.c                                   |   2 +
 fs/ocfs2/ocfs2.h                                   |   2 +-
 fs/ocfs2/stack_o2cb.c                              |   2 +-
 fs/ocfs2/stack_user.c                              |   2 +-
 fs/ocfs2/stackglue.h                               |   2 +-
 fs/ocfs2/xattr.c                                   |  27 ++-
 fs/proc/generic.c                                  |   6 +-
 fs/ufs/super.c                                     |   1 +
 include/asm-generic/vmlinux.lds.h                  |  18 +-
 include/linux/cacheinfo.h                          |   2 +-
 include/linux/cgroup.h                             |   1 -
 include/linux/clockchips.h                         |   2 +-
 include/linux/compiler.h                           |   6 +-
 include/linux/cpu.h                                |   1 -
 include/linux/cpu_cooling.h                        |   1 -
 include/linux/cpu_rmap.h                           |   2 +-
 include/linux/cpumask.h                            |  56 +-----
 include/linux/cpumask_types.h                      |  66 ++++++++
 include/linux/init.h                               |  18 +-
 include/linux/interrupt.h                          |   2 +-
 include/linux/irqchip/irq-partition-percpu.h       |   2 +-
 include/linux/jhash.h                              |   6 +-
 include/linux/kernel_stat.h                        |   1 -
 include/linux/min_heap.h                           | 188 ++++++++++++++++-----
 include/linux/msi.h                                |   2 +-
 include/linux/node.h                               |   1 -
 include/linux/nvme-fc-driver.h                     |   2 +-
 include/linux/panic.h                              |   8 +-
 include/linux/percpu.h                             |   1 -
 include/linux/pm_domain.h                          |   2 +-
 include/linux/poison.h                             |   6 -
 include/linux/profile.h                            |   1 -
 include/linux/rcupdate.h                           |   1 -
 include/linux/sched.h                              |   7 +-
 include/linux/seq_file.h                           |   1 -
 include/linux/soc/apple/rtkit.h                    |   4 +-
 include/linux/stop_machine.h                       |   2 +-
 include/linux/torture.h                            |   2 +-
 include/linux/tracepoint.h                         |   1 -
 include/linux/workqueue.h                          |   2 +-
 kernel/backtracetest.c                             |   1 +
 kernel/crash_reserve.c                             |   1 -
 kernel/events/core.c                               |  29 ++--
 kernel/fork.c                                      |   7 +-
 kernel/hung_task.c                                 |   2 +-
 kernel/panic.c                                     | 116 +++++++++----
 kernel/resource_kunit.c                            |   1 +
 kernel/tsacct.c                                    |   2 +-
 kernel/watchdog_perf.c                             |  11 +-
 lib/Kconfig.debug                                  |   4 +-
 lib/asn1_encoder.c                                 |   1 +
 lib/atomic64_test.c                                |   1 +
 lib/bch.c                                          |  20 +--
 lib/bitfield_kunit.c                               |   1 +
 lib/buildid.c                                      |  14 ++
 lib/checksum_kunit.c                               |   1 +
 lib/cmdline_kunit.c                                |   1 +
 lib/dhry_run.c                                     |   1 +
 lib/dump_stack.c                                   |   9 +-
 lib/fortify_kunit.c                                |   1 +
 lib/hashtable_test.c                               |   1 +
 lib/is_signed_type_kunit.c                         |   1 +
 lib/math/rational.c                                |   1 +
 lib/memcpy_kunit.c                                 |   1 +
 lib/overflow_kunit.c                               |   1 +
 lib/percpu_counter.c                               |  44 ++++-
 lib/plist.c                                        |  42 ++++-
 lib/rbtree.c                                       |   8 +-
 lib/siphash_kunit.c                                |   1 +
 lib/sort.c                                         |  14 +-
 lib/stackinit_kunit.c                              |   1 +
 lib/test-kstrtox.c                                 |   1 +
 lib/test_bits.c                                    |   1 +
 lib/test_blackhole_dev.c                           |   1 +
 lib/test_bpf.c                                     |   4 +-
 lib/test_firmware.c                                |   1 +
 lib/test_fpu_glue.c                                |   1 +
 lib/test_free_pages.c                              |   1 +
 lib/test_hash.c                                    |   1 +
 lib/test_hexdump.c                                 |   1 +
 lib/test_ida.c                                     |   1 +
 lib/test_kmod.c                                    |   1 +
 lib/test_kprobes.c                                 |   3 +-
 lib/test_linear_ranges.c                           |   1 +
 lib/test_list_sort.c                               |   1 +
 lib/test_memcat_p.c                                |   1 +
 lib/test_meminit.c                                 |   1 +
 lib/test_min_heap.c                                |  76 ++++++---
 lib/test_module.c                                  |   1 +
 lib/test_ref_tracker.c                             |   3 +-
 lib/test_sort.c                                    |  15 +-
 lib/test_static_key_base.c                         |   1 +
 lib/test_static_keys.c                             |   1 +
 lib/test_sysctl.c                                  |   1 +
 lib/test_uuid.c                                    |   1 +
 lib/ts_bm.c                                        |   1 +
 lib/ts_fsm.c                                       |   1 +
 lib/ts_kmp.c                                       |   1 +
 lib/zlib_deflate/deflate_syms.c                    |   1 +
 net/netfilter/nf_conntrack_core.c                  |   2 +-
 net/tipc/socket.c                                  |   2 +-
 samples/kfifo/bytestream-example.c                 |   1 +
 samples/kfifo/dma-example.c                        |   1 +
 samples/kfifo/inttype-example.c                    |   1 +
 samples/kfifo/record-example.c                     |   1 +
 scripts/checkpatch.pl                              |  26 ++-
 scripts/decode_stacktrace.sh                       |   6 +-
 scripts/gdb/linux/mm.py                            |  23 ++-
 scripts/gdb/linux/stackdepot.py                    |   8 +-
 scripts/mod/modpost.c                              |  19 +--
 scripts/spelling.txt                               |   3 +
 tools/lib/list_sort.c                              |  10 --
 tools/testing/radix-tree/idr-test.c                |   1 +
 tools/testing/radix-tree/maple.c                   |   1 +
 tools/testing/radix-tree/xarray.c                  |   1 +
 .../selftests/filesystems/eventfd/eventfd_test.c   | 136 ++++++++++++++-
 tools/testing/selftests/mqueue/mq_perf_tests.c     |   6 +-
 tools/testing/selftests/proc/.gitignore            |   2 +
 tools/testing/selftests/proc/Makefile              |   2 +
 tools/testing/selftests/proc/proc-2-is-kthread.c   |  53 ++++++
 tools/testing/selftests/proc/proc-empty-vm.c       |   3 -
 .../selftests/proc/proc-self-isnt-kthread.c        |  37 ++++
 157 files changed, 1416 insertions(+), 845 deletions(-)
 create mode 100644 include/linux/cpumask_types.h
 create mode 100644 tools/testing/selftests/proc/proc-2-is-kthread.c
 create mode 100644 tools/testing/selftests/proc/proc-self-isnt-kthread.c

