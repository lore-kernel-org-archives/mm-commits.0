Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B203B2E36E8;
	Sun,  3 Aug 2025 19:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754250523; cv=none; b=BjoaE5GU2MbAeqOq1HUjS5TgqEDa/tR9NhmwwWroZKoHawe9XIOUTIuIIAMGbl/Sn+Rgk4gIp/HE2L+Qq5LLeDKUf8SB7+CmOJxkWkC7Vm/ApRvV+UOWHEvlICJa6fWBSDZD9A/vYBYMU8JOag08PQn6l0agv3UUmFFQaN4zWbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754250523; c=relaxed/simple;
	bh=oK3+32AASLLCn5GpgJ7coQwD5pzJnQ+87aLPltZf5yE=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=WazaETHbnDoSzu568QMmuYMRIkB4hpnchZLxwv5ddbA/y5hREVbsNvBxGx/8B39lZtkL63Xtkr/I+bluvBYidnJKus9TeFk2tsir8ynsZndBPJlhxbCxBvW1EEr4l55mzOcmKn3DyQeNuKwzQ5HFQQvwRJXlu+1cAQbodk5GS5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tum60HC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tum60HC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1454BC4CEEB;
	Sun,  3 Aug 2025 19:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754250523;
	bh=oK3+32AASLLCn5GpgJ7coQwD5pzJnQ+87aLPltZf5yE=;
	h=Date:From:To:Cc:Subject:From;
	b=tum60HC/vkdMclHZvlYV9q2MgWZhoMhDTOAFQPhQNul6rxsvEea1u3Ak0Svdu2NgK
	 7z35RFvwIPUhHPtr/26NA79dD7Fnk3R72YNRCFV/L56vb8dpYv7RPi2MVNbzDbDYZW
	 /26c7e1P0I6GVX808gDZ49M55IsqfV2PDXIEoEf4=
Date: Sun, 3 Aug 2025 12:48:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM udpates for 6.17-rc1
Message-Id: <20250803124842.f3412ea09d7396677e270ab8@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Linus, please merge mm.git's non-MM updates for the next -rc1 cycle,


I'm seeing two conflicts against your current tree.  Those, along with
their linux-next resolutions are:

kernel/panic.c, vs sysctl tree:
https://lkml.kernel.org/r/20250708190003.4eabc8ab@canb.auug.org.au

lib/Kconfig.debug, vs paulmck tree:
https://lkml.kernel.org/r/20250729104245.6be6957a@canb.auug.org.au


Thanks.


The following changes since commit d7b8f8e20813f0179d8ef519541a3527e7661d3a:

  Linux 6.16-rc5 (2025-07-06 14:10:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-08-03-12-47

for you to fetch changes up to 085dece6cc88b5c6fc6f2eca0403bfd2c5fbc7cb:

  tools/getdelays: add backward compatibility for taskstats version (2025-08-02 12:01:41 -0700)

----------------------------------------------------------------
Significant patch series in this pull request:

- The 2 patch series "squashfs: Remove page->mapping references" from
  Matthew Wilcox gets us closer to being able to remove page->mapping.

- The 5 patch series "relayfs: misc changes" from Jason Xing does some
  maintenance and minor feature addition work in relayfs.

- The 5 patch series "kdump: crashkernel reservation from CMA" from Jiri
  Bohac switches us from static preallocation of the kdump crashkernel's
  working memory over to dynamic allocation.  So the difficulty of
  a-priori estimation of the second kernel's needs is removed and the
  first kernel obtains extra memory.

- The 5 patch series "generalize panic_print's dump function to be used
  by other kernel parts" from Feng Tang implements some consolidation and
  rationalizatio of the various ways in which a faiing kernel splats
  information at the operator.

----------------------------------------------------------------
Ahelenia Ziemiańska (1):
      ocfs2/dlm: fix "take a while" typo

Alexander Graf (1):
      kexec: enable CMA based contiguous allocation

Andrew Morton (2):
      MAINTAINERS: add lib/raid6/ to "SOFTWARE RAID"
      init/Kconfig: restore CONFIG_BROKEN help text

Antonio Borneo (1):
      checkpatch: use utf-8 match for spell checking

Arnd Bergmann (1):
      lib: test_objagg: split test_hints_case() into two functions

Brian Norris (1):
      checkpatch: check for missing sentinels in ID arrays

Colin Ian King (3):
      squashfs: replace ;; with ; and end of fi declaration
      squashfs: fix incorrect argument to sizeof in kmalloc_array call
      samples: Kconfig: fix spelling mistake "instancess" -> "instances"

Dr. David Alan Gilbert (1):
      lib/xxhash: remove unused functions

Easwar Hariharan (1):
      coccinelle: misc: secs_to_jiffies: implement context and report modes

Elijah Wright (1):
      kernel: relay: use __GFP_ZERO in relay_alloc_buf

Fan Yu (1):
      tools/getdelays: add backward compatibility for taskstats version

Feng Tang (5):
      panic: clean up code for console replay
      panic: generalize panic_print's function to show sys info
      panic: add 'panic_sys_info' sysctl to take human readable string parameter
      panic: add 'panic_sys_info=' setup option for kernel cmdline
      panic: add note that panic_print sysctl interface is deprecated

Fushuai Wang (1):
      exit: fix misleading comment in forget_original_parent()

Herbert Xu (2):
      lib/raid6: replace custom zero page with ZERO_PAGE
      lib/raid6: update recov_rvv.c zero page usage

Ivan Pravdin (2):
      ocfs2: avoid NULL pointer dereference in dx_dir_lookup_rec()
      ocfs2: avoid potential ABBA deadlock by reordering tl_inode lock

Jason Xing (5):
      relayfs: abolish prev_padding
      relayfs: support a counter tracking if per-cpu buffers is full
      relayfs: introduce getting relayfs statistics function
      blktrace: use rbuf->stats.full as a drop indicator in relayfs
      relayfs: support a counter tracking if data is too big to write

Jiazi Li (1):
      kthread: update comment for __to_kthread

Jiri Bohac (5):
      Add a new optional ",cma" suffix to the crashkernel= command line option
      kdump: implement reserve_crashkernel_cma
      kdump, documentation: describe craskernel CMA reservation
      kdump: wait for DMA to finish when using CMA
      x86: implement crashkernel cma reservation

Jiri Olsa (1):
      uprobes: revert ref_ctr_offset in uprobe_unregister error path

Johannes Berg (1):
      scripts: gdb: move MNT_* constants to gdb-parsed

Julian Vetter (1):
      include/linux/jhash.h: replace __get_unaligned_cpu32 in jhash function

Kuan-Wei Chiu (3):
      lib/math/gcd: use static key to select implementation at runtime
      riscv: optimize gcd() code size when CONFIG_RISCV_ISA_ZBB is disabled
      riscv: optimize gcd() performance on RISC-V without Zbb extension

Lance Yang (2):
      locking/rwsem: make owner helpers globally available
      hung_task: extend hung task blocker tracking to rwsems

Li Chen (1):
      fs: fat: Prevent fsfuzzer from dominating the console

Lillian Berry (1):
      init/main.c: add warning when file specified in rdinit is inaccessible

Linus Walleij (1):
      fork: define a local GFP_VMAP_STACK

Lizhi Xu (1):
      ocfs2: reset folio to NULL when get folio fails

Long Li (1):
      ocfs2: remove redundant NULL check in rename path

Matt Fleming (1):
      stackdepot: make max number of pools boot-time configurable

Matthew Wilcox (Oracle) (2):
      squashfs: pass the inode to squashfs_readahead_fragment()
      squashfs: use folios in squashfs_bio_read_cached()

Mike Rapoport (Microsoft) (1):
      kho: add test for kexec handover

Moon Hee Lee (1):
      selftests: ptrace: add set_syscall_info to .gitignore

Nicolas Pitre (1):
      mul_u64_u64_div_u64: fix the division-by-zero behavior

OGAWA Hirofumi (1):
      fat: fix too many log in fat_chain_add()

Pasha Tatashin (2):
      fork: clean-up naming of vm_stack/vm_struct variables in vmap stacks code
      fork: clean up ifdef logic around stack allocation

Sachin Mokashi (1):
      mailmap: update Sachin Mokashi's email address

Su Hui (2):
      ocfs2: replace simple_strtol with kstrtol
      fs/proc/vmcore: a few cleanups for vmcore_add_device_dump()

Tetsuo Handa (2):
      ocfs2: embed actual values into ocfs2_sysfile_lock_key names
      ocfs2: update d_splice_alias() return code checking

Thorsten Blum (1):
      alpha: replace sprintf()/strcpy() with scnprintf()/strscpy()

Uros Bizjak (2):
      ucount: fix atomic_long_inc_below() argument type
      ucount: use atomic_long_try_cmpxchg() in atomic_long_inc_below()

Wang Yaxin (3):
      delaytop: add psi info to show system delay
      docs: update docs after introducing delaytop
      MAINTAINERS: add maintainers for delaytop

WangYuli (8):
      selftests/thermal: remove duplicate sprintf() call in workload_hint_test
      selftests/thermal: remove duplicate newlines in perror calls
      KVM: x86: fix typo "notifer"
      cxl: mce: fix typo "notifer"
      drm/xe: fix typo "notifer"
      net: mvneta: fix typo "notifer"
      xen/xenbus: fix typo "notifer"
      scripts/spelling.txt: add notifer||notifier to spelling.txt

Wei Nanxin (1):
      kcov: fix typo in comment of kcov_fault_in_area

Yaxin Wang (1):
      tools/accounting/delaytop: add delaytop to record top-n task delay

Zi Li (1):
      samples: enhance hung_task detector test with read-write semaphore support

fan.yu9@zte.com.cn (1):
      delaytop: enhance error logging and add PSI feature description

 .mailmap                                           |   1 +
 Documentation/accounting/delay-accounting.rst      |  56 ++
 Documentation/admin-guide/kdump/kdump.rst          |  21 +
 Documentation/admin-guide/kernel-parameters.txt    |  48 +-
 Documentation/admin-guide/sysctl/kernel.rst        |  20 +-
 MAINTAINERS                                        |  12 +
 arch/alpha/kernel/core_marvel.c                    |  11 +-
 arch/arm/kernel/setup.c                            |   2 +-
 arch/arm64/mm/init.c                               |   2 +-
 arch/loongarch/kernel/setup.c                      |   2 +-
 arch/mips/kernel/setup.c                           |   2 +-
 arch/powerpc/kernel/fadump.c                       |   2 +-
 arch/powerpc/kexec/core.c                          |   2 +-
 arch/powerpc/mm/nohash/kaslr_booke.c               |   2 +-
 arch/riscv/Kconfig                                 |   1 +
 arch/riscv/kernel/kexec_elf.c                      |   1 +
 arch/riscv/kernel/setup.c                          |   5 +
 arch/riscv/mm/init.c                               |   2 +-
 arch/s390/kernel/setup.c                           |   2 +-
 arch/sh/kernel/machine_kexec.c                     |   2 +-
 arch/x86/kernel/crash.c                            |  26 +-
 arch/x86/kernel/setup.c                            |   5 +-
 arch/x86/kvm/i8254.c                               |   4 +-
 crypto/async_tx/async_pq.c                         |   2 +-
 crypto/async_tx/async_raid6_recov.c                |   4 +-
 drivers/cxl/core/mce.h                             |   2 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c         |   3 +-
 drivers/gpu/drm/xe/xe_vm_types.h                   |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c             |   3 +-
 drivers/net/wwan/t7xx/t7xx_port_trace.c            |   2 +-
 fs/fat/fatent.c                                    |   2 +-
 fs/fat/misc.c                                      |   6 +-
 fs/ocfs2/aops.c                                    |   1 +
 fs/ocfs2/dir.c                                     |   8 +
 fs/ocfs2/dlm/dlmrecovery.c                         |   2 +-
 fs/ocfs2/inode.c                                   |  70 +-
 fs/ocfs2/move_extents.c                            |  19 +-
 fs/ocfs2/namei.c                                   |  11 +-
 fs/ocfs2/stack_user.c                              |  15 +-
 fs/proc/vmcore.c                                   |  29 +-
 fs/squashfs/block.c                                |  47 +-
 fs/squashfs/file.c                                 |   7 +-
 include/linux/crash_reserve.h                      |  15 +-
 include/linux/gcd.h                                |   3 +
 include/linux/hung_task.h                          |  18 +-
 include/linux/jhash.h                              |   8 +-
 include/linux/kexec.h                              |  10 +
 include/linux/raid/pq.h                            |  12 +-
 include/linux/relay.h                              |  24 +-
 include/linux/rwsem.h                              |  12 +
 include/linux/sys_info.h                           |  28 +
 include/linux/xxhash.h                             |  26 -
 include/uapi/linux/kexec.h                         |   1 +
 include/xen/xenbus.h                               |   2 +-
 init/Kconfig                                       |   4 +
 init/main.c                                        |   6 +-
 kernel/crash_core.c                                |  15 +
 kernel/crash_reserve.c                             |  68 +-
 kernel/events/uprobes.c                            |   4 +-
 kernel/exit.c                                      |   7 +-
 kernel/fork.c                                      |  95 ++-
 kernel/hung_task.c                                 |  29 +-
 kernel/kcov.c                                      |   2 +-
 kernel/kexec.c                                     |   2 +-
 kernel/kexec_core.c                                | 100 ++-
 kernel/kexec_file.c                                |  51 +-
 kernel/kexec_internal.h                            |   2 +-
 kernel/kthread.c                                   |  11 +-
 kernel/locking/rwsem.c                             |  31 +-
 kernel/panic.c                                     |  71 +-
 kernel/relay.c                                     |  69 +-
 kernel/trace/blktrace.c                            |  22 +-
 kernel/ucount.c                                    |  16 +-
 lib/Kconfig.debug                                  |  21 +
 lib/Makefile                                       |   3 +-
 lib/math/div64.c                                   |  13 +-
 lib/math/gcd.c                                     |  27 +-
 lib/raid6/algos.c                                  |   3 -
 lib/raid6/recov.c                                  |   6 +-
 lib/raid6/recov_avx2.c                             |   6 +-
 lib/raid6/recov_avx512.c                           |   6 +-
 lib/raid6/recov_loongarch_simd.c                   |  12 +-
 lib/raid6/recov_neon.c                             |   6 +-
 lib/raid6/recov_rvv.c                              |   6 +-
 lib/raid6/recov_s390xc.c                           |   6 +-
 lib/raid6/recov_ssse3.c                            |   6 +-
 lib/stackdepot.c                                   |  67 +-
 lib/sys_info.c                                     | 122 +++
 lib/test_kho.c                                     | 305 ++++++++
 lib/test_objagg.c                                  |  77 +-
 lib/xxhash.c                                       | 107 ---
 samples/Kconfig                                    |   9 +-
 samples/hung_task/hung_task_tests.c                |  81 +-
 scripts/checkpatch.pl                              |  33 +-
 scripts/coccinelle/misc/secs_to_jiffies.cocci      |  49 +-
 scripts/gdb/linux/constants.py.in                  |  12 +-
 scripts/spelling.txt                               |   1 +
 tools/accounting/Makefile                          |   2 +-
 tools/accounting/delaytop.c                        | 862 +++++++++++++++++++++
 tools/accounting/getdelays.c                       | 167 ++--
 tools/testing/selftests/kho/arm64.conf             |   9 +
 tools/testing/selftests/kho/init.c                 | 100 +++
 tools/testing/selftests/kho/vmtest.sh              | 183 +++++
 tools/testing/selftests/kho/x86.conf               |   7 +
 tools/testing/selftests/ptrace/.gitignore          |   1 +
 .../intel/workload_hint/workload_hint_test.c       |  16 +-
 107 files changed, 2931 insertions(+), 632 deletions(-)
 create mode 100644 include/linux/sys_info.h
 create mode 100644 lib/sys_info.c
 create mode 100644 lib/test_kho.c
 create mode 100644 tools/accounting/delaytop.c
 create mode 100644 tools/testing/selftests/kho/arm64.conf
 create mode 100644 tools/testing/selftests/kho/init.c
 create mode 100755 tools/testing/selftests/kho/vmtest.sh
 create mode 100644 tools/testing/selftests/kho/x86.conf

