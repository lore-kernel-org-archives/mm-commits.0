Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68072D7DEE;
	Sat,  6 Dec 2025 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765048535; cv=none; b=ZpbUVBOlvFqLQw885vggC4E7MbOC18pjsvrY2BbUjii6JUAZ+Lho3oy842NOsC2wFdtXqPTau0pkQE3OfJFol5lhfkRX9SaleBxLlKUB2gH5vF0ylt/FPsdIIMnFGBiR6MWmEM4wGcb6V5wbfpIIsTRWTqM3genmxR7hcNKyT9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765048535; c=relaxed/simple;
	bh=hhuzlQ1kyf5SoTrWQ+U0QSgPNDGdfmXR/BP8lVTHyMw=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=i0Ni799GQpEtg6j/aHWsYKdRE3v9TYiqzb0NtJi8NGmm55qR5ojI/oJPYWR2TMxdDngGqz0w3adzd0Nbcgw8LOSBd7CkK611o9tpGma1ptksChYn5rprWzGu1CGs8c8TbdzAltOzNj0HveKSU4PwLVV6mzlpNofYS/OvyDArurI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=THhQt6mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="THhQt6mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E19C4CEF5;
	Sat,  6 Dec 2025 19:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765048534;
	bh=hhuzlQ1kyf5SoTrWQ+U0QSgPNDGdfmXR/BP8lVTHyMw=;
	h=Date:From:To:Cc:Subject:From;
	b=THhQt6mtWnD/sBXU2j/eJBL5r2qtgJ2XR13mMOTD2Rd0FmI3Y1nL7vmkEF3EtCVGW
	 4Ru9JzcqT3/4lkHStaASe3zTy5NcOEVRd3Idnb6QMj96JKhntk/Mb45kKIp6uBcUwO
	 86E58YkDVgNPINt/bzD86RCEQTDkMdsWGc9z7Jrk=
Date: Sat, 6 Dec 2025 11:15:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: [GIT PULL] non-MM updates for 6.19-rc1
Message-Id: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Linus, please merge this batch of non-MM updates for the upcoming -rc
cycle.  I'll have a second much smaller batch next week.

Thanks.


Conflicts which I'm presently seeing and their linux-next resolutions
are as follows:

tools/testing/selftests/drivers/net/gro.c
tools/testing/selftests/drivers/net/hw/toeplitz.c, vs net-next tree:
https://lkml.kernel.org/r/20251124125006.3953f1d5@canb.auug.org.au
https://lkml.kernel.org/r/20251126103039.222a1589@canb.auug.org.au

tools/testing/selftests/vfio/lib/include/vfio_util.h, vs vfio tree:
https://lkml.kernel.org/r/20251201103154.32226085@canb.auug.org.au

tools/testing/selftests/vfio/lib/vfio_pci_device.c, vs vfio tree:
https://lkml.kernel.org/r/20251201103154.32226085@canb.auug.org.au
https://lkml.kernel.org/r/20251201101046.009b0919@canb.auug.org.au

tools/testing/selftests/vfio/lib/vfio_pci_driver.c, vs vfio tree:
https://lkml.kernel.org/r/20251201101312.4dfd2b19@canb.auug.org.au

tools/testing/selftests/vfio/vfio_iommufd_setup_test.c, vs vfio tree:
https://lkml.kernel.org/r/20251201101549.5792d6df@canb.auug.org.au


The following changes since commit 7c9580f44f90f7a4c11fc7831efe323ebe446091:

  mm/filemap: fix logic around SIGBUS in filemap_map_pages() (2025-11-24 14:25:18 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-06-11-14

for you to fetch changes up to aa514a297a0c175239f24a2e582ebd37f0727494:

  calibrate: update header inclusion (2025-11-27 14:24:45 -0800)

----------------------------------------------------------------
Significant patch series in this pull request:

- The 6 patch series "panic: sys_info: Refactor and fix a potential
  issue" from Andy Shevchenko fixes a build issue and does some cleanup in
  ib/sys_info.c.

- The 9 patch series "Implement mul_u64_u64_div_u64_roundup()" from
  David Laight enhances the 64-bit math code on behalf of a PWM driver and
  beefs up the test module for these library functions.

- The 2 patch series "scripts/gdb/symbols: make BPF debug info available
  to GDB" from Ilya Leoshkevich makes BPF symbol names, sizes, and line
  numbers available to the GDB debugger.

- The 4 patch series "Enable hung_task and lockup cases to dump system
  info on demand" from Feng Tang adds a sysctl which can be used to cause
  additional info dumping when the hung-task and lockup detectors fire.

- The 6 patch series "lib/base64: add generic encoder/decoder, migrate
  users" from Kuan-Wei Chiu adds a general base64 encoder/decoder to lib/
  and migrates several users away from their private implementations.

- The 2 patch series "rbree: inline rb_first() and rb_last()" from Eric
  Dumazet makes TCP a little faster.

- The 9 patch series "liveupdate: Rework KHO for in-kernel users" from
  Pasha Tatashin reworks the KEXEC Handover interfaces in preparation for
  Live Update Orchestrator (LUO), and possibly for other future clients.

- The 13 patch series "kho: simplify state machine and enable dynamic
  updates" from Pasha Tatashin increases the flexibility of KEXEC
  Handover.  Also preparation for LUO.

- The 18 patch series "Live Update Orchestrator" from Pasha Tatashin is
  a major new feature targeted at cloud environments.  Quoting the [0/N]:

    This series introduces the Live Update Orchestrator, a kernel subsystem
    designed to facilitate live kernel updates using a kexec-based reboot.
    This capability is critical for cloud environments, allowing hypervisors
    to be updated with minimal downtime for running virtual machines.  LUO
    achieves this by preserving the state of selected resources, such as
    memory, devices and their dependencies, across the kernel transition.

    As a key feature, this series includes support for preserving memfd file
    descriptors, which allows critical in-memory data, such as guest RAM or
    any other large memory region, to be maintained in RAM across the kexec
    reboot.

  Mike Rappaport merits a mention here, for his extensive review and
  testing work.

- The 3 patch series "kexec: reorganize kexec and kdump sysfs" from
  Sourabh Jain moves the kexec and kdump sysfs entries from /sys/kernel/
  to /sys/kernel/kexec/ and adds back-compatibility symlinks which can
  hopefully be removed one day.

- The 2 patch series "kho: fixes for vmalloc restoration" from Mike
  Rapoport fixes a BUG which was being hit during KHO restoration of
  vmalloc() regions.

----------------------------------------------------------------
Ahmet Eray Karadag (1):
      ocfs2: mark inode bad upon validation failure during read

Alice Ryhl (1):
      uaccess: gate _copy_[to|from]_user on !INLINE_COPY_FROM_USER

Andrew Morton (1):
      Merge branch 'mm-hotfixes-stable' into mm-nonmm-stable in order to be able to merge "kho: make debugfs interface optional" into mm-nonmm-stable.

Andy Shevchenko (9):
      panic: sys_info: capture si_bits_global before iterating over it
      panic: sys_info: align constant definition names with parameters
      panic: sys_info:replace struct sys_info_name with plain array of strings
      panic: sys_info: rewrite a fix for a compilation error (`make W=1`)
      panic: sys_info: deduplicate local variable 'table; assignments
      panic: sys_info: factor out read and write handlers
      util_macros.h: fix kernel-doc for u64_to_user_ptr()
      math.h: amend abs() kernel-doc and add a note about signed type limits
      calibrate: update header inclusion

Ankan Biswas (1):
      lib/xz: remove dead IA-64 (Itanium) support code

Bala-Vignesh-Reddy (1):
      selftests: complete kselftest include centralization

Borislav Petkov (AMD) (1):
      lib/Kconfig.debug: cleanup CONFIG_DEBUG_SECTION_MISMATCH help text

Breno Leitao (1):
      vmcoreinfo: track and log recoverable hardware errors

Carlos López (1):
      checkpatch: add IDR to the deprecated list

Chia-Liang Wang (1):
      lib: ratelimit: fix spelling mistake 'seperately'

Christoph Hellwig (1):
      kernel/hung_task: unexport sysctl_hung_task_timeout_secs

David Laight (9):
      lib: mul_u64_u64_div_u64(): rename parameter 'c' to 'd'
      lib: mul_u64_u64_div_u64(): combine overflow and divide by zero checks
      lib: mul_u64_u64_div_u64(): simplify check for a 64bit product
      lib: add mul_u64_add_u64_div_u64() and mul_u64_u64_div_u64_roundup()
      lib: add tests for mul_u64_u64_div_u64_roundup()
      lib: test_mul_u64_u64_div_u64(): test both generic and arch versions
      lib: mul_u64_u64_div_u64(): optimise multiply on 32bit x86
      lib: mul_u64_u64_div_u64(): optimise the divide code
      lib: test_mul_u64_u64_div_u64(): test the 32bit code on 64bit

Deepanshu Kartikey (1):
      ocfs2: validate cl_bpc in allocator inodes to prevent divide-by-zero

Dmitry Antipov (8):
      ocfs2: add extra flags check in ocfs2_ioctl_move_extents()
      ocfs2: relax BUG() to ocfs2_error() in __ocfs2_move_extent()
      ocfs2: annotate flexible array members with __counted_by_le()
      ocfs2: add extra consistency check to ocfs2_dx_dir_lookup_rec()
      ocfs2: add directory size check to ocfs2_find_dir_space_id()
      ocfs2: add boundary check to ocfs2_check_dir_entry()
      ocfs2: add inline inode consistency check to ocfs2_validate_inode_block()
      ocfs2: add extra consistency checks for chain allocator dinodes

Douglas Anderson (1):
      init/main.c: wrap long kernel cmdline when printing to logs

Dr. David Alan Gilbert (1):
      lib/xxhash: remove more unused xxh functions

Eric Dumazet (2):
      rbtree: inline rb_first()
      rbtree: inline rb_last()

Feng Tang (4):
      docs: panic: correct some sys_ifo names in sysctl doc
      hung_task: add hung_task_sys_info sysctl to dump sys info on task-hung
      watchdog: add sys_info sysctls to dump sys info on system lockup
      sys_info: add a default kernel sys_info mask

Guan-Chun Wu (4):
      lib/base64: rework encode/decode for speed and stricter validation
      lib: add KUnit tests for base64 encoding/decoding
      fscrypt: replace local base64url helpers with lib/base64
      ceph: replace local base64 helpers with lib/base64

Gustavo Padovan (1):
      MAINTAINERS: remove Gustavo from sync framework

Hao Ge (1):
      mailmap: add entry for Hao Ge

Ilias Stamatis (1):
      Reinstate "resource: avoid unnecessary lookups in find_next_iomem_res()"

Ilya Leoshkevich (2):
      scripts/gdb/radix-tree: add lx-radix-tree-command
      scripts/gdb/symbols: make BPF debug info available to GDB

Jarkko Sakkinen (1):
      MAINTAINERS: TPM DEVICE DRIVER: update the W-tag

Joseph Qi (2):
      ocfs2: use correct endian in ocfs2_dinode_has_extents
      ocfs2: convert to host endian in ocfs2_validate_inode_block

Justinien Bouron (1):
      kexec_core: remove superfluous page offset handling in segment loading

Kuan-Wei Chiu (3):
      Revert "lib/plist.c: enforce memory ordering in plist_check_list"
      lib/base64: add support for multiple variants
      lib/base64: optimize base64_decode() with reverse lookup tables

Lance Yang (1):
      MAINTAINERS: add Petr as a reviewer of hung task detector

Li RongQing (1):
      hung_task: panic when there are more than N hung tasks at the same time

Lukas Bulwahn (1):
      treewide: drop outdated compiler version remarks in Kconfig help texts

Martin Kepplinger-Novaković (3):
      mailmap: update name and email addresses
      CREDITS: update Martin's information
      MAINTAINERS: apply name and email address changes for Martin

Mateusz Guzik (1):
      fork: stop ignoring NUMA while handling cached thread stacks

Mike Rapoport (Microsoft) (3):
      kho: drop notifiers
      kho: kho_restore_vmalloc: fix initialization of pages array
      kho: fix restoring of contiguous ranges of order-0 pages

Oleg Nesterov (1):
      release_task: kill unnecessary rcu_read_lock() around dec_rlimit_ucounts()

Onur Özkan (2):
      checkpatch: detect unhandled placeholders in cover letters
      checkpatch: document new check PLACEHOLDER_USE

Pasha Tatashin (32):
      kho: make debugfs interface optional
      kho: add interfaces to unpreserve folios, page ranges, and vmalloc
      memblock: unpreserve memory in case of error
      test_kho: unpreserve memory in case of error
      kho: don't unpreserve memory during abort
      liveupdate: kho: move to kernel/liveupdate
      MAINTAINERS: update KHO maintainers
      kho: fix misleading log message in kho_populate()
      kho: convert __kho_abort() to return void
      kho: introduce high-level memory allocation API
      kho: preserve FDT folio only once during initialization
      kho: verify deserialization status and fix FDT alignment access
      kho: always expose output FDT in debugfs
      kho: simplify serialization and remove __kho_abort
      kho: remove global preserved_mem_map and store state in FDT
      kho: remove abort functionality and support state refresh
      kho: update FDT dynamically for subtree addition/removal
      kho: allow kexec load before KHO finalization
      kho: allow memory preservation state updates after finalization
      kho: add Kconfig option to enable KHO by default
      liveupdate: luo_core: Live Update Orchestrator
      liveupdate: luo_core: integrate with KHO
      kexec: call liveupdate_reboot() before kexec
      liveupdate: luo_session: add sessions support
      liveupdate: luo_core: add user interface
      liveupdate: luo_file: implement file systems callbacks
      liveupdate: luo_session: add ioctls for file preservation
      docs: add luo documentation
      MAINTAINERS: add liveupdate entry
      selftests/liveupdate: add userspace API selftests
      selftests/liveupdate: add simple kexec-based selftest for LUO
      selftests/liveupdate: add kexec test for multiple and empty sessions

Petr Pavlu (1):
      taint/module: remove unnecessary taint_flag.module field

Pratyush Yadav (9):
      MAINTAINERS: add Pratyush as a reviewer for KHO
      mm: shmem: use SHMEM_F_* flags instead of VM_* flags
      mm: shmem: allow freezing inode mapping
      mm: shmem: export some functions to internal.h
      liveupdate: luo_file: add private argument to store runtime state
      mm: memfd_luo: allow preserving memfd
      docs: add documentation for memfd preservation via LUO
      kho: free chunks using free_page() instead of kfree()
      test_kho: always print restore status

Ran Xiaokai (1):
      KHO: fix boot failure due to kmemleak access to non-PRESENT pages

Randy Dunlap (1):
      taint: add reminder about updating docs and scripts

Ryusuke Konishi (1):
      MAINTAINERS: update nilfs2 entry

Sourabh Jain (6):
      crash: let architecture decide crash memory export to iomem_resource
      Documentation/ABI: add kexec and kdump sysfs interface
      crash: export crashkernel CMA reservation to userspace
      kexec: move sysfs entries to /sys/kernel/kexec
      Documentation/ABI: mark old kexec sysfs deprecated
      Documentation/ABI: new kexec and kdump sysfs interface

Thomas Weißschuh (1):
      compiler.h: remove ARCH_SEL()

Thorsten Blum (4):
      nilfs2: replace vmalloc + copy_from_user with vmemdup_user
      ocfs2: replace deprecated strcpy in ocfs2_create_xattr_block
      ocfs2: replace deprecated strcpy with strscpy
      init: replace simple_strtoul with kstrtoul to improve lpj_setup

Vlad Kulikov (1):
      ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure

WangYuli (1):
      .mailmap: add entry for WangYuli

Xie Yuanbin (1):
      include/linux/once_lite.h: fix judgment in WARN_ONCE with clang

Ye Bin (1):
      dynamic_debug: add support for print stack

Yu-Chun Lin (1):
      mailmap: add entry for Yu-Chun Lin

Yury Norov (NVIDIA) (1):
      uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST

Zhichi Lin (1):
      scs: fix a wrong parameter in __scs_magic

Zhou Yuhang (1):
      samples: fix coding style issues in Kconfig

Zhu Yanjun (1):
      liveupdate: kho: use %pe format specifier for error pointer printing

zhang jiao (1):
      fs/proc/page: remove unused KPMBITS

 .mailmap                                           |   9 +-
 CREDITS                                            |   9 +-
 .../ABI/obsolete/sysfs-kernel-kexec-kdump          |  71 ++
 Documentation/ABI/testing/sysfs-kernel-kexec-kdump |  61 ++
 Documentation/admin-guide/dynamic-debug-howto.rst  |   5 +-
 Documentation/admin-guide/kernel-parameters.txt    |  20 +-
 Documentation/admin-guide/sysctl/kernel.rst        |  32 +-
 Documentation/core-api/index.rst                   |   1 +
 Documentation/core-api/kho/concepts.rst            |   2 +-
 Documentation/core-api/liveupdate.rst              |  61 ++
 Documentation/dev-tools/checkpatch.rst             |  10 +
 Documentation/driver-api/hw-recoverable-errors.rst |  60 ++
 Documentation/driver-api/index.rst                 |   1 +
 Documentation/mm/index.rst                         |   1 +
 Documentation/mm/memfd_preservation.rst            |  23 +
 Documentation/userspace-api/index.rst              |   1 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |   2 +
 Documentation/userspace-api/liveupdate.rst         |  20 +
 MAINTAINERS                                        |  34 +-
 arch/Kconfig                                       |  19 +-
 arch/arm/Kconfig                                   |   2 -
 arch/arm/configs/aspeed_g5_defconfig               |   2 +-
 arch/powerpc/include/asm/crash_reserve.h           |   8 +
 arch/x86/include/asm/div64.h                       |  39 +-
 arch/x86/kernel/cpu/mce/core.c                     |   4 +
 drivers/acpi/apei/ghes.c                           |  36 +
 drivers/nvme/common/auth.c                         |   4 +-
 drivers/pci/pcie/aer.c                             |   2 +
 fs/ceph/crypto.c                                   |  60 +-
 fs/ceph/crypto.h                                   |   6 +-
 fs/ceph/dir.c                                      |   5 +-
 fs/ceph/inode.c                                    |   2 +-
 fs/crypto/fname.c                                  |  89 +--
 fs/nilfs2/ioctl.c                                  |  35 +-
 fs/ocfs2/dir.c                                     |  42 +-
 fs/ocfs2/inode.c                                   |  49 +-
 fs/ocfs2/move_extents.c                            |  14 +-
 fs/ocfs2/ocfs2_fs.h                                |  22 +-
 fs/ocfs2/refcounttree.c                            |   5 +-
 fs/ocfs2/xattr.c                                   |   2 +-
 fs/proc/page.c                                     |   1 -
 include/linux/base64.h                             |  10 +-
 include/linux/compiler.h                           |   6 -
 include/linux/crash_reserve.h                      |   6 +
 include/linux/dynamic_debug.h                      |  17 +-
 include/linux/kexec_handover.h                     |  57 +-
 include/linux/kho/abi/luo.h                        | 166 ++++
 include/linux/kho/abi/memfd.h                      |  77 ++
 include/linux/liveupdate.h                         | 138 ++++
 include/linux/math.h                               |  13 +-
 include/linux/math64.h                             |  59 +-
 include/linux/once_lite.h                          |   2 +-
 include/linux/panic.h                              |   1 -
 include/linux/rbtree.h                             |  32 +-
 include/linux/shmem_fs.h                           |  23 +
 include/linux/sys_info.h                           |   2 +-
 include/linux/uaccess.h                            |   6 +-
 include/linux/util_macros.h                        |   4 +-
 include/linux/vmcore_info.h                        |   8 +
 include/linux/xxhash.h                             |  46 +-
 include/uapi/linux/liveupdate.h                    | 216 +++++
 include/uapi/linux/vmcore.h                        |   9 +
 init/Kconfig                                       |  20 +
 init/calibrate.c                                   |  13 +-
 init/main.c                                        |  97 ++-
 ipc/namespace.c                                    |   9 +-
 kernel/Kconfig.kexec                               |  24 -
 kernel/Makefile                                    |   3 +-
 kernel/configs/debug.config                        |   2 +-
 kernel/crash_reserve.c                             |   3 +
 kernel/exit.c                                      |   4 +-
 kernel/fork.c                                      |  63 +-
 kernel/hung_task.c                                 |  56 +-
 kernel/kexec_core.c                                | 161 +++-
 kernel/kexec_handover_internal.h                   |  20 -
 kernel/ksysfs.c                                    |  68 +-
 kernel/liveupdate/Kconfig                          |  75 ++
 kernel/liveupdate/Makefile                         |  12 +
 kernel/{ => liveupdate}/kexec_handover.c           | 716 ++++++++---------
 kernel/{ => liveupdate}/kexec_handover_debug.c     |   0
 kernel/liveupdate/kexec_handover_debugfs.c         | 221 +++++
 kernel/liveupdate/kexec_handover_internal.h        |  55 ++
 kernel/liveupdate/luo_core.c                       | 450 +++++++++++
 kernel/liveupdate/luo_file.c                       | 889 +++++++++++++++++++++
 kernel/liveupdate/luo_internal.h                   | 110 +++
 kernel/liveupdate/luo_session.c                    | 646 +++++++++++++++
 kernel/module/main.c                               |   2 +-
 kernel/panic.c                                     |  52 +-
 kernel/resource.c                                  |  10 +-
 kernel/scs.c                                       |   2 +-
 kernel/vmcore_info.c                               |  17 +
 kernel/watchdog.c                                  |  44 +-
 lib/Kconfig.debug                                  |  63 +-
 lib/base64.c                                       | 189 +++--
 lib/dynamic_debug.c                                |   1 +
 lib/math/div64.c                                   | 185 +++--
 lib/math/test_mul_u64_u64_div_u64.c                | 191 +++--
 lib/plist.c                                        |   4 +-
 lib/ratelimit.c                                    |   2 +-
 lib/rbtree.c                                       |  29 -
 lib/sys_info.c                                     | 169 ++--
 lib/test_kho.c                                     | 140 ++--
 lib/tests/Makefile                                 |   1 +
 lib/tests/base64_kunit.c                           | 294 +++++++
 lib/usercopy.c                                     |   4 +-
 lib/xxhash.c                                       |  29 -
 lib/xz/xz_dec_bcj.c                                |  95 ---
 lib/xz/xz_private.h                                |   4 -
 mm/Makefile                                        |   1 +
 mm/internal.h                                      |   6 +
 mm/memblock.c                                      |  93 ++-
 mm/memfd_luo.c                                     | 516 ++++++++++++
 mm/shmem.c                                         |  49 +-
 rust/helpers/rbtree.c                              |  10 +
 rust/helpers/uaccess.c                             |  12 +
 samples/Kconfig                                    |  22 +-
 samples/vfs/Makefile                               |   1 +
 scripts/checkpatch.pl                              |  11 +
 scripts/gdb/linux/bpf.py                           | 253 ++++++
 scripts/gdb/linux/constants.py.in                  |   3 +
 scripts/gdb/linux/radixtree.py                     | 139 +++-
 scripts/gdb/linux/symbols.py                       | 105 ++-
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/acct/acct_syscall.c        |   2 +-
 tools/testing/selftests/alsa/conf.c                |   2 +-
 tools/testing/selftests/alsa/mixer-test.c          |   2 +-
 tools/testing/selftests/alsa/pcm-test.c            |   2 +-
 tools/testing/selftests/alsa/test-pcmtest-driver.c |   2 +-
 tools/testing/selftests/alsa/utimer-test.c         |   2 +-
 tools/testing/selftests/arm64/abi/hwcap.c          |   2 +-
 tools/testing/selftests/arm64/abi/ptrace.c         |   2 +-
 tools/testing/selftests/arm64/abi/syscall-abi.c    |   2 +-
 tools/testing/selftests/arm64/fp/fp-ptrace.c       |   2 +-
 tools/testing/selftests/arm64/fp/fp-stress.c       |   2 +-
 tools/testing/selftests/arm64/fp/sve-probe-vls.c   |   2 +-
 tools/testing/selftests/arm64/fp/sve-ptrace.c      |   2 +-
 tools/testing/selftests/arm64/fp/vec-syscfg.c      |   2 +-
 tools/testing/selftests/arm64/fp/za-ptrace.c       |   2 +-
 tools/testing/selftests/arm64/fp/zt-ptrace.c       |   2 +-
 tools/testing/selftests/arm64/gcs/gcs-stress.c     |   2 +-
 tools/testing/selftests/arm64/pauth/pac.c          |   2 +-
 tools/testing/selftests/arm64/tags/tags_test.c     |   2 +-
 tools/testing/selftests/bpf/xskxceiver.c           |   2 +-
 .../selftests/breakpoints/breakpoint_test.c        |   2 +-
 .../selftests/breakpoints/breakpoint_test_arm64.c  |   2 +-
 .../breakpoints/step_after_suspend_test.c          |   2 +-
 tools/testing/selftests/cachestat/test_cachestat.c |   2 +-
 tools/testing/selftests/capabilities/test_execve.c |   2 +-
 .../testing/selftests/capabilities/validate_cap.c  |   2 +-
 tools/testing/selftests/cgroup/test_core.c         |   2 +-
 tools/testing/selftests/cgroup/test_cpu.c          |   2 +-
 tools/testing/selftests/cgroup/test_cpuset.c       |   2 +-
 tools/testing/selftests/cgroup/test_freezer.c      |   2 +-
 .../testing/selftests/cgroup/test_hugetlb_memcg.c  |   2 +-
 tools/testing/selftests/cgroup/test_kill.c         |   2 +-
 tools/testing/selftests/cgroup/test_kmem.c         |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |   2 +-
 tools/testing/selftests/cgroup/test_pids.c         |   2 +-
 tools/testing/selftests/cgroup/test_zswap.c        |   2 +-
 tools/testing/selftests/clone3/clone3.c            |   2 +-
 .../clone3/clone3_cap_checkpoint_restore.c         |   2 +-
 .../selftests/clone3/clone3_clear_sighand.c        |   2 +-
 tools/testing/selftests/clone3/clone3_selftests.h  |   2 +-
 tools/testing/selftests/clone3/clone3_set_tid.c    |   2 +-
 tools/testing/selftests/connector/proc_filter.c    |   2 +-
 tools/testing/selftests/core/close_range_test.c    |   2 +-
 tools/testing/selftests/core/unshare_test.c        |   2 +-
 tools/testing/selftests/coredump/stackdump_test.c  |   2 +-
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c |   2 +-
 tools/testing/selftests/drivers/dma-buf/udmabuf.c  |   2 +-
 tools/testing/selftests/drivers/ntsync/ntsync.c    |   2 +-
 .../drivers/s390x/uvdevice/test_uvdevice.c         |   2 +-
 tools/testing/selftests/exec/check-exec.c          |   2 +-
 tools/testing/selftests/exec/execveat.c            |   2 +-
 tools/testing/selftests/exec/load_address.c        |   2 +-
 tools/testing/selftests/exec/non-regular.c         |   2 +-
 tools/testing/selftests/exec/null-argv.c           |   2 +-
 tools/testing/selftests/exec/recursion-depth.c     |   2 +-
 tools/testing/selftests/fchmodat2/fchmodat2_test.c |   2 +-
 tools/testing/selftests/filelock/ofdlocks.c        |   2 +-
 .../selftests/filesystems/anon_inode_test.c        |   2 +-
 .../selftests/filesystems/binderfs/binderfs_test.c |   2 +-
 tools/testing/selftests/filesystems/devpts_pts.c   |   2 +-
 .../filesystems/epoll/epoll_wakeup_test.c          |   2 +-
 .../selftests/filesystems/eventfd/eventfd_test.c   |   2 +-
 tools/testing/selftests/filesystems/fclog.c        |   2 +-
 .../testing/selftests/filesystems/file_stressor.c  |   2 +-
 .../selftests/filesystems/fuse/fusectl_test.c      |   2 +-
 tools/testing/selftests/filesystems/kernfs_test.c  |   2 +-
 .../filesystems/mount-notify/mount-notify_test.c   |   2 +-
 .../mount-notify/mount-notify_test_ns.c            |   2 +-
 .../selftests/filesystems/nsfs/iterate_mntns.c     |   2 +-
 .../selftests/filesystems/overlayfs/dev_in_maps.c  |   2 +-
 .../filesystems/overlayfs/set_layers_via_fds.c     |   2 +-
 .../filesystems/statmount/listmount_test.c         |   2 +-
 .../filesystems/statmount/statmount_test.c         |   2 +-
 .../filesystems/statmount/statmount_test_ns.c      |   2 +-
 tools/testing/selftests/filesystems/utils.c        |   2 +-
 .../selftests/futex/functional/futex_numa_mpol.c   |   2 +-
 .../selftests/futex/functional/futex_priv_hash.c   |   2 +-
 .../selftests/futex/functional/futex_requeue.c     |   2 +-
 .../selftests/futex/functional/futex_requeue_pi.c  |   2 +-
 .../functional/futex_requeue_pi_mismatched_ops.c   |   2 +-
 .../functional/futex_requeue_pi_signal_restart.c   |   2 +-
 .../selftests/futex/functional/futex_wait.c        |   2 +-
 .../functional/futex_wait_private_mapped_file.c    |   2 +-
 .../futex/functional/futex_wait_timeout.c          |   2 +-
 .../functional/futex_wait_uninitialized_heap.c     |   2 +-
 .../futex/functional/futex_wait_wouldblock.c       |   2 +-
 .../selftests/futex/functional/futex_waitv.c       |   2 +-
 tools/testing/selftests/hid/hid_common.h           |   2 +-
 tools/testing/selftests/intel_pstate/aperf.c       |   2 +-
 tools/testing/selftests/iommu/iommufd_utils.h      |   2 +-
 tools/testing/selftests/ipc/msgque.c               |   2 +-
 tools/testing/selftests/ir/ir_loopback.c           |   2 +-
 tools/testing/selftests/kcmp/kcmp_test.c           |   2 +-
 tools/testing/selftests/kho/vmtest.sh              |   1 +
 tools/testing/selftests/kselftest_harness.h        |   2 +-
 .../selftests/kselftest_harness/harness-selftest.c |   2 +-
 tools/testing/selftests/landlock/audit.h           |   2 +-
 tools/testing/selftests/landlock/common.h          |   2 +-
 tools/testing/selftests/lib.mk                     |   3 +
 tools/testing/selftests/liveupdate/.gitignore      |   9 +
 tools/testing/selftests/liveupdate/Makefile        |  34 +
 tools/testing/selftests/liveupdate/config          |  11 +
 tools/testing/selftests/liveupdate/do_kexec.sh     |  16 +
 tools/testing/selftests/liveupdate/liveupdate.c    | 348 ++++++++
 .../selftests/liveupdate/luo_kexec_simple.c        |  89 +++
 .../selftests/liveupdate/luo_multi_session.c       | 162 ++++
 .../testing/selftests/liveupdate/luo_test_utils.c  | 266 ++++++
 .../testing/selftests/liveupdate/luo_test_utils.h  |  44 +
 .../testing/selftests/lsm/lsm_get_self_attr_test.c |   2 +-
 .../testing/selftests/lsm/lsm_list_modules_test.c  |   2 +-
 .../testing/selftests/lsm/lsm_set_self_attr_test.c |   2 +-
 .../selftests/media_tests/media_device_open.c      |   2 +-
 .../selftests/media_tests/media_device_test.c      |   2 +-
 .../selftests/membarrier/membarrier_test_impl.h    |   2 +-
 tools/testing/selftests/mincore/mincore_selftest.c |   4 +-
 tools/testing/selftests/mm/compaction_test.c       |   2 +-
 tools/testing/selftests/mm/cow.c                   |   2 +-
 tools/testing/selftests/mm/droppable.c             |   2 +-
 tools/testing/selftests/mm/guard-regions.c         |   2 +-
 tools/testing/selftests/mm/gup_longterm.c          |   2 +-
 tools/testing/selftests/mm/gup_test.c              |   2 +-
 tools/testing/selftests/mm/hmm-tests.c             |   2 +-
 tools/testing/selftests/mm/hugepage-mmap.c         |   2 +-
 tools/testing/selftests/mm/hugepage-mremap.c       |   2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c       |   2 +-
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c |   2 +-
 tools/testing/selftests/mm/hugetlb-soft-offline.c  |   2 +-
 tools/testing/selftests/mm/hugetlb_dio.c           |   2 +-
 .../selftests/mm/hugetlb_fault_after_madv.c        |   2 +-
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c   |   2 +-
 tools/testing/selftests/mm/ksm_functional_tests.c  |   2 +-
 tools/testing/selftests/mm/ksm_tests.c             |   2 +-
 tools/testing/selftests/mm/madv_populate.c         |   2 +-
 tools/testing/selftests/mm/map_fixed_noreplace.c   |   2 +-
 tools/testing/selftests/mm/map_hugetlb.c           |   2 +-
 tools/testing/selftests/mm/map_populate.c          |   2 +-
 tools/testing/selftests/mm/mdwe_test.c             |   2 +-
 tools/testing/selftests/mm/memfd_secret.c          |   2 +-
 tools/testing/selftests/mm/merge.c                 |   2 +-
 tools/testing/selftests/mm/migration.c             |   2 +-
 tools/testing/selftests/mm/mkdirty.c               |   2 +-
 tools/testing/selftests/mm/mlock-random-test.c     |   2 +-
 tools/testing/selftests/mm/mlock2-tests.c          |   2 +-
 tools/testing/selftests/mm/mrelease_test.c         |   2 +-
 tools/testing/selftests/mm/mremap_dontunmap.c      |   2 +-
 tools/testing/selftests/mm/mremap_test.c           |   2 +-
 tools/testing/selftests/mm/mseal_test.c            |   2 +-
 tools/testing/selftests/mm/on-fault-limit.c        |   2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |   2 +-
 tools/testing/selftests/mm/pfnmap.c                |   2 +-
 tools/testing/selftests/mm/pkey-helpers.h          |   2 +-
 tools/testing/selftests/mm/prctl_thp_disable.c     |   2 +-
 tools/testing/selftests/mm/process_madv.c          |   2 +-
 tools/testing/selftests/mm/rmap.c                  |   2 +-
 tools/testing/selftests/mm/soft-dirty.c            |   2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |   2 +-
 tools/testing/selftests/mm/thuge-gen.c             |   2 +-
 tools/testing/selftests/mm/transhuge-stress.c      |   2 +-
 tools/testing/selftests/mm/uffd-common.h           |   2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c        |   2 +-
 tools/testing/selftests/mm/va_high_addr_switch.c   |   2 +-
 tools/testing/selftests/mm/virtual_address_range.c |   2 +-
 tools/testing/selftests/mm/vm_util.c               |   2 +-
 tools/testing/selftests/mm/vm_util.h               |   2 +-
 .../selftests/mount_setattr/mount_setattr_test.c   |   2 +-
 .../move_mount_set_group_test.c                    |   2 +-
 tools/testing/selftests/mqueue/mq_open_tests.c     |   2 +-
 tools/testing/selftests/mqueue/mq_perf_tests.c     |   2 +-
 .../mseal_system_mappings/sysmap_is_sealed.c       |   4 +-
 .../selftests/namespaces/file_handle_test.c        |   2 +-
 tools/testing/selftests/namespaces/init_ino_test.c |   2 +-
 tools/testing/selftests/namespaces/nsid_test.c     |   2 +-
 tools/testing/selftests/nci/nci_dev.c              |   2 +-
 tools/testing/selftests/net/af_unix/diag_uid.c     |   2 +-
 tools/testing/selftests/net/af_unix/msg_oob.c      |   2 +-
 tools/testing/selftests/net/af_unix/scm_inq.c      |   2 +-
 tools/testing/selftests/net/af_unix/scm_pidfd.c    |   2 +-
 tools/testing/selftests/net/af_unix/scm_rights.c   |   2 +-
 tools/testing/selftests/net/af_unix/unix_connect.c |   2 +-
 tools/testing/selftests/net/bind_timewait.c        |   2 +-
 tools/testing/selftests/net/bind_wildcard.c        |   2 +-
 tools/testing/selftests/net/can/test_raw_filter.c  |   2 +-
 tools/testing/selftests/net/cmsg_sender.c          |   2 +-
 tools/testing/selftests/net/epoll_busy_poll.c      |   2 +-
 tools/testing/selftests/net/gro.c                  |   2 +-
 tools/testing/selftests/net/ip_local_port_range.c  |   2 +-
 tools/testing/selftests/net/ipsec.c                |   2 +-
 tools/testing/selftests/net/ipv6_fragmentation.c   |   2 +-
 .../selftests/net/netfilter/conntrack_dump_flush.c |   2 +-
 tools/testing/selftests/net/netlink-dumps.c        |   2 +-
 tools/testing/selftests/net/ovpn/ovpn-cli.c        |   2 +-
 tools/testing/selftests/net/proc_net_pktgen.c      |   2 +-
 tools/testing/selftests/net/psock_fanout.c         |   2 +-
 tools/testing/selftests/net/psock_tpacket.c        |   2 +-
 .../selftests/net/reuseaddr_ports_exhausted.c      |   2 +-
 tools/testing/selftests/net/reuseport_bpf.c        |   2 +-
 tools/testing/selftests/net/reuseport_bpf_numa.c   |   2 +-
 tools/testing/selftests/net/rxtimestamp.c          |   2 +-
 tools/testing/selftests/net/sk_so_peek_off.c       |   2 +-
 tools/testing/selftests/net/so_incoming_cpu.c      |   2 +-
 tools/testing/selftests/net/socket.c               |   2 +-
 tools/testing/selftests/net/tap.c                  |   2 +-
 tools/testing/selftests/net/tcp_ao/lib/setup.c     |   2 +-
 .../selftests/net/tcp_fastopen_backup_key.c        |   2 +-
 tools/testing/selftests/net/tcp_port_share.c       |   2 +-
 tools/testing/selftests/net/tls.c                  |   2 +-
 tools/testing/selftests/net/toeplitz.c             |   2 +-
 tools/testing/selftests/net/tun.c                  |   2 +-
 tools/testing/selftests/net/udpgso_bench_tx.c      |   2 +-
 tools/testing/selftests/openat2/helpers.h          |   2 +-
 tools/testing/selftests/openat2/openat2_test.c     |   2 +-
 .../testing/selftests/openat2/rename_attack_test.c |   2 +-
 tools/testing/selftests/openat2/resolve_test.c     |   2 +-
 .../selftests/pci_endpoint/pci_endpoint_test.c     |   2 +-
 tools/testing/selftests/perf_events/mmap.c         |   2 +-
 .../testing/selftests/perf_events/remove_on_exec.c |   2 +-
 .../selftests/perf_events/sigtrap_threads.c        |   2 +-
 .../selftests/perf_events/watermark_signal.c       |   2 +-
 tools/testing/selftests/pid_namespace/pid_max.c    |   2 +-
 .../selftests/pid_namespace/regression_enomem.c    |   2 +-
 tools/testing/selftests/pidfd/pidfd.h              |   2 +-
 tools/testing/selftests/pidfd/pidfd_bind_mount.c   |   2 +-
 tools/testing/selftests/pidfd/pidfd_fdinfo_test.c  |   2 +-
 .../selftests/pidfd/pidfd_file_handle_test.c       |   2 +-
 tools/testing/selftests/pidfd/pidfd_getfd_test.c   |   2 +-
 tools/testing/selftests/pidfd/pidfd_info_test.c    |   2 +-
 tools/testing/selftests/pidfd/pidfd_open_test.c    |   2 +-
 tools/testing/selftests/pidfd/pidfd_poll_test.c    |   2 +-
 tools/testing/selftests/pidfd/pidfd_setattr_test.c |   2 +-
 tools/testing/selftests/pidfd/pidfd_setns_test.c   |   2 +-
 tools/testing/selftests/pidfd/pidfd_test.c         |   2 +-
 tools/testing/selftests/pidfd/pidfd_wait.c         |   2 +-
 tools/testing/selftests/pidfd/pidfd_xattr_test.c   |   2 +-
 .../selftests/prctl/set-anon-vma-name-test.c       |   2 +-
 tools/testing/selftests/prctl/set-process-name.c   |   2 +-
 tools/testing/selftests/proc/proc-maps-race.c      |   2 +-
 tools/testing/selftests/proc/proc-pid-vm.c         |   2 +-
 tools/testing/selftests/proc/proc-pidns.c          |   2 +-
 tools/testing/selftests/ptrace/get_set_sud.c       |   2 +-
 tools/testing/selftests/ptrace/get_syscall_info.c  |   2 +-
 tools/testing/selftests/ptrace/set_syscall_info.c  |   2 +-
 tools/testing/selftests/ptrace/vmaccess.c          |   2 +-
 tools/testing/selftests/resctrl/resctrl.h          |   2 +-
 tools/testing/selftests/ring-buffer/map_test.c     |   2 +-
 .../testing/selftests/riscv/abi/pointer_masking.c  |   2 +-
 tools/testing/selftests/riscv/hwprobe/cbo.c        |   2 +-
 tools/testing/selftests/riscv/hwprobe/hwprobe.c    |   2 +-
 tools/testing/selftests/riscv/hwprobe/which-cpus.c |   2 +-
 tools/testing/selftests/riscv/mm/mmap_bottomup.c   |   2 +-
 tools/testing/selftests/riscv/mm/mmap_default.c    |   2 +-
 tools/testing/selftests/riscv/mm/mmap_test.h       |   2 +-
 .../testing/selftests/riscv/sigreturn/sigreturn.c  |   2 +-
 tools/testing/selftests/riscv/vector/v_initval.c   |   2 +-
 .../testing/selftests/riscv/vector/vstate_prctl.c  |   2 +-
 .../testing/selftests/rseq/basic_percpu_ops_test.c |   2 +-
 tools/testing/selftests/rseq/rseq.c                |   2 +-
 tools/testing/selftests/rtc/rtctest.c              |   2 +-
 .../testing/selftests/seccomp/seccomp_benchmark.c  |   2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   2 +-
 tools/testing/selftests/sgx/main.c                 |   2 +-
 tools/testing/selftests/signal/mangle_uc_sigmask.c |   2 +-
 tools/testing/selftests/signal/sas.c               |   2 +-
 tools/testing/selftests/sparc64/drivers/adi-test.c |   2 +-
 tools/testing/selftests/sync/sync_test.c           |   2 +-
 .../selftests/syscall_user_dispatch/sud_test.c     |   2 +-
 tools/testing/selftests/tdx/tdx_guest_test.c       |   2 +-
 tools/testing/selftests/timens/timens.h            |   2 +-
 tools/testing/selftests/timers/adjtick.c           |   2 +-
 .../testing/selftests/timers/alarmtimer-suspend.c  |   2 +-
 tools/testing/selftests/timers/change_skew.c       |   2 +-
 .../testing/selftests/timers/clocksource-switch.c  |   2 +-
 tools/testing/selftests/timers/freq-step.c         |   2 +-
 .../testing/selftests/timers/inconsistency-check.c |   2 +-
 tools/testing/selftests/timers/leap-a-day.c        |   2 +-
 tools/testing/selftests/timers/leapcrash.c         |   2 +-
 tools/testing/selftests/timers/mqueue-lat.c        |   2 +-
 tools/testing/selftests/timers/nanosleep.c         |   2 +-
 tools/testing/selftests/timers/nsleep-lat.c        |   2 +-
 tools/testing/selftests/timers/posix_timers.c      |   2 +-
 tools/testing/selftests/timers/raw_skew.c          |   2 +-
 tools/testing/selftests/timers/rtcpie.c            |   2 +-
 tools/testing/selftests/timers/set-2038.c          |   2 +-
 tools/testing/selftests/timers/set-tai.c           |   2 +-
 tools/testing/selftests/timers/set-timer-lat.c     |   2 +-
 tools/testing/selftests/timers/set-tz.c            |   2 +-
 tools/testing/selftests/timers/skew_consistency.c  |   2 +-
 tools/testing/selftests/timers/threadtest.c        |   2 +-
 tools/testing/selftests/timers/valid-adjtimex.c    |   2 +-
 tools/testing/selftests/tmpfs/bug-link-o-tmpfile.c |   2 +-
 tools/testing/selftests/tty/tty_tstamp_update.c    |   2 +-
 tools/testing/selftests/uevent/uevent_filtering.c  |   2 +-
 tools/testing/selftests/user_events/abi_test.c     |   2 +-
 tools/testing/selftests/user_events/dyn_test.c     |   2 +-
 tools/testing/selftests/user_events/ftrace_test.c  |   2 +-
 tools/testing/selftests/user_events/perf_test.c    |   2 +-
 .../selftests/user_events/user_events_selftests.h  |   2 +-
 tools/testing/selftests/vDSO/vdso_test_abi.c       |   2 +-
 tools/testing/selftests/vDSO/vdso_test_chacha.c    |   2 +-
 .../testing/selftests/vDSO/vdso_test_correctness.c |   2 +-
 tools/testing/selftests/vDSO/vdso_test_getcpu.c    |   2 +-
 tools/testing/selftests/vDSO/vdso_test_getrandom.c |   2 +-
 .../selftests/vDSO/vdso_test_gettimeofday.c        |   2 +-
 .../testing/selftests/vfio/lib/include/vfio_util.h |   2 +-
 tools/testing/selftests/vfio/lib/vfio_pci_device.c |   2 +-
 tools/testing/selftests/vfio/lib/vfio_pci_driver.c |   2 +-
 .../testing/selftests/vfio/vfio_dma_mapping_test.c |   2 +-
 .../selftests/vfio/vfio_iommufd_setup_test.c       |   2 +-
 .../testing/selftests/vfio/vfio_pci_device_test.c  |   2 +-
 .../testing/selftests/vfio/vfio_pci_driver_test.c  |   2 +-
 .../testing/selftests/wireguard/qemu/kernel.config |   2 +-
 .../testing/selftests/x86/corrupt_xstate_header.c  |   2 +-
 tools/testing/selftests/x86/helpers.h              |   2 +-
 tools/testing/selftests/x86/lam.c                  |   2 +-
 tools/testing/selftests/x86/syscall_numbering.c    |   2 +-
 tools/testing/selftests/x86/test_mremap_vdso.c     |   2 +-
 tools/testing/selftests/x86/test_vsyscall.c        |   2 +-
 tools/testing/selftests/x86/xstate.h               |   2 +-
 440 files changed, 8032 insertions(+), 1802 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-kernel-kexec-kdump
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-kexec-kdump
 create mode 100644 Documentation/core-api/liveupdate.rst
 create mode 100644 Documentation/driver-api/hw-recoverable-errors.rst
 create mode 100644 Documentation/mm/memfd_preservation.rst
 create mode 100644 Documentation/userspace-api/liveupdate.rst
 create mode 100644 include/linux/kho/abi/luo.h
 create mode 100644 include/linux/kho/abi/memfd.h
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/uapi/linux/liveupdate.h
 delete mode 100644 kernel/kexec_handover_internal.h
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (75%)
 rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
 create mode 100644 kernel/liveupdate/kexec_handover_debugfs.c
 create mode 100644 kernel/liveupdate/kexec_handover_internal.h
 create mode 100644 kernel/liveupdate/luo_core.c
 create mode 100644 kernel/liveupdate/luo_file.c
 create mode 100644 kernel/liveupdate/luo_internal.h
 create mode 100644 kernel/liveupdate/luo_session.c
 create mode 100644 lib/tests/base64_kunit.c
 create mode 100644 mm/memfd_luo.c
 create mode 100644 scripts/gdb/linux/bpf.py
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100755 tools/testing/selftests/liveupdate/do_kexec.sh
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_kexec_simple.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.h

