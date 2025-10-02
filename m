Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D1A1E9B37;
	Thu,  2 Oct 2025 22:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759444588; cv=none; b=heA3mIOFIIa2Mr2RhNnzZjbVoaToAlB1lciGn/9llpdKS+ZOTMun7li+WxLV56CmZtkYpSB7dYwr2VNOMDuM2F7LEv3hP92WX5SGe5eMzBmxCYu0yoUzYdkV+ZSJjsK9r7FbGkMDj3xgvxblL9F6QpIPx19KV64JqinoxigS+nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759444588; c=relaxed/simple;
	bh=gB5LseVaah0BdbQ1EcpV4iPc2oWSvKxKUWT3k3vmJXA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=YjzUC9OkM6hEsz0bjrLew9prADpdLn54m4uJOwdPTHgdA8XduxiBZvGfebf7aysXoEu/6mRbZe3ai//q+x0pSZuco9sHxg393VzSEab9exi7y66lwe9EMWb81eco7lW1LLg+R0s7VoVjFGq6GGRgsycmcVkKw/Ki1Gk5tc3t8xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JavLxU0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JavLxU0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC91FC4CEF4;
	Thu,  2 Oct 2025 22:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759444588;
	bh=gB5LseVaah0BdbQ1EcpV4iPc2oWSvKxKUWT3k3vmJXA=;
	h=Date:From:To:Cc:Subject:From;
	b=JavLxU0dTZI+rbGLfsNfto2CMThKVa3MckK8RZWp0WKJE9WIddezAtKBHkIf7Pvez
	 b/SFKGbARvm9PoHbQReXluhgJzDgi7PHd0WzPc+ztm0irhf1GVEBrssgh5TwbyF5hk
	 WOKBgldjqGVcMFJ49+KKZI34crX3uVGOov8zq+O4=
Date: Thu, 2 Oct 2025 15:36:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 6.18-rc1
Message-Id: <20251002153627.8890d5019e8e25a9df283e99@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull the mm.git non-MM updates for the 6.18-rcX
development cycle.

No merge conflicts are present and none are anticipated.

Thanks.


The following changes since commit e6b9dce0aeeb91dfc0974ab87f02454e24566182:

  Merge tag 'sound-6.17-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2025-09-02 13:38:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-02-15-29

for you to fetch changes up to 9f1c14c1de1bdde395f6cc893efa4f80a2ae3b2b:

  Squashfs: reject negative file sizes in squashfs_read_inode() (2025-09-28 11:36:15 -0700)

----------------------------------------------------------------
Patch series in this pull request:

- The 3 patch series "ida: Remove the ida_simple_xxx() API" from
  Christophe Jaillet completes the removal of this legacy IDR API.

- The 9 patch series "panic: introduce panic status function family"
  from Jinchao Wang provides a number of cleanups to the panic code and
  its various helpers, which were rather ad-hoc and scattered all over the
  place.

- The 5 patch series "tools/delaytop: implement real-time keyboard
  interaction support" from Fan Yu adds a few nice user-facing usability
  changes to the delaytop monitoring tool.

- The 3 patch series "efi: Fix EFI boot with kexec handover (KHO)" from
  Evangelos Petrongonas fixes a panic which was happening with the
  combination of EFI and KHO.

- The 2 patch series "Squashfs: performance improvement and a sanity
  check" from Phillip Lougher teaches squashfs's lseek() about
  SEEK_DATA/SEEK_HOLE.  A mere 150x speedup was measured for a well-chosen
  microbenchmark.

- Plus another 50-odd singleton patches all over the place.

----------------------------------------------------------------
Alexey Dobriyan (1):
      proc: test lseek on /proc/net/dev

Alistair Popple (1):
      cramfs: fix incorrect physical page address calculation

Bala-Vignesh-Reddy (1):
      selftests: proc: mark vsyscall strings maybe-unused

Brian Mak (1):
      x86/kexec: carry forward the boot DTB on kexec

Christophe JAILLET (3):
      idr test suite: remove usage of the deprecated ida_simple_xx() API
      ida: remove the ida_simple_xxx() API
      nvmem: update a comment related to struct nvmem_config

Coiby Xu (1):
      crash: add KUnit tests for crash_exclude_mem_range

Dan Carpenter (2):
      ocfs2: remove unnecessary NULL check in ocfs2_grab_folios()
      ocfs2: fix double free in user_cluster_connect()

Demi Marie Obenour (1):
      kernel: prevent prctl(PR_SET_PDEATHSIG) from racing with parent process exit

Dmitry Antipov (2):
      ocfs2: add suballoc slot check in ocfs2_validate_inode_block()
      ocfs2: avoid extra calls to strlen() after ocfs2_sprintf_system_inode_name()

Evangelos Petrongonas (2):
      kexec: introduce is_kho_boot()
      efi: support booting with kexec handover (KHO)

Fan Yu (5):
      tools/delaytop: add flexible sorting by delay field
      tools/delaytop: add memory verbose mode support
      tools/delaytop: add interactive mode with keyboard controls
      tools/delaytop: improve error handling for missing PSI support
      docs: update delaytop documentation for new interactive features

Feng Tang (3):
      lib/sys_info: handle sys_info_mask==0 case
      panic: refine the document for 'panic_print'
      panic: add note that 'panic_print' parameter is deprecated

Guan-Chun Wu (1):
      btree: simplify merge logic by using btree_last() return value

Huacai Chen (1):
      init: handle bootloader identifier in kernel parameters

Jinchao Wang (10):
      panic: introduce helper functions for panic state
      fbdev: use panic_in_progress() helper
      crash_core: use panic_try_start() in crash_kexec()
      panic: use panic_try_start() in nmi_panic()
      panic: use panic_try_start() in vpanic()
      printk/nbcon: use panic_on_this_cpu() helper
      panic/printk: replace this_cpu_in_panic() with panic_on_this_cpu()
      panic/printk: replace other_cpu_in_panic() with panic_on_other_cpu()
      watchdog: skip checks when panic is in progress
      panic: use angle-bracket include for panic.h

Joe Perches (1):
      checkpatch: allow http links of any length in commit logs

Johan Hovold (1):
      lib/genalloc: fix device leak in of_gen_pool_get()

Johannes Berg (1):
      panic: remove CONFIG_PANIC_ON_OOPS_VALUE

Krzysztof Kozlowski (2):
      coccinelle: of_table: handle SPI device ID tables
      coccinelle: platform_no_drv_owner: handle also built-in drivers

Kuan-Wei Chiu (2):
      test_firmware: use str_true_false() helper
      alloc_tag: use str_on_off() helper

Liao Yuanhong (3):
      lib/digsig: remove unnecessary memset
      x86/crash: remove redundant 0 value initialization
      kexec_core: remove redundant 0 value initialization

Masami Hiramatsu (Google) (1):
      hung_task: dump blocker task if it is not hung

Oleg Nesterov (3):
      fork: kill the pointless lower_32_bits() in create_io_thread(), kernel_thread(), and user_mode_thread()
      sched/task.h: fix the wrong comment on task_lock() nesting with tasklist_lock
      kernel/sys.c: fix the racy usage of task_lock(tsk->group_leader) in sys_prlimit64() paths

Petr Mladek (1):
      panic: clean up message about deprecated 'panic_print' parameter

Phillip Lougher (4):
      Squashfs: fix uninit-value in squashfs_get_parent
      Squashfs: add additional inode sanity checking
      Squashfs: add SEEK_DATA/SEEK_HOLE support
      Squashfs: reject negative file sizes in squashfs_read_inode()

Pratyush Yadav (1):
      kho: only fill kimage if KHO is finalized

Qianfeng Rong (1):
      ref_tracker: remove redundant __GFP_NOWARN

Randy Dunlap (2):
      list.h: add missing kernel-doc for basic macros
      kernel.h: add comments for enum system_states

Sahil Chandna (1):
      kallsyms: use kmalloc_array() instead of kmalloc()

Sergey Senozhatsky (1):
      panic: remove redundant panic-cpu backtrace

Sibi Sankar (1):
      MAINTAINERS: update Sibi Sankar's email address

Soham Bagchi (2):
      kcov: use write memory barrier after memcpy() in kcov_move_area()
      kcov: load acquire coverage count in user-space code

Suchit Karunakaran (1):
      checkpatch: suppress strscpy warnings for userspace tools

Tetsuo Handa (1):
      squashfs: verify inode mode when loading from disk

Thorsten Blum (2):
      ocfs2: remove commented out mlog() statements
      lib/decompress: use designated initializers for struct compress_format

Tio Zhang (1):
      fork: remove #ifdef CONFIG_LOCKDEP in copy_process()

Xichao Zhao (1):
      lib/fault-inject-usercopy.c: use PTR_ERR_OR_ZERO() to simplify code

ZhenguoYao (2):
      watchdog/softlockup: fix wrong output when watchdog_thresh < 3
      watchdog/softlockup: fix incorrect CPU utilization output during softlockup

fuqiang wang (1):
      x86/kexec: fix potential cmem->ranges out of memory

yili (1):
      ocfs2: fix super block reserved field offset comment

zhang jiao (1):
      fs/proc/base.c: fix the wrong format specifier

zhoumin (1):
      vfat: remove unused variable

 .mailmap                                           |   3 +-
 Documentation/accounting/delay-accounting.rst      |  91 ++--
 Documentation/admin-guide/kernel-parameters.txt    |   2 +-
 Documentation/admin-guide/sysctl/kernel.rst        |   2 +-
 Documentation/dev-tools/kcov.rst                   |   7 +-
 MAINTAINERS                                        |   2 +-
 arch/x86/kernel/crash.c                            |  25 +-
 arch/x86/kernel/kexec-bzimage64.c                  |  47 +-
 drivers/firmware/efi/efi-init.c                    |  29 +-
 drivers/video/fbdev/core/fbcon.c                   |   9 +-
 fs/cramfs/inode.c                                  |   2 +-
 fs/fat/dir.c                                       |   7 +-
 fs/ocfs2/alloc.c                                   |   3 +-
 fs/ocfs2/dlm/dlmmaster.c                           |  11 -
 fs/ocfs2/dlm/dlmrecovery.c                         |   1 -
 fs/ocfs2/inode.c                                   |   8 +
 fs/ocfs2/ioctl.c                                   |  18 +-
 fs/ocfs2/move_extents.c                            |   8 +-
 fs/ocfs2/ocfs2_fs.h                                |   2 +-
 fs/ocfs2/stack_user.c                              |   1 +
 fs/ocfs2/sysfile.c                                 |  12 +-
 fs/proc/base.c                                     |   2 +-
 fs/squashfs/file.c                                 | 137 ++++-
 fs/squashfs/inode.c                                |  39 +-
 fs/squashfs/squashfs.h                             |   1 +
 fs/squashfs/squashfs_fs.h                          |   1 +
 fs/squashfs/squashfs_fs_i.h                        |   2 +-
 include/linux/idr.h                                |   8 -
 include/linux/kernel.h                             |  21 +-
 include/linux/kexec.h                              |   5 +-
 include/linux/kexec_handover.h                     |   6 +
 include/linux/list.h                               |   8 +
 include/linux/moduleparam.h                        |  13 +
 include/linux/nvmem-provider.h                     |   2 +-
 include/linux/panic.h                              |   6 +
 include/linux/printk.h                             |   2 -
 include/linux/sched/task.h                         |   5 +-
 include/uapi/linux/kexec.h                         |   4 +
 init/main.c                                        |  12 +
 kernel/Kconfig.kexec                               |  11 +
 kernel/Makefile                                    |   1 +
 kernel/crash_core.c                                |  30 +-
 kernel/crash_core_test.c                           | 343 +++++++++++++
 kernel/fork.c                                      |  18 +-
 kernel/hung_task.c                                 |  78 +--
 kernel/kallsyms_selftest.c                         |   2 +-
 kernel/kcov.c                                      |   9 +
 kernel/kexec_core.c                                |   1 -
 kernel/kexec_file.c                                |   1 +
 kernel/kexec_handover.c                            |  22 +-
 kernel/panic.c                                     | 129 ++++-
 kernel/printk/internal.h                           |   1 -
 kernel/printk/nbcon.c                              |  14 +-
 kernel/printk/printk.c                             |  37 +-
 kernel/printk/printk_ringbuffer.c                  |   2 +-
 kernel/sys.c                                       |  32 +-
 kernel/watchdog.c                                  |  28 +-
 kernel/watchdog_perf.c                             |   4 +
 lib/Kconfig.debug                                  |   6 -
 lib/alloc_tag.c                                    |   3 +-
 lib/btree.c                                        |   4 +-
 lib/decompress.c                                   |  21 +-
 lib/digsig.c                                       |   1 -
 lib/dump_stack.c                                   |   2 +-
 lib/fault-inject-usercopy.c                        |   4 +-
 lib/genalloc.c                                     |   5 +-
 lib/ref_tracker.c                                  |   6 +-
 lib/sys_info.c                                     |   3 +-
 lib/test_firmware.c                                |   7 +-
 scripts/checkpatch.pl                              |  14 +-
 scripts/coccinelle/api/platform_no_drv_owner.cocci |   9 +
 scripts/coccinelle/misc/of_table.cocci             |  14 +-
 tools/accounting/delaytop.c                        | 571 +++++++++++++++------
 tools/testing/radix-tree/idr-test.c                |  16 +-
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 tools/testing/selftests/proc/proc-net-dev-lseek.c  |  68 +++
 tools/testing/selftests/proc/proc-pid-vm.c         |  12 +-
 78 files changed, 1619 insertions(+), 476 deletions(-)
 create mode 100644 kernel/crash_core_test.c
 create mode 100644 tools/testing/selftests/proc/proc-net-dev-lseek.c

