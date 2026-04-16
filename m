Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C20913AA2D;
	Thu, 16 Apr 2026 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776358353; cv=none; b=b3Y++Zl4UxwTRTDeYuuzcYF1g9U9uMOSQuDiE7rDQmy6unYcU1wgzw5XTlJz08cvvQYWL1nvtpEHRQGGxEBtem/OAVdL3Spcxw+8Wp/CWHPaalSKS7PC1PjUG730jfihoaCGv8Vr3xxYgbVq+ZftSX9MoWEPzk1HiHBAeKqeD8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776358353; c=relaxed/simple;
	bh=cLJUJCUYeE3Xc76rcLuCrHl675/j2kCxx1UzAQsG/qA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Y4Ju5DD2U+eNn5zwh3Gh7IAjaJv7tNCWH8fK21vLL8vyhUK3a6wf2UzVJPUrd8+XjvJIrhYZSGYgNAhLLxc2yehcNpqp3DPcmt/XD9dc6nliT+yaRCYVZLRyVY1ZQ4TafY51AypVr0mNyNKbPDyLsuEyeyGRSMPf4MIg++AWY9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r1UXIEtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r1UXIEtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25F6C2BCAF;
	Thu, 16 Apr 2026 16:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776358353;
	bh=cLJUJCUYeE3Xc76rcLuCrHl675/j2kCxx1UzAQsG/qA=;
	h=Date:From:To:Cc:Subject:From;
	b=r1UXIEtX4b7Sn5RwLHkLxz7+8FhJG6P0GHaoQaq9IFq0K2Y3evpOhsUKCuKjv3UPX
	 WUQqnypFYz1LbTUajmrHqji4sA68tyZYcyB52HzvsR3TGiU4MEWZh9sIwit+m2R+ud
	 3+ZXiVRfynX3wCQKfXN7C703oRMt6xIyljJu3I5I=
Date: Thu, 16 Apr 2026 09:52:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 7.1-rc1
Message-Id: <20260416095229.d83bcb0f00859adcd5f90853@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please merge this batch of other-then-MM updates for the 7.1-rc1
cycle, thanks.

I'm seeing one conflict at this time, in fs/ocfs2/dir.c.  The
linux-next resolution is at
https://lore.kernel.org/adOxjbi2byrIet3y@sirena.org.uk.

(Looks nasty, but a peek at 0b2600f81cefc shows what's going on).



The following changes since commit 24f9515de8778410e4b84c85b196c9850d2c1e18:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2026-=
03-24 13:11:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stabl=
e-2026-04-15-04-20

for you to fetch changes up to 70b672833f4025341c11b22c7f83778a5cd611bc:

  ocfs2: validate group add input before caching (2026-04-15 02:15:03 -0700)

----------------------------------------------------------------
mm.git review status for linus..mm-nonmm-stable

Total patches:       126
Reviews/patch:       0.92
Reviewed rate:       76%

- The 2 patch series "pid: make sub-init creation retryable" from Oleg
  Nesterov increases the robustness of our creation of init in a new
  namespace.  By clearing away some historical cruft which is no longer
  needed.  Also some documentation fixups are provided.

- The 2 patch series "selftests/fchmodat2: Error handling and general"
  from Mark Brown has a fixup and a cleanup for the fchmodat2() syscall
  selftest.

- The 3 patch series "lib: polynomial: Move to math/ and clean up" from
  Andy Shevchenko does as advertised.

- The 3 patch series "hung_task: Provide runtime reset interface for
  hung task detector" from Aaron Tomlin gives administrators the ability
  to zero out /proc/sys/kernel/hung_task_detect_count.

- The 2 patch series "tools/getdelays: use the static UAPI headers from
  tools/include/uapi" from Thomas Wei=DFschuh teaches getdelays to use the
  in-kernel UAPI headers rather than the system-provided ones.

- The 5 patch series "watchdog/hardlockup: Improvements to hardlockup"
  from Mayank Rungta provides several cleanups and fixups to the
  hardlockup detector code and its documentation.

- The 2 patch series "lib/bch: fix undefined behavior from signed
  left-shifts" from Josh Law provides a couple of small/theoretical fixes
  in the bch code.

- The 2 patch series "ocfs2/dlm: fix two bugs in dlm_match_regions()"
  from Junrui Luo does what is claims.

- The 27 patch series "cleanup the RAID5 XOR library" from Christoph
  Hellwig is a quite far-reaching cleanup to this code.  I can't do better
  than to quote Christoph:

    The XOR library used for the RAID5 parity is a bit of a mess right
    now.  The main file sits in crypto/ despite not being cryptography and
    not using the crypto API, with the generic implementations sitting in
    include/asm-generic and the arch implementations sitting in an asm/
    header in theory.  The latter doesn't work for many cases, so
    architectures often build the code directly into the core kernel, or
    create another module for the architecture code.

    Change this to a single module in lib/ that also contains the
    architecture optimizations, similar to the library work Eric Biggers
    has done for the CRC and crypto libraries later.  After that it
    changes to better calling conventions that allow for smarter
    architecture implementations (although none is contained here yet),
    and uses static_call to avoid indirection function call overhead.

- The 2 patch series "lib/list_sort: Clean up list_sort() scheduling
  workarounds" from Kuan-Wei Chiu cleans up this library code by removing
  a hacky thing which was added for UBIFS, which UBIFS doesn't actually
  need.

- The 5 patch series "Fix bugs in extract_iter_to_sg()" from Christian
  Ehrhardt fixes a few bugs in the scatterlist code, adds in-kernel tests
  for the now-fixed bugs and fixes a leak in the test itself.

- The 3 patch series "kdump: Enable LUKS-encrypted dump target support
  in ARM64 and PowerPC" from Coiby Xu eenables support of the
  LUKS-encrypted device dump target on arm64 and powerpc.

- The 4 patch series "ocfs2: consolidate extent list validation into
  block read callbacks" from Joseph Qi addresses ocfs2's validation of
  extent list fields - cleanup, simplification, robustness.  (Kernel test
  robot loves mounting corrupted fs images!)

----------------------------------------------------------------
Aaron Tomlin (3):
      hung_task: refactor detection logic and atomicise detection count
      hung_task: enable runtime reset of hung_task_detect_count
      hung_task: explicitly report I/O wait state in log output

Aleksei Oladko (1):
      selftests: fix ARCH normalization to handle command-line argument

Alexey Velichayshiy (1):
      ocfs2: remove redundant error code assignment

Andy Shevchenko (3):
      lib: polynomial: move to math/ subfolder
      lib: math: polynomial: don't use 'proxy' headers
      lib: math: polynomial: remove link to non-exist file and fix spelling

Askar Safin (1):
      .get_maintainer.ignore: add Askar

Benjamin Berg (1):
      scripts/gdb/symbols: handle module path parameters

Christian A. Ehrhardt (5):
      lib/scatterlist: fix length calculations in extract_kvec_to_sg
      lib/scatterlist: fix temp buffer in extract_user_to_sg()
      lib: kunit_iov_iter: fix memory leaks
      lib: kunit_iov_iter: improve error detection
      lib: kunit_iov_iter: add tests for extract_iter_to_sg

Christoph Hellwig (27):
      xor: assert that xor_blocks is not call from interrupt context
      arm/xor: remove in_interrupt() handling
      arm64/xor: fix conflicting attributes for xor_block_template
      um/xor: cleanup xor.h
      xor: move to lib/raid/
      xor: small cleanups
      xor: cleanup registration and probing
      xor: split xor.h
      xor: remove macro abuse for XOR implementation registrations
      xor: move generic implementations out of asm-generic/xor.h
      alpha: move the XOR code to lib/raid/
      arm: move the XOR code to lib/raid/
      arm64: move the XOR code to lib/raid/
      loongarch: move the XOR code to lib/raid/
      powerpc: move the XOR code to lib/raid/
      riscv: move the XOR code to lib/raid/
      sparc: move the XOR code to lib/raid/
      s390: move the XOR code to lib/raid/
      x86: move the XOR code to lib/raid/
      xor: avoid indirect calls for arm64-optimized ops
      xor: make xor.ko self-contained in lib/raid/
      xor: add a better public API
      async_xor: use xor_gen
      btrfs: use xor_gen
      xor: pass the entire operation to the low-level ops
      xor: use static_call for xor_gen
      xor: add a kunit test case

Coiby Xu (3):
      crash_dump/dm-crypt: don't print in arch-specific code
      crash: align the declaration of crash_load_dm_crypt_keys with CONFIG_=
CRASH_DM_CRYPT
      arm64,ppc64le/kdump: pass dm-crypt keys to kdump kernel

David Carlier (1):
      ocfs2: use get_random_u32() where appropriate

Eric Biggers (2):
      kernel/crash: remove inclusion of crypto/sha1.h
      kernel/kexec: remove inclusion of crypto/hash.h

Guru Das Srinagesh (1):
      mailmap: update Guru Das Srinagesh's email address

G=FCnther Noack (1):
      scripts/spelling.txt: add "binded||bound"

Heming Zhao (2):
      ocfs2: fix deadlock when creating quota file
      ocfs2: split transactions in dio completion to avoid credit exhaustion

Hisam Mehboob (1):
      CREDITS: simplify the end-of-file alphabetical order comment

Inseob Kim (1):
      lib: parser: fix match_wildcard to correctly handle trailing stars

Jaime Saguillo Revilla (1):
      proc: array: drop stale FIXME about RCU in task_sig()

Joseph Qi (5):
      ocfs2: fix possible deadlock between unlink and dio_end_io_write
      ocfs2: validate dx_root extent list fields during block read
      ocfs2: remove empty extent list check in ocfs2_dx_dir_lookup_rec()
      ocfs2: validate extent block list fields during block read
      ocfs2: remove redundant l_next_free_rec check in __ocfs2_find_path()

Josh Law (18):
      lib: glob: add missing SPDX-License-Identifier
      lib: glob: fix grammar and replace non-inclusive terminology
      lib: glob: add explicit include for export.h
      lib: glob: replace bitwise OR with logical operation on boolean
      lib/glob: clean up "bool abuse" in pointer arithmetic
      lib/uuid: fix typo "reversion" to "revision" in comment
      lib/inflate: fix memory leak in inflate_fixed() on inflate_codes() fa=
ilure
      lib/inflate: fix memory leak in inflate_dynamic() on inflate_codes() =
failure
      lib/inflate: fix grammar in comment: "variable" to "variables"
      lib/inflate: fix typo "This results" to "The results" in comment
      lib/bug: fix inconsistent capitalization in BUG message
      lib/bug: remove unnecessary variable initializations
      lib: decompress_bunzip2: fix 32-bit shift undefined behavior
      lib/ts_bm: fix integer overflow in pattern length calculation
      lib/ts_kmp: fix integer overflow in pattern length calculation
      lib/glob: initialize back_str to silence uninitialized variable warni=
ng
      lib/bch: fix signed left-shift undefined behavior
      lib/bch: fix signed shift overflow in build_mod8_tables

Junrui Luo (2):
      ocfs2/dlm: validate qr_numregions in dlm_match_regions()
      ocfs2/dlm: fix off-by-one in dlm_match_regions() region comparison

Kuan-Wei Chiu (2):
      ubifs: remove unnecessary cond_resched() from list_sort() compare
      lib/list_sort: remove dummy cmp() calls to speed up merge_final()

Linus Walleij (1):
      fork: zero vmap stack using clear_pages() instead of memset()

Mark Brown (2):
      selftests/fchmodat2: clean up temporary files and directories
      selftests/fchmodat2: use ksft_finished()

Masami Hiramatsu (Google) (1):
      decode_stacktrace: decode caller address

Matteo Croce (1):
      get_maintainer: add ** glob pattern support

Mayank Rungta (5):
      watchdog: return early in watchdog_hardlockup_check()
      watchdog: update saved interrupts during check
      doc: watchdog: clarify hardlockup detection timing
      watchdog/hardlockup: improve buddy system detection timeliness
      doc: watchdog: document buddy detector

Michal Grzedzicki (1):
      unshare: fix nsproxy leak in ksys_unshare() on set_cred_ucounts() fai=
lure

Oleg Nesterov (5):
      exit: kill unnecessary thread_group_leader() checks in exit_notify() =
and do_notify_parent()
      complete_signal: kill always-true "core_state || !SIGNAL_GROUP_EXIT" =
check
      pid: make sub-init creation retryable
      pid: document the PIDNS_ADDING checks in alloc_pid() and copy_process=
()
      do_notify_parent: sanitize the valid_signal() checks

Patrick Bellasi (1):
      scripts/decodecode: return 0 on success

Petr Mladek (2):
      hung_task: increment the global counter immediately
      doc: watchdog: futher improvements

Petr Vorel (2):
      scripts/spelling.txt: sort alphabetically
      scripts/spelling.txt: add "exaclty" typo

Randy Dunlap (1):
      doc: watchdog: fix typos etc

Rio (3):
      kernel/panic: increase buffer size for verbose taint logging
      kernel/panic: allocate taint string buffer dynamically
      kernel/panic: mark init_taint_buf as __initdata and panic instead of =
warning in alloc_taint_buf()

Sasha Levin (1):
      checkpatch: add support for Assisted-by tag

Sean Anderson (1):
      update Sean's email address

Taylor Nelms (1):
      checkpatch: exclude forward declarations of const structs

Tejas Bharambe (1):
      ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY

Thomas Wei=DFschuh (2):
      tools headers UAPI: sync linux/taskstats.h
      tools/getdelays: use the static UAPI headers from tools/include/uapi

Thorsten Blum (4):
      fork: replace simple_strtoul with kstrtoul in coredump_filter_setup
      crash_dump: remove redundant less-than-zero check
      crash_dump: fix typo in function name read_key_from_user_keying
      crash_dump: use sysfs_emit in sysfs show functions

UYeol Jo (1):
      selftests/ipc: skip msgque test when MSG_COPY is unsupported

Valtteri Koskivuori (1):
      scripts/bloat-o-meter: rename file arguments to match output

Yiyang Chen (2):
      taskstats: set version in TGID exit notifications
      tools/accounting: handle truncated taskstats netlink messages

Yufan Chen (1):
      ocfs2/heartbeat: fix slot mapping rollback leaks on error paths

ZhengYuan Huang (5):
      ocfs2: validate bg_list extent bounds in discontig groups
      ocfs2: handle invalid dinode in ocfs2_group_extend
      ocfs2: fix listxattr handling when the buffer is full
      ocfs2: validate bg_bits during freefrag scan
      ocfs2: validate group add input before caching

 .get_maintainer.ignore                             |   1 +
 .mailmap                                           |   6 +-
 CREDITS                                            |   7 +-
 Documentation/admin-guide/lockup-watchdogs.rst     | 146 +++-
 Documentation/admin-guide/sysctl/kernel.rst        |   3 +-
 .../devicetree/bindings/timer/xlnx,xps-timer.yaml  |   2 +-
 MAINTAINERS                                        |   5 +-
 arch/arm/lib/Makefile                              |   5 -
 arch/arm64/include/asm/xor.h                       |  73 --
 arch/arm64/kernel/machine_kexec_file.c             |   4 +
 arch/arm64/lib/Makefile                            |   6 -
 arch/loongarch/include/asm/xor.h                   |  68 --
 arch/loongarch/include/asm/xor_simd.h              |  34 -
 arch/loongarch/lib/Makefile                        |   2 -
 arch/loongarch/lib/xor_simd_glue.c                 |  72 --
 arch/powerpc/include/asm/xor.h                     |  47 --
 arch/powerpc/include/asm/xor_altivec.h             |  22 -
 arch/powerpc/kexec/elf_64.c                        |   4 +
 arch/powerpc/lib/Makefile                          |   5 -
 arch/powerpc/lib/xor_vmx.h                         |  22 -
 arch/powerpc/lib/xor_vmx_glue.c                    |  63 --
 arch/riscv/include/asm/xor.h                       |  68 --
 arch/riscv/lib/Makefile                            |   1 -
 arch/s390/include/asm/xor.h                        |  21 -
 arch/s390/lib/Makefile                             |   2 +-
 arch/sparc/include/asm/asm-prototypes.h            |   1 -
 arch/sparc/include/asm/xor.h                       |   9 -
 arch/sparc/lib/Makefile                            |   2 +-
 arch/um/include/asm/xor.h                          |  24 -
 arch/x86/include/asm/xor_64.h                      |  28 -
 arch/x86/kernel/kexec-bzimage64.c                  |   6 +-
 crypto/Kconfig                                     |   2 -
 crypto/Makefile                                    |   1 -
 crypto/async_tx/async_xor.c                        |  34 +-
 crypto/xor.c                                       | 174 -----
 drivers/of/fdt.c                                   |  21 +
 drivers/of/kexec.c                                 |  19 +
 fs/btrfs/raid56.c                                  |  27 +-
 fs/ocfs2/alloc.c                                   |  35 +-
 fs/ocfs2/aops.c                                    |  75 ++-
 fs/ocfs2/cluster/heartbeat.c                       |  83 ++-
 fs/ocfs2/dir.c                                     |  49 +-
 fs/ocfs2/dlm/dlmdomain.c                           |  10 +-
 fs/ocfs2/dlm/dlmmaster.c                           |   1 -
 fs/ocfs2/ioctl.c                                   |  18 +-
 fs/ocfs2/mmap.c                                    |   7 +-
 fs/ocfs2/ocfs2_trace.h                             |  10 +-
 fs/ocfs2/quota_global.c                            |  16 +-
 fs/ocfs2/quota_local.c                             |   4 +-
 fs/ocfs2/resize.c                                  |  22 +-
 fs/ocfs2/suballoc.c                                |  25 +
 fs/ocfs2/super.c                                   |   2 +-
 fs/ocfs2/xattr.c                                   |   4 +-
 fs/proc/array.c                                    |   2 +-
 fs/ubifs/gc.c                                      |   2 -
 fs/ubifs/replay.c                                  |   1 -
 include/asm-generic/Kbuild                         |   1 -
 include/asm-generic/xor.h                          | 738 -----------------=
----
 include/linux/crash_core.h                         |  14 +-
 include/linux/nmi.h                                |   1 +
 include/linux/raid/xor.h                           |  27 +-
 kernel/crash_core.c                                |   2 -
 kernel/crash_dump_dm_crypt.c                       |  22 +-
 kernel/crash_reserve.c                             |   2 -
 kernel/exit.c                                      |   8 +-
 kernel/fork.c                                      |  30 +-
 kernel/hung_task.c                                 | 106 ++-
 kernel/kexec_core.c                                |   1 -
 kernel/panic.c                                     |  47 +-
 kernel/pid.c                                       |  18 +-
 kernel/signal.c                                    |  12 +-
 kernel/taskstats.c                                 |   1 +
 kernel/vmcore_info.c                               |   2 -
 kernel/watchdog.c                                  | 148 +++--
 kernel/watchdog_buddy.c                            |   9 +-
 lib/Kconfig                                        |   4 +-
 lib/Makefile                                       |   4 +-
 lib/bch.c                                          |   6 +-
 lib/bug.c                                          |   6 +-
 lib/decompress_bunzip2.c                           |   4 +-
 lib/glob.c                                         |  11 +-
 lib/inflate.c                                      |  13 +-
 lib/list_sort.c                                    |  10 -
 lib/math/Kconfig                                   |   3 +
 lib/math/Makefile                                  |   1 +
 lib/{ =3D> math}/polynomial.c                        |  23 +-
 lib/parser.c                                       |   2 +-
 lib/raid/.kunitconfig                              |   3 +
 lib/raid/Kconfig                                   |  30 +
 lib/raid/Makefile                                  |   3 +
 lib/raid/xor/Makefile                              |  42 ++
 .../include/asm/xor.h =3D> lib/raid/xor/alpha/xor.c  |  46 +-
 lib/raid/xor/alpha/xor_arch.h                      |  22 +
 lib/raid/xor/arm/xor-neon-glue.c                   |  19 +
 {arch/arm/lib =3D> lib/raid/xor/arm}/xor-neon.c      |  22 +-
 .../include/asm/xor.h =3D> lib/raid/xor/arm/xor.c    | 105 +--
 lib/raid/xor/arm/xor_arch.h                        |  22 +
 lib/raid/xor/arm64/xor-neon-glue.c                 |  26 +
 {arch/arm64/lib =3D> lib/raid/xor/arm64}/xor-neon.c  |  94 +--
 lib/raid/xor/arm64/xor-neon.h                      |   6 +
 lib/raid/xor/arm64/xor_arch.h                      |  21 +
 lib/raid/xor/loongarch/xor_arch.h                  |  33 +
 .../lib =3D> lib/raid/xor/loongarch}/xor_simd.c      |   0
 .../lib =3D> lib/raid/xor/loongarch}/xor_simd.h      |   0
 lib/raid/xor/loongarch/xor_simd_glue.c             |  37 ++
 .../lib =3D> lib/raid/xor/loongarch}/xor_template.c  |   0
 lib/raid/xor/powerpc/xor_arch.h                    |  22 +
 .../powerpc/lib =3D> lib/raid/xor/powerpc}/xor_vmx.c |  40 +-
 lib/raid/xor/powerpc/xor_vmx.h                     |  10 +
 lib/raid/xor/powerpc/xor_vmx_glue.c                |  28 +
 lib/raid/xor/riscv/xor-glue.c                      |  25 +
 {arch/riscv/lib =3D> lib/raid/xor/riscv}/xor.S       |   4 -
 lib/raid/xor/riscv/xor_arch.h                      |  17 +
 {arch/s390/lib =3D> lib/raid/xor/s390}/xor.c         |  15 +-
 lib/raid/xor/s390/xor_arch.h                       |  13 +
 .../xor_32.h =3D> lib/raid/xor/sparc/xor-sparc32.c   |  32 +-
 .../raid/xor/sparc/xor-sparc64-glue.c              |  48 +-
 .../lib/xor.S =3D> lib/raid/xor/sparc/xor-sparc64.S  |  10 -
 lib/raid/xor/sparc/xor_arch.h                      |  35 +
 lib/raid/xor/tests/Makefile                        |   3 +
 lib/raid/xor/tests/xor_kunit.c                     | 187 ++++++
 lib/raid/xor/um/xor_arch.h                         |   2 +
 .../asm/xor_avx.h =3D> lib/raid/xor/x86/xor-avx.c    |  52 +-
 .../asm/xor_32.h =3D> lib/raid/xor/x86/xor-mmx.c     | 120 +---
 .../asm/xor.h =3D> lib/raid/xor/x86/xor-sse.c        | 105 +--
 lib/raid/xor/x86/xor_arch.h                        |  36 +
 lib/raid/xor/xor-32regs-prefetch.c                 | 267 ++++++++
 lib/raid/xor/xor-32regs.c                          | 217 ++++++
 lib/raid/xor/xor-8regs-prefetch.c                  | 146 ++++
 lib/raid/xor/xor-8regs.c                           | 103 +++
 lib/raid/xor/xor-core.c                            | 193 ++++++
 lib/raid/xor/xor_impl.h                            |  56 ++
 lib/scatterlist.c                                  |   8 +-
 lib/tests/kunit_iov_iter.c                         | 224 ++++++-
 lib/ts_bm.c                                        |  18 +-
 lib/ts_kmp.c                                       |  18 +-
 lib/uuid.c                                         |   2 +-
 scripts/bloat-o-meter                              |   6 +-
 scripts/checkpatch.pl                              |  14 +-
 scripts/decode_stacktrace.sh                       |  26 +-
 scripts/decodecode                                 |   3 +-
 scripts/gdb/linux/symbols.py                       |   2 +-
 scripts/get_maintainer.pl                          |   9 +-
 scripts/spelling.txt                               | 332 ++++-----
 tools/accounting/Makefile                          |   2 +-
 tools/accounting/getdelays.c                       |  41 +-
 tools/accounting/procacct.c                        |  40 +-
 tools/include/uapi/linux/taskstats.h               | 291 ++++++++
 tools/testing/selftests/breakpoints/Makefile       |   4 +-
 tools/testing/selftests/fchmodat2/fchmodat2_test.c | 166 +++--
 tools/testing/selftests/ipc/Makefile               |   8 +-
 tools/testing/selftests/ipc/msgque.c               |   3 +
 tools/testing/selftests/prctl/Makefile             |   4 +-
 tools/testing/selftests/sparc64/Makefile           |   4 +-
 .../selftests/thermal/intel/power_floor/Makefile   |   4 +-
 .../selftests/thermal/intel/workload_hint/Makefile |   4 +-
 156 files changed, 3525 insertions(+), 2704 deletions(-)
 delete mode 100644 arch/arm64/include/asm/xor.h
 delete mode 100644 arch/loongarch/include/asm/xor.h
 delete mode 100644 arch/loongarch/include/asm/xor_simd.h
 delete mode 100644 arch/loongarch/lib/xor_simd_glue.c
 delete mode 100644 arch/powerpc/include/asm/xor.h
 delete mode 100644 arch/powerpc/include/asm/xor_altivec.h
 delete mode 100644 arch/powerpc/lib/xor_vmx.h
 delete mode 100644 arch/powerpc/lib/xor_vmx_glue.c
 delete mode 100644 arch/riscv/include/asm/xor.h
 delete mode 100644 arch/s390/include/asm/xor.h
 delete mode 100644 arch/sparc/include/asm/xor.h
 delete mode 100644 arch/um/include/asm/xor.h
 delete mode 100644 arch/x86/include/asm/xor_64.h
 delete mode 100644 crypto/xor.c
 delete mode 100644 include/asm-generic/xor.h
 rename lib/{ =3D> math}/polynomial.c (88%)
 create mode 100644 lib/raid/.kunitconfig
 create mode 100644 lib/raid/Kconfig
 create mode 100644 lib/raid/Makefile
 create mode 100644 lib/raid/xor/Makefile
 rename arch/alpha/include/asm/xor.h =3D> lib/raid/xor/alpha/xor.c (95%)
 create mode 100644 lib/raid/xor/alpha/xor_arch.h
 create mode 100644 lib/raid/xor/arm/xor-neon-glue.c
 rename {arch/arm/lib =3D> lib/raid/xor/arm}/xor-neon.c (53%)
 rename arch/arm/include/asm/xor.h =3D> lib/raid/xor/arm/xor.c (59%)
 create mode 100644 lib/raid/xor/arm/xor_arch.h
 create mode 100644 lib/raid/xor/arm64/xor-neon-glue.c
 rename {arch/arm64/lib =3D> lib/raid/xor/arm64}/xor-neon.c (76%)
 create mode 100644 lib/raid/xor/arm64/xor-neon.h
 create mode 100644 lib/raid/xor/arm64/xor_arch.h
 create mode 100644 lib/raid/xor/loongarch/xor_arch.h
 rename {arch/loongarch/lib =3D> lib/raid/xor/loongarch}/xor_simd.c (100%)
 rename {arch/loongarch/lib =3D> lib/raid/xor/loongarch}/xor_simd.h (100%)
 create mode 100644 lib/raid/xor/loongarch/xor_simd_glue.c
 rename {arch/loongarch/lib =3D> lib/raid/xor/loongarch}/xor_template.c (10=
0%)
 create mode 100644 lib/raid/xor/powerpc/xor_arch.h
 rename {arch/powerpc/lib =3D> lib/raid/xor/powerpc}/xor_vmx.c (69%)
 create mode 100644 lib/raid/xor/powerpc/xor_vmx.h
 create mode 100644 lib/raid/xor/powerpc/xor_vmx_glue.c
 create mode 100644 lib/raid/xor/riscv/xor-glue.c
 rename {arch/riscv/lib =3D> lib/raid/xor/riscv}/xor.S (92%)
 create mode 100644 lib/raid/xor/riscv/xor_arch.h
 rename {arch/s390/lib =3D> lib/raid/xor/s390}/xor.c (93%)
 create mode 100644 lib/raid/xor/s390/xor_arch.h
 rename arch/sparc/include/asm/xor_32.h =3D> lib/raid/xor/sparc/xor-sparc32=
.c (92%)
 rename arch/sparc/include/asm/xor_64.h =3D> lib/raid/xor/sparc/xor-sparc64=
-glue.c (63%)
 rename arch/sparc/lib/xor.S =3D> lib/raid/xor/sparc/xor-sparc64.S (98%)
 create mode 100644 lib/raid/xor/sparc/xor_arch.h
 create mode 100644 lib/raid/xor/tests/Makefile
 create mode 100644 lib/raid/xor/tests/xor_kunit.c
 create mode 100644 lib/raid/xor/um/xor_arch.h
 rename arch/x86/include/asm/xor_avx.h =3D> lib/raid/xor/x86/xor-avx.c (84%)
 rename arch/x86/include/asm/xor_32.h =3D> lib/raid/xor/x86/xor-mmx.c (87%)
 rename arch/x86/include/asm/xor.h =3D> lib/raid/xor/x86/xor-sse.c (90%)
 create mode 100644 lib/raid/xor/x86/xor_arch.h
 create mode 100644 lib/raid/xor/xor-32regs-prefetch.c
 create mode 100644 lib/raid/xor/xor-32regs.c
 create mode 100644 lib/raid/xor/xor-8regs-prefetch.c
 create mode 100644 lib/raid/xor/xor-8regs.c
 create mode 100644 lib/raid/xor/xor-core.c
 create mode 100644 lib/raid/xor/xor_impl.h
 create mode 100644 tools/include/uapi/linux/taskstats.h

