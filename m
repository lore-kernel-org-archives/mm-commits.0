From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 53/93] mm: reorder includes after introduction of
 linux/pgtable.h
Date: Mon, 08 Jun 2020 21:32:42 -0700
Message-ID: <20200609043242.QYtu-Fp2U%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEcw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:52 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, bcain@codeaurora.org, bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net, dalias@libc.org, davem@davemloft.net, deanbo422@gmail.com, deller@gmx.de, geert@linux-m68k.org, gerg@linux-m68k.org, green.hu@gmail.com, guoren@kernel.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, jcmvbkbc@gmail.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, paul.walmsley@sifive.com, richard@nod.at, rppt@linux.ibm.com, shorne@gmail.com, tglx@linutronix.de, tony.luck@intel.com, torvalds@linux-foundation.org, tsbogend@alpha.franken.de, vgupta@synopsys.com, will@kernel.org, willy@infradead.orgy

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: reorder includes after introduction of linux/pgtable.h

The replacement of <asm/pgrable.h> with <linux/pgtable.h> made the include
of the latter in the middle of asm includes.  Fix this up with the aid of
the below script and manual adjustments here and there.

	import sys
	import re

	if len(sys.argv) is not 3:
	    print "USAGE: %s <file> <header>" % (sys.argv[0])
	    sys.exit(1)

	hdr_to_move="#include <linux/%s>" % sys.argv[2]
	moved = False
	in_hdrs = False

	with open(sys.argv[1], "r") as f:
	    lines = f.readlines()
	    for _line in lines:
		line = _line.rstrip('
')
		if line == hdr_to_move:
		    continue
		if line.startswith("#include <linux/"):
		    in_hdrs = True
		elif not moved and in_hdrs:
		    moved = True
		    print hdr_to_move
		print line

Link: http://lkml.kernel.org/r/20200514170327.31389-4-rppt@kernel.org
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

 arch/alpha/kernel/proto.h                             |    2 --
 arch/arc/mm/highmem.c                                 |    2 +-
 arch/arc/mm/tlbex.S                                   |    2 +-
 arch/arm/include/asm/efi.h                            |    1 -
 arch/arm/include/asm/fixmap.h                         |    2 +-
 arch/arm/kernel/head.S                                |    2 +-
 arch/arm/kernel/suspend.c                             |    2 +-
 arch/arm/kernel/vmlinux.lds.S                         |    2 +-
 arch/arm/mach-integrator/core.c                       |    2 +-
 arch/arm/mach-keystone/platsmp.c                      |    2 +-
 arch/arm/mach-sa1100/hackkit.c                        |    2 +-
 arch/arm/mach-zynq/common.c                           |    2 +-
 arch/arm/mm/idmap.c                                   |    2 +-
 arch/arm/mm/mm.h                                      |    1 -
 arch/arm/mm/proc-arm1020.S                            |    2 +-
 arch/arm/mm/proc-arm1020e.S                           |    2 +-
 arch/arm/mm/proc-arm1022.S                            |    2 +-
 arch/arm/mm/proc-arm1026.S                            |    2 +-
 arch/arm/mm/proc-arm720.S                             |    2 +-
 arch/arm/mm/proc-arm740.S                             |    2 +-
 arch/arm/mm/proc-arm7tdmi.S                           |    2 +-
 arch/arm/mm/proc-arm920.S                             |    2 +-
 arch/arm/mm/proc-arm922.S                             |    2 +-
 arch/arm/mm/proc-arm925.S                             |    2 +-
 arch/arm/mm/proc-arm926.S                             |    2 +-
 arch/arm/mm/proc-arm940.S                             |    2 +-
 arch/arm/mm/proc-arm946.S                             |    2 +-
 arch/arm/mm/proc-arm9tdmi.S                           |    2 +-
 arch/arm/mm/proc-fa526.S                              |    2 +-
 arch/arm/mm/proc-feroceon.S                           |    2 +-
 arch/arm/mm/proc-mohawk.S                             |    2 +-
 arch/arm/mm/proc-sa110.S                              |    2 +-
 arch/arm/mm/proc-sa1100.S                             |    2 +-
 arch/arm/mm/proc-v6.S                                 |    2 +-
 arch/arm/mm/proc-v7.S                                 |    2 +-
 arch/arm/mm/proc-xsc3.S                               |    2 +-
 arch/arm/mm/proc-xscale.S                             |    2 +-
 arch/arm/mm/pv-fixup-asm.S                            |    2 +-
 arch/arm64/include/asm/io.h                           |    2 +-
 arch/arm64/include/asm/kvm_mmu.h                      |    2 +-
 arch/arm64/include/asm/mmu_context.h                  |    2 +-
 arch/arm64/include/asm/vmap_stack.h                   |    2 +-
 arch/arm64/kernel/acpi.c                              |    2 +-
 arch/arm64/kernel/head.S                              |    2 +-
 arch/arm64/kernel/kaslr.c                             |    2 +-
 arch/arm64/kernel/suspend.c                           |    2 +-
 arch/arm64/kernel/vmlinux.lds.S                       |    1 -
 arch/arm64/mm/proc.S                                  |    2 +-
 arch/ia64/kernel/entry.S                              |    2 +-
 arch/ia64/kernel/head.S                               |    3 ++-
 arch/ia64/kernel/irq_ia64.c                           |    2 +-
 arch/ia64/kernel/ivt.S                                |    2 +-
 arch/ia64/kernel/kprobes.c                            |    2 +-
 arch/ia64/kernel/mca_asm.S                            |    2 +-
 arch/ia64/kernel/relocate_kernel.S                    |    4 +---
 arch/ia64/kernel/setup.c                              |    2 +-
 arch/ia64/kernel/uncached.c                           |    2 +-
 arch/ia64/kernel/vmlinux.lds.S                        |    2 +-
 arch/m68k/68000/m68VZ328.c                            |    2 +-
 arch/m68k/include/asm/sun3xflop.h                     |    2 +-
 arch/m68k/kernel/head.S                               |    2 +-
 arch/microblaze/include/asm/pgalloc.h                 |    2 +-
 arch/microblaze/kernel/hw_exception_handler.S         |    2 +-
 arch/microblaze/kernel/module.c                       |    2 +-
 arch/microblaze/kernel/setup.c                        |    2 +-
 arch/microblaze/mm/pgtable.c                          |    2 +-
 arch/mips/jazz/irq.c                                  |    2 +-
 arch/mips/jazz/setup.c                                |    2 +-
 arch/mips/kvm/mips.c                                  |    2 +-
 arch/mips/mm/tlbex.c                                  |    2 +-
 arch/nds32/include/asm/highmem.h                      |    1 -
 arch/nds32/kernel/head.S                              |    2 +-
 arch/nios2/kernel/nios2_ksyms.c                       |    2 +-
 arch/openrisc/include/asm/io.h                        |    1 -
 arch/openrisc/kernel/entry.S                          |    2 +-
 arch/openrisc/kernel/head.S                           |    2 +-
 arch/openrisc/kernel/or32_ksyms.c                     |    2 +-
 arch/openrisc/mm/ioremap.c                            |    2 +-
 arch/parisc/kernel/asm-offsets.c                      |    2 +-
 arch/parisc/kernel/entry.S                            |    2 +-
 arch/parisc/kernel/head.S                             |    2 +-
 arch/parisc/kernel/pacache.S                          |    2 +-
 arch/parisc/kernel/pdt.c                              |    2 +-
 arch/powerpc/include/asm/fixmap.h                     |    2 +-
 arch/powerpc/kernel/btext.c                           |    2 +-
 arch/powerpc/kernel/fpu.S                             |    1 -
 arch/powerpc/kernel/head_32.S                         |    2 +-
 arch/powerpc/kernel/head_40x.S                        |    2 +-
 arch/powerpc/kernel/head_44x.S                        |    2 +-
 arch/powerpc/kernel/head_8xx.S                        |    2 +-
 arch/powerpc/kernel/head_fsl_booke.S                  |    2 +-
 arch/powerpc/kernel/io-workarounds.c                  |    2 +-
 arch/powerpc/kernel/irq.c                             |    2 +-
 arch/powerpc/kernel/mce_power.c                       |    2 +-
 arch/powerpc/kernel/paca.c                            |    2 +-
 arch/powerpc/kernel/prom.c                            |    2 +-
 arch/powerpc/kernel/prom_init.c                       |    2 +-
 arch/powerpc/kernel/rtas_pci.c                        |    2 +-
 arch/powerpc/kernel/setup-common.c                    |    2 +-
 arch/powerpc/kernel/setup_32.c                        |    2 +-
 arch/powerpc/kernel/setup_64.c                        |    2 +-
 arch/powerpc/kernel/smp.c                             |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c                |    2 +-
 arch/powerpc/kvm/book3s_hv_nested.c                   |    2 +-
 arch/powerpc/kvm/book3s_hv_rm_xics.c                  |    2 +-
 arch/powerpc/kvm/book3s_hv_rm_xive.c                  |    2 +-
 arch/powerpc/kvm/fpu.S                                |    2 +-
 arch/powerpc/mm/book3s32/hash_low.S                   |    2 +-
 arch/powerpc/mm/book3s64/hash_native.c                |    2 +-
 arch/powerpc/mm/book3s64/hash_utils.c                 |    2 +-
 arch/powerpc/mm/book3s64/slb.c                        |    2 +-
 arch/powerpc/mm/init-common.c                         |    2 +-
 arch/powerpc/mm/nohash/tlb_low_64e.S                  |    2 +-
 arch/powerpc/mm/ptdump/bats.c                         |    2 +-
 arch/powerpc/platforms/85xx/corenet_generic.c         |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_cds.c             |    2 +-
 arch/powerpc/platforms/85xx/qemu_e500.c               |    2 +-
 arch/powerpc/platforms/85xx/sbc8548.c                 |    2 +-
 arch/powerpc/platforms/85xx/smp.c                     |    2 +-
 arch/powerpc/platforms/86xx/mpc86xx_smp.c             |    2 +-
 arch/powerpc/platforms/cell/cbe_regs.c                |    2 +-
 arch/powerpc/platforms/cell/interrupt.c               |    2 +-
 arch/powerpc/platforms/cell/pervasive.c               |    2 +-
 arch/powerpc/platforms/cell/smp.c                     |    2 +-
 arch/powerpc/platforms/cell/spider-pic.c              |    2 +-
 arch/powerpc/platforms/chrp/pci.c                     |    2 +-
 arch/powerpc/platforms/chrp/smp.c                     |    2 +-
 arch/powerpc/platforms/powermac/smp.c                 |    2 +-
 arch/powerpc/platforms/pseries/lpar.c                 |    2 +-
 arch/powerpc/platforms/pseries/smp.c                  |    2 +-
 arch/powerpc/sysdev/mpic.c                            |    2 +-
 arch/riscv/include/asm/fixmap.h                       |    2 +-
 arch/riscv/include/asm/io.h                           |    2 +-
 arch/riscv/include/asm/kasan.h                        |    2 --
 arch/riscv/mm/cacheflush.c                            |    1 -
 arch/riscv/mm/kasan_init.c                            |    2 +-
 arch/s390/boot/ipl_parm.c                             |    2 +-
 arch/s390/boot/kaslr.c                                |    2 +-
 arch/s390/include/asm/hugetlb.h                       |    2 +-
 arch/s390/include/asm/kasan.h                         |    2 --
 arch/s390/kernel/asm-offsets.c                        |    2 +-
 arch/s390/kvm/gaccess.c                               |    2 +-
 arch/s390/kvm/kvm-s390.c                              |    2 +-
 arch/s390/kvm/priv.c                                  |    2 +-
 arch/s390/mm/extmem.c                                 |    2 +-
 arch/s390/mm/gmap.c                                   |    2 +-
 arch/s390/mm/kasan_init.c                             |    2 +-
 arch/sh/mm/pmb.c                                      |    2 +-
 arch/sparc/include/asm/floppy_32.h                    |    2 +-
 arch/sparc/include/asm/highmem.h                      |    2 +-
 arch/sparc/include/asm/io-unit.h                      |    2 +-
 arch/sparc/include/asm/pgalloc_32.h                   |    2 +-
 arch/sparc/kernel/cpu.c                               |    2 +-
 arch/sparc/kernel/entry.S                             |    2 +-
 arch/sparc/kernel/head_64.S                           |    2 +-
 arch/sparc/kernel/ktlb.S                              |    2 +-
 arch/sparc/kernel/pci.c                               |    2 +-
 arch/sparc/kernel/sun4m_irq.c                         |    2 +-
 arch/sparc/kernel/trampoline_64.S                     |    2 +-
 arch/sparc/kernel/traps_32.c                          |    2 +-
 arch/sparc/lib/clear_page.S                           |    2 +-
 arch/sparc/mm/tsb.c                                   |    2 +-
 arch/sparc/mm/ultra.S                                 |    2 +-
 arch/unicore32/kernel/hibernate.c                     |    2 +-
 arch/unicore32/kernel/hibernate_asm.S                 |    2 +-
 arch/unicore32/mm/alignment.c                         |    2 +-
 arch/unicore32/mm/proc-ucv2.S                         |    2 +-
 arch/x86/boot/compressed/kaslr_64.c                   |    2 +-
 arch/x86/include/asm/asm-prototypes.h                 |    2 +-
 arch/x86/include/asm/efi.h                            |    2 +-
 arch/x86/include/asm/xen/hypercall.h                  |    2 +-
 arch/x86/kernel/acpi/boot.c                           |    2 +-
 arch/x86/kernel/acpi/sleep.c                          |    2 +-
 arch/x86/kernel/apic/apic_numachip.c                  |    2 +-
 arch/x86/kernel/cpu/bugs.c                            |    2 +-
 arch/x86/kernel/cpu/common.c                          |    2 +-
 arch/x86/kernel/cpu/intel.c                           |    2 +-
 arch/x86/kernel/crash_core_32.c                       |    2 +-
 arch/x86/kernel/crash_core_64.c                       |    2 +-
 arch/x86/kernel/early_printk.c                        |    2 +-
 arch/x86/kernel/head64.c                              |    2 +-
 arch/x86/kernel/head_64.S                             |    2 +-
 arch/x86/kernel/i8259.c                               |    2 +-
 arch/x86/kernel/irqinit.c                             |    2 +-
 arch/x86/kernel/kprobes/core.c                        |    2 +-
 arch/x86/kernel/kprobes/opt.c                         |    2 +-
 arch/x86/kernel/paravirt.c                            |    2 +-
 arch/x86/kernel/reboot.c                              |    2 +-
 arch/x86/kernel/smpboot.c                             |    2 +-
 arch/x86/mm/cpu_entry_area.c                          |    2 +-
 arch/x86/mm/ioremap.c                                 |    2 +-
 arch/x86/mm/kaslr.c                                   |    2 +-
 arch/x86/mm/mmio-mod.c                                |    2 +-
 arch/x86/mm/pat/memtype_interval.c                    |    2 +-
 arch/x86/mm/setup_nx.c                                |    2 +-
 arch/x86/platform/efi/efi_32.c                        |    2 +-
 arch/x86/platform/olpc/olpc_ofw.c                     |    2 +-
 arch/x86/power/cpu.c                                  |    2 +-
 arch/x86/power/hibernate.c                            |    2 +-
 arch/x86/power/hibernate_32.c                         |    2 +-
 arch/x86/power/hibernate_64.c                         |    2 +-
 arch/x86/realmode/init.c                              |    2 +-
 arch/x86/xen/mmu_pv.c                                 |    2 +-
 arch/x86/xen/smp_pv.c                                 |    1 +
 arch/xtensa/include/asm/fixmap.h                      |    2 +-
 arch/xtensa/include/asm/highmem.h                     |    2 +-
 arch/xtensa/include/asm/mmu_context.h                 |    2 +-
 arch/xtensa/kernel/entry.S                            |    2 +-
 arch/xtensa/kernel/traps.c                            |    2 +-
 arch/xtensa/kernel/vectors.S                          |    2 +-
 arch/xtensa/mm/cache.c                                |    2 +-
 arch/xtensa/mm/ioremap.c                              |    2 +-
 arch/xtensa/mm/misc.S                                 |    2 +-
 drivers/acpi/scan.c                                   |    1 -
 drivers/atm/fore200e.c                                |    2 +-
 drivers/block/z2ram.c                                 |    2 +-
 drivers/firmware/efi/arm-runtime.c                    |    2 +-
 drivers/gpu/drm/drm_vm.c                              |    2 +-
 drivers/infiniband/hw/qib/qib_file_ops.c              |    2 +-
 drivers/macintosh/macio-adb.c                         |    2 +-
 drivers/macintosh/mediabay.c                          |    2 +-
 drivers/macintosh/via-pmu.c                           |    2 +-
 drivers/media/pci/bt8xx/bt878.c                       |    2 +-
 drivers/media/pci/bt8xx/btcx-risc.c                   |    2 +-
 drivers/media/pci/bt8xx/bttv-risc.c                   |    2 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c             |    2 +-
 drivers/media/v4l2-core/videobuf-vmalloc.c            |    2 +-
 drivers/net/ethernet/amd/7990.c                       |    2 +-
 drivers/net/ethernet/amd/hplance.c                    |    2 +-
 drivers/net/ethernet/amd/mvme147.c                    |    2 +-
 drivers/net/ethernet/amd/sun3lance.c                  |    2 +-
 drivers/net/ethernet/amd/sunlance.c                   |    2 +-
 drivers/net/ethernet/apple/bmac.c                     |    2 +-
 drivers/net/ethernet/apple/mace.c                     |    2 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c |    2 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c      |    2 +-
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c      |    2 +-
 drivers/net/ethernet/i825xx/82596.c                   |    2 +-
 drivers/net/ethernet/korina.c                         |    2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c             |    2 +-
 drivers/net/ethernet/natsemi/jazzsonic.c              |    2 +-
 drivers/net/ethernet/natsemi/macsonic.c               |    2 +-
 drivers/net/ethernet/natsemi/xtsonic.c                |    2 +-
 drivers/net/ethernet/sun/sunbmac.c                    |    2 +-
 drivers/net/ethernet/sun/sunqe.c                      |    2 +-
 drivers/scsi/53c700.c                                 |    2 +-
 drivers/scsi/arm/cumana_2.c                           |    2 +-
 drivers/scsi/arm/eesox.c                              |    2 +-
 drivers/scsi/arm/powertec.c                           |    2 +-
 drivers/scsi/dpt_i2o.c                                |    2 +-
 drivers/scsi/mac53c94.c                               |    2 +-
 drivers/scsi/mesh.c                                   |    2 +-
 drivers/scsi/qlogicpti.c                              |    2 +-
 drivers/scsi/zorro_esp.c                              |    2 +-
 include/linux/crash_dump.h                            |    1 +
 include/linux/io-mapping.h                            |    2 +-
 include/linux/kasan.h                                 |    2 +-
 include/linux/mm.h                                    |    2 +-
 include/xen/arm/page.h                                |    2 +-
 mm/init-mm.c                                          |    2 +-
 mm/mincore.c                                          |    2 +-
 mm/zsmalloc.c                                         |    2 +-
 sound/pci/hda/hda_intel.c                             |    2 +-
 sound/soc/intel/common/sst-firmware.c                 |    2 +-
 sound/soc/intel/haswell/sst-haswell-pcm.c             |    2 +-
 265 files changed, 255 insertions(+), 268 deletions(-)

--- a/arch/alpha/kernel/proto.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/alpha/kernel/proto.h
@@ -2,8 +2,6 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 
-#include <linux/pgtable.h>
-
 /* Prototypes of functions used across modules here in this directory.  */
 
 #define vucp	volatile unsigned char  *
--- a/arch/arc/mm/highmem.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arc/mm/highmem.c
@@ -6,8 +6,8 @@
 #include <linux/memblock.h>
 #include <linux/export.h>
 #include <linux/highmem.h>
-#include <asm/processor.h>
 #include <linux/pgtable.h>
+#include <asm/processor.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
--- a/arch/arc/mm/tlbex.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arc/mm/tlbex.S
@@ -33,9 +33,9 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/entry.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/arcregs.h>
 #include <asm/cache.h>
 #include <asm/processor.h>
--- a/arch/arm64/include/asm/io.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/include/asm/io.h
@@ -9,11 +9,11 @@
 #define __ASM_IO_H
 
 #include <linux/types.h>
+#include <linux/pgtable.h>
 
 #include <asm/byteorder.h>
 #include <asm/barrier.h>
 #include <asm/memory.h>
-#include <linux/pgtable.h>
 #include <asm/early_ioremap.h>
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
--- a/arch/arm64/include/asm/kvm_mmu.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/include/asm/kvm_mmu.h
@@ -83,11 +83,11 @@ alternative_cb_end
 
 #else
 
+#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
-#include <linux/pgtable.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
--- a/arch/arm64/include/asm/mmu_context.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/include/asm/mmu_context.h
@@ -14,13 +14,13 @@
 #include <linux/sched.h>
 #include <linux/sched/hotplug.h>
 #include <linux/mm_types.h>
+#include <linux/pgtable.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/proc-fns.h>
 #include <asm-generic/mm_hooks.h>
 #include <asm/cputype.h>
-#include <linux/pgtable.h>
 #include <asm/sysreg.h>
 #include <asm/tlbflush.h>
 
--- a/arch/arm64/include/asm/vmap_stack.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/include/asm/vmap_stack.h
@@ -7,8 +7,8 @@
 #include <linux/gfp.h>
 #include <linux/kconfig.h>
 #include <linux/vmalloc.h>
-#include <asm/memory.h>
 #include <linux/pgtable.h>
+#include <asm/memory.h>
 #include <asm/thread_info.h>
 
 /*
--- a/arch/arm64/kernel/acpi.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/kernel/acpi.c
@@ -24,12 +24,12 @@
 #include <linux/of_fdt.h>
 #include <linux/smp.h>
 #include <linux/serial_core.h>
+#include <linux/pgtable.h>
 
 #include <acpi/ghes.h>
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
 #include <asm/daifflags.h>
-#include <linux/pgtable.h>
 #include <asm/smp_plat.h>
 
 int acpi_noirq = 1;		/* skip ACPI IRQ initialization */
--- a/arch/arm64/kernel/head.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/kernel/head.S
@@ -12,6 +12,7 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <linux/irqchip/arm-gic-v3.h>
+#include <linux/pgtable.h>
 
 #include <asm/asm_pointer_auth.h>
 #include <asm/assembler.h>
@@ -26,7 +27,6 @@
 #include <asm/kvm_arm.h>
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/scs.h>
 #include <asm/smp.h>
--- a/arch/arm64/kernel/kaslr.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/kernel/kaslr.c
@@ -10,6 +10,7 @@
 #include <linux/mm_types.h>
 #include <linux/sched.h>
 #include <linux/types.h>
+#include <linux/pgtable.h>
 
 #include <asm/archrandom.h>
 #include <asm/cacheflush.h>
@@ -17,7 +18,6 @@
 #include <asm/kernel-pgtable.h>
 #include <asm/memory.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/sections.h>
 
 enum kaslr_status {
--- a/arch/arm64/kernel/suspend.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/kernel/suspend.c
@@ -3,13 +3,13 @@
 #include <linux/percpu.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/pgtable.h>
 #include <asm/alternative.h>
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
 #include <asm/exec.h>
-#include <linux/pgtable.h>
 #include <asm/memory.h>
 #include <asm/mmu_context.h>
 #include <asm/smp_plat.h>
--- a/arch/arm64/kernel/vmlinux.lds.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/kernel/vmlinux.lds.S
@@ -13,7 +13,6 @@
 #include <asm/thread_info.h>
 #include <asm/memory.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 
 #include "image.h"
 
--- a/arch/arm64/mm/proc.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm64/mm/proc.S
@@ -9,11 +9,11 @@
 
 #include <linux/init.h>
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/asm_pointer_auth.h>
 #include <asm/hwcap.h>
-#include <linux/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/cpufeature.h>
 #include <asm/alternative.h>
--- a/arch/arm/include/asm/efi.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/include/asm/efi.h
@@ -13,7 +13,6 @@
 #include <asm/highmem.h>
 #include <asm/mach/map.h>
 #include <asm/mmu_context.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #ifdef CONFIG_EFI
--- a/arch/arm/include/asm/fixmap.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/include/asm/fixmap.h
@@ -6,8 +6,8 @@
 #define FIXADDR_END		0xfff00000UL
 #define FIXADDR_TOP		(FIXADDR_END - PAGE_SIZE)
 
-#include <asm/kmap_types.h>
 #include <linux/pgtable.h>
+#include <asm/kmap_types.h>
 
 enum fixed_addresses {
 	FIX_EARLYCON_MEM_BASE,
--- a/arch/arm/kernel/head.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/kernel/head.S
@@ -10,6 +10,7 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 
 #include <asm/assembler.h>
 #include <asm/cp15.h>
@@ -18,7 +19,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/memory.h>
 #include <asm/thread_info.h>
-#include <linux/pgtable.h>
 
 #if defined(CONFIG_DEBUG_LL) && !defined(CONFIG_DEBUG_SEMIHOSTING)
 #include CONFIG_DEBUG_LL_INCLUDE
--- a/arch/arm/kernel/suspend.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/kernel/suspend.c
@@ -2,12 +2,12 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mm_types.h>
+#include <linux/pgtable.h>
 
 #include <asm/bugs.h>
 #include <asm/cacheflush.h>
 #include <asm/idmap.h>
 #include <asm/pgalloc.h>
-#include <linux/pgtable.h>
 #include <asm/memory.h>
 #include <asm/smp_plat.h>
 #include <asm/suspend.h>
--- a/arch/arm/kernel/vmlinux.lds.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/kernel/vmlinux.lds.S
@@ -8,13 +8,13 @@
 #include "vmlinux-xip.lds.S"
 #else
 
+#include <linux/pgtable.h>
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
 #include <asm/memory.h>
 #include <asm/mpu.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 
 #include "vmlinux.lds.h"
 
--- a/arch/arm/mach-integrator/core.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mach-integrator/core.c
@@ -21,10 +21,10 @@
 #include <linux/stat.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/pgtable.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/time.h>
-#include <linux/pgtable.h>
 
 #include "hardware.h"
 #include "cm.h"
--- a/arch/arm/mach-keystone/platsmp.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mach-keystone/platsmp.c
@@ -12,11 +12,11 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/pgtable.h>
 
 #include <asm/smp_plat.h>
 #include <asm/prom.h>
 #include <asm/tlbflush.h>
-#include <linux/pgtable.h>
 
 #include "keystone.h"
 
--- a/arch/arm/mach-sa1100/hackkit.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mach-sa1100/hackkit.c
@@ -22,11 +22,11 @@
 #include <linux/gpio.h>
 #include <linux/leds.h>
 #include <linux/platform_device.h>
+#include <linux/pgtable.h>
 
 #include <asm/mach-types.h>
 #include <asm/setup.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
--- a/arch/arm/mach-zynq/common.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mach-zynq/common.c
@@ -24,13 +24,13 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/slab.h>
 #include <linux/sys_soc.h>
+#include <linux/pgtable.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
 #include <asm/mach-types.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/smp_scu.h>
 #include <asm/system_info.h>
 #include <asm/hardware/cache-l2x0.h>
--- a/arch/arm/mm/idmap.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/idmap.c
@@ -3,12 +3,12 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm_types.h>
+#include <linux/pgtable.h>
 
 #include <asm/cputype.h>
 #include <asm/idmap.h>
 #include <asm/hwcap.h>
 #include <asm/pgalloc.h>
-#include <linux/pgtable.h>
 #include <asm/sections.h>
 #include <asm/system_info.h>
 
--- a/arch/arm/mm/mm.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/mm.h
@@ -2,7 +2,6 @@
 #ifdef CONFIG_MMU
 #include <linux/list.h>
 #include <linux/vmalloc.h>
-
 #include <linux/pgtable.h>
 
 /* the upper-most page table pointer */
--- a/arch/arm/mm/proc-arm1020e.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm1020e.S
@@ -11,11 +11,11 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm1020.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm1020.S
@@ -11,11 +11,11 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm1022.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm1022.S
@@ -11,11 +11,11 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm1026.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm1026.S
@@ -11,11 +11,11 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm720.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm720.S
@@ -20,11 +20,11 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm740.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm740.S
@@ -6,11 +6,11 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm7tdmi.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm7tdmi.S
@@ -6,11 +6,11 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm920.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm920.S
@@ -13,10 +13,10 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm922.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm922.S
@@ -14,10 +14,10 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm925.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm925.S
@@ -37,10 +37,10 @@
 
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm926.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm926.S
@@ -13,10 +13,10 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-arm940.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm940.S
@@ -6,10 +6,10 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
 
--- a/arch/arm/mm/proc-arm946.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm946.S
@@ -8,10 +8,10 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
 
--- a/arch/arm/mm/proc-arm9tdmi.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-arm9tdmi.S
@@ -6,11 +6,11 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-fa526.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-fa526.S
@@ -11,10 +11,10 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 
--- a/arch/arm/mm/proc-feroceon.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-feroceon.S
@@ -8,10 +8,10 @@
 
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-mohawk.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-mohawk.S
@@ -9,10 +9,10 @@
 
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-sa1100.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-sa1100.S
@@ -17,12 +17,12 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <mach/hardware.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 
 #include "proc-macros.S"
 
--- a/arch/arm/mm/proc-sa110.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-sa110.S
@@ -12,12 +12,12 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <mach/hardware.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-v6.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-v6.S
@@ -9,11 +9,11 @@
  */
 #include <linux/init.h>
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 
 #include "proc-macros.S"
 
--- a/arch/arm/mm/proc-v7.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-v7.S
@@ -9,11 +9,11 @@
 #include <linux/arm-smccc.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/asm-offsets.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 #include <asm/memory.h>
 
 #include "proc-macros.S"
--- a/arch/arm/mm/proc-xsc3.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-xsc3.S
@@ -23,9 +23,9 @@
 
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
-#include <linux/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
--- a/arch/arm/mm/proc-xscale.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/proc-xscale.S
@@ -19,9 +19,9 @@
 
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
-#include <linux/pgtable.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
--- a/arch/arm/mm/pv-fixup-asm.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/arm/mm/pv-fixup-asm.S
@@ -6,10 +6,10 @@
  * for Keystone 2
  */
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/asm-offsets.h>
 #include <asm/cp15.h>
 #include <asm/memory.h>
-#include <linux/pgtable.h>
 
 	.section ".idmap.text", "ax"
 
--- a/arch/ia64/kernel/entry.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/entry.S
@@ -38,12 +38,12 @@
  */
 
 
+#include <linux/pgtable.h>
 #include <asm/asmmacro.h>
 #include <asm/cache.h>
 #include <asm/errno.h>
 #include <asm/kregs.h>
 #include <asm/asm-offsets.h>
-#include <linux/pgtable.h>
 #include <asm/percpu.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
--- a/arch/ia64/kernel/head.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/head.S
@@ -21,18 +21,19 @@
  */
 
 
+#include <linux/pgtable.h>
 #include <asm/asmmacro.h>
 #include <asm/fpu.h>
 #include <asm/kregs.h>
 #include <asm/mmu_context.h>
 #include <asm/asm-offsets.h>
 #include <asm/pal.h>
-#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/mca_asm.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/export.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
--- a/arch/ia64/kernel/irq_ia64.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/irq_ia64.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/pgtable.h>
 
 #include <linux/jiffies.h>
 #include <linux/errno.h>
@@ -37,7 +38,6 @@
 #include <asm/intrinsics.h>
 #include <asm/io.h>
 #include <asm/hw_irq.h>
-#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 
 #ifdef CONFIG_PERFMON
--- a/arch/ia64/kernel/ivt.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/ivt.S
@@ -48,11 +48,11 @@
  */
 
 
+#include <linux/pgtable.h>
 #include <asm/asmmacro.h>
 #include <asm/break.h>
 #include <asm/kregs.h>
 #include <asm/asm-offsets.h>
-#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
--- a/arch/ia64/kernel/kprobes.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/kprobes.c
@@ -17,8 +17,8 @@
 #include <linux/preempt.h>
 #include <linux/extable.h>
 #include <linux/kdebug.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/sections.h>
 #include <asm/exception.h>
 
--- a/arch/ia64/kernel/mca_asm.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/mca_asm.S
@@ -25,9 +25,9 @@
  *		Use per cpu MCA/INIT stacks for all data.
  */
 #include <linux/threads.h>
+#include <linux/pgtable.h>
 
 #include <asm/asmmacro.h>
-#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/mca_asm.h>
 #include <asm/mca.h>
--- a/arch/ia64/kernel/relocate_kernel.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/relocate_kernel.S
@@ -8,10 +8,10 @@
  * Copyright (C) 2005 Khalid Aziz  <khalid.aziz@hp.com>
  * Copyright (C) 2005 Intel Corp,  Zou Nan hai <nanhai.zou@intel.com>
  */
+#include <linux/pgtable.h>
 #include <asm/asmmacro.h>
 #include <asm/kregs.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/mca_asm.h>
 
        /* Must be relocatable PIC code callable as a C function
@@ -319,5 +319,3 @@ GLOBAL_ENTRY(ia64_dump_cpu_regs)
         ;;
         br.ret.sptk.many rp
 END(ia64_dump_cpu_regs)
-
-
--- a/arch/ia64/kernel/setup.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/setup.c
@@ -25,6 +25,7 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 
 #include <linux/acpi.h>
 #include <linux/console.h>
@@ -56,7 +57,6 @@
 #include <asm/meminit.h>
 #include <asm/page.h>
 #include <asm/patch.h>
-#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/sal.h>
 #include <asm/sections.h>
--- a/arch/ia64/kernel/uncached.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/uncached.c
@@ -19,9 +19,9 @@
 #include <linux/nmi.h>
 #include <linux/genalloc.h>
 #include <linux/gfp.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/pal.h>
-#include <linux/pgtable.h>
 #include <linux/atomic.h>
 #include <asm/tlbflush.h>
 
--- a/arch/ia64/kernel/vmlinux.lds.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#include <linux/pgtable.h>
 #include <asm/cache.h>
 #include <asm/ptrace.h>
-#include <linux/pgtable.h>
 #include <asm/thread_info.h>
 
 #define EMITS_PT_NOTE
--- a/arch/m68k/68000/m68VZ328.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/m68k/68000/m68VZ328.c
@@ -22,8 +22,8 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/rtc.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/machdep.h>
 #include <asm/MC68VZ328.h>
 #include <asm/bootstd.h>
--- a/arch/m68k/include/asm/sun3xflop.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/m68k/include/asm/sun3xflop.h
@@ -10,8 +10,8 @@
 #ifndef __ASM_SUN3X_FLOPPY_H
 #define __ASM_SUN3X_FLOPPY_H
 
-#include <asm/page.h>
 #include <linux/pgtable.h>
+#include <asm/page.h>
 #include <asm/irq.h>
 #include <asm/sun3x.h>
 
--- a/arch/m68k/kernel/head.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/m68k/kernel/head.S
@@ -255,6 +255,7 @@
 
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-amiga.h>
 #include <asm/bootinfo-atari.h>
@@ -264,7 +265,6 @@
 #include <asm/bootinfo-vme.h>
 #include <asm/setup.h>
 #include <asm/entry.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
 #ifdef CONFIG_MAC
--- a/arch/microblaze/include/asm/pgalloc.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/microblaze/include/asm/pgalloc.h
@@ -12,11 +12,11 @@
 
 #include <linux/kernel.h>	/* For min/max macros */
 #include <linux/highmem.h>
+#include <linux/pgtable.h>
 #include <asm/setup.h>
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/cache.h>
-#include <linux/pgtable.h>
 
 #define __HAVE_ARCH_PTE_ALLOC_ONE_KERNEL
 #include <asm-generic/pgalloc.h>
--- a/arch/microblaze/kernel/hw_exception_handler.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/microblaze/kernel/hw_exception_handler.S
@@ -68,9 +68,9 @@
 #include <asm/entry.h>
 #include <asm/current.h>
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/signal.h>
 #include <asm/registers.h>
 #include <asm/asm-offsets.h>
--- a/arch/microblaze/kernel/module.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/microblaze/kernel/module.c
@@ -11,8 +11,8 @@
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/string.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/cacheflush.h>
 
 int apply_relocate_add(Elf32_Shdr *sechdrs, const char *strtab,
--- a/arch/microblaze/kernel/setup.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/microblaze/kernel/setup.c
@@ -18,6 +18,7 @@
 #include <linux/console.h>
 #include <linux/debugfs.h>
 #include <linux/of_fdt.h>
+#include <linux/pgtable.h>
 
 #include <asm/setup.h>
 #include <asm/sections.h>
@@ -33,7 +34,6 @@
 #include <asm/entry.h>
 #include <asm/cpuinfo.h>
 
-#include <linux/pgtable.h>
 
 DEFINE_PER_CPU(unsigned int, KSP);	/* Saved kernel stack pointer */
 DEFINE_PER_CPU(unsigned int, KM);	/* Kernel/user mode */
--- a/arch/microblaze/mm/pgtable.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/microblaze/mm/pgtable.c
@@ -32,8 +32,8 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/mm_types.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/pgalloc.h>
 #include <linux/io.h>
 #include <asm/mmu.h>
--- a/arch/mips/jazz/irq.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/mips/jazz/irq.c
@@ -14,12 +14,12 @@
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/irq.h>
+#include <linux/pgtable.h>
 
 #include <asm/irq_cpu.h>
 #include <asm/i8259.h>
 #include <asm/io.h>
 #include <asm/jazz.h>
-#include <linux/pgtable.h>
 #include <asm/tlbmisc.h>
 
 static DEFINE_RAW_SPINLOCK(r4030_lock);
--- a/arch/mips/jazz/setup.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/mips/jazz/setup.c
@@ -17,11 +17,11 @@
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/dma-mapping.h>
+#include <linux/pgtable.h>
 
 #include <asm/jazz.h>
 #include <asm/jazzdma.h>
 #include <asm/reboot.h>
-#include <linux/pgtable.h>
 #include <asm/tlbmisc.h>
 
 extern asmlinkage void jazz_handle_int(void);
--- a/arch/mips/kvm/mips.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/mips/kvm/mips.c
@@ -19,13 +19,13 @@
 #include <linux/sched/signal.h>
 #include <linux/fs.h>
 #include <linux/memblock.h>
+#include <linux/pgtable.h>
 
 #include <asm/fpu.h>
 #include <asm/page.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
-#include <linux/pgtable.h>
 
 #include <linux/kvm_host.h>
 
--- a/arch/mips/mm/tlbex.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/mips/mm/tlbex.c
@@ -28,11 +28,11 @@
 #include <linux/smp.h>
 #include <linux/string.h>
 #include <linux/cache.h>
+#include <linux/pgtable.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cpu-type.h>
 #include <asm/mmu_context.h>
-#include <linux/pgtable.h>
 #include <asm/war.h>
 #include <asm/uasm.h>
 #include <asm/setup.h>
--- a/arch/nds32/include/asm/highmem.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/nds32/include/asm/highmem.h
@@ -7,7 +7,6 @@
 #include <asm/proc-fns.h>
 #include <asm/kmap_types.h>
 #include <asm/fixmap.h>
-#include <linux/pgtable.h>
 
 /*
  * Right now we initialize only a single pte table. It can be extended
--- a/arch/nds32/kernel/head.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/nds32/kernel/head.S
@@ -3,10 +3,10 @@
 
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <linux/sizes.h>
 #include <asm/thread_info.h>
 
--- a/arch/nios2/kernel/nios2_ksyms.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/nios2/kernel/nios2_ksyms.c
@@ -8,9 +8,9 @@
 
 #include <linux/export.h>
 #include <linux/string.h>
+#include <linux/pgtable.h>
 
 #include <asm/cacheflush.h>
-#include <linux/pgtable.h>
 
 /* string functions */
 
--- a/arch/openrisc/include/asm/io.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/openrisc/include/asm/io.h
@@ -26,7 +26,6 @@
 #define PIO_MASK		0
 
 #include <asm-generic/io.h>
-#include <linux/pgtable.h>
 
 void __iomem *ioremap(phys_addr_t offset, unsigned long size);
 extern void iounmap(void *addr);
--- a/arch/openrisc/kernel/entry.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/openrisc/kernel/entry.S
@@ -13,6 +13,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 
 #include <asm/processor.h>
 #include <asm/unistd.h>
@@ -21,7 +22,6 @@
 #include <asm/spr_defs.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/asm-offsets.h>
 
 #define DISABLE_INTERRUPTS(t1,t2)			\
--- a/arch/openrisc/kernel/head.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/openrisc/kernel/head.S
@@ -16,10 +16,10 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/serial_reg.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/spr_defs.h>
--- a/arch/openrisc/kernel/or32_ksyms.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/openrisc/kernel/or32_ksyms.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/vmalloc.h>
 #include <linux/semaphore.h>
+#include <linux/pgtable.h>
 
 #include <asm/processor.h>
 #include <linux/uaccess.h>
@@ -26,7 +27,6 @@
 #include <asm/hardirq.h>
 #include <asm/delay.h>
 #include <asm/pgalloc.h>
-#include <linux/pgtable.h>
 
 #define DECLARE_EXPORT(name) extern void name(void); EXPORT_SYMBOL(name)
 
--- a/arch/openrisc/mm/ioremap.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/openrisc/mm/ioremap.c
@@ -13,11 +13,11 @@
 
 #include <linux/vmalloc.h>
 #include <linux/io.h>
+#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/kmap_types.h>
 #include <asm/fixmap.h>
 #include <asm/bug.h>
-#include <linux/pgtable.h>
 #include <linux/sched.h>
 #include <asm/tlbflush.h>
 
--- a/arch/parisc/kernel/asm-offsets.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/parisc/kernel/asm-offsets.c
@@ -20,8 +20,8 @@
 #include <linux/ptrace.h>
 #include <linux/hardirq.h>
 #include <linux/kbuild.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <asm/pdc.h>
--- a/arch/parisc/kernel/entry.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/parisc/kernel/entry.S
@@ -19,7 +19,6 @@
 #include <asm/psw.h>
 #include <asm/cache.h>		/* for L1_CACHE_SHIFT */
 #include <asm/assembly.h>	/* for LDREG/STREG defines */
-#include <linux/pgtable.h>
 #include <asm/signal.h>
 #include <asm/unistd.h>
 #include <asm/ldcw.h>
@@ -28,6 +27,7 @@
 #include <asm/alternative.h>
 
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 
 #ifdef CONFIG_64BIT
 	.level 2.0w
--- a/arch/parisc/kernel/head.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/parisc/kernel/head.S
@@ -17,10 +17,10 @@
 #include <asm/pdc.h>
 	
 #include <asm/assembly.h>
-#include <linux/pgtable.h>
 
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 
 	.level	PA_ASM_LEVEL
 
--- a/arch/parisc/kernel/pacache.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/parisc/kernel/pacache.S
@@ -21,12 +21,12 @@
 
 #include <asm/psw.h>
 #include <asm/assembly.h>
-#include <linux/pgtable.h>
 #include <asm/cache.h>
 #include <asm/ldcw.h>
 #include <asm/alternative.h>
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 
 	.section .text.hot
 	.align	16
--- a/arch/parisc/kernel/pdt.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/parisc/kernel/pdt.c
@@ -17,11 +17,11 @@
 #include <linux/seq_file.h>
 #include <linux/kthread.h>
 #include <linux/initrd.h>
+#include <linux/pgtable.h>
 
 #include <asm/pdc.h>
 #include <asm/pdcpat.h>
 #include <asm/sections.h>
-#include <linux/pgtable.h>
 
 enum pdt_access_type {
 	PDT_NONE,
--- a/arch/powerpc/include/asm/fixmap.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/include/asm/fixmap.h
@@ -16,8 +16,8 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/sizes.h>
-#include <asm/page.h>
 #include <linux/pgtable.h>
+#include <asm/page.h>
 #ifdef CONFIG_HIGHMEM
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
--- a/arch/powerpc/kernel/btext.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/btext.c
@@ -9,13 +9,13 @@
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/memblock.h>
+#include <linux/pgtable.h>
 
 #include <asm/sections.h>
 #include <asm/prom.h>
 #include <asm/btext.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/udbg.h>
--- a/arch/powerpc/kernel/fpu.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/fpu.S
@@ -12,7 +12,6 @@
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
--- a/arch/powerpc/kernel/head_32.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/head_32.S
@@ -17,10 +17,10 @@
  */
 
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
--- a/arch/powerpc/kernel/head_40x.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/head_40x.S
@@ -26,10 +26,10 @@
  */
 
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
 #include <asm/ppc_asm.h>
--- a/arch/powerpc/kernel/head_44x.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/head_44x.S
@@ -25,10 +25,10 @@
  */
 
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
 #include <asm/ppc_asm.h>
--- a/arch/powerpc/kernel/head_8xx.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/head_8xx.S
@@ -16,12 +16,12 @@
 
 #include <linux/init.h>
 #include <linux/magic.h>
+#include <linux/pgtable.h>
 #include <linux/sizes.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 #include <asm/cache.h>
-#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
 #include <asm/ppc_asm.h>
--- a/arch/powerpc/kernel/head_fsl_booke.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/head_fsl_booke.S
@@ -28,10 +28,10 @@
 
 #include <linux/init.h>
 #include <linux/threads.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/thread_info.h>
 #include <asm/ppc_asm.h>
--- a/arch/powerpc/kernel/io-workarounds.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/io-workarounds.c
@@ -10,10 +10,10 @@
 
 #include <linux/kernel.h>
 #include <linux/sched/mm.h>	/* for init_mm */
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
 #include <asm/machdep.h>
-#include <linux/pgtable.h>
 #include <asm/ppc-pci.h>
 #include <asm/io-workarounds.h>
 #include <asm/pte-walk.h>
--- a/arch/powerpc/kernel/irq.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/irq.c
@@ -51,10 +51,10 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/vmalloc.h>
+#include <linux/pgtable.h>
 
 #include <linux/uaccess.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/cache.h>
 #include <asm/prom.h>
--- a/arch/powerpc/kernel/mce_power.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/mce_power.c
@@ -12,10 +12,10 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/extable.h>
+#include <linux/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mce.h>
 #include <asm/machdep.h>
-#include <linux/pgtable.h>
 #include <asm/pte-walk.h>
 #include <asm/sstep.h>
 #include <asm/exception-64s.h>
--- a/arch/powerpc/kernel/paca.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/paca.c
@@ -8,11 +8,11 @@
 #include <linux/memblock.h>
 #include <linux/sched/task.h>
 #include <linux/numa.h>
+#include <linux/pgtable.h>
 
 #include <asm/lppaca.h>
 #include <asm/paca.h>
 #include <asm/sections.h>
-#include <linux/pgtable.h>
 #include <asm/kexec.h>
 #include <asm/svm.h>
 #include <asm/ultravisor.h>
--- a/arch/powerpc/kernel/prom.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/prom.c
@@ -30,6 +30,7 @@
 #include <linux/of_fdt.h>
 #include <linux/libfdt.h>
 #include <linux/cpu.h>
+#include <linux/pgtable.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
@@ -41,7 +42,6 @@
 #include <asm/smp.h>
 #include <asm/mmu.h>
 #include <asm/paca.h>
-#include <linux/pgtable.h>
 #include <asm/powernv.h>
 #include <asm/iommu.h>
 #include <asm/btext.h>
--- a/arch/powerpc/kernel/prom_init.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/prom_init.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/initrd.h>
 #include <linux/bitops.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/page.h>
@@ -34,7 +35,6 @@
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/iommu.h>
 #include <asm/btext.h>
 #include <asm/sections.h>
--- a/arch/powerpc/kernel/rtas_pci.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/rtas_pci.c
@@ -13,9 +13,9 @@
 #include <linux/pci.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/kernel/setup_32.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/setup_32.c
@@ -19,11 +19,11 @@
 #include <linux/memblock.h>
 #include <linux/export.h>
 #include <linux/nvram.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/processor.h>
-#include <linux/pgtable.h>
 #include <asm/setup.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
--- a/arch/powerpc/kernel/setup_64.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/setup_64.c
@@ -30,13 +30,13 @@
 #include <linux/lockdep.h>
 #include <linux/memory.h>
 #include <linux/nmi.h>
+#include <linux/pgtable.h>
 
 #include <asm/debugfs.h>
 #include <asm/io.h>
 #include <asm/kdump.h>
 #include <asm/prom.h>
 #include <asm/processor.h>
-#include <linux/pgtable.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/kernel/setup-common.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/setup-common.c
@@ -31,13 +31,13 @@
 #include <linux/memblock.h>
 #include <linux/of_platform.h>
 #include <linux/hugetlb.h>
+#include <linux/pgtable.h>
 #include <asm/debugfs.h>
 #include <asm/io.h>
 #include <asm/paca.h>
 #include <asm/prom.h>
 #include <asm/processor.h>
 #include <asm/vdso_datapage.h>
-#include <linux/pgtable.h>
 #include <asm/smp.h>
 #include <asm/elf.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/kernel/smp.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kernel/smp.c
@@ -33,6 +33,7 @@
 #include <linux/processor.h>
 #include <linux/random.h>
 #include <linux/stackprotector.h>
+#include <linux/pgtable.h>
 
 #include <asm/ptrace.h>
 #include <linux/atomic.h>
@@ -41,7 +42,6 @@
 #include <asm/kvm_ppc.h>
 #include <asm/dbell.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
 #include <asm/time.h>
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -11,12 +11,12 @@
 #include <linux/anon_inodes.h>
 #include <linux/file.h>
 #include <linux/debugfs.h>
+#include <linux/pgtable.h>
 
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/pte-walk.h>
 #include <asm/ultravisor.h>
--- a/arch/powerpc/kvm/book3s_hv_nested.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kvm/book3s_hv_nested.c
@@ -11,11 +11,11 @@
 #include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <linux/llist.h>
+#include <linux/pgtable.h>
 
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/pte-walk.h>
 #include <asm/reg.h>
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -8,6 +8,7 @@
 #include <linux/kvm_host.h>
 #include <linux/err.h>
 #include <linux/kernel_stat.h>
+#include <linux/pgtable.h>
 
 #include <asm/kvm_book3s.h>
 #include <asm/kvm_ppc.h>
@@ -15,7 +16,6 @@
 #include <asm/xics.h>
 #include <asm/synch.h>
 #include <asm/cputhreads.h>
-#include <linux/pgtable.h>
 #include <asm/ppc-opcode.h>
 #include <asm/pnv-pci.h>
 #include <asm/opal.h>
--- a/arch/powerpc/kvm/book3s_hv_rm_xive.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kvm/book3s_hv_rm_xive.c
@@ -3,6 +3,7 @@
 #include <linux/kvm_host.h>
 #include <linux/err.h>
 #include <linux/kernel_stat.h>
+#include <linux/pgtable.h>
 
 #include <asm/kvm_book3s.h>
 #include <asm/kvm_ppc.h>
@@ -11,7 +12,6 @@
 #include <asm/debug.h>
 #include <asm/synch.h>
 #include <asm/cputhreads.h>
-#include <linux/pgtable.h>
 #include <asm/ppc-opcode.h>
 #include <asm/pnv-pci.h>
 #include <asm/opal.h>
--- a/arch/powerpc/kvm/fpu.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/kvm/fpu.S
@@ -5,10 +5,10 @@
  *    Copyright (C) 2010 Alexander Graf (agraf@suse.de)
  */
 
+#include <linux/pgtable.h>
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
-#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
--- a/arch/powerpc/mm/book3s32/hash_low.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/mm/book3s32/hash_low.S
@@ -14,9 +14,9 @@
  *  hash table, so this file is not used on them.)
  */
 
+#include <linux/pgtable.h>
 #include <asm/reg.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/cputable.h>
 #include <asm/ppc_asm.h>
 #include <asm/thread_info.h>
--- a/arch/powerpc/mm/book3s64/hash_native.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/mm/book3s64/hash_native.c
@@ -14,11 +14,11 @@
 #include <linux/processor.h>
 #include <linux/threads.h>
 #include <linux/smp.h>
+#include <linux/pgtable.h>
 
 #include <asm/machdep.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
-#include <linux/pgtable.h>
 #include <asm/trace.h>
 #include <asm/tlb.h>
 #include <asm/cputable.h>
--- a/arch/powerpc/mm/book3s64/hash_utils.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/mm/book3s64/hash_utils.c
@@ -35,10 +35,10 @@
 #include <linux/pkeys.h>
 #include <linux/hugetlb.h>
 #include <linux/cpu.h>
+#include <linux/pgtable.h>
 
 #include <asm/debugfs.h>
 #include <asm/processor.h>
-#include <linux/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/page.h>
--- a/arch/powerpc/mm/book3s64/slb.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/mm/book3s64/slb.c
@@ -10,7 +10,6 @@
  */
 
 #include <asm/asm-prototypes.h>
-#include <linux/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/paca.h>
@@ -21,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/context_tracking.h>
 #include <linux/mm_types.h>
+#include <linux/pgtable.h>
 
 #include <asm/udbg.h>
 #include <asm/code-patching.h>
--- a/arch/powerpc/mm/init-common.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/mm/init-common.c
@@ -17,8 +17,8 @@
 #undef DEBUG
 
 #include <linux/string.h>
-#include <asm/pgalloc.h>
 #include <linux/pgtable.h>
+#include <asm/pgalloc.h>
 #include <asm/kup.h>
 
 phys_addr_t memstart_addr __ro_after_init = (phys_addr_t)~0ull;
--- a/arch/powerpc/mm/nohash/tlb_low_64e.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/mm/nohash/tlb_low_64e.S
@@ -6,6 +6,7 @@
  *      Ben. Herrenschmidt (benh@kernel.crashing.org), IBM Corp.
  */
 
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/reg.h>
 #include <asm/page.h>
@@ -13,7 +14,6 @@
 #include <asm/ppc_asm.h>
 #include <asm/asm-offsets.h>
 #include <asm/cputable.h>
-#include <linux/pgtable.h>
 #include <asm/exception-64e.h>
 #include <asm/ppc-opcode.h>
 #include <asm/kvm_asm.h>
--- a/arch/powerpc/mm/ptdump/bats.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/mm/ptdump/bats.c
@@ -6,8 +6,8 @@
  * This dumps the content of BATS
  */
 
-#include <asm/debugfs.h>
 #include <linux/pgtable.h>
+#include <asm/debugfs.h>
 #include <asm/cpu_has_feature.h>
 
 #include "ptdump.h"
--- a/arch/powerpc/platforms/85xx/corenet_generic.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/corenet_generic.c
@@ -12,11 +12,11 @@
 #include <linux/kdev_t.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/pgtable.h>
 
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
-#include <linux/pgtable.h>
 #include <asm/ppc-pci.h>
 #include <mm/mmu_decl.h>
 #include <asm/prom.h>
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -22,8 +22,8 @@
 #include <linux/interrupt.h>
 #include <linux/fsl_devices.h>
 #include <linux/of_platform.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/page.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
--- a/arch/powerpc/platforms/85xx/qemu_e500.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/qemu_e500.c
@@ -13,8 +13,8 @@
 
 #include <linux/kernel.h>
 #include <linux/of_fdt.h>
-#include <asm/machdep.h>
 #include <linux/pgtable.h>
+#include <asm/machdep.h>
 #include <asm/time.h>
 #include <asm/udbg.h>
 #include <asm/mpic.h>
--- a/arch/powerpc/platforms/85xx/sbc8548.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/sbc8548.c
@@ -24,8 +24,8 @@
 #include <linux/interrupt.h>
 #include <linux/fsl_devices.h>
 #include <linux/of_platform.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/page.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
--- a/arch/powerpc/platforms/85xx/smp.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/85xx/smp.c
@@ -16,9 +16,9 @@
 #include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/fsl/guts.h>
+#include <linux/pgtable.h>
 
 #include <asm/machdep.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/mpic.h>
 #include <asm/cacheflush.h>
--- a/arch/powerpc/platforms/86xx/mpc86xx_smp.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/86xx/mpc86xx_smp.c
@@ -10,10 +10,10 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/pgtable.h>
 
 #include <asm/code-patching.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/pci-bridge.h>
 #include <asm/mpic.h>
 #include <asm/cacheflush.h>
--- a/arch/powerpc/platforms/cell/cbe_regs.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/cbe_regs.c
@@ -12,9 +12,9 @@
 #include <linux/export.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/ptrace.h>
 #include <asm/cell-regs.h>
--- a/arch/powerpc/platforms/cell/interrupt.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/interrupt.c
@@ -23,9 +23,9 @@
 #include <linux/types.h>
 #include <linux/ioport.h>
 #include <linux/kernel_stat.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/ptrace.h>
 #include <asm/machdep.h>
--- a/arch/powerpc/platforms/cell/pervasive.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/pervasive.c
@@ -15,11 +15,11 @@
 #include <linux/percpu.h>
 #include <linux/types.h>
 #include <linux/kallsyms.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
 #include <asm/machdep.h>
 #include <asm/prom.h>
-#include <linux/pgtable.h>
 #include <asm/reg.h>
 #include <asm/cell-regs.h>
 #include <asm/cpu_has_feature.h>
--- a/arch/powerpc/platforms/cell/smp.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/smp.c
@@ -21,12 +21,12 @@
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/cpu.h>
+#include <linux/pgtable.h>
 
 #include <asm/ptrace.h>
 #include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
--- a/arch/powerpc/platforms/cell/spider-pic.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/cell/spider-pic.c
@@ -10,8 +10,8 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/ioport.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/prom.h>
 #include <asm/io.h>
 
--- a/arch/powerpc/platforms/chrp/pci.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/chrp/pci.c
@@ -8,9 +8,9 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/hydra.h>
 #include <asm/prom.h>
--- a/arch/powerpc/platforms/chrp/smp.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/chrp/smp.c
@@ -16,12 +16,12 @@
 #include <linux/kernel_stat.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
+#include <linux/pgtable.h>
 
 #include <asm/ptrace.h>
 #include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/prom.h>
--- a/arch/powerpc/platforms/powermac/smp.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/powermac/smp.c
@@ -30,13 +30,13 @@
 #include <linux/hardirq.h>
 #include <linux/cpu.h>
 #include <linux/compiler.h>
+#include <linux/pgtable.h>
 
 #include <asm/ptrace.h>
 #include <linux/atomic.h>
 #include <asm/code-patching.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/prom.h>
--- a/arch/powerpc/platforms/pseries/lpar.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/pseries/lpar.c
@@ -21,10 +21,10 @@
 #include <linux/cpuhotplug.h>
 #include <linux/workqueue.h>
 #include <linux/proc_fs.h>
+#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/mmu_context.h>
 #include <asm/iommu.h>
--- a/arch/powerpc/platforms/pseries/smp.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/platforms/pseries/smp.c
@@ -20,12 +20,12 @@
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/cpu.h>
+#include <linux/pgtable.h>
 
 #include <asm/ptrace.h>
 #include <linux/atomic.h>
 #include <asm/irq.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
--- a/arch/powerpc/sysdev/mpic.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/powerpc/sysdev/mpic.c
@@ -29,11 +29,11 @@
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
 #include <linux/ratelimit.h>
+#include <linux/pgtable.h>
 
 #include <asm/ptrace.h>
 #include <asm/signal.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/machdep.h>
 #include <asm/mpic.h>
--- a/arch/riscv/include/asm/fixmap.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/riscv/include/asm/fixmap.h
@@ -8,8 +8,8 @@
 
 #include <linux/kernel.h>
 #include <linux/sizes.h>
-#include <asm/page.h>
 #include <linux/pgtable.h>
+#include <asm/page.h>
 
 #ifdef CONFIG_MMU
 /*
--- a/arch/riscv/include/asm/io.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/riscv/include/asm/io.h
@@ -12,8 +12,8 @@
 #define _ASM_RISCV_IO_H
 
 #include <linux/types.h>
-#include <asm/mmiowb.h>
 #include <linux/pgtable.h>
+#include <asm/mmiowb.h>
 
 /*
  * MMIO access functions are separated out to break dependency cycles
--- a/arch/riscv/include/asm/kasan.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/riscv/include/asm/kasan.h
@@ -8,8 +8,6 @@
 
 #ifdef CONFIG_KASAN
 
-#include <linux/pgtable.h>
-
 #define KASAN_SHADOW_SCALE_SHIFT	3
 
 #define KASAN_SHADOW_SIZE	(UL(1) << (38 - KASAN_SHADOW_SCALE_SHIFT))
--- a/arch/riscv/mm/cacheflush.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/riscv/mm/cacheflush.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2017 SiFive
  */
 
-#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 
 #ifdef CONFIG_SMP
--- a/arch/riscv/mm/kasan_init.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/riscv/mm/kasan_init.c
@@ -6,8 +6,8 @@
 #include <linux/kasan.h>
 #include <linux/kernel.h>
 #include <linux/memblock.h>
-#include <asm/tlbflush.h>
 #include <linux/pgtable.h>
+#include <asm/tlbflush.h>
 #include <asm/fixmap.h>
 
 extern pgd_t early_pg_dir[PTRS_PER_PGD];
--- a/arch/s390/boot/ipl_parm.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/boot/ipl_parm.c
@@ -2,12 +2,12 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
+#include <linux/pgtable.h>
 #include <asm/ebcdic.h>
 #include <asm/sclp.h>
 #include <asm/sections.h>
 #include <asm/boot_data.h>
 #include <asm/facility.h>
-#include <linux/pgtable.h>
 #include <asm/uv.h>
 #include "boot.h"
 
--- a/arch/s390/boot/kaslr.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/boot/kaslr.c
@@ -2,8 +2,8 @@
 /*
  * Copyright IBM Corp. 2019
  */
-#include <asm/mem_detect.h>
 #include <linux/pgtable.h>
+#include <asm/mem_detect.h>
 #include <asm/cpacf.h>
 #include <asm/timex.h>
 #include <asm/sclp.h>
--- a/arch/s390/include/asm/hugetlb.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/include/asm/hugetlb.h
@@ -9,8 +9,8 @@
 #ifndef _ASM_S390_HUGETLB_H
 #define _ASM_S390_HUGETLB_H
 
-#include <asm/page.h>
 #include <linux/pgtable.h>
+#include <asm/page.h>
 
 #define hugetlb_free_pgd_range			free_pgd_range
 #define hugepages_supported()			(MACHINE_HAS_EDAT1)
--- a/arch/s390/include/asm/kasan.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/include/asm/kasan.h
@@ -2,8 +2,6 @@
 #ifndef __ASM_KASAN_H
 #define __ASM_KASAN_H
 
-#include <linux/pgtable.h>
-
 #ifdef CONFIG_KASAN
 
 #define KASAN_SHADOW_SCALE_SHIFT 3
--- a/arch/s390/kernel/asm-offsets.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/kernel/asm-offsets.c
@@ -11,9 +11,9 @@
 #include <linux/kvm_host.h>
 #include <linux/sched.h>
 #include <linux/purgatory.h>
+#include <linux/pgtable.h>
 #include <asm/idle.h>
 #include <asm/vdso.h>
-#include <linux/pgtable.h>
 #include <asm/gmap.h>
 #include <asm/nmi.h>
 #include <asm/stacktrace.h>
--- a/arch/s390/kvm/gaccess.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/kvm/gaccess.c
@@ -9,8 +9,8 @@
 #include <linux/vmalloc.h>
 #include <linux/mm_types.h>
 #include <linux/err.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/gmap.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
--- a/arch/s390/kvm/kvm-s390.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/kvm/kvm-s390.c
@@ -31,11 +31,11 @@
 #include <linux/bitmap.h>
 #include <linux/sched/signal.h>
 #include <linux/string.h>
+#include <linux/pgtable.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/lowcore.h>
 #include <asm/stp.h>
-#include <linux/pgtable.h>
 #include <asm/gmap.h>
 #include <asm/nmi.h>
 #include <asm/switch_to.h>
--- a/arch/s390/kvm/priv.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/kvm/priv.c
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/compat.h>
 #include <linux/mm_types.h>
+#include <linux/pgtable.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/facility.h>
@@ -20,7 +21,6 @@
 #include <asm/debug.h>
 #include <asm/ebcdic.h>
 #include <asm/sysinfo.h>
-#include <linux/pgtable.h>
 #include <asm/page-states.h>
 #include <asm/pgalloc.h>
 #include <asm/gmap.h>
--- a/arch/s390/mm/extmem.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/mm/extmem.c
@@ -20,9 +20,9 @@
 #include <linux/ctype.h>
 #include <linux/ioport.h>
 #include <linux/refcount.h>
+#include <linux/pgtable.h>
 #include <asm/diag.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/ebcdic.h>
 #include <asm/errno.h>
 #include <asm/extmem.h>
--- a/arch/s390/mm/gmap.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/mm/gmap.c
@@ -17,8 +17,8 @@
 #include <linux/swapops.h>
 #include <linux/ksm.h>
 #include <linux/mman.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/pgalloc.h>
 #include <asm/gmap.h>
 #include <asm/tlb.h>
--- a/arch/s390/mm/kasan_init.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/s390/mm/kasan_init.c
@@ -2,8 +2,8 @@
 #include <linux/kasan.h>
 #include <linux/sched/task.h>
 #include <linux/memblock.h>
-#include <asm/pgalloc.h>
 #include <linux/pgtable.h>
+#include <asm/pgalloc.h>
 #include <asm/kasan.h>
 #include <asm/mem_detect.h>
 #include <asm/processor.h>
--- a/arch/sh/mm/pmb.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sh/mm/pmb.c
@@ -23,10 +23,10 @@
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <linux/sizes.h>
 #include <linux/uaccess.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
--- a/arch/sparc/include/asm/floppy_32.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/include/asm/floppy_32.h
@@ -9,8 +9,8 @@
 
 #include <linux/of.h>
 #include <linux/of_device.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/idprom.h>
 #include <asm/oplib.h>
 #include <asm/auxio.h>
--- a/arch/sparc/include/asm/highmem.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/include/asm/highmem.h
@@ -22,9 +22,9 @@
 #ifdef __KERNEL__
 
 #include <linux/interrupt.h>
+#include <linux/pgtable.h>
 #include <asm/vaddrs.h>
 #include <asm/kmap_types.h>
-#include <linux/pgtable.h>
 #include <asm/pgtsrmmu.h>
 
 /* declarations for highmem.c */
--- a/arch/sparc/include/asm/io-unit.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/include/asm/io-unit.h
@@ -7,8 +7,8 @@
 #define _SPARC_IO_UNIT_H
 
 #include <linux/spinlock.h>
-#include <asm/page.h>
 #include <linux/pgtable.h>
+#include <asm/page.h>
 
 /* The io-unit handles all virtual to physical address translations
  * that occur between the SBUS and physical memory.  Access by
--- a/arch/sparc/include/asm/pgalloc_32.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/include/asm/pgalloc_32.h
@@ -4,9 +4,9 @@
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/pgtable.h>
 
 #include <asm/pgtsrmmu.h>
-#include <linux/pgtable.h>
 #include <asm/vaddrs.h>
 #include <asm/page.h>
 
--- a/arch/sparc/kernel/cpu.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/kernel/cpu.c
@@ -11,9 +11,9 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/threads.h>
+#include <linux/pgtable.h>
 
 #include <asm/spitfire.h>
-#include <linux/pgtable.h>
 #include <asm/oplib.h>
 #include <asm/setup.h>
 #include <asm/page.h>
--- a/arch/sparc/kernel/entry.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/kernel/entry.S
@@ -10,6 +10,7 @@
 
 #include <linux/linkage.h>
 #include <linux/errno.h>
+#include <linux/pgtable.h>
 
 #include <asm/head.h>
 #include <asm/asi.h>
@@ -20,7 +21,6 @@
 #include <asm/psr.h>
 #include <asm/vaddrs.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/winmacro.h>
 #include <asm/signal.h>
 #include <asm/obio.h>
--- a/arch/sparc/kernel/head_64.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/kernel/head_64.S
@@ -12,13 +12,13 @@
 #include <linux/threads.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/thread_info.h>
 #include <asm/asi.h>
 #include <asm/pstate.h>
 #include <asm/ptrace.h>
 #include <asm/spitfire.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/errno.h>
 #include <asm/signal.h>
 #include <asm/processor.h>
--- a/arch/sparc/kernel/ktlb.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/kernel/ktlb.S
@@ -7,10 +7,10 @@
  * Copyright (C) 1996,98,99 Jakub Jelinek  (jj@sunsite.mff.cuni.cz)
  */
 
+#include <linux/pgtable.h>
 #include <asm/head.h>
 #include <asm/asi.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/tsb.h>
 
 	.text
--- a/arch/sparc/kernel/pci.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/kernel/pci.c
@@ -21,9 +21,9 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/pgtable.h>
 
 #include <linux/uaccess.h>
-#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/prom.h>
 #include <asm/apb.h>
--- a/arch/sparc/kernel/sun4m_irq.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/kernel/sun4m_irq.c
@@ -12,11 +12,11 @@
 
 #include <linux/slab.h>
 #include <linux/sched/debug.h>
+#include <linux/pgtable.h>
 
 #include <asm/timer.h>
 #include <asm/traps.h>
 #include <asm/pgalloc.h>
-#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
--- a/arch/sparc/kernel/trampoline_64.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/kernel/trampoline_64.S
@@ -6,6 +6,7 @@
  */
 
 
+#include <linux/pgtable.h>
 #include <asm/head.h>
 #include <asm/asi.h>
 #include <asm/lsu.h>
@@ -13,7 +14,6 @@
 #include <asm/dcu.h>
 #include <asm/pstate.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/spitfire.h>
 #include <asm/processor.h>
 #include <asm/thread_info.h>
--- a/arch/sparc/kernel/traps_32.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/kernel/traps_32.c
@@ -18,12 +18,12 @@
 #include <linux/smp.h>
 #include <linux/kdebug.h>
 #include <linux/export.h>
+#include <linux/pgtable.h>
 
 #include <asm/delay.h>
 #include <asm/ptrace.h>
 #include <asm/oplib.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/unistd.h>
 #include <asm/traps.h>
 
--- a/arch/sparc/lib/clear_page.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/lib/clear_page.S
@@ -5,10 +5,10 @@
  * Copyright (C) 1997 Jakub Jelinek (jakub@redhat.com)
  */
 
+#include <linux/pgtable.h>
 #include <asm/visasm.h>
 #include <asm/thread_info.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/spitfire.h>
 #include <asm/head.h>
 #include <asm/export.h>
--- a/arch/sparc/mm/tsb.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/mm/tsb.c
@@ -8,9 +8,9 @@
 #include <linux/preempt.h>
 #include <linux/slab.h>
 #include <linux/mm_types.h>
+#include <linux/pgtable.h>
 
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/tsb.h>
--- a/arch/sparc/mm/ultra.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/sparc/mm/ultra.S
@@ -5,8 +5,8 @@
  * Copyright (C) 1997, 2000, 2008 David S. Miller (davem@davemloft.net)
  */
 
-#include <asm/asi.h>
 #include <linux/pgtable.h>
+#include <asm/asi.h>
 #include <asm/page.h>
 #include <asm/spitfire.h>
 #include <asm/mmu_context.h>
--- a/arch/unicore32/kernel/hibernate_asm.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/unicore32/kernel/hibernate_asm.S
@@ -11,9 +11,9 @@
 #include <linux/sys.h>
 #include <linux/errno.h>
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <generated/asm-offsets.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/assembler.h>
 
 @ restore_image(pgd_t *resume_pg_dir, struct pbe *restore_pblist)
--- a/arch/unicore32/kernel/hibernate.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/unicore32/kernel/hibernate.c
@@ -11,9 +11,9 @@
 #include <linux/gfp.h>
 #include <linux/suspend.h>
 #include <linux/memblock.h>
+#include <linux/pgtable.h>
 
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/suspend.h>
--- a/arch/unicore32/mm/alignment.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/unicore32/mm/alignment.c
@@ -18,8 +18,8 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/tlbflush.h>
 #include <asm/unaligned.h>
 
--- a/arch/unicore32/mm/proc-ucv2.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/unicore32/mm/proc-ucv2.S
@@ -8,10 +8,10 @@
  */
 #include <linux/init.h>
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/assembler.h>
 #include <asm/hwcap.h>
 #include <asm/pgtable-hwdef.h>
-#include <linux/pgtable.h>
 
 #include "proc-macros.S"
 
--- a/arch/x86/boot/compressed/kaslr_64.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/boot/compressed/kaslr_64.c
@@ -22,8 +22,8 @@
 #include "misc.h"
 
 /* These actually do the work of building the kernel identity maps. */
-#include <asm/init.h>
 #include <linux/pgtable.h>
+#include <asm/init.h>
 /* Use the static base for this part of the boot process */
 #undef __PAGE_OFFSET
 #define __PAGE_OFFSET __PAGE_OFFSET_BASE
--- a/arch/x86/include/asm/asm-prototypes.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/include/asm/asm-prototypes.h
@@ -1,13 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <asm/ftrace.h>
 #include <linux/uaccess.h>
+#include <linux/pgtable.h>
 #include <asm/string.h>
 #include <asm/page.h>
 #include <asm/checksum.h>
 
 #include <asm-generic/asm-prototypes.h>
 
-#include <linux/pgtable.h>
 #include <asm/special_insns.h>
 #include <asm/preempt.h>
 #include <asm/asm.h>
--- a/arch/x86/include/asm/efi.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/include/asm/efi.h
@@ -3,13 +3,13 @@
 #define _ASM_X86_EFI_H
 
 #include <asm/fpu/api.h>
-#include <linux/pgtable.h>
 #include <asm/processor-flags.h>
 #include <asm/tlb.h>
 #include <asm/nospec-branch.h>
 #include <asm/mmu_context.h>
 #include <linux/build_bug.h>
 #include <linux/kernel.h>
+#include <linux/pgtable.h>
 
 extern unsigned long efi_fw_vendor, efi_config_table;
 
--- a/arch/x86/include/asm/xen/hypercall.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/include/asm/xen/hypercall.h
@@ -38,11 +38,11 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/pgtable.h>
 
 #include <trace/events/xen.h>
 
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/smap.h>
 #include <asm/nospec-branch.h>
 
--- a/arch/x86/kernel/acpi/boot.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/acpi/boot.c
@@ -20,11 +20,11 @@
 #include <linux/pci.h>
 #include <linux/efi-bgrt.h>
 #include <linux/serial_core.h>
+#include <linux/pgtable.h>
 
 #include <asm/e820/api.h>
 #include <asm/irqdomain.h>
 #include <asm/pci_x86.h>
-#include <linux/pgtable.h>
 #include <asm/io_apic.h>
 #include <asm/apic.h>
 #include <asm/io.h>
--- a/arch/x86/kernel/acpi/sleep.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/acpi/sleep.c
@@ -10,9 +10,9 @@
 #include <linux/memblock.h>
 #include <linux/dmi.h>
 #include <linux/cpumask.h>
+#include <linux/pgtable.h>
 #include <asm/segment.h>
 #include <asm/desc.h>
-#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/realmode.h>
 
--- a/arch/x86/kernel/apic/apic_numachip.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/apic/apic_numachip.c
@@ -12,11 +12,11 @@
  */
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 
 #include <asm/numachip/numachip.h>
 #include <asm/numachip/numachip_csr.h>
 
-#include <linux/pgtable.h>
 
 #include "local.h"
 
--- a/arch/x86/kernel/cpu/bugs.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/cpu/bugs.c
@@ -15,6 +15,7 @@
 #include <linux/nospec.h>
 #include <linux/prctl.h>
 #include <linux/sched/smt.h>
+#include <linux/pgtable.h>
 
 #include <asm/spec-ctrl.h>
 #include <asm/cmdline.h>
@@ -26,7 +27,6 @@
 #include <asm/vmx.h>
 #include <asm/paravirt.h>
 #include <asm/alternative.h>
-#include <linux/pgtable.h>
 #include <asm/set_memory.h>
 #include <asm/intel-family.h>
 #include <asm/e820/api.h>
--- a/arch/x86/kernel/cpu/common.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/cpu/common.c
@@ -21,6 +21,7 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/syscore_ops.h>
+#include <linux/pgtable.h>
 
 #include <asm/stackprotector.h>
 #include <asm/perf_event.h>
@@ -35,7 +36,6 @@
 #include <asm/vsyscall.h>
 #include <linux/topology.h>
 #include <linux/cpumask.h>
-#include <linux/pgtable.h>
 #include <linux/atomic.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
--- a/arch/x86/kernel/cpu/intel.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/cpu/intel.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
+#include <linux/pgtable.h>
 
 #include <linux/string.h>
 #include <linux/bitops.h>
@@ -11,7 +12,6 @@
 #include <linux/uaccess.h>
 
 #include <asm/cpufeature.h>
-#include <linux/pgtable.h>
 #include <asm/msr.h>
 #include <asm/bugs.h>
 #include <asm/cpu.h>
--- a/arch/x86/kernel/crash_core_32.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/crash_core_32.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/crash_core.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/setup.h>
 
 void arch_crash_save_vmcoreinfo(void)
--- a/arch/x86/kernel/crash_core_64.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/crash_core_64.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/crash_core.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/setup.h>
 
 void arch_crash_save_vmcoreinfo(void)
--- a/arch/x86/kernel/early_printk.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/early_printk.c
@@ -8,6 +8,7 @@
 #include <linux/pci_regs.h>
 #include <linux/pci_ids.h>
 #include <linux/errno.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/fcntl.h>
@@ -15,7 +16,6 @@
 #include <xen/hvc-console.h>
 #include <asm/pci-direct.h>
 #include <asm/fixmap.h>
-#include <linux/pgtable.h>
 #include <linux/usb/ehci_def.h>
 #include <linux/usb/xhci-dbgp.h>
 #include <asm/pci_x86.h>
--- a/arch/x86/kernel/head64.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/head64.c
@@ -20,13 +20,13 @@
 #include <linux/io.h>
 #include <linux/memblock.h>
 #include <linux/mem_encrypt.h>
+#include <linux/pgtable.h>
 
 #include <asm/processor.h>
 #include <asm/proto.h>
 #include <asm/smp.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
-#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/kdebug.h>
--- a/arch/x86/kernel/head_64.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/head_64.S
@@ -13,8 +13,8 @@
 #include <linux/linkage.h>
 #include <linux/threads.h>
 #include <linux/init.h>
-#include <asm/segment.h>
 #include <linux/pgtable.h>
+#include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/msr.h>
 #include <asm/cache.h>
--- a/arch/x86/kernel/i8259.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/i8259.c
@@ -15,11 +15,11 @@
 #include <linux/acpi.h>
 #include <linux/io.h>
 #include <linux/delay.h>
+#include <linux/pgtable.h>
 
 #include <linux/atomic.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
-#include <linux/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
--- a/arch/x86/kernel/irqinit.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/irqinit.c
@@ -16,11 +16,11 @@
 #include <linux/acpi.h>
 #include <linux/io.h>
 #include <linux/delay.h>
+#include <linux/pgtable.h>
 
 #include <linux/atomic.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
-#include <linux/pgtable.h>
 #include <asm/desc.h>
 #include <asm/apic.h>
 #include <asm/setup.h>
--- a/arch/x86/kernel/kprobes/core.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/kprobes/core.c
@@ -41,11 +41,11 @@
 #include <linux/kasan.h>
 #include <linux/moduleloader.h>
 #include <linux/vmalloc.h>
+#include <linux/pgtable.h>
 
 #include <asm/text-patching.h>
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
-#include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/alternative.h>
 #include <asm/insn.h>
--- a/arch/x86/kernel/kprobes/opt.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/kprobes/opt.c
@@ -16,11 +16,11 @@
 #include <linux/kallsyms.h>
 #include <linux/ftrace.h>
 #include <linux/frame.h>
+#include <linux/pgtable.h>
 
 #include <asm/text-patching.h>
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
-#include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/alternative.h>
 #include <asm/insn.h>
--- a/arch/x86/kernel/paravirt.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/paravirt.c
@@ -13,13 +13,13 @@
 #include <linux/bcd.h>
 #include <linux/highmem.h>
 #include <linux/kprobes.h>
+#include <linux/pgtable.h>
 
 #include <asm/bug.h>
 #include <asm/paravirt.h>
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/setup.h>
-#include <linux/pgtable.h>
 #include <asm/time.h>
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
--- a/arch/x86/kernel/reboot.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/reboot.c
@@ -11,13 +11,13 @@
 #include <linux/tboot.h>
 #include <linux/delay.h>
 #include <linux/frame.h>
+#include <linux/pgtable.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
 #include <asm/io_apic.h>
 #include <asm/desc.h>
 #include <asm/hpet.h>
-#include <linux/pgtable.h>
 #include <asm/proto.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
--- a/arch/x86/kernel/smpboot.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/kernel/smpboot.c
@@ -55,6 +55,7 @@
 #include <linux/gfp.h>
 #include <linux/cpuidle.h>
 #include <linux/numa.h>
+#include <linux/pgtable.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -63,7 +64,6 @@
 #include <asm/realmode.h>
 #include <asm/cpu.h>
 #include <asm/numa.h>
-#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mtrr.h>
 #include <asm/mwait.h>
--- a/arch/x86/mm/cpu_entry_area.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/mm/cpu_entry_area.c
@@ -4,9 +4,9 @@
 #include <linux/percpu.h>
 #include <linux/kallsyms.h>
 #include <linux/kcore.h>
+#include <linux/pgtable.h>
 
 #include <asm/cpu_entry_area.h>
-#include <linux/pgtable.h>
 #include <asm/fixmap.h>
 #include <asm/desc.h>
 
--- a/arch/x86/mm/ioremap.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/mm/ioremap.c
@@ -16,12 +16,12 @@
 #include <linux/mmiotrace.h>
 #include <linux/mem_encrypt.h>
 #include <linux/efi.h>
+#include <linux/pgtable.h>
 
 #include <asm/set_memory.h>
 #include <asm/e820/api.h>
 #include <asm/efi.h>
 #include <asm/fixmap.h>
-#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/memtype.h>
--- a/arch/x86/mm/kaslr.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/mm/kaslr.c
@@ -24,9 +24,9 @@
 #include <linux/init.h>
 #include <linux/random.h>
 #include <linux/memblock.h>
+#include <linux/pgtable.h>
 
 #include <asm/pgalloc.h>
-#include <linux/pgtable.h>
 #include <asm/setup.h>
 #include <asm/kaslr.h>
 
--- a/arch/x86/mm/mmio-mod.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/mm/mmio-mod.c
@@ -17,8 +17,8 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <linux/pgtable.h>
 #include <linux/mmiotrace.h>
+#include <linux/pgtable.h>
 #include <asm/e820/api.h> /* for ISA_START_ADDRESS */
 #include <linux/atomic.h>
 #include <linux/percpu.h>
--- a/arch/x86/mm/pat/memtype_interval.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/mm/pat/memtype_interval.c
@@ -14,8 +14,8 @@
 #include <linux/interval_tree_generic.h>
 #include <linux/sched.h>
 #include <linux/gfp.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/memtype.h>
 
 #include "memtype.h"
--- a/arch/x86/mm/setup_nx.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/mm/setup_nx.c
@@ -2,8 +2,8 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/proto.h>
 #include <asm/cpufeature.h>
 
--- a/arch/x86/platform/efi/efi_32.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/platform/efi/efi_32.c
@@ -24,11 +24,11 @@
 #include <linux/types.h>
 #include <linux/ioport.h>
 #include <linux/efi.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
 #include <asm/desc.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/efi.h>
 
--- a/arch/x86/platform/olpc/olpc_ofw.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/platform/olpc/olpc_ofw.c
@@ -3,12 +3,12 @@
 #include <linux/export.h>
 #include <linux/spinlock_types.h>
 #include <linux/init.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/setup.h>
 #include <asm/io.h>
 #include <asm/cpufeature.h>
 #include <asm/special_insns.h>
-#include <linux/pgtable.h>
 #include <asm/olpc_ofw.h>
 
 /* address of OFW callback interface; will be NULL if OFW isn't found */
--- a/arch/x86/power/cpu.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/power/cpu.c
@@ -13,8 +13,8 @@
 #include <linux/perf_event.h>
 #include <linux/tboot.h>
 #include <linux/dmi.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/proto.h>
 #include <asm/mtrr.h>
 #include <asm/page.h>
--- a/arch/x86/power/hibernate_32.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/power/hibernate_32.c
@@ -8,9 +8,9 @@
 #include <linux/gfp.h>
 #include <linux/suspend.h>
 #include <linux/memblock.h>
+#include <linux/pgtable.h>
 
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/mmzone.h>
 #include <asm/sections.h>
 #include <asm/suspend.h>
--- a/arch/x86/power/hibernate_64.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/power/hibernate_64.c
@@ -12,6 +12,7 @@
 #include <linux/suspend.h>
 #include <linux/scatterlist.h>
 #include <linux/kdebug.h>
+#include <linux/pgtable.h>
 
 #include <crypto/hash.h>
 
@@ -19,7 +20,6 @@
 #include <asm/init.h>
 #include <asm/proto.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/mtrr.h>
 #include <asm/sections.h>
 #include <asm/suspend.h>
--- a/arch/x86/power/hibernate.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/power/hibernate.c
@@ -12,6 +12,7 @@
 #include <linux/scatterlist.h>
 #include <linux/kdebug.h>
 #include <linux/cpu.h>
+#include <linux/pgtable.h>
 
 #include <crypto/hash.h>
 
@@ -19,7 +20,6 @@
 #include <asm/init.h>
 #include <asm/proto.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/mtrr.h>
 #include <asm/sections.h>
 #include <asm/suspend.h>
--- a/arch/x86/realmode/init.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/realmode/init.c
@@ -3,9 +3,9 @@
 #include <linux/slab.h>
 #include <linux/memblock.h>
 #include <linux/mem_encrypt.h>
+#include <linux/pgtable.h>
 
 #include <asm/set_memory.h>
-#include <linux/pgtable.h>
 #include <asm/realmode.h>
 #include <asm/tlbflush.h>
 #include <asm/crash.h>
--- a/arch/x86/xen/mmu_pv.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/xen/mmu_pv.c
@@ -51,13 +51,13 @@
 #include <linux/memblock.h>
 #include <linux/seq_file.h>
 #include <linux/crash_dump.h>
+#include <linux/pgtable.h>
 #ifdef CONFIG_KEXEC_CORE
 #include <linux/kexec.h>
 #endif
 
 #include <trace/events/xen.h>
 
-#include <linux/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
 #include <asm/mmu_context.h>
--- a/arch/x86/xen/smp_pv.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/x86/xen/smp_pv.c
@@ -23,6 +23,7 @@
 #include <linux/nmi.h>
 #include <linux/cpuhotplug.h>
 #include <linux/stackprotector.h>
+#include <linux/pgtable.h>
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
--- a/arch/xtensa/include/asm/fixmap.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/xtensa/include/asm/fixmap.h
@@ -13,9 +13,9 @@
 #ifndef _ASM_FIXMAP_H
 #define _ASM_FIXMAP_H
 
-#include <linux/pgtable.h>
 #ifdef CONFIG_HIGHMEM
 #include <linux/threads.h>
+#include <linux/pgtable.h>
 #include <asm/kmap_types.h>
 #endif
 
--- a/arch/xtensa/include/asm/highmem.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/xtensa/include/asm/highmem.h
@@ -13,10 +13,10 @@
 #define _XTENSA_HIGHMEM_H
 
 #include <linux/wait.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 #include <asm/kmap_types.h>
-#include <linux/pgtable.h>
 
 #define PKMAP_BASE		((FIXADDR_START - \
 				  (LAST_PKMAP + 1) * PAGE_SIZE) & PMD_MASK)
--- a/arch/xtensa/include/asm/mmu_context.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/xtensa/include/asm/mmu_context.h
@@ -18,10 +18,10 @@
 #include <linux/stringify.h>
 #include <linux/sched.h>
 #include <linux/mm_types.h>
+#include <linux/pgtable.h>
 
 #include <asm/vectors.h>
 
-#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm-generic/mm_hooks.h>
--- a/arch/xtensa/kernel/entry.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/xtensa/kernel/entry.S
@@ -13,6 +13,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/asm-offsets.h>
 #include <asm/asmmacro.h>
 #include <asm/processor.h>
@@ -22,7 +23,6 @@
 #include <asm/unistd.h>
 #include <asm/ptrace.h>
 #include <asm/current.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <asm/signal.h>
 #include <asm/tlbflush.h>
--- a/arch/xtensa/kernel/traps.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/xtensa/kernel/traps.c
@@ -34,12 +34,12 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/ratelimit.h>
+#include <linux/pgtable.h>
 
 #include <asm/stacktrace.h>
 #include <asm/ptrace.h>
 #include <asm/timex.h>
 #include <linux/uaccess.h>
-#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/traps.h>
 #include <asm/hw_breakpoint.h>
--- a/arch/xtensa/kernel/vectors.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/xtensa/kernel/vectors.S
@@ -43,11 +43,11 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/pgtable.h>
 #include <asm/asmmacro.h>
 #include <asm/ptrace.h>
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
-#include <linux/pgtable.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/thread_info.h>
--- a/arch/xtensa/mm/cache.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/xtensa/mm/cache.c
@@ -24,6 +24,7 @@
 #include <linux/memblock.h>
 #include <linux/swap.h>
 #include <linux/pagemap.h>
+#include <linux/pgtable.h>
 
 #include <asm/bootparam.h>
 #include <asm/mmu_context.h>
@@ -31,7 +32,6 @@
 #include <asm/tlbflush.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <linux/pgtable.h>
 
 /* 
  * Note:
--- a/arch/xtensa/mm/ioremap.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/xtensa/mm/ioremap.c
@@ -7,9 +7,9 @@
 
 #include <linux/io.h>
 #include <linux/vmalloc.h>
+#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 
 static void __iomem *xtensa_ioremap(unsigned long paddr, unsigned long size,
 				    pgprot_t prot)
--- a/arch/xtensa/mm/misc.S~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/arch/xtensa/mm/misc.S
@@ -14,8 +14,8 @@
 
 
 #include <linux/linkage.h>
-#include <asm/page.h>
 #include <linux/pgtable.h>
+#include <asm/page.h>
 #include <asm/asmmacro.h>
 #include <asm/cacheasm.h>
 #include <asm/tlbflush.h>
--- a/drivers/acpi/scan.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/acpi/scan.c
@@ -15,7 +15,6 @@
 #include <linux/nls.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_data/x86/apple.h>
-
 #include <linux/pgtable.h>
 
 #include "internal.h"
--- a/drivers/atm/fore200e.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/atm/fore200e.c
@@ -25,6 +25,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/string.h>
 #include <asm/page.h>
@@ -40,7 +41,6 @@
 #include <asm/idprom.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <linux/pgtable.h>
 #endif
 
 #if defined(CONFIG_ATM_FORE200E_USE_TASKLET) /* defer interrupt work to a tasklet */
--- a/drivers/block/z2ram.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/block/z2ram.c
@@ -35,10 +35,10 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pgtable.h>
 
 #include <asm/setup.h>
 #include <asm/amigahw.h>
-#include <linux/pgtable.h>
 
 #include <linux/zorro.h>
 
--- a/drivers/firmware/efi/arm-runtime.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/firmware/efi/arm-runtime.c
@@ -18,12 +18,12 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/pgtable.h>
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
 #include <asm/mmu.h>
 #include <asm/pgalloc.h>
-#include <linux/pgtable.h>
 
 #if defined(CONFIG_PTDUMP_DEBUGFS) && defined(CONFIG_ARM64)
 #include <asm/ptdump.h>
--- a/drivers/gpu/drm/drm_vm.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/gpu/drm/drm_vm.c
@@ -37,6 +37,7 @@
 #include <linux/pci.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
+#include <linux/pgtable.h>
 
 #if defined(__ia64__)
 #include <linux/efi.h>
@@ -44,7 +45,6 @@
 #endif
 #include <linux/mem_encrypt.h>
 
-#include <linux/pgtable.h>
 
 #include <drm/drm_agpsupport.h>
 #include <drm/drm_device.h>
--- a/drivers/infiniband/hw/qib/qib_file_ops.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -40,10 +40,10 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
-#include <linux/pgtable.h>
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/uio.h>
+#include <linux/pgtable.h>
 
 #include <rdma/ib.h>
 
--- a/drivers/macintosh/macio-adb.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/macintosh/macio-adb.c
@@ -9,10 +9,10 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <linux/adb.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/hydra.h>
 #include <asm/irq.h>
 #include <linux/init.h>
--- a/drivers/macintosh/mediabay.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/macintosh/mediabay.c
@@ -16,8 +16,8 @@
 #include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
-#include <asm/prom.h>
 #include <linux/pgtable.h>
+#include <asm/prom.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
 #include <asm/pmac_feature.h>
--- a/drivers/macintosh/via-pmu.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/macintosh/via-pmu.c
@@ -50,9 +50,9 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/uaccess.h>
+#include <linux/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/sections.h>
 #include <asm/irq.h>
 #ifdef CONFIG_PPC_PMAC
--- a/drivers/media/pci/bt8xx/bt878.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/media/pci/bt8xx/bt878.c
@@ -13,9 +13,9 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <linux/ioport.h>
-#include <linux/pgtable.h>
 #include <asm/page.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
--- a/drivers/media/pci/bt8xx/btcx-risc.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/media/pci/bt8xx/btcx-risc.c
@@ -17,8 +17,8 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/videodev2.h>
-#include <asm/page.h>
 #include <linux/pgtable.h>
+#include <asm/page.h>
 
 #include "btcx-risc.h"
 
--- a/drivers/media/pci/bt8xx/bttv-risc.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/media/pci/bt8xx/bttv-risc.c
@@ -20,8 +20,8 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
-#include <asm/page.h>
 #include <linux/pgtable.h>
+#include <asm/page.h>
 #include <media/v4l2-ioctl.h>
 
 #include "bttvp.h"
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -21,13 +21,13 @@
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/pgtable.h>
 
 #include <linux/dma-mapping.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 
 #include <media/videobuf-dma-sg.h>
 
--- a/drivers/media/v4l2-core/videobuf-vmalloc.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/media/v4l2-core/videobuf-vmalloc.c
@@ -15,12 +15,12 @@
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/pgtable.h>
 
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 
 #include <media/videobuf-vmalloc.h>
 
--- a/drivers/net/ethernet/amd/7990.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/amd/7990.c
@@ -28,6 +28,7 @@
 #include <linux/route.h>
 #include <linux/string.h>
 #include <linux/skbuff.h>
+#include <linux/pgtable.h>
 #include <asm/irq.h>
 /* Used for the temporal inet entries and routing */
 #include <linux/socket.h>
@@ -35,7 +36,6 @@
 
 #include <asm/io.h>
 #include <asm/dma.h>
-#include <linux/pgtable.h>
 #ifdef CONFIG_HP300
 #include <asm/blinken.h>
 #endif
--- a/drivers/net/ethernet/amd/hplance.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/amd/hplance.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/pgtable.h>
 /* Used for the temporal inet entries and routing */
 #include <linux/socket.h>
 #include <linux/route.h>
@@ -24,7 +25,6 @@
 #include <linux/skbuff.h>
 
 #include <asm/io.h>
-#include <linux/pgtable.h>
 
 #include "hplance.h"
 
--- a/drivers/net/ethernet/amd/mvme147.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/amd/mvme147.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/gfp.h>
+#include <linux/pgtable.h>
 /* Used for the temporal inet entries and routing */
 #include <linux/socket.h>
 #include <linux/route.h>
@@ -24,7 +25,6 @@
 #include <linux/skbuff.h>
 
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/mvme147hw.h>
 
 /* We have 32K of RAM for the init block and buffers. This places
--- a/drivers/net/ethernet/amd/sun3lance.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/amd/sun3lance.c
@@ -37,12 +37,12 @@ static const char version[] =
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/bitops.h>
+#include <linux/pgtable.h>
 
 #include <asm/cacheflush.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/dvma.h>
 #include <asm/idprom.h>
 #include <asm/machines.h>
--- a/drivers/net/ethernet/amd/sunlance.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/amd/sunlance.c
@@ -94,10 +94,10 @@ static char lancestr[] = "LANCE";
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/gfp.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
-#include <linux/pgtable.h>
 #include <asm/byteorder.h>	/* Used by the checksum routines */
 #include <asm/idprom.h>
 #include <asm/prom.h>
--- a/drivers/net/ethernet/apple/bmac.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/apple/bmac.c
@@ -24,11 +24,11 @@
 #include <linux/bitrev.h>
 #include <linux/ethtool.h>
 #include <linux/slab.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/dbdma.h>
 #include <asm/io.h>
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/pmac_feature.h>
 #include <asm/macio.h>
--- a/drivers/net/ethernet/apple/mace.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/apple/mace.c
@@ -19,10 +19,10 @@
 #include <linux/spinlock.h>
 #include <linux/bitrev.h>
 #include <linux/slab.h>
+#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/dbdma.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/macio.h>
 
 #include "mace.h"
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -40,9 +40,9 @@
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 #include <linux/of_net.h>
+#include <linux/pgtable.h>
 
 #include <linux/vmalloc.h>
-#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <linux/uaccess.h>
 
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
@@ -35,12 +35,12 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/gfp.h>
+#include <linux/pgtable.h>
 
 #include <asm/immap_cpm2.h>
 #include <asm/mpc8260.h>
 #include <asm/cpm2.h>
 
-#include <linux/pgtable.h>
 #include <asm/irq.h>
 #include <linux/uaccess.h>
 
--- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
@@ -32,8 +32,8 @@
 #include <linux/platform_device.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/irq.h>
 #include <linux/uaccess.h>
 #include <asm/mpc5xxx.h>
--- a/drivers/net/ethernet/i825xx/82596.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/i825xx/82596.c
@@ -53,10 +53,10 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/gfp.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
-#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 
 static char version[] __initdata =
--- a/drivers/net/ethernet/korina.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/korina.c
@@ -53,10 +53,10 @@
 #include <linux/mii.h>
 #include <linux/ethtool.h>
 #include <linux/crc32.h>
+#include <linux/pgtable.h>
 
 #include <asm/bootinfo.h>
 #include <asm/bitops.h>
-#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
--- a/drivers/net/ethernet/marvell/pxa168_eth.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -31,8 +31,8 @@
 #include <linux/types.h>
 #include <linux/udp.h>
 #include <linux/workqueue.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/cacheflush.h>
 
 #define DRIVER_NAME	"pxa168-eth"
--- a/drivers/net/ethernet/natsemi/jazzsonic.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -36,9 +36,9 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/pgtable.h>
 
 #include <asm/bootinfo.h>
-#include <linux/pgtable.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/jazz.h>
--- a/drivers/net/ethernet/natsemi/macsonic.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/natsemi/macsonic.c
@@ -51,8 +51,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/bitrev.h>
 #include <linux/slab.h>
-
 #include <linux/pgtable.h>
+
 #include <asm/io.h>
 #include <asm/hwtest.h>
 #include <asm/dma.h>
--- a/drivers/net/ethernet/natsemi/xtsonic.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/natsemi/xtsonic.c
@@ -35,9 +35,9 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/dma.h>
 
 static char xtsonic_string[] = "xtsonic";
--- a/drivers/net/ethernet/sun/sunbmac.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/sun/sunbmac.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/pgtable.h>
 
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -34,7 +35,6 @@
 #include <asm/io.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <linux/pgtable.h>
 
 #include "sunbmac.h"
 
--- a/drivers/net/ethernet/sun/sunqe.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/net/ethernet/sun/sunqe.c
@@ -28,6 +28,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -36,7 +37,6 @@
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/auxio.h>
-#include <linux/pgtable.h>
 #include <asm/irq.h>
 
 #include "sunqe.h"
--- a/drivers/scsi/53c700.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/scsi/53c700.c
@@ -116,9 +116,9 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
+#include <linux/pgtable.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/byteorder.h>
 
 #include <scsi/scsi.h>
--- a/drivers/scsi/arm/cumana_2.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/scsi/arm/cumana_2.c
@@ -23,11 +23,11 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
+#include <linux/pgtable.h>
 
 #include <asm/dma.h>
 #include <asm/ecard.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
--- a/drivers/scsi/arm/eesox.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/scsi/arm/eesox.c
@@ -29,11 +29,11 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
+#include <linux/pgtable.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/ecard.h>
-#include <linux/pgtable.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
--- a/drivers/scsi/arm/powertec.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/scsi/arm/powertec.c
@@ -14,11 +14,11 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
+#include <linux/pgtable.h>
 
 #include <asm/dma.h>
 #include <asm/ecard.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
--- a/drivers/scsi/dpt_i2o.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/scsi/dpt_i2o.c
@@ -27,6 +27,7 @@
 /*#define UARTDELAY 1 */
 
 #include <linux/module.h>
+#include <linux/pgtable.h>
 
 MODULE_AUTHOR("Deanna Bonds, with _lots_ of help from Mark Salyzyn");
 MODULE_DESCRIPTION("Adaptec I2O RAID Driver");
@@ -55,7 +56,6 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Dri
 #include <linux/mutex.h>
 
 #include <asm/processor.h>	/* for boot_cpu_data */
-#include <linux/pgtable.h>
 #include <asm/io.h>		/* for virt_to_bus, etc. */
 
 #include <scsi/scsi.h>
--- a/drivers/scsi/mac53c94.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/scsi/mac53c94.c
@@ -20,9 +20,9 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/pgtable.h>
 #include <asm/dbdma.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/macio.h>
 
--- a/drivers/scsi/mesh.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/scsi/mesh.c
@@ -31,9 +31,9 @@
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
+#include <linux/pgtable.h>
 #include <asm/dbdma.h>
 #include <asm/io.h>
-#include <linux/pgtable.h>
 #include <asm/prom.h>
 #include <asm/irq.h>
 #include <asm/hydra.h>
--- a/drivers/scsi/qlogicpti.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/scsi/qlogicpti.c
@@ -30,6 +30,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/firmware.h>
+#include <linux/pgtable.h>
 
 #include <asm/byteorder.h>
 
@@ -37,7 +38,6 @@
 
 #include <asm/dma.h>
 #include <asm/ptrace.h>
-#include <linux/pgtable.h>
 #include <asm/oplib.h>
 #include <asm/io.h>
 #include <asm/irq.h>
--- a/drivers/scsi/zorro_esp.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/drivers/scsi/zorro_esp.c
@@ -34,9 +34,9 @@
 #include <linux/delay.h>
 #include <linux/zorro.h>
 #include <linux/slab.h>
+#include <linux/pgtable.h>
 
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
--- a/include/linux/crash_dump.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/include/linux/crash_dump.h
@@ -5,6 +5,7 @@
 #include <linux/kexec.h>
 #include <linux/proc_fs.h>
 #include <linux/elf.h>
+#include <linux/pgtable.h>
 #include <uapi/linux/vmcore.h>
 
 #include <linux/pgtable.h> /* for pgprot_t */
--- a/include/linux/io-mapping.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/include/linux/io-mapping.h
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/bug.h>
 #include <linux/io.h>
+#include <linux/pgtable.h>
 #include <asm/page.h>
 
 /*
@@ -99,7 +100,6 @@ io_mapping_unmap(void __iomem *vaddr)
 #else
 
 #include <linux/uaccess.h>
-#include <linux/pgtable.h>
 
 /* Create the io_mapping object*/
 static inline struct io_mapping *
--- a/include/linux/kasan.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/include/linux/kasan.h
@@ -11,8 +11,8 @@ struct task_struct;
 
 #ifdef CONFIG_KASAN
 
-#include <asm/kasan.h>
 #include <linux/pgtable.h>
+#include <asm/kasan.h>
 
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
 extern pte_t kasan_early_shadow_pte[PTRS_PER_PTE];
--- a/include/linux/mm.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/include/linux/mm.h
@@ -28,6 +28,7 @@
 #include <linux/overflow.h>
 #include <linux/sizes.h>
 #include <linux/sched.h>
+#include <linux/pgtable.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -92,7 +93,6 @@ extern int mmap_rnd_compat_bits __read_m
 #endif
 
 #include <asm/page.h>
-#include <linux/pgtable.h>
 #include <asm/processor.h>
 
 /*
--- a/include/xen/arm/page.h~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/include/xen/arm/page.h
@@ -3,11 +3,11 @@
 #define _ASM_ARM_XEN_PAGE_H
 
 #include <asm/page.h>
-#include <linux/pgtable.h>
 
 #include <linux/pfn.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
+#include <linux/pgtable.h>
 
 #include <xen/xen.h>
 #include <xen/interface/grant_table.h>
--- a/mm/init-mm.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/mm/init-mm.c
@@ -6,10 +6,10 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/mman.h>
+#include <linux/pgtable.h>
 
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
-#include <linux/pgtable.h>
 #include <asm/mmu.h>
 
 #ifndef INIT_MM_CONTEXT
--- a/mm/mincore.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/mm/mincore.c
@@ -17,9 +17,9 @@
 #include <linux/swapops.h>
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
+#include <linux/pgtable.h>
 
 #include <linux/uaccess.h>
-#include <linux/pgtable.h>
 
 static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
--- a/mm/zsmalloc.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/mm/zsmalloc.c
@@ -39,8 +39,8 @@
 #include <linux/highmem.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <asm/tlbflush.h>
 #include <linux/pgtable.h>
+#include <asm/tlbflush.h>
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
 #include <linux/vmalloc.h>
--- a/sound/pci/hda/hda_intel.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/sound/pci/hda/hda_intel.c
@@ -36,10 +36,10 @@
 #include <linux/time.h>
 #include <linux/completion.h>
 #include <linux/acpi.h>
+#include <linux/pgtable.h>
 
 #ifdef CONFIG_X86
 /* for snoop control */
-#include <linux/pgtable.h>
 #include <asm/set_memory.h>
 #include <asm/cpufeature.h>
 #endif
--- a/sound/soc/intel/common/sst-firmware.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/sound/soc/intel/common/sst-firmware.c
@@ -16,12 +16,12 @@
 #include <linux/dmaengine.h>
 #include <linux/pci.h>
 #include <linux/acpi.h>
+#include <linux/pgtable.h>
 
 /* supported DMA engine drivers */
 #include <linux/dma/dw.h>
 
 #include <asm/page.h>
-#include <linux/pgtable.h>
 
 #include "sst-dsp.h"
 #include "sst-dsp-priv.h"
--- a/sound/soc/intel/haswell/sst-haswell-pcm.c~mm-reorder-includes-after-introduction-of-linux-pgtableh
+++ a/sound/soc/intel/haswell/sst-haswell-pcm.c
@@ -10,8 +10,8 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/pm_runtime.h>
-#include <asm/page.h>
 #include <linux/pgtable.h>
+#include <asm/page.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
_
