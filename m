Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37840F4FA;
	Mon, 31 Mar 2025 01:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743384373; cv=none; b=BjJpBgFjob4YWbZ13PS5cjrw31G4h5a9dOb9B7mRSl7PBSXBtOCsBFCU+clGqXZ3hiKyB1uPYlDk6WK5RKLgXTsdyT0Y62dO+LYEAUn7LSZza1fwIAqw8cog8C+42F8EeOQ7864GEGCHvYp3kUA8iGGjLe1U0z/9i6jTeHR9ISM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743384373; c=relaxed/simple;
	bh=uZWaL8rXYRPsw8+ETZ5h0MS5tSziL8z+ySA4w9v2oKA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=fTZJJ6klmFcYe3YyQz+8+FRdMA6SapouukQFkh2wtI23YwQ7XD2WMit3GyuafO2kKh0pZf/dl0rjQiHehjXhIwP1VOGCyGvO5SAruiaBwPbQIsi5YBUVbn2MKBj2dc9s8DBMv1wijQG1rLP0Pqyw9YtpMPA5xKVNzHOAaAG2lN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HdJWWriE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HdJWWriE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA15AC4CEDD;
	Mon, 31 Mar 2025 01:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743384373;
	bh=uZWaL8rXYRPsw8+ETZ5h0MS5tSziL8z+ySA4w9v2oKA=;
	h=Date:From:To:Cc:Subject:From;
	b=HdJWWriEV10Ljz7WWz1xAy5JGgTdpLO0hdMO4qyPY1iFuvahbOxa+wqE5yVMenb8c
	 S5gGP2iruVobDXTDrdlI05Nt90/RDGGdIMV+WHQwfWVJ9boSc6s+hkSysO1s8FCEx8
	 bqzAI73HWmS2pLYcMy33Ekh1IQTbCOyQWBZlnUWI=
Date: Sun, 30 Mar 2025 18:26:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 6.15-rc1
Message-Id: <20250330182612.add2bb30fef22ca5bc3e2755@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull mm.git's non-MM updates for this development cycle.

I'm not seeing any present or future conflicts or build issues at this
time.

Thanks.



The following changes since commit 80e54e84911a923c40d7bee33a34c1b4be148d7a:

  Linux 6.14-rc6 (2025-03-09 13:45:25 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-03-30-18-23

for you to fetch changes up to 434333dd3f66f9d1ad387dabd2a565182a823f31:

  mailmap: consolidate email addresses of Alexander Sverdlin (2025-03-21 22:10:06 -0700)

----------------------------------------------------------------
- The 7 patch series "powerpc/crash: use generic crashkernel
  reservation" from Sourabh Jain changes powerpc's kexec code to use more
  of the generic layers.

- The 2 patch series "get_maintainer: report subsystem status
  separately" from Vlastimil Babka makes some long-requested improvements
  to the get_maintainer output.

- The 4 patch series "ucount: Simplify refcounting with rcuref_t" from
  Sebastian Siewior cleans up and optimizing the refcounting in the ucount
  code.

- The 12 patch series "reboot: support runtime configuration of
  emergency hw_protection action" from Ahmad Fatoum improves the ability
  for a driver to perform an emergency system shutdown or reboot.

- The 16 patch series "Converge on using secs_to_jiffies() part two"
  from Easwar Hariharan performs further migrations from
  msecs_to_jiffies() to secs_to_jiffies().

- The 7 patch series "lib/interval_tree: add some test cases and
  cleanup" from Wei Yang permits more userspace testing of kernel library
  code, adds some more tests and performs some cleanups.

- The 2 patch series "hung_task: Dump the blocking task stacktrace" from
  Masami Hiramatsu arranges for the hung_task detector to dump the stack
  of the blocking task and not just that of the blocked task.

- The 4 patch series "resource: Split and use DEFINE_RES*() macros" from
  Andy Shevchenko provides some cleanups to the resource definition
  macros.

- Plus the usual shower of singleton patches - please see the individual
  changelogs for details.

----------------------------------------------------------------
Ahmad Fatoum (12):
      reboot: replace __hw_protection_shutdown bool action parameter with an enum
      reboot: reboot, not shutdown, on hw_protection_reboot timeout
      docs: thermal: sync hardware protection doc with code
      reboot: describe do_kernel_restart's cmd argument in kernel-doc
      reboot: rename now misleading __hw_protection_shutdown symbols
      reboot: indicate whether it is a HARDWARE PROTECTION reboot or shutdown
      reboot: add support for configuring emergency hardware protection action
      regulator: allow user configuration of hardware protection action
      platform/chrome: cros_ec_lpc: prepare for hw_protection_shutdown removal
      dt-bindings: thermal: give OS some leeway in absence of critical-action
      thermal: core: allow user configuration of hardware protection action
      reboot: retire hw_protection_reboot and hw_protection_shutdown helpers

Alexander Sverdlin (1):
      mailmap: consolidate email addresses of Alexander Sverdlin

Andrii Nakryiko (2):
      mm,procfs: allow read-only remote mm access under CAP_PERFMON
      docs,procfs: document /proc/PID/* access permission checks

Andy Shevchenko (5):
      resource: split DEFINE_RES_NAMED_DESC() out of DEFINE_RES_NAMED()
      resource: replace open coded variant of DEFINE_RES_NAMED_DESC()
      resource: replace open coded variants of DEFINE_RES_*_NAMED()
      resource: replace open coded variant of DEFINE_RES()
      relay: use kasprintf() instead of fixed buffer formatting

Antonio Quartulli (1):
      scripts/gdb/linux/symbols.py: address changes to module_sect_attrs

Bart Van Assche (1):
      fs/procfs: fix the comment above proc_pid_wchan()

Brendan Jackman (1):
      scripts/gdb: add $lx_per_cpu_ptr()

Carlos Bilbao (1):
      .mailmap: remove redundant mappings of emails

Easwar Hariharan (14):
      coccinelle: misc: secs_to_jiffies: Patch expressions too
      scsi: lpfc: convert timeouts to secs_to_jiffies()
      accel/habanalabs: convert timeouts to secs_to_jiffies()
      ALSA: ac97: convert timeouts to secs_to_jiffies()
      btrfs: convert timeouts to secs_to_jiffies()
      ata: libata-zpodd: convert timeouts to secs_to_jiffies()
      xfs: convert timeouts to secs_to_jiffies()
      power: supply: da9030: convert timeouts to secs_to_jiffies()
      nvme: convert timeouts to secs_to_jiffies()
      spi: spi-fsl-lpspi: convert timeouts to secs_to_jiffies()
      spi: spi-imx: convert timeouts to secs_to_jiffies()
      platform/x86/amd/pmf: convert timeouts to secs_to_jiffies()
      platform/x86: thinkpad_acpi: convert timeouts to secs_to_jiffies()
      RDMA/bnxt_re: convert timeouts to secs_to_jiffies()

Guilherme G. Piccoli (1):
      scripts: add script to extract built-in firmware blobs

Harry Yoo (1):
      MAINTAINERS: mailmap: update Hyeonggon's name and email address

I Hsin Cheng (1):
      lib/plist.c: add shortcut for plist_requeue()

Ilya Leoshkevich (1):
      scripts/gdb/symbols: determine KASLR offset on s390

Jarkko Sakkinen (1):
      mailmap: remove never used @parity.io email

Kuan-Wei Chiu (1):
      lib min_heap: use size_t for array size and index variables

Masami Hiramatsu (Google) (2):
      hung_task: show the blocker task if the task is hung on mutex
      samples: add hung_task detector mutex blocking sample

Mateusz Guzik (1):
      signal: avoid clearing TIF_SIGPENDING in recalc_sigpending() if unset

Matthew Wilcox (Oracle) (2):
      ocfs2: use memcpy_to_folio() in ocfs2_symlink_get_block()
      ocfs2: remove reference to bh->b_page

Philipp Hahn (1):
      checkpatch: describe --min-conf-desc-length

Sebastian Andrzej Siewior (4):
      rcu: provide a static initializer for hlist_nulls_head
      ucount: replace get_ucounts_or_wrap() with atomic_inc_not_zero()
      ucount: use RCU for ucounts lookups
      ucount: use rcuref_t for reference counting

Sourabh Jain (7):
      kexec: initialize ELF lowest address to ULONG_MAX
      crash: remove an unused argument from reserve_crashkernel_generic()
      crash: let arch decide usable memory range in reserved area
      powerpc/crash: use generic APIs to locate memory hole for kdump
      powerpc/crash: preserve user-specified memory limit
      powerpc: insert System RAM resource to prevent crashkernel conflict
      powerpc/crash: use generic crashkernel reservation

Thorsten Blum (1):
      watchdog/perf: optimize bytes copied and remove manual NUL-termination

Vasiliy Kovalev (1):
      ocfs2: validate l_tree_depth to avoid out-of-bounds access

Vlastimil Babka (2):
      get_maintainer: add --substatus for reporting subsystem status
      get_maintainer: stop reporting subsystem status as maintainer role

Wei Yang (7):
      lib/rbtree: enable userland test suite for rbtree related data structure
      lib/rbtree: split tests
      lib/rbtree: add random seed
      lib/interval_tree: add test case for interval_tree_iter_xxx() helpers
      lib/interval_tree: add test case for span iteration
      lib/interval_tree: skip the check before go to the right subtree
      lib/interval_tree: fix the comment of interval_tree_span_iter_next_gap()

Yan Zhao (1):
      kexec_core: accept unaccepted kexec segments' destination addresses

Yang Yang (1):
      MAINTAINERS: add Yang Yang as a co-maintainer of PER-TASK DELAY ACCOUNTING

Yury Norov (1):
      lib/zlib: drop EQUAL macro

Zijun Hu (2):
      rhashtable: remove needless return in three void APIs
      cpu: remove needless return in void API suspend_enable_secondary_cpus()

 .mailmap                                           |  11 +-
 Documentation/ABI/testing/sysfs-kernel-reboot      |   8 +
 Documentation/admin-guide/kernel-parameters.txt    |   6 +
 .../devicetree/bindings/thermal/thermal-zones.yaml |   5 +-
 Documentation/driver-api/thermal/sysfs-api.rst     |  25 +-
 Documentation/filesystems/proc.rst                 |  10 +
 MAINTAINERS                                        |   3 +-
 arch/arm64/mm/init.c                               |   6 +-
 arch/loongarch/kernel/setup.c                      |   5 +-
 arch/powerpc/Kconfig                               |   3 +
 arch/powerpc/include/asm/crash_reserve.h           |   8 +
 arch/powerpc/include/asm/kexec.h                   |  10 +-
 arch/powerpc/kernel/prom.c                         |   2 +-
 arch/powerpc/kexec/core.c                          |  96 +++-----
 arch/powerpc/kexec/file_load_64.c                  | 259 +--------------------
 arch/powerpc/mm/mem.c                              |   2 +-
 arch/riscv/mm/init.c                               |   6 +-
 arch/x86/kernel/setup.c                            |   6 +-
 .../accel/habanalabs/common/command_submission.c   |   2 +-
 drivers/accel/habanalabs/common/debugfs.c          |   2 +-
 drivers/accel/habanalabs/common/device.c           |   2 +-
 drivers/accel/habanalabs/common/habanalabs_drv.c   |   2 +-
 drivers/ata/libata-zpodd.c                         |   3 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   2 +-
 drivers/nvme/host/core.c                           |   6 +-
 drivers/platform/chrome/cros_ec_lpc.c              |   2 +-
 drivers/platform/x86/amd/pmf/acpi.c                |   2 +-
 drivers/platform/x86/thinkpad_acpi.c               |   2 +-
 drivers/power/supply/da9030_battery.c              |   3 +-
 drivers/regulator/core.c                           |   4 +-
 drivers/regulator/irq_helpers.c                    |  16 +-
 drivers/scsi/lpfc/lpfc.h                           |   3 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  11 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  10 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  12 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  41 ++--
 drivers/scsi/lpfc/lpfc_vport.c                     |   2 +-
 drivers/spi/spi-fsl-lpspi.c                        |   2 +-
 drivers/spi/spi-imx.c                              |   2 +-
 drivers/thermal/thermal_core.c                     |  17 +-
 drivers/thermal/thermal_core.h                     |   1 +
 drivers/thermal/thermal_of.c                       |   7 +-
 fs/btrfs/disk-io.c                                 |   6 +-
 fs/ocfs2/alloc.c                                   |   8 +
 fs/ocfs2/aops.c                                    |  17 +-
 fs/ocfs2/quota_global.c                            |   2 +-
 fs/proc/base.c                                     |   2 +-
 fs/xfs/xfs_icache.c                                |   2 +-
 fs/xfs/xfs_sysfs.c                                 |   8 +-
 include/linux/cpu.h                                |   2 +-
 include/linux/crash_reserve.h                      |  11 +-
 include/linux/interval_tree_generic.h              |   8 +-
 include/linux/ioport.h                             |   9 +-
 include/linux/kexec.h                              |   9 +
 include/linux/list_nulls.h                         |   1 +
 include/linux/min_heap.h                           |  12 +-
 include/linux/mutex.h                              |   2 +
 include/linux/reboot.h                             |  36 ++-
 include/linux/rhashtable.h                         |   6 +-
 include/linux/sched.h                              |   4 +
 include/linux/types.h                              |   1 +
 include/linux/user_namespace.h                     |  15 +-
 include/uapi/linux/capability.h                    |   1 +
 kernel/crash_reserve.c                             |   9 +-
 kernel/fork.c                                      |  13 +-
 kernel/hung_task.c                                 |  38 +++
 kernel/kexec_core.c                                |  10 +
 kernel/kexec_elf.c                                 |   2 +-
 kernel/kexec_file.c                                |  12 +
 kernel/locking/mutex.c                             |  14 ++
 kernel/reboot.c                                    | 140 ++++++++---
 kernel/relay.c                                     |   3 +-
 kernel/resource.c                                  |  18 +-
 kernel/signal.c                                    |   7 +-
 kernel/ucount.c                                    |  95 ++++----
 kernel/watchdog_perf.c                             |   6 +-
 lib/Kconfig.debug                                  |  11 +
 lib/interval_tree.c                                |  12 +-
 lib/interval_tree_test.c                           | 237 +++++++++++++++++--
 lib/min_heap.c                                     |   4 +-
 lib/plist.c                                        |  12 +
 lib/rbtree_test.c                                  |  30 ++-
 lib/zlib_deflate/deflate.c                         |   6 +-
 samples/Kconfig                                    |   9 +
 samples/Makefile                                   |   1 +
 samples/hung_task/Makefile                         |   2 +
 samples/hung_task/hung_task_mutex.c                |  66 ++++++
 scripts/checkpatch.pl                              |   5 +-
 scripts/coccinelle/misc/secs_to_jiffies.cocci      |  10 +
 scripts/extract-fwblobs                            |  30 +++
 scripts/gdb/linux/cpus.py                          |  22 +-
 scripts/gdb/linux/symbols.py                       |  44 +++-
 scripts/gdb/linux/utils.py                         |  35 +++
 scripts/get_maintainer.pl                          |  49 ++--
 sound/pci/ac97/ac97_codec.c                        |   3 +-
 tools/include/asm/timex.h                          |  13 ++
 tools/include/linux/bitmap.h                       |  21 ++
 tools/include/linux/container_of.h                 |  18 ++
 tools/include/linux/kernel.h                       |  14 +-
 tools/include/linux/math64.h                       |   5 +
 tools/include/linux/moduleparam.h                  |   7 +
 tools/include/linux/prandom.h                      |  51 ++++
 tools/include/linux/slab.h                         |   1 +
 tools/include/linux/types.h                        |   2 +
 tools/lib/bitmap.c                                 |  20 ++
 tools/lib/slab.c                                   |  16 ++
 tools/testing/rbtree/Makefile                      |  33 +++
 tools/testing/rbtree/interval_tree_test.c          |  58 +++++
 tools/testing/rbtree/rbtree_test.c                 |  48 ++++
 tools/testing/rbtree/test.h                        |   4 +
 tools/testing/shared/interval_tree-shim.c          |   5 +
 tools/testing/shared/linux/interval_tree.h         |   7 +
 tools/testing/shared/linux/interval_tree_generic.h |   2 +
 tools/testing/shared/linux/rbtree.h                |   8 +
 tools/testing/shared/linux/rbtree_augmented.h      |   7 +
 tools/testing/shared/linux/rbtree_types.h          |   8 +
 tools/testing/shared/rbtree-shim.c                 |   6 +
 118 files changed, 1426 insertions(+), 674 deletions(-)
 create mode 100644 arch/powerpc/include/asm/crash_reserve.h
 create mode 100644 samples/hung_task/Makefile
 create mode 100644 samples/hung_task/hung_task_mutex.c
 create mode 100755 scripts/extract-fwblobs
 create mode 100644 tools/include/asm/timex.h
 create mode 100644 tools/include/linux/container_of.h
 create mode 100644 tools/include/linux/moduleparam.h
 create mode 100644 tools/include/linux/prandom.h
 create mode 100644 tools/testing/rbtree/Makefile
 create mode 100644 tools/testing/rbtree/interval_tree_test.c
 create mode 100644 tools/testing/rbtree/rbtree_test.c
 create mode 100644 tools/testing/rbtree/test.h
 create mode 100644 tools/testing/shared/interval_tree-shim.c
 create mode 100644 tools/testing/shared/linux/interval_tree.h
 create mode 100644 tools/testing/shared/linux/interval_tree_generic.h
 create mode 100644 tools/testing/shared/linux/rbtree.h
 create mode 100644 tools/testing/shared/linux/rbtree_augmented.h
 create mode 100644 tools/testing/shared/linux/rbtree_types.h
 create mode 100644 tools/testing/shared/rbtree-shim.c

