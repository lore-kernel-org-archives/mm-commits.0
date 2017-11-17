From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 17 Nov 2017 15:25:45 -0800
Message-ID: <20171117152545.40282646ce6ac51195a1af93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54460 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030461AbdKQXZs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:25:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- a bit more MM

- procfs updates

- dynamic-debug fixes

- lib/ updates

- checkpatch

- epoll

- nilfs2

- signals

- rapidio

- PID management cleanup and optimization

- kcov updates

- sysvipc updates

- quite a few misc things all over the place


94 patches, based on a3841f94c7ecb3ede0f888d3fcfe8fb6368ddd7a:

Subject: mm: fix nodemask printing
Subject: mm/z3fold.c: use kref to prevent page free/compact race
Subject: lib/dma-debug.c: fix incorrect pfn calculation
Subject: mm: shmem: remove unused info variable
Subject: mm, compaction: kcompactd should not ignore pageblock skip
Subject: mm, compaction: persistently skip hugetlbfs pageblocks
Subject: mm, compaction: extend pageblock_skip_persistent() to all compound pages
Subject: mm, compaction: split off flag for not updating skip hints
Subject: mm, compaction: remove unneeded pageblock_skip_persistent() checks
Subject: proc, coredump: add CoreDumping flag to /proc/pid/status
Subject: proc: : uninline name_to_int()
Subject: proc: use do-while in name_to_int()
Subject: spelling.txt: add "unnecessary" typo variants
Subject: sh/boot: add static stack-protector to pre-kernel
Subject: kernel debug: support resetting WARN*_ONCE
Subject: kernel debug: support resetting WARN_ONCE for all architectures
Subject: parse-maintainers: add ability to specify filenames
Subject: iopoll: avoid -Wint-in-bool-context warning
Subject: lkdtm: include WARN format string
Subject: bug: define the "cut here" string in a single place
Subject: bug: fix "cut here" location for __WARN_TAINT architectures
Subject: include/linux/compiler-clang.h: handle randomizable anonymous structs
Subject: kernel/umh.c: optimize 'proc_cap_handler()'
Subject: dynamic-debug-howto: fix optional/omitted ending line number to be LARGE instead of 0
Subject: dynamic_debug documentation: minor fixes
Subject: get_maintainer: add --self-test for internal consistency tests
Subject: get_maintainer: add more --self-test options
Subject: include/linux/bitfield.h: include <linux/build_bug.h> instead of <linux/bug.h>
Subject: include/linux/radix-tree.h: remove unneeded #include <linux/bug.h>
Subject: lib: add module support to string tests
Subject: lib/test: delete five error messages for failed memory allocations
Subject: lib/int_sqrt: optimize small argument
Subject: lib/int_sqrt: optimize initial value compute
Subject: lib/int_sqrt: adjust comments
Subject: lib/genalloc.c: make the avail variable an atomic_long_t
Subject: lib/nmi_backtrace.c: fix kernel text address leak
Subject: tools/lib/traceevent/parse-filter.c: clean up clang build warning
Subject: lib/rbtree-test: lower default params
Subject: lib: test module for find_*_bit() functions
Subject: checkpatch: support function pointers for unnamed function definition arguments
Subject: scripts/checkpatch.pl: avoid false warning missing break
Subject: checkpatch: printks always need a KERN_<LEVEL>
Subject: checkpatch: allow DEFINE_PER_CPU definitions to exceed line length
Subject: checkpatch: add TP_printk to list of logging functions
Subject: checkpatch: add --strict test for lines ending in [ or (
Subject: checkpatch: do not check missing blank line before builtin_*_driver
Subject: epoll: account epitem and eppoll_entry to kmemcg
Subject: epoll: avoid calling ep_call_nested() from ep_poll_safewake()
Subject: epoll: remove ep_call_nested() from ep_eventpoll_poll()
Subject: init/version.c: include <linux/export.h> instead of <linux/module.h>
Subject: autofs: don't fail mount for transient error
Subject: pipe: match pipe_max_size data type with procfs
Subject: pipe: avoid round_pipe_size() nr_pages overflow on 32-bit
Subject: pipe: add proc_dopipe_max_size() to safely assign pipe_max_size
Subject: sysctl: check for UINT_MAX before unsigned int min/max
Subject: fs/nilfs2: convert timers to use timer_setup()
Subject: nilfs2: fix race condition that causes file system corruption
Subject: fs, nilfs: convert nilfs_root.count from atomic_t to refcount_t
Subject: nilfs2: align block comments of nilfs_sufile_truncate_range() at *
Subject: nilfs2: use octal for unreadable permission macro
Subject: nilfs2: remove inode->i_version initialization
Subject: hfs/hfsplus: clean up unused variables in bnode.c
Subject: fat: remove redundant assignment of 0 to slots
Subject: kernel/signal.c: protect the traced SIGNAL_UNKILLABLE tasks from SIGKILL
Subject: kernel/signal.c: protect the SIGNAL_UNKILLABLE tasks from !sig_kernel_only() signals
Subject: kernel/signal.c: remove the no longer needed SIGNAL_UNKILLABLE check in complete_signal()
Subject: kdump: print a message in case parse_crashkernel_mem resulted in zero bytes
Subject: rapidio: constify rio_device_id
Subject: drivers/rapidio/devices/rio_mport_cdev.c: fix resource leak in error handling path in 'rio_dma_transfer()'
Subject: drivers/rapidio/devices/rio_mport_cdev.c: fix error handling in 'rio_dma_transfer()'
Subject: Documentation/sysctl/vm.txt: fix typo
Subject: kernel/sysctl.c: code cleanups
Subject: pid: replace pid bitmap implementation with IDR API
Subject: pid: remove pidhash
Subject: kernel/panic.c: add TAINT_AUX
Subject: kcov: remove pointless current != NULL check
Subject: kcov: support comparison operands collection
Subject: Makefile: support flag -fsanitizer-coverage=trace-cmp
Subject: kcov: update documentation
Subject: kernel/reboot.c: add devm_register_reboot_notifier()
Subject: drivers/watchdog: make use of devm_register_reboot_notifier()
Subject: initramfs: use time64_t timestamps
Subject: sysvipc: unteach ids->next_id for !CHECKPOINT_RESTORE
Subject: sysvipc: duplicate lock comments wrt ipc_addid()
Subject: sysvipc: properly name ipc_addid() limit parameter
Subject: sysvipc: make get_maxid O(1) again
Subject: mm: add infrastructure for get_user_pages_fast() benchmarking
Subject: drivers/pcmcia/sa1111_badge4.c: avoid unused function warning
Subject: arch/ia64/include/asm/topology.h: remove unused parent_node() macro
Subject: arch/sh/include/asm/topology.h: remove unused parent_node() macro
Subject: arch/sparc/include/asm/topology_64.h: remove unused parent_node() macro
Subject: arch/tile/include/asm/topology.h: remove unused parent_node() macro
Subject: include/asm-generic/topology.h: remove unused parent_node() macro
Subject: EXPERT Kconfig menu: fix broken EXPERT menu

