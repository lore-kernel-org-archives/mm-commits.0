From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-include-linux-pgtableh.patch added to -mm
 tree
Date: Fri, 15 May 2020 14:13:34 -0700
Message-ID: <20200515211334.zVCvMQpH3%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOVNq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 May 2020 17:13:46 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: introduce include/linux/pgtable.h
has been added to the -mm tree.  Its filename is
     mm-introduce-include-linux-pgtableh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-include-linux-pgtableh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-include-linux-pgtableh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: introduce include/linux/pgtable.h

The include/linux/pgtable.h is going to be the home of generic page table
manipulation functions.

Start with moving asm-generic/pgtable.h to include/linux/pgtable.h and
make the latter include asm/pgtable.h.

Link: http://lkml.kernel.org/r/20200514170327.31389-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Cain <bcain@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgtable.h                      |    2 
 arch/alpha/kernel/proto.h                             |    2 
 arch/arc/include/asm/pgtable.h                        |    2 
 arch/arc/mm/highmem.c                                 |    2 
 arch/arc/mm/tlbex.S                                   |    2 
 arch/arm/include/asm/efi.h                            |    2 
 arch/arm/include/asm/fixmap.h                         |    2 
 arch/arm/include/asm/idmap.h                          |    2 
 arch/arm/include/asm/pgtable-nommu.h                  |    2 
 arch/arm/include/asm/pgtable.h                        |    2 
 arch/arm/kernel/head.S                                |    2 
 arch/arm/kernel/suspend.c                             |    2 
 arch/arm/kernel/vmlinux.lds.S                         |    2 
 arch/arm/mach-integrator/core.c                       |    2 
 arch/arm/mach-keystone/platsmp.c                      |    2 
 arch/arm/mach-sa1100/hackkit.c                        |    2 
 arch/arm/mach-tegra/iomap.h                           |    2 
 arch/arm/mach-zynq/common.c                           |    2 
 arch/arm/mm/idmap.c                                   |    2 
 arch/arm/mm/mm.h                                      |    2 
 arch/arm/mm/proc-arm1020.S                            |    2 
 arch/arm/mm/proc-arm1020e.S                           |    2 
 arch/arm/mm/proc-arm1022.S                            |    2 
 arch/arm/mm/proc-arm1026.S                            |    2 
 arch/arm/mm/proc-arm720.S                             |    2 
 arch/arm/mm/proc-arm740.S                             |    2 
 arch/arm/mm/proc-arm7tdmi.S                           |    2 
 arch/arm/mm/proc-arm920.S                             |    2 
 arch/arm/mm/proc-arm922.S                             |    2 
 arch/arm/mm/proc-arm925.S                             |    2 
 arch/arm/mm/proc-arm926.S                             |    2 
 arch/arm/mm/proc-arm940.S                             |    2 
 arch/arm/mm/proc-arm946.S                             |    2 
 arch/arm/mm/proc-arm9tdmi.S                           |    2 
 arch/arm/mm/proc-fa526.S                              |    2 
 arch/arm/mm/proc-feroceon.S                           |    2 
 arch/arm/mm/proc-mohawk.S                             |    2 
 arch/arm/mm/proc-sa110.S                              |    2 
 arch/arm/mm/proc-sa1100.S                             |    2 
 arch/arm/mm/proc-v6.S                                 |    2 
 arch/arm/mm/proc-v7.S                                 |    2 
 arch/arm/mm/proc-xsc3.S                               |    2 
 arch/arm/mm/proc-xscale.S                             |    2 
 arch/arm/mm/pv-fixup-asm.S                            |    2 
 arch/arm64/include/asm/io.h                           |    2 
 arch/arm64/include/asm/kernel-pgtable.h               |    2 
 arch/arm64/include/asm/kvm_mmu.h                      |    2 
 arch/arm64/include/asm/mmu_context.h                  |    2 
 arch/arm64/include/asm/pgtable.h                      |    4 
 arch/arm64/include/asm/stage2_pgtable.h               |    2 
 arch/arm64/include/asm/vmap_stack.h                   |    2 
 arch/arm64/kernel/acpi.c                              |    2 
 arch/arm64/kernel/head.S                              |    2 
 arch/arm64/kernel/kaslr.c                             |    2 
 arch/arm64/kernel/suspend.c                           |    2 
 arch/arm64/kernel/vmlinux.lds.S                       |    2 
 arch/arm64/mm/proc.S                                  |    2 
 arch/c6x/include/asm/pgtable.h                        |    2 
 arch/csky/include/asm/io.h                            |    2 
 arch/csky/include/asm/pgtable.h                       |    2 
 arch/h8300/include/asm/pgtable.h                      |    1 
 arch/hexagon/include/asm/pgtable.h                    |    3 
 arch/hexagon/mm/uaccess.c                             |    2 
 arch/ia64/include/asm/pgtable.h                       |    1 
 arch/ia64/include/asm/uaccess.h                       |    2 
 arch/ia64/kernel/entry.S                              |    2 
 arch/ia64/kernel/head.S                               |    2 
 arch/ia64/kernel/irq_ia64.c                           |    2 
 arch/ia64/kernel/ivt.S                                |    2 
 arch/ia64/kernel/kprobes.c                            |    2 
 arch/ia64/kernel/mca_asm.S                            |    2 
 arch/ia64/kernel/relocate_kernel.S                    |    2 
 arch/ia64/kernel/setup.c                              |    2 
 arch/ia64/kernel/uncached.c                           |    2 
 arch/ia64/kernel/vmlinux.lds.S                        |    2 
 arch/m68k/68000/m68EZ328.c                            |    2 
 arch/m68k/68000/m68VZ328.c                            |    2 
 arch/m68k/include/asm/pgtable_mm.h                    |    1 
 arch/m68k/include/asm/pgtable_no.h                    |    2 
 arch/m68k/include/asm/sun3xflop.h                     |    2 
 arch/m68k/kernel/head.S                               |    2 
 arch/microblaze/include/asm/pgalloc.h                 |    2 
 arch/microblaze/include/asm/pgtable.h                 |    2 
 arch/microblaze/include/asm/uaccess.h                 |    2 
 arch/microblaze/kernel/hw_exception_handler.S         |    2 
 arch/microblaze/kernel/module.c                       |    2 
 arch/microblaze/kernel/setup.c                        |    2 
 arch/microblaze/mm/pgtable.c                          |    2 
 arch/mips/include/asm/pgtable.h                       |    2 
 arch/mips/jazz/irq.c                                  |    2 
 arch/mips/jazz/setup.c                                |    2 
 arch/mips/kvm/mips.c                                  |    2 
 arch/mips/mm/tlbex.c                                  |    2 
 arch/nds32/include/asm/highmem.h                      |    2 
 arch/nds32/include/asm/pgtable.h                      |    2 
 arch/nds32/kernel/head.S                              |    2 
 arch/nds32/kernel/module.c                            |    2 
 arch/nios2/include/asm/pgtable.h                      |    2 
 arch/nios2/kernel/nios2_ksyms.c                       |    2 
 arch/openrisc/include/asm/io.h                        |    2 
 arch/openrisc/include/asm/pgtable.h                   |    2 
 arch/openrisc/kernel/entry.S                          |    2 
 arch/openrisc/kernel/head.S                           |    2 
 arch/openrisc/kernel/or32_ksyms.c                     |    2 
 arch/openrisc/mm/ioremap.c                            |    2 
 arch/parisc/include/asm/io.h                          |    2 
 arch/parisc/include/asm/pgtable.h                     |    1 
 arch/parisc/kernel/asm-offsets.c                      |    2 
 arch/parisc/kernel/entry.S                            |    2 
 arch/parisc/kernel/head.S                             |    2 
 arch/parisc/kernel/pacache.S                          |    2 
 arch/parisc/kernel/pdt.c                              |    2 
 arch/powerpc/include/asm/fixmap.h                     |    2 
 arch/powerpc/include/asm/kup.h                        |    2 
 arch/powerpc/include/asm/nohash/pgtable.h             |    2 
 arch/powerpc/include/asm/pgtable.h                    |    2 
 arch/powerpc/include/asm/tlb.h                        |    2 
 arch/powerpc/kernel/btext.c                           |    2 
 arch/powerpc/kernel/fpu.S                             |    2 
 arch/powerpc/kernel/head_32.S                         |    2 
 arch/powerpc/kernel/head_40x.S                        |    2 
 arch/powerpc/kernel/head_44x.S                        |    2 
 arch/powerpc/kernel/head_8xx.S                        |    2 
 arch/powerpc/kernel/head_fsl_booke.S                  |    2 
 arch/powerpc/kernel/io-workarounds.c                  |    2 
 arch/powerpc/kernel/irq.c                             |    2 
 arch/powerpc/kernel/mce_power.c                       |    2 
 arch/powerpc/kernel/paca.c                            |    2 
 arch/powerpc/kernel/prom.c                            |    2 
 arch/powerpc/kernel/prom_init.c                       |    2 
 arch/powerpc/kernel/rtas_pci.c                        |    2 
 arch/powerpc/kernel/setup-common.c                    |    2 
 arch/powerpc/kernel/setup_32.c                        |    2 
 arch/powerpc/kernel/setup_64.c                        |    2 
 arch/powerpc/kernel/smp.c                             |    2 
 arch/powerpc/kvm/book3s_64_mmu_radix.c                |    2 
 arch/powerpc/kvm/book3s_hv_nested.c                   |    2 
 arch/powerpc/kvm/book3s_hv_rm_xics.c                  |    2 
 arch/powerpc/kvm/book3s_hv_rm_xive.c                  |    2 
 arch/powerpc/kvm/fpu.S                                |    2 
 arch/powerpc/mm/book3s32/hash_low.S                   |    2 
 arch/powerpc/mm/book3s64/hash_native.c                |    2 
 arch/powerpc/mm/book3s64/hash_utils.c                 |    2 
 arch/powerpc/mm/book3s64/slb.c                        |    2 
 arch/powerpc/mm/book3s64/subpage_prot.c               |    2 
 arch/powerpc/mm/init-common.c                         |    2 
 arch/powerpc/mm/nohash/tlb_low_64e.S                  |    2 
 arch/powerpc/mm/ptdump/8xx.c                          |    2 
 arch/powerpc/mm/ptdump/bats.c                         |    2 
 arch/powerpc/mm/ptdump/book3s64.c                     |    2 
 arch/powerpc/mm/ptdump/shared.c                       |    2 
 arch/powerpc/platforms/85xx/corenet_generic.c         |    2 
 arch/powerpc/platforms/85xx/mpc85xx_cds.c             |    2 
 arch/powerpc/platforms/85xx/qemu_e500.c               |    2 
 arch/powerpc/platforms/85xx/sbc8548.c                 |    2 
 arch/powerpc/platforms/85xx/smp.c                     |    2 
 arch/powerpc/platforms/86xx/mpc86xx_smp.c             |    2 
 arch/powerpc/platforms/cell/cbe_regs.c                |    2 
 arch/powerpc/platforms/cell/interrupt.c               |    2 
 arch/powerpc/platforms/cell/pervasive.c               |    2 
 arch/powerpc/platforms/cell/smp.c                     |    2 
 arch/powerpc/platforms/cell/spider-pic.c              |    2 
 arch/powerpc/platforms/chrp/pci.c                     |    2 
 arch/powerpc/platforms/chrp/smp.c                     |    2 
 arch/powerpc/platforms/powermac/smp.c                 |    2 
 arch/powerpc/platforms/pseries/lpar.c                 |    2 
 arch/powerpc/platforms/pseries/smp.c                  |    2 
 arch/powerpc/sysdev/fsl_85xx_cache_sram.c             |    2 
 arch/powerpc/sysdev/mpic.c                            |    2 
 arch/riscv/include/asm/fixmap.h                       |    2 
 arch/riscv/include/asm/io.h                           |    2 
 arch/riscv/include/asm/kasan.h                        |    2 
 arch/riscv/include/asm/pgtable.h                      |    2 
 arch/riscv/kernel/module.c                            |    2 
 arch/riscv/kernel/soc.c                               |    2 
 arch/riscv/mm/cacheflush.c                            |    2 
 arch/riscv/mm/kasan_init.c                            |    2 
 arch/riscv/mm/pageattr.c                              |    2 
 arch/riscv/mm/ptdump.c                                |    2 
 arch/s390/boot/ipl_parm.c                             |    2 
 arch/s390/boot/kaslr.c                                |    2 
 arch/s390/include/asm/hugetlb.h                       |    2 
 arch/s390/include/asm/kasan.h                         |    2 
 arch/s390/include/asm/pgtable.h                       |    2 
 arch/s390/kernel/asm-offsets.c                        |    2 
 arch/s390/kvm/gaccess.c                               |    2 
 arch/s390/kvm/kvm-s390.c                              |    2 
 arch/s390/kvm/priv.c                                  |    2 
 arch/s390/mm/extmem.c                                 |    2 
 arch/s390/mm/gmap.c                                   |    2 
 arch/s390/mm/kasan_init.c                             |    2 
 arch/sh/include/asm/io.h                              |    2 
 arch/sh/include/asm/pgtable.h                         |    2 
 arch/sh/mm/pmb.c                                      |    2 
 arch/sparc/include/asm/floppy_32.h                    |    2 
 arch/sparc/include/asm/highmem.h                      |    2 
 arch/sparc/include/asm/ide.h                          |    2 
 arch/sparc/include/asm/io-unit.h                      |    2 
 arch/sparc/include/asm/pgalloc_32.h                   |    2 
 arch/sparc/include/asm/pgtable_32.h                   |    2 
 arch/sparc/include/asm/pgtable_64.h                   |    1 
 arch/sparc/kernel/cpu.c                               |    2 
 arch/sparc/kernel/entry.S                             |    2 
 arch/sparc/kernel/head_64.S                           |    2 
 arch/sparc/kernel/ktlb.S                              |    2 
 arch/sparc/kernel/pci.c                               |    2 
 arch/sparc/kernel/sun4m_irq.c                         |    2 
 arch/sparc/kernel/trampoline_64.S                     |    2 
 arch/sparc/kernel/traps_32.c                          |    2 
 arch/sparc/lib/clear_page.S                           |    2 
 arch/sparc/lib/copy_page.S                            |    2 
 arch/sparc/mm/tsb.c                                   |    2 
 arch/sparc/mm/ultra.S                                 |    2 
 arch/um/include/asm/pgtable.h                         |    2 
 arch/unicore32/include/asm/pgtable.h                  |    2 
 arch/unicore32/kernel/hibernate.c                     |    2 
 arch/unicore32/kernel/hibernate_asm.S                 |    2 
 arch/unicore32/mm/alignment.c                         |    2 
 arch/unicore32/mm/proc-ucv2.S                         |    2 
 arch/x86/boot/compressed/kaslr_64.c                   |    2 
 arch/x86/include/asm/agp.h                            |    2 
 arch/x86/include/asm/asm-prototypes.h                 |    2 
 arch/x86/include/asm/efi.h                            |    2 
 arch/x86/include/asm/pgtable.h                        |    3 
 arch/x86/include/asm/xen/hypercall.h                  |    2 
 arch/x86/kernel/acpi/boot.c                           |    2 
 arch/x86/kernel/acpi/sleep.c                          |    2 
 arch/x86/kernel/apic/apic_numachip.c                  |    2 
 arch/x86/kernel/cpu/bugs.c                            |    2 
 arch/x86/kernel/cpu/common.c                          |    2 
 arch/x86/kernel/cpu/intel.c                           |    2 
 arch/x86/kernel/crash_core_32.c                       |    2 
 arch/x86/kernel/crash_core_64.c                       |    2 
 arch/x86/kernel/early_printk.c                        |    2 
 arch/x86/kernel/espfix_64.c                           |    2 
 arch/x86/kernel/head64.c                              |    2 
 arch/x86/kernel/head_64.S                             |    2 
 arch/x86/kernel/i8259.c                               |    2 
 arch/x86/kernel/irqinit.c                             |    2 
 arch/x86/kernel/kprobes/core.c                        |    2 
 arch/x86/kernel/kprobes/opt.c                         |    2 
 arch/x86/kernel/paravirt.c                            |    2 
 arch/x86/kernel/reboot.c                              |    2 
 arch/x86/kernel/smpboot.c                             |    2 
 arch/x86/mm/cpu_entry_area.c                          |    2 
 arch/x86/mm/debug_pagetables.c                        |    2 
 arch/x86/mm/ioremap.c                                 |    2 
 arch/x86/mm/kaslr.c                                   |    2 
 arch/x86/mm/mem_encrypt_boot.S                        |    2 
 arch/x86/mm/mmio-mod.c                                |    2 
 arch/x86/mm/pat/memtype_interval.c                    |    2 
 arch/x86/mm/setup_nx.c                                |    2 
 arch/x86/platform/efi/efi_32.c                        |    2 
 arch/x86/platform/olpc/olpc_ofw.c                     |    2 
 arch/x86/power/cpu.c                                  |    2 
 arch/x86/power/hibernate.c                            |    2 
 arch/x86/power/hibernate_32.c                         |    2 
 arch/x86/power/hibernate_64.c                         |    2 
 arch/x86/realmode/init.c                              |    2 
 arch/x86/xen/mmu_pv.c                                 |    2 
 arch/x86/xen/smp_pv.c                                 |    2 
 arch/xtensa/include/asm/fixmap.h                      |    2 
 arch/xtensa/include/asm/highmem.h                     |    2 
 arch/xtensa/include/asm/initialize_mmu.h              |    2 
 arch/xtensa/include/asm/mmu_context.h                 |    2 
 arch/xtensa/include/asm/pgtable.h                     |    2 
 arch/xtensa/kernel/entry.S                            |    2 
 arch/xtensa/kernel/traps.c                            |    2 
 arch/xtensa/kernel/vectors.S                          |    2 
 arch/xtensa/mm/cache.c                                |    2 
 arch/xtensa/mm/ioremap.c                              |    2 
 arch/xtensa/mm/misc.S                                 |    2 
 drivers/acpi/scan.c                                   |    2 
 drivers/atm/fore200e.c                                |    2 
 drivers/block/z2ram.c                                 |    2 
 drivers/firmware/efi/arm-runtime.c                    |    2 
 drivers/gpu/drm/drm_vm.c                              |    2 
 drivers/infiniband/hw/qib/qib_file_ops.c              |    2 
 drivers/macintosh/macio-adb.c                         |    2 
 drivers/macintosh/mediabay.c                          |    2 
 drivers/macintosh/via-pmu.c                           |    2 
 drivers/media/pci/bt8xx/bt878.c                       |    2 
 drivers/media/pci/bt8xx/btcx-risc.c                   |    2 
 drivers/media/pci/bt8xx/bttv-risc.c                   |    2 
 drivers/media/v4l2-core/videobuf-dma-sg.c             |    2 
 drivers/media/v4l2-core/videobuf-vmalloc.c            |    2 
 drivers/misc/genwqe/card_utils.c                      |    2 
 drivers/mtd/ubi/ubi.h                                 |    2 
 drivers/net/ethernet/amd/7990.c                       |    2 
 drivers/net/ethernet/amd/hplance.c                    |    2 
 drivers/net/ethernet/amd/mvme147.c                    |    2 
 drivers/net/ethernet/amd/sun3lance.c                  |    2 
 drivers/net/ethernet/amd/sunlance.c                   |    2 
 drivers/net/ethernet/apple/bmac.c                     |    2 
 drivers/net/ethernet/apple/mace.c                     |    2 
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c |    2 
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c      |    2 
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c      |    2 
 drivers/net/ethernet/i825xx/82596.c                   |    2 
 drivers/net/ethernet/korina.c                         |    2 
 drivers/net/ethernet/marvell/pxa168_eth.c             |    2 
 drivers/net/ethernet/natsemi/jazzsonic.c              |    2 
 drivers/net/ethernet/natsemi/macsonic.c               |    2 
 drivers/net/ethernet/natsemi/xtsonic.c                |    2 
 drivers/net/ethernet/sun/sunbmac.c                    |    2 
 drivers/net/ethernet/sun/sunqe.c                      |    2 
 drivers/scsi/53c700.c                                 |    2 
 drivers/scsi/arm/cumana_2.c                           |    2 
 drivers/scsi/arm/eesox.c                              |    2 
 drivers/scsi/arm/powertec.c                           |    2 
 drivers/scsi/dpt_i2o.c                                |    2 
 drivers/scsi/mac53c94.c                               |    2 
 drivers/scsi/mesh.c                                   |    2 
 drivers/scsi/qlogicpti.c                              |    2 
 drivers/scsi/zorro_esp.c                              |    2 
 include/asm-generic/io.h                              |    2 
 include/asm-generic/pgtable.h                         | 1289 ---------
 include/linux/crash_dump.h                            |    2 
 include/linux/dma-noncoherent.h                       |    2 
 include/linux/hmm.h                                   |    2 
 include/linux/hugetlb.h                               |    2 
 include/linux/io-mapping.h                            |    2 
 include/linux/kasan.h                                 |    2 
 include/linux/mm.h                                    |    2 
 include/linux/pgtable.h                               | 1290 ++++++++++
 include/xen/arm/page.h                                |    2 
 kernel/bpf/syscall.c                                  |    2 
 mm/init-mm.c                                          |    2 
 mm/mincore.c                                          |    2 
 mm/mprotect.c                                         |    2 
 mm/page_reporting.h                                   |    2 
 mm/pgtable-generic.c                                  |    6 
 mm/zsmalloc.c                                         |    2 
 sound/pci/hda/hda_intel.c                             |    2 
 sound/soc/intel/common/sst-firmware.c                 |    2 
 sound/soc/intel/haswell/sst-haswell-pcm.c             |    2 
 336 files changed, 1600 insertions(+), 1650 deletions(-)

--- a/arch/alpha/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/alpha/include/asm/pgtable.h
@@ -355,8 +355,6 @@ extern inline pte_t mk_swap_pte(unsigned
 
 extern void paging_init(void);
 
-#include <asm-generic/pgtable.h>
-
 /* We have our own get_unmapped_area to cope with ADDR_LIMIT_32BIT.  */
 #define HAVE_ARCH_UNMAPPED_AREA
 
--- a/arch/alpha/kernel/proto.h~mm-introduce-include-linux-pgtableh
+++ a/arch/alpha/kernel/proto.h
@@ -2,7 +2,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /* Prototypes of functions used across modules here in this directory.  */
 
--- a/arch/arc/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arc/include/asm/pgtable.h
@@ -390,8 +390,6 @@ void update_mmu_cache(struct vm_area_str
 #include <asm/hugepage.h>
 #endif
 
-#include <asm-generic/pgtable.h>
-
 /* to cope with aliasing VIPT cache */
 #define HAVE_ARCH_UNMAPPED_AREA
 
--- a/arch/arc/mm/highmem.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arc/mm/highmem.c
@@ -7,7 +7,7 @@
 #include <linux/export.h>
 #include <linux/highmem.h>
 #include <asm/processor.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
--- a/arch/arc/mm/tlbex.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arc/mm/tlbex.S
@@ -35,7 +35,7 @@
 #include <linux/linkage.h>
 #include <asm/entry.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/arcregs.h>
 #include <asm/cache.h>
 #include <asm/processor.h>
--- a/arch/arm64/include/asm/io.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/include/asm/io.h
@@ -13,7 +13,7 @@
 #include <asm/byteorder.h>
 #include <asm/barrier.h>
 #include <asm/memory.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/early_ioremap.h>
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
--- a/arch/arm64/include/asm/kernel-pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/include/asm/kernel-pgtable.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_KERNEL_PGTABLE_H
 #define __ASM_KERNEL_PGTABLE_H
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/sparsemem.h>
 
 /*
--- a/arch/arm64/include/asm/kvm_mmu.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/include/asm/kvm_mmu.h
@@ -87,7 +87,7 @@ alternative_cb_end
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
--- a/arch/arm64/include/asm/mmu_context.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/include/asm/mmu_context.h
@@ -20,7 +20,7 @@
 #include <asm/proc-fns.h>
 #include <asm-generic/mm_hooks.h>
 #include <asm/cputype.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/sysreg.h>
 #include <asm/tlbflush.h>
 
--- a/arch/arm64/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/include/asm/pgtable.h
@@ -340,7 +340,7 @@ static inline pgprot_t mk_pmd_sect_prot(
 
 #ifdef CONFIG_NUMA_BALANCING
 /*
- * See the comment in include/asm-generic/pgtable.h
+ * See the comment in include/linux/pgtable.h
  */
 static inline int pte_protnone(pte_t pte)
 {
@@ -853,8 +853,6 @@ static inline pmd_t pmdp_establish(struc
 
 extern int kern_addr_valid(unsigned long addr);
 
-#include <asm-generic/pgtable.h>
-
 /*
  * On AArch64, the cache coherency is handled via the set_pte_at() function.
  */
--- a/arch/arm64/include/asm/stage2_pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/include/asm/stage2_pgtable.h
@@ -9,7 +9,7 @@
 #define __ARM64_S2_PGTABLE_H_
 
 #include <linux/hugetlb.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /*
  * PGDIR_SHIFT determines the size a top-level page table entry can map
--- a/arch/arm64/include/asm/vmap_stack.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/include/asm/vmap_stack.h
@@ -8,7 +8,7 @@
 #include <linux/kconfig.h>
 #include <linux/vmalloc.h>
 #include <asm/memory.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/thread_info.h>
 
 /*
--- a/arch/arm64/kernel/acpi.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/kernel/acpi.c
@@ -28,7 +28,7 @@
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
 #include <asm/daifflags.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/smp_plat.h>
 
 int acpi_noirq = 1;		/* skip ACPI IRQ initialization */
--- a/arch/arm64/kernel/head.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/kernel/head.S
@@ -26,7 +26,7 @@
 #include <asm/kvm_arm.h>
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/smp.h>
 #include <asm/sysreg.h>
--- a/arch/arm64/kernel/kaslr.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/kernel/kaslr.c
@@ -17,7 +17,7 @@
 #include <asm/kernel-pgtable.h>
 #include <asm/memory.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/sections.h>
 
 enum kaslr_status {
--- a/arch/arm64/kernel/suspend.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/kernel/suspend.c
@@ -9,7 +9,7 @@
 #include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
 #include <asm/exec.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/memory.h>
 #include <asm/mmu_context.h>
 #include <asm/smp_plat.h>
--- a/arch/arm64/kernel/vmlinux.lds.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/kernel/vmlinux.lds.S
@@ -13,7 +13,7 @@
 #include <asm/thread_info.h>
 #include <asm/memory.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "image.h"
 
--- a/arch/arm64/mm/proc.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm64/mm/proc.S
@@ -13,7 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/asm_pointer_auth.h>
 #include <asm/hwcap.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/cpufeature.h>
 #include <asm/alternative.h>
--- a/arch/arm/include/asm/efi.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/include/asm/efi.h
@@ -13,7 +13,7 @@
 #include <asm/highmem.h>
 #include <asm/mach/map.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #ifdef CONFIG_EFI
--- a/arch/arm/include/asm/fixmap.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/include/asm/fixmap.h
@@ -7,7 +7,7 @@
 #define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 
 #include <asm/kmap_types.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 enum fixed_addresses {
 	FIX_EARLYCON_MEM_BASE,
--- a/arch/arm/include/asm/idmap.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/include/asm/idmap.h
@@ -3,7 +3,7 @@
 #define __ASM_IDMAP_H
 
 #include <linux/compiler.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /* Tag a function as requiring to be executed via an identity mapping. */
 #define __idmap __section(.idmap.text) noinline notrace
--- a/arch/arm/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/include/asm/pgtable.h
@@ -339,8 +339,6 @@ static inline pte_t pte_modify(pte_t pte
 /* FIXME: this is not correct */
 #define kern_addr_valid(addr)	(1)
 
-#include <asm-generic/pgtable.h>
-
 /*
  * We provide our own arch_get_unmapped_area to cope with VIPT caches.
  */
--- a/arch/arm/include/asm/pgtable-nommu.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/include/asm/pgtable-nommu.h
@@ -73,8 +73,6 @@ extern unsigned int kobjsize(const void
 
 #define FIRST_USER_ADDRESS      0UL
 
-#include <asm-generic/pgtable.h>
-
 #else 
 
 /*
--- a/arch/arm/kernel/head.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/kernel/head.S
@@ -18,7 +18,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/memory.h>
 #include <asm/thread_info.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #if defined(CONFIG_DEBUG_LL) && !defined(CONFIG_DEBUG_SEMIHOSTING)
 #include CONFIG_DEBUG_LL_INCLUDE
--- a/arch/arm/kernel/suspend.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/kernel/suspend.c
@@ -7,7 +7,7 @@
 #include <asm/cacheflush.h>
 #include <asm/idmap.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/memory.h>
 #include <asm/smp_plat.h>
 #include <asm/suspend.h>
--- a/arch/arm/kernel/vmlinux.lds.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -14,7 +14,7 @@
 #include <asm/memory.h>
 #include <asm/mpu.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "vmlinux.lds.h"
 
--- a/arch/arm/mach-integrator/core.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mach-integrator/core.c
@@ -24,7 +24,7 @@
 
 #include <asm/mach-types.h>
 #include <asm/mach/time.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "hardware.h"
 #include "cm.h"
--- a/arch/arm/mach-keystone/platsmp.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mach-keystone/platsmp.c
@@ -16,7 +16,7 @@
 #include <asm/smp_plat.h>
 #include <asm/prom.h>
 #include <asm/tlbflush.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "keystone.h"
 
--- a/arch/arm/mach-sa1100/hackkit.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mach-sa1100/hackkit.c
@@ -26,7 +26,7 @@
 #include <asm/mach-types.h>
 #include <asm/setup.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
--- a/arch/arm/mach-tegra/iomap.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mach-tegra/iomap.h
@@ -10,7 +10,7 @@
 #ifndef __MACH_TEGRA_IOMAP_H
 #define __MACH_TEGRA_IOMAP_H
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/sizes.h>
 
 #define TEGRA_IRAM_BASE			0x40000000
--- a/arch/arm/mach-zynq/common.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mach-zynq/common.c
@@ -30,7 +30,7 @@
 #include <asm/mach/time.h>
 #include <asm/mach-types.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/smp_scu.h>
 #include <asm/system_info.h>
 #include <asm/hardware/cache-l2x0.h>
--- a/arch/arm/mm/idmap.c~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/idmap.c
@@ -8,7 +8,7 @@
 #include <asm/idmap.h>
 #include <asm/hwcap.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/sections.h>
 #include <asm/system_info.h>
 
--- a/arch/arm/mm/mm.h~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/mm.h
@@ -3,7 +3,7 @@
 #include <linux/list.h>
 #include <linux/vmalloc.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /* the upper-most page table pointer */
 extern pmd_t *top_pmd;
--- a/arch/arm/mm/proc-arm1020e.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm1020e.S
@@ -15,7 +15,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm1020.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm1020.S
@@ -15,7 +15,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm1022.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm1022.S
@@ -15,7 +15,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm1026.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm1026.S
@@ -15,7 +15,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm720.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm720.S
@@ -24,7 +24,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm740.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm740.S
@@ -10,7 +10,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm7tdmi.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm7tdmi.S
@@ -10,7 +10,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm920.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm920.S
@@ -16,7 +16,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm922.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm922.S
@@ -17,7 +17,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm925.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm925.S
@@ -40,7 +40,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm926.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm926.S
@@ -16,7 +16,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm940.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm940.S
@@ -9,7 +9,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
 
--- a/arch/arm/mm/proc-arm946.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm946.S
@@ -11,7 +11,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
 
--- a/arch/arm/mm/proc-arm9tdmi.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-arm9tdmi.S
@@ -10,7 +10,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-fa526.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-fa526.S
@@ -14,7 +14,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 
--- a/arch/arm/mm/proc-feroceon.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-feroceon.S
@@ -11,7 +11,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-mohawk.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-mohawk.S
@@ -12,7 +12,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-sa1100.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-sa1100.S
@@ -22,7 +22,7 @@
 #include <asm/hwcap.h>
 #include <mach/hardware.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "proc-macros.S"
 
--- a/arch/arm/mm/proc-sa110.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-sa110.S
@@ -17,7 +17,7 @@
 #include <asm/hwcap.h>
 #include <mach/hardware.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-v6.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-v6.S
@@ -13,7 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "proc-macros.S"
 
--- a/arch/arm/mm/proc-v7.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-v7.S
@@ -13,7 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/memory.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-xsc3.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-xsc3.S
@@ -25,7 +25,7 @@
 #include <linux/init.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
--- a/arch/arm/mm/proc-xscale.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/proc-xscale.S
@@ -21,7 +21,7 @@
 #include <linux/init.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
--- a/arch/arm/mm/pv-fixup-asm.S~mm-introduce-include-linux-pgtableh
+++ a/arch/arm/mm/pv-fixup-asm.S
@@ -9,7 +9,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/cp15.h>
 #include <asm/memory.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 	.section ".idmap.text", "ax"
 
--- a/arch/c6x/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/c6x/include/asm/pgtable.h
@@ -64,6 +64,4 @@ extern unsigned long empty_zero_page;
  */
 #define pgprot_writecombine pgprot_noncached
 
-#include <asm-generic/pgtable.h>
-
 #endif /* _ASM_C6X_PGTABLE_H */
--- a/arch/csky/include/asm/io.h~mm-introduce-include-linux-pgtableh
+++ a/arch/csky/include/asm/io.h
@@ -4,7 +4,7 @@
 #ifndef __ASM_CSKY_IO_H
 #define __ASM_CSKY_IO_H
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/types.h>
 #include <linux/version.h>
 
--- a/arch/csky/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/csky/include/asm/pgtable.h
@@ -306,6 +306,4 @@ void update_mmu_cache(struct vm_area_str
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot) \
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
-#include <asm-generic/pgtable.h>
-
 #endif /* __ASM_CSKY_PGTABLE_H */
--- a/arch/h8300/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/h8300/include/asm/pgtable.h
@@ -2,7 +2,6 @@
 #ifndef _H8300_PGTABLE_H
 #define _H8300_PGTABLE_H
 #include <asm-generic/pgtable-nopud.h>
-#include <asm-generic/pgtable.h>
 extern void paging_init(void);
 #define PAGE_NONE		__pgprot(0)    /* these mean nothing to NO_MM */
 #define PAGE_SHARED		__pgprot(0)    /* these mean nothing to NO_MM */
--- a/arch/hexagon/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -460,7 +460,4 @@ static inline int pte_exec(pte_t pte)
 		((type << 1) | \
 		 ((offset & 0x7ffff0) << 9) | ((offset & 0xf) << 6)) })
 
-/*  Oh boy.  There are a lot of possible arch overrides found in this file.  */
-#include <asm-generic/pgtable.h>
-
 #endif
--- a/arch/hexagon/mm/uaccess.c~mm-introduce-include-linux-pgtableh
+++ a/arch/hexagon/mm/uaccess.c
@@ -11,7 +11,7 @@
  */
 #include <linux/types.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /*
  * For clear_user(), exploit previously defined copy_to_user function
--- a/arch/ia64/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/include/asm/pgtable.h
@@ -583,6 +583,5 @@ extern struct page *zero_page_memmap_ptr
 #include <asm-generic/pgtable-nopud.h>
 #endif
 #include <asm-generic/pgtable-nop4d.h>
-#include <asm-generic/pgtable.h>
 
 #endif /* _ASM_IA64_PGTABLE_H */
--- a/arch/ia64/include/asm/uaccess.h~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/include/asm/uaccess.h
@@ -37,7 +37,7 @@
 #include <linux/page-flags.h>
 
 #include <asm/intrinsics.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/extable.h>
 
--- a/arch/ia64/kernel/entry.S~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/entry.S
@@ -43,7 +43,7 @@
 #include <asm/errno.h>
 #include <asm/kregs.h>
 #include <asm/asm-offsets.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/percpu.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
--- a/arch/ia64/kernel/head.S~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/head.S
@@ -27,7 +27,7 @@
 #include <asm/mmu_context.h>
 #include <asm/asm-offsets.h>
 #include <asm/pal.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/mca_asm.h>
--- a/arch/ia64/kernel/irq_ia64.c~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/irq_ia64.c
@@ -37,7 +37,7 @@
 #include <asm/intrinsics.h>
 #include <asm/io.h>
 #include <asm/hw_irq.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 
 #ifdef CONFIG_PERFMON
--- a/arch/ia64/kernel/ivt.S~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/ivt.S
@@ -52,7 +52,7 @@
 #include <asm/break.h>
 #include <asm/kregs.h>
 #include <asm/asm-offsets.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
--- a/arch/ia64/kernel/kprobes.c~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/kprobes.c
@@ -18,7 +18,7 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/sections.h>
 #include <asm/exception.h>
 
--- a/arch/ia64/kernel/mca_asm.S~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/mca_asm.S
@@ -27,7 +27,7 @@
 #include <linux/threads.h>
 
 #include <asm/asmmacro.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/mca_asm.h>
 #include <asm/mca.h>
--- a/arch/ia64/kernel/relocate_kernel.S~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/relocate_kernel.S
@@ -11,7 +11,7 @@
 #include <asm/asmmacro.h>
 #include <asm/kregs.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/mca_asm.h>
 
        /* Must be relocatable PIC code callable as a C function
--- a/arch/ia64/kernel/setup.c~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/setup.c
@@ -56,7 +56,7 @@
 #include <asm/meminit.h>
 #include <asm/page.h>
 #include <asm/patch.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/sal.h>
 #include <asm/sections.h>
--- a/arch/ia64/kernel/uncached.c~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/uncached.c
@@ -21,7 +21,7 @@
 #include <linux/gfp.h>
 #include <asm/page.h>
 #include <asm/pal.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/atomic.h>
 #include <asm/tlbflush.h>
 
--- a/arch/ia64/kernel/vmlinux.lds.S~mm-introduce-include-linux-pgtableh
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -2,7 +2,7 @@
 
 #include <asm/cache.h>
 #include <asm/ptrace.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/thread_info.h>
 
 #define EMITS_PT_NOTE
--- a/arch/m68k/68000/m68EZ328.c~mm-introduce-include-linux-pgtableh
+++ a/arch/m68k/68000/m68EZ328.c
@@ -17,7 +17,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/rtc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/MC68EZ328.h>
 #ifdef CONFIG_UCSIMM
--- a/arch/m68k/68000/m68VZ328.c~mm-introduce-include-linux-pgtableh
+++ a/arch/m68k/68000/m68VZ328.c
@@ -23,7 +23,7 @@
 #include <linux/irq.h>
 #include <linux/rtc.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/MC68VZ328.h>
 #include <asm/bootstd.h>
--- a/arch/m68k/include/asm/pgtable_mm.h~mm-introduce-include-linux-pgtableh
+++ a/arch/m68k/include/asm/pgtable_mm.h
@@ -176,7 +176,6 @@ pgprot_t pgprot_dmacoherent(pgprot_t pro
 #define pgprot_dmacoherent(prot)	pgprot_dmacoherent(prot)
 
 #endif /* CONFIG_COLDFIRE */
-#include <asm-generic/pgtable.h>
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _M68K_PGTABLE_H */
--- a/arch/m68k/include/asm/pgtable_no.h~mm-introduce-include-linux-pgtableh
+++ a/arch/m68k/include/asm/pgtable_no.h
@@ -53,6 +53,4 @@ extern void paging_init(void);
 #define	KMAP_START	0
 #define	KMAP_END	0xffffffff
 
-#include <asm-generic/pgtable.h>
-
 #endif /* _M68KNOMMU_PGTABLE_H */
--- a/arch/m68k/include/asm/sun3xflop.h~mm-introduce-include-linux-pgtableh
+++ a/arch/m68k/include/asm/sun3xflop.h
@@ -11,7 +11,7 @@
 #define __ASM_SUN3X_FLOPPY_H
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/sun3x.h>
 
--- a/arch/m68k/kernel/head.S~mm-introduce-include-linux-pgtableh
+++ a/arch/m68k/kernel/head.S
@@ -264,7 +264,7 @@
 #include <asm/bootinfo-vme.h>
 #include <asm/setup.h>
 #include <asm/entry.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
 #ifdef CONFIG_MAC
--- a/arch/microblaze/include/asm/pgalloc.h~mm-introduce-include-linux-pgtableh
+++ a/arch/microblaze/include/asm/pgalloc.h
@@ -16,7 +16,7 @@
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/cache.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
 #include <asm-generic/pgalloc.h>
--- a/arch/microblaze/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -507,8 +507,6 @@ void __init *early_get_page(void);
 #endif /* CONFIG_MMU */
 
 #ifndef __ASSEMBLY__
-#include <asm-generic/pgtable.h>
-
 extern unsigned long ioremap_bot, ioremap_base;
 
 void setup_memory(void);
--- a/arch/microblaze/include/asm/uaccess.h~mm-introduce-include-linux-pgtableh
+++ a/arch/microblaze/include/asm/uaccess.h
@@ -12,7 +12,7 @@
 
 #include <asm/mmu.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/extable.h>
 #include <linux/string.h>
 
--- a/arch/microblaze/kernel/hw_exception_handler.S~mm-introduce-include-linux-pgtableh
+++ a/arch/microblaze/kernel/hw_exception_handler.S
@@ -70,7 +70,7 @@
 #include <linux/linkage.h>
 
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/signal.h>
 #include <asm/registers.h>
 #include <asm/asm-offsets.h>
--- a/arch/microblaze/kernel/module.c~mm-introduce-include-linux-pgtableh
+++ a/arch/microblaze/kernel/module.c
@@ -12,7 +12,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 
 int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
--- a/arch/microblaze/kernel/setup.c~mm-introduce-include-linux-pgtableh
+++ a/arch/microblaze/kernel/setup.c
@@ -33,7 +33,7 @@
 #include <asm/entry.h>
 #include <asm/cpuinfo.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 DEFINE_PER_CPU(unsigned int, KSP);	/* Saved kernel stack pointer */
 DEFINE_PER_CPU(unsigned int, KM);	/* Kernel/user mode */
--- a/arch/microblaze/mm/pgtable.c~mm-introduce-include-linux-pgtableh
+++ a/arch/microblaze/mm/pgtable.c
@@ -33,7 +33,7 @@
 #include <linux/init.h>
 #include <linux/mm_types.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <linux/io.h>
 #include <asm/mmu.h>
--- a/arch/mips/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/mips/include/asm/pgtable.h
@@ -659,8 +659,6 @@ static inline pmd_t pmdp_huge_get_and_cl
 
 #define gup_fast_permitted(start, end)	(!cpu_has_dc_aliases)
 
-#include <asm-generic/pgtable.h>
-
 /*
  * We provide our own get_unmapped area to cope with the virtual aliasing
  * constraints placed on us by the cache architecture.
--- a/arch/mips/jazz/irq.c~mm-introduce-include-linux-pgtableh
+++ a/arch/mips/jazz/irq.c
@@ -19,7 +19,7 @@
 #include <asm/i8259.h>
 #include <asm/io.h>
 #include <asm/jazz.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbmisc.h>
 
 static DEFINE_RAW_SPINLOCK(r4030_lock);
--- a/arch/mips/jazz/setup.c~mm-introduce-include-linux-pgtableh
+++ a/arch/mips/jazz/setup.c
@@ -21,7 +21,7 @@
 #include <asm/jazz.h>
 #include <asm/jazzdma.h>
 #include <asm/reboot.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbmisc.h>
 
 extern asmlinkage void jazz_handle_int(void);
--- a/arch/mips/kvm/mips.c~mm-introduce-include-linux-pgtableh
+++ a/arch/mips/kvm/mips.c
@@ -25,7 +25,7 @@
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include <linux/kvm_host.h>
 
--- a/arch/mips/mm/tlbex.c~mm-introduce-include-linux-pgtableh
+++ a/arch/mips/mm/tlbex.c
@@ -32,7 +32,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpu-type.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/war.h>
 #include <asm/uasm.h>
 #include <asm/setup.h>
--- a/arch/nds32/include/asm/highmem.h~mm-introduce-include-linux-pgtableh
+++ a/arch/nds32/include/asm/highmem.h
@@ -7,7 +7,7 @@
 #include <asm/proc-fns.h>
 #include <asm/kmap_types.h>
 #include <asm/fixmap.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /*
  * Right now we initialize only a single pte table. It can be extended
--- a/arch/nds32/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/nds32/include/asm/pgtable.h
@@ -374,8 +374,6 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD
 /* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
 #define kern_addr_valid(addr)	(1)
 
-#include <asm-generic/pgtable.h>
-
 /*
  * We provide our own arch_get_unmapped_area to cope with VIPT caches.
  */
--- a/arch/nds32/kernel/head.S~mm-introduce-include-linux-pgtableh
+++ a/arch/nds32/kernel/head.S
@@ -6,7 +6,7 @@
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/sizes.h>
 #include <asm/thread_info.h>
 
--- a/arch/nds32/kernel/module.c~mm-introduce-include-linux-pgtableh
+++ a/arch/nds32/kernel/module.c
@@ -5,7 +5,7 @@
 #include <linux/elf.h>
 #include <linux/vmalloc.h>
 #include <linux/moduleloader.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 void *module_alloc(unsigned long size)
 {
--- a/arch/nios2/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/nios2/include/asm/pgtable.h
@@ -285,8 +285,6 @@ static inline void pte_clear(struct mm_s
 
 #define kern_addr_valid(addr)		(1)
 
-#include <asm-generic/pgtable.h>
-
 extern void __init paging_init(void);
 extern void __init mmu_init(void);
 
--- a/arch/nios2/kernel/nios2_ksyms.c~mm-introduce-include-linux-pgtableh
+++ a/arch/nios2/kernel/nios2_ksyms.c
@@ -10,7 +10,7 @@
 #include <linux/string.h>
 
 #include <asm/cacheflush.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /* string functions */
 
--- a/arch/openrisc/include/asm/io.h~mm-introduce-include-linux-pgtableh
+++ a/arch/openrisc/include/asm/io.h
@@ -26,7 +26,7 @@
 #define PIO_MASK		0
 
 #include <asm-generic/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 void __iomem *ioremap(phys_addr_t offset, unsigned long size);
 extern void iounmap(void *addr);
--- a/arch/openrisc/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/openrisc/include/asm/pgtable.h
@@ -438,8 +438,6 @@ static inline void update_mmu_cache(stru
 
 #define kern_addr_valid(addr)           (1)
 
-#include <asm-generic/pgtable.h>
-
 typedef pte_t *pte_addr_t;
 
 #endif /* __ASSEMBLY__ */
--- a/arch/openrisc/kernel/entry.S~mm-introduce-include-linux-pgtableh
+++ a/arch/openrisc/kernel/entry.S
@@ -21,7 +21,7 @@
 #include <asm/spr_defs.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/asm-offsets.h>
 
 #define DISABLE_INTERRUPTS(t1,t2)			\
--- a/arch/openrisc/kernel/head.S~mm-introduce-include-linux-pgtableh
+++ a/arch/openrisc/kernel/head.S
@@ -19,7 +19,7 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/spr_defs.h>
--- a/arch/openrisc/kernel/or32_ksyms.c~mm-introduce-include-linux-pgtableh
+++ a/arch/openrisc/kernel/or32_ksyms.c
@@ -26,7 +26,7 @@
 #include <asm/hardirq.h>
 #include <asm/delay.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #define DECLARE_EXPORT(name) extern void name(void); EXPORT_SYMBOL(name)
 
--- a/arch/openrisc/mm/ioremap.c~mm-introduce-include-linux-pgtableh
+++ a/arch/openrisc/mm/ioremap.c
@@ -17,7 +17,7 @@
 #include <asm/kmap_types.h>
 #include <asm/fixmap.h>
 #include <asm/bug.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/sched.h>
 #include <asm/tlbflush.h>
 
--- a/arch/parisc/include/asm/io.h~mm-introduce-include-linux-pgtableh
+++ a/arch/parisc/include/asm/io.h
@@ -3,7 +3,7 @@
 #define _ASM_IO_H
 
 #include <linux/types.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #define virt_to_phys(a) ((unsigned long)__pa(a))
 #define phys_to_virt(a) __va(a)
--- a/arch/parisc/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/parisc/include/asm/pgtable.h
@@ -573,6 +573,5 @@ extern void arch_report_meminfo(struct s
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
-#include <asm-generic/pgtable.h>
 
 #endif /* _PARISC_PGTABLE_H */
--- a/arch/parisc/kernel/asm-offsets.c~mm-introduce-include-linux-pgtableh
+++ a/arch/parisc/kernel/asm-offsets.c
@@ -21,7 +21,7 @@
 #include <linux/hardirq.h>
 #include <linux/kbuild.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/pdc.h>
--- a/arch/parisc/kernel/entry.S~mm-introduce-include-linux-pgtableh
+++ a/arch/parisc/kernel/entry.S
@@ -19,7 +19,7 @@
 #include <asm/psw.h>
 #include <asm/cache.h>		/* for L1_CACHE_SHIFT */
 #include <asm/assembly.h>	/* for LDREG/STREG defines */
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/signal.h>
 #include <asm/unistd.h>
 #include <asm/ldcw.h>
--- a/arch/parisc/kernel/head.S~mm-introduce-include-linux-pgtableh
+++ a/arch/parisc/kernel/head.S
@@ -17,7 +17,7 @@
 #include <asm/pdc.h>
 	
 #include <asm/assembly.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include <linux/linkage.h>
 #include <linux/init.h>
--- a/arch/parisc/kernel/pacache.S~mm-introduce-include-linux-pgtableh
+++ a/arch/parisc/kernel/pacache.S
@@ -21,7 +21,7 @@
 
 #include <asm/psw.h>
 #include <asm/assembly.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cache.h>
 #include <asm/ldcw.h>
 #include <asm/alternative.h>
--- a/arch/parisc/kernel/pdt.c~mm-introduce-include-linux-pgtableh
+++ a/arch/parisc/kernel/pdt.c
@@ -21,7 +21,7 @@
 #include <asm/pdc.h>
 #include <asm/pdcpat.h>
 #include <asm/sections.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 enum pdt_access_type {
 	PDT_NONE,
--- a/arch/powerpc/include/asm/fixmap.h~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/include/asm/fixmap.h
@@ -17,7 +17,7 @@
 #ifndef __ASSEMBLY__
 #include <linux/sizes.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #ifdef CONFIG_HIGHMEM
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
--- a/arch/powerpc/include/asm/kup.h~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/include/asm/kup.h
@@ -37,7 +37,7 @@
 
 #else /* !__ASSEMBLY__ */
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 void setup_kup(void);
 
--- a/arch/powerpc/include/asm/nohash/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/include/asm/nohash/pgtable.h
@@ -56,7 +56,7 @@ static inline bool pte_exec(pte_t pte)
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * These work without NUMA balancing but the kernel does not care. See the
- * comment in include/asm-generic/pgtable.h . On powerpc, this will only
+ * comment in include/linux/pgtable.h . On powerpc, this will only
  * work for user pages and always return true for kernel pages.
  */
 static inline int pte_protnone(pte_t pte)
--- a/arch/powerpc/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -96,8 +96,6 @@ extern unsigned long ioremap_bot;
  */
 #define kern_addr_valid(addr)	(1)
 
-#include <asm-generic/pgtable.h>
-
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_large(pmd)		0
 #endif
--- a/arch/powerpc/include/asm/tlb.h~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/include/asm/tlb.h
@@ -10,7 +10,7 @@
 #ifdef __KERNEL__
 
 #ifndef __powerpc64__
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #endif
 #include <asm/pgalloc.h>
 #ifndef __powerpc64__
--- a/arch/powerpc/kernel/btext.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/btext.c
@@ -15,7 +15,7 @@
 #include <asm/btext.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/udbg.h>
--- a/arch/powerpc/kernel/fpu.S~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/fpu.S
@@ -12,7 +12,7 @@
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
--- a/arch/powerpc/kernel/head_32.S~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/head_32.S
@@ -20,7 +20,7 @@
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
--- a/arch/powerpc/kernel/head_40x.S~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/head_40x.S
@@ -29,7 +29,7 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
 #include <asm/ppc_asm.h>
--- a/arch/powerpc/kernel/head_44x.S~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/head_44x.S
@@ -28,7 +28,7 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
 #include <asm/ppc_asm.h>
--- a/arch/powerpc/kernel/head_8xx.S~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/head_8xx.S
@@ -20,7 +20,7 @@
 #include <asm/page.h>
 #include <asm/mmu.h>
 #include <asm/cache.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
 #include <asm/ppc_asm.h>
--- a/arch/powerpc/kernel/head_fsl_booke.S~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/head_fsl_booke.S
@@ -31,7 +31,7 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
 #include <asm/ppc_asm.h>
--- a/arch/powerpc/kernel/io-workarounds.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/io-workarounds.c
@@ -13,7 +13,7 @@
 
 #include <asm/io.h>
 #include <asm/machdep.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ppc-pci.h>
 #include <asm/io-workarounds.h>
 #include <asm/pte-walk.h>
--- a/arch/powerpc/kernel/irq.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/irq.c
@@ -54,7 +54,7 @@
 
 #include <linux/uaccess.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/cache.h>
 #include <asm/prom.h>
--- a/arch/powerpc/kernel/mce_power.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/mce_power.c
@@ -15,7 +15,7 @@
 #include <asm/mmu.h>
 #include <asm/mce.h>
 #include <asm/machdep.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pte-walk.h>
 #include <asm/sstep.h>
 #include <asm/exception-64s.h>
--- a/arch/powerpc/kernel/paca.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/paca.c
@@ -12,7 +12,7 @@
 #include <asm/lppaca.h>
 #include <asm/paca.h>
 #include <asm/sections.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/kexec.h>
 #include <asm/svm.h>
 #include <asm/ultravisor.h>
--- a/arch/powerpc/kernel/prom.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/prom.c
@@ -41,7 +41,7 @@
 #include <asm/smp.h>
 #include <asm/mmu.h>
 #include <asm/paca.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/powernv.h>
 #include <asm/iommu.h>
 #include <asm/btext.h>
--- a/arch/powerpc/kernel/prom_init.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/prom_init.c
@@ -34,7 +34,7 @@
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/iommu.h>
 #include <asm/btext.h>
 #include <asm/sections.h>
--- a/arch/powerpc/kernel/rtas_pci.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/rtas_pci.c
@@ -15,7 +15,7 @@
 #include <linux/init.h>
 
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/kernel/setup_32.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/setup_32.c
@@ -23,7 +23,7 @@
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/processor.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
--- a/arch/powerpc/kernel/setup_64.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/setup_64.c
@@ -36,7 +36,7 @@
 #include <asm/kdump.h>
 #include <asm/prom.h>
 #include <asm/processor.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/kernel/setup-common.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/setup-common.c
@@ -37,7 +37,7 @@
 #include <asm/prom.h>
 #include <asm/processor.h>
 #include <asm/vdso_datapage.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/kernel/smp.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kernel/smp.c
@@ -41,7 +41,7 @@
 #include <asm/kvm_ppc.h>
 #include <asm/dbell.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
 #include <asm/time.h>
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -16,7 +16,7 @@
 #include <asm/kvm_book3s.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/pte-walk.h>
 #include <asm/ultravisor.h>
--- a/arch/powerpc/kvm/book3s_hv_nested.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kvm/book3s_hv_nested.c
@@ -15,7 +15,7 @@
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/pte-walk.h>
 #include <asm/reg.h>
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -15,7 +15,7 @@
 #include <asm/xics.h>
 #include <asm/synch.h>
 #include <asm/cputhreads.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ppc-opcode.h>
 #include <asm/pnv-pci.h>
 #include <asm/opal.h>
--- a/arch/powerpc/kvm/book3s_hv_rm_xive.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kvm/book3s_hv_rm_xive.c
@@ -11,7 +11,7 @@
 #include <asm/debug.h>
 #include <asm/synch.h>
 #include <asm/cputhreads.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ppc-opcode.h>
 #include <asm/pnv-pci.h>
 #include <asm/opal.h>
--- a/arch/powerpc/kvm/fpu.S~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/kvm/fpu.S
@@ -8,7 +8,7 @@
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
--- a/arch/powerpc/mm/book3s32/hash_low.S~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/book3s32/hash_low.S
@@ -16,7 +16,7 @@
 
 #include <asm/reg.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/ppc_asm.h>
 #include <asm/thread_info.h>
--- a/arch/powerpc/mm/book3s64/hash_native.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/book3s64/hash_native.c
@@ -18,7 +18,7 @@
 #include <asm/machdep.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/trace.h>
 #include <asm/tlb.h>
 #include <asm/cputable.h>
--- a/arch/powerpc/mm/book3s64/hash_utils.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/book3s64/hash_utils.c
@@ -38,7 +38,7 @@
 
 #include <asm/debugfs.h>
 #include <asm/processor.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/page.h>
--- a/arch/powerpc/mm/book3s64/slb.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/book3s64/slb.c
@@ -10,7 +10,7 @@
  */
 
 #include <asm/asm-prototypes.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/paca.h>
--- a/arch/powerpc/mm/book3s64/subpage_prot.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/book3s64/subpage_prot.c
@@ -11,7 +11,7 @@
 #include <linux/hugetlb.h>
 #include <linux/syscalls.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/uaccess.h>
 
 /*
--- a/arch/powerpc/mm/init-common.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/init-common.c
@@ -18,7 +18,7 @@
 
 #include <linux/string.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/kup.h>
 
 phys_addr_t memstart_addr __ro_after_init = (phys_addr_t)~0ull;
--- a/arch/powerpc/mm/nohash/tlb_low_64e.S~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/nohash/tlb_low_64e.S
@@ -13,7 +13,7 @@
 #include <asm/ppc_asm.h>
 #include <asm/asm-offsets.h>
 #include <asm/cputable.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/exception-64e.h>
 #include <asm/ppc-opcode.h>
 #include <asm/kvm_asm.h>
--- a/arch/powerpc/mm/ptdump/8xx.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/ptdump/8xx.c
@@ -5,7 +5,7 @@
  *
  */
 #include <linux/kernel.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "ptdump.h"
 
--- a/arch/powerpc/mm/ptdump/bats.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/ptdump/bats.c
@@ -7,7 +7,7 @@
  */
 
 #include <asm/debugfs.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cpu_has_feature.h>
 
 static char *pp_601(int k, int pp)
--- a/arch/powerpc/mm/ptdump/book3s64.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/ptdump/book3s64.c
@@ -5,7 +5,7 @@
  *
  */
 #include <linux/kernel.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "ptdump.h"
 
--- a/arch/powerpc/mm/ptdump/shared.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/mm/ptdump/shared.c
@@ -5,7 +5,7 @@
  *
  */
 #include <linux/kernel.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "ptdump.h"
 
--- a/arch/powerpc/platforms/85xx/corenet_generic.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/corenet_generic.c
@@ -16,7 +16,7 @@
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ppc-pci.h>
 #include <mm/mmu_decl.h>
 #include <asm/prom.h>
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -23,7 +23,7 @@
 #include <linux/fsl_devices.h>
 #include <linux/of_platform.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
--- a/arch/powerpc/platforms/85xx/qemu_e500.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/qemu_e500.c
@@ -14,7 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/of_fdt.h>
 #include <asm/machdep.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/time.h>
 #include <asm/udbg.h>
 #include <asm/mpic.h>
--- a/arch/powerpc/platforms/85xx/sbc8548.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/sbc8548.c
@@ -25,7 +25,7 @@
 #include <linux/fsl_devices.h>
 #include <linux/of_platform.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
--- a/arch/powerpc/platforms/85xx/smp.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/smp.c
@@ -18,7 +18,7 @@
 #include <linux/fsl/guts.h>
 
 #include <asm/machdep.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/mpic.h>
 #include <asm/cacheflush.h>
--- a/arch/powerpc/platforms/86xx/mpc86xx_smp.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/86xx/mpc86xx_smp.c
@@ -13,7 +13,7 @@
 
 #include <asm/code-patching.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pci-bridge.h>
 #include <asm/mpic.h>
 #include <asm/cacheflush.h>
--- a/arch/powerpc/platforms/cell/cbe_regs.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/cbe_regs.c
@@ -14,7 +14,7 @@
 #include <linux/of_platform.h>
 
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/ptrace.h>
 #include <asm/cell-regs.h>
--- a/arch/powerpc/platforms/cell/interrupt.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/interrupt.c
@@ -25,7 +25,7 @@
 #include <linux/kernel_stat.h>
 
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/ptrace.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/platforms/cell/pervasive.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/pervasive.c
@@ -19,7 +19,7 @@
 #include <asm/io.h>
 #include <asm/machdep.h>
 #include <asm/prom.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/reg.h>
 #include <asm/cell-regs.h>
 #include <asm/cpu_has_feature.h>
--- a/arch/powerpc/platforms/cell/smp.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/smp.c
@@ -26,7 +26,7 @@
 #include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
--- a/arch/powerpc/platforms/cell/spider-pic.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/spider-pic.c
@@ -11,7 +11,7 @@
 #include <linux/irq.h>
 #include <linux/ioport.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/io.h>
 
--- a/arch/powerpc/platforms/chrp/pci.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/chrp/pci.c
@@ -10,7 +10,7 @@
 #include <linux/init.h>
 
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/hydra.h>
 #include <asm/prom.h>
--- a/arch/powerpc/platforms/chrp/smp.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/chrp/smp.c
@@ -21,7 +21,7 @@
 #include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/prom.h>
--- a/arch/powerpc/platforms/powermac/smp.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/powermac/smp.c
@@ -36,7 +36,7 @@
 #include <asm/code-patching.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/prom.h>
--- a/arch/powerpc/platforms/pseries/lpar.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/pseries/lpar.c
@@ -24,7 +24,7 @@
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/mmu_context.h>
 #include <asm/iommu.h>
--- a/arch/powerpc/platforms/pseries/smp.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/platforms/pseries/smp.c
@@ -25,7 +25,7 @@
 #include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
--- a/arch/powerpc/sysdev/fsl_85xx_cache_sram.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/sysdev/fsl_85xx_cache_sram.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/of_platform.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/fsl_85xx_cache_sram.h>
 
 #include "fsl_85xx_cache_ctlr.h"
--- a/arch/powerpc/sysdev/mpic.c~mm-introduce-include-linux-pgtableh
+++ a/arch/powerpc/sysdev/mpic.c
@@ -33,7 +33,7 @@
 #include <asm/ptrace.h>
 #include <asm/signal.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/machdep.h>
 #include <asm/mpic.h>
--- a/arch/riscv/include/asm/fixmap.h~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/include/asm/fixmap.h
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/sizes.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #ifdef CONFIG_MMU
 /*
--- a/arch/riscv/include/asm/io.h~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/include/asm/io.h
@@ -13,7 +13,7 @@
 
 #include <linux/types.h>
 #include <asm/mmiowb.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /*
  * MMIO access functions are separated out to break dependency cycles
--- a/arch/riscv/include/asm/kasan.h~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/include/asm/kasan.h
@@ -8,7 +8,7 @@
 
 #ifdef CONFIG_KASAN
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #define KASAN_SHADOW_SCALE_SHIFT	3
 
--- a/arch/riscv/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/include/asm/pgtable.h
@@ -493,8 +493,6 @@ void paging_init(void);
 extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 #define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
 
-#include <asm-generic/pgtable.h>
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_RISCV_PGTABLE_H */
--- a/arch/riscv/kernel/module.c~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/kernel/module.c
@@ -10,7 +10,7 @@
 #include <linux/moduleloader.h>
 #include <linux/vmalloc.h>
 #include <linux/sizes.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/sections.h>
 
 static int apply_r_riscv_32_rela(struct module *me, u32 *location, Elf_Addr v)
--- a/arch/riscv/kernel/soc.c~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/kernel/soc.c
@@ -4,7 +4,7 @@
  */
 #include <linux/init.h>
 #include <linux/libfdt.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/soc.h>
 
 /*
--- a/arch/riscv/mm/cacheflush.c~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/mm/cacheflush.c
@@ -3,7 +3,7 @@
  * Copyright (C) 2017 SiFive
  */
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 
 #ifdef CONFIG_SMP
--- a/arch/riscv/mm/kasan_init.c~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/mm/kasan_init.c
@@ -7,7 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/memblock.h>
 #include <asm/tlbflush.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/fixmap.h>
 
 extern pgd_t early_pg_dir[PTRS_PER_PGD];
--- a/arch/riscv/mm/pageattr.c~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/mm/pageattr.c
@@ -4,7 +4,7 @@
  */
 
 #include <linux/pagewalk.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/bitops.h>
 
--- a/arch/riscv/mm/ptdump.c~mm-introduce-include-linux-pgtableh
+++ a/arch/riscv/mm/ptdump.c
@@ -9,7 +9,7 @@
 #include <linux/ptdump.h>
 
 #include <asm/ptdump.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/kasan.h>
 
 #define pt_dump_seq_printf(m, fmt, args...)	\
--- a/arch/s390/boot/ipl_parm.c~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/boot/ipl_parm.c
@@ -7,7 +7,7 @@
 #include <asm/sections.h>
 #include <asm/boot_data.h>
 #include <asm/facility.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/uv.h>
 #include "boot.h"
 
--- a/arch/s390/boot/kaslr.c~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/boot/kaslr.c
@@ -3,7 +3,7 @@
  * Copyright IBM Corp. 2019
  */
 #include <asm/mem_detect.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cpacf.h>
 #include <asm/timex.h>
 #include <asm/sclp.h>
--- a/arch/s390/include/asm/hugetlb.h~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/include/asm/hugetlb.h
@@ -10,7 +10,7 @@
 #define _ASM_S390_HUGETLB_H
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #define hugetlb_free_pgd_range			free_pgd_range
 #define hugepages_supported()			(MACHINE_HAS_EDAT1)
--- a/arch/s390/include/asm/kasan.h~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/include/asm/kasan.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_KASAN_H
 #define __ASM_KASAN_H
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #ifdef CONFIG_KASAN
 
--- a/arch/s390/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/include/asm/pgtable.h
@@ -1683,6 +1683,4 @@ extern void s390_reset_cmma(struct mm_st
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 
-#include <asm-generic/pgtable.h>
-
 #endif /* _S390_PAGE_H */
--- a/arch/s390/kernel/asm-offsets.c~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/kernel/asm-offsets.c
@@ -13,7 +13,7 @@
 #include <linux/purgatory.h>
 #include <asm/idle.h>
 #include <asm/vdso.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/gmap.h>
 #include <asm/nmi.h>
 #include <asm/stacktrace.h>
--- a/arch/s390/kvm/gaccess.c~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/kvm/gaccess.c
@@ -10,7 +10,7 @@
 #include <linux/mm_types.h>
 #include <linux/err.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/gmap.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
--- a/arch/s390/kvm/kvm-s390.c~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/kvm/kvm-s390.c
@@ -35,7 +35,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/lowcore.h>
 #include <asm/stp.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/gmap.h>
 #include <asm/nmi.h>
 #include <asm/switch_to.h>
--- a/arch/s390/kvm/priv.c~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/kvm/priv.c
@@ -20,7 +20,7 @@
 #include <asm/debug.h>
 #include <asm/ebcdic.h>
 #include <asm/sysinfo.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page-states.h>
 #include <asm/pgalloc.h>
 #include <asm/gmap.h>
--- a/arch/s390/mm/extmem.c~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/mm/extmem.c
@@ -22,7 +22,7 @@
 #include <linux/refcount.h>
 #include <asm/diag.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/ebcdic.h>
 #include <asm/errno.h>
 #include <asm/extmem.h>
--- a/arch/s390/mm/gmap.c~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/mm/gmap.c
@@ -18,7 +18,7 @@
 #include <linux/ksm.h>
 #include <linux/mman.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/gmap.h>
 #include <asm/tlb.h>
--- a/arch/s390/mm/kasan_init.c~mm-introduce-include-linux-pgtableh
+++ a/arch/s390/mm/kasan_init.c
@@ -3,7 +3,7 @@
 #include <linux/sched/task.h>
 #include <linux/memblock.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/kasan.h>
 #include <asm/mem_detect.h>
 #include <asm/processor.h>
--- a/arch/sh/include/asm/io.h~mm-introduce-include-linux-pgtableh
+++ a/arch/sh/include/asm/io.h
@@ -17,7 +17,7 @@
 #include <asm/cache.h>
 #include <asm/addrspace.h>
 #include <asm/machvec.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm-generic/iomap.h>
 
 #ifdef __KERNEL__
--- a/arch/sh/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/sh/include/asm/pgtable.h
@@ -185,6 +185,4 @@ static inline bool pte_access_permitted(
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 
-#include <asm-generic/pgtable.h>
-
 #endif /* __ASM_SH_PGTABLE_H */
--- a/arch/sh/mm/pmb.c~mm-introduce-include-linux-pgtableh
+++ a/arch/sh/mm/pmb.c
@@ -26,7 +26,7 @@
 #include <asm/cacheflush.h>
 #include <linux/sizes.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
--- a/arch/sparc/include/asm/floppy_32.h~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/include/asm/floppy_32.h
@@ -10,7 +10,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/idprom.h>
 #include <asm/oplib.h>
 #include <asm/auxio.h>
--- a/arch/sparc/include/asm/highmem.h~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/include/asm/highmem.h
@@ -24,7 +24,7 @@
 #include <linux/interrupt.h>
 #include <asm/vaddrs.h>
 #include <asm/kmap_types.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgtsrmmu.h>
 
 /* declarations for highmem.c */
--- a/arch/sparc/include/asm/ide.h~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/include/asm/ide.h
@@ -18,7 +18,7 @@
 #include <asm/cacheflush.h>
 #include <asm/page.h>
 #else
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/psr.h>
 #endif
 
--- a/arch/sparc/include/asm/io-unit.h~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/include/asm/io-unit.h
@@ -8,7 +8,7 @@
 
 #include <linux/spinlock.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /* The io-unit handles all virtual to physical address translations
  * that occur between the SBUS and physical memory.  Access by
--- a/arch/sparc/include/asm/pgalloc_32.h~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/include/asm/pgalloc_32.h
@@ -6,7 +6,7 @@
 #include <linux/sched.h>
 
 #include <asm/pgtsrmmu.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/vaddrs.h>
 #include <asm/page.h>
 
--- a/arch/sparc/include/asm/pgtable_32.h~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -440,8 +440,6 @@ static inline int io_remap_pfn_range(str
 	__changed;							  \
 })
 
-#include <asm-generic/pgtable.h>
-
 #endif /* !(__ASSEMBLY__) */
 
 #define VMALLOC_START           _AC(0xfe600000,UL)
--- a/arch/sparc/include/asm/pgtable_64.h~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -1122,7 +1122,6 @@ static inline bool pte_access_permitted(
 #define pte_access_permitted pte_access_permitted
 
 #include <asm/tlbflush.h>
-#include <asm-generic/pgtable.h>
 
 /* We provide our own get_unmapped_area to cope with VA holes and
  * SHM area cache aliasing for userland.
--- a/arch/sparc/kernel/cpu.c~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/kernel/cpu.c
@@ -13,7 +13,7 @@
 #include <linux/threads.h>
 
 #include <asm/spitfire.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/oplib.h>
 #include <asm/setup.h>
 #include <asm/page.h>
--- a/arch/sparc/kernel/entry.S~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/kernel/entry.S
@@ -20,7 +20,7 @@
 #include <asm/psr.h>
 #include <asm/vaddrs.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/winmacro.h>
 #include <asm/signal.h>
 #include <asm/obio.h>
--- a/arch/sparc/kernel/head_64.S~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/kernel/head_64.S
@@ -18,7 +18,7 @@
 #include <asm/ptrace.h>
 #include <asm/spitfire.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/errno.h>
 #include <asm/signal.h>
 #include <asm/processor.h>
--- a/arch/sparc/kernel/ktlb.S~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/kernel/ktlb.S
@@ -10,7 +10,7 @@
 #include <asm/head.h>
 #include <asm/asi.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tsb.h>
 
 	.text
--- a/arch/sparc/kernel/pci.c~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/kernel/pci.c
@@ -23,7 +23,7 @@
 #include <linux/of_device.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/prom.h>
 #include <asm/apb.h>
--- a/arch/sparc/kernel/sun4m_irq.c~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/kernel/sun4m_irq.c
@@ -16,7 +16,7 @@
 #include <asm/timer.h>
 #include <asm/traps.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
--- a/arch/sparc/kernel/trampoline_64.S~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/kernel/trampoline_64.S
@@ -13,7 +13,7 @@
 #include <asm/dcu.h>
 #include <asm/pstate.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/spitfire.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
--- a/arch/sparc/kernel/traps_32.c~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/kernel/traps_32.c
@@ -23,7 +23,7 @@
 #include <asm/ptrace.h>
 #include <asm/oplib.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/unistd.h>
 #include <asm/traps.h>
 
--- a/arch/sparc/lib/clear_page.S~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/lib/clear_page.S
@@ -8,7 +8,7 @@
 #include <asm/visasm.h>
 #include <asm/thread_info.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/spitfire.h>
 #include <asm/head.h>
 #include <asm/export.h>
--- a/arch/sparc/lib/copy_page.S~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/lib/copy_page.S
@@ -8,7 +8,7 @@
 #include <asm/visasm.h>
 #include <asm/thread_info.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/spitfire.h>
 #include <asm/head.h>
 #include <asm/export.h>
--- a/arch/sparc/mm/tsb.c~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/mm/tsb.c
@@ -10,7 +10,7 @@
 #include <linux/mm_types.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/tsb.h>
--- a/arch/sparc/mm/ultra.S~mm-introduce-include-linux-pgtableh
+++ a/arch/sparc/mm/ultra.S
@@ -6,7 +6,7 @@
  */
 
 #include <asm/asi.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/spitfire.h>
 #include <asm/mmu_context.h>
--- a/arch/um/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/um/include/asm/pgtable.h
@@ -353,8 +353,6 @@ extern pte_t *virt_to_pte(struct mm_stru
 
 #define kern_addr_valid(addr) (1)
 
-#include <asm-generic/pgtable.h>
-
 /* Clear a kernel PTE and flush it from the TLB */
 #define kpte_clear_flush(ptep, vaddr)		\
 do {						\
--- a/arch/unicore32/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/unicore32/include/asm/pgtable.h
@@ -279,8 +279,6 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD
 /* FIXME: this is not correct */
 #define kern_addr_valid(addr)	(1)
 
-#include <asm-generic/pgtable.h>
-
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __UNICORE_PGTABLE_H__ */
--- a/arch/unicore32/kernel/hibernate_asm.S~mm-introduce-include-linux-pgtableh
+++ a/arch/unicore32/kernel/hibernate_asm.S
@@ -13,7 +13,7 @@
 #include <linux/linkage.h>
 #include <generated/asm-offsets.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 
 @ restore_image(pgd_t *resume_pg_dir, struct pbe *restore_pblist)
--- a/arch/unicore32/kernel/hibernate.c~mm-introduce-include-linux-pgtableh
+++ a/arch/unicore32/kernel/hibernate.c
@@ -13,7 +13,7 @@
 #include <linux/memblock.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/suspend.h>
--- a/arch/unicore32/mm/alignment.c~mm-introduce-include-linux-pgtableh
+++ a/arch/unicore32/mm/alignment.c
@@ -19,7 +19,7 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/unaligned.h>
 
--- a/arch/unicore32/mm/proc-ucv2.S~mm-introduce-include-linux-pgtableh
+++ a/arch/unicore32/mm/proc-ucv2.S
@@ -11,7 +11,7 @@
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "proc-macros.S"
 
--- a/arch/x86/boot/compressed/kaslr_64.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/boot/compressed/kaslr_64.c
@@ -23,7 +23,7 @@
 
 /* These actually do the work of building the kernel identity maps. */
 #include <asm/init.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 /* Use the static base for this part of the boot process */
 #undef __PAGE_OFFSET
 #define __PAGE_OFFSET __PAGE_OFFSET_BASE
--- a/arch/x86/include/asm/agp.h~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/include/asm/agp.h
@@ -2,7 +2,7 @@
 #ifndef _ASM_X86_AGP_H
 #define _ASM_X86_AGP_H
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 
 /*
--- a/arch/x86/include/asm/asm-prototypes.h~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/include/asm/asm-prototypes.h
@@ -7,7 +7,7 @@
 
 #include <asm-generic/asm-prototypes.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/special_insns.h>
 #include <asm/preempt.h>
 #include <asm/asm.h>
--- a/arch/x86/include/asm/efi.h~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/include/asm/efi.h
@@ -3,7 +3,7 @@
 #define _ASM_X86_EFI_H
 
 #include <asm/fpu/api.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/processor-flags.h>
 #include <asm/tlb.h>
 #include <asm/nospec-branch.h>
--- a/arch/x86/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/include/asm/pgtable.h
@@ -801,7 +801,7 @@ static inline int pmd_present(pmd_t pmd)
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * These work without NUMA balancing but the kernel does not care. See the
- * comment in include/asm-generic/pgtable.h
+ * comment in include/linux/pgtable.h
  */
 static inline int pte_protnone(pte_t pte)
 {
@@ -1545,7 +1545,6 @@ static inline bool arch_faults_on_old_pt
 	return false;
 }
 
-#include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_H */
--- a/arch/x86/include/asm/xen/hypercall.h~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/include/asm/xen/hypercall.h
@@ -42,7 +42,7 @@
 #include <trace/events/xen.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/smap.h>
 #include <asm/nospec-branch.h>
 
--- a/arch/x86/kernel/acpi/boot.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/acpi/boot.c
@@ -24,7 +24,7 @@
 #include <asm/e820/api.h>
 #include <asm/irqdomain.h>
 #include <asm/pci_x86.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io_apic.h>
 #include <asm/apic.h>
 #include <asm/io.h>
--- a/arch/x86/kernel/acpi/sleep.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/acpi/sleep.c
@@ -12,7 +12,7 @@
 #include <linux/cpumask.h>
 #include <asm/segment.h>
 #include <asm/desc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/realmode.h>
 
--- a/arch/x86/kernel/apic/apic_numachip.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/apic/apic_numachip.c
@@ -16,7 +16,7 @@
 #include <asm/numachip/numachip.h>
 #include <asm/numachip/numachip_csr.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "local.h"
 
--- a/arch/x86/kernel/cpu/bugs.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/cpu/bugs.c
@@ -26,7 +26,7 @@
 #include <asm/vmx.h>
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/set_memory.h>
 #include <asm/intel-family.h>
 #include <asm/e820/api.h>
--- a/arch/x86/kernel/cpu/common.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/cpu/common.c
@@ -35,7 +35,7 @@
 #include <asm/vsyscall.h>
 #include <linux/topology.h>
 #include <linux/cpumask.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/atomic.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
--- a/arch/x86/kernel/cpu/intel.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/cpu/intel.c
@@ -11,7 +11,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/cpufeature.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/msr.h>
 #include <asm/bugs.h>
 #include <asm/cpu.h>
--- a/arch/x86/kernel/crash_core_32.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/crash_core_32.c
@@ -2,7 +2,7 @@
 
 #include <linux/crash_core.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/setup.h>
 
 void arch_crash_save_vmcoreinfo(void)
--- a/arch/x86/kernel/crash_core_64.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/crash_core_64.c
@@ -2,7 +2,7 @@
 
 #include <linux/crash_core.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/setup.h>
 
 void arch_crash_save_vmcoreinfo(void)
--- a/arch/x86/kernel/early_printk.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/early_printk.c
@@ -15,7 +15,7 @@
 #include <xen/hvc-console.h>
 #include <asm/pci-direct.h>
 #include <asm/fixmap.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/usb/ehci_def.h>
 #include <linux/usb/xhci-dbgp.h>
 #include <asm/pci_x86.h>
--- a/arch/x86/kernel/espfix_64.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/espfix_64.c
@@ -29,7 +29,7 @@
 #include <linux/percpu.h>
 #include <linux/gfp.h>
 #include <linux/random.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/setup.h>
 #include <asm/espfix.h>
--- a/arch/x86/kernel/head64.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/head64.c
@@ -26,7 +26,7 @@
 #include <asm/smp.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/kdebug.h>
--- a/arch/x86/kernel/head_64.S~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/head_64.S
@@ -14,7 +14,7 @@
 #include <linux/threads.h>
 #include <linux/init.h>
 #include <asm/segment.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/msr.h>
 #include <asm/cache.h>
--- a/arch/x86/kernel/i8259.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/i8259.c
@@ -19,7 +19,7 @@
 #include <linux/atomic.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
--- a/arch/x86/kernel/irqinit.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/irqinit.c
@@ -20,7 +20,7 @@
 #include <linux/atomic.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/setup.h>
--- a/arch/x86/kernel/kprobes/core.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/kprobes/core.c
@@ -45,7 +45,7 @@
 #include <asm/text-patching.h>
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/alternative.h>
 #include <asm/insn.h>
--- a/arch/x86/kernel/kprobes/opt.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/kprobes/opt.c
@@ -20,7 +20,7 @@
 #include <asm/text-patching.h>
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/alternative.h>
 #include <asm/insn.h>
--- a/arch/x86/kernel/paravirt.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/paravirt.c
@@ -19,7 +19,7 @@
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/setup.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/time.h>
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
--- a/arch/x86/kernel/reboot.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/reboot.c
@@ -17,7 +17,7 @@
 #include <asm/io_apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/proto.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
--- a/arch/x86/kernel/smpboot.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/kernel/smpboot.c
@@ -63,7 +63,7 @@
 #include <asm/realmode.h>
 #include <asm/cpu.h>
 #include <asm/numa.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mtrr.h>
 #include <asm/mwait.h>
--- a/arch/x86/mm/cpu_entry_area.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/mm/cpu_entry_area.c
@@ -6,7 +6,7 @@
 #include <linux/kcore.h>
 
 #include <asm/cpu_entry_area.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/fixmap.h>
 #include <asm/desc.h>
 
--- a/arch/x86/mm/debug_pagetables.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/mm/debug_pagetables.c
@@ -3,7 +3,7 @@
 #include <linux/efi.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 static int ptdump_show(struct seq_file *m, void *v)
 {
--- a/arch/x86/mm/ioremap.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/mm/ioremap.c
@@ -21,7 +21,7 @@
 #include <asm/e820/api.h>
 #include <asm/efi.h>
 #include <asm/fixmap.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/memtype.h>
--- a/arch/x86/mm/kaslr.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/mm/kaslr.c
@@ -26,7 +26,7 @@
 #include <linux/memblock.h>
 
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/setup.h>
 #include <asm/kaslr.h>
 
--- a/arch/x86/mm/mem_encrypt_boot.S~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/mm/mem_encrypt_boot.S
@@ -8,7 +8,7 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/processor-flags.h>
 #include <asm/msr-index.h>
--- a/arch/x86/mm/mmio-mod.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/mm/mmio-mod.c
@@ -17,7 +17,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/mmiotrace.h>
 #include <asm/e820/api.h> /* for ISA_START_ADDRESS */
 #include <linux/atomic.h>
--- a/arch/x86/mm/pat/memtype_interval.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/mm/pat/memtype_interval.c
@@ -15,7 +15,7 @@
 #include <linux/sched.h>
 #include <linux/gfp.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/memtype.h>
 
 #include "memtype.h"
--- a/arch/x86/mm/setup_nx.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/mm/setup_nx.c
@@ -3,7 +3,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/proto.h>
 #include <asm/cpufeature.h>
 
--- a/arch/x86/platform/efi/efi_32.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/platform/efi/efi_32.c
@@ -28,7 +28,7 @@
 #include <asm/io.h>
 #include <asm/desc.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/efi.h>
 
--- a/arch/x86/platform/olpc/olpc_ofw.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/platform/olpc/olpc_ofw.c
@@ -8,7 +8,7 @@
 #include <asm/io.h>
 #include <asm/cpufeature.h>
 #include <asm/special_insns.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/olpc_ofw.h>
 
 /* address of OFW callback interface; will be NULL if OFW isn't found */
--- a/arch/x86/power/cpu.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/power/cpu.c
@@ -14,7 +14,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/proto.h>
 #include <asm/mtrr.h>
 #include <asm/page.h>
--- a/arch/x86/power/hibernate_32.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/power/hibernate_32.c
@@ -10,7 +10,7 @@
 #include <linux/memblock.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/mmzone.h>
 #include <asm/sections.h>
 #include <asm/suspend.h>
--- a/arch/x86/power/hibernate_64.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/power/hibernate_64.c
@@ -19,7 +19,7 @@
 #include <asm/init.h>
 #include <asm/proto.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/mtrr.h>
 #include <asm/sections.h>
 #include <asm/suspend.h>
--- a/arch/x86/power/hibernate.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/power/hibernate.c
@@ -19,7 +19,7 @@
 #include <asm/init.h>
 #include <asm/proto.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/mtrr.h>
 #include <asm/sections.h>
 #include <asm/suspend.h>
--- a/arch/x86/realmode/init.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/realmode/init.c
@@ -5,7 +5,7 @@
 #include <linux/mem_encrypt.h>
 
 #include <asm/set_memory.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/realmode.h>
 #include <asm/tlbflush.h>
 #include <asm/crash.h>
--- a/arch/x86/xen/mmu_pv.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/xen/mmu_pv.c
@@ -57,7 +57,7 @@
 
 #include <trace/events/xen.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
 #include <asm/mmu_context.h>
--- a/arch/x86/xen/smp_pv.c~mm-introduce-include-linux-pgtableh
+++ a/arch/x86/xen/smp_pv.c
@@ -26,7 +26,7 @@
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cpu.h>
 
 #include <xen/interface/xen.h>
--- a/arch/xtensa/include/asm/fixmap.h~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/include/asm/fixmap.h
@@ -13,7 +13,7 @@
 #ifndef _ASM_FIXMAP_H
 #define _ASM_FIXMAP_H
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #ifdef CONFIG_HIGHMEM
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
--- a/arch/xtensa/include/asm/highmem.h~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/include/asm/highmem.h
@@ -16,7 +16,7 @@
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 #include <asm/kmap_types.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #define PKMAP_BASE		((FIXADDR_START - \
 				  (LAST_PKMAP + 1) * PAGE_SIZE) & PMD_MASK)
--- a/arch/xtensa/include/asm/initialize_mmu.h~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/include/asm/initialize_mmu.h
@@ -24,7 +24,7 @@
 #define _XTENSA_INITIALIZE_MMU_H
 
 #include <linux/init.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/vectors.h>
 
 #if XCHAL_HAVE_PTP_MMU
--- a/arch/xtensa/include/asm/mmu_context.h~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/include/asm/mmu_context.h
@@ -21,7 +21,7 @@
 
 #include <asm/vectors.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm-generic/mm_hooks.h>
--- a/arch/xtensa/include/asm/pgtable.h~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -438,6 +438,4 @@ typedef pte_t *pte_addr_t;
  */
 #define HAVE_ARCH_UNMAPPED_AREA
 
-#include <asm-generic/pgtable.h>
-
 #endif /* _XTENSA_PGTABLE_H */
--- a/arch/xtensa/kernel/entry.S~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/kernel/entry.S
@@ -22,7 +22,7 @@
 #include <asm/unistd.h>
 #include <asm/ptrace.h>
 #include <asm/current.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/signal.h>
 #include <asm/tlbflush.h>
--- a/arch/xtensa/kernel/traps.c~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/kernel/traps.c
@@ -39,7 +39,7 @@
 #include <asm/ptrace.h>
 #include <asm/timex.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/traps.h>
 #include <asm/hw_breakpoint.h>
--- a/arch/xtensa/kernel/vectors.S~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/kernel/vectors.S
@@ -47,7 +47,7 @@
 #include <asm/ptrace.h>
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/thread_info.h>
--- a/arch/xtensa/mm/cache.c~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/mm/cache.c
@@ -31,7 +31,7 @@
 #include <asm/tlbflush.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /* 
  * Note:
--- a/arch/xtensa/mm/ioremap.c~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/mm/ioremap.c
@@ -9,7 +9,7 @@
 #include <linux/vmalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 static void __iomem *xtensa_ioremap(unsigned long paddr, unsigned long size,
 				    pgprot_t prot)
--- a/arch/xtensa/mm/misc.S~mm-introduce-include-linux-pgtableh
+++ a/arch/xtensa/mm/misc.S
@@ -15,7 +15,7 @@
 
 #include <linux/linkage.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/asmmacro.h>
 #include <asm/cacheasm.h>
 #include <asm/tlbflush.h>
--- a/drivers/acpi/scan.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/acpi/scan.c
@@ -16,7 +16,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/platform_data/x86/apple.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "internal.h"
 
--- a/drivers/atm/fore200e.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/atm/fore200e.c
@@ -40,7 +40,7 @@
 #include <asm/idprom.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #endif
 
 #if defined(CONFIG_ATM_FORE200E_USE_TASKLET) /* defer interrupt work to a tasklet */
--- a/drivers/block/z2ram.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/block/z2ram.c
@@ -38,7 +38,7 @@
 
 #include <asm/setup.h>
 #include <asm/amigahw.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include <linux/zorro.h>
 
--- a/drivers/firmware/efi/arm-runtime.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/firmware/efi/arm-runtime.c
@@ -23,7 +23,7 @@
 #include <asm/efi.h>
 #include <asm/mmu.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #if defined(CONFIG_PTDUMP_DEBUGFS) && defined(CONFIG_ARM64)
 #include <asm/ptdump.h>
--- a/drivers/gpu/drm/drm_vm.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/gpu/drm/drm_vm.c
@@ -44,7 +44,7 @@
 #endif
 #include <linux/mem_encrypt.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include <drm/drm_agpsupport.h>
 #include <drm/drm_device.h>
--- a/drivers/infiniband/hw/qib/qib_file_ops.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -40,7 +40,7 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/uio.h>
--- a/drivers/macintosh/macio-adb.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/macintosh/macio-adb.c
@@ -12,7 +12,7 @@
 #include <asm/prom.h>
 #include <linux/adb.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/hydra.h>
 #include <asm/irq.h>
 #include <linux/init.h>
--- a/drivers/macintosh/mediabay.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/macintosh/mediabay.c
@@ -17,7 +17,7 @@
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <asm/prom.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
 #include <asm/pmac_feature.h>
--- a/drivers/macintosh/via-pmu.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/macintosh/via-pmu.c
@@ -52,7 +52,7 @@
 #include <linux/uaccess.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/sections.h>
 #include <asm/irq.h>
 #ifdef CONFIG_PPC_PMAC
--- a/drivers/media/pci/bt8xx/bt878.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/media/pci/bt8xx/bt878.c
@@ -15,7 +15,7 @@
 #include <linux/pci.h>
 #include <asm/io.h>
 #include <linux/ioport.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
--- a/drivers/media/pci/bt8xx/btcx-risc.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/media/pci/bt8xx/btcx-risc.c
@@ -18,7 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/videodev2.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "btcx-risc.h"
 
--- a/drivers/media/pci/bt8xx/bttv-risc.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/media/pci/bt8xx/bttv-risc.c
@@ -21,7 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <media/v4l2-ioctl.h>
 
 #include "bttvp.h"
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -27,7 +27,7 @@
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include <media/videobuf-dma-sg.h>
 
--- a/drivers/media/v4l2-core/videobuf-vmalloc.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/media/v4l2-core/videobuf-vmalloc.c
@@ -20,7 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include <media/videobuf-vmalloc.h>
 
--- a/drivers/misc/genwqe/card_utils.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/misc/genwqe/card_utils.c
@@ -27,7 +27,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "genwqe_driver.h"
 #include "card_base.h"
--- a/drivers/mtd/ubi/ubi.h~mm-introduce-include-linux-pgtableh
+++ a/drivers/mtd/ubi/ubi.h
@@ -26,7 +26,7 @@
 #include <linux/notifier.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/ubi.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "ubi-media.h"
 
--- a/drivers/net/ethernet/amd/7990.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/amd/7990.c
@@ -35,7 +35,7 @@
 
 #include <asm/io.h>
 #include <asm/dma.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #ifdef CONFIG_HP300
 #include <asm/blinken.h>
 #endif
--- a/drivers/net/ethernet/amd/hplance.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/amd/hplance.c
@@ -24,7 +24,7 @@
 #include <linux/skbuff.h>
 
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "hplance.h"
 
--- a/drivers/net/ethernet/amd/mvme147.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/amd/mvme147.c
@@ -24,7 +24,7 @@
 #include <linux/skbuff.h>
 
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/mvme147hw.h>
 
 /* We have 32K of RAM for the init block and buffers. This places
--- a/drivers/net/ethernet/amd/sun3lance.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/amd/sun3lance.c
@@ -42,7 +42,7 @@ static const char version[] =
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/dvma.h>
 #include <asm/idprom.h>
 #include <asm/machines.h>
--- a/drivers/net/ethernet/amd/sunlance.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/amd/sunlance.c
@@ -97,7 +97,7 @@ static char lancestr[] = "LANCE";
 
 #include <asm/io.h>
 #include <asm/dma.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/byteorder.h>	/* Used by the checksum routines */
 #include <asm/idprom.h>
 #include <asm/prom.h>
--- a/drivers/net/ethernet/apple/bmac.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/apple/bmac.c
@@ -28,7 +28,7 @@
 #include <asm/dbdma.h>
 #include <asm/io.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/pmac_feature.h>
 #include <asm/macio.h>
--- a/drivers/net/ethernet/apple/mace.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/apple/mace.c
@@ -22,7 +22,7 @@
 #include <asm/prom.h>
 #include <asm/dbdma.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/macio.h>
 
 #include "mace.h"
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -42,7 +42,7 @@
 #include <linux/of_net.h>
 
 #include <linux/vmalloc.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <linux/uaccess.h>
 
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
@@ -40,7 +40,7 @@
 #include <asm/mpc8260.h>
 #include <asm/cpm2.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <linux/uaccess.h>
 
--- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
@@ -33,7 +33,7 @@
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <linux/uaccess.h>
 #include <asm/mpc5xxx.h>
--- a/drivers/net/ethernet/i825xx/82596.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/i825xx/82596.c
@@ -56,7 +56,7 @@
 
 #include <asm/io.h>
 #include <asm/dma.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 
 static char version[] __initdata =
--- a/drivers/net/ethernet/korina.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/korina.c
@@ -56,7 +56,7 @@
 
 #include <asm/bootinfo.h>
 #include <asm/bitops.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
--- a/drivers/net/ethernet/marvell/pxa168_eth.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -32,7 +32,7 @@
 #include <linux/udp.h>
 #include <linux/workqueue.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 
 #define DRIVER_NAME	"pxa168-eth"
--- a/drivers/net/ethernet/natsemi/jazzsonic.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -38,7 +38,7 @@
 #include <linux/slab.h>
 
 #include <asm/bootinfo.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/jazz.h>
--- a/drivers/net/ethernet/natsemi/macsonic.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/natsemi/macsonic.c
@@ -52,7 +52,7 @@
 #include <linux/bitrev.h>
 #include <linux/slab.h>
 
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/hwtest.h>
 #include <asm/dma.h>
--- a/drivers/net/ethernet/natsemi/xtsonic.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/natsemi/xtsonic.c
@@ -37,7 +37,7 @@
 #include <linux/slab.h>
 
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/dma.h>
 
 static char xtsonic_string[] = "xtsonic";
--- a/drivers/net/ethernet/sun/sunbmac.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/sun/sunbmac.c
@@ -34,7 +34,7 @@
 #include <asm/io.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "sunbmac.h"
 
--- a/drivers/net/ethernet/sun/sunqe.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/net/ethernet/sun/sunqe.c
@@ -36,7 +36,7 @@
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/auxio.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 
 #include "sunqe.h"
--- a/drivers/scsi/53c700.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/scsi/53c700.c
@@ -118,7 +118,7 @@
 #include <linux/device.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/byteorder.h>
 
 #include <scsi/scsi.h>
--- a/drivers/scsi/arm/cumana_2.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/scsi/arm/cumana_2.c
@@ -27,7 +27,7 @@
 #include <asm/dma.h>
 #include <asm/ecard.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
--- a/drivers/scsi/arm/eesox.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/scsi/arm/eesox.c
@@ -33,7 +33,7 @@
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/ecard.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
--- a/drivers/scsi/arm/powertec.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/scsi/arm/powertec.c
@@ -18,7 +18,7 @@
 #include <asm/dma.h>
 #include <asm/ecard.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
--- a/drivers/scsi/dpt_i2o.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/scsi/dpt_i2o.c
@@ -55,7 +55,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Dri
 #include <linux/mutex.h>
 
 #include <asm/processor.h>	/* for boot_cpu_data */
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>		/* for virt_to_bus, etc. */
 
 #include <scsi/scsi.h>
--- a/drivers/scsi/mac53c94.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/scsi/mac53c94.c
@@ -22,7 +22,7 @@
 #include <linux/pci.h>
 #include <asm/dbdma.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/macio.h>
 
--- a/drivers/scsi/mesh.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/scsi/mesh.c
@@ -33,7 +33,7 @@
 #include <linux/pci.h>
 #include <asm/dbdma.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/irq.h>
 #include <asm/hydra.h>
--- a/drivers/scsi/qlogicpti.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/scsi/qlogicpti.c
@@ -37,7 +37,7 @@
 
 #include <asm/dma.h>
 #include <asm/ptrace.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/oplib.h>
 #include <asm/io.h>
 #include <asm/irq.h>
--- a/drivers/scsi/zorro_esp.c~mm-introduce-include-linux-pgtableh
+++ a/drivers/scsi/zorro_esp.c
@@ -36,7 +36,7 @@
 #include <linux/slab.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
--- a/include/asm-generic/io.h~mm-introduce-include-linux-pgtableh
+++ a/include/asm-generic/io.h
@@ -948,7 +948,7 @@ static inline void iounmap(void __iomem
 }
 #endif
 #elif defined(CONFIG_GENERIC_IOREMAP)
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 void __iomem *ioremap_prot(phys_addr_t addr, size_t size, unsigned long prot);
 void iounmap(volatile void __iomem *addr);
--- a/include/asm-generic/pgtable.h
+++ /dev/null
@@ -1,1289 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _ASM_GENERIC_PGTABLE_H
-#define _ASM_GENERIC_PGTABLE_H
-
-#include <linux/pfn.h>
-
-#ifndef __ASSEMBLY__
-#ifdef CONFIG_MMU
-
-#include <linux/mm_types.h>
-#include <linux/bug.h>
-#include <linux/errno.h>
-#include <asm-generic/pgtable_uffd.h>
-
-#if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
-	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
-#error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
-#endif
-
-/*
- * On almost all architectures and configurations, 0 can be used as the
- * upper ceiling to free_pgtables(): on many architectures it has the same
- * effect as using TASK_SIZE.  However, there is one configuration which
- * must impose a more careful limit, to avoid freeing kernel pgtables.
- */
-#ifndef USER_PGTABLES_CEILING
-#define USER_PGTABLES_CEILING	0UL
-#endif
-
-#ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-extern int ptep_set_access_flags(struct vm_area_struct *vma,
-				 unsigned long address, pte_t *ptep,
-				 pte_t entry, int dirty);
-#endif
-
-#ifndef __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern int pmdp_set_access_flags(struct vm_area_struct *vma,
-				 unsigned long address, pmd_t *pmdp,
-				 pmd_t entry, int dirty);
-extern int pudp_set_access_flags(struct vm_area_struct *vma,
-				 unsigned long address, pud_t *pudp,
-				 pud_t entry, int dirty);
-#else
-static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
-					unsigned long address, pmd_t *pmdp,
-					pmd_t entry, int dirty)
-{
-	BUILD_BUG();
-	return 0;
-}
-static inline int pudp_set_access_flags(struct vm_area_struct *vma,
-					unsigned long address, pud_t *pudp,
-					pud_t entry, int dirty)
-{
-	BUILD_BUG();
-	return 0;
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-#endif
-
-#ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pte_t *ptep)
-{
-	pte_t pte = *ptep;
-	int r = 1;
-	if (!pte_young(pte))
-		r = 0;
-	else
-		set_pte_at(vma->vm_mm, address, ptep, pte_mkold(pte));
-	return r;
-}
-#endif
-
-#ifndef __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pmd_t *pmdp)
-{
-	pmd_t pmd = *pmdp;
-	int r = 1;
-	if (!pmd_young(pmd))
-		r = 0;
-	else
-		set_pmd_at(vma->vm_mm, address, pmdp, pmd_mkold(pmd));
-	return r;
-}
-#else
-static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
-					    unsigned long address,
-					    pmd_t *pmdp)
-{
-	BUILD_BUG();
-	return 0;
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-#endif
-
-#ifndef __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-int ptep_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pte_t *ptep);
-#endif
-
-#ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
-#else
-/*
- * Despite relevant to THP only, this API is called from generic rmap code
- * under PageTransHuge(), hence needs a dummy implementation for !THP
- */
-static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long address, pmd_t *pmdp)
-{
-	BUILD_BUG();
-	return 0;
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-#endif
-
-#ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
-static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
-				       unsigned long address,
-				       pte_t *ptep)
-{
-	pte_t pte = *ptep;
-	pte_clear(mm, address, ptep);
-	return pte;
-}
-#endif
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
-static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
-					    unsigned long address,
-					    pmd_t *pmdp)
-{
-	pmd_t pmd = *pmdp;
-	pmd_clear(pmdp);
-	return pmd;
-}
-#endif /* __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR */
-#ifndef __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
-static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
-					    unsigned long address,
-					    pud_t *pudp)
-{
-	pud_t pud = *pudp;
-
-	pud_clear(pudp);
-	return pud;
-}
-#endif /* __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR */
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR_FULL
-static inline pmd_t pmdp_huge_get_and_clear_full(struct vm_area_struct *vma,
-					    unsigned long address, pmd_t *pmdp,
-					    int full)
-{
-	return pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
-}
-#endif
-
-#ifndef __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR_FULL
-static inline pud_t pudp_huge_get_and_clear_full(struct mm_struct *mm,
-					    unsigned long address, pud_t *pudp,
-					    int full)
-{
-	return pudp_huge_get_and_clear(mm, address, pudp);
-}
-#endif
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
-#ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
-static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
-					    unsigned long address, pte_t *ptep,
-					    int full)
-{
-	pte_t pte;
-	pte = ptep_get_and_clear(mm, address, ptep);
-	return pte;
-}
-#endif
-
-/*
- * Some architectures may be able to avoid expensive synchronization
- * primitives when modifications are made to PTE's which are already
- * not present, or in the process of an address space destruction.
- */
-#ifndef __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-static inline void pte_clear_not_present_full(struct mm_struct *mm,
-					      unsigned long address,
-					      pte_t *ptep,
-					      int full)
-{
-	pte_clear(mm, address, ptep);
-}
-#endif
-
-#ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
-extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
-			      unsigned long address,
-			      pte_t *ptep);
-#endif
-
-#ifndef __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
-extern pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma,
-			      unsigned long address,
-			      pmd_t *pmdp);
-extern pud_t pudp_huge_clear_flush(struct vm_area_struct *vma,
-			      unsigned long address,
-			      pud_t *pudp);
-#endif
-
-#ifndef __HAVE_ARCH_PTEP_SET_WRPROTECT
-struct mm_struct;
-static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long address, pte_t *ptep)
-{
-	pte_t old_pte = *ptep;
-	set_pte_at(mm, address, ptep, pte_wrprotect(old_pte));
-}
-#endif
-
-#ifndef pte_savedwrite
-#define pte_savedwrite pte_write
-#endif
-
-#ifndef pte_mk_savedwrite
-#define pte_mk_savedwrite pte_mkwrite
-#endif
-
-#ifndef pte_clear_savedwrite
-#define pte_clear_savedwrite pte_wrprotect
-#endif
-
-#ifndef pmd_savedwrite
-#define pmd_savedwrite pmd_write
-#endif
-
-#ifndef pmd_mk_savedwrite
-#define pmd_mk_savedwrite pmd_mkwrite
-#endif
-
-#ifndef pmd_clear_savedwrite
-#define pmd_clear_savedwrite pmd_wrprotect
-#endif
-
-#ifndef __HAVE_ARCH_PMDP_SET_WRPROTECT
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline void pmdp_set_wrprotect(struct mm_struct *mm,
-				      unsigned long address, pmd_t *pmdp)
-{
-	pmd_t old_pmd = *pmdp;
-	set_pmd_at(mm, address, pmdp, pmd_wrprotect(old_pmd));
-}
-#else
-static inline void pmdp_set_wrprotect(struct mm_struct *mm,
-				      unsigned long address, pmd_t *pmdp)
-{
-	BUILD_BUG();
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-#endif
-#ifndef __HAVE_ARCH_PUDP_SET_WRPROTECT
-#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static inline void pudp_set_wrprotect(struct mm_struct *mm,
-				      unsigned long address, pud_t *pudp)
-{
-	pud_t old_pud = *pudp;
-
-	set_pud_at(mm, address, pudp, pud_wrprotect(old_pud));
-}
-#else
-static inline void pudp_set_wrprotect(struct mm_struct *mm,
-				      unsigned long address, pud_t *pudp)
-{
-	BUILD_BUG();
-}
-#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
-#endif
-
-#ifndef pmdp_collapse_flush
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
-				 unsigned long address, pmd_t *pmdp);
-#else
-static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
-					unsigned long address,
-					pmd_t *pmdp)
-{
-	BUILD_BUG();
-	return *pmdp;
-}
-#define pmdp_collapse_flush pmdp_collapse_flush
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-#endif
-
-#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
-extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
-				       pgtable_t pgtable);
-#endif
-
-#ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
-extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
-#endif
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/*
- * This is an implementation of pmdp_establish() that is only suitable for an
- * architecture that doesn't have hardware dirty/accessed bits. In this case we
- * can't race with CPU which sets these bits and non-atomic aproach is fine.
- */
-static inline pmd_t generic_pmdp_establish(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmdp, pmd_t pmd)
-{
-	pmd_t old_pmd = *pmdp;
-	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
-	return old_pmd;
-}
-#endif
-
-#ifndef __HAVE_ARCH_PMDP_INVALIDATE
-extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
-			    pmd_t *pmdp);
-#endif
-
-#ifndef __HAVE_ARCH_PTE_SAME
-static inline int pte_same(pte_t pte_a, pte_t pte_b)
-{
-	return pte_val(pte_a) == pte_val(pte_b);
-}
-#endif
-
-#ifndef __HAVE_ARCH_PTE_UNUSED
-/*
- * Some architectures provide facilities to virtualization guests
- * so that they can flag allocated pages as unused. This allows the
- * host to transparently reclaim unused pages. This function returns
- * whether the pte's page is unused.
- */
-static inline int pte_unused(pte_t pte)
-{
-	return 0;
-}
-#endif
-
-#ifndef pte_access_permitted
-#define pte_access_permitted(pte, write) \
-	(pte_present(pte) && (!(write) || pte_write(pte)))
-#endif
-
-#ifndef pmd_access_permitted
-#define pmd_access_permitted(pmd, write) \
-	(pmd_present(pmd) && (!(write) || pmd_write(pmd)))
-#endif
-
-#ifndef pud_access_permitted
-#define pud_access_permitted(pud, write) \
-	(pud_present(pud) && (!(write) || pud_write(pud)))
-#endif
-
-#ifndef p4d_access_permitted
-#define p4d_access_permitted(p4d, write) \
-	(p4d_present(p4d) && (!(write) || p4d_write(p4d)))
-#endif
-
-#ifndef pgd_access_permitted
-#define pgd_access_permitted(pgd, write) \
-	(pgd_present(pgd) && (!(write) || pgd_write(pgd)))
-#endif
-
-#ifndef __HAVE_ARCH_PMD_SAME
-static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
-{
-	return pmd_val(pmd_a) == pmd_val(pmd_b);
-}
-
-static inline int pud_same(pud_t pud_a, pud_t pud_b)
-{
-	return pud_val(pud_a) == pud_val(pud_b);
-}
-#endif
-
-#ifndef __HAVE_ARCH_P4D_SAME
-static inline int p4d_same(p4d_t p4d_a, p4d_t p4d_b)
-{
-	return p4d_val(p4d_a) == p4d_val(p4d_b);
-}
-#endif
-
-#ifndef __HAVE_ARCH_PGD_SAME
-static inline int pgd_same(pgd_t pgd_a, pgd_t pgd_b)
-{
-	return pgd_val(pgd_a) == pgd_val(pgd_b);
-}
-#endif
-
-/*
- * Use set_p*_safe(), and elide TLB flushing, when confident that *no*
- * TLB flush will be required as a result of the "set". For example, use
- * in scenarios where it is known ahead of time that the routine is
- * setting non-present entries, or re-setting an existing entry to the
- * same value. Otherwise, use the typical "set" helpers and flush the
- * TLB.
- */
-#define set_pte_safe(ptep, pte) \
-({ \
-	WARN_ON_ONCE(pte_present(*ptep) && !pte_same(*ptep, pte)); \
-	set_pte(ptep, pte); \
-})
-
-#define set_pmd_safe(pmdp, pmd) \
-({ \
-	WARN_ON_ONCE(pmd_present(*pmdp) && !pmd_same(*pmdp, pmd)); \
-	set_pmd(pmdp, pmd); \
-})
-
-#define set_pud_safe(pudp, pud) \
-({ \
-	WARN_ON_ONCE(pud_present(*pudp) && !pud_same(*pudp, pud)); \
-	set_pud(pudp, pud); \
-})
-
-#define set_p4d_safe(p4dp, p4d) \
-({ \
-	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
-	set_p4d(p4dp, p4d); \
-})
-
-#define set_pgd_safe(pgdp, pgd) \
-({ \
-	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
-	set_pgd(pgdp, pgd); \
-})
-
-#ifndef __HAVE_ARCH_DO_SWAP_PAGE
-/*
- * Some architectures support metadata associated with a page. When a
- * page is being swapped out, this metadata must be saved so it can be
- * restored when the page is swapped back in. SPARC M7 and newer
- * processors support an ADI (Application Data Integrity) tag for the
- * page as metadata for the page. arch_do_swap_page() can restore this
- * metadata when a page is swapped back in.
- */
-static inline void arch_do_swap_page(struct mm_struct *mm,
-				     struct vm_area_struct *vma,
-				     unsigned long addr,
-				     pte_t pte, pte_t oldpte)
-{
-
-}
-#endif
-
-#ifndef __HAVE_ARCH_UNMAP_ONE
-/*
- * Some architectures support metadata associated with a page. When a
- * page is being swapped out, this metadata must be saved so it can be
- * restored when the page is swapped back in. SPARC M7 and newer
- * processors support an ADI (Application Data Integrity) tag for the
- * page as metadata for the page. arch_unmap_one() can save this
- * metadata on a swap-out of a page.
- */
-static inline int arch_unmap_one(struct mm_struct *mm,
-				  struct vm_area_struct *vma,
-				  unsigned long addr,
-				  pte_t orig_pte)
-{
-	return 0;
-}
-#endif
-
-#ifndef __HAVE_ARCH_PGD_OFFSET_GATE
-#define pgd_offset_gate(mm, addr)	pgd_offset(mm, addr)
-#endif
-
-#ifndef __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, prot, old_addr, new_addr)	(pte)
-#endif
-
-#ifndef pte_accessible
-# define pte_accessible(mm, pte)	((void)(pte), 1)
-#endif
-
-#ifndef flush_tlb_fix_spurious_fault
-#define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
-#endif
-
-#ifndef pgprot_nx
-#define pgprot_nx(prot)	(prot)
-#endif
-
-#ifndef pgprot_noncached
-#define pgprot_noncached(prot)	(prot)
-#endif
-
-#ifndef pgprot_writecombine
-#define pgprot_writecombine pgprot_noncached
-#endif
-
-#ifndef pgprot_writethrough
-#define pgprot_writethrough pgprot_noncached
-#endif
-
-#ifndef pgprot_device
-#define pgprot_device pgprot_noncached
-#endif
-
-#ifndef pgprot_modify
-#define pgprot_modify pgprot_modify
-static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
-{
-	if (pgprot_val(oldprot) == pgprot_val(pgprot_noncached(oldprot)))
-		newprot = pgprot_noncached(newprot);
-	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
-		newprot = pgprot_writecombine(newprot);
-	if (pgprot_val(oldprot) == pgprot_val(pgprot_device(oldprot)))
-		newprot = pgprot_device(newprot);
-	return newprot;
-}
-#endif
-
-/*
- * When walking page tables, get the address of the next boundary,
- * or the end address of the range if that comes earlier.  Although no
- * vma end wraps to 0, rounded up __boundary may wrap to 0 throughout.
- */
-
-#define pgd_addr_end(addr, end)						\
-({	unsigned long __boundary = ((addr) + PGDIR_SIZE) & PGDIR_MASK;	\
-	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
-})
-
-#ifndef p4d_addr_end
-#define p4d_addr_end(addr, end)						\
-({	unsigned long __boundary = ((addr) + P4D_SIZE) & P4D_MASK;	\
-	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
-})
-#endif
-
-#ifndef pud_addr_end
-#define pud_addr_end(addr, end)						\
-({	unsigned long __boundary = ((addr) + PUD_SIZE) & PUD_MASK;	\
-	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
-})
-#endif
-
-#ifndef pmd_addr_end
-#define pmd_addr_end(addr, end)						\
-({	unsigned long __boundary = ((addr) + PMD_SIZE) & PMD_MASK;	\
-	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
-})
-#endif
-
-/*
- * When walking page tables, we usually want to skip any p?d_none entries;
- * and any p?d_bad entries - reporting the error before resetting to none.
- * Do the tests inline, but report and clear the bad entry in mm/memory.c.
- */
-void pgd_clear_bad(pgd_t *);
-
-#ifndef __PAGETABLE_P4D_FOLDED
-void p4d_clear_bad(p4d_t *);
-#else
-#define p4d_clear_bad(p4d)        do { } while (0)
-#endif
-
-#ifndef __PAGETABLE_PUD_FOLDED
-void pud_clear_bad(pud_t *);
-#else
-#define pud_clear_bad(p4d)        do { } while (0)
-#endif
-
-void pmd_clear_bad(pmd_t *);
-
-static inline int pgd_none_or_clear_bad(pgd_t *pgd)
-{
-	if (pgd_none(*pgd))
-		return 1;
-	if (unlikely(pgd_bad(*pgd))) {
-		pgd_clear_bad(pgd);
-		return 1;
-	}
-	return 0;
-}
-
-static inline int p4d_none_or_clear_bad(p4d_t *p4d)
-{
-	if (p4d_none(*p4d))
-		return 1;
-	if (unlikely(p4d_bad(*p4d))) {
-		p4d_clear_bad(p4d);
-		return 1;
-	}
-	return 0;
-}
-
-static inline int pud_none_or_clear_bad(pud_t *pud)
-{
-	if (pud_none(*pud))
-		return 1;
-	if (unlikely(pud_bad(*pud))) {
-		pud_clear_bad(pud);
-		return 1;
-	}
-	return 0;
-}
-
-static inline int pmd_none_or_clear_bad(pmd_t *pmd)
-{
-	if (pmd_none(*pmd))
-		return 1;
-	if (unlikely(pmd_bad(*pmd))) {
-		pmd_clear_bad(pmd);
-		return 1;
-	}
-	return 0;
-}
-
-static inline pte_t __ptep_modify_prot_start(struct vm_area_struct *vma,
-					     unsigned long addr,
-					     pte_t *ptep)
-{
-	/*
-	 * Get the current pte state, but zero it out to make it
-	 * non-present, preventing the hardware from asynchronously
-	 * updating it.
-	 */
-	return ptep_get_and_clear(vma->vm_mm, addr, ptep);
-}
-
-static inline void __ptep_modify_prot_commit(struct vm_area_struct *vma,
-					     unsigned long addr,
-					     pte_t *ptep, pte_t pte)
-{
-	/*
-	 * The pte is non-present, so there's no hardware state to
-	 * preserve.
-	 */
-	set_pte_at(vma->vm_mm, addr, ptep, pte);
-}
-
-#ifndef __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
-/*
- * Start a pte protection read-modify-write transaction, which
- * protects against asynchronous hardware modifications to the pte.
- * The intention is not to prevent the hardware from making pte
- * updates, but to prevent any updates it may make from being lost.
- *
- * This does not protect against other software modifications of the
- * pte; the appropriate pte lock must be held over the transation.
- *
- * Note that this interface is intended to be batchable, meaning that
- * ptep_modify_prot_commit may not actually update the pte, but merely
- * queue the update to be done at some later time.  The update must be
- * actually committed before the pte lock is released, however.
- */
-static inline pte_t ptep_modify_prot_start(struct vm_area_struct *vma,
-					   unsigned long addr,
-					   pte_t *ptep)
-{
-	return __ptep_modify_prot_start(vma, addr, ptep);
-}
-
-/*
- * Commit an update to a pte, leaving any hardware-controlled bits in
- * the PTE unmodified.
- */
-static inline void ptep_modify_prot_commit(struct vm_area_struct *vma,
-					   unsigned long addr,
-					   pte_t *ptep, pte_t old_pte, pte_t pte)
-{
-	__ptep_modify_prot_commit(vma, addr, ptep, pte);
-}
-#endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
-#endif /* CONFIG_MMU */
-
-/*
- * No-op macros that just return the current protection value. Defined here
- * because these macros can be used used even if CONFIG_MMU is not defined.
- */
-#ifndef pgprot_encrypted
-#define pgprot_encrypted(prot)	(prot)
-#endif
-
-#ifndef pgprot_decrypted
-#define pgprot_decrypted(prot)	(prot)
-#endif
-
-/*
- * A facility to provide lazy MMU batching.  This allows PTE updates and
- * page invalidations to be delayed until a call to leave lazy MMU mode
- * is issued.  Some architectures may benefit from doing this, and it is
- * beneficial for both shadow and direct mode hypervisors, which may batch
- * the PTE updates which happen during this window.  Note that using this
- * interface requires that read hazards be removed from the code.  A read
- * hazard could result in the direct mode hypervisor case, since the actual
- * write to the page tables may not yet have taken place, so reads though
- * a raw PTE pointer after it has been modified are not guaranteed to be
- * up to date.  This mode can only be entered and left under the protection of
- * the page table locks for all page tables which may be modified.  In the UP
- * case, this is required so that preemption is disabled, and in the SMP case,
- * it must synchronize the delayed page table writes properly on other CPUs.
- */
-#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
-#endif
-
-/*
- * A facility to provide batching of the reload of page tables and
- * other process state with the actual context switch code for
- * paravirtualized guests.  By convention, only one of the batched
- * update (lazy) modes (CPU, MMU) should be active at any given time,
- * entry should never be nested, and entry and exits should always be
- * paired.  This is for sanity of maintaining and reasoning about the
- * kernel code.  In this case, the exit (end of the context switch) is
- * in architecture-specific code, and so doesn't need a generic
- * definition.
- */
-#ifndef __HAVE_ARCH_START_CONTEXT_SWITCH
-#define arch_start_context_switch(prev)	do {} while (0)
-#endif
-
-#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
-#ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
-static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline int pmd_swp_soft_dirty(pmd_t pmd)
-{
-	return 0;
-}
-
-static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-#endif
-#else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
-static inline int pte_soft_dirty(pte_t pte)
-{
-	return 0;
-}
-
-static inline int pmd_soft_dirty(pmd_t pmd)
-{
-	return 0;
-}
-
-static inline pte_t pte_mksoft_dirty(pte_t pte)
-{
-	return pte;
-}
-
-static inline pmd_t pmd_mksoft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline pte_t pte_clear_soft_dirty(pte_t pte)
-{
-	return pte;
-}
-
-static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
-{
-	return pte;
-}
-
-static inline int pte_swp_soft_dirty(pte_t pte)
-{
-	return 0;
-}
-
-static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
-{
-	return pte;
-}
-
-static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-
-static inline int pmd_swp_soft_dirty(pmd_t pmd)
-{
-	return 0;
-}
-
-static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
-{
-	return pmd;
-}
-#endif
-
-#ifndef __HAVE_PFNMAP_TRACKING
-/*
- * Interfaces that can be used by architecture code to keep track of
- * memory type of pfn mappings specified by the remap_pfn_range,
- * vmf_insert_pfn.
- */
-
-/*
- * track_pfn_remap is called when a _new_ pfn mapping is being established
- * by remap_pfn_range() for physical range indicated by pfn and size.
- */
-static inline int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
-				  unsigned long pfn, unsigned long addr,
-				  unsigned long size)
-{
-	return 0;
-}
-
-/*
- * track_pfn_insert is called when a _new_ single pfn is established
- * by vmf_insert_pfn().
- */
-static inline void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-				    pfn_t pfn)
-{
-}
-
-/*
- * track_pfn_copy is called when vma that is covering the pfnmap gets
- * copied through copy_page_range().
- */
-static inline int track_pfn_copy(struct vm_area_struct *vma)
-{
-	return 0;
-}
-
-/*
- * untrack_pfn is called while unmapping a pfnmap for a region.
- * untrack can be called for a specific region indicated by pfn and size or
- * can be for the entire vma (in which case pfn, size are zero).
- */
-static inline void untrack_pfn(struct vm_area_struct *vma,
-			       unsigned long pfn, unsigned long size)
-{
-}
-
-/*
- * untrack_pfn_moved is called while mremapping a pfnmap for a new region.
- */
-static inline void untrack_pfn_moved(struct vm_area_struct *vma)
-{
-}
-#else
-extern int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
-			   unsigned long pfn, unsigned long addr,
-			   unsigned long size);
-extern void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-			     pfn_t pfn);
-extern int track_pfn_copy(struct vm_area_struct *vma);
-extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
-			unsigned long size);
-extern void untrack_pfn_moved(struct vm_area_struct *vma);
-#endif
-
-#ifdef __HAVE_COLOR_ZERO_PAGE
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	extern unsigned long zero_pfn;
-	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
-	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
-}
-
-#define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
-
-#else
-static inline int is_zero_pfn(unsigned long pfn)
-{
-	extern unsigned long zero_pfn;
-	return pfn == zero_pfn;
-}
-
-static inline unsigned long my_zero_pfn(unsigned long addr)
-{
-	extern unsigned long zero_pfn;
-	return zero_pfn;
-}
-#endif
-
-#ifdef CONFIG_MMU
-
-#ifndef CONFIG_TRANSPARENT_HUGEPAGE
-static inline int pmd_trans_huge(pmd_t pmd)
-{
-	return 0;
-}
-#ifndef pmd_write
-static inline int pmd_write(pmd_t pmd)
-{
-	BUG();
-	return 0;
-}
-#endif /* pmd_write */
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
-#ifndef pud_write
-static inline int pud_write(pud_t pud)
-{
-	BUG();
-	return 0;
-}
-#endif /* pud_write */
-
-#if !defined(CONFIG_ARCH_HAS_PTE_DEVMAP) || !defined(CONFIG_TRANSPARENT_HUGEPAGE)
-static inline int pmd_devmap(pmd_t pmd)
-{
-	return 0;
-}
-static inline int pud_devmap(pud_t pud)
-{
-	return 0;
-}
-static inline int pgd_devmap(pgd_t pgd)
-{
-	return 0;
-}
-#endif
-
-#if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
-	(defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
-	 !defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
-static inline int pud_trans_huge(pud_t pud)
-{
-	return 0;
-}
-#endif
-
-/* See pmd_none_or_trans_huge_or_clear_bad for discussion. */
-static inline int pud_none_or_trans_huge_or_dev_or_clear_bad(pud_t *pud)
-{
-	pud_t pudval = READ_ONCE(*pud);
-
-	if (pud_none(pudval) || pud_trans_huge(pudval) || pud_devmap(pudval))
-		return 1;
-	if (unlikely(pud_bad(pudval))) {
-		pud_clear_bad(pud);
-		return 1;
-	}
-	return 0;
-}
-
-/* See pmd_trans_unstable for discussion. */
-static inline int pud_trans_unstable(pud_t *pud)
-{
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
-	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	return pud_none_or_trans_huge_or_dev_or_clear_bad(pud);
-#else
-	return 0;
-#endif
-}
-
-#ifndef pmd_read_atomic
-static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
-{
-	/*
-	 * Depend on compiler for an atomic pmd read. NOTE: this is
-	 * only going to work, if the pmdval_t isn't larger than
-	 * an unsigned long.
-	 */
-	return *pmdp;
-}
-#endif
-
-#ifndef arch_needs_pgtable_deposit
-#define arch_needs_pgtable_deposit() (false)
-#endif
-/*
- * This function is meant to be used by sites walking pagetables with
- * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
- * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
- * into a null pmd and the transhuge page fault can convert a null pmd
- * into an hugepmd or into a regular pmd (if the hugepage allocation
- * fails). While holding the mmap_sem in read mode the pmd becomes
- * stable and stops changing under us only if it's not null and not a
- * transhuge pmd. When those races occurs and this function makes a
- * difference vs the standard pmd_none_or_clear_bad, the result is
- * undefined so behaving like if the pmd was none is safe (because it
- * can return none anyway). The compiler level barrier() is critically
- * important to compute the two checks atomically on the same pmdval.
- *
- * For 32bit kernels with a 64bit large pmd_t this automatically takes
- * care of reading the pmd atomically to avoid SMP race conditions
- * against pmd_populate() when the mmap_sem is hold for reading by the
- * caller (a special atomic read not done by "gcc" as in the generic
- * version above, is also needed when THP is disabled because the page
- * fault can populate the pmd from under us).
- */
-static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
-{
-	pmd_t pmdval = pmd_read_atomic(pmd);
-	/*
-	 * The barrier will stabilize the pmdval in a register or on
-	 * the stack so that it will stop changing under the code.
-	 *
-	 * When CONFIG_TRANSPARENT_HUGEPAGE=y on x86 32bit PAE,
-	 * pmd_read_atomic is allowed to return a not atomic pmdval
-	 * (for example pointing to an hugepage that has never been
-	 * mapped in the pmd). The below checks will only care about
-	 * the low part of the pmd with 32bit PAE x86 anyway, with the
-	 * exception of pmd_none(). So the important thing is that if
-	 * the low part of the pmd is found null, the high part will
-	 * be also null or the pmd_none() check below would be
-	 * confused.
-	 */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	barrier();
-#endif
-	/*
-	 * !pmd_present() checks for pmd migration entries
-	 *
-	 * The complete check uses is_pmd_migration_entry() in linux/swapops.h
-	 * But using that requires moving current function and pmd_trans_unstable()
-	 * to linux/swapops.h to resovle dependency, which is too much code move.
-	 *
-	 * !pmd_present() is equivalent to is_pmd_migration_entry() currently,
-	 * because !pmd_present() pages can only be under migration not swapped
-	 * out.
-	 *
-	 * pmd_none() is preseved for future condition checks on pmd migration
-	 * entries and not confusing with this function name, although it is
-	 * redundant with !pmd_present().
-	 */
-	if (pmd_none(pmdval) || pmd_trans_huge(pmdval) ||
-		(IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION) && !pmd_present(pmdval)))
-		return 1;
-	if (unlikely(pmd_bad(pmdval))) {
-		pmd_clear_bad(pmd);
-		return 1;
-	}
-	return 0;
-}
-
-/*
- * This is a noop if Transparent Hugepage Support is not built into
- * the kernel. Otherwise it is equivalent to
- * pmd_none_or_trans_huge_or_clear_bad(), and shall only be called in
- * places that already verified the pmd is not none and they want to
- * walk ptes while holding the mmap sem in read mode (write mode don't
- * need this). If THP is not enabled, the pmd can't go away under the
- * code even if MADV_DONTNEED runs, but if THP is enabled we need to
- * run a pmd_trans_unstable before walking the ptes after
- * split_huge_pmd returns (because it may have run when the pmd become
- * null, but then a page fault can map in a THP and not a regular page).
- */
-static inline int pmd_trans_unstable(pmd_t *pmd)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	return pmd_none_or_trans_huge_or_clear_bad(pmd);
-#else
-	return 0;
-#endif
-}
-
-#ifndef CONFIG_NUMA_BALANCING
-/*
- * Technically a PTE can be PROTNONE even when not doing NUMA balancing but
- * the only case the kernel cares is for NUMA balancing and is only ever set
- * when the VMA is accessible. For PROT_NONE VMAs, the PTEs are not marked
- * _PAGE_PROTNONE so by by default, implement the helper as "always no". It
- * is the responsibility of the caller to distinguish between PROT_NONE
- * protections and NUMA hinting fault protections.
- */
-static inline int pte_protnone(pte_t pte)
-{
-	return 0;
-}
-
-static inline int pmd_protnone(pmd_t pmd)
-{
-	return 0;
-}
-#endif /* CONFIG_NUMA_BALANCING */
-
-#endif /* CONFIG_MMU */
-
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-
-#ifndef __PAGETABLE_P4D_FOLDED
-int p4d_set_huge(p4d_t *p4d, phys_addr_t addr, pgprot_t prot);
-int p4d_clear_huge(p4d_t *p4d);
-#else
-static inline int p4d_set_huge(p4d_t *p4d, phys_addr_t addr, pgprot_t prot)
-{
-	return 0;
-}
-static inline int p4d_clear_huge(p4d_t *p4d)
-{
-	return 0;
-}
-#endif /* !__PAGETABLE_P4D_FOLDED */
-
-int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
-int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
-int pud_clear_huge(pud_t *pud);
-int pmd_clear_huge(pmd_t *pmd);
-int p4d_free_pud_page(p4d_t *p4d, unsigned long addr);
-int pud_free_pmd_page(pud_t *pud, unsigned long addr);
-int pmd_free_pte_page(pmd_t *pmd, unsigned long addr);
-#else	/* !CONFIG_HAVE_ARCH_HUGE_VMAP */
-static inline int p4d_set_huge(p4d_t *p4d, phys_addr_t addr, pgprot_t prot)
-{
-	return 0;
-}
-static inline int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
-{
-	return 0;
-}
-static inline int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
-{
-	return 0;
-}
-static inline int p4d_clear_huge(p4d_t *p4d)
-{
-	return 0;
-}
-static inline int pud_clear_huge(pud_t *pud)
-{
-	return 0;
-}
-static inline int pmd_clear_huge(pmd_t *pmd)
-{
-	return 0;
-}
-static inline int p4d_free_pud_page(p4d_t *p4d, unsigned long addr)
-{
-	return 0;
-}
-static inline int pud_free_pmd_page(pud_t *pud, unsigned long addr)
-{
-	return 0;
-}
-static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
-{
-	return 0;
-}
-#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
-
-#ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/*
- * ARCHes with special requirements for evicting THP backing TLB entries can
- * implement this. Otherwise also, it can help optimize normal TLB flush in
- * THP regime. stock flush_tlb_range() typically has optimization to nuke the
- * entire TLB TLB if flush span is greater than a threshold, which will
- * likely be true for a single huge page. Thus a single thp flush will
- * invalidate the entire TLB which is not desitable.
- * e.g. see arch/arc: flush_pmd_tlb_range
- */
-#define flush_pmd_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
-#define flush_pud_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
-#else
-#define flush_pmd_tlb_range(vma, addr, end)	BUILD_BUG()
-#define flush_pud_tlb_range(vma, addr, end)	BUILD_BUG()
-#endif
-#endif
-
-struct file;
-int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
-			unsigned long size, pgprot_t *vma_prot);
-
-#ifndef CONFIG_X86_ESPFIX64
-static inline void init_espfix_bsp(void) { }
-#endif
-
-extern void __init pgtable_cache_init(void);
-
-#ifndef __HAVE_ARCH_PFN_MODIFY_ALLOWED
-static inline bool pfn_modify_allowed(unsigned long pfn, pgprot_t prot)
-{
-	return true;
-}
-
-static inline bool arch_has_pfn_modify_check(void)
-{
-	return false;
-}
-#endif /* !_HAVE_ARCH_PFN_MODIFY_ALLOWED */
-
-/*
- * Architecture PAGE_KERNEL_* fallbacks
- *
- * Some architectures don't define certain PAGE_KERNEL_* flags. This is either
- * because they really don't support them, or the port needs to be updated to
- * reflect the required functionality. Below are a set of relatively safe
- * fallbacks, as best effort, which we can count on in lieu of the architectures
- * not defining them on their own yet.
- */
-
-#ifndef PAGE_KERNEL_RO
-# define PAGE_KERNEL_RO PAGE_KERNEL
-#endif
-
-#ifndef PAGE_KERNEL_EXEC
-# define PAGE_KERNEL_EXEC PAGE_KERNEL
-#endif
-
-/*
- * Page Table Modification bits for pgtbl_mod_mask.
- *
- * These are used by the p?d_alloc_track*() set of functions an in the generic
- * vmalloc/ioremap code to track at which page-table levels entries have been
- * modified. Based on that the code can better decide when vmalloc and ioremap
- * mapping changes need to be synchronized to other page-tables in the system.
- */
-#define		__PGTBL_PGD_MODIFIED	0
-#define		__PGTBL_P4D_MODIFIED	1
-#define		__PGTBL_PUD_MODIFIED	2
-#define		__PGTBL_PMD_MODIFIED	3
-#define		__PGTBL_PTE_MODIFIED	4
-
-#define		PGTBL_PGD_MODIFIED	BIT(__PGTBL_PGD_MODIFIED)
-#define		PGTBL_P4D_MODIFIED	BIT(__PGTBL_P4D_MODIFIED)
-#define		PGTBL_PUD_MODIFIED	BIT(__PGTBL_PUD_MODIFIED)
-#define		PGTBL_PMD_MODIFIED	BIT(__PGTBL_PMD_MODIFIED)
-#define		PGTBL_PTE_MODIFIED	BIT(__PGTBL_PTE_MODIFIED)
-
-/* Page-Table Modification Mask */
-typedef unsigned int pgtbl_mod_mask;
-
-#endif /* !__ASSEMBLY__ */
-
-#ifndef io_remap_pfn_range
-#define io_remap_pfn_range remap_pfn_range
-#endif
-
-#ifndef has_transparent_hugepage
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define has_transparent_hugepage() 1
-#else
-#define has_transparent_hugepage() 0
-#endif
-#endif
-
-/*
- * On some architectures it depends on the mm if the p4d/pud or pmd
- * layer of the page table hierarchy is folded or not.
- */
-#ifndef mm_p4d_folded
-#define mm_p4d_folded(mm)	__is_defined(__PAGETABLE_P4D_FOLDED)
-#endif
-
-#ifndef mm_pud_folded
-#define mm_pud_folded(mm)	__is_defined(__PAGETABLE_PUD_FOLDED)
-#endif
-
-#ifndef mm_pmd_folded
-#define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
-#endif
-
-/*
- * p?d_leaf() - true if this entry is a final mapping to a physical address.
- * This differs from p?d_huge() by the fact that they are always available (if
- * the architecture supports large pages at the appropriate level) even
- * if CONFIG_HUGETLB_PAGE is not defined.
- * Only meaningful when called on a valid entry.
- */
-#ifndef pgd_leaf
-#define pgd_leaf(x)	0
-#endif
-#ifndef p4d_leaf
-#define p4d_leaf(x)	0
-#endif
-#ifndef pud_leaf
-#define pud_leaf(x)	0
-#endif
-#ifndef pmd_leaf
-#define pmd_leaf(x)	0
-#endif
-
-#endif /* _ASM_GENERIC_PGTABLE_H */
--- a/include/linux/crash_dump.h~mm-introduce-include-linux-pgtableh
+++ a/include/linux/crash_dump.h
@@ -7,7 +7,7 @@
 #include <linux/elf.h>
 #include <uapi/linux/vmcore.h>
 
-#include <asm/pgtable.h> /* for pgprot_t */
+#include <linux/pgtable.h> /* for pgprot_t */
 
 #ifdef CONFIG_CRASH_DUMP
 #define ELFCORE_ADDR_MAX	(-1ULL)
--- a/include/linux/dma-noncoherent.h~mm-introduce-include-linux-pgtableh
+++ a/include/linux/dma-noncoherent.h
@@ -3,7 +3,7 @@
 #define _LINUX_DMA_NONCOHERENT_H 1
 
 #include <linux/dma-mapping.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #ifdef CONFIG_ARCH_HAS_DMA_COHERENCE_H
 #include <asm/dma-coherence.h>
--- a/include/linux/hmm.h~mm-introduce-include-linux-pgtableh
+++ a/include/linux/hmm.h
@@ -10,7 +10,7 @@
 #define LINUX_HMM_H
 
 #include <linux/kconfig.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include <linux/device.h>
 #include <linux/migrate.h>
--- a/include/linux/hugetlb.h~mm-introduce-include-linux-pgtableh
+++ a/include/linux/hugetlb.h
@@ -9,7 +9,7 @@
 #include <linux/cgroup.h>
 #include <linux/list.h>
 #include <linux/kref.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 struct ctl_table;
 struct user_struct;
--- a/include/linux/io-mapping.h~mm-introduce-include-linux-pgtableh
+++ a/include/linux/io-mapping.h
@@ -99,7 +99,7 @@ io_mapping_unmap(void __iomem *vaddr)
 #else
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 /* Create the io_mapping object*/
 static inline struct io_mapping *
--- a/include/linux/kasan.h~mm-introduce-include-linux-pgtableh
+++ a/include/linux/kasan.h
@@ -12,7 +12,7 @@ struct task_struct;
 #ifdef CONFIG_KASAN
 
 #include <asm/kasan.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
 extern pte_t kasan_early_shadow_pte[PTRS_PER_PTE];
--- a/include/linux/mm.h~mm-introduce-include-linux-pgtableh
+++ a/include/linux/mm.h
@@ -92,7 +92,7 @@ extern int mmap_rnd_compat_bits __read_m
 #endif
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 
 /*
--- /dev/null
+++ a/include/linux/pgtable.h
@@ -0,0 +1,1290 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGTABLE_H
+#define _LINUX_PGTABLE_H
+
+#include <linux/pfn.h>
+#include <asm/pgtable.h>
+
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_MMU
+
+#include <linux/mm_types.h>
+#include <linux/bug.h>
+#include <linux/errno.h>
+#include <asm-generic/pgtable_uffd.h>
+
+#if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
+	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
+#error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
+#endif
+
+/*
+ * On almost all architectures and configurations, 0 can be used as the
+ * upper ceiling to free_pgtables(): on many architectures it has the same
+ * effect as using TASK_SIZE.  However, there is one configuration which
+ * must impose a more careful limit, to avoid freeing kernel pgtables.
+ */
+#ifndef USER_PGTABLES_CEILING
+#define USER_PGTABLES_CEILING	0UL
+#endif
+
+#ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
+extern int ptep_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pte_t *ptep,
+				 pte_t entry, int dirty);
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+extern int pmdp_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pmd_t *pmdp,
+				 pmd_t entry, int dirty);
+extern int pudp_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pud_t *pudp,
+				 pud_t entry, int dirty);
+#else
+static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
+					unsigned long address, pmd_t *pmdp,
+					pmd_t entry, int dirty)
+{
+	BUILD_BUG();
+	return 0;
+}
+static inline int pudp_set_access_flags(struct vm_area_struct *vma,
+					unsigned long address, pud_t *pudp,
+					pud_t entry, int dirty)
+{
+	BUILD_BUG();
+	return 0;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+
+#ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long address,
+					    pte_t *ptep)
+{
+	pte_t pte = *ptep;
+	int r = 1;
+	if (!pte_young(pte))
+		r = 0;
+	else
+		set_pte_at(vma->vm_mm, address, ptep, pte_mkold(pte));
+	return r;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long address,
+					    pmd_t *pmdp)
+{
+	pmd_t pmd = *pmdp;
+	int r = 1;
+	if (!pmd_young(pmd))
+		r = 0;
+	else
+		set_pmd_at(vma->vm_mm, address, pmdp, pmd_mkold(pmd));
+	return r;
+}
+#else
+static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long address,
+					    pmd_t *pmdp)
+{
+	BUILD_BUG();
+	return 0;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+
+#ifndef __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
+int ptep_clear_flush_young(struct vm_area_struct *vma,
+			   unsigned long address, pte_t *ptep);
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
+				  unsigned long address, pmd_t *pmdp);
+#else
+/*
+ * Despite relevant to THP only, this API is called from generic rmap code
+ * under PageTransHuge(), hence needs a dummy implementation for !THP
+ */
+static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
+					 unsigned long address, pmd_t *pmdp)
+{
+	BUILD_BUG();
+	return 0;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+
+#ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
+				       unsigned long address,
+				       pte_t *ptep)
+{
+	pte_t pte = *ptep;
+	pte_clear(mm, address, ptep);
+	return pte;
+}
+#endif
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
+static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address,
+					    pmd_t *pmdp)
+{
+	pmd_t pmd = *pmdp;
+	pmd_clear(pmdp);
+	return pmd;
+}
+#endif /* __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR */
+#ifndef __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
+static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address,
+					    pud_t *pudp)
+{
+	pud_t pud = *pudp;
+
+	pud_clear(pudp);
+	return pud;
+}
+#endif /* __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR_FULL
+static inline pmd_t pmdp_huge_get_and_clear_full(struct vm_area_struct *vma,
+					    unsigned long address, pmd_t *pmdp,
+					    int full)
+{
+	return pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
+}
+#endif
+
+#ifndef __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR_FULL
+static inline pud_t pudp_huge_get_and_clear_full(struct mm_struct *mm,
+					    unsigned long address, pud_t *pudp,
+					    int full)
+{
+	return pudp_huge_get_and_clear(mm, address, pudp);
+}
+#endif
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+#ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
+static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
+					    unsigned long address, pte_t *ptep,
+					    int full)
+{
+	pte_t pte;
+	pte = ptep_get_and_clear(mm, address, ptep);
+	return pte;
+}
+#endif
+
+/*
+ * Some architectures may be able to avoid expensive synchronization
+ * primitives when modifications are made to PTE's which are already
+ * not present, or in the process of an address space destruction.
+ */
+#ifndef __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
+static inline void pte_clear_not_present_full(struct mm_struct *mm,
+					      unsigned long address,
+					      pte_t *ptep,
+					      int full)
+{
+	pte_clear(mm, address, ptep);
+}
+#endif
+
+#ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
+extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
+			      unsigned long address,
+			      pte_t *ptep);
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
+extern pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma,
+			      unsigned long address,
+			      pmd_t *pmdp);
+extern pud_t pudp_huge_clear_flush(struct vm_area_struct *vma,
+			      unsigned long address,
+			      pud_t *pudp);
+#endif
+
+#ifndef __HAVE_ARCH_PTEP_SET_WRPROTECT
+struct mm_struct;
+static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long address, pte_t *ptep)
+{
+	pte_t old_pte = *ptep;
+	set_pte_at(mm, address, ptep, pte_wrprotect(old_pte));
+}
+#endif
+
+#ifndef pte_savedwrite
+#define pte_savedwrite pte_write
+#endif
+
+#ifndef pte_mk_savedwrite
+#define pte_mk_savedwrite pte_mkwrite
+#endif
+
+#ifndef pte_clear_savedwrite
+#define pte_clear_savedwrite pte_wrprotect
+#endif
+
+#ifndef pmd_savedwrite
+#define pmd_savedwrite pmd_write
+#endif
+
+#ifndef pmd_mk_savedwrite
+#define pmd_mk_savedwrite pmd_mkwrite
+#endif
+
+#ifndef pmd_clear_savedwrite
+#define pmd_clear_savedwrite pmd_wrprotect
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_SET_WRPROTECT
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline void pmdp_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pmd_t *pmdp)
+{
+	pmd_t old_pmd = *pmdp;
+	set_pmd_at(mm, address, pmdp, pmd_wrprotect(old_pmd));
+}
+#else
+static inline void pmdp_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pmd_t *pmdp)
+{
+	BUILD_BUG();
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+#ifndef __HAVE_ARCH_PUDP_SET_WRPROTECT
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline void pudp_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pud_t *pudp)
+{
+	pud_t old_pud = *pudp;
+
+	set_pud_at(mm, address, pudp, pud_wrprotect(old_pud));
+}
+#else
+static inline void pudp_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pud_t *pudp)
+{
+	BUILD_BUG();
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+#endif
+
+#ifndef pmdp_collapse_flush
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
+				 unsigned long address, pmd_t *pmdp);
+#else
+static inline pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
+					unsigned long address,
+					pmd_t *pmdp)
+{
+	BUILD_BUG();
+	return *pmdp;
+}
+#define pmdp_collapse_flush pmdp_collapse_flush
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+
+#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
+				       pgtable_t pgtable);
+#endif
+
+#ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
+extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
+#endif
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/*
+ * This is an implementation of pmdp_establish() that is only suitable for an
+ * architecture that doesn't have hardware dirty/accessed bits. In this case we
+ * can't race with CPU which sets these bits and non-atomic aproach is fine.
+ */
+static inline pmd_t generic_pmdp_establish(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp, pmd_t pmd)
+{
+	pmd_t old_pmd = *pmdp;
+	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
+	return old_pmd;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_INVALIDATE
+extern pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
+			    pmd_t *pmdp);
+#endif
+
+#ifndef __HAVE_ARCH_PTE_SAME
+static inline int pte_same(pte_t pte_a, pte_t pte_b)
+{
+	return pte_val(pte_a) == pte_val(pte_b);
+}
+#endif
+
+#ifndef __HAVE_ARCH_PTE_UNUSED
+/*
+ * Some architectures provide facilities to virtualization guests
+ * so that they can flag allocated pages as unused. This allows the
+ * host to transparently reclaim unused pages. This function returns
+ * whether the pte's page is unused.
+ */
+static inline int pte_unused(pte_t pte)
+{
+	return 0;
+}
+#endif
+
+#ifndef pte_access_permitted
+#define pte_access_permitted(pte, write) \
+	(pte_present(pte) && (!(write) || pte_write(pte)))
+#endif
+
+#ifndef pmd_access_permitted
+#define pmd_access_permitted(pmd, write) \
+	(pmd_present(pmd) && (!(write) || pmd_write(pmd)))
+#endif
+
+#ifndef pud_access_permitted
+#define pud_access_permitted(pud, write) \
+	(pud_present(pud) && (!(write) || pud_write(pud)))
+#endif
+
+#ifndef p4d_access_permitted
+#define p4d_access_permitted(p4d, write) \
+	(p4d_present(p4d) && (!(write) || p4d_write(p4d)))
+#endif
+
+#ifndef pgd_access_permitted
+#define pgd_access_permitted(pgd, write) \
+	(pgd_present(pgd) && (!(write) || pgd_write(pgd)))
+#endif
+
+#ifndef __HAVE_ARCH_PMD_SAME
+static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
+{
+	return pmd_val(pmd_a) == pmd_val(pmd_b);
+}
+
+static inline int pud_same(pud_t pud_a, pud_t pud_b)
+{
+	return pud_val(pud_a) == pud_val(pud_b);
+}
+#endif
+
+#ifndef __HAVE_ARCH_P4D_SAME
+static inline int p4d_same(p4d_t p4d_a, p4d_t p4d_b)
+{
+	return p4d_val(p4d_a) == p4d_val(p4d_b);
+}
+#endif
+
+#ifndef __HAVE_ARCH_PGD_SAME
+static inline int pgd_same(pgd_t pgd_a, pgd_t pgd_b)
+{
+	return pgd_val(pgd_a) == pgd_val(pgd_b);
+}
+#endif
+
+/*
+ * Use set_p*_safe(), and elide TLB flushing, when confident that *no*
+ * TLB flush will be required as a result of the "set". For example, use
+ * in scenarios where it is known ahead of time that the routine is
+ * setting non-present entries, or re-setting an existing entry to the
+ * same value. Otherwise, use the typical "set" helpers and flush the
+ * TLB.
+ */
+#define set_pte_safe(ptep, pte) \
+({ \
+	WARN_ON_ONCE(pte_present(*ptep) && !pte_same(*ptep, pte)); \
+	set_pte(ptep, pte); \
+})
+
+#define set_pmd_safe(pmdp, pmd) \
+({ \
+	WARN_ON_ONCE(pmd_present(*pmdp) && !pmd_same(*pmdp, pmd)); \
+	set_pmd(pmdp, pmd); \
+})
+
+#define set_pud_safe(pudp, pud) \
+({ \
+	WARN_ON_ONCE(pud_present(*pudp) && !pud_same(*pudp, pud)); \
+	set_pud(pudp, pud); \
+})
+
+#define set_p4d_safe(p4dp, p4d) \
+({ \
+	WARN_ON_ONCE(p4d_present(*p4dp) && !p4d_same(*p4dp, p4d)); \
+	set_p4d(p4dp, p4d); \
+})
+
+#define set_pgd_safe(pgdp, pgd) \
+({ \
+	WARN_ON_ONCE(pgd_present(*pgdp) && !pgd_same(*pgdp, pgd)); \
+	set_pgd(pgdp, pgd); \
+})
+
+#ifndef __HAVE_ARCH_DO_SWAP_PAGE
+/*
+ * Some architectures support metadata associated with a page. When a
+ * page is being swapped out, this metadata must be saved so it can be
+ * restored when the page is swapped back in. SPARC M7 and newer
+ * processors support an ADI (Application Data Integrity) tag for the
+ * page as metadata for the page. arch_do_swap_page() can restore this
+ * metadata when a page is swapped back in.
+ */
+static inline void arch_do_swap_page(struct mm_struct *mm,
+				     struct vm_area_struct *vma,
+				     unsigned long addr,
+				     pte_t pte, pte_t oldpte)
+{
+
+}
+#endif
+
+#ifndef __HAVE_ARCH_UNMAP_ONE
+/*
+ * Some architectures support metadata associated with a page. When a
+ * page is being swapped out, this metadata must be saved so it can be
+ * restored when the page is swapped back in. SPARC M7 and newer
+ * processors support an ADI (Application Data Integrity) tag for the
+ * page as metadata for the page. arch_unmap_one() can save this
+ * metadata on a swap-out of a page.
+ */
+static inline int arch_unmap_one(struct mm_struct *mm,
+				  struct vm_area_struct *vma,
+				  unsigned long addr,
+				  pte_t orig_pte)
+{
+	return 0;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PGD_OFFSET_GATE
+#define pgd_offset_gate(mm, addr)	pgd_offset(mm, addr)
+#endif
+
+#ifndef __HAVE_ARCH_MOVE_PTE
+#define move_pte(pte, prot, old_addr, new_addr)	(pte)
+#endif
+
+#ifndef pte_accessible
+# define pte_accessible(mm, pte)	((void)(pte), 1)
+#endif
+
+#ifndef flush_tlb_fix_spurious_fault
+#define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
+#endif
+
+#ifndef pgprot_nx
+#define pgprot_nx(prot)	(prot)
+#endif
+
+#ifndef pgprot_noncached
+#define pgprot_noncached(prot)	(prot)
+#endif
+
+#ifndef pgprot_writecombine
+#define pgprot_writecombine pgprot_noncached
+#endif
+
+#ifndef pgprot_writethrough
+#define pgprot_writethrough pgprot_noncached
+#endif
+
+#ifndef pgprot_device
+#define pgprot_device pgprot_noncached
+#endif
+
+#ifndef pgprot_modify
+#define pgprot_modify pgprot_modify
+static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+{
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_noncached(oldprot)))
+		newprot = pgprot_noncached(newprot);
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_writecombine(oldprot)))
+		newprot = pgprot_writecombine(newprot);
+	if (pgprot_val(oldprot) == pgprot_val(pgprot_device(oldprot)))
+		newprot = pgprot_device(newprot);
+	return newprot;
+}
+#endif
+
+/*
+ * When walking page tables, get the address of the next boundary,
+ * or the end address of the range if that comes earlier.  Although no
+ * vma end wraps to 0, rounded up __boundary may wrap to 0 throughout.
+ */
+
+#define pgd_addr_end(addr, end)						\
+({	unsigned long __boundary = ((addr) + PGDIR_SIZE) & PGDIR_MASK;	\
+	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
+})
+
+#ifndef p4d_addr_end
+#define p4d_addr_end(addr, end)						\
+({	unsigned long __boundary = ((addr) + P4D_SIZE) & P4D_MASK;	\
+	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
+})
+#endif
+
+#ifndef pud_addr_end
+#define pud_addr_end(addr, end)						\
+({	unsigned long __boundary = ((addr) + PUD_SIZE) & PUD_MASK;	\
+	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
+})
+#endif
+
+#ifndef pmd_addr_end
+#define pmd_addr_end(addr, end)						\
+({	unsigned long __boundary = ((addr) + PMD_SIZE) & PMD_MASK;	\
+	(__boundary - 1 < (end) - 1)? __boundary: (end);		\
+})
+#endif
+
+/*
+ * When walking page tables, we usually want to skip any p?d_none entries;
+ * and any p?d_bad entries - reporting the error before resetting to none.
+ * Do the tests inline, but report and clear the bad entry in mm/memory.c.
+ */
+void pgd_clear_bad(pgd_t *);
+
+#ifndef __PAGETABLE_P4D_FOLDED
+void p4d_clear_bad(p4d_t *);
+#else
+#define p4d_clear_bad(p4d)        do { } while (0)
+#endif
+
+#ifndef __PAGETABLE_PUD_FOLDED
+void pud_clear_bad(pud_t *);
+#else
+#define pud_clear_bad(p4d)        do { } while (0)
+#endif
+
+void pmd_clear_bad(pmd_t *);
+
+static inline int pgd_none_or_clear_bad(pgd_t *pgd)
+{
+	if (pgd_none(*pgd))
+		return 1;
+	if (unlikely(pgd_bad(*pgd))) {
+		pgd_clear_bad(pgd);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int p4d_none_or_clear_bad(p4d_t *p4d)
+{
+	if (p4d_none(*p4d))
+		return 1;
+	if (unlikely(p4d_bad(*p4d))) {
+		p4d_clear_bad(p4d);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int pud_none_or_clear_bad(pud_t *pud)
+{
+	if (pud_none(*pud))
+		return 1;
+	if (unlikely(pud_bad(*pud))) {
+		pud_clear_bad(pud);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int pmd_none_or_clear_bad(pmd_t *pmd)
+{
+	if (pmd_none(*pmd))
+		return 1;
+	if (unlikely(pmd_bad(*pmd))) {
+		pmd_clear_bad(pmd);
+		return 1;
+	}
+	return 0;
+}
+
+static inline pte_t __ptep_modify_prot_start(struct vm_area_struct *vma,
+					     unsigned long addr,
+					     pte_t *ptep)
+{
+	/*
+	 * Get the current pte state, but zero it out to make it
+	 * non-present, preventing the hardware from asynchronously
+	 * updating it.
+	 */
+	return ptep_get_and_clear(vma->vm_mm, addr, ptep);
+}
+
+static inline void __ptep_modify_prot_commit(struct vm_area_struct *vma,
+					     unsigned long addr,
+					     pte_t *ptep, pte_t pte)
+{
+	/*
+	 * The pte is non-present, so there's no hardware state to
+	 * preserve.
+	 */
+	set_pte_at(vma->vm_mm, addr, ptep, pte);
+}
+
+#ifndef __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
+/*
+ * Start a pte protection read-modify-write transaction, which
+ * protects against asynchronous hardware modifications to the pte.
+ * The intention is not to prevent the hardware from making pte
+ * updates, but to prevent any updates it may make from being lost.
+ *
+ * This does not protect against other software modifications of the
+ * pte; the appropriate pte lock must be held over the transation.
+ *
+ * Note that this interface is intended to be batchable, meaning that
+ * ptep_modify_prot_commit may not actually update the pte, but merely
+ * queue the update to be done at some later time.  The update must be
+ * actually committed before the pte lock is released, however.
+ */
+static inline pte_t ptep_modify_prot_start(struct vm_area_struct *vma,
+					   unsigned long addr,
+					   pte_t *ptep)
+{
+	return __ptep_modify_prot_start(vma, addr, ptep);
+}
+
+/*
+ * Commit an update to a pte, leaving any hardware-controlled bits in
+ * the PTE unmodified.
+ */
+static inline void ptep_modify_prot_commit(struct vm_area_struct *vma,
+					   unsigned long addr,
+					   pte_t *ptep, pte_t old_pte, pte_t pte)
+{
+	__ptep_modify_prot_commit(vma, addr, ptep, pte);
+}
+#endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
+#endif /* CONFIG_MMU */
+
+/*
+ * No-op macros that just return the current protection value. Defined here
+ * because these macros can be used used even if CONFIG_MMU is not defined.
+ */
+#ifndef pgprot_encrypted
+#define pgprot_encrypted(prot)	(prot)
+#endif
+
+#ifndef pgprot_decrypted
+#define pgprot_decrypted(prot)	(prot)
+#endif
+
+/*
+ * A facility to provide lazy MMU batching.  This allows PTE updates and
+ * page invalidations to be delayed until a call to leave lazy MMU mode
+ * is issued.  Some architectures may benefit from doing this, and it is
+ * beneficial for both shadow and direct mode hypervisors, which may batch
+ * the PTE updates which happen during this window.  Note that using this
+ * interface requires that read hazards be removed from the code.  A read
+ * hazard could result in the direct mode hypervisor case, since the actual
+ * write to the page tables may not yet have taken place, so reads though
+ * a raw PTE pointer after it has been modified are not guaranteed to be
+ * up to date.  This mode can only be entered and left under the protection of
+ * the page table locks for all page tables which may be modified.  In the UP
+ * case, this is required so that preemption is disabled, and in the SMP case,
+ * it must synchronize the delayed page table writes properly on other CPUs.
+ */
+#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#define arch_enter_lazy_mmu_mode()	do {} while (0)
+#define arch_leave_lazy_mmu_mode()	do {} while (0)
+#define arch_flush_lazy_mmu_mode()	do {} while (0)
+#endif
+
+/*
+ * A facility to provide batching of the reload of page tables and
+ * other process state with the actual context switch code for
+ * paravirtualized guests.  By convention, only one of the batched
+ * update (lazy) modes (CPU, MMU) should be active at any given time,
+ * entry should never be nested, and entry and exits should always be
+ * paired.  This is for sanity of maintaining and reasoning about the
+ * kernel code.  In this case, the exit (end of the context switch) is
+ * in architecture-specific code, and so doesn't need a generic
+ * definition.
+ */
+#ifndef __HAVE_ARCH_START_CONTEXT_SWITCH
+#define arch_start_context_switch(prev)	do {} while (0)
+#endif
+
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+#ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
+static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline int pmd_swp_soft_dirty(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+#endif
+#else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
+static inline int pte_soft_dirty(pte_t pte)
+{
+	return 0;
+}
+
+static inline int pmd_soft_dirty(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pte_t pte_mksoft_dirty(pte_t pte)
+{
+	return pte;
+}
+
+static inline pmd_t pmd_mksoft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline pte_t pte_clear_soft_dirty(pte_t pte)
+{
+	return pte;
+}
+
+static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
+{
+	return pte;
+}
+
+static inline int pte_swp_soft_dirty(pte_t pte)
+{
+	return 0;
+}
+
+static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
+{
+	return pte;
+}
+
+static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline int pmd_swp_soft_dirty(pmd_t pmd)
+{
+	return 0;
+}
+
+static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
+{
+	return pmd;
+}
+#endif
+
+#ifndef __HAVE_PFNMAP_TRACKING
+/*
+ * Interfaces that can be used by architecture code to keep track of
+ * memory type of pfn mappings specified by the remap_pfn_range,
+ * vmf_insert_pfn.
+ */
+
+/*
+ * track_pfn_remap is called when a _new_ pfn mapping is being established
+ * by remap_pfn_range() for physical range indicated by pfn and size.
+ */
+static inline int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
+				  unsigned long pfn, unsigned long addr,
+				  unsigned long size)
+{
+	return 0;
+}
+
+/*
+ * track_pfn_insert is called when a _new_ single pfn is established
+ * by vmf_insert_pfn().
+ */
+static inline void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
+				    pfn_t pfn)
+{
+}
+
+/*
+ * track_pfn_copy is called when vma that is covering the pfnmap gets
+ * copied through copy_page_range().
+ */
+static inline int track_pfn_copy(struct vm_area_struct *vma)
+{
+	return 0;
+}
+
+/*
+ * untrack_pfn is called while unmapping a pfnmap for a region.
+ * untrack can be called for a specific region indicated by pfn and size or
+ * can be for the entire vma (in which case pfn, size are zero).
+ */
+static inline void untrack_pfn(struct vm_area_struct *vma,
+			       unsigned long pfn, unsigned long size)
+{
+}
+
+/*
+ * untrack_pfn_moved is called while mremapping a pfnmap for a new region.
+ */
+static inline void untrack_pfn_moved(struct vm_area_struct *vma)
+{
+}
+#else
+extern int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
+			   unsigned long pfn, unsigned long addr,
+			   unsigned long size);
+extern void track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
+			     pfn_t pfn);
+extern int track_pfn_copy(struct vm_area_struct *vma);
+extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
+			unsigned long size);
+extern void untrack_pfn_moved(struct vm_area_struct *vma);
+#endif
+
+#ifdef __HAVE_COLOR_ZERO_PAGE
+static inline int is_zero_pfn(unsigned long pfn)
+{
+	extern unsigned long zero_pfn;
+	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
+	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
+}
+
+#define my_zero_pfn(addr)	page_to_pfn(ZERO_PAGE(addr))
+
+#else
+static inline int is_zero_pfn(unsigned long pfn)
+{
+	extern unsigned long zero_pfn;
+	return pfn == zero_pfn;
+}
+
+static inline unsigned long my_zero_pfn(unsigned long addr)
+{
+	extern unsigned long zero_pfn;
+	return zero_pfn;
+}
+#endif
+
+#ifdef CONFIG_MMU
+
+#ifndef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmd_trans_huge(pmd_t pmd)
+{
+	return 0;
+}
+#ifndef pmd_write
+static inline int pmd_write(pmd_t pmd)
+{
+	BUG();
+	return 0;
+}
+#endif /* pmd_write */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+#ifndef pud_write
+static inline int pud_write(pud_t pud)
+{
+	BUG();
+	return 0;
+}
+#endif /* pud_write */
+
+#if !defined(CONFIG_ARCH_HAS_PTE_DEVMAP) || !defined(CONFIG_TRANSPARENT_HUGEPAGE)
+static inline int pmd_devmap(pmd_t pmd)
+{
+	return 0;
+}
+static inline int pud_devmap(pud_t pud)
+{
+	return 0;
+}
+static inline int pgd_devmap(pgd_t pgd)
+{
+	return 0;
+}
+#endif
+
+#if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
+	(defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	 !defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
+static inline int pud_trans_huge(pud_t pud)
+{
+	return 0;
+}
+#endif
+
+/* See pmd_none_or_trans_huge_or_clear_bad for discussion. */
+static inline int pud_none_or_trans_huge_or_dev_or_clear_bad(pud_t *pud)
+{
+	pud_t pudval = READ_ONCE(*pud);
+
+	if (pud_none(pudval) || pud_trans_huge(pudval) || pud_devmap(pudval))
+		return 1;
+	if (unlikely(pud_bad(pudval))) {
+		pud_clear_bad(pud);
+		return 1;
+	}
+	return 0;
+}
+
+/* See pmd_trans_unstable for discussion. */
+static inline int pud_trans_unstable(pud_t *pud)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	return pud_none_or_trans_huge_or_dev_or_clear_bad(pud);
+#else
+	return 0;
+#endif
+}
+
+#ifndef pmd_read_atomic
+static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
+{
+	/*
+	 * Depend on compiler for an atomic pmd read. NOTE: this is
+	 * only going to work, if the pmdval_t isn't larger than
+	 * an unsigned long.
+	 */
+	return *pmdp;
+}
+#endif
+
+#ifndef arch_needs_pgtable_deposit
+#define arch_needs_pgtable_deposit() (false)
+#endif
+/*
+ * This function is meant to be used by sites walking pagetables with
+ * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
+ * transhuge page faults. MADV_DONTNEED can convert a transhuge pmd
+ * into a null pmd and the transhuge page fault can convert a null pmd
+ * into an hugepmd or into a regular pmd (if the hugepage allocation
+ * fails). While holding the mmap_sem in read mode the pmd becomes
+ * stable and stops changing under us only if it's not null and not a
+ * transhuge pmd. When those races occurs and this function makes a
+ * difference vs the standard pmd_none_or_clear_bad, the result is
+ * undefined so behaving like if the pmd was none is safe (because it
+ * can return none anyway). The compiler level barrier() is critically
+ * important to compute the two checks atomically on the same pmdval.
+ *
+ * For 32bit kernels with a 64bit large pmd_t this automatically takes
+ * care of reading the pmd atomically to avoid SMP race conditions
+ * against pmd_populate() when the mmap_sem is hold for reading by the
+ * caller (a special atomic read not done by "gcc" as in the generic
+ * version above, is also needed when THP is disabled because the page
+ * fault can populate the pmd from under us).
+ */
+static inline int pmd_none_or_trans_huge_or_clear_bad(pmd_t *pmd)
+{
+	pmd_t pmdval = pmd_read_atomic(pmd);
+	/*
+	 * The barrier will stabilize the pmdval in a register or on
+	 * the stack so that it will stop changing under the code.
+	 *
+	 * When CONFIG_TRANSPARENT_HUGEPAGE=y on x86 32bit PAE,
+	 * pmd_read_atomic is allowed to return a not atomic pmdval
+	 * (for example pointing to an hugepage that has never been
+	 * mapped in the pmd). The below checks will only care about
+	 * the low part of the pmd with 32bit PAE x86 anyway, with the
+	 * exception of pmd_none(). So the important thing is that if
+	 * the low part of the pmd is found null, the high part will
+	 * be also null or the pmd_none() check below would be
+	 * confused.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	barrier();
+#endif
+	/*
+	 * !pmd_present() checks for pmd migration entries
+	 *
+	 * The complete check uses is_pmd_migration_entry() in linux/swapops.h
+	 * But using that requires moving current function and pmd_trans_unstable()
+	 * to linux/swapops.h to resovle dependency, which is too much code move.
+	 *
+	 * !pmd_present() is equivalent to is_pmd_migration_entry() currently,
+	 * because !pmd_present() pages can only be under migration not swapped
+	 * out.
+	 *
+	 * pmd_none() is preseved for future condition checks on pmd migration
+	 * entries and not confusing with this function name, although it is
+	 * redundant with !pmd_present().
+	 */
+	if (pmd_none(pmdval) || pmd_trans_huge(pmdval) ||
+		(IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION) && !pmd_present(pmdval)))
+		return 1;
+	if (unlikely(pmd_bad(pmdval))) {
+		pmd_clear_bad(pmd);
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * This is a noop if Transparent Hugepage Support is not built into
+ * the kernel. Otherwise it is equivalent to
+ * pmd_none_or_trans_huge_or_clear_bad(), and shall only be called in
+ * places that already verified the pmd is not none and they want to
+ * walk ptes while holding the mmap sem in read mode (write mode don't
+ * need this). If THP is not enabled, the pmd can't go away under the
+ * code even if MADV_DONTNEED runs, but if THP is enabled we need to
+ * run a pmd_trans_unstable before walking the ptes after
+ * split_huge_pmd returns (because it may have run when the pmd become
+ * null, but then a page fault can map in a THP and not a regular page).
+ */
+static inline int pmd_trans_unstable(pmd_t *pmd)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return pmd_none_or_trans_huge_or_clear_bad(pmd);
+#else
+	return 0;
+#endif
+}
+
+#ifndef CONFIG_NUMA_BALANCING
+/*
+ * Technically a PTE can be PROTNONE even when not doing NUMA balancing but
+ * the only case the kernel cares is for NUMA balancing and is only ever set
+ * when the VMA is accessible. For PROT_NONE VMAs, the PTEs are not marked
+ * _PAGE_PROTNONE so by by default, implement the helper as "always no". It
+ * is the responsibility of the caller to distinguish between PROT_NONE
+ * protections and NUMA hinting fault protections.
+ */
+static inline int pte_protnone(pte_t pte)
+{
+	return 0;
+}
+
+static inline int pmd_protnone(pmd_t pmd)
+{
+	return 0;
+}
+#endif /* CONFIG_NUMA_BALANCING */
+
+#endif /* CONFIG_MMU */
+
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+
+#ifndef __PAGETABLE_P4D_FOLDED
+int p4d_set_huge(p4d_t *p4d, phys_addr_t addr, pgprot_t prot);
+int p4d_clear_huge(p4d_t *p4d);
+#else
+static inline int p4d_set_huge(p4d_t *p4d, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+static inline int p4d_clear_huge(p4d_t *p4d)
+{
+	return 0;
+}
+#endif /* !__PAGETABLE_P4D_FOLDED */
+
+int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
+int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
+int pud_clear_huge(pud_t *pud);
+int pmd_clear_huge(pmd_t *pmd);
+int p4d_free_pud_page(p4d_t *p4d, unsigned long addr);
+int pud_free_pmd_page(pud_t *pud, unsigned long addr);
+int pmd_free_pte_page(pmd_t *pmd, unsigned long addr);
+#else	/* !CONFIG_HAVE_ARCH_HUGE_VMAP */
+static inline int p4d_set_huge(p4d_t *p4d, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+static inline int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+static inline int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+static inline int p4d_clear_huge(p4d_t *p4d)
+{
+	return 0;
+}
+static inline int pud_clear_huge(pud_t *pud)
+{
+	return 0;
+}
+static inline int pmd_clear_huge(pmd_t *pmd)
+{
+	return 0;
+}
+static inline int p4d_free_pud_page(p4d_t *p4d, unsigned long addr)
+{
+	return 0;
+}
+static inline int pud_free_pmd_page(pud_t *pud, unsigned long addr)
+{
+	return 0;
+}
+static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
+{
+	return 0;
+}
+#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
+
+#ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/*
+ * ARCHes with special requirements for evicting THP backing TLB entries can
+ * implement this. Otherwise also, it can help optimize normal TLB flush in
+ * THP regime. stock flush_tlb_range() typically has optimization to nuke the
+ * entire TLB TLB if flush span is greater than a threshold, which will
+ * likely be true for a single huge page. Thus a single thp flush will
+ * invalidate the entire TLB which is not desitable.
+ * e.g. see arch/arc: flush_pmd_tlb_range
+ */
+#define flush_pmd_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
+#define flush_pud_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
+#else
+#define flush_pmd_tlb_range(vma, addr, end)	BUILD_BUG()
+#define flush_pud_tlb_range(vma, addr, end)	BUILD_BUG()
+#endif
+#endif
+
+struct file;
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+			unsigned long size, pgprot_t *vma_prot);
+
+#ifndef CONFIG_X86_ESPFIX64
+static inline void init_espfix_bsp(void) { }
+#endif
+
+extern void __init pgtable_cache_init(void);
+
+#ifndef __HAVE_ARCH_PFN_MODIFY_ALLOWED
+static inline bool pfn_modify_allowed(unsigned long pfn, pgprot_t prot)
+{
+	return true;
+}
+
+static inline bool arch_has_pfn_modify_check(void)
+{
+	return false;
+}
+#endif /* !_HAVE_ARCH_PFN_MODIFY_ALLOWED */
+
+/*
+ * Architecture PAGE_KERNEL_* fallbacks
+ *
+ * Some architectures don't define certain PAGE_KERNEL_* flags. This is either
+ * because they really don't support them, or the port needs to be updated to
+ * reflect the required functionality. Below are a set of relatively safe
+ * fallbacks, as best effort, which we can count on in lieu of the architectures
+ * not defining them on their own yet.
+ */
+
+#ifndef PAGE_KERNEL_RO
+# define PAGE_KERNEL_RO PAGE_KERNEL
+#endif
+
+#ifndef PAGE_KERNEL_EXEC
+# define PAGE_KERNEL_EXEC PAGE_KERNEL
+#endif
+
+/*
+ * Page Table Modification bits for pgtbl_mod_mask.
+ *
+ * These are used by the p?d_alloc_track*() set of functions an in the generic
+ * vmalloc/ioremap code to track at which page-table levels entries have been
+ * modified. Based on that the code can better decide when vmalloc and ioremap
+ * mapping changes need to be synchronized to other page-tables in the system.
+ */
+#define		__PGTBL_PGD_MODIFIED	0
+#define		__PGTBL_P4D_MODIFIED	1
+#define		__PGTBL_PUD_MODIFIED	2
+#define		__PGTBL_PMD_MODIFIED	3
+#define		__PGTBL_PTE_MODIFIED	4
+
+#define		PGTBL_PGD_MODIFIED	BIT(__PGTBL_PGD_MODIFIED)
+#define		PGTBL_P4D_MODIFIED	BIT(__PGTBL_P4D_MODIFIED)
+#define		PGTBL_PUD_MODIFIED	BIT(__PGTBL_PUD_MODIFIED)
+#define		PGTBL_PMD_MODIFIED	BIT(__PGTBL_PMD_MODIFIED)
+#define		PGTBL_PTE_MODIFIED	BIT(__PGTBL_PTE_MODIFIED)
+
+/* Page-Table Modification Mask */
+typedef unsigned int pgtbl_mod_mask;
+
+#endif /* !__ASSEMBLY__ */
+
+#ifndef io_remap_pfn_range
+#define io_remap_pfn_range remap_pfn_range
+#endif
+
+#ifndef has_transparent_hugepage
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define has_transparent_hugepage() 1
+#else
+#define has_transparent_hugepage() 0
+#endif
+#endif
+
+/*
+ * On some architectures it depends on the mm if the p4d/pud or pmd
+ * layer of the page table hierarchy is folded or not.
+ */
+#ifndef mm_p4d_folded
+#define mm_p4d_folded(mm)	__is_defined(__PAGETABLE_P4D_FOLDED)
+#endif
+
+#ifndef mm_pud_folded
+#define mm_pud_folded(mm)	__is_defined(__PAGETABLE_PUD_FOLDED)
+#endif
+
+#ifndef mm_pmd_folded
+#define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
+#endif
+
+/*
+ * p?d_leaf() - true if this entry is a final mapping to a physical address.
+ * This differs from p?d_huge() by the fact that they are always available (if
+ * the architecture supports large pages at the appropriate level) even
+ * if CONFIG_HUGETLB_PAGE is not defined.
+ * Only meaningful when called on a valid entry.
+ */
+#ifndef pgd_leaf
+#define pgd_leaf(x)	0
+#endif
+#ifndef p4d_leaf
+#define p4d_leaf(x)	0
+#endif
+#ifndef pud_leaf
+#define pud_leaf(x)	0
+#endif
+#ifndef pmd_leaf
+#define pmd_leaf(x)	0
+#endif
+
+#endif /* _ASM_GENERIC_PGTABLE_H */
--- a/include/xen/arm/page.h~mm-introduce-include-linux-pgtableh
+++ a/include/xen/arm/page.h
@@ -3,7 +3,7 @@
 #define _ASM_ARM_XEN_PAGE_H
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include <linux/pfn.h>
 #include <linux/types.h>
--- a/kernel/bpf/syscall.c~mm-introduce-include-linux-pgtableh
+++ a/kernel/bpf/syscall.c
@@ -25,7 +25,7 @@
 #include <linux/nospec.h>
 #include <linux/audit.h>
 #include <uapi/linux/btf.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/bpf_lsm.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
--- a/mm/init-mm.c~mm-introduce-include-linux-pgtableh
+++ a/mm/init-mm.c
@@ -9,7 +9,7 @@
 
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/mmu.h>
 
 #ifndef INIT_MM_CONTEXT
--- a/mm/mincore.c~mm-introduce-include-linux-pgtableh
+++ a/mm/mincore.c
@@ -19,7 +19,7 @@
 #include <linux/hugetlb.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
--- a/mm/mprotect.c~mm-introduce-include-linux-pgtableh
+++ a/mm/mprotect.c
@@ -28,7 +28,7 @@
 #include <linux/ksm.h>
 #include <linux/uaccess.h>
 #include <linux/mm_inline.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
--- a/mm/page_reporting.h~mm-introduce-include-linux-pgtableh
+++ a/mm/page_reporting.h
@@ -7,7 +7,7 @@
 #include <linux/page-isolation.h>
 #include <linux/jump_label.h>
 #include <linux/slab.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/scatterlist.h>
 
 #define PAGE_REPORTING_MIN_ORDER	pageblock_order
--- a/mm/pgtable-generic.c~mm-introduce-include-linux-pgtableh
+++ a/mm/pgtable-generic.c
@@ -2,15 +2,15 @@
 /*
  *  mm/pgtable-generic.c
  *
- *  Generic pgtable methods declared in asm-generic/pgtable.h
+ *  Generic pgtable methods declared in linux/pgtable.h
  *
  *  Copyright (C) 2010  Linus Torvalds
  */
 
 #include <linux/pagemap.h>
 #include <linux/hugetlb.h>
+#include <linux/pgtable.h>
 #include <asm/tlb.h>
-#include <asm-generic/pgtable.h>
 
 /*
  * If a p?d_bad entry is found while walking page tables, report
@@ -53,7 +53,7 @@ void pmd_clear_bad(pmd_t *pmd)
 
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
- * Only sets the access flags (dirty, accessed), as well as write 
+ * Only sets the access flags (dirty, accessed), as well as write
  * permission. Furthermore, we know it always gets set to a "more
  * permissive" setting, which allows most architectures to optimize
  * this. We return whether the PTE actually changed, which in turn
--- a/mm/zsmalloc.c~mm-introduce-include-linux-pgtableh
+++ a/mm/zsmalloc.c
@@ -40,7 +40,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <asm/tlbflush.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
 #include <linux/vmalloc.h>
--- a/sound/pci/hda/hda_intel.c~mm-introduce-include-linux-pgtableh
+++ a/sound/pci/hda/hda_intel.c
@@ -39,7 +39,7 @@
 
 #ifdef CONFIG_X86
 /* for snoop control */
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <asm/set_memory.h>
 #include <asm/cpufeature.h>
 #endif
--- a/sound/soc/intel/common/sst-firmware.c~mm-introduce-include-linux-pgtableh
+++ a/sound/soc/intel/common/sst-firmware.c
@@ -21,7 +21,7 @@
 #include <linux/dma/dw.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 
 #include "sst-dsp.h"
 #include "sst-dsp-priv.h"
--- a/sound/soc/intel/haswell/sst-haswell-pcm.c~mm-introduce-include-linux-pgtableh
+++ a/sound/soc/intel/haswell/sst-haswell-pcm.c
@@ -11,7 +11,7 @@
 #include <linux/delay.h>
 #include <linux/pm_runtime.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
+#include <linux/pgtable.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-memblock-replace-dereferences-of-memblock_regionnid-with-api-calls.patch
mm-make-early_pfn_to_nid-and-related-defintions-close-to-each-other.patch
mm-remove-config_have_memblock_node_map-option.patch
mm-free_area_init-use-maximal-zone-pfns-rather-than-zone-sizes.patch
mm-use-free_area_init-instead-of-free_area_init_nodes.patch
alpha-simplify-detection-of-memory-zone-boundaries.patch
arm-simplify-detection-of-memory-zone-boundaries.patch
arm64-simplify-detection-of-memory-zone-boundaries-for-uma-configs.patch
csky-simplify-detection-of-memory-zone-boundaries.patch
m68k-mm-simplify-detection-of-memory-zone-boundaries.patch
parisc-simplify-detection-of-memory-zone-boundaries.patch
sparc32-simplify-detection-of-memory-zone-boundaries.patch
unicore32-simplify-detection-of-memory-zone-boundaries.patch
xtensa-simplify-detection-of-memory-zone-boundaries.patch
mm-remove-early_pfn_in_nid-and-config_nodes_span_other_nodes.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order.patch
mm-free_area_init-allow-defining-max_zone_pfn-in-descending-order-fix-2.patch
mm-rename-free_area_init_node-to-free_area_init_memoryless_node.patch
mm-clean-up-free_area_init_node-and-its-helpers.patch
mm-simplify-find_min_pfn_with_active_regions.patch
docs-vm-update-memory-models-documentation.patch
h8300-remove-usage-of-__arch_use_5level_hack.patch
arm-add-support-for-folded-p4d-page-tables.patch
arm-add-support-for-folded-p4d-page-tables-fix.patch
arm64-add-support-for-folded-p4d-page-tables.patch
hexagon-remove-__arch_use_5level_hack.patch
ia64-add-support-for-folded-p4d-page-tables.patch
nios2-add-support-for-folded-p4d-page-tables.patch
openrisc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables.patch
powerpc-add-support-for-folded-p4d-page-tables-fix.patch
sh-drop-__pxd_offset-macros-that-duplicate-pxd_index-ones.patch
sh-add-support-for-folded-p4d-page-tables.patch
unicore32-remove-__arch_use_5level_hack.patch
asm-generic-remove-pgtable-nop4d-hackh.patch
mm-remove-__arch_has_5level_hack-and-include-asm-generic-5level-fixuph.patch
mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch
mm-introduce-include-linux-pgtableh.patch
mm-reorder-includes-after-introduction-of-linux-pgtableh.patch
csky-replace-definitions-of-__pxd_offset-with-pxd_index.patch
m68k-mm-motorola-move-comment-about-page-table-allocation-funcitons.patch
m68k-mm-move-cachenocahe_page-definitions-close-to-their-user.patch
x86-mm-simplify-init_trampoline-and-surrounding-logic.patch
mm-pgtable-add-shortcuts-for-accessing-kernel-pmd-and-pte.patch
mm-consolidate-pte_index-and-pte_offset_-definitions.patch
mm-consolidate-pmd_index-and-pmd_offset-definitions.patch
mm-consolidate-pud_index-and-pud_offset-definitions.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions.patch
