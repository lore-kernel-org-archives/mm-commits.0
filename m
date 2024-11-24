Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F75C14287;
	Sun, 24 Nov 2024 10:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732442931; cv=none; b=noZjVIDNiKaJ1Wezovuf8R7xv2/odg70RWNR77TZchncsPI0Wb70YgDavahGQRCFALhrgyMRUZtHug5dVHMp7uqm0fDB0s5pIbfDE8Xi9gPnupqcplMtEMdwIQfXfXlH19kCWAJOiE3R05oeY9t7SSbg9uaBZZpeA3GFBg57pBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732442931; c=relaxed/simple;
	bh=JOaEzMsrupHbOYkmeB77Gn8/lgjUaj9fxhGXkH5xHaA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=PIVm8XZXt7AkUmthZvQ6B4GVX5rTnw8j8IQbBpGvA1Kts9pPaWDqDzP6/3kfZFXZL4S5EX7qMnpDPOnty0nyC8ibHVdDyQv8Uk9DFHA1m75XPboydmlZOPzptTSqFQJLNsOdHVj/PpcIipYqYSwz6f7pEKuJDjequ7G7UxLua5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ggEhGLJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ggEhGLJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D91C4CECC;
	Sun, 24 Nov 2024 10:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732442931;
	bh=JOaEzMsrupHbOYkmeB77Gn8/lgjUaj9fxhGXkH5xHaA=;
	h=Date:From:To:Cc:Subject:From;
	b=ggEhGLJfZesK8O9RXX3jmh5lwx+M+JvYmFPMrKrgjPnI7oDCK+kkfvdPhAKVhAUmH
	 K7OlZ0URs5QE8GWmgg7DKQSZRoIDNVp2VsyxGOn7AWzdM5vbjGixZEzkZWH+tmDCLm
	 FXljQod357ta7wwtzqx/LP8wlmf7c8q1OAzCdCiQ=
Date: Sun, 24 Nov 2024 02:08:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 6.13-rc1
Message-Id: <20241124020841.3a96d9e26be9ce4d5810d0b5@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this cycle's non-MM updates, thanks.

Merge issues along with their linux-next resolutions are as follows:

kernel/auditsc.c, vs security tree:
https://lkml.kernel.org/r/20241014144648.1923104a@canb.auug.org.au

lib/Makefile, vs asm-generic tree:
https://lkml.kernel.org/r/20241029095525.0fba9d23@canb.auug.org.au


The following changes since commit 59b723cd2adbac2a34fc8e12c74ae26ae45bf230:

  Linux 6.12-rc6 (2024-11-03 14:05:52 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stabl=
e-2024-11-24-02-05

for you to fetch changes up to 2c259a91d8d23a8266092b0dd51b8092877717a4:

  gdb: lx-symbols: do not error out on monolithic build (2024-11-14 22:51:1=
4 -0800)

----------------------------------------------------------------
- The series "resource: A couple of cleanups" from Andy Shevchenko
  performs some cleanups in the resource management code.

- The series "Improve the copy of task comm" from Yafang Shao addresses
  possible race-induced overflows in the management of task_struct.comm[].

- The series "Remove unnecessary header includes from
  {tools/}lib/list_sort.c" from Kuan-Wei Chiu adds some cleanups and a
  small fix to the list_sort library code and to its selftest.

- The series "Enhance min heap API with non-inline functions and
  optimizations" also from Kuan-Wei Chiu optimizes and cleans up the
  min_heap library code.

- The series "nilfs2: Finish folio conversion" from Ryusuke Konishi
  finishes off nilfs2's folioification.

- The series "add detect count for hung tasks" from Lance Yang adds more
  userspace visibility into the hung-task detector's activity.

- Apart from that, singelton patches in many places - please see the
  individual changelogs for details.

----------------------------------------------------------------
Alexandru Ardelean (2):
      util_macros.h: fix/rework find_closest() macros
      lib: util_macros_kunit: add kunit test for util_macros.h

Andrew Kreimer (1):
      ocfs2: cluster: fix a typo

Andy Shevchenko (2):
      resource: replace open coded resource_intersection()
      resource: introduce is_type_match() helper and use it

Breno Leitao (1):
      scripts/decode_stacktrace.sh: remove trailing space

Dmitry Antipov (1):
      ocfs2: fix uninitialized value in ocfs2_file_read_iter()

Dr. David Alan Gilbert (1):
      ocfs2: remove unused errmsg function and table

Etienne Buira (1):
      gdb: lx-symbols: do not error out on monolithic build

Huang Ying (1):
      resource: avoid unnecessary resource tree walking in __region_interse=
cts()

I Hsin Cheng (1):
      list: test: check the size of every lists for list_cut_position*()

Ilpo J=E4rvinen (1):
      resource: correct reallocate_resource() documentation

Kuan-Wei Chiu (16):
      lib/Kconfig.debug: move int_pow test option to runtime testing section
      lib/Makefile: make union-find compilation conditional on CONFIG_CPUSE=
TS
      lib/list_sort: remove unnecessary header includes
      tools/lib/list_sort: remove unnecessary header includes
      perf tools: update expected diff for lib/list_sort.c
      lib/min_heap: introduce non-inline versions of min heap API functions
      lib min_heap: optimize min heap by prescaling counters for better per=
formance
      lib min_heap: avoid indirect function call by providing default swap
      lib/test_min_heap: update min_heap_callbacks to use default builtin s=
wap
      perf/core: update min_heap_callbacks to use default builtin swap
      dm vdo: update min_heap_callbacks to use default builtin swap
      bcache: update min_heap_callbacks to use default builtin swap
      bcachefs: clean up duplicate min_heap_callbacks declarations
      bcachefs: update min_heap_callbacks to use default builtin swap
      Documentation/core-api: add min heap API introduction
      MAINTAINERS: add entry for min heap library code

Lance Yang (2):
      hung_task: add detect count for hung tasks
      hung_task: add docs for hung_task_detect_count

Ma Wupeng (1):
      ipc: fix memleak if msg_init_ns failed in create_ipc_ns

Matthew Wilcox (Oracle) (4):
      nilfs2: remove nilfs_writepage
      nilfs2: convert nilfs_page_count_clean_buffers() to take a folio
      nilfs2: convert nilfs_recovery_copy_block() to take a folio
      nilfs2: convert metadata aops from writepage to writepages

Mirsad Todorovac (1):
      fs/proc/kcore.c: fix coccinelle reported ERROR instances

Mohammed Anees (1):
      ocfs2: fix typo in comment

Nataniel Farzan (1):
      Improve consistency of '#error' directive messages

Ryusuke Konishi (8):
      nilfs2: convert segment buffer to be folio-based
      nilfs2: convert common metadata file code to be folio-based
      nilfs2: convert segment usage file to be folio-based
      nilfs2: convert persistent object allocator to be folio-based
      nilfs2: convert inode file to be folio-based
      nilfs2: convert DAT file to be folio-based
      nilfs2: remove nilfs_palloc_block_get_entry()
      nilfs2: convert checkpoint file to be folio-based

Shuah Khan (1):
      tools: fix -Wunused-result in linux.c

Sourabh Jain (1):
      kexec/crash: no crash update when kexec in progress

Sui Jingfeng (2):
      scatterlist: fix a typo
      lib/scatterlist: use sg_phys() helper

Tamir Duberstein (1):
      checkpatch: always parse orig_commit in fixes tag

Thomas Wei=DFschuh (1):
      reboot: move reboot_notifier_list to kernel/reboot.c

Thorsten Blum (1):
      ipc/msg: replace one-element array with flexible array member

Tio Zhang (1):
      kernel/watchdog: always restore watchdog_softlockup(,hardlockup)_user=
_enabled after proc show

Uros Bizjak (5):
      perf/hw_breakpoint: use ERR_PTR_PCPU(), IS_ERR_PCPU() and PTR_ERR_PCP=
U() macros
      percpu: merge VERIFY_PERCPU_PTR() into its only user
      percpu: introduce PERCPU_PTR() macro
      percpu: cast percpu pointer in PERCPU_PTR() via unsigned long
      dma-buf: use atomic64_inc_return() in dma_buf_getfile()

Vinicius Peixoto (1):
      lib/crc16_kunit.c: add KUnit tests for crc16

WangYuli (1):
      scripts/spelling.txt: add typo "exprienced" and "rewritting"

Yafang Shao (7):
      get rid of __get_task_comm()
      auditsc: replace memcpy() with strscpy()
      security: replace memcpy() with get_task_comm()
      bpftool: ensure task comm is always NUL-terminated
      mm/util: fix possible race condition in kstrdup()
      mm/util: deduplicate code in {kstrdup,kstrndup,kmemdup_nul}
      drm: replace strcpy() with strscpy()

Yu Jiaoliang (1):
      scripts/spelling.txt: add more spellings corrections

Zhang Zekun (1):
      ocfs2: remove unused declaration in header file

zhangguopeng (1):
      kernel/reboot: replace sprintf() with sysfs_emit()

 Documentation/admin-guide/sysctl/kernel.rst        |   9 +
 Documentation/core-api/index.rst                   |   1 +
 Documentation/core-api/min_heap.rst                | 300 ++++++++++++++++
 MAINTAINERS                                        |   9 +
 arch/alpha/include/asm/spinlock_types.h            |   2 +-
 arch/arm/include/asm/spinlock_types.h              |   2 +-
 arch/arm64/include/asm/spinlock_types.h            |   2 +-
 arch/hexagon/include/asm/spinlock_types.h          |   2 +-
 arch/powerpc/include/asm/simple_spinlock_types.h   |   2 +-
 arch/powerpc/include/asm/spinlock_types.h          |   2 +-
 arch/s390/include/asm/spinlock_types.h             |   2 +-
 arch/sh/include/asm/spinlock_types.h               |   2 +-
 arch/xtensa/include/asm/spinlock_types.h           |   2 +-
 drivers/dma-buf/dma-buf.c                          |   2 +-
 drivers/gpu/drm/drm_framebuffer.c                  |   2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |   6 +-
 drivers/md/bcache/Kconfig                          |   1 +
 drivers/md/bcache/alloc.c                          |  11 +-
 drivers/md/bcache/bset.c                           |  14 +-
 drivers/md/bcache/extents.c                        |  10 +-
 drivers/md/bcache/movinggc.c                       |  10 +-
 drivers/md/dm-vdo/Kconfig                          |   1 +
 drivers/md/dm-vdo/repair.c                         |   2 +-
 drivers/md/dm-vdo/slab-depot.c                     |  10 +-
 fs/bcachefs/Kconfig                                |   1 +
 fs/bcachefs/clock.c                                |  25 +-
 fs/bcachefs/ec.c                                   |  19 +-
 fs/exec.c                                          |  10 -
 fs/nilfs2/alloc.c                                  | 148 ++++----
 fs/nilfs2/alloc.h                                  |   4 +-
 fs/nilfs2/cpfile.c                                 | 383 +++++++++++------=
----
 fs/nilfs2/dat.c                                    |  98 +++---
 fs/nilfs2/dir.c                                    |   2 +-
 fs/nilfs2/ifile.c                                  |  10 +-
 fs/nilfs2/ifile.h                                  |   4 +-
 fs/nilfs2/inode.c                                  |  35 +-
 fs/nilfs2/mdt.c                                    |  40 ++-
 fs/nilfs2/page.c                                   |   4 +-
 fs/nilfs2/page.h                                   |   4 +-
 fs/nilfs2/recovery.c                               |  17 +-
 fs/nilfs2/segbuf.c                                 |  17 +-
 fs/nilfs2/sufile.c                                 | 160 ++++-----
 fs/ocfs2/alloc.c                                   |   2 +-
 fs/ocfs2/aops.h                                    |   2 +
 fs/ocfs2/cluster/quorum.c                          |   2 +-
 fs/ocfs2/dlm/dlmapi.h                              |   2 -
 fs/ocfs2/dlm/dlmdebug.c                            |  53 ---
 fs/ocfs2/file.c                                    |   4 +
 fs/ocfs2/quota.h                                   |   1 -
 fs/proc/array.c                                    |   2 +-
 fs/proc/kcore.c                                    |  10 +-
 include/acpi/platform/aclinux.h                    |   2 +-
 include/linux/compiler-clang.h                     |   2 +-
 include/linux/compiler-gcc.h                       |   2 +-
 include/linux/min_heap.h                           | 357 +++++++++++++++--=
--
 include/linux/notifier.h                           |   2 -
 include/linux/percpu-defs.h                        |  21 +-
 include/linux/pm_wakeup.h                          |   2 +-
 include/linux/rwlock.h                             |   2 +-
 include/linux/rwlock_api_smp.h                     |   2 +-
 include/linux/scatterlist.h                        |   2 +-
 include/linux/sched.h                              |  28 +-
 include/linux/spinlock_api_smp.h                   |   2 +-
 include/linux/spinlock_types_up.h                  |   2 +-
 include/linux/spinlock_up.h                        |   2 +-
 include/linux/util_macros.h                        |  56 ++-
 init/Kconfig                                       |   1 +
 ipc/msg.c                                          |   2 +-
 ipc/namespace.c                                    |   4 +-
 kernel/auditsc.c                                   |   6 +-
 kernel/crash_core.c                                |   6 +-
 kernel/events/core.c                               |  15 +-
 kernel/events/hw_breakpoint.c                      |   4 +-
 kernel/hung_task.c                                 |  18 +
 kernel/kthread.c                                   |   2 +-
 kernel/notifier.c                                  |   8 -
 kernel/reboot.c                                    |  15 +-
 kernel/resource.c                                  |  66 ++--
 kernel/watchdog.c                                  |   3 +-
 lib/Kconfig                                        |   6 +
 lib/Kconfig.debug                                  |  59 +++-
 lib/Makefile                                       |   6 +-
 lib/crc16_kunit.c                                  | 155 +++++++++
 lib/list-test.c                                    |   4 +
 lib/list_sort.c                                    |   3 -
 lib/min_heap.c                                     |  70 ++++
 lib/scatterlist.c                                  |   4 +-
 lib/test_min_heap.c                                |  16 +-
 lib/util_macros_kunit.c                            | 240 +++++++++++++
 mm/util.c                                          |  62 ++--
 samples/hw_breakpoint/data_breakpoint.c            |   4 +-
 scripts/checkpatch.pl                              |  37 +-
 scripts/decode_stacktrace.sh                       |   7 +-
 scripts/gdb/linux/modules.py                       |   3 +
 scripts/gdb/linux/symbols.py                       |   3 +
 scripts/spelling.txt                               |  33 ++
 security/lsm_audit.c                               |   4 +-
 security/selinux/selinuxfs.c                       |   2 +-
 tools/bpf/bpftool/pids.c                           |   2 +
 tools/include/linux/compiler-gcc.h                 |   2 +-
 tools/lib/list_sort.c                              |   2 -
 .../perf/check-header_ignore_hunks/lib/list_sort.c |  11 +-
 tools/testing/shared/linux.c                       |  14 +-
 103 files changed, 1952 insertions(+), 896 deletions(-)
 create mode 100644 Documentation/core-api/min_heap.rst
 create mode 100644 lib/crc16_kunit.c
 create mode 100644 lib/min_heap.c
 create mode 100644 lib/util_macros_kunit.c

