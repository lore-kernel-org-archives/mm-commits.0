From: akpm@linux-foundation.org
Subject: [merged]
 mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch removed
 from -mm tree
Date: Tue, 09 Jun 2020 17:38:39 -0700
Message-ID: <20200610003839.rhmPJcV1_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFJAit (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:38:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@kernel.org, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm: don't include asm/pgtable.h if linux/mm.h is already included
has been removed from the -mm tree.  Its filename was
     mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: don't include asm/pgtable.h if linux/mm.h is already included

Patch series "mm: consolidate definitions of page table accessors", v2.

The low level page table accessors (pXY_index(), pXY_offset()) are
duplicated across all architectures and sometimes more than once.  For
instance, we have 31 definition of pgd_offset() for 25 supported
architectures.

Most of these definitions are actually identical and typically it boils
down to, e.g. 

static inline unsigned long pmd_index(unsigned long address)
{
        return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
}

static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
{
        return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(address);
}

These definitions can be shared among 90% of the arches provided
XYZ_SHIFT, PTRS_PER_XYZ and xyz_page_vaddr() are defined.

For architectures that really need a custom version there is always
possibility to override the generic version with the usual ifdefs magic.

These patches introduce include/linux/pgtable.h that replaces
include/asm-generic/pgtable.h and add the definitions of the page table
accessors to the new header.  


This patch (of 12):

The linux/mm.h header includes <asm/pgtable.h> to allow inlining of the
functions involving page table manipulations, e.g.  pte_alloc() and
pmd_alloc().  So, there is no point to explicitly include <asm/pgtable.h>
in the files that include <linux/mm.h>.

The include statements in such cases are remove with a simple loop:

	for f in $(git grep -l "include <linux/mm.h>") ; do
		sed -i -e '/include <asm\/pgtable.h>/ d' $f
	done

Link: http://lkml.kernel.org/r/20200514170327.31389-1-rppt@kernel.org
Link: http://lkml.kernel.org/r/20200514170327.31389-2-rppt@kernel.org
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
Cc: Mike Rapoport <rppt@kernel.org>
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

 arch/alpha/boot/bootp.c                       |    1 -
 arch/alpha/boot/bootpz.c                      |    1 -
 arch/alpha/boot/main.c                        |    1 -
 arch/alpha/include/asm/io.h                   |    1 -
 arch/alpha/kernel/process.c                   |    1 -
 arch/alpha/kernel/ptrace.c                    |    1 -
 arch/alpha/kernel/setup.c                     |    1 -
 arch/alpha/kernel/smp.c                       |    1 -
 arch/alpha/kernel/sys_alcor.c                 |    1 -
 arch/alpha/kernel/sys_cabriolet.c             |    1 -
 arch/alpha/kernel/sys_dp264.c                 |    1 -
 arch/alpha/kernel/sys_eb64p.c                 |    1 -
 arch/alpha/kernel/sys_eiger.c                 |    1 -
 arch/alpha/kernel/sys_jensen.c                |    1 -
 arch/alpha/kernel/sys_marvel.c                |    1 -
 arch/alpha/kernel/sys_miata.c                 |    1 -
 arch/alpha/kernel/sys_mikasa.c                |    1 -
 arch/alpha/kernel/sys_nautilus.c              |    1 -
 arch/alpha/kernel/sys_noritake.c              |    1 -
 arch/alpha/kernel/sys_rawhide.c               |    1 -
 arch/alpha/kernel/sys_ruffian.c               |    1 -
 arch/alpha/kernel/sys_rx164.c                 |    1 -
 arch/alpha/kernel/sys_sable.c                 |    1 -
 arch/alpha/kernel/sys_sio.c                   |    1 -
 arch/alpha/kernel/sys_sx164.c                 |    1 -
 arch/alpha/kernel/sys_takara.c                |    1 -
 arch/alpha/kernel/sys_titan.c                 |    1 -
 arch/alpha/kernel/sys_wildfire.c              |    1 -
 arch/alpha/mm/init.c                          |    1 -
 arch/arm/kernel/machine_kexec.c               |    1 -
 arch/arm/kernel/module.c                      |    1 -
 arch/arm/kernel/ptrace.c                      |    1 -
 arch/arm/kernel/smp.c                         |    1 -
 arch/arm/mach-ebsa110/core.c                  |    1 -
 arch/arm/mach-footbridge/common.c             |    1 -
 arch/arm/mach-imx/mm-imx21.c                  |    1 -
 arch/arm/mach-imx/mm-imx27.c                  |    1 -
 arch/arm/mach-imx/mm-imx3.c                   |    1 -
 arch/arm/mach-iop32x/i2c.c                    |    1 -
 arch/arm/mach-iop32x/iq31244.c                |    1 -
 arch/arm/mach-iop32x/iq80321.c                |    1 -
 arch/arm/mach-iop32x/n2100.c                  |    1 -
 arch/arm/mach-ixp4xx/common.c                 |    1 -
 arch/arm/mach-sa1100/assabet.c                |    1 -
 arch/arm/mm/copypage-v4mc.c                   |    1 -
 arch/arm/mm/copypage-v6.c                     |    1 -
 arch/arm/mm/copypage-xscale.c                 |    1 -
 arch/arm/mm/dump.c                            |    1 -
 arch/arm/mm/fault-armv.c                      |    1 -
 arch/arm/mm/fault.c                           |    1 -
 arch/arm/mm/pageattr.c                        |    1 -
 arch/arm64/kernel/hibernate.c                 |    1 -
 arch/arm64/kernel/ptrace.c                    |    1 -
 arch/arm64/kernel/smp.c                       |    1 -
 arch/arm64/mm/dump.c                          |    1 -
 arch/arm64/mm/fault.c                         |    1 -
 arch/arm64/mm/kasan_init.c                    |    1 -
 arch/arm64/mm/pageattr.c                      |    1 -
 arch/csky/kernel/module.c                     |    1 -
 arch/csky/kernel/ptrace.c                     |    1 -
 arch/csky/mm/init.c                           |    1 -
 arch/csky/mm/tlb.c                            |    1 -
 arch/h8300/kernel/process.c                   |    1 -
 arch/h8300/kernel/setup.c                     |    1 -
 arch/h8300/kernel/signal.c                    |    1 -
 arch/h8300/mm/fault.c                         |    1 -
 arch/h8300/mm/init.c                          |    1 -
 arch/h8300/mm/memory.c                        |    1 -
 arch/hexagon/mm/vm_fault.c                    |    1 -
 arch/ia64/kernel/efi.c                        |    1 -
 arch/ia64/kernel/ptrace.c                     |    1 -
 arch/ia64/kernel/smp.c                        |    1 -
 arch/ia64/kernel/smpboot.c                    |    1 -
 arch/ia64/mm/contig.c                         |    1 -
 arch/ia64/mm/fault.c                          |    1 -
 arch/m68k/68000/timers.c                      |    1 -
 arch/m68k/amiga/config.c                      |    1 -
 arch/m68k/apollo/config.c                     |    1 -
 arch/m68k/atari/atasound.c                    |    1 -
 arch/m68k/atari/stram.c                       |    1 -
 arch/m68k/bvme6000/config.c                   |    1 -
 arch/m68k/kernel/process.c                    |    1 -
 arch/m68k/kernel/ptrace.c                     |    1 -
 arch/m68k/kernel/setup_no.c                   |    1 -
 arch/m68k/kernel/signal.c                     |    1 -
 arch/m68k/kernel/uboot.c                      |    1 -
 arch/m68k/mac/config.c                        |    1 -
 arch/m68k/mm/mcfmmu.c                         |    1 -
 arch/m68k/mm/sun3kmap.c                       |    1 -
 arch/m68k/mm/sun3mmu.c                        |    1 -
 arch/m68k/mvme147/config.c                    |    1 -
 arch/m68k/mvme16x/config.c                    |    1 -
 arch/m68k/q40/config.c                        |    1 -
 arch/m68k/sun3/config.c                       |    1 -
 arch/m68k/sun3/dvma.c                         |    1 -
 arch/m68k/sun3/mmu_emu.c                      |    1 -
 arch/m68k/sun3/sun3dvma.c                     |    1 -
 arch/m68k/sun3x/dvma.c                        |    1 -
 arch/m68k/sun3x/prom.c                        |    1 -
 arch/microblaze/kernel/signal.c               |    1 -
 arch/microblaze/mm/fault.c                    |    1 -
 arch/mips/fw/arc/memory.c                     |    1 -
 arch/mips/include/asm/mach-generic/floppy.h   |    1 -
 arch/mips/include/asm/mach-jazz/floppy.h      |    1 -
 arch/mips/jazz/jazzdma.c                      |    1 -
 arch/mips/kernel/module.c                     |    1 -
 arch/mips/kernel/process.c                    |    1 -
 arch/mips/kernel/ptrace.c                     |    1 -
 arch/mips/kernel/ptrace32.c                   |    1 -
 arch/mips/kernel/smp-bmips.c                  |    1 -
 arch/mips/kernel/traps.c                      |    1 -
 arch/mips/kvm/tlb.c                           |    1 -
 arch/mips/lib/dump_tlb.c                      |    1 -
 arch/mips/lib/r3k_dump_tlb.c                  |    1 -
 arch/mips/mm/c-octeon.c                       |    1 -
 arch/mips/mm/c-r3k.c                          |    1 -
 arch/mips/mm/c-r4k.c                          |    1 -
 arch/mips/mm/c-tx39.c                         |    1 -
 arch/mips/mm/init.c                           |    1 -
 arch/mips/mm/page.c                           |    1 -
 arch/mips/mm/pgtable-32.c                     |    1 -
 arch/mips/mm/pgtable-64.c                     |    1 -
 arch/mips/mm/sc-ip22.c                        |    1 -
 arch/mips/mm/sc-mips.c                        |    1 -
 arch/mips/mm/sc-r5k.c                         |    1 -
 arch/mips/mm/tlb-r3k.c                        |    1 -
 arch/mips/mm/tlb-r4k.c                        |    1 -
 arch/mips/sgi-ip27/ip27-init.c                |    1 -
 arch/mips/sgi-ip27/ip27-timer.c               |    1 -
 arch/mips/sgi-ip32/ip32-memory.c              |    1 -
 arch/nds32/mm/fault.c                         |    1 -
 arch/nds32/mm/proc.c                          |    1 -
 arch/nios2/kernel/module.c                    |    1 -
 arch/nios2/mm/init.c                          |    1 -
 arch/nios2/mm/pgtable.c                       |    1 -
 arch/nios2/mm/tlb.c                           |    1 -
 arch/openrisc/include/asm/tlbflush.h          |    1 -
 arch/openrisc/kernel/asm-offsets.c            |    1 -
 arch/openrisc/kernel/process.c                |    1 -
 arch/openrisc/kernel/ptrace.c                 |    1 -
 arch/openrisc/kernel/setup.c                  |    1 -
 arch/openrisc/kernel/traps.c                  |    1 -
 arch/openrisc/mm/init.c                       |    1 -
 arch/openrisc/mm/tlb.c                        |    1 -
 arch/parisc/include/asm/mmu_context.h         |    1 -
 arch/parisc/kernel/module.c                   |    1 -
 arch/parisc/kernel/ptrace.c                   |    1 -
 arch/parisc/kernel/smp.c                      |    1 -
 arch/parisc/mm/init.c                         |    1 -
 arch/powerpc/include/asm/io.h                 |    1 -
 arch/powerpc/kernel/asm-offsets.c             |    1 -
 arch/powerpc/kernel/process.c                 |    1 -
 arch/powerpc/kernel/signal_32.c               |    1 -
 arch/powerpc/kernel/signal_64.c               |    1 -
 arch/powerpc/kernel/traps.c                   |    1 -
 arch/powerpc/kernel/vdso.c                    |    1 -
 arch/powerpc/lib/code-patching.c              |    1 -
 arch/powerpc/mm/book3s64/hash_hugetlbpage.c   |    1 -
 arch/powerpc/mm/book3s64/hash_pgtable.c       |    1 -
 arch/powerpc/mm/book3s64/radix_hugetlbpage.c  |    1 -
 arch/powerpc/mm/book3s64/radix_pgtable.c      |    1 -
 arch/powerpc/mm/fault.c                       |    1 -
 arch/powerpc/mm/hugetlbpage.c                 |    1 -
 arch/powerpc/mm/init_32.c                     |    1 -
 arch/powerpc/mm/init_64.c                     |    1 -
 arch/powerpc/mm/mem.c                         |    1 -
 arch/powerpc/mm/nohash/40x.c                  |    1 -
 arch/powerpc/mm/nohash/fsl_booke.c            |    1 -
 arch/powerpc/mm/pgtable_32.c                  |    1 -
 arch/powerpc/mm/pgtable_64.c                  |    1 -
 arch/powerpc/mm/ptdump/hashpagetable.c        |    1 -
 arch/powerpc/mm/ptdump/ptdump.c               |    1 -
 arch/powerpc/perf/callchain.c                 |    1 -
 arch/powerpc/perf/callchain_32.c              |    1 -
 arch/powerpc/perf/callchain_64.c              |    1 -
 arch/powerpc/platforms/8xx/cpm1.c             |    1 -
 arch/powerpc/platforms/8xx/micropatch.c       |    1 -
 arch/powerpc/platforms/cell/setup.c           |    1 -
 arch/powerpc/platforms/chrp/setup.c           |    1 -
 arch/powerpc/platforms/maple/setup.c          |    1 -
 arch/powerpc/platforms/maple/time.c           |    1 -
 arch/powerpc/platforms/powermac/setup.c       |    1 -
 arch/powerpc/platforms/powermac/time.c        |    1 -
 arch/powerpc/platforms/pseries/setup.c        |    1 -
 arch/powerpc/sysdev/cpm2.c                    |    1 -
 arch/powerpc/xmon/xmon.c                      |    1 -
 arch/riscv/kernel/setup.c                     |    1 -
 arch/riscv/mm/init.c                          |    1 -
 arch/s390/include/asm/tlbflush.h              |    1 -
 arch/s390/kernel/machine_kexec.c              |    1 -
 arch/s390/kernel/ptrace.c                     |    1 -
 arch/s390/kernel/vdso.c                       |    1 -
 arch/s390/mm/dump_pagetables.c                |    1 -
 arch/s390/mm/fault.c                          |    1 -
 arch/s390/mm/init.c                           |    1 -
 arch/s390/mm/pageattr.c                       |    1 -
 arch/s390/mm/pgtable.c                        |    1 -
 arch/s390/mm/vmem.c                           |    1 -
 arch/sh/kernel/machine_kexec.c                |    1 -
 arch/sh/kernel/ptrace_32.c                    |    1 -
 arch/sh/kernel/signal_32.c                    |    1 -
 arch/sh/mm/cache-sh3.c                        |    1 -
 arch/sh/mm/cache-sh4.c                        |    1 -
 arch/sh/mm/cache-sh7705.c                     |    1 -
 arch/sh/mm/nommu.c                            |    1 -
 arch/sparc/kernel/leon_smp.c                  |    1 -
 arch/sparc/kernel/process_32.c                |    1 -
 arch/sparc/kernel/process_64.c                |    1 -
 arch/sparc/kernel/ptrace_32.c                 |    1 -
 arch/sparc/kernel/ptrace_64.c                 |    1 -
 arch/sparc/kernel/setup_32.c                  |    1 -
 arch/sparc/kernel/setup_64.c                  |    1 -
 arch/sparc/kernel/signal32.c                  |    1 -
 arch/sparc/kernel/signal_32.c                 |    1 -
 arch/sparc/kernel/signal_64.c                 |    1 -
 arch/sparc/kernel/smp_32.c                    |    1 -
 arch/sparc/kernel/smp_64.c                    |    1 -
 arch/sparc/kernel/traps_64.c                  |    1 -
 arch/sparc/mm/fault_32.c                      |    1 -
 arch/sparc/mm/fault_64.c                      |    1 -
 arch/sparc/mm/hugetlbpage.c                   |    1 -
 arch/sparc/mm/init_32.c                       |    1 -
 arch/sparc/mm/init_64.c                       |    1 -
 arch/sparc/mm/io-unit.c                       |    1 -
 arch/sparc/mm/iommu.c                         |    1 -
 arch/sparc/mm/tlb.c                           |    1 -
 arch/um/kernel/process.c                      |    1 -
 arch/um/kernel/skas/mmu.c                     |    1 -
 arch/um/kernel/skas/uaccess.c                 |    1 -
 arch/um/kernel/tlb.c                          |    1 -
 arch/um/kernel/trap.c                         |    1 -
 arch/um/kernel/um_arch.c                      |    1 -
 arch/unicore32/kernel/module.c                |    1 -
 arch/unicore32/mm/fault.c                     |    1 -
 arch/x86/include/asm/iomap.h                  |    1 -
 arch/x86/include/asm/xen/page.h               |    1 -
 arch/x86/kernel/alternative.c                 |    1 -
 arch/x86/kernel/amd_gart_64.c                 |    1 -
 arch/x86/kernel/doublefault_32.c              |    1 -
 arch/x86/kernel/machine_kexec_32.c            |    1 -
 arch/x86/kernel/machine_kexec_64.c            |    1 -
 arch/x86/kernel/module.c                      |    1 -
 arch/x86/kernel/process_32.c                  |    1 -
 arch/x86/kernel/process_64.c                  |    1 -
 arch/x86/kernel/ptrace.c                      |    1 -
 arch/x86/kernel/tboot.c                       |    1 -
 arch/x86/mm/dump_pagetables.c                 |    1 -
 arch/x86/mm/init_32.c                         |    1 -
 arch/x86/mm/init_64.c                         |    1 -
 arch/x86/mm/kasan_init_64.c                   |    1 -
 arch/x86/mm/pat/cpa-test.c                    |    1 -
 arch/x86/mm/pat/memtype.c                     |    1 -
 arch/x86/mm/pgtable.c                         |    1 -
 arch/x86/mm/pgtable_32.c                      |    1 -
 arch/x86/mm/pti.c                             |    1 -
 arch/x86/platform/efi/efi_64.c                |    1 -
 arch/x86/xen/enlighten_pv.c                   |    1 -
 arch/x86/xen/grant-table.c                    |    1 -
 arch/xtensa/kernel/process.c                  |    1 -
 arch/xtensa/kernel/ptrace.c                   |    1 -
 arch/xtensa/kernel/setup.c                    |    1 -
 drivers/char/agp/frontend.c                   |    1 -
 drivers/char/agp/generic.c                    |    1 -
 drivers/char/bsr.c                            |    1 -
 drivers/char/mspec.c                          |    1 -
 drivers/gpu/drm/i915/i915_mm.c                |    1 -
 drivers/infiniband/sw/rdmavt/mmap.c           |    1 -
 drivers/infiniband/sw/rxe/rxe_mmap.c          |    1 -
 drivers/media/platform/davinci/vpbe_display.c |    1 -
 drivers/media/v4l2-core/v4l2-common.c         |    1 -
 drivers/misc/sgi-gru/grufault.c               |    1 -
 drivers/net/ethernet/sun/sunhme.c             |    1 -
 drivers/sbus/char/flash.c                     |    1 -
 drivers/sbus/char/uctrl.c                     |    1 -
 drivers/scsi/a2091.c                          |    1 -
 drivers/scsi/a3000.c                          |    1 -
 drivers/scsi/gvp11.c                          |    1 -
 drivers/scsi/lasi700.c                        |    1 -
 drivers/scsi/mvme147.c                        |    1 -
 drivers/scsi/sni_53c710.c                     |    1 -
 drivers/video/console/newport_con.c           |    1 -
 drivers/video/fbdev/acornfb.c                 |    1 -
 drivers/video/fbdev/atafb.c                   |    1 -
 drivers/video/fbdev/cirrusfb.c                |    1 -
 drivers/video/fbdev/cyber2000fb.c             |    1 -
 drivers/video/fbdev/fb-puv3.c                 |    1 -
 drivers/video/fbdev/hitfb.c                   |    1 -
 drivers/video/fbdev/neofb.c                   |    1 -
 drivers/video/fbdev/q40fb.c                   |    1 -
 drivers/video/fbdev/savage/savagefb_driver.c  |    1 -
 drivers/xen/balloon.c                         |    1 -
 drivers/xen/grant-table.c                     |    1 -
 drivers/xen/privcmd.c                         |    1 -
 drivers/xen/xenbus/xenbus_probe.c             |    1 -
 drivers/xen/xenbus/xenbus_probe_backend.c     |    1 -
 drivers/xen/xenbus/xenbus_probe_frontend.c    |    1 -
 fs/proc/array.c                               |    1 -
 fs/proc/meminfo.c                             |    1 -
 fs/proc/nommu.c                               |    1 -
 fs/proc/vmcore.c                              |    1 -
 include/linux/dax.h                           |    1 -
 init/init_task.c                              |    1 -
 kernel/exit.c                                 |    1 -
 kernel/fork.c                                 |    1 -
 kernel/power/snapshot.c                       |    1 -
 lib/ioremap.c                                 |    1 -
 mm/debug_vm_pgtable.c                         |    1 -
 mm/gup.c                                      |    1 -
 mm/hugetlb.c                                  |    1 -
 mm/memory.c                                   |    1 -
 mm/page_io.c                                  |    1 -
 mm/shmem.c                                    |    1 -
 mm/sparse-vmemmap.c                           |    1 -
 mm/sparse.c                                   |    1 -
 mm/swap_state.c                               |    1 -
 mm/swapfile.c                                 |    1 -
 mm/vmacache.c                                 |    1 -
 sound/core/sgbuf.c                            |    1 -
 virt/kvm/kvm_main.c                           |    1 -
 319 files changed, 319 deletions(-)

--- a/arch/alpha/boot/bootp.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/boot/bootp.c
@@ -16,7 +16,6 @@
 
 #include <asm/console.h>
 #include <asm/hwrpb.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 
 #include <stdarg.h>
--- a/arch/alpha/boot/bootpz.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/boot/bootpz.c
@@ -18,7 +18,6 @@
 
 #include <asm/console.h>
 #include <asm/hwrpb.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 
 #include <stdarg.h>
--- a/arch/alpha/boot/main.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/boot/main.c
@@ -14,7 +14,6 @@
 
 #include <asm/console.h>
 #include <asm/hwrpb.h>
-#include <asm/pgtable.h>
 
 #include <stdarg.h>
 
--- a/arch/alpha/include/asm/io.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/include/asm/io.h
@@ -7,7 +7,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <asm/compiler.h>
-#include <asm/pgtable.h>
 #include <asm/machvec.h>
 #include <asm/hwrpb.h>
 
--- a/arch/alpha/kernel/process.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/process.c
@@ -37,7 +37,6 @@
 #include <asm/reg.h>
 #include <linux/uaccess.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/hwrpb.h>
 #include <asm/fpu.h>
 
--- a/arch/alpha/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/ptrace.c
@@ -19,7 +19,6 @@
 #include <linux/audit.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/fpu.h>
 
 #include "proto.h"
--- a/arch/alpha/kernel/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/setup.c
@@ -55,7 +55,6 @@ static struct notifier_block alpha_panic
 };
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/hwrpb.h>
 #include <asm/dma.h>
 #include <asm/mmu_context.h>
--- a/arch/alpha/kernel/smp.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/smp.c
@@ -36,7 +36,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_alcor.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_alcor.c
@@ -23,7 +23,6 @@
 #include <asm/dma.h>
 #include <asm/mmu_context.h>
 #include <asm/irq.h>
-#include <asm/pgtable.h>
 #include <asm/core_cia.h>
 #include <asm/tlbflush.h>
 
--- a/arch/alpha/kernel/sys_cabriolet.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_cabriolet.c
@@ -23,7 +23,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_apecs.h>
 #include <asm/core_cia.h>
 #include <asm/core_lca.h>
--- a/arch/alpha/kernel/sys_dp264.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_dp264.c
@@ -26,7 +26,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_tsunami.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_eb64p.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_eb64p.c
@@ -22,7 +22,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_apecs.h>
 #include <asm/core_lca.h>
 #include <asm/hwrpb.h>
--- a/arch/alpha/kernel/sys_eiger.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_eiger.c
@@ -23,7 +23,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_tsunami.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_jensen.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_jensen.c
@@ -25,7 +25,6 @@
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
 #include "proto.h"
--- a/arch/alpha/kernel/sys_marvel.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_marvel.c
@@ -18,7 +18,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_marvel.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_miata.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_miata.c
@@ -22,7 +22,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_cia.h>
 #include <asm/tlbflush.h>
 
--- a/arch/alpha/kernel/sys_mikasa.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_mikasa.c
@@ -23,7 +23,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_apecs.h>
 #include <asm/core_cia.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_nautilus.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_nautilus.c
@@ -40,7 +40,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_irongate.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_noritake.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_noritake.c
@@ -24,7 +24,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_apecs.h>
 #include <asm/core_cia.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_rawhide.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_rawhide.c
@@ -21,7 +21,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_mcpcia.h>
 #include <asm/tlbflush.h>
 
--- a/arch/alpha/kernel/sys_ruffian.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_ruffian.c
@@ -23,7 +23,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_cia.h>
 #include <asm/tlbflush.h>
 
--- a/arch/alpha/kernel/sys_rx164.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_rx164.c
@@ -22,7 +22,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_polaris.h>
 #include <asm/tlbflush.h>
 
--- a/arch/alpha/kernel/sys_sable.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_sable.c
@@ -21,7 +21,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_t2.h>
 #include <asm/tlbflush.h>
 
--- a/arch/alpha/kernel/sys_sio.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_sio.c
@@ -25,7 +25,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_apecs.h>
 #include <asm/core_lca.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_sx164.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_sx164.c
@@ -22,7 +22,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_cia.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_takara.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_takara.c
@@ -21,7 +21,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_cia.h>
 #include <asm/tlbflush.h>
 
--- a/arch/alpha/kernel/sys_titan.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_titan.c
@@ -26,7 +26,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_titan.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/kernel/sys_wildfire.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/kernel/sys_wildfire.c
@@ -20,7 +20,6 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/core_wildfire.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
--- a/arch/alpha/mm/init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/alpha/mm/init.c
@@ -24,7 +24,6 @@
 #include <linux/gfp.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/hwrpb.h>
 #include <asm/dma.h>
--- a/arch/arm64/kernel/hibernate.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm64/kernel/hibernate.c
@@ -32,7 +32,6 @@
 #include <asm/memory.h>
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/sections.h>
 #include <asm/smp.h>
--- a/arch/arm64/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm64/kernel/ptrace.c
@@ -34,7 +34,6 @@
 #include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/fpsimd.h>
-#include <asm/pgtable.h>
 #include <asm/pointer_auth.h>
 #include <asm/stacktrace.h>
 #include <asm/syscall.h>
--- a/arch/arm64/kernel/smp.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm64/kernel/smp.c
@@ -43,7 +43,6 @@
 #include <asm/kvm_mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/numa.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/smp_plat.h>
--- a/arch/arm64/mm/dump.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm64/mm/dump.c
@@ -22,7 +22,6 @@
 #include <asm/fixmap.h>
 #include <asm/kasan.h>
 #include <asm/memory.h>
-#include <asm/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/ptdump.h>
 
--- a/arch/arm64/mm/fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm64/mm/fault.c
@@ -36,7 +36,6 @@
 #include <asm/processor.h>
 #include <asm/sysreg.h>
 #include <asm/system_misc.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
 
--- a/arch/arm64/mm/kasan_init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm64/mm/kasan_init.c
@@ -18,7 +18,6 @@
 #include <asm/kernel-pgtable.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
 
--- a/arch/arm64/mm/pageattr.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm64/mm/pageattr.c
@@ -8,7 +8,6 @@
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 
-#include <asm/pgtable.h>
 #include <asm/set_memory.h>
 #include <asm/tlbflush.h>
 
--- a/arch/arm/kernel/machine_kexec.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/kernel/machine_kexec.c
@@ -10,7 +10,6 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/memblock.h>
-#include <asm/pgtable.h>
 #include <linux/of_fdt.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
--- a/arch/arm/kernel/module.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/kernel/module.c
@@ -17,7 +17,6 @@
 #include <linux/string.h>
 #include <linux/gfp.h>
 
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 #include <asm/smp_plat.h>
 #include <asm/unwind.h>
--- a/arch/arm/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/kernel/ptrace.c
@@ -25,7 +25,6 @@
 #include <linux/tracehook.h>
 #include <linux/unistd.h>
 
-#include <asm/pgtable.h>
 #include <asm/traps.h>
 
 #define CREATE_TRACE_POINTS
--- a/arch/arm/kernel/smp.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/kernel/smp.c
@@ -37,7 +37,6 @@
 #include <asm/idmap.h>
 #include <asm/topology.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/procinfo.h>
 #include <asm/processor.h>
--- a/arch/arm/mach-ebsa110/core.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-ebsa110/core.c
@@ -17,7 +17,6 @@
 #include <asm/irq.h>
 #include <asm/setup.h>
 #include <asm/mach-types.h>
-#include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/system_misc.h>
 
--- a/arch/arm/mach-footbridge/common.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-footbridge/common.c
@@ -14,7 +14,6 @@
 #include <linux/spinlock.h>
 #include <video/vga.h>
 
-#include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/irq.h>
 #include <asm/mach-types.h>
--- a/arch/arm/mach-imx/mm-imx21.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-imx/mm-imx21.c
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/pinctrl/machine.h>
-#include <asm/pgtable.h>
 #include <asm/mach/map.h>
 
 #include "common.h"
--- a/arch/arm/mach-imx/mm-imx27.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-imx/mm-imx27.c
@@ -8,7 +8,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/pinctrl/machine.h>
-#include <asm/pgtable.h>
 #include <asm/mach/map.h>
 
 #include "common.h"
--- a/arch/arm/mach-imx/mm-imx3.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-imx/mm-imx3.c
@@ -13,7 +13,6 @@
 #include <linux/io.h>
 #include <linux/pinctrl/machine.h>
 
-#include <asm/pgtable.h>
 #include <asm/system_misc.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach/map.h>
--- a/arch/arm/mach-iop32x/i2c.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-iop32x/i2c.c
@@ -17,7 +17,6 @@
 #include <linux/serial_core.h>
 #include <linux/io.h>
 #include <linux/gpio/machine.h>
-#include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/mach/map.h>
 #include <asm/setup.h>
--- a/arch/arm/mach-iop32x/iq31244.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-iop32x/iq31244.c
@@ -31,7 +31,6 @@
 #include <asm/mach/time.h>
 #include <asm/mach-types.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 
 #include "hardware.h"
 #include "irqs.h"
--- a/arch/arm/mach-iop32x/iq80321.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-iop32x/iq80321.c
@@ -27,7 +27,6 @@
 #include <asm/mach/time.h>
 #include <asm/mach-types.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 
 #include "hardware.h"
 #include "irqs.h"
--- a/arch/arm/mach-iop32x/n2100.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-iop32x/n2100.c
@@ -35,7 +35,6 @@
 #include <asm/mach/time.h>
 #include <asm/mach-types.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 
 #include "hardware.h"
 #include "irqs.h"
--- a/arch/arm/mach-ixp4xx/common.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -33,7 +33,6 @@
 #include <mach/hardware.h>
 #include <mach/io.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/exception.h>
 #include <asm/irq.h>
--- a/arch/arm/mach-sa1100/assabet.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mach-sa1100/assabet.c
@@ -34,7 +34,6 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
 #include <asm/mach/arch.h>
--- a/arch/arm/mm/copypage-v4mc.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mm/copypage-v4mc.c
@@ -14,7 +14,6 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
--- a/arch/arm/mm/copypage-v6.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mm/copypage-v6.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 
-#include <asm/pgtable.h>
 #include <asm/shmparam.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
--- a/arch/arm/mm/copypage-xscale.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mm/copypage-xscale.c
@@ -14,7 +14,6 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
--- a/arch/arm/mm/dump.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mm/dump.c
@@ -16,7 +16,6 @@
 #include <asm/domain.h>
 #include <asm/fixmap.h>
 #include <asm/memory.h>
-#include <asm/pgtable.h>
 #include <asm/ptdump.h>
 
 static struct addr_marker address_markers[] = {
--- a/arch/arm/mm/fault-armv.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mm/fault-armv.c
@@ -17,7 +17,6 @@
 #include <asm/bugs.h>
 #include <asm/cacheflush.h>
 #include <asm/cachetype.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
 #include "mm.h"
--- a/arch/arm/mm/fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mm/fault.c
@@ -18,7 +18,6 @@
 #include <linux/highmem.h>
 #include <linux/perf_event.h>
 
-#include <asm/pgtable.h>
 #include <asm/system_misc.h>
 #include <asm/system_info.h>
 #include <asm/tlbflush.h>
--- a/arch/arm/mm/pageattr.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/arm/mm/pageattr.c
@@ -5,7 +5,6 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/set_memory.h>
 
--- a/arch/csky/kernel/module.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/csky/kernel/module.c
@@ -10,7 +10,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
-#include <asm/pgtable.h>
 
 #ifdef CONFIG_CPU_CK810
 #define IS_BSR32(hi16, lo16)		(((hi16) & 0xFC00) == 0xE000)
--- a/arch/csky/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/csky/kernel/ptrace.c
@@ -18,7 +18,6 @@
 
 #include <asm/thread_info.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/asm-offsets.h>
 
--- a/arch/csky/mm/init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/csky/mm/init.c
@@ -24,7 +24,6 @@
 #include <asm/setup.h>
 #include <asm/cachectl.h>
 #include <asm/dma.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/sections.h>
--- a/arch/csky/mm/tlb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/csky/mm/tlb.c
@@ -7,7 +7,6 @@
 #include <linux/sched.h>
 
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/setup.h>
 
 /*
--- a/arch/h8300/kernel/process.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/h8300/kernel/process.c
@@ -45,7 +45,6 @@
 #include <linux/uaccess.h>
 #include <asm/traps.h>
 #include <asm/setup.h>
-#include <asm/pgtable.h>
 
 void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
--- a/arch/h8300/kernel/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/h8300/kernel/setup.c
@@ -31,7 +31,6 @@
 
 #include <asm/setup.h>
 #include <asm/irq.h>
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 #include <asm/page.h>
 
--- a/arch/h8300/kernel/signal.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/h8300/kernel/signal.c
@@ -43,7 +43,6 @@
 
 #include <asm/setup.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/traps.h>
 #include <asm/ucontext.h>
 
--- a/arch/h8300/mm/fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/h8300/mm/fault.c
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
 
-#include <asm/pgtable.h>
 
 void die(const char *str, struct pt_regs *fp, unsigned long err);
 
--- a/arch/h8300/mm/init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/h8300/mm/init.c
@@ -36,7 +36,6 @@
 #include <asm/setup.h>
 #include <asm/segment.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 
 /*
--- a/arch/h8300/mm/memory.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/h8300/mm/memory.c
@@ -26,7 +26,6 @@
 #include <asm/setup.h>
 #include <asm/segment.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/traps.h>
 #include <asm/io.h>
 
--- a/arch/hexagon/mm/vm_fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/hexagon/mm/vm_fault.c
@@ -11,7 +11,6 @@
  * execptions.
  */
 
-#include <asm/pgtable.h>
 #include <asm/traps.h>
 #include <linux/uaccess.h>
 #include <linux/mm.h>
--- a/arch/ia64/kernel/efi.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/ia64/kernel/efi.c
@@ -37,7 +37,6 @@
 #include <asm/io.h>
 #include <asm/kregs.h>
 #include <asm/meminit.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/mca.h>
 #include <asm/setup.h>
--- a/arch/ia64/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/ia64/kernel/ptrace.c
@@ -25,7 +25,6 @@
 #include <linux/elf.h>
 #include <linux/tracehook.h>
 
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/ptrace_offsets.h>
 #include <asm/rse.h>
--- a/arch/ia64/kernel/smpboot.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/ia64/kernel/smpboot.c
@@ -50,7 +50,6 @@
 #include <asm/mca.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/sal.h>
--- a/arch/ia64/kernel/smp.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/ia64/kernel/smp.c
@@ -40,7 +40,6 @@
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/sal.h>
--- a/arch/ia64/mm/contig.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/ia64/mm/contig.c
@@ -22,7 +22,6 @@
 
 #include <asm/meminit.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 #include <asm/mca.h>
 
--- a/arch/ia64/mm/fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/ia64/mm/fault.c
@@ -15,7 +15,6 @@
 #include <linux/prefetch.h>
 #include <linux/uaccess.h>
 
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/exception.h>
 
--- a/arch/m68k/68000/timers.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/68000/timers.c
@@ -22,7 +22,6 @@
 #include <linux/clocksource.h>
 #include <linux/rtc.h>
 #include <asm/setup.h>
-#include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/MC68VZ328.h>
 
--- a/arch/m68k/amiga/config.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/amiga/config.c
@@ -32,7 +32,6 @@
 #include <asm/bootinfo-amiga.h>
 #include <asm/byteorder.h>
 #include <asm/setup.h>
-#include <asm/pgtable.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
 #include <asm/irq.h>
--- a/arch/m68k/apollo/config.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/apollo/config.c
@@ -13,7 +13,6 @@
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-apollo.h>
 #include <asm/byteorder.h>
-#include <asm/pgtable.h>
 #include <asm/apollohw.h>
 #include <asm/irq.h>
 #include <asm/machdep.h>
--- a/arch/m68k/atari/atasound.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/atari/atasound.c
@@ -26,7 +26,6 @@
 
 #include <asm/atarihw.h>
 #include <asm/irq.h>
-#include <asm/pgtable.h>
 #include <asm/atariints.h>
 
 
--- a/arch/m68k/atari/stram.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/atari/stram.c
@@ -26,7 +26,6 @@
 #include <asm/setup.h>
 #include <asm/machdep.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/atarihw.h>
 #include <asm/atari_stram.h>
 #include <asm/io.h>
--- a/arch/m68k/bvme6000/config.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/bvme6000/config.c
@@ -31,7 +31,6 @@
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-vme.h>
 #include <asm/byteorder.h>
-#include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
--- a/arch/m68k/kernel/process.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/kernel/process.c
@@ -36,7 +36,6 @@
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/setup.h>
-#include <asm/pgtable.h>
 
 
 asmlinkage void ret_from_fork(void);
--- a/arch/m68k/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/kernel/ptrace.c
@@ -23,7 +23,6 @@
 
 #include <linux/uaccess.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 
 /*
--- a/arch/m68k/kernel/setup_no.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/kernel/setup_no.c
@@ -38,7 +38,6 @@
 #include <asm/bootinfo.h>
 #include <asm/irq.h>
 #include <asm/machdep.h>
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 
 unsigned long memory_start;
--- a/arch/m68k/kernel/signal.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/kernel/signal.c
@@ -47,7 +47,6 @@
 
 #include <asm/setup.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/traps.h>
 #include <asm/ucontext.h>
 #include <asm/cacheflush.h>
--- a/arch/m68k/kernel/uboot.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/kernel/uboot.c
@@ -26,7 +26,6 @@
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/machdep.h>
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 
 /*
--- a/arch/m68k/mac/config.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/mac/config.c
@@ -36,7 +36,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/pgtable.h>
 #include <asm/machdep.h>
 
 #include <asm/macintosh.h>
--- a/arch/m68k/mm/mcfmmu.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/mm/mcfmmu.c
@@ -17,7 +17,6 @@
 
 #include <asm/setup.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/mcf_pgalloc.h>
 #include <asm/tlbflush.h>
--- a/arch/m68k/mm/sun3kmap.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/mm/sun3kmap.c
@@ -15,7 +15,6 @@
 #include <linux/vmalloc.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/sun3mmu.h>
 
--- a/arch/m68k/mm/sun3mmu.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/mm/sun3mmu.c
@@ -21,7 +21,6 @@
 #include <asm/setup.h>
 #include <linux/uaccess.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
 
--- a/arch/m68k/mvme147/config.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/mvme147/config.c
@@ -29,7 +29,6 @@
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-vme.h>
 #include <asm/byteorder.h>
-#include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
--- a/arch/m68k/mvme16x/config.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/mvme16x/config.c
@@ -32,7 +32,6 @@
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-vme.h>
 #include <asm/byteorder.h>
-#include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
--- a/arch/m68k/q40/config.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/q40/config.c
@@ -29,7 +29,6 @@
 
 #include <asm/io.h>
 #include <asm/bootinfo.h>
-#include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
--- a/arch/m68k/sun3/config.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/sun3/config.c
@@ -22,7 +22,6 @@
 #include <asm/setup.h>
 #include <asm/contregs.h>
 #include <asm/movs.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/sun3-head.h>
 #include <asm/sun3mmu.h>
--- a/arch/m68k/sun3/dvma.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/sun3/dvma.c
@@ -14,7 +14,6 @@
 #include <linux/memblock.h>
 #include <linux/list.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/sun3mmu.h>
 #include <asm/dvma.h>
 
--- a/arch/m68k/sun3/mmu_emu.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/sun3/mmu_emu.c
@@ -22,7 +22,6 @@
 #include <asm/traps.h>
 #include <linux/uaccess.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/sun3mmu.h>
 #include <asm/segment.h>
 #include <asm/oplib.h>
--- a/arch/m68k/sun3/sun3dvma.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/sun3/sun3dvma.c
@@ -16,7 +16,6 @@
 #include <linux/list.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/dvma.h>
 
 #undef DVMA_DEBUG
--- a/arch/m68k/sun3x/dvma.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/sun3x/dvma.c
@@ -22,7 +22,6 @@
 #include <asm/dvma.h>
 #include <asm/io.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 
 /* IOMMU support */
--- a/arch/m68k/sun3x/prom.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/m68k/sun3x/prom.c
@@ -10,7 +10,6 @@
 #include <linux/string.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/traps.h>
 #include <asm/sun3xprom.h>
--- a/arch/microblaze/kernel/signal.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/microblaze/kernel/signal.c
@@ -35,7 +35,6 @@
 #include <asm/entry.h>
 #include <asm/ucontext.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <linux/syscalls.h>
 #include <asm/cacheflush.h>
--- a/arch/microblaze/mm/fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/microblaze/mm/fault.c
@@ -30,7 +30,6 @@
 #include <linux/interrupt.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <linux/mmu_context.h>
 #include <linux/uaccess.h>
--- a/arch/mips/fw/arc/memory.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/fw/arc/memory.c
@@ -22,7 +22,6 @@
 
 #include <asm/sgialib.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/bootinfo.h>
 
 #undef DEBUG
--- a/arch/mips/include/asm/mach-generic/floppy.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/include/asm/mach-generic/floppy.h
@@ -21,7 +21,6 @@
 #include <asm/floppy.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/pgtable.h>
 
 /*
  * How to access the FDC's registers.
--- a/arch/mips/include/asm/mach-jazz/floppy.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/include/asm/mach-jazz/floppy.h
@@ -15,7 +15,6 @@
 #include <asm/addrspace.h>
 #include <asm/jazz.h>
 #include <asm/jazzdma.h>
-#include <asm/pgtable.h>
 
 static inline unsigned char fd_inb(unsigned int base, unsigned int reg)
 {
--- a/arch/mips/jazz/jazzdma.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/jazz/jazzdma.c
@@ -24,7 +24,6 @@
 #include <linux/uaccess.h>
 #include <asm/dma.h>
 #include <asm/jazzdma.h>
-#include <asm/pgtable.h>
 
 /*
  * Set this to one to enable additional vdma debug code.
--- a/arch/mips/kernel/module.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/kernel/module.c
@@ -21,7 +21,6 @@
 #include <linux/spinlock.h>
 #include <linux/jump_label.h>
 
-#include <asm/pgtable.h>	/* MODULE_START */
 
 struct mips_hi16 {
 	struct mips_hi16 *next;
--- a/arch/mips/kernel/process.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/kernel/process.c
@@ -42,7 +42,6 @@
 #include <asm/irq.h>
 #include <asm/mips-cps.h>
 #include <asm/msa.h>
-#include <asm/pgtable.h>
 #include <asm/mipsregs.h>
 #include <asm/processor.h>
 #include <asm/reg.h>
--- a/arch/mips/kernel/ptrace32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/kernel/ptrace32.c
@@ -30,7 +30,6 @@
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
-#include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/reg.h>
 #include <asm/syscall.h>
--- a/arch/mips/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/kernel/ptrace.c
@@ -39,7 +39,6 @@
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
-#include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/syscall.h>
--- a/arch/mips/kernel/smp-bmips.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/kernel/smp-bmips.c
@@ -28,7 +28,6 @@
 #include <linux/kexec.h>
 
 #include <asm/time.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/bootinfo.h>
 #include <asm/cacheflush.h>
--- a/arch/mips/kernel/traps.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/kernel/traps.c
@@ -57,7 +57,6 @@
 #include <asm/mipsmtregs.h>
 #include <asm/module.h>
 #include <asm/msa.h>
-#include <asm/pgtable.h>
 #include <asm/ptrace.h>
 #include <asm/sections.h>
 #include <asm/siginfo.h>
--- a/arch/mips/kvm/tlb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/kvm/tlb.c
@@ -21,7 +21,6 @@
 #include <asm/cpu.h>
 #include <asm/bootinfo.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
 #include <asm/tlbdebug.h>
--- a/arch/mips/lib/dump_tlb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/lib/dump_tlb.c
@@ -12,7 +12,6 @@
 #include <asm/mipsregs.h>
 #include <asm/mmu_context.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/tlbdebug.h>
 
 void dump_tlb_regs(void)
--- a/arch/mips/lib/r3k_dump_tlb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/lib/r3k_dump_tlb.c
@@ -12,7 +12,6 @@
 #include <asm/mipsregs.h>
 #include <asm/mmu_context.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/tlbdebug.h>
 
 extern int r3k_have_wired_reg;
--- a/arch/mips/mm/c-octeon.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/c-octeon.c
@@ -20,7 +20,6 @@
 #include <asm/cpu-features.h>
 #include <asm/cpu-type.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/r4kcache.h>
 #include <asm/traps.h>
 #include <asm/mmu_context.h>
--- a/arch/mips/mm/c-r3k.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/c-r3k.c
@@ -16,7 +16,6 @@
 #include <linux/mm.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/isadep.h>
 #include <asm/io.h>
--- a/arch/mips/mm/c-r4k.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/c-r4k.c
@@ -29,7 +29,6 @@
 #include <asm/cpu-type.h>
 #include <asm/io.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/r4kcache.h>
 #include <asm/sections.h>
 #include <asm/mmu_context.h>
--- a/arch/mips/mm/c-tx39.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/c-tx39.c
@@ -17,7 +17,6 @@
 
 #include <asm/cacheops.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/isadep.h>
 #include <asm/io.h>
--- a/arch/mips/mm/init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/init.c
@@ -40,7 +40,6 @@
 #include <asm/maar.h>
 #include <asm/mmu_context.h>
 #include <asm/sections.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
--- a/arch/mips/mm/page.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/page.c
@@ -20,7 +20,6 @@
 #include <asm/inst.h>
 #include <asm/io.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/prefetch.h>
 #include <asm/bootinfo.h>
 #include <asm/mipsregs.h>
--- a/arch/mips/mm/pgtable-32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/pgtable-32.c
@@ -10,7 +10,6 @@
 #include <linux/memblock.h>
 #include <linux/highmem.h>
 #include <asm/fixmap.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
--- a/arch/mips/mm/pgtable-64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/pgtable-64.c
@@ -10,7 +10,6 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <asm/fixmap.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
--- a/arch/mips/mm/sc-ip22.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/sc-ip22.c
@@ -12,7 +12,6 @@
 
 #include <asm/bcache.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/bootinfo.h>
 #include <asm/sgi/ip22.h>
 #include <asm/sgi/mc.h>
--- a/arch/mips/mm/sc-mips.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/sc-mips.c
@@ -12,7 +12,6 @@
 #include <asm/bcache.h>
 #include <asm/cacheops.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/r4kcache.h>
 #include <asm/mips-cps.h>
--- a/arch/mips/mm/sc-r5k.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/sc-r5k.c
@@ -12,7 +12,6 @@
 #include <asm/bcache.h>
 #include <asm/cacheops.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/r4kcache.h>
 
--- a/arch/mips/mm/tlb-r3k.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/tlb-r3k.c
@@ -17,7 +17,6 @@
 #include <linux/mm.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbmisc.h>
 #include <asm/isadep.h>
--- a/arch/mips/mm/tlb-r4k.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/mm/tlb-r4k.c
@@ -21,7 +21,6 @@
 #include <asm/bootinfo.h>
 #include <asm/hazards.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/tlb.h>
 #include <asm/tlbmisc.h>
 
--- a/arch/mips/sgi-ip27/ip27-init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/sgi-ip27/ip27-init.c
@@ -16,7 +16,6 @@
 #include <asm/bootinfo.h>
 #include <asm/cpu.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/sgialib.h>
 #include <asm/time.h>
 #include <asm/sn/agent.h>
--- a/arch/mips/sgi-ip27/ip27-timer.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/sgi-ip27/ip27-timer.c
@@ -19,7 +19,6 @@
 #include <linux/platform_device.h>
 
 #include <asm/time.h>
-#include <asm/pgtable.h>
 #include <asm/sgialib.h>
 #include <asm/sn/klconfig.h>
 #include <asm/sn/arch.h>
--- a/arch/mips/sgi-ip32/ip32-memory.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/mips/sgi-ip32/ip32-memory.c
@@ -14,7 +14,6 @@
 #include <asm/ip32/crime.h>
 #include <asm/bootinfo.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 
 extern void crime_init(void);
--- a/arch/nds32/mm/fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/nds32/mm/fault.c
@@ -11,7 +11,6 @@
 #include <linux/uaccess.h>
 #include <linux/perf_event.h>
 
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
 extern void die(const char *str, struct pt_regs *regs, long err);
--- a/arch/nds32/mm/proc.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/nds32/mm/proc.c
@@ -5,7 +5,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <asm/nds32.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 #include <asm/l2_cache.h>
--- a/arch/nios2/kernel/module.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/nios2/kernel/module.c
@@ -19,7 +19,6 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 
-#include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 
 /*
--- a/arch/nios2/mm/init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/nios2/mm/init.c
@@ -29,7 +29,6 @@
 
 #include <asm/setup.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 #include <asm/tlb.h>
 #include <asm/mmu_context.h>
--- a/arch/nios2/mm/pgtable.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/nios2/mm/pgtable.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#include <asm/pgtable.h>
 #include <asm/cpuinfo.h>
 
 /* pteaddr:
--- a/arch/nios2/mm/tlb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/nios2/mm/tlb.c
@@ -16,7 +16,6 @@
 
 #include <asm/tlb.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/cpuinfo.h>
 
 #define TLB_INDEX_MASK		\
--- a/arch/openrisc/include/asm/tlbflush.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/openrisc/include/asm/tlbflush.h
@@ -17,7 +17,6 @@
 
 #include <linux/mm.h>
 #include <asm/processor.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/current.h>
 #include <linux/sched.h>
--- a/arch/openrisc/kernel/asm-offsets.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/openrisc/kernel/asm-offsets.c
@@ -32,7 +32,6 @@
 #include <linux/thread_info.h>
 #include <linux/kbuild.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 
 int main(void)
--- a/arch/openrisc/kernel/process.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/openrisc/kernel/process.c
@@ -36,7 +36,6 @@
 #include <linux/fs.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/spr_defs.h>
--- a/arch/openrisc/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/openrisc/kernel/ptrace.c
@@ -27,7 +27,6 @@
 
 #include <asm/thread_info.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 
 /*
  * Copy the thread state to a regset that can be interpreted by userspace.
--- a/arch/openrisc/kernel/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/openrisc/kernel/setup.c
@@ -35,7 +35,6 @@
 #include <linux/device.h>
 
 #include <asm/sections.h>
-#include <asm/pgtable.h>
 #include <asm/types.h>
 #include <asm/setup.h>
 #include <asm/io.h>
--- a/arch/openrisc/kernel/traps.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/openrisc/kernel/traps.c
@@ -31,7 +31,6 @@
 #include <linux/uaccess.h>
 
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/unwinder.h>
 #include <asm/sections.h>
 
--- a/arch/openrisc/mm/init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/openrisc/mm/init.c
@@ -29,7 +29,6 @@
 #include <linux/pagemap.h>
 
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/tlb.h>
--- a/arch/openrisc/mm/tlb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/openrisc/mm/tlb.c
@@ -23,7 +23,6 @@
 #include <linux/init.h>
 
 #include <asm/tlbflush.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/spr_defs.h>
 
--- a/arch/parisc/include/asm/mmu_context.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/parisc/include/asm/mmu_context.h
@@ -6,7 +6,6 @@
 #include <linux/sched.h>
 #include <linux/atomic.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm-generic/mm_hooks.h>
 
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
--- a/arch/parisc/kernel/module.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/parisc/kernel/module.c
@@ -50,7 +50,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 
-#include <asm/pgtable.h>
 #include <asm/unwind.h>
 #include <asm/sections.h>
 
--- a/arch/parisc/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/parisc/kernel/ptrace.c
@@ -26,7 +26,6 @@
 #include <linux/audit.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/asm-offsets.h>
 
--- a/arch/parisc/kernel/smp.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/parisc/kernel/smp.c
@@ -39,7 +39,6 @@
 #include <asm/irq.h>		/* for CPU_IRQ_REGION and friends */
 #include <asm/mmu_context.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
--- a/arch/parisc/mm/init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/parisc/mm/init.c
@@ -26,7 +26,6 @@
 #include <linux/compat.h>
 
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/tlb.h>
 #include <asm/pdc_chassis.h>
 #include <asm/mmzone.h>
--- a/arch/powerpc/include/asm/io.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/include/asm/io.h
@@ -34,7 +34,6 @@ extern struct pci_dev *isa_bridge_pcidev
 #include <asm/mmiowb.h>
 #include <asm/mmu.h>
 #include <asm/ppc_asm.h>
-#include <asm/pgtable.h>
 
 #define SIO_CONFIG_RA	0x398
 #define SIO_CONFIG_RD	0x399
--- a/arch/powerpc/kernel/asm-offsets.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/kernel/asm-offsets.c
@@ -30,7 +30,6 @@
 
 #include <asm/io.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
--- a/arch/powerpc/kernel/process.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/kernel/process.c
@@ -41,7 +41,6 @@
 #include <linux/pkeys.h>
 #include <linux/seq_buf.h>
 
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
--- a/arch/powerpc/kernel/signal_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/kernel/signal_32.c
@@ -47,7 +47,6 @@
 #include <asm/unistd.h>
 #else
 #include <asm/ucontext.h>
-#include <asm/pgtable.h>
 #endif
 
 #include "signal.h"
--- a/arch/powerpc/kernel/signal_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/kernel/signal_64.c
@@ -25,7 +25,6 @@
 #include <asm/sigcontext.h>
 #include <asm/ucontext.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/unistd.h>
 #include <asm/cacheflush.h>
 #include <asm/syscalls.h>
--- a/arch/powerpc/kernel/traps.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/kernel/traps.c
@@ -39,7 +39,6 @@
 #include <linux/kmsg_dump.h>
 
 #include <asm/emulated_ops.h>
-#include <asm/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/debugfs.h>
 #include <asm/io.h>
--- a/arch/powerpc/kernel/vdso.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/kernel/vdso.c
@@ -18,7 +18,6 @@
 #include <linux/security.h>
 #include <linux/memblock.h>
 
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
--- a/arch/powerpc/lib/code-patching.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/lib/code-patching.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/page.h>
 #include <asm/code-patching.h>
--- a/arch/powerpc/mm/book3s64/hash_hugetlbpage.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/book3s64/hash_hugetlbpage.c
@@ -10,7 +10,6 @@
 
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 #include <asm/mmu.h>
 #include <asm/tlb.h>
--- a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/book3s64/radix_hugetlbpage.c
@@ -2,7 +2,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/security.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -17,7 +17,6 @@
 #include <linux/string_helpers.h>
 #include <linux/stop_machine.h>
 
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/dma.h>
--- a/arch/powerpc/mm/fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/fault.c
@@ -35,7 +35,6 @@
 
 #include <asm/firmware.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/siginfo.h>
--- a/arch/powerpc/mm/hugetlbpage.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -19,7 +19,6 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/kmemleak.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/setup.h>
--- a/arch/powerpc/mm/init_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/init_32.c
@@ -32,7 +32,6 @@
 #include <asm/pgalloc.h>
 #include <asm/prom.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/smp.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/mm/init_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/init_64.c
@@ -47,7 +47,6 @@
 #include <asm/rtas.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <linux/uaccess.h>
 #include <asm/smp.h>
--- a/arch/powerpc/mm/mem.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/mem.c
@@ -38,7 +38,6 @@
 #include <asm/prom.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/smp.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/mm/nohash/40x.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/nohash/40x.c
@@ -36,7 +36,6 @@
 #include <asm/prom.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <linux/uaccess.h>
 #include <asm/smp.h>
--- a/arch/powerpc/mm/nohash/fsl_booke.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/nohash/fsl_booke.c
@@ -41,7 +41,6 @@
 #include <asm/prom.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <linux/uaccess.h>
 #include <asm/smp.h>
--- a/arch/powerpc/mm/pgtable_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/pgtable_32.c
@@ -24,7 +24,6 @@
 #include <linux/memblock.h>
 #include <linux/slab.h>
 
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/fixmap.h>
 #include <asm/setup.h>
--- a/arch/powerpc/mm/pgtable_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -35,7 +35,6 @@
 #include <asm/page.h>
 #include <asm/prom.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/smp.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/mm/ptdump/hashpagetable.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/ptdump/hashpagetable.c
@@ -15,7 +15,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
-#include <asm/pgtable.h>
 #include <linux/const.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
--- a/arch/powerpc/mm/ptdump/ptdump.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/mm/ptdump/ptdump.c
@@ -19,7 +19,6 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <asm/fixmap.h>
-#include <asm/pgtable.h>
 #include <linux/const.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
--- a/arch/powerpc/perf/callchain_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/perf/callchain_32.c
@@ -11,7 +11,6 @@
 #include <linux/uaccess.h>
 #include <linux/mm.h>
 #include <asm/ptrace.h>
-#include <asm/pgtable.h>
 #include <asm/sigcontext.h>
 #include <asm/ucontext.h>
 #include <asm/vdso.h>
--- a/arch/powerpc/perf/callchain_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/perf/callchain_64.c
@@ -11,7 +11,6 @@
 #include <linux/uaccess.h>
 #include <linux/mm.h>
 #include <asm/ptrace.h>
-#include <asm/pgtable.h>
 #include <asm/sigcontext.h>
 #include <asm/ucontext.h>
 #include <asm/vdso.h>
--- a/arch/powerpc/perf/callchain.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/perf/callchain.c
@@ -11,7 +11,6 @@
 #include <linux/uaccess.h>
 #include <linux/mm.h>
 #include <asm/ptrace.h>
-#include <asm/pgtable.h>
 #include <asm/sigcontext.h>
 #include <asm/ucontext.h>
 #include <asm/vdso.h>
--- a/arch/powerpc/platforms/8xx/cpm1.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/platforms/8xx/cpm1.c
@@ -34,7 +34,6 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/8xx_immap.h>
 #include <asm/cpm1.h>
 #include <asm/io.h>
--- a/arch/powerpc/platforms/8xx/micropatch.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/platforms/8xx/micropatch.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/8xx_immap.h>
 #include <asm/cpm.h>
 #include <asm/cpm1.h>
--- a/arch/powerpc/platforms/cell/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/platforms/cell/setup.c
@@ -31,7 +31,6 @@
 #include <asm/mmu.h>
 #include <asm/processor.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/pci-bridge.h>
--- a/arch/powerpc/platforms/chrp/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/platforms/chrp/setup.c
@@ -34,7 +34,6 @@
 #include <linux/timer.h>
 
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/prom.h>
 #include <asm/pci-bridge.h>
 #include <asm/dma.h>
--- a/arch/powerpc/platforms/maple/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/platforms/maple/setup.c
@@ -42,7 +42,6 @@
 #include <asm/processor.h>
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
 #include <asm/iommu.h>
--- a/arch/powerpc/platforms/maple/time.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/platforms/maple/time.c
@@ -23,7 +23,6 @@
 #include <asm/sections.h>
 #include <asm/prom.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/time.h>
 
--- a/arch/powerpc/platforms/powermac/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/platforms/powermac/setup.c
@@ -51,7 +51,6 @@
 #include <asm/reg.h>
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
 #include <asm/ohare.h>
--- a/arch/powerpc/platforms/powermac/time.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/platforms/powermac/time.c
@@ -28,7 +28,6 @@
 #include <asm/sections.h>
 #include <asm/prom.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/time.h>
 #include <asm/nvram.h>
--- a/arch/powerpc/platforms/pseries/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/platforms/pseries/setup.c
@@ -43,7 +43,6 @@
 #include <asm/mmu.h>
 #include <asm/processor.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/pci-bridge.h>
--- a/arch/powerpc/sysdev/cpm2.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/sysdev/cpm2.c
@@ -39,7 +39,6 @@
 #include <asm/irq.h>
 #include <asm/mpc8260.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/cpm2.h>
 #include <asm/rheap.h>
 #include <asm/fs_pd.h>
--- a/arch/powerpc/xmon/xmon.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/powerpc/xmon/xmon.c
@@ -35,7 +35,6 @@
 #include <asm/machdep.h>
 #include <asm/xmon.h>
 #include <asm/processor.h>
-#include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/plpar_wrappers.h>
--- a/arch/riscv/kernel/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/riscv/kernel/setup.c
@@ -22,7 +22,6 @@
 #include <asm/cpu_ops.h>
 #include <asm/setup.h>
 #include <asm/sections.h>
-#include <asm/pgtable.h>
 #include <asm/sbi.h>
 #include <asm/tlbflush.h>
 #include <asm/thread_info.h>
--- a/arch/riscv/mm/init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/riscv/mm/init.c
@@ -18,7 +18,6 @@
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/soc.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/ptdump.h>
 
--- a/arch/s390/include/asm/tlbflush.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/include/asm/tlbflush.h
@@ -6,7 +6,6 @@
 #include <linux/sched.h>
 #include <asm/processor.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 
 /*
  * Flush all TLB entries on the local CPU.
--- a/arch/s390/kernel/machine_kexec.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/kernel/machine_kexec.c
@@ -16,7 +16,6 @@
 #include <linux/debug_locks.h>
 #include <asm/cio.h>
 #include <asm/setup.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/smp.h>
 #include <asm/ipl.h>
--- a/arch/s390/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/kernel/ptrace.c
@@ -25,7 +25,6 @@
 #include <linux/compat.h>
 #include <trace/syscall.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
--- a/arch/s390/kernel/vdso.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/kernel/vdso.c
@@ -21,7 +21,6 @@
 #include <linux/memblock.h>
 #include <linux/compat.h>
 #include <asm/asm-offsets.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
--- a/arch/s390/mm/dump_pagetables.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/mm/dump_pagetables.c
@@ -6,7 +6,6 @@
 #include <linux/kasan.h>
 #include <asm/kasan.h>
 #include <asm/sections.h>
-#include <asm/pgtable.h>
 
 static unsigned long max_addr;
 
--- a/arch/s390/mm/fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/mm/fault.c
@@ -33,7 +33,6 @@
 #include <linux/hugetlb.h>
 #include <asm/asm-offsets.h>
 #include <asm/diag.h>
-#include <asm/pgtable.h>
 #include <asm/gmap.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
--- a/arch/s390/mm/init.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/mm/init.c
@@ -33,7 +33,6 @@
 #include <linux/dma-direct.h>
 #include <asm/processor.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/dma.h>
 #include <asm/lowcore.h>
--- a/arch/s390/mm/pageattr.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/mm/pageattr.c
@@ -7,7 +7,6 @@
 #include <linux/mm.h>
 #include <asm/cacheflush.h>
 #include <asm/facility.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/page.h>
 #include <asm/set_memory.h>
--- a/arch/s390/mm/pgtable.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/mm/pgtable.c
@@ -19,7 +19,6 @@
 #include <linux/ksm.h>
 #include <linux/mman.h>
 
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
--- a/arch/s390/mm/vmem.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/s390/mm/vmem.c
@@ -13,7 +13,6 @@
 #include <linux/slab.h>
 #include <asm/cacheflush.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
--- a/arch/sh/kernel/machine_kexec.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sh/kernel/machine_kexec.c
@@ -14,7 +14,6 @@
 #include <linux/ftrace.h>
 #include <linux/suspend.h>
 #include <linux/memblock.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
 #include <asm/io.h>
--- a/arch/sh/kernel/ptrace_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sh/kernel/ptrace_32.c
@@ -25,7 +25,6 @@
 #include <linux/regset.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
--- a/arch/sh/kernel/signal_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sh/kernel/signal_32.c
@@ -28,7 +28,6 @@
 #include <linux/tracehook.h>
 #include <asm/ucontext.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/syscalls.h>
 #include <asm/fpu.h>
--- a/arch/sh/mm/cache-sh3.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sh/mm/cache-sh3.c
@@ -12,7 +12,6 @@
 #include <linux/threads.h>
 #include <asm/addrspace.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
 #include <asm/io.h>
--- a/arch/sh/mm/cache-sh4.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sh/mm/cache-sh4.c
@@ -16,7 +16,6 @@
 #include <linux/mutex.h>
 #include <linux/fs.h>
 #include <linux/highmem.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/cache_insns.h>
 #include <asm/cacheflush.h>
--- a/arch/sh/mm/cache-sh7705.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sh/mm/cache-sh7705.c
@@ -16,7 +16,6 @@
 #include <linux/threads.h>
 #include <asm/addrspace.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
 #include <asm/io.h>
--- a/arch/sh/mm/nommu.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sh/mm/nommu.c
@@ -10,7 +10,6 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/page.h>
 #include <linux/uaccess.h>
--- a/arch/sparc/kernel/leon_smp.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/leon_smp.c
@@ -39,7 +39,6 @@
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/oplib.h>
 #include <asm/cpudata.h>
 #include <asm/asi.h>
--- a/arch/sparc/kernel/process_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/process_32.c
@@ -35,7 +35,6 @@
 #include <linux/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/delay.h>
 #include <asm/processor.h>
 #include <asm/psr.h>
--- a/arch/sparc/kernel/process_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/process_64.c
@@ -41,7 +41,6 @@
 #include <linux/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/pstate.h>
 #include <asm/elf.h>
--- a/arch/sparc/kernel/ptrace_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/ptrace_32.c
@@ -23,7 +23,6 @@
 #include <linux/elf.h>
 #include <linux/tracehook.h>
 
-#include <asm/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
 
--- a/arch/sparc/kernel/ptrace_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/ptrace_64.c
@@ -32,7 +32,6 @@
 #include <linux/context_tracking.h>
 
 #include <asm/asi.h>
-#include <asm/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/psrcompat.h>
 #include <asm/visasm.h>
--- a/arch/sparc/kernel/setup_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/setup_32.c
@@ -40,7 +40,6 @@
 #include <asm/processor.h>
 #include <asm/oplib.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/traps.h>
 #include <asm/vaddrs.h>
 #include <asm/mbus.h>
--- a/arch/sparc/kernel/setup_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/setup_64.c
@@ -39,7 +39,6 @@
 #include <asm/processor.h>
 #include <asm/oplib.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/idprom.h>
 #include <asm/head.h>
 #include <asm/starfire.h>
--- a/arch/sparc/kernel/signal_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/signal_32.c
@@ -24,7 +24,6 @@
 #include <linux/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/cacheflush.h>	/* flush_sig_insns */
 #include <asm/switch_to.h>
 
--- a/arch/sparc/kernel/signal32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/signal32.c
@@ -24,7 +24,6 @@
 
 #include <linux/uaccess.h>
 #include <asm/ptrace.h>
-#include <asm/pgtable.h>
 #include <asm/psrcompat.h>
 #include <asm/fpumacro.h>
 #include <asm/visasm.h>
--- a/arch/sparc/kernel/signal_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/signal_64.c
@@ -25,7 +25,6 @@
 
 #include <linux/uaccess.h>
 #include <asm/ptrace.h>
-#include <asm/pgtable.h>
 #include <asm/fpumacro.h>
 #include <asm/uctx.h>
 #include <asm/siginfo.h>
--- a/arch/sparc/kernel/smp_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/smp_32.c
@@ -30,7 +30,6 @@
 #include <asm/irq.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/oplib.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
--- a/arch/sparc/kernel/smp_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/smp_64.c
@@ -43,7 +43,6 @@
 #include <asm/irq.h>
 #include <asm/irq_regs.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/oplib.h>
 #include <linux/uaccess.h>
 #include <asm/starfire.h>
--- a/arch/sparc/kernel/traps_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/kernel/traps_64.c
@@ -30,7 +30,6 @@
 #include <asm/ptrace.h>
 #include <asm/oplib.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/unistd.h>
 #include <linux/uaccess.h>
 #include <asm/fpumacro.h>
--- a/arch/sparc/mm/fault_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/mm/fault_32.c
@@ -25,7 +25,6 @@
 #include <linux/uaccess.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/setup.h>
--- a/arch/sparc/mm/fault_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/mm/fault_64.c
@@ -27,7 +27,6 @@
 #include <linux/uaccess.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/asi.h>
--- a/arch/sparc/mm/hugetlbpage.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -14,7 +14,6 @@
 
 #include <asm/mman.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
--- a/arch/sparc/mm/init_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/mm/init_32.c
@@ -29,7 +29,6 @@
 
 #include <asm/sections.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/vaddrs.h>
 #include <asm/setup.h>
 #include <asm/tlb.h>
--- a/arch/sparc/mm/init_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/mm/init_64.c
@@ -31,7 +31,6 @@
 #include <asm/head.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/oplib.h>
 #include <asm/iommu.h>
 #include <asm/io.h>
--- a/arch/sparc/mm/iommu.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/mm/iommu.c
@@ -17,7 +17,6 @@
 #include <linux/of_device.h>
 
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/mxcc.h>
 #include <asm/mbus.h>
--- a/arch/sparc/mm/io-unit.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/mm/io-unit.c
@@ -16,7 +16,6 @@
 #include <linux/of_device.h>
 
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/io-unit.h>
 #include <asm/mxcc.h>
--- a/arch/sparc/mm/tlb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/sparc/mm/tlb.c
@@ -10,7 +10,6 @@
 #include <linux/swap.h>
 #include <linux/preempt.h>
 
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
--- a/arch/um/kernel/process.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/um/kernel/process.c
@@ -25,7 +25,6 @@
 #include <linux/threads.h>
 #include <linux/tracehook.h>
 #include <asm/current.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <linux/uaccess.h>
 #include <as-layout.h>
--- a/arch/um/kernel/skas/mmu.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/um/kernel/skas/mmu.c
@@ -9,7 +9,6 @@
 #include <linux/slab.h>
 
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 #include <as-layout.h>
 #include <os.h>
--- a/arch/um/kernel/skas/uaccess.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/um/kernel/skas/uaccess.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <asm/current.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <kern_util.h>
 #include <os.h>
 
--- a/arch/um/kernel/tlb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/um/kernel/tlb.c
@@ -7,7 +7,6 @@
 #include <linux/module.h>
 #include <linux/sched/signal.h>
 
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <as-layout.h>
 #include <mem_user.h>
--- a/arch/um/kernel/trap.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/um/kernel/trap.c
@@ -10,7 +10,6 @@
 #include <linux/uaccess.h>
 #include <linux/sched/debug.h>
 #include <asm/current.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <arch.h>
 #include <as-layout.h>
--- a/arch/um/kernel/um_arch.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/um/kernel/um_arch.c
@@ -14,7 +14,6 @@
 #include <linux/sched/task.h>
 #include <linux/kmsg_dump.h>
 
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
--- a/arch/unicore32/kernel/module.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/unicore32/kernel/module.c
@@ -16,7 +16,6 @@
 #include <linux/string.h>
 #include <linux/gfp.h>
 
-#include <asm/pgtable.h>
 #include <asm/sections.h>
 
 void *module_alloc(unsigned long size)
--- a/arch/unicore32/mm/fault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/unicore32/mm/fault.c
@@ -17,7 +17,6 @@
 #include <linux/sched/signal.h>
 #include <linux/io.h>
 
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
 /*
--- a/arch/x86/include/asm/iomap.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/include/asm/iomap.h
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
 void __iomem *
--- a/arch/x86/include/asm/xen/page.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/include/asm/xen/page.h
@@ -11,7 +11,6 @@
 
 #include <asm/extable.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/grant_table.h>
--- a/arch/x86/kernel/alternative.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/alternative.c
@@ -18,7 +18,6 @@
 #include <asm/text-patching.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
-#include <asm/pgtable.h>
 #include <asm/mce.h>
 #include <asm/nmi.h>
 #include <asm/cacheflush.h>
--- a/arch/x86/kernel/amd_gart_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -33,7 +33,6 @@
 #include <linux/atomic.h>
 #include <linux/dma-direct.h>
 #include <asm/mtrr.h>
-#include <asm/pgtable.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
--- a/arch/x86/kernel/doublefault_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/doublefault_32.c
@@ -6,7 +6,6 @@
 #include <linux/fs.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/desc.h>
 #include <asm/traps.h>
--- a/arch/x86/kernel/machine_kexec_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/machine_kexec_32.c
@@ -13,7 +13,6 @@
 #include <linux/gfp.h>
 #include <linux/io.h>
 
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
--- a/arch/x86/kernel/machine_kexec_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -19,7 +19,6 @@
 #include <linux/efi.h>
 
 #include <asm/init.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/io_apic.h>
--- a/arch/x86/kernel/module.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/module.c
@@ -22,7 +22,6 @@
 
 #include <asm/text-patching.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/unwind.h>
 
--- a/arch/x86/kernel/process_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/process_32.c
@@ -39,7 +39,6 @@
 #include <linux/kdebug.h>
 #include <linux/syscalls.h>
 
-#include <asm/pgtable.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
 #include <asm/fpu/internal.h>
--- a/arch/x86/kernel/process_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/process_64.c
@@ -40,7 +40,6 @@
 #include <linux/ftrace.h>
 #include <linux/syscalls.h>
 
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/fpu/internal.h>
 #include <asm/mmu_context.h>
--- a/arch/x86/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/ptrace.c
@@ -28,7 +28,6 @@
 #include <linux/nospec.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/fpu/internal.h>
 #include <asm/fpu/signal.h>
--- a/arch/x86/kernel/tboot.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/kernel/tboot.c
@@ -23,7 +23,6 @@
 #include <asm/realmode.h>
 #include <asm/processor.h>
 #include <asm/bootparam.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/swiotlb.h>
 #include <asm/fixmap.h>
--- a/arch/x86/mm/dump_pagetables.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/mm/dump_pagetables.c
@@ -19,7 +19,6 @@
 #include <linux/ptdump.h>
 
 #include <asm/e820/types.h>
-#include <asm/pgtable.h>
 
 /*
  * The dumper groups pagetable entries of the same type into one, and for
--- a/arch/x86/mm/init_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/mm/init_32.c
@@ -35,7 +35,6 @@
 #include <asm/bios_ebda.h>
 #include <asm/processor.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/dma.h>
 #include <asm/fixmap.h>
 #include <asm/e820/api.h>
--- a/arch/x86/mm/init_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/mm/init_64.c
@@ -37,7 +37,6 @@
 #include <asm/processor.h>
 #include <asm/bios_ebda.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/dma.h>
 #include <asm/fixmap.h>
--- a/arch/x86/mm/kasan_init_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/mm/kasan_init_64.c
@@ -17,7 +17,6 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
-#include <asm/pgtable.h>
 #include <asm/cpu_entry_area.h>
 
 extern struct range pfn_mapped[E820_MAX_ENTRIES];
--- a/arch/x86/mm/pat/cpa-test.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/mm/pat/cpa-test.c
@@ -14,7 +14,6 @@
 #include <linux/vmalloc.h>
 
 #include <asm/cacheflush.h>
-#include <asm/pgtable.h>
 #include <asm/kdebug.h>
 
 /*
--- a/arch/x86/mm/pat/memtype.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/mm/pat/memtype.c
@@ -46,7 +46,6 @@
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
-#include <asm/pgtable.h>
 #include <asm/fcntl.h>
 #include <asm/e820/api.h>
 #include <asm/mtrr.h>
--- a/arch/x86/mm/pgtable_32.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/mm/pgtable_32.c
@@ -11,7 +11,6 @@
 #include <linux/spinlock.h>
 
 #include <asm/cpu_entry_area.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/fixmap.h>
 #include <asm/e820/api.h>
--- a/arch/x86/mm/pgtable.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/mm/pgtable.c
@@ -3,7 +3,6 @@
 #include <linux/gfp.h>
 #include <linux/hugetlb.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/tlb.h>
 #include <asm/fixmap.h>
 #include <asm/mtrr.h>
--- a/arch/x86/mm/pti.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/mm/pti.c
@@ -34,7 +34,6 @@
 #include <asm/vsyscall.h>
 #include <asm/cmdline.h>
 #include <asm/pti.h>
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/desc.h>
--- a/arch/x86/platform/efi/efi_64.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/platform/efi/efi_64.c
@@ -39,7 +39,6 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/e820/api.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
 #include <asm/efi.h>
--- a/arch/x86/xen/enlighten_pv.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/xen/enlighten_pv.c
@@ -63,7 +63,6 @@
 #include <asm/setup.h>
 #include <asm/desc.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
 #include <asm/stackprotector.h>
--- a/arch/x86/xen/grant-table.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/x86/xen/grant-table.c
@@ -21,7 +21,6 @@
 #include <xen/grant_table.h>
 #include <xen/xen.h>
 
-#include <asm/pgtable.h>
 
 static struct gnttab_vm_area {
 	struct vm_struct *area;
--- a/arch/xtensa/kernel/process.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/xtensa/kernel/process.c
@@ -37,7 +37,6 @@
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 
-#include <asm/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/io.h>
 #include <asm/processor.h>
--- a/arch/xtensa/kernel/ptrace.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/xtensa/kernel/ptrace.c
@@ -33,7 +33,6 @@
 #include <asm/coprocessor.h>
 #include <asm/elf.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/ptrace.h>
 
 static int gpr_get(struct task_struct *target,
--- a/arch/xtensa/kernel/setup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/arch/xtensa/kernel/setup.c
@@ -37,7 +37,6 @@
 #include <asm/bootparam.h>
 #include <asm/kasan.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/timex.h>
 #include <asm/platform.h>
--- a/drivers/char/agp/frontend.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/char/agp/frontend.c
@@ -39,7 +39,6 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include "agp.h"
 
 struct agp_front_data agp_fe;
--- a/drivers/char/agp/generic.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/char/agp/generic.c
@@ -42,7 +42,6 @@
 #ifdef CONFIG_X86
 #include <asm/set_memory.h>
 #endif
-#include <asm/pgtable.h>
 #include "agp.h"
 
 __u32 *agp_gatt_table;
--- a/drivers/char/bsr.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/char/bsr.c
@@ -17,7 +17,6 @@
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 
 /*
--- a/drivers/char/mspec.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/char/mspec.c
@@ -39,7 +39,6 @@
 #include <linux/numa.h>
 #include <linux/refcount.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <linux/atomic.h>
 #include <asm/tlbflush.h>
 #include <asm/uncached.h>
--- a/drivers/gpu/drm/i915/i915_mm.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/gpu/drm/i915/i915_mm.c
@@ -25,7 +25,6 @@
 #include <linux/mm.h>
 #include <linux/io-mapping.h>
 
-#include <asm/pgtable.h>
 
 #include "i915_drv.h"
 
--- a/drivers/infiniband/sw/rdmavt/mmap.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/infiniband/sw/rdmavt/mmap.c
@@ -48,7 +48,6 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
-#include <asm/pgtable.h>
 #include <rdma/uverbs_ioctl.h>
 #include "mmap.h"
 
--- a/drivers/infiniband/sw/rxe/rxe_mmap.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/infiniband/sw/rxe/rxe_mmap.c
@@ -35,7 +35,6 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
-#include <asm/pgtable.h>
 #include <rdma/uverbs_ioctl.h>
 
 #include "rxe.h"
--- a/drivers/media/platform/davinci/vpbe_display.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/media/platform/davinci/vpbe_display.c
@@ -17,7 +17,6 @@
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 
-#include <asm/pgtable.h>
 
 #include <media/v4l2-dev.h>
 #include <media/v4l2-common.h>
--- a/drivers/media/v4l2-core/v4l2-common.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/media/v4l2-core/v4l2-common.c
@@ -41,7 +41,6 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/div64.h>
 #include <media/v4l2-common.h>
--- a/drivers/misc/sgi-gru/grufault.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -21,7 +21,6 @@
 #include <linux/uaccess.h>
 #include <linux/security.h>
 #include <linux/prefetch.h>
-#include <asm/pgtable.h>
 #include "gru.h"
 #include "grutables.h"
 #include "grulib.h"
--- a/drivers/net/ethernet/sun/sunhme.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/net/ethernet/sun/sunhme.c
@@ -52,7 +52,6 @@
 #endif
 #include <linux/uaccess.h>
 
-#include <asm/pgtable.h>
 #include <asm/irq.h>
 
 #ifdef CONFIG_PCI
--- a/drivers/sbus/char/flash.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/sbus/char/flash.c
@@ -17,7 +17,6 @@
 #include <linux/of_device.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/upa.h>
 
--- a/drivers/sbus/char/uctrl.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/sbus/char/uctrl.c
@@ -21,7 +21,6 @@
 #include <asm/oplib.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/pgtable.h>
 
 #define DEBUG 1
 #ifdef DEBUG
--- a/drivers/scsi/a2091.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/scsi/a2091.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
 
--- a/drivers/scsi/a3000.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/scsi/a3000.c
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
 
--- a/drivers/scsi/gvp11.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/scsi/gvp11.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
 
--- a/drivers/scsi/lasi700.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/scsi/lasi700.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/hardware.h>
 #include <asm/parisc-device.h>
--- a/drivers/scsi/mvme147.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/scsi/mvme147.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/mvme147hw.h>
 #include <asm/irq.h>
 
--- a/drivers/scsi/sni_53c710.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/scsi/sni_53c710.c
@@ -28,7 +28,6 @@
 #include <linux/platform_device.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/delay.h>
 
--- a/drivers/video/console/newport_con.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/console/newport_con.c
@@ -24,7 +24,6 @@
 #include <asm/io.h>
 #include <linux/uaccess.h>
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/gio_device.h>
 
 #include <video/newport.h>
--- a/drivers/video/fbdev/acornfb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/fbdev/acornfb.c
@@ -30,7 +30,6 @@
 #include <mach/hardware.h>
 #include <asm/irq.h>
 #include <asm/mach-types.h>
-#include <asm/pgtable.h>
 
 #include "acornfb.h"
 
--- a/drivers/video/fbdev/atafb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/fbdev/atafb.c
@@ -58,7 +58,6 @@
 
 #include <asm/setup.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 
--- a/drivers/video/fbdev/cirrusfb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/fbdev/cirrusfb.c
@@ -42,7 +42,6 @@
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/init.h>
-#include <asm/pgtable.h>
 
 #ifdef CONFIG_ZORRO
 #include <linux/zorro.h>
--- a/drivers/video/fbdev/cyber2000fb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/fbdev/cyber2000fb.c
@@ -47,7 +47,6 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 
-#include <asm/pgtable.h>
 
 #ifdef __arm__
 #include <asm/mach-types.h>
--- a/drivers/video/fbdev/fb-puv3.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/fbdev/fb-puv3.c
@@ -18,7 +18,6 @@
 #include <linux/mm.h>
 
 #include <linux/sizes.h>
-#include <asm/pgtable.h>
 #include <mach/hardware.h>
 
 /* Platform_data reserved for unifb registers. */
--- a/drivers/video/fbdev/hitfb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/fbdev/hitfb.c
@@ -23,7 +23,6 @@
 
 #include <asm/machvec.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/hd64461.h>
 #include <cpu/dac.h>
--- a/drivers/video/fbdev/neofb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/fbdev/neofb.c
@@ -70,7 +70,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/pgtable.h>
 #include <video/vga.h>
 #include <video/neomagic.h>
 
--- a/drivers/video/fbdev/q40fb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/fbdev/q40fb.c
@@ -23,7 +23,6 @@
 #include <asm/q40_master.h>
 #include <linux/fb.h>
 #include <linux/module.h>
-#include <asm/pgtable.h>
 
 #define Q40_PHYS_SCREEN_ADDR 0xFE800000
 
--- a/drivers/video/fbdev/savage/savagefb_driver.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/video/fbdev/savage/savagefb_driver.c
@@ -55,7 +55,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/pgtable.h>
 
 #include "savagefb.h"
 
--- a/drivers/xen/balloon.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/xen/balloon.c
@@ -59,7 +59,6 @@
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/tlb.h>
 
 #include <asm/xen/hypervisor.h>
--- a/drivers/xen/grant-table.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/xen/grant-table.c
@@ -64,7 +64,6 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/interface.h>
 
-#include <asm/pgtable.h>
 #include <asm/sync_bitops.h>
 
 /* External tools reserve first few grant table entries. */
--- a/drivers/xen/privcmd.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/xen/privcmd.c
@@ -26,7 +26,6 @@
 #include <linux/moduleparam.h>
 
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 
--- a/drivers/xen/xenbus/xenbus_probe_backend.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -48,7 +48,6 @@
 #include <linux/semaphore.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/hypervisor.h>
 #include <xen/xenbus.h>
--- a/drivers/xen/xenbus/xenbus_probe.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/xen/xenbus/xenbus_probe.c
@@ -51,7 +51,6 @@
 #include <linux/module.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/xen/hypervisor.h>
 
 #include <xen/xen.h>
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/xen/hypervisor.h>
 #include <xen/xenbus.h>
 #include <xen/events.h>
--- a/fs/proc/array.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/fs/proc/array.c
@@ -92,7 +92,6 @@
 #include <linux/user_namespace.h>
 #include <linux/fs_struct.h>
 
-#include <asm/pgtable.h>
 #include <asm/processor.h>
 #include "internal.h"
 
--- a/fs/proc/meminfo.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/fs/proc/meminfo.c
@@ -17,7 +17,6 @@
 #include <linux/cma.h>
 #endif
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include "internal.h"
 
 void __attribute__((weak)) arch_report_meminfo(struct seq_file *m)
--- a/fs/proc/nommu.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/fs/proc/nommu.c
@@ -22,7 +22,6 @@
 #include <linux/hugetlb.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 #include <asm/tlb.h>
 #include <asm/div64.h>
 #include "internal.h"
--- a/fs/proc/vmcore.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/fs/proc/vmcore.c
@@ -27,7 +27,6 @@
 #include <linux/pagemap.h>
 #include <linux/uaccess.h>
 #include <linux/mem_encrypt.h>
-#include <asm/pgtable.h>
 #include <asm/io.h>
 #include "internal.h"
 
--- a/include/linux/dax.h~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/include/linux/dax.h
@@ -5,7 +5,6 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/radix-tree.h>
-#include <asm/pgtable.h>
 
 /* Flag for synchronous flush */
 #define DAXDEV_F_SYNC (1UL << 0)
--- a/init/init_task.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/init/init_task.c
@@ -13,7 +13,6 @@
 #include <linux/numa.h>
 #include <linux/scs.h>
 
-#include <asm/pgtable.h>
 #include <linux/uaccess.h>
 
 static struct signal_struct init_signals = {
--- a/kernel/exit.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/kernel/exit.c
@@ -66,7 +66,6 @@
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
-#include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
 static void __unhash_process(struct task_struct *p, bool group_dead)
--- a/kernel/fork.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/kernel/fork.c
@@ -96,7 +96,6 @@
 #include <linux/kasan.h>
 #include <linux/scs.h>
 
-#include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
--- a/kernel/power/snapshot.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/kernel/power/snapshot.c
@@ -34,7 +34,6 @@
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
--- a/lib/ioremap.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/lib/ioremap.c
@@ -12,7 +12,6 @@
 #include <linux/io.h>
 #include <linux/export.h>
 #include <asm/cacheflush.h>
-#include <asm/pgtable.h>
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 static int __read_mostly ioremap_p4d_capable;
--- a/mm/debug_vm_pgtable.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/debug_vm_pgtable.c
@@ -28,7 +28,6 @@
 #include <linux/start_kernel.h>
 #include <linux/sched/mm.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 
 #define VMFLAGS	(VM_READ|VM_WRITE|VM_EXEC)
 
--- a/mm/gup.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/gup.c
@@ -19,7 +19,6 @@
 #include <linux/sched/mm.h>
 
 #include <asm/mmu_context.h>
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
 #include "internal.h"
--- a/mm/hugetlb.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/hugetlb.c
@@ -31,7 +31,6 @@
 #include <linux/cma.h>
 
 #include <asm/page.h>
-#include <asm/pgtable.h>
 #include <asm/tlb.h>
 
 #include <linux/io.h>
--- a/mm/memory.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/memory.c
@@ -80,7 +80,6 @@
 #include <linux/uaccess.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
-#include <asm/pgtable.h>
 
 #include "internal.h"
 
--- a/mm/page_io.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/page_io.c
@@ -25,7 +25,6 @@
 #include <linux/psi.h>
 #include <linux/uio.h>
 #include <linux/sched/task.h>
-#include <asm/pgtable.h>
 
 static struct bio *get_swap_bio(gfp_t gfp_flags,
 				struct page *page, bio_end_io_t end_io)
--- a/mm/shmem.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/shmem.c
@@ -82,7 +82,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/uuid.h>
 
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 
 #include "internal.h"
 
--- a/mm/sparse.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/sparse.c
@@ -17,7 +17,6 @@
 #include "internal.h"
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 
 /*
  * Permanent SPARSEMEM data:
--- a/mm/sparse-vmemmap.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/sparse-vmemmap.c
@@ -29,7 +29,6 @@
 #include <linux/sched.h>
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
-#include <asm/pgtable.h>
 
 /*
  * Allocate a block of memory to be used to back the virtual memory map
--- a/mm/swapfile.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/swapfile.c
@@ -40,7 +40,6 @@
 #include <linux/swap_slots.h>
 #include <linux/sort.h>
 
-#include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
 #include <linux/swap_cgroup.h>
--- a/mm/swap_state.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/swap_state.c
@@ -22,7 +22,6 @@
 #include <linux/swap_slots.h>
 #include <linux/huge_mm.h>
 
-#include <asm/pgtable.h>
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
--- a/mm/vmacache.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/mm/vmacache.c
@@ -6,7 +6,6 @@
 #include <linux/sched/task.h>
 #include <linux/mm.h>
 #include <linux/vmacache.h>
-#include <asm/pgtable.h>
 
 /*
  * Hash based on the pmd of addr if configured with MMU, which provides a good
--- a/sound/core/sgbuf.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/sound/core/sgbuf.c
@@ -9,7 +9,6 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/export.h>
-#include <asm/pgtable.h>
 #include <sound/memalloc.h>
 
 
--- a/virt/kvm/kvm_main.c~mm-dont-include-asm-pgtableh-if-linux-mmh-is-already-included
+++ a/virt/kvm/kvm_main.c
@@ -55,7 +55,6 @@
 #include <asm/processor.h>
 #include <asm/ioctl.h>
 #include <linux/uaccess.h>
-#include <asm/pgtable.h>
 
 #include "coalesced_mmio.h"
 #include "async_pf.h"
_

Patches currently in -mm which might be from rppt@linux.ibm.com are
