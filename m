Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E073BB40;
	Sun, 23 Aug 2026 00:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787443651; cv=none; b=pRyO7uTFc0XcIagf1uhuGAK2LArD1s93LQjJy1dTnT1owi5yTvq2dJ7A7HUhu8JmP5mN+JdyGBR2naedXcBav00onUHp/m6QIFn10FHOydBJ7ROSvgIkn4LhAy7Bv6Cd8jMvHvcZ59xl+/wkEIns5PWbYZJGvjVYwWJSz7q/R1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787443651; c=relaxed/simple;
	bh=9ytDHbNFobAI+7hMP8DTo8q09G17hCJcSPyqpyYJu9E=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=lw+Ce6qFzYqE2n0KRT07Sn2vgIia+DnEZ7tiqwCxIxURuTrlf+GC3V49oE19ZOaqAc5t1LPHXB7L88mekllTSZvFvwKKYeCEcDizv5kz1O3zzES01FIpJQ/0CPSE1hAarwl6iKRnFjLN396rbuj8ZgLK/vQYB+rJgvI793Ka8Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tZ9gVfSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tZ9gVfSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BE91F000E9;
	Sun, 23 Aug 2026 00:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787443649;
	bh=Jv9OK1rc+KFJbl15QLqqmRw3mFydCFiVTSz+aKJB6jE=;
	h=Date:From:To:Cc:Subject;
	b=tZ9gVfSlIrEXJYlJIxWJhXzkSDx9gOr+NRWi/eEOSnQaCI20mwUfRd2yKntsNfGiz
	 JL4RYV9jVXDwyqK1/i/lHev8C3oxMBUDvLy+wqdZYKcmJRBbD4ewTxq83yPJ+VaNwk
	 wVyepnn139kvV3rMUvGe8y70E0teKUt6Ku8K0ZBE=
Date: Sat, 22 Aug 2026 17:07:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] Non-MM updates for 7.3.rc1
Message-Id: <20260822170728.415abdaf6589f2849d6de871@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge mm,git's other-than-MM updates for the upcoming -rc
cycle.

I'm seeing no present or upcoming conflicts at this time.

Thanks.


The following changes since commit 62cc90241548d5570ee68e01aaba6506964e9811:

  Merge tag 'mm-hotfixes-stable-2026-07-27-14-18' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-07-27 14:36:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-08-22-16-57

for you to fetch changes up to eef628bce8e18ce1eb8531c396bf55e36f86c62c:

  mailmap: fix bouncing address for Taniya Das (2026-08-19 19:55:06 -0700)

----------------------------------------------------------------
mm.git review status for master..mm-nonmm-stable

Total patches:       95
Reviews/patch:       0.63
Reviewed rate:       56%

Summary of patch series in this merge:

- "ocfs2/dlm: bound peer-controlled lengths in the o2dlm" (Bryam Vargas):

  Validate and bound all input lengths and count fields in the o2dlm
  migration and recovery receive handlers to prevent memory corruption and
  kernel panics from malformed cluster messages

- "ocfs2: validate xattr entry bounds" (Cen Zhang):

  Validate OCFS2 extended attribute entry name and value bounds during
  metadata reads to prevent out-of-range memory accesses during retrieval
  or listing operations.

- "taskstats: fix cgroupstats invalid fd handling and add selftests"
  (Yiyang Chen):

  Return -EBADF when cgroupstats receives an invalid file descriptor to
  prevent caller hangs and misleading success ACKs.  Add a kselftest to
  validate valid cgroup v1 queries and verify proper error handling across
  different Netlink flag combinations.

- "misc lib/raid/ improvements v2" (Christoph Hellwig):

  Improve benchmark-based algorithm selection for the XOR and RAID6
  libraries, add KUnit benchmark tests, and cleanup minor implementation
  details.

- "ocfs2: cluster: o2hb_region_pin() fixes" (Joseph Qi):

  Fix sleeping-in-atomic, lock order inversion and error-path cleanup
  bugs in o2hb_region_pin() by releasing o2hb_live_lock across sleeping
  configfs_depend_item() calls and using unlocked variants from callback
  context.  Ensure failed pin attempts properly decrement user counts and
  unpin partially initialized heartbeat regions to prevent memory leaks
  and unprotected states.

- "lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()" (Vincent
  Mailhol)

  Fix an off-by-one which could cause an out-of-bounds read.

- "ocfs2: harden heartbeat teardown races" (Cen Zhang):

  Fix two OCFS2 heartbeat/o2net teardown races found by KASAN.

- "taskstats: tidy up the cpumask command path" *Bradley Morgan)

  make two small cleanups in kernel/taskstats.c.

- "ocfs2: validate active orphan slots during inode read" (ZhengYuan Huang):

  Validate active ordinary and append-DIO orphan slots read from OCFS2
  dinodes at the metadata boundary to prevent corrupted slot indices from
  causing out-of-bounds array accesses.

- "ocfs2: bound-check both readdir re-validation scans" (Zhan Xusheng)

  Enforce strict boundary checks on directory entry record lengths and
  offset calculations during OCFS2 directory re-scans to prevent
  out-of-bounds memory reads and directory position corruption.

----------------------------------------------------------------
Adi Nata (1):
      lib/math: add KUnit test suite for polynomial_calc()

Andrea Calabrese (1):
      kernel: refactor: shorten has_pending_signals

Bradley Morgan (7):
      lib/string: fix memchr_inv() for large ranges
      signal: avoid shared siginfo namespace rewrites
      taskstats: fix cpumask parsing cutting off the last character
      taskstats: drop the dead NULL attribute check in parse()
      taskstats: fold the two cpumask handlers into one
      signal: factor out the kernel reserved si_code check
      prctl: fix PR_SET_MM_AUXV losing the forced AT_NULL terminator

Bryam Vargas (2):
      ocfs2: bound namelen in dlm_migrate_request_handler
      ocfs2: validate lengths in dlm_mig_lockres_handler

Calvin Owens (3):
      pps: don't try to wait for negative timeouts in PPS_FETCH
      pps: don't allow PPS_KC_BIND on removed devices
      pps-gpio: remove dead capture_clear code

Cen Zhang (5):
      ocfs2/cluster: keep heartbeat local node stable
      ocfs2: validate inline xattrs during inode block validation
      ocfs2: validate external xattr entries when reading metadata
      ocfs2: synchronize heartbeat callbacks with o2net teardown
      ocfs2: o2hb: quiesce negotiate handlers and timeout work

Charlie Jenkins (1):
      mailmap: add entry for Charlie Jenkins

Chen-Yu Tsai (1):
      checkpatch: don't emit warnings for ID-base USB & PCI DT compatibles

Christoph Hellwig (8):
      xor: enable lock context analysis
      xor: improve the runtime selection benchmark
      xor/kunit: fix a spelling error
      xor/kunit: add a benchmark
      raid6: enable lock context analysis
      raid6: defer implementation selection when built-in
      raid6: improve the runtime selection benchmark
      raid6/kunit: add a benchmark

Deepanshu Kartikey (1):
      ocfs2: use inode_lock_nested() for orphan dir locking

Dmitry Antipov (2):
      ocfs2: do not use make_bad_inode() in ocfs2_read_inode_block_full()
      ocfs2: always run deallocs on copy-on-write completion

Doruk Tan Ozturk (1):
      ocfs2: validate directory-index entry counts when reading metadata

Gou Hao (3):
      drm: remove dead WARN_ON NULL check after GFP_NOFAIL allocation
      lib/test_hmm: remove dead NULL checks after GFP_NOFAIL allocations
      RDMA/cxgb4: remove dead NULL checks after GFP_NOFAIL allocations

Guangshuo Li (1):
      rapidio: clear mport->net when rio_add_net() fails

Hongfu Li (1):
      selftests/prctl: fix non-anonymous VMA mapping in set-anon-vma-name test

Ian Bridges (1):
      ocfs2: fix missing metadata reservation for large xattrs

Ibrahim Hashimov (1):
      ocfs2: validate rl_used against rl_count in refcount block validator

James Kim (1):
      rapidio: mport_cdev: fix use-after-free in dma_req_free()

Jiaming Zhang (1):
      ocfs2: fix hung task in orphan recovery

JianChunfu (1):
      kernel/fork: declare max_threads __read_mostly

Jianlin Shi (1):
      ipc: only destroy orphaned shm segments on sysctl write

Jim Cromie (1):
      kernel/params: fix a pr_debug(" %p ") in parse_one()

Jordan R Abrahams-Whitehead (1):
      include/linux/list.h: mark list_add and __list_add as __always_inline

Joseph Qi (5):
      ocfs2: cluster: use GFP_NOFS for heartbeat bio allocation
      ocfs2: cluster: use an on-stack bio for the heartbeat write
      ocfs2: cluster: don't sleep while holding o2hb_live_lock in o2hb_region_pin()
      ocfs2: cluster: avoid lock order inversion in o2hb_region_pin() from drop_item
      ocfs2: cluster: fix o2hb_dependent_users leak on pin failure

Joy H.J. Lee (1):
      tools/compiler: match glibc 2.42 definition of __attribute_const__

Karl Mehltretter (1):
      lib/interval_tree: fix allocation warning messages

Kir Chou (1):
      lib/random32: convert selftest to KUnit

Konrad Dybcio (1):
      mailmap: fix bouncing address for Taniya Das

Krystian Kaniewski (1):
      ocfs2: fix circular locking dependency in ocfs2_init_acl()

Lasse Collin (2):
      lib/xz: use size_t instead of uint32_t in a few places
      lib/xz: fix comments

Linfeng Sun (1):
      mailmap: update email address for Linfeng Sun

Manuel Quintero Fonseca (1):
      resource: downgrade "resource sanity check" warning to debug level

Matthew Chen (1):
      watchdog/softlockup: fix softlockup typos

Matthias Goergens (1):
      ocfs2: fix cached cluster count after suballocator reclaim

Michael Byczkowski (1):
      pps: pps-gpio: split IRQ handler into hardirq timestamper + threaded handler

Nathan Chancellor (1):
      .get_maintainer.ignore: add Nathan Chancellor

Oleg Nesterov (2):
      signal: change sys_kill() to use SEND_SIG_NOINFO
      signal: avoid unconditional siginfo copy in send_signal_locked()

Paul Walmsley (1):
      checkpatch: add NOKPROBE_SYMBOL to the whitelist of lines that can occur immediately after functions

Paul White (1):
      selftests: ipc: change operation not supported error number

Petr Mladek (1):
      Revert "printf: Compile the kunit test with DISABLE_BRANCH_PROFILING DISABLE_BRANCH_PROFILING"

Petr Vorel (1):
      MAINTAINERS: add IRC and patchwork for LTP

Phillip Lougher (1):
      Squashfs: check block offset is not negative

Randy Dunlap (3):
      rbtree: fixup kernel-doc names
      llist: use correct function parameter name
      stacktrace: header: repair kernel-doc comments

Sara Sena (1):
      tools/accounting/delaytop.c: fix typo in PSI header string

Shivank Sharma (1):
      tools/accounting: fix macro typos in getdelays

Tetsuo Handa (1):
      kcov: fix data corruption and race conditions on PREEMPT_RT

Thorsten Blum (1):
      lib/xz: replace min_t with min

Usama Arif (1):
      squashfs: avoid thundering-herd cache wakeups

Vincent Mailhol (2):
      lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()
      lib/ucs2_string.c: fix indentation

Warren Xiong (1):
      tools/mm: prevent page_owner_sort from truncating input

Xibo Wang (1):
      hung_task: update DETECT_HUNG_TASK_BLOCKER Kconfig help

Yemu Lu (1):
      fat: restore original value when fat_ent_write failed

Yichong Chen (1):
      fat: release buffer head after rebuilding parent

Yiyang Chen (4):
      taskstats: remove dead taskstats_exit_mutex declaration
      taskstats: return -EBADF when cgroupstats receives an invalid fd
      selftests/acct: add cgroupstats functional test
      selftests/acct: share netlink helpers

Zhan Xusheng (3):
      ocfs2: fix readdir position truncation on 32-bit kernels
      ocfs2: bound-check dir entries in the readdir re-validation scan
      ocfs2: bound-check dir entries in the inline-data re-validation scan

ZhengYuan Huang (2):
      ocfs2: validate orphan slot during inode read
      ocfs2: validate DIO orphan slot during inode read

Ziran Zhang (1):
      FAT: allow 0xE9 near jump in fat_read_static_bpb()

 .get_maintainer.ignore                             |   1 +
 .mailmap                                           |   6 +-
 MAINTAINERS                                        |   2 +
 drivers/gpu/drm/drm_modeset_lock.c                 |   4 -
 drivers/infiniband/hw/cxgb4/mem.c                  |  10 +-
 drivers/pps/clients/pps-gpio.c                     |  72 ++--
 drivers/pps/kc.c                                   |  10 +
 drivers/pps/pps.c                                  |  10 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  10 +-
 drivers/rapidio/rio-scan.c                         |   1 +
 fs/fat/inode.c                                     |   5 +-
 fs/fat/misc.c                                      |   4 +
 fs/fat/nfs.c                                       |   4 +-
 fs/ocfs2/acl.c                                     | 135 +++++---
 fs/ocfs2/acl.h                                     |  19 +-
 fs/ocfs2/cluster/heartbeat.c                       | 381 +++++++++++++++------
 fs/ocfs2/cluster/heartbeat.h                       |   5 +
 fs/ocfs2/cluster/nodemanager.c                     |  29 +-
 fs/ocfs2/cluster/nodemanager.h                     |   3 +
 fs/ocfs2/cluster/tcp.c                             | 186 ++++++++--
 fs/ocfs2/cluster/tcp.h                             |   2 +
 fs/ocfs2/dir.c                                     |  93 ++++-
 fs/ocfs2/dlm/dlmmaster.c                           |   6 +
 fs/ocfs2/dlm/dlmrecovery.c                         |   9 +
 fs/ocfs2/inode.c                                   |  22 +-
 fs/ocfs2/namei.c                                   |  34 +-
 fs/ocfs2/refcounttree.c                            |  47 ++-
 fs/ocfs2/suballoc.c                                |   2 +-
 fs/ocfs2/xattr.c                                   | 324 +++++++++++++++---
 fs/ocfs2/xattr.h                                   |  11 +-
 fs/squashfs/cache.c                                | 116 ++++++-
 fs/squashfs/squashfs_fs_sb.h                       |   9 +
 include/linux/list.h                               |  15 +-
 include/linux/llist.h                              |   2 +-
 include/linux/nmi.h                                |   4 +-
 include/linux/pps_kernel.h                         |   1 +
 include/linux/rbtree.h                             |   2 +-
 include/linux/rbtree_latch.h                       |   2 +-
 include/linux/sched.h                              |   8 +
 include/linux/stacktrace.h                         |   6 +-
 include/linux/taskstats_kern.h                     |   1 -
 ipc/ipc_sysctl.c                                   |   2 +-
 kernel/fork.c                                      |   2 +-
 kernel/kcov.c                                      |  90 ++---
 kernel/params.c                                    |   4 +-
 kernel/resource.c                                  |   2 +-
 kernel/signal.c                                    |  76 ++--
 kernel/sys.c                                       |   2 +-
 kernel/taskstats.c                                 |  45 +--
 kernel/watchdog.c                                  |  16 +-
 lib/Kconfig                                        |   6 -
 lib/Kconfig.debug                                  |  39 ++-
 lib/interval_tree_test.c                           |   4 +-
 lib/math/tests/Makefile                            |   1 +
 lib/math/tests/polynomial_kunit.c                  | 270 +++++++++++++++
 lib/raid/Kconfig                                   |  12 +
 lib/raid/raid6/Makefile                            |   2 +
 lib/raid/raid6/algos.c                             | 102 +++---
 lib/raid/raid6/tests/raid6_kunit.c                 |  66 +++-
 lib/raid/xor/Makefile                              |   2 +
 lib/raid/xor/tests/Makefile                        |   2 +
 lib/raid/xor/tests/xor_kunit.c                     |  64 +++-
 lib/raid/xor/xor-core.c                            |  55 ++-
 lib/random32.c                                     | 184 +---------
 lib/string.c                                       |   3 +-
 lib/test_hmm.c                                     |   6 -
 lib/tests/Makefile                                 |   3 +-
 lib/tests/random32_kunit.c                         | 182 ++++++++++
 lib/ucs2_string.c                                  |  38 +-
 lib/xz/xz_dec_bcj.c                                |   2 +-
 lib/xz/xz_dec_lzma2.c                              |  63 ++--
 lib/xz/xz_dec_stream.c                             |   4 +-
 lib/xz/xz_lzma2.h                                  |   2 +-
 scripts/checkpatch.pl                              |   7 +
 tools/accounting/delaytop.c                        |   2 +-
 tools/accounting/getdelays.c                       |  32 +-
 tools/include/linux/compiler.h                     |   2 +-
 tools/mm/page_owner_sort.c                         |  10 +-
 tools/testing/selftests/acct/.gitignore            |   1 +
 tools/testing/selftests/acct/Makefile              |  11 +
 tools/testing/selftests/acct/cgroupstats.c         | 231 +++++++++++++
 tools/testing/selftests/acct/netlink_helper.c      | 116 +++++++
 tools/testing/selftests/acct/netlink_helper.h      |  44 +++
 .../selftests/acct/taskstats_fill_stats_tgid.c     | 134 +-------
 tools/testing/selftests/ipc/msgque.c               |   2 +-
 .../selftests/prctl/set-anon-vma-name-test.c       |  21 +-
 86 files changed, 2589 insertions(+), 988 deletions(-)
 create mode 100644 lib/math/tests/polynomial_kunit.c
 create mode 100644 lib/tests/random32_kunit.c
 create mode 100644 tools/testing/selftests/acct/cgroupstats.c
 create mode 100644 tools/testing/selftests/acct/netlink_helper.c
 create mode 100644 tools/testing/selftests/acct/netlink_helper.h

