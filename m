From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 14 Dec 2016 15:04:01 -0800
Message-ID: <20161214150401.fd5ffeb35b306231e00fb5f4@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34216 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbcLNXDd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:03:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- a few misc things

- kexec updates

- DMA-mapping updates to better support networking DMA operations

- IPC updates

- various MM changes to improve DAX fault handling

- lots of radix-tree changes, mainly to the test suite.  All leading
  up to reimplementing the IDA/IDR code to be a wrapper layer over the
  radix-tree.  However the final trigger-pulling patch is held off for
  4.11.

114 patches, based on 775a2e29c3bbcf853432f47d3caa9ff8808807ad:

Subject: btrfs: better handle btrfs_printk() defaults
Subject: kernel/watchdog: use nmi registers snapshot in hardlockup handler
Subject: mm, compaction: allow compaction for GFP_NOFS requests
Subject: signals: avoid unnecessary taking of sighand->siglock
Subject: coredump: clarify "unsafe core_pattern" warning
Subject: Revert "kdump, vmcoreinfo: report memory sections virtual addresses"
Subject: kexec: export the value of phys_base instead of symbol address
Subject: kexec: add cond_resched into kimage_alloc_crash_control_pages
Subject: sysctl: add KERN_CONT to deprecated_sysctl_warning()
Subject: arch/arc: add option to skip sync on DMA mapping
Subject: arch/arm: add option to skip sync on DMA map and unmap
Subject: arch/avr32: add option to skip sync on DMA map
Subject: arch/blackfin: add option to skip sync on DMA map
Subject: arch/c6x: add option to skip sync on DMA map and unmap
Subject: arch/frv: add option to skip sync on DMA map
Subject: arch/hexagon: Add option to skip DMA sync as a part of mapping
Subject: arch/m68k: add option to skip DMA sync as a part of mapping
Subject: arch/metag: add option to skip DMA sync as a part of map and unmap
Subject: arch/microblaze: add option to skip DMA sync as a part of map and unmap
Subject: arch/mips: add option to skip DMA sync as a part of map and unmap
Subject: arch/nios2: add option to skip DMA sync as a part of map and unmap
Subject: arch/openrisc: add option to skip DMA sync as a part of mapping
Subject: arch/parisc: add option to skip DMA sync as a part of map and unmap
Subject: arch/powerpc: add option to skip DMA sync as a part of mapping
Subject: arch/sh: add option to skip DMA sync as a part of mapping
Subject: arch/sparc: add option to skip DMA sync as a part of map and unmap
Subject: arch/tile: add option to skip DMA sync as a part of map and unmap
Subject: arch/xtensa: add option to skip DMA sync as a part of mapping
Subject: dma: add calls for dma_map_page_attrs and dma_unmap_page_attrs
Subject: mm: add support for releasing multiple instances of a page
Subject: igb: update driver to make use of DMA_ATTR_SKIP_CPU_SYNC
Subject: igb: update code to better handle incrementing page count
Subject: relay: check array offset before using it
Subject: Kconfig: lib/Kconfig.debug: fix references to Documenation
Subject: Kconfig: lib/Kconfig.ubsan fix reference to ubsan documentation
Subject: kcov: add more missing includes
Subject: kernel/debug/debug_core.c: more properly delay for secondary CPUs
Subject: kdb: remove unused kdb_event handling
Subject: kdb: properly synchronize vkdb_printf() calls with other CPUs
Subject: kdb: call vkdb_printf() from vprintk_default() only when wanted
Subject: initramfs: select builtin initram compression algorithm on KConfig instead of Makefile
Subject: initramfs: allow again choice of the embedded initram compression algorithm
Subject: ipc: msg, make msgrcv work with LONG_MIN
Subject: ipc/shm.c: coding style fixes
Subject: posix-timers: give lazy compilers some help optimizing code away
Subject: drivers/net/wireless/intel/iwlwifi/dvm/calib.c: simplfy min() expression
Subject: ktest.pl: fix english
Subject: kernel/watchdog.c: move shared definitions to nmi.h
Subject: kernel/watchdog.c: move hardlockup detector to separate file
Subject: sparc: implement watchdog_nmi_enable and watchdog_nmi_disable
Subject: ipc/sem: do not call wake_sem_queue_do() prematurely
Subject: ipc/sem: rework task wakeups
Subject: ipc/sem: optimize perform_atomic_semop()
Subject: ipc/sem: explicitly inline check_restart
Subject: ipc/sem: use proper list api for pending_list wakeups
Subject: ipc/sem: simplify wait-wake loop
Subject: ipc/sem: avoid idr tree lookup for interrupted semop
Subject: mm: add locked parameter to get_user_pages_remote()
Subject: mm: unexport __get_user_pages_unlocked()
Subject: mm: join struct fault_env and vm_fault
Subject: mm: use vmf->address instead of of vmf->virtual_address
Subject: mm: use pgoff in struct vm_fault instead of passing it separately
Subject: mm: use passed vm_fault structure in __do_fault()
Subject: mm: trim __do_fault() arguments
Subject: mm: use passed vm_fault structure for in wp_pfn_shared()
Subject: mm: add orig_pte field into vm_fault
Subject: mm: allow full handling of COW faults in ->fault handlers
Subject: mm: factor out functionality to finish page faults
Subject: mm: move handling of COW faults into DAX code
Subject: mm: factor out common parts of write fault handling
Subject: mm: pass vm_fault structure into do_page_mkwrite()
Subject: mm: use vmf->page during WP faults
Subject: mm: move part of wp_page_reuse() into the single call site
Subject: mm: provide helper for finishing mkwrite faults
Subject: mm: change return values of finish_mkwrite_fault()
Subject: mm: export follow_pte()
Subject: dax: make cache flushing protected by entry lock
Subject: dax: protect PTE modification on WP fault by radix tree entry lock
Subject: dax: clear dirty entry tags on cache flush
Subject: tools: add WARN_ON_ONCE
Subject: radix tree test suite: allow GFP_ATOMIC allocations to fail
Subject: radix tree test suite: track preempt_count
Subject: radix tree test suite: free preallocated nodes
Subject: radix tree test suite: make runs more reproducible
Subject: radix tree test suite: iteration test misuses RCU
Subject: radix tree test suite: benchmark for iterator
Subject: radix tree test suite: use rcu_barrier
Subject: radix tree test suite: handle exceptional entries
Subject: radix tree test suite: record order in each item
Subject: tools: add more bitmap functions
Subject: radix tree test suite: use common find-bit code
Subject: radix-tree: fix typo
Subject: radix-tree: move rcu_head into a union with private_list
Subject: radix-tree: create node_tag_set()
Subject: radix-tree: make radix_tree_find_next_bit more useful
Subject: radix-tree: improve dump output
Subject: btrfs: fix race in btrfs_free_dummy_fs_info()
Subject: radix-tree: improve multiorder iterators
Subject: radix-tree: delete radix_tree_locate_item()
Subject: radix-tree: delete radix_tree_range_tag_if_tagged()
Subject: radix-tree: add radix_tree_join
Subject: radix-tree: add radix_tree_split
Subject: radix-tree: add radix_tree_split_preload()
Subject: radix-tree: fix replacement for multiorder entries
Subject: radix tree test suite: check multiorder iteration
Subject: idr: add ida_is_empty
Subject: tpm: use idr_find(), not idr_find_slowpath()
Subject: rxrpc: abstract away knowledge of IDR internals
Subject: idr: reduce the number of bits per level from 8 to 6
Subject: radix tree test suite: add some more functionality
Subject: radix tree test suite: cache recently freed objects
Subject: radix-tree: ensure counts are initialised
Subject: radix tree test suite: add new tag check
Subject: radix tree test suite: delete unused rcupdate.c

