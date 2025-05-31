Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C5E13F434;
	Sat, 31 May 2025 22:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748730719; cv=none; b=j0XgH9w9TeYb3rup4mGAPLg7sqplnEo6Ua5jQdnoN2B32v/RYrQUbUfyFfOZcIezXXGMBM9V0tzmZjkpqqj+ddE+At67kT0Sc4omp1BnC9RX1mleNaE3dpeugTccEeC7ALQIyYN3Y4M+IsC7zERiweDVUQF8YrLdgAK4iSa+FTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748730719; c=relaxed/simple;
	bh=FzjibAJzYSR3ngKXOTEm8IoBAY2HueMnLqz1AXGs7Po=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=oUy8YBzzJvygfqdPSR5ga5eFb2P1ohqXwEfZWiM+GrqxJrmktTC1JO27BZHQt/aPMGj1rdrbWF9Q+4WtCQwvVkL+zAnuRR4cogc9ieOUbI+tQzLu8XyyQvn/Hs0VBk2VM2Q+A4c5pZjXzxWZIeZZpNuG6MrGQsCtJGsBppH11mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rFwPxKR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rFwPxKR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E66C4CEE3;
	Sat, 31 May 2025 22:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748730718;
	bh=FzjibAJzYSR3ngKXOTEm8IoBAY2HueMnLqz1AXGs7Po=;
	h=Date:From:To:Cc:Subject:From;
	b=rFwPxKR49AfdyQ+TC8gwm5XVhzYdoKXfTH/dL0/iE1ZmXSQMUFuOkRrC7oITholDO
	 2Xz0R9ZSfos2KY0xk2ngsRfCeJImEWvSnUTM+EztV+DT6EUU06+TrqVyDr+RoWd5Eh
	 JRBFCzWwSOiimdcwGqBzwOs5suTt+yWFUWzLixpI=
Date: Sat, 31 May 2025 15:31:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 6.16-rc1
Message-Id: <20250531153157.8fd9b708ae4009f5dbe81a9e@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this set of other-than-MM patches for the 6.16-rcX
cycle, thanks.

Conflicts which I'm seeing today, and their linux-resolutions:

kernel/kexec_file.c, vs integrity tree:
https://lkml.kernel.org/r/20250430142331.468074f1@canb.auug.org.au



The following changes since commit 82f2b0b97b36ee3fcddf0f0780a9a0825d52fec3:

  Linux 6.15-rc6 (2025-05-11 14:54:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-05-31-15-28

for you to fetch changes up to 375700bab5b150e876e42d894a9a7470881f8a61:

  llist: make llist_add_batch() a static inline (2025-05-27 19:40:34 -0700)

----------------------------------------------------------------
- The 3 patch series "hung_task: extend blocking task stacktrace dump to
  semaphore" from Lance Yang enhances the hung task detector.  The
  detector presently dumps the blocking tasks's stack when it is blocked
  on a mutex.  Lance's series extends this to semaphores.

- The 2 patch series "nilfs2: improve sanity checks in dirty state
  propagation" from Wentao Liang addresses a couple of minor flaws in
  nilfs2.

- The 2 patch series "scripts/gdb: Fixes related to lx_per_cpu()" from
  Illia Ostapyshyn fixes a couple of issues in the gdb scripts.

- The 9 patch series "Support kdump with LUKS encryption by reusing LUKS
  volume keys" from Coiby Xu addresses a usability problem with kdump.
  When the dump device is LUKS-encrypted, the kdump kernel may not have
  the keys to the encrypted filesystem.  A full writeup of this is in the
  series [0/N] cover letter.

- The 2 patch series "sysfs: add counters for lockups and stalls" from
  Max Kellermann adds /sys/kernel/hardlockup_count and
  /sys/kernel/hardlockup_count and /sys/kernel/rcu_stall_count.

- The 3 patch series "fork: Page operation cleanups in the fork code"
  from Pasha Tatashin implements a number of code cleanups in fork.c.

- The 3 patch series "scripts/gdb/symbols: determine KASLR offset on
  s390 during early boot" from Ilya Leoshkevich fixes some s390 issues in
  the gdb scripts.

----------------------------------------------------------------
Andrii Nakryiko (1):
      exit: move and extend sched_process_exit() tracepoint

Andy Shevchenko (3):
      kernel.h: move PTR_IF() and u64_to_user_ptr() to util_macros.h
      util_macros.h: fix the reference in kernel-doc
      list: remove redundant 'extern' for function prototypes

Arnd Bergmann (1):
      crash_dump, nvme: select CONFIGFS_FS as built-in

Caleb Sander Mateos (1):
      scatterlist: inline sg_next()

Casey Connolly (1):
      mailmap: update and consolidate Casey Connolly's name and email

Chanho Min (1):
      squashfs: add optional full compressed block caching

Chelsy Ratnawat (1):
      selftests: fix some typos in tools/testing/selftests

Chen Ni (1):
      ocfs2: remove unnecessary NULL check before unregister_sysctl_table()

Chisheng Chen (1):
      lib/rbtree.c: fix the example typo

Christoph Hellwig (1):
      nilfs2: remove wbc->for_reclaim handling

Coiby Xu (8):
      kexec_file: allow to place kexec_buf randomly
      crash_dump: make dm crypt keys persist for the kdump kernel
      crash_dump: store dm crypt keys in kdump reserved memory
      crash_dump: reuse saved dm crypt keys for CPU/memory hot-plugging
      crash_dump: retrieve dm crypt keys in kdump kernel
      Revert "x86/mm: Remove unused __set_memory_prot()"
      x86/crash: pass dm crypt keys to kdump kernel
      x86/crash: make the page that stores the dm crypt keys inaccessible

Colin Ian King (1):
      crash: fix spelling mistake "crahskernel" -> "crashkernel"

Dr. David Alan Gilbert (4):
      rapidio: remove some dead defines
      rapidio: remove unused functions
      relay: remove unused relay_late_setup_files
      lib/oid_registry.c: remove unused sprint_OID

Eric Biggers (1):
      kexec_file: use SHA-256 library API instead of crypto_shash API

Fedor Pchelkin (1):
      sort.h: hoist cmp_int() into generic header file

Francesco Valla (1):
      init/main.c: log initcall level when initcall_debug is used

Herton R. Krzesinski (1):
      lib/test_kmod: do not hardcode/depend on any filesystem

Illia Ostapyshyn (2):
      scripts/gdb: fix kgdb probing on single-core systems
      scripts/gdb: update documentation for lx_per_cpu

Ilya Leoshkevich (3):
      scripts/gdb/symbols: factor out get_vmlinux()
      scripts/gdb/symbols: factor out pagination_off()
      scripts/gdb/symbols: determine KASLR offset on s390 during early boot

Ingo Molnar (1):
      kernel.h: move READ/WRITE definitions to <linux/types.h>

Jens Axboe (1):
      llist: make llist_add_batch() a static inline

Jeongjun Park (1):
      ipc: fix to protect IPCS lookups using RCU

Jim Cromie (3):
      checkpatch: dont warn about unused macro arg on empty body
      checkpatch: qualify do-while-0 advice
      powernow: use pr_info_once

Lance Yang (2):
      hung_task: replace blocker_mutex with encoded blocker
      hung_task: show the blocker task if the task is hung on semaphore

Linus Walleij (1):
      fork: define a local GFP_VMAP_STACK

Luo Gengkun (1):
      watchdog: fix watchdog may detect false positive of softlockup

Marc Herbert (1):
      compiler_types.h: fix "unused variable" in __compiletime_assert()

Mario Limonciello (1):
      kstrtox: add support for enabled and disabled in kstrtobool()

Mateusz Guzik (1):
      exit: combine work under lock in synchronize_group_exit() and coredump_task_exit()

Max Kellermann (2):
      kernel/watchdog: add /sys/kernel/{hard,soft}lockup_count
      kernel/rcu/tree_stall: add /sys/kernel/rcu_stall_count

Murad Masimov (1):
      ocfs2: fix possible memory leak in ocfs2_finish_quota_recovery

Mykyta Yatsenko (1):
      maccess: fix strncpy_from_user_nofault() empty string handling

Pasha Tatashin (4):
      task_stack.h: remove obsolete __HAVE_ARCH_KSTACK_END check
      fork: clean-up ifdef logic around stack allocation
      fork: clean-up naming of vm_stack/vm_struct variables in vmap stacks code
      fork: check charging success before zeroing stack

Penglei Jiang (1):
      proc: fix the issue of proc_mem_open returning NULL

Phillip Lougher (1):
      Squashfs: check return result of sb_min_blocksize

Ryusuke Konishi (1):
      nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()

Sravan Kumar Gundu (1):
      kernel/panic.c: format kernel-doc comments

Thorsten Blum (1):
      ocfs2: simplify return statement in ocfs2_filecheck_attr_store()

Wang Yaxin (1):
      delayacct: remove redundant code and adjust indentation

WangYuli (2):
      ocfs2: o2net_idle_timer: Rename del_timer_sync in comment
      treewide: fix typo "previlege"

Wentao Liang (1):
      nilfs2: add pointer check for nilfs_direct_propagate()

Zhiquan Li (1):
      crash: export PAGE_UNACCEPTED_MAPCOUNT_VALUE to vmcoreinfo

Zi Li (1):
      samples: extend hung_task detector test with semaphore support

Zijun Hu (1):
      errseq: eliminate special limitation for macro MAX_ERRNO

 .mailmap                                           |   3 +
 .../ABI/testing/sysfs-kernel-hardlockup_count      |   7 +
 .../ABI/testing/sysfs-kernel-rcu_stall_count       |   6 +
 .../ABI/testing/sysfs-kernel-softlockup_count      |   7 +
 Documentation/admin-guide/kdump/kdump.rst          |  32 ++
 Documentation/admin-guide/kdump/vmcoreinfo.rst     |   4 +-
 .../bindings/display/panel/lg,sw43408.yaml         |   2 +-
 .../bindings/iio/adc/qcom,spmi-rradc.yaml          |   2 +-
 .../power/supply/qcom,pmi8998-charger.yaml         |   2 +-
 Documentation/filesystems/relay.rst                |  10 -
 .../process/debugging/gdb-kernel-debugging.rst     |  34 +-
 .../zh_CN/dev-tools/gdb-kernel-debugging.rst       |  34 +-
 .../zh_TW/dev-tools/gdb-kernel-debugging.rst       |  34 +-
 MAINTAINERS                                        |   2 +-
 arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts   |   2 +-
 arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts  |   2 +-
 arch/x86/include/asm/set_memory.h                  |   2 +
 arch/x86/kernel/crash.c                            |  26 +-
 arch/x86/kernel/kexec-bzimage64.c                  |  21 +
 arch/x86/kernel/machine_kexec_64.c                 |  22 +
 arch/x86/mm/pat/set_memory.c                       |  13 +
 drivers/cpufreq/powernow-k8.c                      |   2 +-
 drivers/gpu/drm/panel/panel-samsung-sofef00.c      |   4 +-
 drivers/iio/adc/qcom-spmi-rradc.c                  |   4 +-
 drivers/md/bcache/btree.c                          |   3 +-
 drivers/nvme/target/Kconfig                        |   2 +-
 drivers/power/supply/qcom_pmi8998_charger.c        |   4 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  20 -
 drivers/rapidio/rio.c                              | 103 -----
 drivers/rapidio/rio.h                              |   2 -
 drivers/rapidio/rio_cm.c                           |   6 -
 drivers/s390/char/vmlogrdr.c                       |   4 +-
 fs/bcachefs/util.h                                 |   3 +-
 fs/configfs/Kconfig                                |   1 -
 fs/nilfs2/btree.c                                  |   4 +-
 fs/nilfs2/direct.c                                 |   3 +
 fs/nilfs2/mdt.c                                    |   2 -
 fs/nilfs2/segment.c                                |  16 -
 fs/nilfs2/segment.h                                |   1 -
 fs/ocfs2/cluster/tcp.c                             |   2 +-
 fs/ocfs2/filecheck.c                               |   2 +-
 fs/ocfs2/quota_local.c                             |   2 +-
 fs/ocfs2/stackglue.c                               |   3 +-
 fs/pipe.c                                          |   3 +-
 fs/proc/base.c                                     |  12 +-
 fs/proc/task_mmu.c                                 |  12 +-
 fs/proc/task_nommu.c                               |   4 +-
 fs/squashfs/Kconfig                                |  21 +
 fs/squashfs/block.c                                |  28 ++
 fs/squashfs/super.c                                |   5 +
 fs/xfs/xfs_zone_gc.c                               |   2 -
 include/linux/compiler_types.h                     |   8 +-
 include/linux/crash_core.h                         |   7 +-
 include/linux/crash_dump.h                         |   2 +
 include/linux/habanalabs/hl_boot_if.h              |   2 +-
 include/linux/hung_task.h                          |  99 +++++
 include/linux/kernel.h                             |  14 +-
 include/linux/kexec.h                              |  34 ++
 include/linux/list.h                               |   8 +-
 include/linux/llist.h                              |  23 +-
 include/linux/oid_registry.h                       |   1 -
 include/linux/relay.h                              |   3 -
 include/linux/rio_drv.h                            |   5 -
 include/linux/scatterlist.h                        |  23 +-
 include/linux/sched.h                              |   6 +-
 include/linux/sched/task_stack.h                   |   2 -
 include/linux/semaphore.h                          |  15 +-
 include/linux/sort.h                               |  10 +
 include/linux/types.h                              |   4 +
 include/linux/util_macros.h                        |  66 +++
 include/soc/qcom/qcom-spmi-pmic.h                  |   2 +-
 include/trace/events/sched.h                       |  34 +-
 init/main.c                                        |  18 +-
 ipc/shm.c                                          |   5 +-
 kernel/Kconfig.kexec                               |  20 +-
 kernel/Makefile                                    |   1 +
 kernel/crash_dump_dm_crypt.c                       | 464 +++++++++++++++++++++
 kernel/crash_reserve.c                             |   2 +-
 kernel/delayacct.c                                 |  51 +--
 kernel/exit.c                                      |  70 ++--
 kernel/hung_task.c                                 |  55 ++-
 kernel/kexec_file.c                                |  81 +---
 kernel/locking/mutex.c                             |   5 +-
 kernel/locking/semaphore.c                         |  57 ++-
 kernel/panic.c                                     |   8 +-
 kernel/relay.c                                     | 111 +----
 kernel/vmcore_info.c                               |   4 +
 kernel/watchdog.c                                  |  94 ++++-
 lib/Kconfig.debug                                  |   6 -
 lib/errseq.c                                       |  13 +-
 lib/kstrtox.c                                      |   4 +
 lib/llist.c                                        |  22 -
 lib/oid_registry.c                                 |  25 +-
 lib/rbtree.c                                       |   8 +-
 lib/scatterlist.c                                  |  23 -
 lib/test_kmod.c                                    |  64 +--
 mm/maccess.c                                       |   2 +-
 samples/Kconfig                                    |   9 +-
 samples/hung_task/Makefile                         |   2 +-
 samples/hung_task/hung_task_mutex.c                |  66 ---
 samples/hung_task/hung_task_tests.c                |  97 +++++
 scripts/checkpatch.pl                              |  35 +-
 scripts/gdb/linux/cpus.py                          |   4 +-
 scripts/gdb/linux/symbols.py                       |  38 +-
 scripts/gdb/linux/utils.py                         |  22 +-
 scripts/spelling.txt                               |   2 +
 .../testing/selftests/filesystems/file_stressor.c  |   2 +-
 tools/testing/selftests/kmod/config                |   5 -
 tools/testing/selftests/mm/gup_longterm.c          |   2 +-
 .../thermal/intel/power_floor/power_floor_test.c   |   2 +-
 .../intel/workload_hint/workload_hint_test.c       |   4 +-
 111 files changed, 1599 insertions(+), 819 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-hardlockup_count
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-rcu_stall_count
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-softlockup_count
 create mode 100644 include/linux/hung_task.h
 create mode 100644 kernel/crash_dump_dm_crypt.c
 delete mode 100644 samples/hung_task/hung_task_mutex.c
 create mode 100644 samples/hung_task/hung_task_tests.c

