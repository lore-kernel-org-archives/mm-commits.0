Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E77C1A275;
	Thu, 12 Feb 2026 18:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770922197; cv=none; b=Vyn+6+qRrw084mOXcMXmlxVfxl6DN8OvmLQSMXCiwwwgQpKoOOnAqd1/u6IIHGJmjdXS9Co5geNYfhMIN/5EOBebKwRcpIFVTq1nG3Ua26KdD+lOHxAErnVXtGewWwrKwD0hj6+blewGF91mLTILr0wvP0WHk10riKwXImNs84Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770922197; c=relaxed/simple;
	bh=g05igaccAA838+V0Sp/aZQf9YPg8wlju5Y/vaV6qXJk=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Nku/kIZxGd420M7wQzKa74dWSwHf3IKeVuWc+PpiAHAhGyOBfSDZ8w0M/7D/MCWpM8jK+BuCgSrDecK8Ep8DqN/rjPVLeZbaP5JaoaZqSpyyg0E65TnDbyjyHCcevPx+/XbQY/xw3fxWVqIC1CzPrnYXYvUg7jwAQikJLBuaYDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FRtY5+rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FRtY5+rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8261C16AAE;
	Thu, 12 Feb 2026 18:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770922196;
	bh=g05igaccAA838+V0Sp/aZQf9YPg8wlju5Y/vaV6qXJk=;
	h=Date:From:To:Cc:Subject:From;
	b=FRtY5+rbyVaMuIs8J0f0EOeLxiWNLXYBKWuZ9VNXRrUFLi94bofAeV8SwkVRve3Ix
	 PYpg4GBWDCh79g1ediI7d3C9otydcZLd6iiGEWEWoginb8ABnO9xRqSikjIfJW5N/M
	 u542qVi5wy8gn+bw2vdS28dOGfak8C6KuAtnZCTY=
Date: Thu, 12 Feb 2026 10:49:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] non-MM updates for 7.0-rc1
Message-Id: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Linus, please merge this first and main batch of other-than-MM updates
for the 7.0-rcX cycle, thanks.


Conflicts which I'm presently seeing, along with their possible
resolutions are:

Documentation/core-api/kho/index.rst, vs jc_docs tree:
	https://lkml.kernel.org/r/aXeZQy24nAzwEKF3@sirena.org.uk
(unhelpful!  But it's simple)

drivers/gpu/drm/amd/amdkfd/kfd_process.c, vs drm tree
	https://lkml.kernel.org/r/aXjJCmDiKFYA0-P6@sirena.org.uk
(also unhelpful, also trivial)

fs/fat/dir.c, vs vfs-brauner tree
	https://lkml.kernel.org/r/20260113122141.1de833ab@canb.auug.org.au

lib/Kconfig.debug, vs tip tree
	https://lkml.kernel.org/r/20260107131112.69183629@canb.auug.org.au



Possible forthcoming build errors:

drivers/usb/gadget/function/..., vs usb tree:
	https://lkml.kernel.org/r/20260113150752.2e2238f2@canb.auug.org.au


Possible forthcoming conflicts:

kernel/cpu.c, vs spdx tree:
	https://lkml.kernel.org/r/aW912Qvlf_n2S8f6@sirena.org.uk

kernel/trace/trace.c, vs ftrace tree:
	https://lkml.kernel.org/r/aYoAtbc4L0N-g6C-@sirena.co.uk
	https://lkml.kernel.org/r/20260209120655.2045ea9f@gandalf.local.home



The following changes since commit bd58782995a2e6a07fd07255f3cc319f40b131c9:

  vmcoreinfo: make hwerr_data visible for debugging (2026-01-26 19:03:49 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-02-12-10-48

for you to fetch changes up to 0dddf20b4fd4afd59767acc144ad4da60259f21f:

  watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency (2026-02-08 00:13:35 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-nonmm-stable

Total patches:       107
Reviews/patch:       1.07
Reviewed rate:       67%

- The 2 patch series "ocfs2: give ocfs2 the ability to reclaim
  suballocator free bg" from Heming Zhao saves disk space by teaching
  ocfs2 to reclaim suballocator block group space.

- The 4 patch series "Add ARRAY_END(), and use it to fix off-by-one
  bugs" from Alejandro Colomar adds the ARRAY_END() macro and uses it in
  various places.

- The 2 patch series "vmcoreinfo: support VMCOREINFO_BYTES larger than
  PAGE_SIZE" from Pnina Feder makes the vmcore code future-safe, if
  VMCOREINFO_BYTES ever exceeds the page size.

- The 7 patch series "kallsyms: Prevent invalid access when showing
  module buildid" from Petr Mladek cleans up kallsyms code related to
  module buildid and fixes an invalid access crash when printing
  backtraces.

- The 3 patch series "Address page fault in
  ima_restore_measurement_list()" from Harshit Mogalapalli fixes a
  kexec-related crash that can occur when booting the second-stage kernel
  on x86.

- The 6 patch series "kho: ABI headers and Documentation updates" from
  Mike Rapoport updates the kexec handover ABI documentation.

- The 4 patch series "Align atomic storage" from Finn Thain adds the
  __aligned attribute to atomic_t and atomic64_t definitions to get
  natural alignment of both types on csky, m68k, microblaze, nios2,
  openrisc and sh.

- The 2 patch series "kho: clean up page initialization logic" from
  Pratyush Yadav simplifies the page initialization logic in
  kho_restore_page().

- The 6 patch series "Unload linux/kernel.h" from Yury Norov moves
  several things out of kernel.h and into more appropriate places.

- The 7 patch series "don't abuse task_struct.group_leader" from Oleg
  Nesterov removes the usage of ->group_leader when it is "obviously
  unnecessary".

- The 5 patch series "list private v2 & luo flb" from Pasha Tatashin
  adds some infrastructure improvements to the live update orchestrator.

----------------------------------------------------------------
Alan Maguire (1):
      kcsan, compiler_types: avoid duplicate type issues in BPF Type Format

Alejandro Colomar (4):
      array_size.h: add ARRAY_END()
      mm: fix benign off-by-one bugs
      kernel: fix off-by-one benign bugs
      mm: use ARRAY_END() instead of open-coding it

Alice Ryhl (1):
      rust: task: restrict Task::group_leader() to current

Andrew Morton (1):
      Merge branch 'mm-hotfixes-stable' into mm-nonmm-stable to pick up changes required to merge "kho: use unsigned long for nr_pages".

Arnd Bergmann (1):
      delayacct: fix uapi timespec64 definition

Chaitanya Mishra (1):
      lib/kstrtox: fix kstrtobool() docstring to mention enabled/disabled

Christian Marangi (1):
      resource: provide 0args DEFINE_RES variant for unset resource desc

Christophe JAILLET (2):
      crash_dump: constify struct configfs_item_operations and configfs_group_operations
      ocfs2: constify struct configfs_item_operations and configfs_group_operations

Deepanshu Kartikey (3):
      ocfs2: validate i_refcount_loc when refcount flag is set
      ocfs2: validate inline data i_size during inode read
      ocfs2: add check for free bits before allocation in ocfs2_move_extent()

Dmitry Antipov (2):
      ocfs2: adjust ocfs2_xa_remove_entry() to match UBSAN boundary checks
      ocfs2: annotate more flexible array members with __counted_by_le()

Edward Adam Davis (1):
      ocfs2: fix oob in __ocfs2_find_path

Eric Dumazet (1):
      scripts/bloat-o-meter: ignore __noinstr_text_start

Evangelos Petrongonas (1):
      kho: skip memoryless NUMA nodes when reserving scratch areas

Finn Thain (3):
      bpf: explicitly align bpf_res_spin_lock
      atomic: specify alignment for atomic_t and atomic64_t
      atomic: add option for weaker alignment check

Haoxiang Li (1):
      rapidio: replace rio_free_net() with kfree() in rio_scan_alloc_net()

Harshit Mogalapalli (3):
      ima: verify the previous kernel's IMA buffer lies in addressable RAM
      of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()
      x86/kexec: add a sanity check on previous kernel's ima kexec buffer

Heming Zhao (3):
      ocfs2: give ocfs2 the ability to reclaim suballocator free bg
      ocfs2: detect released suballocator BG for fh_to_[dentry|parent]
      ocfs2: fix reflink preserve cleanup issue

James Bottomley (1):
      oid_registry: allow arbitrary size OIDs

Jason Miu (2):
      kho: introduce KHO FDT ABI header
      kho: relocate vmalloc preservation structure to KHO ABI header

Jinliang Zheng (1):
      procfs: fix missing RCU protection when reading real_parent in do_task_stat()

Joe Perches (1):
      checkpatch: add an invalid patch separator test

Julia Lawall (1):
      ocfs2: adjust function name reference

Kari Argillander (1):
      editorconfig: add rst extension

Kevin Hao (1):
      .editorconfig: respect .editorconfig settings from parent directories

Kir Chou (1):
      lib/glob: convert selftest to KUnit

Lalit Shankar Chowdhury (1):
      fat: remove unused parameter

Li Chen (1):
      kexec: derive purgatory entry from symbol

Li RongQing (1):
      watchdog: softlockup: panic when lockup duration exceeds N thresholds

Lillian Berry (1):
      init/main.c: check if rdinit was explicitly set before printing warning

Long Wei (2):
      kho: test: clean up residual memory upon test_kho module unload
      kho: remove duplicate header file references

Maciej W. Rozycki (1):
      linux/log2.h: reduce instruction count for is_power_of_2()

Mathieu Desnoyers (1):
      tsacct: skip all kernel threads

Mike Rapoport (Microsoft) (5):
      kho/abi: luo: make generated documentation more coherent
      kho/abi: memfd: make generated documentation more coherent
      kho: docs: combine concepts and FDT documentation
      kho/abi: add memblock ABI header
      kho: cleanup error handling in kho_populate()

Minu Jin (1):
      fork-comment-fix: remove ambiguous question mark in CLONE_CHILD_CLEARTID comment

Nathan Chancellor (1):
      compiler-clang.h: require LLVM 19.1.0 or higher for __typeof_unqual__

Oleg Nesterov (7):
      android/binder: don't abuse current->group_leader
      android/binder: use same_thread_group(proc->tsk, current) in binder_mmap()
      drm/amdgpu: don't abuse current->group_leader
      drm/amd: kill the outdated "Only the pthreads threading model is supported" checks
      drm/pan*: don't abuse current->group_leader
      RDMA/umem: don't abuse current->group_leader
      netclassid: use thread_group_leader(p) in update_classid_task()

Ondrej Mosnacek (2):
      ipc: don't audit capability check in ipc_permissions()
      ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()

Pasha Tatashin (6):
      liveupdate: separate memfd support into LIVEUPDATE_MEMFD
      list: add primitives for private list manipulations
      list: add kunit test for private list primitives
      liveupdate: luo_file: Use private list
      liveupdate: luo_flb: introduce File-Lifecycle-Bound global state
      tests/liveupdate: add in-kernel liveupdate test

Peter Zijlstra (1):
      atomic: add alignment check to instrumented atomic operations

Petr Mladek (7):
      kallsyms: clean up @namebuf initialization in kallsyms_lookup_buildid()
      kallsyms: clean up modname and modbuildid initialization in kallsyms_lookup_buildid()
      module: add helper function for reading module_buildid()
      kallsyms: cleanup code for appending the module buildid
      kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()
      kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()
      kallsyms: prevent module removal when printing module name and buildid

Pnina Feder (3):
      kernel: vmcoreinfo: allocate vmcoreinfo_data based on VMCOREINFO_BYTES
      kernel/crash: handle multi-page vmcoreinfo in crash kernel copy
      panic: add panic_force_cpu= parameter to redirect panic to a specific CPU

Pratyush Yadav (2):
      kho: use unsigned long for nr_pages
      kho: simplify page initialization in kho_restore_page()

Pratyush Yadav (Google) (1):
      kho: print which scratch buffer failed to be reserved

Prithvi Tambewagh (1):
      ocfs2: add validate function for slot map blocks

Qiliang Yuan (1):
      watchdog/hardlockup: simplify perf event probe and remove per-cpu dependency

Randy Dunlap (3):
      kernel.h: drop hex.h and update all hex.h users
      kfifo: fix kmalloc_array_node() argument order
      kernel-chktaint: add reporting for tainted modules

Ryota Sakamoto (2):
      lib/tests: convert test_uuid module to KUnit
      lib/tests: convert test_min_heap module to KUnit

Shengming Hu (1):
      watchdog/softlockup: fix sample ring index wrap in need_counting_irqs()

Steven Rostedt (1):
      tracing: remove size parameter in __trace_puts()

Sun Jian (1):
      init/main: read bootconfig header with get_unaligned_le32()

Thomas Weißschuh (2):
      ipc/shm: uapi: remove dependency on libc
      types: drop definition of __EXPORTED_HEADERS__

Tomas Glozar (1):
      lib/Kconfig.debug: fix BOOTPARAM_HUNG_TASK_PANIC comment

Tony Luck (1):
      once: don't use a work queue to reset sleepable static key

Tycho Andersen (AMD) (1):
      kho: fix doc for kho_restore_pages()

Vasily Gorbik (1):
      crash_dump: fix dm_crypt keys locking and ref leak

Wang Yaxin (1):
      delayacct: add timestamp of delay max

Wangyang Guo (1):
      lib/group_cpus: make group CPU cluster aware

Yury Norov (5):
      kernel.h: drop STACK_MAGIC macro
      moduleparam: include required headers explicitly
      kernel.h: move VERIFY_OCTAL_PERMISSIONS() to sysfs.h
      kernel.h: include linux/instruction_pointer.h explicitly
      tracing: move tracing declarations from kernel.h to a dedicated header

Zhiyu Zhang (1):
      fat: avoid parent link count underflow in rmdir

mingzhu.wang(王明珠) (1):
      kernel/fork: update obsolete use_mm references to kthread_use_mm

 .editorconfig                                      |   4 +-
 Documentation/accounting/delay-accounting.rst      |  32 +-
 Documentation/admin-guide/kernel-parameters.txt    |  25 +-
 Documentation/core-api/kho/abi.rst                 |  28 +
 Documentation/core-api/kho/bindings/kho.yaml       |  43 --
 .../core-api/kho/bindings/memblock/memblock.yaml   |  39 --
 .../kho/bindings/memblock/reserve-mem.yaml         |  40 --
 Documentation/core-api/kho/bindings/sub-fdt.yaml   |  27 -
 Documentation/core-api/kho/concepts.rst            |  74 ---
 Documentation/core-api/kho/fdt.rst                 |  80 ---
 Documentation/core-api/kho/index.rst               |  82 ++-
 Documentation/core-api/list.rst                    |   9 +
 Documentation/core-api/liveupdate.rst              |  13 +-
 Documentation/dev-tools/checkpatch.rst             |   5 +
 Documentation/filesystems/sysfs.rst                |   2 +-
 Documentation/mm/memfd_preservation.rst            |   2 +-
 MAINTAINERS                                        |   8 +-
 arch/arm/configs/aspeed_g5_defconfig               |   2 +-
 arch/arm/configs/pxa3xx_defconfig                  |   2 +-
 arch/arm64/net/bpf_jit_comp.c                      |   2 +-
 arch/loongarch/net/bpf_jit.c                       |   2 +-
 arch/m68k/configs/amiga_defconfig                  |   3 -
 arch/m68k/configs/apollo_defconfig                 |   3 -
 arch/m68k/configs/atari_defconfig                  |   3 -
 arch/m68k/configs/bvme6000_defconfig               |   3 -
 arch/m68k/configs/hp300_defconfig                  |   3 -
 arch/m68k/configs/mac_defconfig                    |   3 -
 arch/m68k/configs/multi_defconfig                  |   3 -
 arch/m68k/configs/mvme147_defconfig                |   3 -
 arch/m68k/configs/mvme16x_defconfig                |   3 -
 arch/m68k/configs/q40_defconfig                    |   3 -
 arch/m68k/configs/sun3_defconfig                   |   3 -
 arch/m68k/configs/sun3x_defconfig                  |   3 -
 arch/mips/kernel/setup.c                           |   1 +
 arch/mips/rb532/devices.c                          |   1 +
 arch/openrisc/configs/or1klitex_defconfig          |   2 +-
 arch/powerpc/configs/ppc64_defconfig               |   2 -
 arch/powerpc/configs/skiroot_defconfig             |   2 +-
 arch/powerpc/kernel/btext.c                        |   1 +
 arch/powerpc/net/bpf_jit_comp.c                    |   2 +-
 arch/s390/configs/debug_defconfig                  |   2 +-
 arch/s390/include/asm/processor.h                  |   1 +
 arch/s390/kernel/alternative.c                     |   1 +
 arch/s390/kernel/stackprotector.c                  |   1 +
 arch/um/drivers/vector_kern.c                      |   1 +
 arch/x86/kernel/setup.c                            |   6 +
 arch/xtensa/platforms/iss/network.c                |   1 +
 certs/blacklist.c                                  |   1 +
 crypto/asymmetric_keys/asymmetric_type.c           |   1 +
 crypto/asymmetric_keys/x509_public_key.c           |   1 +
 crypto/krb5/selftest.c                             |   1 +
 drivers/android/binder.c                           |   9 +-
 drivers/android/binder_alloc.c                     |   2 +-
 drivers/atm/nicstar.c                              |   1 +
 drivers/auxdisplay/hd44780_common.c                |   1 +
 drivers/auxdisplay/lcd2s.c                         |   1 +
 drivers/block/floppy.c                             |   2 -
 drivers/bus/moxtet.c                               |   1 +
 drivers/char/tpm/tpm.h                             |   1 +
 drivers/comedi/drivers/jr3_pci.c                   |   1 +
 drivers/firmware/broadcom/bcm47xx_sprom.c          |   1 +
 drivers/gpio/gpio-macsmc.c                         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  10 -
 drivers/gpu/drm/ci/arm.config                      |   2 +-
 drivers/gpu/drm/ci/arm64.config                    |   2 +-
 drivers/gpu/drm/ci/x86_64.config                   |   2 +-
 drivers/gpu/drm/i915/gt/selftest_ring_submission.c |   1 +
 drivers/gpu/drm/i915/i915_selftest.h               |   2 +
 drivers/gpu/drm/panfrost/panfrost_gem.c            |   2 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |   2 +-
 drivers/hid/hid-picolcd_debugfs.c                  |   1 +
 drivers/hwmon/pmbus/q54sj108a2.c                   |   1 +
 drivers/hwmon/pmbus/ucd9000.c                      |   1 +
 drivers/infiniband/core/umem_odp.c                 |   4 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   1 +
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   1 +
 drivers/input/touchscreen/iqs5xx.c                 |   1 +
 drivers/md/dm-crypt.c                              |   1 +
 drivers/md/dm-integrity.c                          |   1 +
 drivers/md/dm-verity-target.c                      |   1 +
 .../extron-da-hd-4k-plus/extron-da-hd-4k-plus.c    |   1 +
 drivers/media/cec/usb/rainshadow/rainshadow-cec.c  |   1 +
 drivers/media/i2c/ccs/ccs-reg-access.c             |   1 +
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c       |   1 +
 drivers/misc/kgdbts.c                              |   1 +
 drivers/misc/pch_phub.c                            |   1 +
 drivers/net/bonding/bond_options.c                 |   1 +
 drivers/net/can/can327.c                           |   1 +
 drivers/net/can/slcan/slcan-core.c                 |   1 +
 drivers/net/ethernet/chelsio/cxgb3/common.h        |   1 +
 .../mellanox/mlx5/core/steering/sws/dr_dbg.c       |   1 +
 drivers/net/ethernet/micrel/ksz884x.c              |   1 +
 drivers/net/ethernet/pasemi/pasemi_mac.c           |   1 +
 drivers/net/netconsole.c                           |   1 +
 drivers/net/netdevsim/dev.c                        |   1 +
 drivers/net/usb/r8152.c                            |   1 +
 drivers/net/usb/usbnet.c                           |   1 +
 drivers/net/wireless/ath/ath6kl/debug.c            |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |   1 +
 drivers/net/wireless/intel/iwlwifi/mld/debugfs.c   |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   1 +
 drivers/net/wireless/realtek/rtw89/debug.c         |   1 +
 drivers/net/wireless/silabs/wfx/fwio.c             |   1 +
 drivers/nvme/target/configfs.c                     |   1 +
 drivers/nvme/target/core.c                         |   1 +
 drivers/nvmem/brcm_nvram.c                         |   1 +
 drivers/nvmem/layouts/u-boot-env.c                 |   1 +
 drivers/of/kexec.c                                 |  15 +-
 drivers/platform/x86/intel/wmi/thunderbolt.c       |   1 +
 drivers/pnp/support.c                              |   1 +
 drivers/ptp/ptp_pch.c                              |   1 +
 drivers/rapidio/rio-scan.c                         |   3 +-
 drivers/s390/cio/blacklist.c                       |   1 +
 drivers/s390/crypto/ap_bus.c                       |   1 +
 drivers/s390/crypto/zcrypt_cex4.c                  |   1 +
 drivers/s390/virtio/virtio_ccw.c                   |   1 +
 drivers/scsi/aacraid/rx.c                          |   1 +
 drivers/scsi/ips.c                                 |   1 +
 drivers/scsi/libsas/sas_scsi_host.c                |   1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   1 +
 drivers/scsi/scsi_transport_fc.c                   |   1 +
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |   1 +
 drivers/target/iscsi/iscsi_target_auth.c           |   1 +
 drivers/target/target_core_fabric_lib.c            |   1 +
 drivers/target/target_core_spc.c                   |   1 +
 drivers/target/tcm_fc/tfc_conf.c                   |   1 +
 drivers/thunderbolt/switch.c                       |   1 +
 drivers/tty/vt/vt.c                                |   1 +
 drivers/ufs/core/ufshcd.c                          |   1 +
 drivers/usb/atm/speedtch.c                         |   1 +
 drivers/usb/atm/ueagle-atm.c                       |   1 +
 drivers/usb/gadget/function/u_ether.c              |   1 +
 drivers/usb/gadget/function/uvc_configfs.c         |   1 +
 drivers/usb/typec/ucsi/debugfs.c                   |   1 +
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   1 +
 drivers/watchdog/hpwdt.c                           |   1 +
 fs/adfs/dir.c                                      |   1 +
 fs/binfmt_misc.c                                   |   1 +
 fs/ecryptfs/ecryptfs_kernel.h                      |   1 +
 fs/efivarfs/vars.c                                 |   1 +
 fs/fat/cache.c                                     |   4 +-
 fs/fat/dir.c                                       |   1 +
 fs/fat/namei_msdos.c                               |   7 +-
 fs/fat/namei_vfat.c                                |   8 +-
 fs/gfs2/lock_dlm.c                                 |   1 +
 fs/nfsd/nfs4recover.c                              |   1 +
 fs/ntfs3/ntfs_fs.h                                 |   1 +
 fs/ocfs2/alloc.c                                   |   9 +-
 fs/ocfs2/cluster/heartbeat.c                       |   4 +-
 fs/ocfs2/cluster/nodemanager.c                     |   8 +-
 fs/ocfs2/dlm/dlmdomain.c                           |   2 +-
 fs/ocfs2/export.c                                  |   6 +-
 fs/ocfs2/inode.c                                   |  32 +-
 fs/ocfs2/localalloc.c                              |   4 +-
 fs/ocfs2/move_extents.c                            |   7 +-
 fs/ocfs2/ocfs2_fs.h                                |   4 +-
 fs/ocfs2/slot_map.c                                |  27 +-
 fs/ocfs2/suballoc.c                                | 334 ++++++++++-
 fs/ocfs2/xattr.c                                   |   9 +-
 fs/overlayfs/namei.c                               |   1 +
 fs/proc/array.c                                    |   3 +-
 fs/seq_file.c                                      |   1 +
 fs/udf/unicode.c                                   |   1 +
 include/asm-generic/atomic64.h                     |   2 +-
 include/asm-generic/rqspinlock.h                   |   2 +-
 include/linux/array_size.h                         |   6 +
 include/linux/capability.h                         |   6 +
 include/linux/compiler-clang.h                     |   2 +-
 include/linux/compiler_types.h                     |  23 +-
 include/linux/delayacct.h                          |   8 +
 include/linux/filter.h                             |  26 +-
 include/linux/ftrace.h                             |   6 +-
 include/linux/ima.h                                |   1 +
 include/linux/instrumented.h                       |  17 +
 include/linux/ioport.h                             |   7 +-
 include/linux/kernel.h                             | 211 +------
 include/linux/kexec_handover.h                     |  33 +-
 include/linux/kho/abi/kexec_handover.h             | 163 +++++
 include/linux/kho/abi/luo.h                        |  89 ++-
 include/linux/kho/abi/memblock.h                   |  73 +++
 include/linux/kho/abi/memfd.h                      |   6 +-
 include/linux/list_private.h                       | 256 ++++++++
 include/linux/liveupdate.h                         | 147 +++++
 include/linux/log2.h                               |   2 +-
 include/linux/module.h                             |   9 +
 include/linux/moduleparam.h                        |   7 +-
 include/linux/panic.h                              |   8 +
 include/linux/sched.h                              |   5 +
 include/linux/smp.h                                |   1 +
 include/linux/sysfs.h                              |  13 +
 include/linux/trace_printk.h                       | 204 +++++++
 include/linux/types.h                              |   3 +-
 include/linux/ww_mutex.h                           |   1 +
 include/uapi/linux/shm.h                           |   3 -
 include/uapi/linux/taskstats.h                     |  13 +-
 init/main.c                                        |  16 +-
 ipc/ipc_sysctl.c                                   |   2 +-
 kernel/audit.c                                     |   1 +
 kernel/bpf/core.c                                  |   5 +-
 kernel/bpf/rqspinlock.c                            |   1 -
 kernel/bpf/syscall.c                               |   1 +
 kernel/configs/debug.config                        |   2 +-
 kernel/crash_core.c                                |  17 +-
 kernel/crash_dump_dm_crypt.c                       |  21 +-
 kernel/debug/gdbstub.c                             |   1 +
 kernel/delayacct.c                                 |  33 +-
 kernel/fork.c                                      |   4 +-
 kernel/kallsyms.c                                  |  73 ++-
 kernel/kcsan/kcsan_test.c                          |   4 +-
 kernel/kexec_file.c                                | 131 +++--
 kernel/liveupdate/Kconfig                          |  17 +-
 kernel/liveupdate/Makefile                         |   1 +
 kernel/liveupdate/kexec_handover.c                 | 147 ++---
 kernel/liveupdate/luo_core.c                       |  10 +-
 kernel/liveupdate/luo_file.c                       |  39 +-
 kernel/liveupdate/luo_flb.c                        | 654 +++++++++++++++++++++
 kernel/liveupdate/luo_internal.h                   |  22 +-
 kernel/module/kallsyms.c                           |   9 +-
 kernel/panic.c                                     | 164 +++++-
 kernel/sched/stats.h                               |   8 +-
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/trace.c                               |   7 +-
 kernel/trace/trace.h                               |   2 +-
 kernel/tsacct.c                                    |   2 +-
 kernel/ucount.c                                    |   2 +-
 kernel/vmcore_info.c                               |   6 +-
 kernel/watchdog.c                                  |  12 +-
 kernel/watchdog_perf.c                             |  50 +-
 lib/Kconfig                                        |  13 -
 lib/Kconfig.debug                                  | 118 +++-
 lib/Makefile                                       |   3 -
 lib/build_OID_registry                             |  26 +-
 lib/globtest.c                                     | 167 ------
 lib/group_cpus.c                                   | 271 +++++++--
 lib/hexdump.c                                      |   1 +
 lib/kfifo.c                                        |   2 +-
 lib/kstrtox.c                                      |   4 +-
 lib/once.c                                         |   2 +-
 lib/string_helpers.c                               |   1 +
 lib/test_kho.c                                     |   7 +-
 lib/test_uuid.c                                    | 134 -----
 lib/tests/Makefile                                 |   5 +
 lib/tests/glob_kunit.c                             | 125 ++++
 lib/tests/list-private-test.c                      |  76 +++
 lib/tests/liveupdate.c                             | 158 +++++
 lib/{test_min_heap.c => tests/min_heap_kunit.c}    | 147 +++--
 lib/tests/uuid_kunit.c                             | 106 ++++
 lib/uuid.c                                         |   1 +
 lib/vsprintf.c                                     |   1 +
 mm/Makefile                                        |   2 +-
 mm/kfence/kfence_test.c                            |   4 +-
 mm/kmemleak.c                                      |   2 +-
 mm/kmsan/kmsan_test.c                              |   2 +-
 mm/memblock.c                                      |   4 +-
 mm/memcontrol-v1.c                                 |   4 +-
 net/bridge/br_sysfs_br.c                           |   1 +
 net/core/netclassid_cgroup.c                       |   2 +-
 net/core/pktgen.c                                  |   1 +
 net/core/utils.c                                   |   1 +
 net/ipv4/arp.c                                     |   1 +
 net/mac80211/debugfs_netdev.c                      |   1 +
 net/sunrpc/cache.c                                 |   1 +
 net/tipc/core.h                                    |   1 +
 rust/kernel/task.rs                                |  24 +-
 scripts/bloat-o-meter                              |   1 +
 scripts/checkpatch.pl                              |  10 +
 security/integrity/evm/evm_crypto.c                |   1 +
 security/integrity/ima/ima_api.c                   |   1 +
 security/integrity/ima/ima_kexec.c                 |  35 ++
 security/ipe/digest.c                              |   1 +
 security/keys/encrypted-keys/encrypted.c           |   1 +
 security/keys/trusted-keys/trusted_core.c          |   1 +
 security/keys/trusted-keys/trusted_tpm1.c          |   1 +
 security/loadpin/loadpin.c                         |   1 +
 security/selinux/selinuxfs.c                       |   1 +
 sound/pci/riptide/riptide.c                        |   1 +
 sound/usb/6fire/firmware.c                         |   1 +
 tools/accounting/getdelays.c                       | 172 +++++-
 tools/debugging/kernel-chktaint                    |  18 +-
 tools/testing/selftests/bpf/config                 |   2 +-
 .../testing/selftests/wireguard/qemu/kernel.config |   2 +-
 285 files changed, 4133 insertions(+), 1560 deletions(-)
 create mode 100644 Documentation/core-api/kho/abi.rst
 delete mode 100644 Documentation/core-api/kho/bindings/kho.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/memblock/memblock.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/sub-fdt.yaml
 delete mode 100644 Documentation/core-api/kho/concepts.rst
 delete mode 100644 Documentation/core-api/kho/fdt.rst
 create mode 100644 include/linux/kho/abi/kexec_handover.h
 create mode 100644 include/linux/kho/abi/memblock.h
 create mode 100644 include/linux/list_private.h
 create mode 100644 include/linux/trace_printk.h
 create mode 100644 kernel/liveupdate/luo_flb.c
 delete mode 100644 lib/globtest.c
 delete mode 100644 lib/test_uuid.c
 create mode 100644 lib/tests/glob_kunit.c
 create mode 100644 lib/tests/list-private-test.c
 create mode 100644 lib/tests/liveupdate.c
 rename lib/{test_min_heap.c => tests/min_heap_kunit.c} (58%)
 create mode 100644 lib/tests/uuid_kunit.c


