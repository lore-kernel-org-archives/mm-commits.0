From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Tue, 6 Feb 2018 15:34:53 -0800
Message-ID: <20180206153453.fcd27537b60920f18369cab6@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52442 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753912AbeBFXe4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- kasan updates

- procfs

- lib/bitmap updates

- other lib/ updates

- checkpatch tweaks

- rapidio

- ubsan

- pipe fixes and cleanups

- lots of other misc bits


114 patches, based on e237f98a9c134c3d600353f21e07db915516875b:

Subject: kasan: don't emit builtin calls when sanitization is off
Subject: kasan: add compiler support for clang
Subject: kasan/Makefile: support LLVM style asan parameters
Subject: kasan: support alloca() poisoning
Subject: kasan: add tests for alloca poisoning
Subject: kasan: add functions for unpoisoning stack variables
Subject: kasan: detect invalid frees for large objects
Subject: kasan: don't use __builtin_return_address(1)
Subject: kasan: detect invalid frees for large mempool objects
Subject: kasan: unify code between kasan_slab_free() and kasan_poison_kfree()
Subject: kasan: detect invalid frees
Subject: kasan: fix prototype author email address
Subject: kasan: clean up KASAN_SHADOW_SCALE_SHIFT usage
Subject: kasan: remove redundant initialization of variable 'real_size'
Subject: proc: use %u for pid printing and slightly less stack
Subject: proc: don't use READ_ONCE/WRITE_ONCE for /proc/*/fail-nth
Subject: proc: fix /proc/*/map_files lookup
Subject: fs/proc/vmcore.c: simpler /proc/vmcore cleanup
Subject: proc: less memory for /proc/*/map_files readdir
Subject: fs/proc/array.c: delete children_seq_release()
Subject: fs/proc/kcore.c: use probe_kernel_read() instead of memcpy()
Subject: fs/proc/internal.h: rearrange struct proc_dir_entry
Subject: fs/proc/internal.h: fix up comment
Subject: fs/proc: use __ro_after_init
Subject: proc: spread likely/unlikely a bit
Subject: proc: rearrange args
Subject: fs/proc/consoles.c: use seq_putc() in show_console_dev()
Subject: Makefile: move stack-protector compiler breakage test earlier
Subject: Makefile: move stack-protector availability out of Kconfig
Subject: Makefile: introduce CONFIG_CC_STACKPROTECTOR_AUTO
Subject: uuid: cleanup <uapi/linux/uuid.h>
Subject: tools/lib/subcmd/pager.c: do not alias select() params
Subject: kernel/async.c: revert "async: simplify lowest_in_progress()"
Subject: MAINTAINERS: update sboyd's email address
Subject: bitmap: new bitmap_copy_safe and bitmap_{from,to}_arr32
Subject: bitmap: replace bitmap_{from,to}_u32array
Subject: lib/test_bitmap.c: add bitmap_zero()/bitmap_clear() test cases
Subject: lib/test_bitmap.c: add bitmap_fill()/bitmap_set() test cases
Subject: lib/test_bitmap.c: clean up test_zero_fill_copy() test case and rename
Subject: include/linux/bitmap.h: make bitmap_fill() and bitmap_zero() consistent
Subject: lib/stackdepot.c: use a non-instrumented version of memcmp()
Subject: lib/test_find_bit.c: rename to find_bit_benchmark.c
Subject: lib/find_bit_benchmark.c: improvements
Subject: lib: optimize cpumask_next_and()
Subject: lib/: make RUNTIME_TESTS a menuconfig to ease disabling it all
Subject: lib/test_sort.c: add module unload support
Subject: checkpatch: allow long lines containing URL
Subject: checkpatch: ignore some octal permissions of 0
Subject: checkpatch: improve quoted string and line continuation test
Subject: checkpatch: add a few DEVICE_ATTR style tests
Subject: checkpatch: improve the TABSTOP test to include declarations
Subject: checkpatch: exclude drivers/staging from if with unnecessary parentheses test
Subject: checkpatch: avoid some false positives for TABSTOP declaration test
Subject: checkpatch: improve OPEN_BRACE test
Subject: elf: fix NT_FILE integer overflow
Subject: kallsyms: let print_ip_sym() print raw addresses
Subject: nilfs2: use time64_t internally
Subject: hfsplus: honor setgid flag on directories
Subject: <asm-generic/siginfo.h>: fix language in comments
Subject: kernel/fork.c: check error and return early
Subject: kernel/fork.c: add comment about usage of CLONE_FS flags and namespaces
Subject: cpumask: make cpumask_size() return "unsigned int"
Subject: rapidio: delete an error message for a failed memory allocation in rio_init_mports()
Subject: rapidio: adjust 12 checks for null pointers
Subject: rapidio: adjust five function calls together with a variable assignment
Subject: rapidio: improve a size determination in five functions
Subject: rapidio: delete an unnecessary variable initialisation in three functions
Subject: rapidio: return an error code only as a constant in two functions
Subject: rapidio: move 12 EXPORT_SYMBOL_GPL() calls to function implementations
Subject: drivers/rapidio/devices/tsi721_dma.c: delete an error message for a failed memory allocation in tsi721_alloc_chan_resources()
Subject: drivers/rapidio/devices/tsi721_dma.c: delete an unnecessary variable initialisation in tsi721_alloc_chan_resources()
Subject: drivers/rapidio/devices/tsi721_dma.c: adjust six checks for null pointers
Subject: pids: introduce find_get_task_by_vpid() helper
Subject: pps: parport: use timespec64 instead of timespec
Subject: kernel/relay.c: revert "kernel/relay.c: fix potential memory leak"
Subject: kcov: detect double association with a single task
Subject: include/linux/genl_magic_func.h: remove own BUILD_BUG_ON*() defines
Subject: build_bug.h: remove BUILD_BUG_ON_NULL()
Subject: lib/ubsan.c: s/missaligned/misaligned/
Subject: lib/ubsan: add type mismatch handler for new GCC/Clang
Subject: lib/ubsan: remove returns-nonnull-attribute checks
Subject: ipc: fix ipc data structures inconsistency
Subject: ipc/mqueue.c: have RT tasks queue in by priority in wq_add()
Subject: arch/score/kernel/setup.c: combine two seq_printf() calls into one call in show_cpuinfo()
Subject: vfs: remove might_sleep() from clear_inode()
Subject: mm/userfaultfd.c: remove duplicate include
Subject: mm: remove unneeded kallsyms include
Subject: hrtimer: remove unneeded kallsyms include
Subject: genirq: remove unneeded kallsyms include
Subject: mm/memblock: memblock_is_map/region_memory can be boolean
Subject: lib/lockref: __lockref_is_dead can be boolean
Subject: kernel/cpuset: current_cpuset_is_being_rebound can be  boolean
Subject: kernel/resource: iomem_is_exclusive can be boolean
Subject: kernel/module: module_is_live can be boolean
Subject: kernel/mutex: mutex_is_locked can be boolean
Subject: crash_dump: is_kdump_kernel can be boolean
Subject: kasan: rework Kconfig settings
Subject: pipe, sysctl: drop 'min' parameter from pipe-max-size converter
Subject: pipe, sysctl: remove pipe_proc_fn()
Subject: pipe: actually allow root to exceed the pipe buffer limits
Subject: pipe: fix off-by-one error when checking buffer limits
Subject: pipe: reject F_SETPIPE_SZ with size over UINT_MAX
Subject: pipe: simplify round_pipe_size()
Subject: pipe: read buffer limits atomically
Subject: mm: docs: fixup punctuation
Subject: mm: docs: fix parameter names mismatch
Subject: mm: docs: add blank lines to silence sphinx "Unexpected indentation" errors
Subject: MAINTAINERS: remove ANDROID ION pattern
Subject: MAINTAINERS: remove ARM/CLKDEV SUPPORT file pattern
Subject: MAINTAINERS: update Cortina/Gemini patterns
Subject: MAINTAINERS: update "ARM/OXNAS platform support" patterns
Subject: MAINTAINERS: update various PALM patterns
Subject: MAINTAINERS: update ARM/QUALCOMM SUPPORT patterns
Subject: Documentation/sysctl/user.txt: fix typo

