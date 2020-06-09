From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 8 Jun 2020 21:29:22 -0700
Message-ID: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIE30 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:29:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


- a kernel-wide sweep of show_stack()

- pagetable cleanups

- abstract out accesses to mmap_sem - prep for mmap_sem scalability work

- hch's user acess work


93 patches, based on abfbb29297c27e3f101f348dc9e467b0fe70f919:

Subsystems affected by this patch series:

  debug
  mm/pagemap
  mm/maccess
  mm/documentation

Subsystem: debug

    Dmitry Safonov <dima@arista.com>:
    Patch series "Add log level to show_stack()", v3:
      kallsyms/printk: add loglvl to print_ip_sym()
      alpha: add show_stack_loglvl()
      arc: add show_stack_loglvl()
      arm/asm: add loglvl to c_backtrace()
      arm: add loglvl to unwind_backtrace()
      arm: add loglvl to dump_backtrace()
      arm: wire up dump_backtrace_{entry,stm}
      arm: add show_stack_loglvl()
      arm64: add loglvl to dump_backtrace()
      arm64: add show_stack_loglvl()
      c6x: add show_stack_loglvl()
      csky: add show_stack_loglvl()
      h8300: add show_stack_loglvl()
      hexagon: add show_stack_loglvl()
      ia64: pass log level as arg into ia64_do_show_stack()
      ia64: add show_stack_loglvl()
      m68k: add show_stack_loglvl()
      microblaze: add loglvl to microblaze_unwind_inner()
      microblaze: add loglvl to microblaze_unwind()
      microblaze: add show_stack_loglvl()
      mips: add show_stack_loglvl()
      nds32: add show_stack_loglvl()
      nios2: add show_stack_loglvl()
      openrisc: add show_stack_loglvl()
      parisc: add show_stack_loglvl()
      powerpc: add show_stack_loglvl()
      riscv: add show_stack_loglvl()
      s390: add show_stack_loglvl()
      sh: add loglvl to dump_mem()
      sh: remove needless printk()
      sh: add loglvl to printk_address()
      sh: add loglvl to show_trace()
      sh: add show_stack_loglvl()
      sparc: add show_stack_loglvl()
      um/sysrq: remove needless variable sp
      um: add show_stack_loglvl()
      unicore32: remove unused pmode argument in c_backtrace()
      unicore32: add loglvl to c_backtrace()
      unicore32: add show_stack_loglvl()
      x86: add missing const qualifiers for log_lvl
      x86: add show_stack_loglvl()
      xtensa: add loglvl to show_trace()
      xtensa: add show_stack_loglvl()
      sysrq: use show_stack_loglvl()
      x86/amd_gart: print stacktrace for a leak with KERN_ERR
      power: use show_stack_loglvl()
      kdb: don't play with console_loglevel
      sched: print stack trace with KERN_INFO
      kernel: use show_stack_loglvl()
      kernel: rename show_stack_loglvl() => show_stack()

Subsystem: mm/pagemap

    Mike Rapoport <rppt@linux.ibm.com>:
    Patch series "mm: consolidate definitions of page table accessors", v2:
      mm: don't include asm/pgtable.h if linux/mm.h is already included
      mm: introduce include/linux/pgtable.h
      mm: reorder includes after introduction of linux/pgtable.h
      csky: replace definitions of __pXd_offset() with pXd_index()
      m68k/mm/motorola: move comment about page table allocation funcitons
      m68k/mm: move {cache,nocahe}_page() definitions close to their user
      x86/mm: simplify init_trampoline() and surrounding logic
      mm: pgtable: add shortcuts for accessing kernel PMD and PTE
      mm: consolidate pte_index() and pte_offset_*() definitions

    Michel Lespinasse <walken@google.com>:
      mmap locking API: initial implementation as rwsem wrappers
      MMU notifier: use the new mmap locking API
      DMA reservations: use the new mmap locking API
      mmap locking API: use coccinelle to convert mmap_sem rwsem call sites
      mmap locking API: convert mmap_sem call sites missed by coccinelle
      mmap locking API: convert nested write lock sites
      mmap locking API: add mmap_read_trylock_non_owner()
      mmap locking API: add MMAP_LOCK_INITIALIZER
      mmap locking API: add mmap_assert_locked() and mmap_assert_write_locked()
      mmap locking API: rename mmap_sem to mmap_lock
      mmap locking API: convert mmap_sem API comments
      mmap locking API: convert mmap_sem comments

Subsystem: mm/maccess

    Christoph Hellwig <hch@lst.de>:
    Patch series "clean up and streamline probe_kernel_* and friends", v4:
      maccess: unexport probe_kernel_write()
      maccess: remove various unused weak aliases
      maccess: remove duplicate kerneldoc comments
      maccess: clarify kerneldoc comments
      maccess: update the top of file comment
      maccess: rename strncpy_from_unsafe_user to strncpy_from_user_nofault
      maccess: rename strncpy_from_unsafe_strict to strncpy_from_kernel_nofault
      maccess: rename strnlen_unsafe_user to strnlen_user_nofault
      maccess: remove probe_read_common and probe_write_common
      maccess: unify the probe kernel arch hooks
      bpf: factor out a bpf_trace_copy_string helper
      bpf: handle the compat string in bpf_trace_copy_string better

    Andrew Morton <akpm@linux-foundation.org>:
      bpf:bpf_seq_printf(): handle potentially unsafe format string better

    Christoph Hellwig <hch@lst.de>:
      bpf: rework the compat kernel probe handling
      tracing/kprobes: handle mixed kernel/userspace probes better
      maccess: remove strncpy_from_unsafe
      maccess: always use strict semantics for probe_kernel_read
      maccess: move user access routines together
      maccess: allow architectures to provide kernel probing directly
      x86: use non-set_fs based maccess routines
      maccess: return -ERANGE when probe_kernel_read() fails

Subsystem: mm/documentation

    Luis Chamberlain <mcgrof@kernel.org>:
      include/linux/cache.h: expand documentation over __read_mostly

 Documentation/admin-guide/mm/numa_memory_policy.rst   |   10 
 Documentation/admin-guide/mm/userfaultfd.rst          |    2 
 Documentation/filesystems/locking.rst                 |    2 
 Documentation/vm/hmm.rst                              |    6 
 Documentation/vm/transhuge.rst                        |    4 
 arch/alpha/boot/bootp.c                               |    1 
 arch/alpha/boot/bootpz.c                              |    1 
 arch/alpha/boot/main.c                                |    1 
 arch/alpha/include/asm/io.h                           |    1 
 arch/alpha/include/asm/pgtable.h                      |   16 
 arch/alpha/kernel/process.c                           |    1 
 arch/alpha/kernel/proto.h                             |    4 
 arch/alpha/kernel/ptrace.c                            |    1 
 arch/alpha/kernel/setup.c                             |    1 
 arch/alpha/kernel/smp.c                               |    1 
 arch/alpha/kernel/sys_alcor.c                         |    1 
 arch/alpha/kernel/sys_cabriolet.c                     |    1 
 arch/alpha/kernel/sys_dp264.c                         |    1 
 arch/alpha/kernel/sys_eb64p.c                         |    1 
 arch/alpha/kernel/sys_eiger.c                         |    1 
 arch/alpha/kernel/sys_jensen.c                        |    1 
 arch/alpha/kernel/sys_marvel.c                        |    1 
 arch/alpha/kernel/sys_miata.c                         |    1 
 arch/alpha/kernel/sys_mikasa.c                        |    1 
 arch/alpha/kernel/sys_nautilus.c                      |    1 
 arch/alpha/kernel/sys_noritake.c                      |    1 
 arch/alpha/kernel/sys_rawhide.c                       |    1 
 arch/alpha/kernel/sys_ruffian.c                       |    1 
 arch/alpha/kernel/sys_rx164.c                         |    1 
 arch/alpha/kernel/sys_sable.c                         |    1 
 arch/alpha/kernel/sys_sio.c                           |    1 
 arch/alpha/kernel/sys_sx164.c                         |    1 
 arch/alpha/kernel/sys_takara.c                        |    1 
 arch/alpha/kernel/sys_titan.c                         |    1 
 arch/alpha/kernel/sys_wildfire.c                      |    1 
 arch/alpha/kernel/traps.c                             |   40 
 arch/alpha/mm/fault.c                                 |   12 
 arch/alpha/mm/init.c                                  |    1 
 arch/arc/include/asm/bug.h                            |    3 
 arch/arc/include/asm/pgtable.h                        |   24 
 arch/arc/kernel/process.c                             |    4 
 arch/arc/kernel/stacktrace.c                          |   29 
 arch/arc/kernel/troubleshoot.c                        |    6 
 arch/arc/mm/fault.c                                   |    6 
 arch/arc/mm/highmem.c                                 |   14 
 arch/arc/mm/tlbex.S                                   |    4 
 arch/arm/include/asm/bug.h                            |    3 
 arch/arm/include/asm/efi.h                            |    3 
 arch/arm/include/asm/fixmap.h                         |    4 
 arch/arm/include/asm/idmap.h                          |    2 
 arch/arm/include/asm/pgtable-2level.h                 |    1 
 arch/arm/include/asm/pgtable-3level.h                 |    7 
 arch/arm/include/asm/pgtable-nommu.h                  |    3 
 arch/arm/include/asm/pgtable.h                        |   25 
 arch/arm/include/asm/traps.h                          |    3 
 arch/arm/include/asm/unwind.h                         |    3 
 arch/arm/kernel/head.S                                |    4 
 arch/arm/kernel/machine_kexec.c                       |    1 
 arch/arm/kernel/module.c                              |    1 
 arch/arm/kernel/process.c                             |    4 
 arch/arm/kernel/ptrace.c                              |    1 
 arch/arm/kernel/smp.c                                 |    1 
 arch/arm/kernel/suspend.c                             |    4 
 arch/arm/kernel/swp_emulate.c                         |    4 
 arch/arm/kernel/traps.c                               |   61 
 arch/arm/kernel/unwind.c                              |    7 
 arch/arm/kernel/vdso.c                                |    2 
 arch/arm/kernel/vmlinux.lds.S                         |    4 
 arch/arm/lib/backtrace-clang.S                        |    9 
 arch/arm/lib/backtrace.S                              |   14 
 arch/arm/lib/uaccess_with_memcpy.c                    |   16 
 arch/arm/mach-ebsa110/core.c                          |    1 
 arch/arm/mach-footbridge/common.c                     |    1 
 arch/arm/mach-imx/mm-imx21.c                          |    1 
 arch/arm/mach-imx/mm-imx27.c                          |    1 
 arch/arm/mach-imx/mm-imx3.c                           |    1 
 arch/arm/mach-integrator/core.c                       |    4 
 arch/arm/mach-iop32x/i2c.c                            |    1 
 arch/arm/mach-iop32x/iq31244.c                        |    1 
 arch/arm/mach-iop32x/iq80321.c                        |    1 
 arch/arm/mach-iop32x/n2100.c                          |    1 
 arch/arm/mach-ixp4xx/common.c                         |    1 
 arch/arm/mach-keystone/platsmp.c                      |    4 
 arch/arm/mach-sa1100/assabet.c                        |    3 
 arch/arm/mach-sa1100/hackkit.c                        |    4 
 arch/arm/mach-tegra/iomap.h                           |    2 
 arch/arm/mach-zynq/common.c                           |    4 
 arch/arm/mm/copypage-v4mc.c                           |    1 
 arch/arm/mm/copypage-v6.c                             |    1 
 arch/arm/mm/copypage-xscale.c                         |    1 
 arch/arm/mm/dump.c                                    |    1 
 arch/arm/mm/fault-armv.c                              |    1 
 arch/arm/mm/fault.c                                   |    9 
 arch/arm/mm/highmem.c                                 |    4 
 arch/arm/mm/idmap.c                                   |    4 
 arch/arm/mm/ioremap.c                                 |   31 
 arch/arm/mm/mm.h                                      |    8 
 arch/arm/mm/mmu.c                                     |    7 
 arch/arm/mm/pageattr.c                                |    1 
 arch/arm/mm/proc-arm1020.S                            |    4 
 arch/arm/mm/proc-arm1020e.S                           |    4 
 arch/arm/mm/proc-arm1022.S                            |    4 
 arch/arm/mm/proc-arm1026.S                            |    4 
 arch/arm/mm/proc-arm720.S                             |    4 
 arch/arm/mm/proc-arm740.S                             |    4 
 arch/arm/mm/proc-arm7tdmi.S                           |    4 
 arch/arm/mm/proc-arm920.S                             |    4 
 arch/arm/mm/proc-arm922.S                             |    4 
 arch/arm/mm/proc-arm925.S                             |    4 
 arch/arm/mm/proc-arm926.S                             |    4 
 arch/arm/mm/proc-arm940.S                             |    4 
 arch/arm/mm/proc-arm946.S                             |    4 
 arch/arm/mm/proc-arm9tdmi.S                           |    4 
 arch/arm/mm/proc-fa526.S                              |    4 
 arch/arm/mm/proc-feroceon.S                           |    4 
 arch/arm/mm/proc-mohawk.S                             |    4 
 arch/arm/mm/proc-sa110.S                              |    4 
 arch/arm/mm/proc-sa1100.S                             |    4 
 arch/arm/mm/proc-v6.S                                 |    4 
 arch/arm/mm/proc-v7.S                                 |    4 
 arch/arm/mm/proc-xsc3.S                               |    4 
 arch/arm/mm/proc-xscale.S                             |    4 
 arch/arm/mm/pv-fixup-asm.S                            |    4 
 arch/arm64/include/asm/io.h                           |    4 
 arch/arm64/include/asm/kernel-pgtable.h               |    2 
 arch/arm64/include/asm/kvm_mmu.h                      |    4 
 arch/arm64/include/asm/mmu_context.h                  |    4 
 arch/arm64/include/asm/pgtable.h                      |   40 
 arch/arm64/include/asm/stacktrace.h                   |    3 
 arch/arm64/include/asm/stage2_pgtable.h               |    2 
 arch/arm64/include/asm/vmap_stack.h                   |    4 
 arch/arm64/kernel/acpi.c                              |    4 
 arch/arm64/kernel/head.S                              |    4 
 arch/arm64/kernel/hibernate.c                         |    5 
 arch/arm64/kernel/kaslr.c                             |    4 
 arch/arm64/kernel/process.c                           |    2 
 arch/arm64/kernel/ptrace.c                            |    1 
 arch/arm64/kernel/smp.c                               |    1 
 arch/arm64/kernel/suspend.c                           |    4 
 arch/arm64/kernel/traps.c                             |   37 
 arch/arm64/kernel/vdso.c                              |    8 
 arch/arm64/kernel/vmlinux.lds.S                       |    3 
 arch/arm64/kvm/mmu.c                                  |   14 
 arch/arm64/mm/dump.c                                  |    1 
 arch/arm64/mm/fault.c                                 |    9 
 arch/arm64/mm/kasan_init.c                            |    3 
 arch/arm64/mm/mmu.c                                   |    8 
 arch/arm64/mm/pageattr.c                              |    1 
 arch/arm64/mm/proc.S                                  |    4 
 arch/c6x/include/asm/pgtable.h                        |    3 
 arch/c6x/kernel/traps.c                               |   28 
 arch/csky/include/asm/io.h                            |    2 
 arch/csky/include/asm/pgtable.h                       |   37 
 arch/csky/kernel/module.c                             |    1 
 arch/csky/kernel/ptrace.c                             |    5 
 arch/csky/kernel/stacktrace.c                         |   20 
 arch/csky/kernel/vdso.c                               |    4 
 arch/csky/mm/fault.c                                  |   10 
 arch/csky/mm/highmem.c                                |    2 
 arch/csky/mm/init.c                                   |    7 
 arch/csky/mm/tlb.c                                    |    1 
 arch/h8300/include/asm/pgtable.h                      |    1 
 arch/h8300/kernel/process.c                           |    1 
 arch/h8300/kernel/setup.c                             |    1 
 arch/h8300/kernel/signal.c                            |    1 
 arch/h8300/kernel/traps.c                             |   26 
 arch/h8300/mm/fault.c                                 |    1 
 arch/h8300/mm/init.c                                  |    1 
 arch/h8300/mm/memory.c                                |    1 
 arch/hexagon/include/asm/fixmap.h                     |    4 
 arch/hexagon/include/asm/pgtable.h                    |   55 
 arch/hexagon/kernel/traps.c                           |   39 
 arch/hexagon/kernel/vdso.c                            |    4 
 arch/hexagon/mm/uaccess.c                             |    2 
 arch/hexagon/mm/vm_fault.c                            |    9 
 arch/ia64/include/asm/pgtable.h                       |   34 
 arch/ia64/include/asm/ptrace.h                        |    1 
 arch/ia64/include/asm/uaccess.h                       |    2 
 arch/ia64/kernel/efi.c                                |    1 
 arch/ia64/kernel/entry.S                              |    4 
 arch/ia64/kernel/head.S                               |    5 
 arch/ia64/kernel/irq_ia64.c                           |    4 
 arch/ia64/kernel/ivt.S                                |    4 
 arch/ia64/kernel/kprobes.c                            |    4 
 arch/ia64/kernel/mca.c                                |    2 
 arch/ia64/kernel/mca_asm.S                            |    4 
 arch/ia64/kernel/perfmon.c                            |    8 
 arch/ia64/kernel/process.c                            |   37 
 arch/ia64/kernel/ptrace.c                             |    1 
 arch/ia64/kernel/relocate_kernel.S                    |    6 
 arch/ia64/kernel/setup.c                              |    4 
 arch/ia64/kernel/smp.c                                |    1 
 arch/ia64/kernel/smpboot.c                            |    1 
 arch/ia64/kernel/uncached.c                           |    4 
 arch/ia64/kernel/vmlinux.lds.S                        |    4 
 arch/ia64/mm/contig.c                                 |    1 
 arch/ia64/mm/fault.c                                  |   17 
 arch/ia64/mm/init.c                                   |   12 
 arch/m68k/68000/m68EZ328.c                            |    2 
 arch/m68k/68000/m68VZ328.c                            |    4 
 arch/m68k/68000/timers.c                              |    1 
 arch/m68k/amiga/config.c                              |    1 
 arch/m68k/apollo/config.c                             |    1 
 arch/m68k/atari/atasound.c                            |    1 
 arch/m68k/atari/stram.c                               |    1 
 arch/m68k/bvme6000/config.c                           |    1 
 arch/m68k/include/asm/mcf_pgtable.h                   |   63 
 arch/m68k/include/asm/motorola_pgalloc.h              |    8 
 arch/m68k/include/asm/motorola_pgtable.h              |   84 -
 arch/m68k/include/asm/pgtable_mm.h                    |    1 
 arch/m68k/include/asm/pgtable_no.h                    |    2 
 arch/m68k/include/asm/sun3_pgtable.h                  |   24 
 arch/m68k/include/asm/sun3xflop.h                     |    4 
 arch/m68k/kernel/head.S                               |    4 
 arch/m68k/kernel/process.c                            |    1 
 arch/m68k/kernel/ptrace.c                             |    1 
 arch/m68k/kernel/setup_no.c                           |    1 
 arch/m68k/kernel/signal.c                             |    1 
 arch/m68k/kernel/sys_m68k.c                           |   14 
 arch/m68k/kernel/traps.c                              |   27 
 arch/m68k/kernel/uboot.c                              |    1 
 arch/m68k/mac/config.c                                |    1 
 arch/m68k/mm/fault.c                                  |   10 
 arch/m68k/mm/init.c                                   |    2 
 arch/m68k/mm/mcfmmu.c                                 |    1 
 arch/m68k/mm/motorola.c                               |   65 
 arch/m68k/mm/sun3kmap.c                               |    1 
 arch/m68k/mm/sun3mmu.c                                |    1 
 arch/m68k/mvme147/config.c                            |    1 
 arch/m68k/mvme16x/config.c                            |    1 
 arch/m68k/q40/config.c                                |    1 
 arch/m68k/sun3/config.c                               |    1 
 arch/m68k/sun3/dvma.c                                 |    1 
 arch/m68k/sun3/mmu_emu.c                              |    1 
 arch/m68k/sun3/sun3dvma.c                             |    1 
 arch/m68k/sun3x/dvma.c                                |    1 
 arch/m68k/sun3x/prom.c                                |    1 
 arch/microblaze/include/asm/pgalloc.h                 |    4 
 arch/microblaze/include/asm/pgtable.h                 |   23 
 arch/microblaze/include/asm/uaccess.h                 |    2 
 arch/microblaze/include/asm/unwind.h                  |    3 
 arch/microblaze/kernel/hw_exception_handler.S         |    4 
 arch/microblaze/kernel/module.c                       |    4 
 arch/microblaze/kernel/setup.c                        |    4 
 arch/microblaze/kernel/signal.c                       |    9 
 arch/microblaze/kernel/stacktrace.c                   |    4 
 arch/microblaze/kernel/traps.c                        |   28 
 arch/microblaze/kernel/unwind.c                       |   46 
 arch/microblaze/mm/fault.c                            |   17 
 arch/microblaze/mm/init.c                             |    9 
 arch/microblaze/mm/pgtable.c                          |    4 
 arch/mips/fw/arc/memory.c                             |    1 
 arch/mips/include/asm/fixmap.h                        |    3 
 arch/mips/include/asm/mach-generic/floppy.h           |    1 
 arch/mips/include/asm/mach-jazz/floppy.h              |    1 
 arch/mips/include/asm/pgtable-32.h                    |   22 
 arch/mips/include/asm/pgtable-64.h                    |   32 
 arch/mips/include/asm/pgtable.h                       |    2 
 arch/mips/jazz/irq.c                                  |    4 
 arch/mips/jazz/jazzdma.c                              |    1 
 arch/mips/jazz/setup.c                                |    4 
 arch/mips/kernel/module.c                             |    1 
 arch/mips/kernel/process.c                            |    1 
 arch/mips/kernel/ptrace.c                             |    1 
 arch/mips/kernel/ptrace32.c                           |    1 
 arch/mips/kernel/smp-bmips.c                          |    1 
 arch/mips/kernel/traps.c                              |   58 
 arch/mips/kernel/vdso.c                               |    4 
 arch/mips/kvm/mips.c                                  |    4 
 arch/mips/kvm/mmu.c                                   |   20 
 arch/mips/kvm/tlb.c                                   |    1 
 arch/mips/kvm/trap_emul.c                             |    2 
 arch/mips/lib/dump_tlb.c                              |    1 
 arch/mips/lib/r3k_dump_tlb.c                          |    1 
 arch/mips/mm/c-octeon.c                               |    1 
 arch/mips/mm/c-r3k.c                                  |   11 
 arch/mips/mm/c-r4k.c                                  |   11 
 arch/mips/mm/c-tx39.c                                 |   11 
 arch/mips/mm/fault.c                                  |   12 
 arch/mips/mm/highmem.c                                |    2 
 arch/mips/mm/init.c                                   |    1 
 arch/mips/mm/page.c                                   |    1 
 arch/mips/mm/pgtable-32.c                             |    1 
 arch/mips/mm/pgtable-64.c                             |    1 
 arch/mips/mm/sc-ip22.c                                |    1 
 arch/mips/mm/sc-mips.c                                |    1 
 arch/mips/mm/sc-r5k.c                                 |    1 
 arch/mips/mm/tlb-r3k.c                                |    1 
 arch/mips/mm/tlb-r4k.c                                |    1 
 arch/mips/mm/tlbex.c                                  |    4 
 arch/mips/sgi-ip27/ip27-init.c                        |    1 
 arch/mips/sgi-ip27/ip27-timer.c                       |    1 
 arch/mips/sgi-ip32/ip32-memory.c                      |    1 
 arch/nds32/include/asm/highmem.h                      |    3 
 arch/nds32/include/asm/pgtable.h                      |   22 
 arch/nds32/kernel/head.S                              |    4 
 arch/nds32/kernel/module.c                            |    2 
 arch/nds32/kernel/traps.c                             |   33 
 arch/nds32/kernel/vdso.c                              |    6 
 arch/nds32/mm/fault.c                                 |   17 
 arch/nds32/mm/init.c                                  |   13 
 arch/nds32/mm/proc.c                                  |    7 
 arch/nios2/include/asm/pgtable.h                      |   24 
 arch/nios2/kernel/module.c                            |    1 
 arch/nios2/kernel/nios2_ksyms.c                       |    4 
 arch/nios2/kernel/traps.c                             |   35 
 arch/nios2/mm/fault.c                                 |   14 
 arch/nios2/mm/init.c                                  |    5 
 arch/nios2/mm/pgtable.c                               |    1 
 arch/nios2/mm/tlb.c                                   |    1 
 arch/openrisc/include/asm/io.h                        |    3 
 arch/openrisc/include/asm/pgtable.h                   |   33 
 arch/openrisc/include/asm/tlbflush.h                  |    1 
 arch/openrisc/kernel/asm-offsets.c                    |    1 
 arch/openrisc/kernel/entry.S                          |    4 
 arch/openrisc/kernel/head.S                           |    4 
 arch/openrisc/kernel/or32_ksyms.c                     |    4 
 arch/openrisc/kernel/process.c                        |    1 
 arch/openrisc/kernel/ptrace.c                         |    1 
 arch/openrisc/kernel/setup.c                          |    1 
 arch/openrisc/kernel/traps.c                          |   27 
 arch/openrisc/mm/fault.c                              |   12 
 arch/openrisc/mm/init.c                               |    1 
 arch/openrisc/mm/ioremap.c                            |    4 
 arch/openrisc/mm/tlb.c                                |    1 
 arch/parisc/include/asm/io.h                          |    2 
 arch/parisc/include/asm/mmu_context.h                 |    1 
 arch/parisc/include/asm/pgtable.h                     |   33 
 arch/parisc/kernel/asm-offsets.c                      |    4 
 arch/parisc/kernel/entry.S                            |    4 
 arch/parisc/kernel/head.S                             |    4 
 arch/parisc/kernel/module.c                           |    1 
 arch/parisc/kernel/pacache.S                          |    4 
 arch/parisc/kernel/pci-dma.c                          |    2 
 arch/parisc/kernel/pdt.c                              |    4 
 arch/parisc/kernel/ptrace.c                           |    1 
 arch/parisc/kernel/smp.c                              |    1 
 arch/parisc/kernel/traps.c                            |   42 
 arch/parisc/lib/memcpy.c                              |   14 
 arch/parisc/mm/fault.c                                |   10 
 arch/parisc/mm/fixmap.c                               |    6 
 arch/parisc/mm/init.c                                 |    1 
 arch/powerpc/include/asm/book3s/32/pgtable.h          |   20 
 arch/powerpc/include/asm/book3s/64/pgtable.h          |   43 
 arch/powerpc/include/asm/fixmap.h                     |    4 
 arch/powerpc/include/asm/io.h                         |    1 
 arch/powerpc/include/asm/kup.h                        |    2 
 arch/powerpc/include/asm/nohash/32/pgtable.h          |   17 
 arch/powerpc/include/asm/nohash/64/pgtable-4k.h       |    4 
 arch/powerpc/include/asm/nohash/64/pgtable.h          |   22 
 arch/powerpc/include/asm/nohash/pgtable.h             |    2 
 arch/powerpc/include/asm/pgtable.h                    |   28 
 arch/powerpc/include/asm/pkeys.h                      |    2 
 arch/powerpc/include/asm/tlb.h                        |    2 
 arch/powerpc/kernel/asm-offsets.c                     |    1 
 arch/powerpc/kernel/btext.c                           |    4 
 arch/powerpc/kernel/fpu.S                             |    3 
 arch/powerpc/kernel/head_32.S                         |    4 
 arch/powerpc/kernel/head_40x.S                        |    4 
 arch/powerpc/kernel/head_44x.S                        |    4 
 arch/powerpc/kernel/head_8xx.S                        |    4 
 arch/powerpc/kernel/head_fsl_booke.S                  |    4 
 arch/powerpc/kernel/io-workarounds.c                  |    4 
 arch/powerpc/kernel/irq.c                             |    4 
 arch/powerpc/kernel/mce_power.c                       |    4 
 arch/powerpc/kernel/paca.c                            |    4 
 arch/powerpc/kernel/process.c                         |   30 
 arch/powerpc/kernel/prom.c                            |    4 
 arch/powerpc/kernel/prom_init.c                       |    4 
 arch/powerpc/kernel/rtas_pci.c                        |    4 
 arch/powerpc/kernel/setup-common.c                    |    4 
 arch/powerpc/kernel/setup_32.c                        |    4 
 arch/powerpc/kernel/setup_64.c                        |    4 
 arch/powerpc/kernel/signal_32.c                       |    1 
 arch/powerpc/kernel/signal_64.c                       |    1 
 arch/powerpc/kernel/smp.c                             |    4 
 arch/powerpc/kernel/stacktrace.c                      |    2 
 arch/powerpc/kernel/traps.c                           |    1 
 arch/powerpc/kernel/vdso.c                            |    7 
 arch/powerpc/kvm/book3s_64_mmu_radix.c                |    4 
 arch/powerpc/kvm/book3s_hv.c                          |    6 
 arch/powerpc/kvm/book3s_hv_nested.c                   |    4 
 arch/powerpc/kvm/book3s_hv_rm_xics.c                  |    4 
 arch/powerpc/kvm/book3s_hv_rm_xive.c                  |    4 
 arch/powerpc/kvm/book3s_hv_uvmem.c                    |   18 
 arch/powerpc/kvm/e500_mmu_host.c                      |    4 
 arch/powerpc/kvm/fpu.S                                |    4 
 arch/powerpc/lib/code-patching.c                      |    1 
 arch/powerpc/mm/book3s32/hash_low.S                   |    4 
 arch/powerpc/mm/book3s32/mmu.c                        |    2 
 arch/powerpc/mm/book3s32/tlb.c                        |    6 
 arch/powerpc/mm/book3s64/hash_hugetlbpage.c           |    1 
 arch/powerpc/mm/book3s64/hash_native.c                |    4 
 arch/powerpc/mm/book3s64/hash_pgtable.c               |    5 
 arch/powerpc/mm/book3s64/hash_utils.c                 |    4 
 arch/powerpc/mm/book3s64/iommu_api.c                  |    4 
 arch/powerpc/mm/book3s64/radix_hugetlbpage.c          |    1 
 arch/powerpc/mm/book3s64/radix_pgtable.c              |    1 
 arch/powerpc/mm/book3s64/slb.c                        |    4 
 arch/powerpc/mm/book3s64/subpage_prot.c               |   16 
 arch/powerpc/mm/copro_fault.c                         |    4 
 arch/powerpc/mm/fault.c                               |   23 
 arch/powerpc/mm/hugetlbpage.c                         |    1 
 arch/powerpc/mm/init-common.c                         |    4 
 arch/powerpc/mm/init_32.c                             |    1 
 arch/powerpc/mm/init_64.c                             |    1 
 arch/powerpc/mm/kasan/8xx.c                           |    4 
 arch/powerpc/mm/kasan/book3s_32.c                     |    2 
 arch/powerpc/mm/kasan/kasan_init_32.c                 |    8 
 arch/powerpc/mm/mem.c                                 |    1 
 arch/powerpc/mm/nohash/40x.c                          |    5 
 arch/powerpc/mm/nohash/8xx.c                          |    2 
 arch/powerpc/mm/nohash/fsl_booke.c                    |    1 
 arch/powerpc/mm/nohash/tlb_low_64e.S                  |    4 
 arch/powerpc/mm/pgtable.c                             |    2 
 arch/powerpc/mm/pgtable_32.c                          |    5 
 arch/powerpc/mm/pgtable_64.c                          |    1 
 arch/powerpc/mm/ptdump/8xx.c                          |    2 
 arch/powerpc/mm/ptdump/bats.c                         |    4 
 arch/powerpc/mm/ptdump/book3s64.c                     |    2 
 arch/powerpc/mm/ptdump/hashpagetable.c                |    1 
 arch/powerpc/mm/ptdump/ptdump.c                       |    1 
 arch/powerpc/mm/ptdump/shared.c                       |    2 
 arch/powerpc/oprofile/cell/spu_task_sync.c            |    6 
 arch/powerpc/perf/callchain.c                         |    1 
 arch/powerpc/perf/callchain_32.c                      |    1 
 arch/powerpc/perf/callchain_64.c                      |    1 
 arch/powerpc/platforms/85xx/corenet_generic.c         |    4 
 arch/powerpc/platforms/85xx/mpc85xx_cds.c             |    4 
 arch/powerpc/platforms/85xx/qemu_e500.c               |    4 
 arch/powerpc/platforms/85xx/sbc8548.c                 |    4 
 arch/powerpc/platforms/85xx/smp.c                     |    4 
 arch/powerpc/platforms/86xx/mpc86xx_smp.c             |    4 
 arch/powerpc/platforms/8xx/cpm1.c                     |    1 
 arch/powerpc/platforms/8xx/micropatch.c               |    1 
 arch/powerpc/platforms/cell/cbe_regs.c                |    4 
 arch/powerpc/platforms/cell/interrupt.c               |    4 
 arch/powerpc/platforms/cell/pervasive.c               |    4 
 arch/powerpc/platforms/cell/setup.c                   |    1 
 arch/powerpc/platforms/cell/smp.c                     |    4 
 arch/powerpc/platforms/cell/spider-pic.c              |    4 
 arch/powerpc/platforms/cell/spufs/file.c              |   10 
 arch/powerpc/platforms/chrp/pci.c                     |    4 
 arch/powerpc/platforms/chrp/setup.c                   |    1 
 arch/powerpc/platforms/chrp/smp.c                     |    4 
 arch/powerpc/platforms/maple/setup.c                  |    1 
 arch/powerpc/platforms/maple/time.c                   |    1 
 arch/powerpc/platforms/powermac/setup.c               |    1 
 arch/powerpc/platforms/powermac/smp.c                 |    4 
 arch/powerpc/platforms/powermac/time.c                |    1 
 arch/powerpc/platforms/pseries/lpar.c                 |    4 
 arch/powerpc/platforms/pseries/setup.c                |    1 
 arch/powerpc/platforms/pseries/smp.c                  |    4 
 arch/powerpc/sysdev/cpm2.c                            |    1 
 arch/powerpc/sysdev/fsl_85xx_cache_sram.c             |    2 
 arch/powerpc/sysdev/mpic.c                            |    4 
 arch/powerpc/xmon/xmon.c                              |    1 
 arch/riscv/include/asm/fixmap.h                       |    4 
 arch/riscv/include/asm/io.h                           |    4 
 arch/riscv/include/asm/kasan.h                        |    4 
 arch/riscv/include/asm/pgtable-64.h                   |    7 
 arch/riscv/include/asm/pgtable.h                      |   22 
 arch/riscv/kernel/module.c                            |    2 
 arch/riscv/kernel/setup.c                             |    1 
 arch/riscv/kernel/soc.c                               |    2 
 arch/riscv/kernel/stacktrace.c                        |   23 
 arch/riscv/kernel/vdso.c                              |    4 
 arch/riscv/mm/cacheflush.c                            |    3 
 arch/riscv/mm/fault.c                                 |   14 
 arch/riscv/mm/init.c                                  |   31 
 arch/riscv/mm/kasan_init.c                            |    4 
 arch/riscv/mm/pageattr.c                              |    6 
 arch/riscv/mm/ptdump.c                                |    2 
 arch/s390/boot/ipl_parm.c                             |    4 
 arch/s390/boot/kaslr.c                                |    4 
 arch/s390/include/asm/hugetlb.h                       |    4 
 arch/s390/include/asm/kasan.h                         |    4 
 arch/s390/include/asm/pgtable.h                       |   15 
 arch/s390/include/asm/tlbflush.h                      |    1 
 arch/s390/kernel/asm-offsets.c                        |    4 
 arch/s390/kernel/dumpstack.c                          |   25 
 arch/s390/kernel/machine_kexec.c                      |    1 
 arch/s390/kernel/ptrace.c                             |    1 
 arch/s390/kernel/uv.c                                 |    4 
 arch/s390/kernel/vdso.c                               |    5 
 arch/s390/kvm/gaccess.c                               |    8 
 arch/s390/kvm/interrupt.c                             |    4 
 arch/s390/kvm/kvm-s390.c                              |   32 
 arch/s390/kvm/priv.c                                  |   38 
 arch/s390/mm/dump_pagetables.c                        |    1 
 arch/s390/mm/extmem.c                                 |    4 
 arch/s390/mm/fault.c                                  |   17 
 arch/s390/mm/gmap.c                                   |   80 
 arch/s390/mm/init.c                                   |    1 
 arch/s390/mm/kasan_init.c                             |    4 
 arch/s390/mm/pageattr.c                               |   13 
 arch/s390/mm/pgalloc.c                                |    2 
 arch/s390/mm/pgtable.c                                |    1 
 arch/s390/mm/vmem.c                                   |    1 
 arch/s390/pci/pci_mmio.c                              |    4 
 arch/sh/include/asm/io.h                              |    2 
 arch/sh/include/asm/kdebug.h                          |    6 
 arch/sh/include/asm/pgtable-3level.h                  |    7 
 arch/sh/include/asm/pgtable.h                         |    2 
 arch/sh/include/asm/pgtable_32.h                      |   25 
 arch/sh/include/asm/processor_32.h                    |    2 
 arch/sh/kernel/dumpstack.c                            |   54 
 arch/sh/kernel/machine_kexec.c                        |    1 
 arch/sh/kernel/process_32.c                           |    2 
 arch/sh/kernel/ptrace_32.c                            |    1 
 arch/sh/kernel/signal_32.c                            |    1 
 arch/sh/kernel/sys_sh.c                               |    6 
 arch/sh/kernel/traps.c                                |    4 
 arch/sh/kernel/vsyscall/vsyscall.c                    |    4 
 arch/sh/mm/cache-sh3.c                                |    1 
 arch/sh/mm/cache-sh4.c                                |   11 
 arch/sh/mm/cache-sh7705.c                             |    1 
 arch/sh/mm/fault.c                                    |   16 
 arch/sh/mm/kmap.c                                     |    5 
 arch/sh/mm/nommu.c                                    |    1 
 arch/sh/mm/pmb.c                                      |    4 
 arch/sparc/include/asm/floppy_32.h                    |    4 
 arch/sparc/include/asm/highmem.h                      |    4 
 arch/sparc/include/asm/ide.h                          |    2 
 arch/sparc/include/asm/io-unit.h                      |    4 
 arch/sparc/include/asm/pgalloc_32.h                   |    4 
 arch/sparc/include/asm/pgalloc_64.h                   |    2 
 arch/sparc/include/asm/pgtable_32.h                   |   34 
 arch/sparc/include/asm/pgtable_64.h                   |   32 
 arch/sparc/kernel/cpu.c                               |    4 
 arch/sparc/kernel/entry.S                             |    4 
 arch/sparc/kernel/head_64.S                           |    4 
 arch/sparc/kernel/ktlb.S                              |    4 
 arch/sparc/kernel/leon_smp.c                          |    1 
 arch/sparc/kernel/pci.c                               |    4 
 arch/sparc/kernel/process_32.c                        |   29 
 arch/sparc/kernel/process_64.c                        |    3 
 arch/sparc/kernel/ptrace_32.c                         |    1 
 arch/sparc/kernel/ptrace_64.c                         |    1 
 arch/sparc/kernel/setup_32.c                          |    1 
 arch/sparc/kernel/setup_64.c                          |    1 
 arch/sparc/kernel/signal32.c                          |    1 
 arch/sparc/kernel/signal_32.c                         |    1 
 arch/sparc/kernel/signal_64.c                         |    1 
 arch/sparc/kernel/smp_32.c                            |    1 
 arch/sparc/kernel/smp_64.c                            |    1 
 arch/sparc/kernel/sun4m_irq.c                         |    4 
 arch/sparc/kernel/trampoline_64.S                     |    4 
 arch/sparc/kernel/traps_32.c                          |    4 
 arch/sparc/kernel/traps_64.c                          |   24 
 arch/sparc/lib/clear_page.S                           |    4 
 arch/sparc/lib/copy_page.S                            |    2 
 arch/sparc/mm/fault_32.c                              |   21 
 arch/sparc/mm/fault_64.c                              |   17 
 arch/sparc/mm/highmem.c                               |   12 
 arch/sparc/mm/hugetlbpage.c                           |    1 
 arch/sparc/mm/init_32.c                               |    1 
 arch/sparc/mm/init_64.c                               |    7 
 arch/sparc/mm/io-unit.c                               |   11 
 arch/sparc/mm/iommu.c                                 |    9 
 arch/sparc/mm/tlb.c                                   |    1 
 arch/sparc/mm/tsb.c                                   |    4 
 arch/sparc/mm/ultra.S                                 |    4 
 arch/sparc/vdso/vma.c                                 |    4 
 arch/um/drivers/mconsole_kern.c                       |    2 
 arch/um/include/asm/mmu_context.h                     |    5 
 arch/um/include/asm/pgtable-3level.h                  |    4 
 arch/um/include/asm/pgtable.h                         |   69 
 arch/um/kernel/maccess.c                              |   12 
 arch/um/kernel/mem.c                                  |   10 
 arch/um/kernel/process.c                              |    1 
 arch/um/kernel/skas/mmu.c                             |    3 
 arch/um/kernel/skas/uaccess.c                         |    1 
 arch/um/kernel/sysrq.c                                |   35 
 arch/um/kernel/tlb.c                                  |    5 
 arch/um/kernel/trap.c                                 |   15 
 arch/um/kernel/um_arch.c                              |    1 
 arch/unicore32/include/asm/pgtable.h                  |   19 
 arch/unicore32/kernel/hibernate.c                     |    4 
 arch/unicore32/kernel/hibernate_asm.S                 |    4 
 arch/unicore32/kernel/module.c                        |    1 
 arch/unicore32/kernel/setup.h                         |    4 
 arch/unicore32/kernel/traps.c                         |   50 
 arch/unicore32/lib/backtrace.S                        |   24 
 arch/unicore32/mm/alignment.c                         |    4 
 arch/unicore32/mm/fault.c                             |    9 
 arch/unicore32/mm/mm.h                                |   10 
 arch/unicore32/mm/proc-ucv2.S                         |    4 
 arch/x86/boot/compressed/kaslr_64.c                   |    4 
 arch/x86/entry/vdso/vma.c                             |   14 
 arch/x86/events/core.c                                |    4 
 arch/x86/include/asm/agp.h                            |    2 
 arch/x86/include/asm/asm-prototypes.h                 |    4 
 arch/x86/include/asm/efi.h                            |    4 
 arch/x86/include/asm/iomap.h                          |    1 
 arch/x86/include/asm/kaslr.h                          |    2 
 arch/x86/include/asm/mmu.h                            |    2 
 arch/x86/include/asm/pgtable-3level.h                 |    8 
 arch/x86/include/asm/pgtable.h                        |   89 -
 arch/x86/include/asm/pgtable_32.h                     |   11 
 arch/x86/include/asm/pgtable_64.h                     |    4 
 arch/x86/include/asm/setup.h                          |   12 
 arch/x86/include/asm/stacktrace.h                     |    2 
 arch/x86/include/asm/uaccess.h                        |   16 
 arch/x86/include/asm/xen/hypercall.h                  |    4 
 arch/x86/include/asm/xen/page.h                       |    1 
 arch/x86/kernel/acpi/boot.c                           |    4 
 arch/x86/kernel/acpi/sleep.c                          |    4 
 arch/x86/kernel/alternative.c                         |    1 
 arch/x86/kernel/amd_gart_64.c                         |    5 
 arch/x86/kernel/apic/apic_numachip.c                  |    4 
 arch/x86/kernel/cpu/bugs.c                            |    4 
 arch/x86/kernel/cpu/common.c                          |    4 
 arch/x86/kernel/cpu/intel.c                           |    4 
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c             |    6 
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                |    6 
 arch/x86/kernel/crash_core_32.c                       |    4 
 arch/x86/kernel/crash_core_64.c                       |    4 
 arch/x86/kernel/doublefault_32.c                      |    1 
 arch/x86/kernel/dumpstack.c                           |   21 
 arch/x86/kernel/early_printk.c                        |    4 
 arch/x86/kernel/espfix_64.c                           |    2 
 arch/x86/kernel/head64.c                              |    4 
 arch/x86/kernel/head_64.S                             |    4 
 arch/x86/kernel/i8259.c                               |    4 
 arch/x86/kernel/irqinit.c                             |    4 
 arch/x86/kernel/kprobes/core.c                        |    4 
 arch/x86/kernel/kprobes/opt.c                         |    4 
 arch/x86/kernel/ldt.c                                 |    2 
 arch/x86/kernel/machine_kexec_32.c                    |    1 
 arch/x86/kernel/machine_kexec_64.c                    |    1 
 arch/x86/kernel/module.c                              |    1 
 arch/x86/kernel/paravirt.c                            |    4 
 arch/x86/kernel/process_32.c                          |    1 
 arch/x86/kernel/process_64.c                          |    1 
 arch/x86/kernel/ptrace.c                              |    1 
 arch/x86/kernel/reboot.c                              |    4 
 arch/x86/kernel/smpboot.c                             |    4 
 arch/x86/kernel/tboot.c                               |    3 
 arch/x86/kernel/vm86_32.c                             |    4 
 arch/x86/kvm/mmu/paging_tmpl.h                        |    8 
 arch/x86/mm/cpu_entry_area.c                          |    4 
 arch/x86/mm/debug_pagetables.c                        |    2 
 arch/x86/mm/dump_pagetables.c                         |    1 
 arch/x86/mm/fault.c                                   |   22 
 arch/x86/mm/init.c                                    |   22 
 arch/x86/mm/init_32.c                                 |   27 
 arch/x86/mm/init_64.c                                 |    1 
 arch/x86/mm/ioremap.c                                 |    4 
 arch/x86/mm/kasan_init_64.c                           |    1 
 arch/x86/mm/kaslr.c                                   |   37 
 arch/x86/mm/maccess.c                                 |   44 
 arch/x86/mm/mem_encrypt_boot.S                        |    2 
 arch/x86/mm/mmio-mod.c                                |    4 
 arch/x86/mm/pat/cpa-test.c                            |    1 
 arch/x86/mm/pat/memtype.c                             |    1 
 arch/x86/mm/pat/memtype_interval.c                    |    4 
 arch/x86/mm/pgtable.c                                 |    1 
 arch/x86/mm/pgtable_32.c                              |    1 
 arch/x86/mm/pti.c                                     |    1 
 arch/x86/mm/setup_nx.c                                |    4 
 arch/x86/platform/efi/efi_32.c                        |    4 
 arch/x86/platform/efi/efi_64.c                        |    1 
 arch/x86/platform/olpc/olpc_ofw.c                     |    4 
 arch/x86/power/cpu.c                                  |    4 
 arch/x86/power/hibernate.c                            |    4 
 arch/x86/power/hibernate_32.c                         |    4 
 arch/x86/power/hibernate_64.c                         |    4 
 arch/x86/realmode/init.c                              |    4 
 arch/x86/um/vdso/vma.c                                |    4 
 arch/x86/xen/enlighten_pv.c                           |    1 
 arch/x86/xen/grant-table.c                            |    1 
 arch/x86/xen/mmu_pv.c                                 |    4 
 arch/x86/xen/smp_pv.c                                 |    2 
 arch/xtensa/include/asm/fixmap.h                      |   12 
 arch/xtensa/include/asm/highmem.h                     |    4 
 arch/xtensa/include/asm/initialize_mmu.h              |    2 
 arch/xtensa/include/asm/mmu_context.h                 |    4 
 arch/xtensa/include/asm/pgtable.h                     |   20 
 arch/xtensa/kernel/entry.S                            |    4 
 arch/xtensa/kernel/process.c                          |    1 
 arch/xtensa/kernel/ptrace.c                           |    1 
 arch/xtensa/kernel/setup.c                            |    1 
 arch/xtensa/kernel/traps.c                            |   42 
 arch/xtensa/kernel/vectors.S                          |    4 
 arch/xtensa/mm/cache.c                                |    4 
 arch/xtensa/mm/fault.c                                |   12 
 arch/xtensa/mm/highmem.c                              |    2 
 arch/xtensa/mm/ioremap.c                              |    4 
 arch/xtensa/mm/kasan_init.c                           |   10 
 arch/xtensa/mm/misc.S                                 |    4 
 arch/xtensa/mm/mmu.c                                  |    5 
 drivers/acpi/scan.c                                   |    3 
 drivers/android/binder_alloc.c                        |   14 
 drivers/atm/fore200e.c                                |    4 
 drivers/base/power/main.c                             |    4 
 drivers/block/z2ram.c                                 |    4 
 drivers/char/agp/frontend.c                           |    1 
 drivers/char/agp/generic.c                            |    1 
 drivers/char/bsr.c                                    |    1 
 drivers/char/mspec.c                                  |    3 
 drivers/dma-buf/dma-resv.c                            |    5 
 drivers/firmware/efi/arm-runtime.c                    |    4 
 drivers/firmware/efi/efi.c                            |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h            |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v7.c     |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v8.c     |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c      |    4 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c               |   10 
 drivers/gpu/drm/amd/amdkfd/kfd_events.c               |    4 
 drivers/gpu/drm/drm_vm.c                              |    4 
 drivers/gpu/drm/etnaviv/etnaviv_gem.c                 |    2 
 drivers/gpu/drm/i915/gem/i915_gem_mman.c              |    4 
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c           |   14 
 drivers/gpu/drm/i915/i915_mm.c                        |    1 
 drivers/gpu/drm/i915/i915_perf.c                      |    2 
 drivers/gpu/drm/nouveau/nouveau_svm.c                 |   22 
 drivers/gpu/drm/radeon/radeon_cs.c                    |    4 
 drivers/gpu/drm/radeon/radeon_gem.c                   |    6 
 drivers/gpu/drm/ttm/ttm_bo_vm.c                       |   10 
 drivers/infiniband/core/umem_odp.c                    |    4 
 drivers/infiniband/core/uverbs_main.c                 |    6 
 drivers/infiniband/hw/hfi1/mmu_rb.c                   |    2 
 drivers/infiniband/hw/mlx4/mr.c                       |    4 
 drivers/infiniband/hw/qib/qib_file_ops.c              |    4 
 drivers/infiniband/hw/qib/qib_user_pages.c            |    6 
 drivers/infiniband/hw/usnic/usnic_uiom.c              |    4 
 drivers/infiniband/sw/rdmavt/mmap.c                   |    1 
 drivers/infiniband/sw/rxe/rxe_mmap.c                  |    1 
 drivers/infiniband/sw/siw/siw_mem.c                   |    4 
 drivers/iommu/amd_iommu_v2.c                          |    4 
 drivers/iommu/intel-svm.c                             |    4 
 drivers/macintosh/macio-adb.c                         |    4 
 drivers/macintosh/mediabay.c                          |    4 
 drivers/macintosh/via-pmu.c                           |    4 
 drivers/media/pci/bt8xx/bt878.c                       |    4 
 drivers/media/pci/bt8xx/btcx-risc.c                   |    4 
 drivers/media/pci/bt8xx/bttv-risc.c                   |    4 
 drivers/media/platform/davinci/vpbe_display.c         |    1 
 drivers/media/v4l2-core/v4l2-common.c                 |    1 
 drivers/media/v4l2-core/videobuf-core.c               |    4 
 drivers/media/v4l2-core/videobuf-dma-contig.c         |    4 
 drivers/media/v4l2-core/videobuf-dma-sg.c             |   10 
 drivers/media/v4l2-core/videobuf-vmalloc.c            |    4 
 drivers/misc/cxl/cxllib.c                             |    9 
 drivers/misc/cxl/fault.c                              |    4 
 drivers/misc/genwqe/card_utils.c                      |    2 
 drivers/misc/sgi-gru/grufault.c                       |   25 
 drivers/misc/sgi-gru/grufile.c                        |    4 
 drivers/mtd/ubi/ubi.h                                 |    2 
 drivers/net/ethernet/amd/7990.c                       |    4 
 drivers/net/ethernet/amd/hplance.c                    |    4 
 drivers/net/ethernet/amd/mvme147.c                    |    4 
 drivers/net/ethernet/amd/sun3lance.c                  |    4 
 drivers/net/ethernet/amd/sunlance.c                   |    4 
 drivers/net/ethernet/apple/bmac.c                     |    4 
 drivers/net/ethernet/apple/mace.c                     |    4 
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c |    4 
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c      |    4 
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c      |    4 
 drivers/net/ethernet/i825xx/82596.c                   |    4 
 drivers/net/ethernet/korina.c                         |    4 
 drivers/net/ethernet/marvell/pxa168_eth.c             |    4 
 drivers/net/ethernet/natsemi/jazzsonic.c              |    4 
 drivers/net/ethernet/natsemi/macsonic.c               |    4 
 drivers/net/ethernet/natsemi/xtsonic.c                |    4 
 drivers/net/ethernet/sun/sunbmac.c                    |    4 
 drivers/net/ethernet/sun/sunhme.c                     |    1 
 drivers/net/ethernet/sun/sunqe.c                      |    4 
 drivers/oprofile/buffer_sync.c                        |   12 
 drivers/sbus/char/flash.c                             |    1 
 drivers/sbus/char/uctrl.c                             |    1 
 drivers/scsi/53c700.c                                 |    4 
 drivers/scsi/a2091.c                                  |    1 
 drivers/scsi/a3000.c                                  |    1 
 drivers/scsi/arm/cumana_2.c                           |    4 
 drivers/scsi/arm/eesox.c                              |    4 
 drivers/scsi/arm/powertec.c                           |    4 
 drivers/scsi/dpt_i2o.c                                |    4 
 drivers/scsi/gvp11.c                                  |    1 
 drivers/scsi/lasi700.c                                |    1 
 drivers/scsi/mac53c94.c                               |    4 
 drivers/scsi/mesh.c                                   |    4 
 drivers/scsi/mvme147.c                                |    1 
 drivers/scsi/qlogicpti.c                              |    4 
 drivers/scsi/sni_53c710.c                             |    1 
 drivers/scsi/zorro_esp.c                              |    4 
 drivers/staging/android/ashmem.c                      |    4 
 drivers/staging/comedi/comedi_fops.c                  |    2 
 drivers/staging/kpc2000/kpc_dma/fileops.c             |    4 
 drivers/staging/media/atomisp/pci/hmm/hmm_bo.c        |    4 
 drivers/tee/optee/call.c                              |    4 
 drivers/tty/sysrq.c                                   |    4 
 drivers/tty/vt/consolemap.c                           |    2 
 drivers/vfio/pci/vfio_pci.c                           |   22 
 drivers/vfio/vfio_iommu_type1.c                       |    8 
 drivers/vhost/vdpa.c                                  |    4 
 drivers/video/console/newport_con.c                   |    1 
 drivers/video/fbdev/acornfb.c                         |    1 
 drivers/video/fbdev/atafb.c                           |    1 
 drivers/video/fbdev/cirrusfb.c                        |    1 
 drivers/video/fbdev/cyber2000fb.c                     |    1 
 drivers/video/fbdev/fb-puv3.c                         |    1 
 drivers/video/fbdev/hitfb.c                           |    1 
 drivers/video/fbdev/neofb.c                           |    1 
 drivers/video/fbdev/q40fb.c                           |    1 
 drivers/video/fbdev/savage/savagefb_driver.c          |    1 
 drivers/xen/balloon.c                                 |    1 
 drivers/xen/gntdev.c                                  |    6 
 drivers/xen/grant-table.c                             |    1 
 drivers/xen/privcmd.c                                 |   15 
 drivers/xen/xenbus/xenbus_probe.c                     |    1 
 drivers/xen/xenbus/xenbus_probe_backend.c             |    1 
 drivers/xen/xenbus/xenbus_probe_frontend.c            |    1 
 fs/aio.c                                              |    4 
 fs/coredump.c                                         |    8 
 fs/exec.c                                             |   18 
 fs/ext2/file.c                                        |    2 
 fs/ext4/super.c                                       |    6 
 fs/hugetlbfs/inode.c                                  |    2 
 fs/io_uring.c                                         |    4 
 fs/kernfs/file.c                                      |    4 
 fs/proc/array.c                                       |    1 
 fs/proc/base.c                                        |   24 
 fs/proc/meminfo.c                                     |    1 
 fs/proc/nommu.c                                       |    1 
 fs/proc/task_mmu.c                                    |   34 
 fs/proc/task_nommu.c                                  |   18 
 fs/proc/vmcore.c                                      |    1 
 fs/userfaultfd.c                                      |   46 
 fs/xfs/xfs_file.c                                     |    2 
 fs/xfs/xfs_inode.c                                    |   14 
 fs/xfs/xfs_iops.c                                     |    4 
 include/asm-generic/io.h                              |    2 
 include/asm-generic/pgtable-nopmd.h                   |    1 
 include/asm-generic/pgtable-nopud.h                   |    1 
 include/asm-generic/pgtable.h                         | 1322 ----------------
 include/linux/cache.h                                 |   10 
 include/linux/crash_dump.h                            |    3 
 include/linux/dax.h                                   |    1 
 include/linux/dma-noncoherent.h                       |    2 
 include/linux/fs.h                                    |    4 
 include/linux/hmm.h                                   |    2 
 include/linux/huge_mm.h                               |    2 
 include/linux/hugetlb.h                               |    2 
 include/linux/io-mapping.h                            |    4 
 include/linux/kallsyms.h                              |    4 
 include/linux/kasan.h                                 |    4 
 include/linux/mempolicy.h                             |    2 
 include/linux/mm.h                                    |   15 
 include/linux/mm_types.h                              |    4 
 include/linux/mmap_lock.h                             |  128 +
 include/linux/mmu_notifier.h                          |   13 
 include/linux/pagemap.h                               |    2 
 include/linux/pgtable.h                               | 1444 +++++++++++++++++-
 include/linux/rmap.h                                  |    2 
 include/linux/sched/debug.h                           |    7 
 include/linux/sched/mm.h                              |   10 
 include/linux/uaccess.h                               |   62 
 include/xen/arm/page.h                                |    4 
 init/init_task.c                                      |    1 
 ipc/shm.c                                             |    8 
 kernel/acct.c                                         |    6 
 kernel/bpf/stackmap.c                                 |   21 
 kernel/bpf/syscall.c                                  |    2 
 kernel/cgroup/cpuset.c                                |    4 
 kernel/debug/kdb/kdb_bt.c                             |   17 
 kernel/events/core.c                                  |   10 
 kernel/events/uprobes.c                               |   20 
 kernel/exit.c                                         |   11 
 kernel/fork.c                                         |   15 
 kernel/futex.c                                        |    4 
 kernel/locking/lockdep.c                              |    4 
 kernel/locking/rtmutex-debug.c                        |    4 
 kernel/power/snapshot.c                               |    1 
 kernel/relay.c                                        |    2 
 kernel/sched/core.c                                   |   10 
 kernel/sched/fair.c                                   |    4 
 kernel/sys.c                                          |   22 
 kernel/trace/bpf_trace.c                              |  176 +-
 kernel/trace/ftrace.c                                 |    8 
 kernel/trace/trace_kprobe.c                           |   80 
 kernel/trace/trace_output.c                           |    4 
 lib/dump_stack.c                                      |    4 
 lib/ioremap.c                                         |    1 
 lib/test_hmm.c                                        |   14 
 lib/test_lockup.c                                     |   16 
 mm/debug.c                                            |   10 
 mm/debug_vm_pgtable.c                                 |    1 
 mm/filemap.c                                          |   46 
 mm/frame_vector.c                                     |    6 
 mm/gup.c                                              |   73 
 mm/hmm.c                                              |    2 
 mm/huge_memory.c                                      |    8 
 mm/hugetlb.c                                          |    3 
 mm/init-mm.c                                          |    6 
 mm/internal.h                                         |    6 
 mm/khugepaged.c                                       |   72 
 mm/ksm.c                                              |   48 
 mm/maccess.c                                          |  496 +++---
 mm/madvise.c                                          |   40 
 mm/memcontrol.c                                       |   10 
 mm/memory.c                                           |   61 
 mm/mempolicy.c                                        |   36 
 mm/migrate.c                                          |   16 
 mm/mincore.c                                          |    8 
 mm/mlock.c                                            |   22 
 mm/mmap.c                                             |   74 
 mm/mmu_gather.c                                       |    2 
 mm/mmu_notifier.c                                     |   22 
 mm/mprotect.c                                         |   22 
 mm/mremap.c                                           |   14 
 mm/msync.c                                            |    8 
 mm/nommu.c                                            |   22 
 mm/oom_kill.c                                         |   14 
 mm/page_io.c                                          |    1 
 mm/page_reporting.h                                   |    2 
 mm/pagewalk.c                                         |   12 
 mm/pgtable-generic.c                                  |    6 
 mm/process_vm_access.c                                |    4 
 mm/ptdump.c                                           |    4 
 mm/rmap.c                                             |   12 
 mm/shmem.c                                            |    5 
 mm/sparse-vmemmap.c                                   |    1 
 mm/sparse.c                                           |    1 
 mm/swap_state.c                                       |    5 
 mm/swapfile.c                                         |    5 
 mm/userfaultfd.c                                      |   26 
 mm/util.c                                             |   12 
 mm/vmacache.c                                         |    1 
 mm/zsmalloc.c                                         |    4 
 net/ipv4/tcp.c                                        |    8 
 net/xdp/xdp_umem.c                                    |    4 
 security/keys/keyctl.c                                |    2 
 sound/core/oss/pcm_oss.c                              |    2 
 sound/core/sgbuf.c                                    |    1 
 sound/pci/hda/hda_intel.c                             |    4 
 sound/soc/intel/common/sst-firmware.c                 |    4 
 sound/soc/intel/haswell/sst-haswell-pcm.c             |    4 
 tools/include/linux/kallsyms.h                        |    2 
 virt/kvm/async_pf.c                                   |    4 
 virt/kvm/kvm_main.c                                   |    9 
 942 files changed, 4580 insertions(+), 5662 deletions(-)
