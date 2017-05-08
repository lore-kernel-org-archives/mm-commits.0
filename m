From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 8 May 2017 15:53:55 -0700
Message-ID: <20170508155355.a0a32216272a653f0f252faf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbdEHWx5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- the rest of MM

- various misc things

- procfs updates

- lib/ updates

- checkpatch updates

- kdump/kexec updates

- add kvmalloc helpers, use them

- time helper updates for Y2038 issues.  We're almost ready to remove
  current_fs_time() but that awaits a btrfs merge.

- add tracepoints to DAX.


114 patches, based on 13e0988140374123bead1dd27c287354cb95108e:

Subject: mm, compaction: reorder fields in struct compact_control
Subject: mm, compaction: remove redundant watermark check in compact_finished()
Subject: mm, page_alloc: split smallest stolen page in fallback
Subject: mm, page_alloc: count movable pages when stealing from pageblock
Subject: mm, compaction: change migrate_async_suitable() to suitable_migration_source()
Subject: mm, compaction: add migratetype to compact_control
Subject: mm, compaction: restrict async compaction to pageblocks of same migratetype
Subject: mm, compaction: finish whole pageblock to reduce fragmentation
Subject: fs/proc/inode.c: remove cast from memory allocation
Subject: proc/sysctl: fix the int overflow for jiffies conversion
Subject: drivers/virt/fsl_hypervisor.c: use get_user_pages_unlocked()
Subject: jiffies.h: declare jiffies and jiffies_64 with ____cacheline_aligned_in_smp
Subject: make help: add tools help target
Subject: kernel/hung_task.c: defer showing held locks
Subject: drivers/misc/vmw_vmci/vmci_queue_pair.c: fix a couple integer overflow tests
Subject: drivers/misc/c2port/c2port-duramar2150.c: checking for NULL instead of IS_ERR()
Subject: Revert "lib/test_sort.c: make it explicitly non-modular"
Subject: lib: add module support to array-based sort tests
Subject: lib: add module support to linked list sorting tests
Subject: firmware/Makefile: force recompilation if makefile changes
Subject: checkpatch: remove obsolete CONFIG_EXPERIMENTAL checks
Subject: checkpatch: add ability to find bad uses of vsprintf %p<foo> extensions
Subject: checkpatch: improve EMBEDDED_FUNCTION_NAME test
Subject: checkpatch: allow space leading blank lines in email headers
Subject: checkpatch: avoid suggesting struct definitions should be const
Subject: checkpatch: improve MULTISTATEMENT_MACRO_USE_DO_WHILE test
Subject: checkpatch: clarify the EMBEDDED_FUNCTION_NAME message
Subject: checkpatch: special audit for revert commit line
Subject: checkpatch: improve k.alloc with multiplication and sizeof test
Subject: checkpatch: add --typedefsfile
Subject: checkpatch: improve the embedded function name test for patch contexts
Subject: checkpatch: improve the SUSPECT_CODE_INDENT test
Subject: reiserfs: use designated initializers
Subject: fork: free vmapped stacks in cache when cpus are offline
Subject: cpumask: make "nr_cpumask_bits" unsigned
Subject: crash: move crashkernel parsing and vmcore related code under CONFIG_CRASH_CORE
Subject: ia64: reuse append_elf_note() and final_note() functions
Subject: powerpc/fadump: remove dependency with CONFIG_KEXEC
Subject: powerpc/fadump: reuse crashkernel parameter for fadump memory reservation
Subject: powerpc/fadump: update documentation about crashkernel parameter reuse
Subject: pidns: disable pid allocation if pid_ns_prepare_proc() is failed in alloc_pid()
Subject: ns: allow ns_entries to have custom symlink content
Subject: pidns: expose task pid_ns_for_children to userspace
Subject: taskstats: add e/u/stime for TGID command
Subject: kcov: simplify interrupt check
Subject: lib/fault-inject.c: use correct check for interrupts
Subject: lib/zlib_inflate/inftrees.c: fix potential buffer overflow
Subject: initramfs: provide a way to ignore image provided by bootloader
Subject: initramfs: use vfs_stat/lstat directly
Subject: ipc/shm: some shmat cleanups
Subject: sysv,ipc: cacheline align kern_ipc_perm
Subject: mm: introduce kv[mz]alloc helpers
Subject: mm, vmalloc: properly track vmalloc users
Subject: mm: support __GFP_REPEAT in kvmalloc_node for >32kB
Subject: lib/rhashtable.c: simplify a strange allocation pattern
Subject: net/ipv6/ila/ila_xlat.c: simplify a strange allocation pattern
Subject: fs/xattr.c: zero out memory copied to userspace in getxattr
Subject: treewide: use kv[mz]alloc* rather than opencoded variants
Subject: net: use kvmalloc with __GFP_REPEAT rather than open coded variant
Subject: drivers/md/dm-ioctl.c: use kvmalloc rather than opencoded variant
Subject: drivers/md/bcache/super.c: use kvmalloc
Subject: mm, swap: use kvzalloc to allocate some swap data structures
Subject: mm, vmalloc: use __GFP_HIGHMEM implicitly
Subject: scripts/spelling.txt: add "memory" pattern and fix typos
Subject: scripts/spelling.txt: add regsiter -> register spelling mistake
Subject: scripts/spelling.txt: add "intialise(d)" pattern and fix typo instances
Subject: treewide: spelling: correct diffrent[iate] and banlance typos
Subject: treewide: move set_memory_* functions away from cacheflush.h
Subject: arm: use set_memory.h header
Subject: arm64: use set_memory.h header
Subject: s390: use set_memory.h header
Subject: x86: use set_memory.h header
Subject: agp: use set_memory.h header
Subject: drm: use set_memory.h header
Subject: drivers/hwtracing/intel_th/msu.c: use set_memory.h header
Subject: drivers/watchdog/hpwdt.c: use set_memory.h header
Subject: include/linux/filter.h: use set_memory.h header
Subject: kernel/module.c: use set_memory.h header
Subject: kernel/power/snapshot.c: use set_memory.h header
Subject: alsa: use set_memory.h header
Subject: drivers/misc/sram-exec.c: use set_memory.h header
Subject: drivers/video/fbdev/vermilion/vermilion.c: use set_memory.h header
Subject: drivers/staging/media/atomisp/pci/atomisp2: use set_memory.h
Subject: treewide: decouple cacheflush.h and set_memory.h
Subject: kref: remove WARN_ON for NULL release functions
Subject: drivers/scsi/megaraid: remove expensive inline from megasas_return_cmd
Subject: include/linux/uaccess.h: remove expensive WARN_ON in pagefault_disabled_dec
Subject: fs: semove set but not checked AOP_FLAG_UNINTERRUPTIBLE flag
Subject: Documentation/vm/transhuge.txt: fix trivial typos
Subject: format-security: move static strings to const
Subject: fs: f2fs: use ktime_get_real_seconds for sit_info times
Subject: trace: make trace_hwlat timestamp y2038 safe
Subject: fs: cifs: replace CURRENT_TIME by other appropriate apis
Subject: fs: ceph: CURRENT_TIME with ktime_get_real_ts()
Subject: fs: ufs: use ktime_get_real_ts64() for birthtime
Subject: fs: ubifs: replace CURRENT_TIME_SEC with current_time
Subject: lustre: replace CURRENT_TIME macro
Subject: apparmorfs: replace CURRENT_TIME with current_time()
Subject: gfs2: replace CURRENT_TIME with current_time
Subject: time: delete CURRENT_TIME_SEC and CURRENT_TIME
Subject: mm/huge_memory.c: use zap_deposited_table() more
Subject: mm/huge_memory.c: deposit a pgtable for DAX PMD faults when required
Subject: mm: prevent potential recursive reclaim due to clearing PF_MEMALLOC
Subject: mm: introduce memalloc_noreclaim_{save,restore}
Subject: treewide: convert PF_MEMALLOC manipulations to new helpers
Subject: mtd: nand: nandsim: convert to memalloc_noreclaim_*()
Subject: dax: add tracepoints to dax_iomap_pte_fault()
Subject: dax: add tracepoints to dax_pfn_mkwrite()
Subject: dax: add tracepoints to dax_load_hole()
Subject: dax: add tracepoints to dax_writeback_mapping_range()
Subject: dax: add tracepoint to dax_writeback_one()
Subject: dax: add tracepoint to dax_insert_mapping()
Subject: selftests/vm: add a test for virtual address range mapping
Subject: drivers/staging/ccree/ssi_hash.c: fix build with gcc-4.4.4



