Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035281E51D;
	Sat, 21 Sep 2024 14:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726930620; cv=none; b=ST15xGz2ibpQMAS5YlHqDOqnVt9mvi9kkWLB+sqAtPDUGufdNkRa13WTw3YGEYZoAuKI6kx6OvkRqfYuJdIVW+8qOUrxg968x1oMtcykfhomUSM8lXHSH6e31c/pNNomVSLR+y2PXV0dqVjHAP9uEwoP8vEnX2kXKiV0/tjrRdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726930620; c=relaxed/simple;
	bh=bz4mb6O0I1c988DUhoXiWYvm+7zmxYZVEFszB4hx2hk=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Un1Fr8Kjdiepjt7BYoQ9vkjcmr1HJurNC+LdHO7L65HNe6Jh2wuzmxrrlUe9hbyFQLZkYi3Xn7oSCI2pKL0AqxMnStNLvLgz247XveTo++nUsSqjLEJaiiNxmlRUT2UpKWoH7KbbI4uNBCGj4uUkhyxxJ9U5fEoeghWDbqbGQH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n1I15vT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1I15vT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5A1C4CECD;
	Sat, 21 Sep 2024 14:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726930619;
	bh=bz4mb6O0I1c988DUhoXiWYvm+7zmxYZVEFszB4hx2hk=;
	h=Date:From:To:Cc:Subject:From;
	b=n1I15vT/qS546pYTJnRLhYldyWQ5nmCGL8mQuFDveNMtZgnJJYONNR/JvhFr3GZoX
	 kSb/ehfQAuFhWkL57tAFRRhyT09KGL+GE+ooTD89XA0OJTBWIOEQbQ4pZKPIA9DuqB
	 Z9bZmQ0quOAz8xIoBax0CwkKo0T2wmnCLDcywoKM=
Date: Sat, 21 Sep 2024 07:56:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 6.12-rc1
Message-Id: <20240921075655.ecdd22bad5e21c783aa14f2f@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please pull mm,git's non-MM updates for this development cycle,
thanks.


Known upcoming merge/build issues and their linux-ext resolutions
include:

fs/bcachefs/clock.c, vs bcachefs tree:
https://lkml.kernel.org/r/20240712105711.6dc900a2@canb.auug.org.au

include/linux/string_choices.h, vs kspp tree:
https://lkml.kernel.org/r/20240829153145.7f768337@canb.auug.org.au


A build issue vs 6ff4cd1160af ("lib/string_choices: Add
str_true_false()/str_false_true() helper"):
https://lkml.kernel.org/r/20240919091446.37087f60@canb.auug.org.au

And a build issue, vs kspp tree:
https://lkml.kernel.org/r/20240906171238.07709365@canb.auug.org.au




The following changes since commit 431c1646e1f86b949fa3685efc50b660a364c2b6:

  Linux 6.11-rc6 (2024-09-01 19:46:02 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stabl=
e-2024-09-21-07-52

for you to fetch changes up to 5e06e08939df1cafef97a8e04f4b88c2806b538a:

  list: test: increase coverage of list_test_list_replace*() (2024-09-17 01=
:11:20 -0700)

----------------------------------------------------------------
Many singleton patches - please see the various changelogs for details.

Quite a lot of nilfs2 work this time around.

Notable patch series in this pull request are:

"mul_u64_u64_div_u64: new implementation" by Nicolas Pitre, with
assistance from Uwe Kleine-K=F6nig.  Reimplement mul_u64_u64_div_u64() to
provide (much) more accurate results.  The current implementation was
causing Uwe some issues in the PWM drivers.

"xz: Updates to license, filters, and compression options" from Lasse
Collin.  Miscellaneous maintenance and kinor feature work to the xz
decompressor.

"Fix some GDB command error and add some GDB commands" from Kuan-Ying Lee.
Fixes and enhancements to the gdb scripts.

"treewide: add missing MODULE_DESCRIPTION() macros" from Jeff Johnson.
Adds lots of MODULE_DESCRIPTIONs, thus fixing lots of warnings about this.

"nilfs2: add support for some common ioctls" from Ryusuke Konishi.  Adds
various commonly-available ioctls to nilfs2.

"This series fixes a number of formatting issues in kernel doc comments"
from Ryusuke Konishi does that.

"nilfs2: prevent unexpected ENOENT propagation" from Ryusuke Konishi.  Fix
issues where -ENOENT was being unintentionally and inappropriately
returned to userspace.

"nilfs2: assorted cleanups" from Huang Xiaojia.

"nilfs2: fix potential issues with empty b-tree nodes" from Ryusuke
Konishi fixes some issues which can occur on corrupted nilfs2 filesystems.

"scripts/decode_stacktrace.sh: improve error reporting and usability" from
Luca Ceresoli does those things.

----------------------------------------------------------------
Alexey Dobriyan (1):
      proc: use __auto_type more

Alok Swaminathan (1):
      lib: glob.c: added null check for character class

Andrey Konovalov (1):
      kcov: don't instrument lib/find_bit.c

Andrii Nakryiko (1):
      fs/procfs: remove build ID-related code duplication in PROCMAP_QUERY

Andy Shevchenko (1):
      dimlib: use *-y instead of *-objs in Makefile

Breno Leitao (3):
      failcmd: add script file in MAINTAINERS
      fault-injection: enhance failcmd to exit on non-hex address input
      failcmd: make failcmd.sh executable

Chen Yu (1):
      kthread: fix task state in kthread worker if being frozen

Chi Zhiling (1):
      ocfs2: fix unexpected zeroing of virtual disk

Davidlohr Bueso (1):
      lib/rhashtable: cleanup fallback check in bucket_table_alloc()

Deshan Zhang (1):
      lib/lru_cache: fix spelling mistake "colision"->"collision"

Heming Zhao (1):
      ocfs2: fix the la space leak when unmounting an ocfs2 volume

Hongbo Li (3):
      lib/string_choices: add str_true_false()/str_false_true() helper
      mm: make use of str_true_false helper
      nfs make use of str_false_true helper

Huang Xiaojia (1):
      nilfs2: use common implementation of file type

I Hsin Cheng (2):
      list: test: fix tests for list_cut_position()
      list: test: increase coverage of list_test_list_replace*()

J. R. Okajima (1):
      lockdep: upper limit LOCKDEP_CHAINS_BITS

Jani Nikula (3):
      fault-inject: improve build for CONFIG_FAULT_INJECTION=3Dn
      drm/msm: clean up fault injection usage
      drm/xe: clean up fault injection usage

Jeff Johnson (4):
      lib: test_objpool: add missing MODULE_DESCRIPTION() macro
      crypto: arm/xor - add missing MODULE_DESCRIPTION() macro
      x86/mm: add testmmiotrace MODULE_DESCRIPTION()
      locking/ww_mutex/test: add MODULE_DESCRIPTION()

Jinjie Ruan (2):
      crash: fix crash memory reserve exceed system memory bug
      user_namespace: use kmemdup_array() instead of kmemdup() for multiple=
 allocation

Joseph Qi (1):
      ocfs2: cleanup return value and mlog in ocfs2_global_read_info()

Julian Sun (1):
      scripts: add macro_checker script to check unused parameters in macros

Kent Overstreet (1):
      scripts/decode_stacktrace.sh: nix-ify

Kuan-Wei Chiu (2):
      lib/bcd: optimize _bin2bcd() for improved performance
      ocfs2: remove custom swap functions in favor of built-in sort swap

Kuan-Ying Lee (5):
      scripts/gdb: fix timerlist parsing issue
      scripts/gdb: add iteration function for rbtree
      scripts/gdb: fix lx-mounts command error
      scripts/gdb: add 'lx-stack_depot_lookup' command.
      scripts/gdb: add 'lx-kasan_mem_to_shadow' command

Kunwu Chan (1):
      nilfs2: remove duplicate 'unlikely()' usage

Lasse Collin (16):
      MAINTAINERS: add XZ Embedded maintainer
      LICENSES: add 0BSD license text
      xz: switch from public domain to BSD Zero Clause License (0BSD)
      xz: fix comments and coding style
      xz: fix kernel-doc formatting errors in xz.h
      xz: improve the MicroLZMA kernel-doc in xz.h
      xz: Documentation/staging/xz.rst: Revise thoroughly
      xz: cleanup CRC32 edits from 2018
      xz: optimize for-loop conditions in the BCJ decoders
      xz: Add ARM64 BCJ filter
      xz: add RISC-V BCJ filter
      xz: use 128 MiB dictionary and force single-threaded mode
      xz: adjust arch-specific options for better kernel compression
      arm64: boot: add Image.xz support
      riscv: boot: add Image.xz support
      xz: remove XZ_EXTERN and extern from functions

Luca Ceresoli (3):
      scripts/decode_stacktrace.sh: remove find_module recursion and improv=
e error reporting
      scripts/decode_stacktrace.sh: clarify command line
      scripts/decode_stacktrace.sh: add '-h' flag

Markus Elfring (2):
      dyndbg: use seq_putc() in ddebug_proc_show()
      closures: use seq_putc() in debug_show()

Mateusz Guzik (1):
      ratelimit: convert flags to int to save 8 bytes in size

Nicolas Pitre (2):
      mul_u64_u64_div_u64: make it precise always
      mul_u64_u64_div_u64: basic sanity test

Ryusuke Konishi (28):
      nilfs2: add support for FS_IOC_GETUUID
      nilfs2: add support for FS_IOC_GETFSSYSFSPATH
      nilfs2: add support for FS_IOC_GETFSLABEL
      nilfs2: add support for FS_IOC_SETFSLABEL
      nilfs2: do not output warnings when clearing dirty buffers
      nilfs2: add missing argument description for __nilfs_error()
      nilfs2: add missing argument descriptions for ioctl-related helpers
      nilfs2: improve kernel-doc comments for b-tree node helpers
      nilfs2: fix incorrect kernel-doc declaration of nilfs_palloc_req stru=
cture
      nilfs2: add missing description of nilfs_btree_path structure
      nilfs2: describe the members of nilfs_bmap_operations structure
      nilfs2: fix inconsistencies in kernel-doc comments in segment.h
      nilfs2: fix missing initial short descriptions of kernel-doc comments
      nilfs2: treat missing sufile header block as metadata corruption
      nilfs2: treat missing cpfile header block as metadata corruption
      nilfs2: do not propagate ENOENT error from sufile during recovery
      nilfs2: do not propagate ENOENT error from sufile during GC
      nilfs2: do not propagate ENOENT error from nilfs_sufile_mark_dirty()
      nilfs2: use the BITS_PER_LONG macro
      nilfs2: separate inode type information from i_state field
      nilfs2: eliminate the shared counter and spinlock for i_generation
      nilfs2: do not repair reserved inode bitmap in nilfs_new_inode()
      nilfs2: remove sc_timer_task
      nilfs2: use kthread_create and kthread_stop for the log writer thread
      nilfs2: refactor nilfs_segctor_thread()
      nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
      nilfs2: determine empty node blocks as corrupted
      nilfs2: fix potential oob read in nilfs_btree_check_delete()

Sourabh Jain (1):
      Document/kexec: generalize crash hotplug description

Thorsten Blum (2):
      lib: checksum: use ARRAY_SIZE() to improve assert_setup_correct()
      ocfs2: use max() to improve ocfs2_dlm_seq_show()

Uros Bizjak (3):
      kexec: use atomic_try_cmpxchg_acquire() in kexec_trylock()
      lib/percpu_counter: add missing __percpu qualifier to a cast
      squashfs: fix percpu address space issues in decompressor_multi_percp=
u.c

Waiman Long (1):
      watchdog: handle the ENODEV failure case of lockup_detector_delay_ini=
t() separately

WangYuli (1):
      treewide: correct the typo 'retun'

Yang Ruibin (1):
      lib: fix the NULL vs IS_ERR() bug for debugfs_create_dir()

qasdev (1):
      ocfs2: fix shift-out-of-bounds UBSAN bug in ocfs2_verify_volume()

zhangjiao (1):
      tools/mm: rm thp_swap_allocator_test when make clean

 Documentation/ABI/testing/sysfs-devices-memory     |   6 +-
 Documentation/ABI/testing/sysfs-devices-system-cpu |   6 +-
 Documentation/admin-guide/mm/memory-hotplug.rst    |   5 +-
 Documentation/core-api/cpu_hotplug.rst             |  10 +-
 Documentation/staging/xz.rst                       | 157 ++++++--------
 LICENSES/deprecated/0BSD                           |  23 ++
 MAINTAINERS                                        |  14 ++
 arch/arm/lib/xor-neon.c                            |   1 +
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |   2 +-
 arch/arm64/boot/Makefile                           |   5 +-
 arch/powerpc/boot/xz_config.h                      |   3 -
 arch/riscv/Kconfig                                 |   1 +
 arch/riscv/Makefile                                |   6 +-
 arch/riscv/boot/Makefile                           |   3 +
 arch/x86/mm/testmmiotrace.c                        |   1 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.h           |   2 +-
 drivers/gpu/drm/msm/msm_debugfs.c                  |   2 -
 drivers/gpu/drm/msm/msm_drv.c                      |   3 +-
 drivers/gpu/drm/msm/msm_drv.h                      |   4 -
 drivers/gpu/drm/xe/xe_debugfs.c                    |   7 +-
 drivers/gpu/drm/xe/xe_gt.h                         |  10 +-
 drivers/infiniband/core/sa_query.c                 |   2 +-
 drivers/input/misc/wistron_btns.c                  |   2 +-
 drivers/iommu/iommufd/selftest.c                   |   1 +
 drivers/misc/xilinx_tmr_inject.c                   |   1 +
 drivers/mtd/nand/raw/nandsim.c                     |   2 +-
 drivers/nvme/host/fault_inject.c                   |   1 +
 drivers/scsi/bfa/bfa_fcs.c                         |   2 +-
 drivers/scsi/pmcraid.c                             |   2 +-
 drivers/ufs/core/ufs-fault-injection.c             |   1 +
 fs/nfs/nfs4xdr.c                                   |  11 +-
 fs/nilfs2/alloc.h                                  |   2 +-
 fs/nilfs2/bmap.c                                   |   2 +-
 fs/nilfs2/bmap.h                                   |  20 +-
 fs/nilfs2/btnode.c                                 |  63 +++++-
 fs/nilfs2/btree.c                                  |  12 +-
 fs/nilfs2/btree.h                                  |   1 +
 fs/nilfs2/cpfile.c                                 |  54 ++---
 fs/nilfs2/dat.c                                    |  17 +-
 fs/nilfs2/dir.c                                    |  44 +---
 fs/nilfs2/inode.c                                  |  79 ++-----
 fs/nilfs2/ioctl.c                                  | 109 +++++++++-
 fs/nilfs2/mdt.c                                    |   6 +-
 fs/nilfs2/nilfs.h                                  |  27 ++-
 fs/nilfs2/page.c                                   |  21 +-
 fs/nilfs2/page.h                                   |   4 +-
 fs/nilfs2/recovery.c                               |  11 +-
 fs/nilfs2/segment.c                                | 234 +++++++++++------=
----
 fs/nilfs2/segment.h                                |  10 +-
 fs/nilfs2/sufile.c                                 |  52 +++--
 fs/nilfs2/super.c                                  |   9 +
 fs/nilfs2/the_nilfs.c                              |   5 -
 fs/nilfs2/the_nilfs.h                              |   6 -
 fs/ocfs2/aops.c                                    |   2 +-
 fs/ocfs2/dir.c                                     |  12 +-
 fs/ocfs2/dlmglue.c                                 |   7 +-
 fs/ocfs2/localalloc.c                              |  19 ++
 fs/ocfs2/quota_global.c                            |  15 +-
 fs/ocfs2/refcounttree.c                            |  13 +-
 fs/ocfs2/super.c                                   |   4 +-
 fs/ocfs2/xattr.c                                   |  15 +-
 fs/proc/inode.c                                    |  31 +--
 fs/proc/task_mmu.c                                 |  15 --
 fs/squashfs/decompressor_multi_percpu.c            |   6 +-
 include/linux/decompress/unxz.h                    |   5 +-
 include/linux/fault-inject.h                       |  36 +++-
 include/linux/lru_cache.h                          |   4 +-
 include/linux/mmc/host.h                           |   1 +
 include/linux/ratelimit_types.h                    |   2 +-
 include/linux/string_choices.h                     |   6 +
 include/linux/xz.h                                 |  81 +++----
 include/ufs/ufshcd.h                               |   1 +
 init/Kconfig                                       |   5 +-
 kernel/crash_core.c                                |  33 +--
 kernel/crash_reserve.c                             |   3 +
 kernel/futex/core.c                                |   1 +
 kernel/kexec_internal.h                            |   3 +-
 kernel/kthread.c                                   |  10 +-
 kernel/locking/test-ww_mutex.c                     |   1 +
 kernel/user_namespace.c                            |   5 +-
 kernel/watchdog.c                                  |   5 +-
 lib/Kconfig.debug                                  |  12 +-
 lib/Makefile                                       |   1 +
 lib/bcd.c                                          |   4 +-
 lib/checksum_kunit.c                               |   9 +-
 lib/closure.c                                      |   2 +-
 lib/decompress_unxz.c                              |  40 ++--
 lib/dim/Makefile                                   |   2 +-
 lib/dynamic_debug.c                                |   4 +-
 lib/fault-inject.c                                 |   1 +
 lib/glob.c                                         |   2 +
 lib/list-test.c                                    |  10 +
 lib/lru_cache.c                                    |  10 +-
 lib/math/Makefile                                  |   1 +
 lib/math/div64.c                                   | 115 ++++++----
 lib/math/test_mul_u64_u64_div_u64.c                |  99 +++++++++
 lib/percpu_counter.c                               |   2 +-
 lib/rhashtable.c                                   |   2 +-
 lib/test_fpu_glue.c                                |   2 +-
 lib/test_objpool.c                                 |   3 +-
 lib/xz/Kconfig                                     |  13 +-
 lib/xz/xz_crc32.c                                  |  11 +-
 lib/xz/xz_dec_bcj.c                                | 191 +++++++++++++++--
 lib/xz/xz_dec_lzma2.c                              |  15 +-
 lib/xz/xz_dec_stream.c                             |  13 +-
 lib/xz/xz_dec_syms.c                               |  14 +-
 lib/xz/xz_dec_test.c                               |  12 +-
 lib/xz/xz_lzma2.h                                  |   5 +-
 lib/xz/xz_private.h                                |  40 ++--
 lib/xz/xz_stream.h                                 |   5 +-
 mm/fail_page_alloc.c                               |   1 +
 mm/failslab.c                                      |   1 +
 mm/memory-tiers.c                                  |   3 +-
 scripts/Makefile.lib                               |  13 +-
 scripts/decode_stacktrace.sh                       |  51 +++--
 scripts/gdb/linux/kasan.py                         |  44 ++++
 scripts/gdb/linux/proc.py                          |   4 +-
 scripts/gdb/linux/rbtree.py                        |  12 ++
 scripts/gdb/linux/stackdepot.py                    |  27 +++
 scripts/gdb/linux/timerlist.py                     |  31 +--
 scripts/gdb/vmlinux-gdb.py                         |   1 +
 scripts/macro_checker.py                           | 131 ++++++++++++
 scripts/xz_wrap.sh                                 | 158 +++++++++++++-
 tools/mm/Makefile                                  |   2 +-
 tools/testing/fault-injection/failcmd.sh           |  12 ++
 125 files changed, 1697 insertions(+), 859 deletions(-)
 create mode 100644 LICENSES/deprecated/0BSD
 create mode 100644 lib/math/test_mul_u64_u64_div_u64.c
 create mode 100644 scripts/gdb/linux/kasan.py
 create mode 100755 scripts/macro_checker.py
 mode change 100644 =3D> 100755 tools/testing/fault-injection/failcmd.sh

