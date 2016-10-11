From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Tue, 11 Oct 2016 13:49:58 -0700
Message-ID: <20161011134958.1188eaa89b1bae8821cd2d96@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38533 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751993AbcJKVAv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 17:00:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- a few block updates that fell in my lap

- lib/ updates

- checkpatch

- autofs

- ipc

- A ton of misc other things


102 patches, based on 1689c73a739d094b544c680b0dfdebe52ffee8fb:

Subject: ocfs2: fix memory leak in dlm_migrate_request_handler()
Subject: block: invalidate the page cache when issuing BLKZEROOUT
Subject: block: require write_same and discard requests align to logical block size
Subject: block: implement (some of) fallocate for block devices
Subject: fs/select: add vmalloc fallback for select(2)
Subject: radix-tree: 'slot' can be NULL in radix_tree_next_slot()
Subject: radix-tree tests: add iteration test
Subject: radix-tree tests: properly initialize mutex
Subject: lib: harden strncpy_from_user
Subject: include/linux/ctype.h: make isdigit() table lookupless
Subject: lib/kstrtox.c: smaller _parse_integer()
Subject: lib/bitmap.c: enhance bitmap syntax
Subject: include/linux: provide a safe version of container_of()
Subject: llist: introduce llist_entry_safe()
Subject: checkpatch: see if modified files are marked obsolete in MAINTAINERS
Subject: checkpatch: look for symbolic permissions and suggest octal instead
Subject: checkpatch: test multiple line block comment alignment
Subject: checkpatch: don't test for prefer ether_addr_<foo>
Subject: checkpatch: externalize the structs that should be const
Subject: const_structs.checkpatch: add frequently used from Julia Lawall's list
Subject: checkpatch: speed up checking for filenames in sections marked obsolete
Subject: checkpatch: improve the block comment * alignment test
Subject: checkpatch: add --strict test for macro argument reuse
Subject: checkpatch: add --strict test for precedence challenged macro arguments
Subject: checkpatch: improve MACRO_ARG_PRECEDENCE test
Subject: checkpatch: add warning for unnamed function definition arguments
Subject: checkpatch: improve the octal permissions tests
Subject: kprobes: include <asm/sections.h> instead of <asm-generic/sections.h>
Subject: autofs: fix typos in Documentation/filesystems/autofs4.txt
Subject: autofs: drop unnecessary extern in autofs_i.h
Subject: autofs: test autofs versions first on sb initialization
Subject: autofs: fix autofs4_fill_super() error exit handling
Subject: autofs: add WARN_ON(1) for non dir/link inode case
Subject: autofs: remove ino free in autofs4_dir_symlink()
Subject: autofs: use autofs4_free_ino() to kfree dentry data
Subject: autofs: remove obsolete sb fields
Subject: autofs: don't fail to free_dev_ioctl(param)
Subject: autofs: remove AUTOFS_DEVID_LEN
Subject: autofs: fix Documentation regarding devid on ioctl
Subject: autofs: update struct autofs_dev_ioctl in Documentation
Subject: autofs: fix pr_debug() message
Subject: autofs: fix dev ioctl number range check
Subject: autofs: add autofs_dev_ioctl_version() for AUTOFS_DEV_IOCTL_VERSION_CMD
Subject: autofs: fix print format for ioctl warning message
Subject: autofs: move inclusion of linux/limits.h to uapi
Subject: autofs4: move linux/auto_dev-ioctl.h to uapi/linux
Subject: autofs: remove possibly misleading /* #define DEBUG */
Subject: autofs: refactor ioctl fn vector in iookup_dev_ioctl()
Subject: pipe: relocate round_pipe_size() above pipe_set_size()
Subject: pipe: move limit checking logic into pipe_set_size()
Subject: pipe: refactor argument for account_pipe_buffers()
Subject: pipe: fix limit checking in pipe_set_size()
Subject: pipe: simplify logic in alloc_pipe_info()
Subject: pipe: fix limit checking in alloc_pipe_info()
Subject: pipe: make account_pipe_buffers() return a value, and use it
Subject: pipe: cap initial pipe capacity according to pipe-max-size limit
Subject: ptrace: clear TIF_SYSCALL_TRACE on ptrace detach
Subject: rapidio/rio_cm: use memdup_user() instead of duplicating code
Subject: random: simplify API for random address requests
Subject: x86: use simpler API for random address requests
Subject: ARM: use simpler API for random address requests
Subject: arm64: use simpler API for random address requests
Subject: tile: use simpler API for random address requests
Subject: unicore32: use simpler API for random address requests
Subject: random: remove unused randomize_range()
Subject: dma-mapping: introduce the DMA_ATTR_NO_WARN attribute
Subject: powerpc: implement the DMA_ATTR_NO_WARN attribute
Subject: nvme: use the DMA_ATTR_NO_WARN attribute
Subject: x86/panic: replace smp_send_stop() with kdump friendly version in panic path
Subject: mips/panic: replace smp_send_stop() with kdump friendly version in panic path
Subject: pps: kc: fix non-tickless system config dependency
Subject: relay: Use irq_work instead of plain timer for deferred wakeup
Subject: config/android: Remove CONFIG_IPV6_PRIVACY
Subject: config: android: move device mapper options to recommended
Subject: config: android: set SELinux as default security mode
Subject: config: android: enable CONFIG_SECCOMP
Subject: kcov: do not instrument lib/stackdepot.c
Subject: ipc/sem.c: fix complex_count vs. simple op race
Subject: ipc/msg: implement lockless pipelined wakeups
Subject: ipc/msg: batch queue sender wakeups
Subject: ipc/msg: make ss_wakeup() kill arg boolean
Subject: ipc/msg: avoid waking sender upon full queue
Subject: ipc/sem.c: Add cond_resched in exit_sme
Subject: kdump, vmcoreinfo: report memory sections virtual addresses
Subject: mm: kmemleak: avoid using __va() on addresses that don't have a lowmem mapping
Subject: scripts/tags.sh: enable code completion in VIM
Subject: kthread: rename probe_kthread_data() to kthread_probe_data()
Subject: kthread: kthread worker API cleanup
Subject: kthread/smpboot: do not park in kthread_create_on_cpu()
Subject: kthread: allow to call __kthread_create_on_node() with va_list args
Subject: kthread: add kthread_create_worker*()
Subject: kthread: add kthread_destroy_worker()
Subject: kthread: detect when a kthread work is used by more workers
Subject: kthread: initial support for delayed kthread work
Subject: kthread: allow to cancel kthread work
Subject: kthread: allow to modify delayed kthread work
Subject: kthread: better support freezable kthread workers
Subject: kthread: add kerneldoc for kthread_create()
Subject: hung_task: allow hung_task_panic when hung_task_warnings is 0
Subject: treewide: remove redundant #include <linux/kconfig.h>
Subject: fs: use mapping_set_error instead of opencoded set_bit
Subject: mm: split gfp_mask and mapping flags into separate fields

