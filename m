From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 12 Jul 2017 14:32:24 -0700
Message-ID: <20170712143224.dd573e563e79f8d1892c34d3@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53052 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdGLVcZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:32:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- various misc things

- kexec updates

- sysctl core updates

- scripts/gdb udpates

- checkpoint-restart updates

- ipc updates

- kernel/watchdog updates

- Kees's "rough equivalent to the glibc _FORTIFY_SOURCE=1 feature"

- "stackprotector: ascii armor the stack canary"

- more MM bits

- checkpatch updates


96 patches, based on 235b84fc862ae2637dc0dabada18d97f1bfc18e1:

Subject: include/linux/dcache.h: use unsigned chars in struct name_snapshot
Subject: kernel.h: handle pointers to arrays better in container_of()
Subject: mm/memory.c: mark create_huge_pmd() inline to prevent build failure
Subject: kernel/fork.c: virtually mapped stacks: do not disable interrupts
Subject: kexec: move vmcoreinfo out of the kernel's .bss section
Subject: powerpc/fadump: use the correct VMCOREINFO_NOTE_SIZE for phdr
Subject: kdump: protect vmcoreinfo data under the crash memory
Subject: kexec/kdump: minor Documentation updates for arm64 and Image
Subject: sysctl: fix lax sysctl_check_table() sanity check
Subject: sysctl: kdoc'ify sysctl_writes_strict
Subject: sysctl: fold sysctl_writes_strict checks into helper
Subject: sysctl: simplify unsigned int support
Subject: sysctl: add unsigned int range support
Subject: test_sysctl: add dedicated proc sysctl test driver
Subject: test_sysctl: add generic script to expand on tests
Subject: test_sysctl: test against PAGE_SIZE for int
Subject: test_sysctl: add simple proc_dointvec() case
Subject: test_sysctl: add simple proc_douintvec() case
Subject: test_sysctl: test against int proc_dointvec() array support
Subject: kernel/sysctl_binary.c: check name array length in deprecated_sysctl_warning()
Subject: random: do not ignore early device randomness
Subject: bfs: fix sanity checks for empty files
Subject: fs/Kconfig: kill CONFIG_PERCPU_RWSEM some more
Subject: scripts/gdb: add lx-fdtdump command
Subject: scripts/gdb: lx-dmesg: cast log_buf to void* for addr fetch
Subject: scripts/gdb: lx-dmesg: use explicit encoding=utf8 errors=replace
Subject: kfifo: clean up example to not use page_link
Subject: procfs: fdinfo: extend information about epoll target files
Subject: kcmp: add KCMP_EPOLL_TFD mode to compare epoll target files
Subject: kcmp: fs/epoll: wrap kcmp code with CONFIG_CHECKPOINT_RESTORE
Subject: fault-inject: support systematic fault injection
Subject: ipc/sem.c: remove sem_base, embed struct sem
Subject: ipc: merge ipc_rcu and kern_ipc_perm
Subject: include/linux/sem.h: correctly document sem_ctime
Subject: ipc: drop non-RCU allocation
Subject: ipc/sem: do not use ipc_rcu_free()
Subject: ipc/shm: do not use ipc_rcu_free()
Subject: ipc/msg: do not use ipc_rcu_free()
Subject: ipc/util: drop ipc_rcu_free()
Subject: ipc/sem: avoid ipc_rcu_alloc()
Subject: ipc/shm: avoid ipc_rcu_alloc()
Subject: ipc/msg: avoid ipc_rcu_alloc()
Subject: ipc/util: drop ipc_rcu_alloc()
Subject: ipc/sem.c: avoid ipc_rcu_putref for failed ipc_addid()
Subject: ipc/shm.c: avoid ipc_rcu_putref for failed ipc_addid()
Subject: ipc/msg.c: avoid ipc_rcu_putref for failed ipc_addid()
Subject: ipc: move atomic_set() to where it is needed
Subject: ipc/shm: remove special shm_alloc/free
Subject: ipc/msg: remove special msg_alloc/free
Subject: ipc/sem: drop __sem_free()
Subject: ipc/util.h: update documentation for ipc_getref() and ipc_putref()
Subject: net/netfilter/x_tables.c: use kvmalloc() in xt_alloc_table_info()
Subject: kernel/watchdog: remove unused declaration
Subject: kernel/watchdog: introduce arch_touch_nmi_watchdog()
Subject: kernel/watchdog: split up config options
Subject: kernel/watchdog: provide watchdog_nmi_reconfigure() for arch watchdogs
Subject: powerpc/64s: implement arch-specific hardlockup watchdog
Subject: efi: avoid fortify checks in EFI stub
Subject: kexec_file: adjust declaration of kexec_purgatory
Subject: IB/rxe: do not copy extra stack memory to skb
Subject: powerpc: don't fortify prom_init
Subject: powerpc: make feature-fixup tests fortify-safe
Subject: include/linux/string.h: add the option of fortified string.h functions
Subject: sh: mark end of BUG() implementation as unreachable
Subject: random,stackprotect: introduce get_random_canary function
Subject: fork,random: use get_random_canary() to set tsk->stack_canary
Subject: x86: ascii armor the x86_64 boot init stack canary
Subject: arm64: ascii armor the arm64 boot init stack canary
Subject: sh64: ascii armor the sh64 boot init stack canary
Subject: x86/mmap: properly account for stack randomization in mmap_base
Subject: arm64/mmap: properly account for stack randomization in mmap_base
Subject: powerpc,mmap: properly account for stack randomization in mmap_base
Subject: MIPS: do not use __GFP_REPEAT for order-0 request
Subject: mm, tree wide: replace __GFP_REPEAT by __GFP_RETRY_MAYFAIL with more useful semantic
Subject: xfs: map KM_MAYFAIL to __GFP_RETRY_MAYFAIL
Subject: mm: kvmalloc support __GFP_RETRY_MAYFAIL for all sizes
Subject: drm/i915: use __GFP_RETRY_MAYFAIL
Subject: mm, migration: do not trigger OOM killer when migrating memory
Subject: checkpatch: improve the STORAGE_CLASS test
Subject: ARM: KVM: move asmlinkage before type
Subject: ARM: HP Jornada 7XX: move inline before return type
Subject: CRIS: gpio: move inline before return type
Subject: FRV: tlbflush: move asmlinkage before return type
Subject: ia64: move inline before return type
Subject: ia64: sn: pci: move inline before type
Subject: m68k: coldfire: move inline before return type
Subject: MIPS: SMP: move asmlinkage before return type
Subject: sh: move inline before return type
Subject: x86/efi: move asmlinkage before return type
Subject: drivers: s390: move static and inline before return type
Subject: drivers: tty: serial: move inline before return type
Subject: USB: serial: safe_serial: move __inline__ before return type
Subject: video: fbdev: intelfb: move inline before return type
Subject: video: fbdev: omap: move inline before return type
Subject: ARM: samsung: usb-ohci: move inline before return type
Subject: writeback: rework wb_[dec|inc]_stat family of functions

