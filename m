From: akpm@linux-foundation.org
Subject: - detach-schedh-from-mmh.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:58 -0700
Message-ID: <200705212009.l4LK9vMr018798@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45633 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965540AbXEUUL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:11:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Detach sched.h from mm.h
has been removed from the -mm tree.  Its filename was
     detach-schedh-from-mmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Detach sched.h from mm.h
From: Alexey Dobriyan <adobriyan@gmail.com>

First thing mm.h does is including sched.h solely for can_do_mlock() inline
function which has "current" dereference inside.  By dealing with
can_do_mlock() mm.h can be detached from sched.h which is good.  See below,
why.

This patch
a) removes unconditional inclusion of sched.h from mm.h
b) makes can_do_mlock() normal function in mm/mlock.c
c) exports can_do_mlock() to not break compilation
d) adds sched.h inclusions back to files that were getting it indirectly.
e) adds less bloated headers to some files (asm/signal.h, jiffies.h) that were
   getting them indirectly

Net result is:
a) mm.h users would get less code to open, read, preprocess, parse, ... if
   they don't need sched.h
b) sched.h stops being dependency for significant number of files:
   on x86_64 allmodconfig touching sched.h results in recompile of 4083 files,
   after patch it's only 3744 (-8.3%).

Cross-compile tested on

	all arm defconfigs, all mips defconfigs, all powerpc defconfigs,
	alpha alpha-up
	arm
	i386 i386-up i386-defconfig i386-allnoconfig
	ia64 ia64-up
	m68k
	mips
	parisc parisc-up
	powerpc powerpc-up
	s390 s390-up
	sparc sparc-up
	sparc64 sparc64-up
	um-x86_64
	x86_64 x86_64-up x86_64-defconfig x86_64-allnoconfig

as well as my two usual configs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-iop13xx/pci.c                  |    3 ++-
 arch/arm/mm/mmap.c                           |    2 +-
 arch/arm/plat-iop/pci.c                      |    1 +
 arch/i386/kernel/cpu/cpufreq/speedstep-ich.c |    1 +
 arch/i386/kernel/cpu/cyrix.c                 |    1 +
 arch/i386/mm/mmap.c                          |    1 +
 arch/mips/kernel/unaligned.c                 |    2 +-
 arch/mips/mm/ioremap.c                       |    2 +-
 arch/parisc/kernel/cache.c                   |    2 +-
 arch/parisc/kernel/processor.c               |    2 +-
 arch/powerpc/mm/mmap.c                       |    1 +
 arch/x86_64/ia32/mmap32.c                    |    1 +
 arch/x86_64/kernel/reboot.c                  |    1 +
 drivers/base/dmapool.c                       |    1 +
 drivers/char/agp/frontend.c                  |    1 +
 drivers/char/agp/generic.c                   |    1 +
 drivers/char/hangcheck-timer.c               |    2 +-
 drivers/infiniband/core/cache.c              |    1 +
 drivers/infiniband/core/device.c             |    1 +
 drivers/infiniband/core/umem.c               |    1 +
 drivers/infiniband/hw/mthca/mthca_cmd.c      |    1 +
 drivers/infiniband/hw/mthca/mthca_cq.c       |    1 +
 drivers/infiniband/hw/mthca/mthca_memfree.c  |    1 +
 drivers/infiniband/hw/mthca/mthca_qp.c       |    1 +
 drivers/infiniband/hw/mthca/mthca_srq.c      |    1 +
 drivers/isdn/icn/icn.c                       |    1 +
 drivers/isdn/sc/message.c                    |    2 +-
 drivers/kvm/kvm.h                            |    1 +
 drivers/kvm/kvm_main.c                       |    1 +
 drivers/kvm/svm.c                            |    1 +
 drivers/kvm/vmx.c                            |    1 +
 drivers/oprofile/buffer_sync.c               |    1 +
 drivers/pci/hotplug/ibmphp_hpc.c             |    1 +
 drivers/pci/pcie/aer/aerdrv.h                |    1 +
 drivers/scsi/megaraid/megaraid_mm.c          |    2 +-
 fs/9p/vfs_addr.c                             |    1 +
 fs/9p/vfs_dentry.c                           |    1 +
 fs/9p/vfs_inode.c                            |    1 +
 fs/9p/vfs_super.c                            |    1 +
 fs/affs/inode.c                              |    2 +-
 fs/affs/super.c                              |    1 +
 fs/afs/callback.c                            |    1 +
 fs/afs/cell.c                                |    1 +
 fs/afs/dir.c                                 |    1 +
 fs/afs/inode.c                               |    1 +
 fs/afs/internal.h                            |    1 +
 fs/afs/main.c                                |    1 +
 fs/afs/proc.c                                |    1 +
 fs/afs/security.c                            |    1 +
 fs/afs/super.c                               |    1 +
 fs/afs/vlocation.c                           |    1 +
 fs/afs/vnode.c                               |    1 +
 fs/afs/volume.c                              |    1 +
 fs/binfmt_misc.c                             |    2 +-
 fs/coda/cache.c                              |    1 +
 fs/coda/upcall.c                             |    2 +-
 fs/configfs/inode.c                          |    1 +
 fs/ecryptfs/messaging.c                      |    2 +-
 fs/fifo.c                                    |    1 +
 fs/fuse/file.c                               |    1 +
 fs/fuse/inode.c                              |    1 +
 fs/gfs2/glock.h                              |    1 +
 fs/hfs/inode.c                               |    1 +
 fs/hfsplus/inode.c                           |    1 +
 fs/hpfs/buffer.c                             |    2 +-
 fs/hpfs/namei.c                              |    2 +-
 fs/hpfs/super.c                              |    1 +
 fs/minix/bitmap.c                            |    1 +
 fs/ncpfs/file.c                              |    1 +
 fs/ncpfs/ioctl.c                             |    1 +
 fs/nfs/client.c                              |    2 +-
 fs/nfs/dir.c                                 |    1 +
 fs/nfs/file.c                                |    1 +
 fs/nfs/inode.c                               |    2 +-
 fs/nfs/pagelist.c                            |    1 +
 fs/nfsd/nfs4callback.c                       |    1 +
 fs/nfsd/nfs4recover.c                        |    2 +-
 fs/nfsd/nfssvc.c                             |    2 +-
 fs/ntfs/file.c                               |    1 +
 fs/ramfs/inode.c                             |    2 +-
 fs/smbfs/dir.c                               |    1 +
 fs/smbfs/file.c                              |    1 +
 fs/smbfs/inode.c                             |    1 +
 fs/smbfs/request.c                           |    1 +
 fs/sysfs/inode.c                             |    1 +
 fs/udf/file.c                                |    1 +
 fs/udf/namei.c                               |    1 +
 include/asm-arm/tlbflush.h                   |    2 ++
 include/asm-i386/tlbflush.h                  |    2 ++
 include/asm-mips/pgalloc.h                   |    1 +
 include/asm-parisc/mmu_context.h             |    1 +
 include/asm-parisc/tlbflush.h                |    1 +
 include/asm-powerpc/mmu_context.h            |    1 +
 include/asm-x86_64/calgary.h                 |    1 +
 include/asm-x86_64/tlbflush.h                |    1 +
 include/linux/mm.h                           |   11 ++---------
 include/linux/smb_fs.h                       |    1 +
 include/linux/task_io_accounting_ops.h       |    2 ++
 include/linux/writeback.h                    |    2 ++
 include/rdma/ib_umem.h                       |    1 +
 kernel/profile.c                             |    1 +
 kernel/time/ntp.c                            |    2 ++
 lib/ioremap.c                                |    2 +-
 mm/filemap_xip.c                             |    1 +
 mm/madvise.c                                 |    1 +
 mm/mlock.c                                   |   11 +++++++++++
 mm/msync.c                                   |    1 +
 mm/vmstat.c                                  |    1 +
 sound/sound_firmware.c                       |    1 +
 109 files changed, 126 insertions(+), 30 deletions(-)

diff -puN arch/arm/mach-iop13xx/pci.c~detach-schedh-from-mmh arch/arm/mach-iop13xx/pci.c
--- a/arch/arm/mach-iop13xx/pci.c~detach-schedh-from-mmh
+++ a/arch/arm/mach-iop13xx/pci.c
@@ -19,10 +19,11 @@
 
 #include <linux/pci.h>
 #include <linux/delay.h>
-
+#include <linux/jiffies.h>
 #include <asm/irq.h>
 #include <asm/hardware.h>
 #include <asm/sizes.h>
+#include <asm/signal.h>
 #include <asm/mach/pci.h>
 #include <asm/arch/pci.h>
 
diff -puN arch/arm/mm/mmap.c~detach-schedh-from-mmh arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~detach-schedh-from-mmh
+++ a/arch/arm/mm/mmap.c
@@ -5,7 +5,7 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/shm.h>
-
+#include <linux/sched.h>
 #include <asm/system.h>
 
 #define COLOUR_ALIGN(addr,pgoff)		\
diff -puN arch/arm/plat-iop/pci.c~detach-schedh-from-mmh arch/arm/plat-iop/pci.c
--- a/arch/arm/plat-iop/pci.c~detach-schedh-from-mmh
+++ a/arch/arm/plat-iop/pci.c
@@ -19,6 +19,7 @@
 #include <linux/ioport.h>
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/signal.h>
 #include <asm/system.h>
 #include <asm/hardware.h>
 #include <asm/mach/pci.h>
diff -puN arch/i386/kernel/cpu/cpufreq/speedstep-ich.c~detach-schedh-from-mmh arch/i386/kernel/cpu/cpufreq/speedstep-ich.c
--- a/arch/i386/kernel/cpu/cpufreq/speedstep-ich.c~detach-schedh-from-mmh
+++ a/arch/i386/kernel/cpu/cpufreq/speedstep-ich.c
@@ -24,6 +24,7 @@
 #include <linux/cpufreq.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include "speedstep-lib.h"
 
diff -puN arch/i386/kernel/cpu/cyrix.c~detach-schedh-from-mmh arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c~detach-schedh-from-mmh
+++ a/arch/i386/kernel/cpu/cyrix.c
@@ -7,6 +7,7 @@
 #include <asm/processor.h>
 #include <asm/timer.h>
 #include <asm/pci-direct.h>
+#include <asm/tsc.h>
 
 #include "cpu.h"
 
diff -puN arch/i386/mm/mmap.c~detach-schedh-from-mmh arch/i386/mm/mmap.c
--- a/arch/i386/mm/mmap.c~detach-schedh-from-mmh
+++ a/arch/i386/mm/mmap.c
@@ -27,6 +27,7 @@
 #include <linux/personality.h>
 #include <linux/mm.h>
 #include <linux/random.h>
+#include <linux/sched.h>
 
 /*
  * Top of mmap area (just below the process stack).
diff -puN arch/mips/kernel/unaligned.c~detach-schedh-from-mmh arch/mips/kernel/unaligned.c
--- a/arch/mips/kernel/unaligned.c~detach-schedh-from-mmh
+++ a/arch/mips/kernel/unaligned.c
@@ -76,7 +76,7 @@
 #include <linux/module.h>
 #include <linux/signal.h>
 #include <linux/smp.h>
-
+#include <linux/sched.h>
 #include <asm/asm.h>
 #include <asm/branch.h>
 #include <asm/byteorder.h>
diff -puN arch/mips/mm/ioremap.c~detach-schedh-from-mmh arch/mips/mm/ioremap.c
--- a/arch/mips/mm/ioremap.c~detach-schedh-from-mmh
+++ a/arch/mips/mm/ioremap.c
@@ -9,7 +9,7 @@
 #include <linux/module.h>
 #include <asm/addrspace.h>
 #include <asm/byteorder.h>
-
+#include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/io.h>
diff -puN arch/parisc/kernel/cache.c~detach-schedh-from-mmh arch/parisc/kernel/cache.c
--- a/arch/parisc/kernel/cache.c~detach-schedh-from-mmh
+++ a/arch/parisc/kernel/cache.c
@@ -18,7 +18,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/pagemap.h>
-
+#include <linux/sched.h>
 #include <asm/pdc.h>
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
diff -puN arch/parisc/kernel/processor.c~detach-schedh-from-mmh arch/parisc/kernel/processor.c
--- a/arch/parisc/kernel/processor.c~detach-schedh-from-mmh
+++ a/arch/parisc/kernel/processor.c
@@ -33,7 +33,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
-
+#include <asm/param.h>
 #include <asm/cache.h>
 #include <asm/hardware.h>	/* for register_parisc_driver() stuff */
 #include <asm/processor.h>
diff -puN arch/powerpc/mm/mmap.c~detach-schedh-from-mmh arch/powerpc/mm/mmap.c
--- a/arch/powerpc/mm/mmap.c~detach-schedh-from-mmh
+++ a/arch/powerpc/mm/mmap.c
@@ -24,6 +24,7 @@
 
 #include <linux/personality.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 
 /*
  * Top of mmap area (just below the process stack).
diff -puN arch/x86_64/ia32/mmap32.c~detach-schedh-from-mmh arch/x86_64/ia32/mmap32.c
--- a/arch/x86_64/ia32/mmap32.c~detach-schedh-from-mmh
+++ a/arch/x86_64/ia32/mmap32.c
@@ -29,6 +29,7 @@
 #include <linux/personality.h>
 #include <linux/mm.h>
 #include <linux/random.h>
+#include <linux/sched.h>
 
 /*
  * Top of mmap area (just below the process stack).
diff -puN arch/x86_64/kernel/reboot.c~detach-schedh-from-mmh arch/x86_64/kernel/reboot.c
--- a/arch/x86_64/kernel/reboot.c~detach-schedh-from-mmh
+++ a/arch/x86_64/kernel/reboot.c
@@ -8,6 +8,7 @@
 #include <linux/string.h>
 #include <linux/pm.h>
 #include <linux/kdebug.h>
+#include <linux/sched.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/hw_irq.h>
diff -puN drivers/base/dmapool.c~detach-schedh-from-mmh drivers/base/dmapool.c
--- a/drivers/base/dmapool.c~detach-schedh-from-mmh
+++ a/drivers/base/dmapool.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/poison.h>
+#include <linux/sched.h>
 
 /*
  * Pool allocator ... wraps the dma_alloc_coherent page allocator, so
diff -puN drivers/char/agp/frontend.c~detach-schedh-from-mmh drivers/char/agp/frontend.c
--- a/drivers/char/agp/frontend.c~detach-schedh-from-mmh
+++ a/drivers/char/agp/frontend.c
@@ -37,6 +37,7 @@
 #include <linux/agpgart.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include "agp.h"
diff -puN drivers/char/agp/generic.c~detach-schedh-from-mmh drivers/char/agp/generic.c
--- a/drivers/char/agp/generic.c~detach-schedh-from-mmh
+++ a/drivers/char/agp/generic.c
@@ -37,6 +37,7 @@
 #include <linux/vmalloc.h>
 #include <linux/dma-mapping.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
diff -puN drivers/char/hangcheck-timer.c~detach-schedh-from-mmh drivers/char/hangcheck-timer.c
--- a/drivers/char/hangcheck-timer.c~detach-schedh-from-mmh
+++ a/drivers/char/hangcheck-timer.c
@@ -48,7 +48,7 @@
 #include <linux/delay.h>
 #include <asm/uaccess.h>
 #include <linux/sysrq.h>
-
+#include <linux/timer.h>
 
 #define VERSION_STR "0.9.0"
 
diff -puN drivers/infiniband/core/cache.c~detach-schedh-from-mmh drivers/infiniband/core/cache.c
--- a/drivers/infiniband/core/cache.c~detach-schedh-from-mmh
+++ a/drivers/infiniband/core/cache.c
@@ -38,6 +38,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 
 #include <rdma/ib_cache.h>
 
diff -puN drivers/infiniband/core/device.c~detach-schedh-from-mmh drivers/infiniband/core/device.c
--- a/drivers/infiniband/core/device.c~detach-schedh-from-mmh
+++ a/drivers/infiniband/core/device.c
@@ -40,6 +40,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/workqueue.h>
 
 #include "core_priv.h"
 
diff -puN drivers/infiniband/core/umem.c~detach-schedh-from-mmh drivers/infiniband/core/umem.c
--- a/drivers/infiniband/core/umem.c~detach-schedh-from-mmh
+++ a/drivers/infiniband/core/umem.c
@@ -36,6 +36,7 @@
 
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
+#include <linux/sched.h>
 
 #include "uverbs.h"
 
diff -puN drivers/infiniband/hw/mthca/mthca_cmd.c~detach-schedh-from-mmh drivers/infiniband/hw/mthca/mthca_cmd.c
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c~detach-schedh-from-mmh
+++ a/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -37,6 +37,7 @@
 #include <linux/completion.h>
 #include <linux/pci.h>
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include <asm/io.h>
 #include <rdma/ib_mad.h>
 
diff -puN drivers/infiniband/hw/mthca/mthca_cq.c~detach-schedh-from-mmh drivers/infiniband/hw/mthca/mthca_cq.c
--- a/drivers/infiniband/hw/mthca/mthca_cq.c~detach-schedh-from-mmh
+++ a/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -37,6 +37,7 @@
  */
 
 #include <linux/hardirq.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 
diff -puN drivers/infiniband/hw/mthca/mthca_memfree.c~detach-schedh-from-mmh drivers/infiniband/hw/mthca/mthca_memfree.c
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c~detach-schedh-from-mmh
+++ a/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -36,6 +36,7 @@
 
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
+#include <linux/sched.h>
 
 #include <asm/page.h>
 
diff -puN drivers/infiniband/hw/mthca/mthca_qp.c~detach-schedh-from-mmh drivers/infiniband/hw/mthca/mthca_qp.c
--- a/drivers/infiniband/hw/mthca/mthca_qp.c~detach-schedh-from-mmh
+++ a/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -37,6 +37,7 @@
 
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 
diff -puN drivers/infiniband/hw/mthca/mthca_srq.c~detach-schedh-from-mmh drivers/infiniband/hw/mthca/mthca_srq.c
--- a/drivers/infiniband/hw/mthca/mthca_srq.c~detach-schedh-from-mmh
+++ a/drivers/infiniband/hw/mthca/mthca_srq.c
@@ -34,6 +34,7 @@
 
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 
diff -puN drivers/isdn/icn/icn.c~detach-schedh-from-mmh drivers/isdn/icn/icn.c
--- a/drivers/isdn/icn/icn.c~detach-schedh-from-mmh
+++ a/drivers/isdn/icn/icn.c
@@ -12,6 +12,7 @@
 #include "icn.h"
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 
 static int portbase = ICN_BASEADDR;
 static unsigned long membase = ICN_MEMADDR;
diff -puN drivers/isdn/sc/message.c~detach-schedh-from-mmh drivers/isdn/sc/message.c
--- a/drivers/isdn/sc/message.c~detach-schedh-from-mmh
+++ a/drivers/isdn/sc/message.c
@@ -16,7 +16,7 @@
  *     +1 (416) 297-8565
  *     +1 (416) 297-6433 Facsimile
  */
-
+#include <linux/sched.h>
 #include "includes.h"
 #include "hardware.h"
 #include "message.h"
diff -puN drivers/kvm/kvm.h~detach-schedh-from-mmh drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~detach-schedh-from-mmh
+++ a/drivers/kvm/kvm.h
@@ -11,6 +11,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/mm.h>
+#include <asm/signal.h>
 
 #include "vmx.h"
 #include <linux/kvm.h>
diff -puN drivers/kvm/kvm_main.c~detach-schedh-from-mmh drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~detach-schedh-from-mmh
+++ a/drivers/kvm/kvm_main.c
@@ -40,6 +40,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
+#include <linux/sched.h>
 
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
diff -puN drivers/kvm/svm.c~detach-schedh-from-mmh drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~detach-schedh-from-mmh
+++ a/drivers/kvm/svm.c
@@ -19,6 +19,7 @@
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 #include <linux/profile.h>
+#include <linux/sched.h>
 #include <asm/desc.h>
 
 #include "kvm_svm.h"
diff -puN drivers/kvm/vmx.c~detach-schedh-from-mmh drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~detach-schedh-from-mmh
+++ a/drivers/kvm/vmx.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/profile.h>
+#include <linux/sched.h>
 #include <asm/io.h>
 #include <asm/desc.h>
 
diff -puN drivers/oprofile/buffer_sync.c~detach-schedh-from-mmh drivers/oprofile/buffer_sync.c
--- a/drivers/oprofile/buffer_sync.c~detach-schedh-from-mmh
+++ a/drivers/oprofile/buffer_sync.c
@@ -26,6 +26,7 @@
 #include <linux/profile.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/sched.h>
  
 #include "oprofile_stats.h"
 #include "event_buffer.h"
diff -puN drivers/pci/hotplug/ibmphp_hpc.c~detach-schedh-from-mmh drivers/pci/hotplug/ibmphp_hpc.c
--- a/drivers/pci/hotplug/ibmphp_hpc.c~detach-schedh-from-mmh
+++ a/drivers/pci/hotplug/ibmphp_hpc.c
@@ -34,6 +34,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 
 #include "ibmphp.h"
 
diff -puN drivers/pci/pcie/aer/aerdrv.h~detach-schedh-from-mmh drivers/pci/pcie/aer/aerdrv.h
--- a/drivers/pci/pcie/aer/aerdrv.h~detach-schedh-from-mmh
+++ a/drivers/pci/pcie/aer/aerdrv.h
@@ -8,6 +8,7 @@
 #ifndef _AERDRV_H_
 #define _AERDRV_H_
 
+#include <linux/workqueue.h>
 #include <linux/pcieport_if.h>
 #include <linux/aer.h>
 
diff -puN drivers/scsi/megaraid/megaraid_mm.c~detach-schedh-from-mmh drivers/scsi/megaraid/megaraid_mm.c
--- a/drivers/scsi/megaraid/megaraid_mm.c~detach-schedh-from-mmh
+++ a/drivers/scsi/megaraid/megaraid_mm.c
@@ -14,7 +14,7 @@
  *
  * Common management module
  */
-
+#include <linux/sched.h>
 #include "megaraid_mm.h"
 
 
diff -puN fs/9p/vfs_addr.c~detach-schedh-from-mmh fs/9p/vfs_addr.c
--- a/fs/9p/vfs_addr.c~detach-schedh-from-mmh
+++ a/fs/9p/vfs_addr.c
@@ -32,6 +32,7 @@
 #include <linux/inet.h>
 #include <linux/pagemap.h>
 #include <linux/idr.h>
+#include <linux/sched.h>
 
 #include "debug.h"
 #include "v9fs.h"
diff -puN fs/9p/vfs_dentry.c~detach-schedh-from-mmh fs/9p/vfs_dentry.c
--- a/fs/9p/vfs_dentry.c~detach-schedh-from-mmh
+++ a/fs/9p/vfs_dentry.c
@@ -33,6 +33,7 @@
 #include <linux/inet.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
+#include <linux/sched.h>
 
 #include "debug.h"
 #include "v9fs.h"
diff -puN fs/9p/vfs_inode.c~detach-schedh-from-mmh fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~detach-schedh-from-mmh
+++ a/fs/9p/vfs_inode.c
@@ -33,6 +33,7 @@
 #include <linux/inet.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
+#include <linux/sched.h>
 
 #include "debug.h"
 #include "v9fs.h"
diff -puN fs/9p/vfs_super.c~detach-schedh-from-mmh fs/9p/vfs_super.c
--- a/fs/9p/vfs_super.c~detach-schedh-from-mmh
+++ a/fs/9p/vfs_super.c
@@ -36,6 +36,7 @@
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/idr.h>
+#include <linux/sched.h>
 
 #include "debug.h"
 #include "v9fs.h"
diff -puN fs/affs/inode.c~detach-schedh-from-mmh fs/affs/inode.c
--- a/fs/affs/inode.c~detach-schedh-from-mmh
+++ a/fs/affs/inode.c
@@ -9,7 +9,7 @@
  *
  *  (C) 1991  Linus Torvalds - minix filesystem
  */
-
+#include <linux/sched.h>
 #include "affs.h"
 
 extern const struct inode_operations affs_symlink_inode_operations;
diff -puN fs/affs/super.c~detach-schedh-from-mmh fs/affs/super.c
--- a/fs/affs/super.c~detach-schedh-from-mmh
+++ a/fs/affs/super.c
@@ -15,6 +15,7 @@
 #include <linux/statfs.h>
 #include <linux/parser.h>
 #include <linux/magic.h>
+#include <linux/sched.h>
 #include "affs.h"
 
 extern struct timezone sys_tz;
diff -puN fs/afs/callback.c~detach-schedh-from-mmh fs/afs/callback.c
--- a/fs/afs/callback.c~detach-schedh-from-mmh
+++ a/fs/afs/callback.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/circ_buf.h>
+#include <linux/sched.h>
 #include "internal.h"
 
 unsigned afs_vnode_update_timeout = 10;
diff -puN fs/afs/cell.c~detach-schedh-from-mmh fs/afs/cell.c
--- a/fs/afs/cell.c~detach-schedh-from-mmh
+++ a/fs/afs/cell.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/key.h>
 #include <linux/ctype.h>
+#include <linux/sched.h>
 #include <keys/rxrpc-type.h>
 #include "internal.h"
 
diff -puN fs/afs/dir.c~detach-schedh-from-mmh fs/afs/dir.c
--- a/fs/afs/dir.c~detach-schedh-from-mmh
+++ a/fs/afs/dir.c
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/ctype.h>
+#include <linux/sched.h>
 #include "internal.h"
 
 static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
diff -puN fs/afs/inode.c~detach-schedh-from-mmh fs/afs/inode.c
--- a/fs/afs/inode.c~detach-schedh-from-mmh
+++ a/fs/afs/inode.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/sched.h>
 #include "internal.h"
 
 struct afs_iget_data {
diff -puN fs/afs/internal.h~detach-schedh-from-mmh fs/afs/internal.h
--- a/fs/afs/internal.h~detach-schedh-from-mmh
+++ a/fs/afs/internal.h
@@ -16,6 +16,7 @@
 #include <linux/skbuff.h>
 #include <linux/rxrpc.h>
 #include <linux/key.h>
+#include <linux/workqueue.h>
 #include "afs.h"
 #include "afs_vl.h"
 
diff -puN fs/afs/main.c~detach-schedh-from-mmh fs/afs/main.c
--- a/fs/afs/main.c~detach-schedh-from-mmh
+++ a/fs/afs/main.c
@@ -13,6 +13,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/completion.h>
+#include <linux/sched.h>
 #include "internal.h"
 
 MODULE_DESCRIPTION("AFS Client File System");
diff -puN fs/afs/proc.c~detach-schedh-from-mmh fs/afs/proc.c
--- a/fs/afs/proc.c~detach-schedh-from-mmh
+++ a/fs/afs/proc.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff -puN fs/afs/security.c~detach-schedh-from-mmh fs/afs/security.c
--- a/fs/afs/security.c~detach-schedh-from-mmh
+++ a/fs/afs/security.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/ctype.h>
+#include <linux/sched.h>
 #include <keys/rxrpc-type.h>
 #include "internal.h"
 
diff -puN fs/afs/super.c~detach-schedh-from-mmh fs/afs/super.c
--- a/fs/afs/super.c~detach-schedh-from-mmh
+++ a/fs/afs/super.c
@@ -22,6 +22,7 @@
 #include <linux/pagemap.h>
 #include <linux/parser.h>
 #include <linux/statfs.h>
+#include <linux/sched.h>
 #include "internal.h"
 
 #define AFS_FS_MAGIC 0x6B414653 /* 'kAFS' */
diff -puN fs/afs/vlocation.c~detach-schedh-from-mmh fs/afs/vlocation.c
--- a/fs/afs/vlocation.c~detach-schedh-from-mmh
+++ a/fs/afs/vlocation.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include "internal.h"
 
 unsigned afs_vlocation_timeout = 10;	/* volume location timeout in seconds */
diff -puN fs/afs/vnode.c~detach-schedh-from-mmh fs/afs/vnode.c
--- a/fs/afs/vnode.c~detach-schedh-from-mmh
+++ a/fs/afs/vnode.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
+#include <linux/sched.h>
 #include "internal.h"
 
 #if 0
diff -puN fs/afs/volume.c~detach-schedh-from-mmh fs/afs/volume.c
--- a/fs/afs/volume.c~detach-schedh-from-mmh
+++ a/fs/afs/volume.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/sched.h>
 #include "internal.h"
 
 static const char *afs_voltypes[] = { "R/W", "R/O", "BAK" };
diff -puN fs/binfmt_misc.c~detach-schedh-from-mmh fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~detach-schedh-from-mmh
+++ a/fs/binfmt_misc.c
@@ -18,7 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-
+#include <linux/sched.h>
 #include <linux/binfmts.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
diff -puN fs/coda/cache.c~detach-schedh-from-mmh fs/coda/cache.c
--- a/fs/coda/cache.c~detach-schedh-from-mmh
+++ a/fs/coda/cache.c
@@ -16,6 +16,7 @@
 #include <asm/uaccess.h>
 #include <linux/string.h>
 #include <linux/list.h>
+#include <linux/sched.h>
 
 #include <linux/coda.h>
 #include <linux/coda_linux.h>
diff -puN fs/coda/upcall.c~detach-schedh-from-mmh fs/coda/upcall.c
--- a/fs/coda/upcall.c~detach-schedh-from-mmh
+++ a/fs/coda/upcall.c
@@ -16,7 +16,7 @@
 
 #include <asm/system.h>
 #include <linux/signal.h>
-
+#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
diff -puN fs/configfs/inode.c~detach-schedh-from-mmh fs/configfs/inode.c
--- a/fs/configfs/inode.c~detach-schedh-from-mmh
+++ a/fs/configfs/inode.c
@@ -32,6 +32,7 @@
 #include <linux/namei.h>
 #include <linux/backing-dev.h>
 #include <linux/capability.h>
+#include <linux/sched.h>
 
 #include <linux/configfs.h>
 #include "configfs_internal.h"
diff -puN fs/ecryptfs/messaging.c~detach-schedh-from-mmh fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~detach-schedh-from-mmh
+++ a/fs/ecryptfs/messaging.c
@@ -19,7 +19,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
  * 02111-1307, USA.
  */
-
+#include <linux/sched.h>
 #include "ecryptfs_kernel.h"
 
 static LIST_HEAD(ecryptfs_msg_ctx_free_list);
diff -puN fs/fifo.c~detach-schedh-from-mmh fs/fifo.c
--- a/fs/fifo.c~detach-schedh-from-mmh
+++ a/fs/fifo.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
+#include <linux/sched.h>
 #include <linux/pipe_fs_i.h>
 
 static void wait_for_partner(struct inode* inode, unsigned int *cnt)
diff -puN fs/fuse/file.c~detach-schedh-from-mmh fs/fuse/file.c
--- a/fs/fuse/file.c~detach-schedh-from-mmh
+++ a/fs/fuse/file.c
@@ -11,6 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
diff -puN fs/fuse/inode.c~detach-schedh-from-mmh fs/fuse/inode.c
--- a/fs/fuse/inode.c~detach-schedh-from-mmh
+++ a/fs/fuse/inode.c
@@ -17,6 +17,7 @@
 #include <linux/parser.h>
 #include <linux/statfs.h>
 #include <linux/random.h>
+#include <linux/sched.h>
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Filesystem in Userspace");
diff -puN fs/gfs2/glock.h~detach-schedh-from-mmh fs/gfs2/glock.h
--- a/fs/gfs2/glock.h~detach-schedh-from-mmh
+++ a/fs/gfs2/glock.h
@@ -10,6 +10,7 @@
 #ifndef __GLOCK_DOT_H__
 #define __GLOCK_DOT_H__
 
+#include <linux/sched.h>
 #include "incore.h"
 
 /* Flags for lock requests; used in gfs2_holder gh_flag field.
diff -puN fs/hfs/inode.c~detach-schedh-from-mmh fs/hfs/inode.c
--- a/fs/hfs/inode.c~detach-schedh-from-mmh
+++ a/fs/hfs/inode.c
@@ -13,6 +13,7 @@
 
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
+#include <linux/sched.h>
 
 #include "hfs_fs.h"
 #include "btree.h"
diff -puN fs/hfsplus/inode.c~detach-schedh-from-mmh fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~detach-schedh-from-mmh
+++ a/fs/hfsplus/inode.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
+#include <linux/sched.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
diff -puN fs/hpfs/buffer.c~detach-schedh-from-mmh fs/hpfs/buffer.c
--- a/fs/hpfs/buffer.c~detach-schedh-from-mmh
+++ a/fs/hpfs/buffer.c
@@ -5,7 +5,7 @@
  *
  *  general buffer i/o
  */
-
+#include <linux/sched.h>
 #include "hpfs_fn.h"
 
 void hpfs_lock_creation(struct super_block *s)
diff -puN fs/hpfs/namei.c~detach-schedh-from-mmh fs/hpfs/namei.c
--- a/fs/hpfs/namei.c~detach-schedh-from-mmh
+++ a/fs/hpfs/namei.c
@@ -5,7 +5,7 @@
  *
  *  adding & removing files & directories
  */
-
+#include <linux/sched.h>
 #include "hpfs_fn.h"
 
 static int hpfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
diff -puN fs/hpfs/super.c~detach-schedh-from-mmh fs/hpfs/super.c
--- a/fs/hpfs/super.c~detach-schedh-from-mmh
+++ a/fs/hpfs/super.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/statfs.h>
 #include <linux/magic.h>
+#include <linux/sched.h>
 
 /* Mark the filesystem dirty, so that chkdsk checks it when os/2 booted */
 
diff -puN fs/minix/bitmap.c~detach-schedh-from-mmh fs/minix/bitmap.c
--- a/fs/minix/bitmap.c~detach-schedh-from-mmh
+++ a/fs/minix/bitmap.c
@@ -15,6 +15,7 @@
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/bitops.h>
+#include <linux/sched.h>
 
 static int nibblemap[] = { 4,3,3,2,3,2,2,1,3,2,2,1,2,1,1,0 };
 
diff -puN fs/ncpfs/file.c~detach-schedh-from-mmh fs/ncpfs/file.c
--- a/fs/ncpfs/file.c~detach-schedh-from-mmh
+++ a/fs/ncpfs/file.c
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/sched.h>
 
 #include <linux/ncp_fs.h>
 #include "ncplib_kernel.h"
diff -puN fs/ncpfs/ioctl.c~detach-schedh-from-mmh fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~detach-schedh-from-mmh
+++ a/fs/ncpfs/ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/highuid.h>
 #include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
+#include <linux/sched.h>
 
 #include <linux/ncp_fs.h>
 
diff -puN fs/nfs/client.c~detach-schedh-from-mmh fs/nfs/client.c
--- a/fs/nfs/client.c~detach-schedh-from-mmh
+++ a/fs/nfs/client.c
@@ -12,7 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-
+#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
diff -puN fs/nfs/dir.c~detach-schedh-from-mmh fs/nfs/dir.c
--- a/fs/nfs/dir.c~detach-schedh-from-mmh
+++ a/fs/nfs/dir.c
@@ -33,6 +33,7 @@
 #include <linux/pagevec.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/sched.h>
 
 #include "nfs4_fs.h"
 #include "delegation.h"
diff -puN fs/nfsd/nfs4callback.c~detach-schedh-from-mmh fs/nfsd/nfs4callback.c
--- a/fs/nfsd/nfs4callback.c~detach-schedh-from-mmh
+++ a/fs/nfsd/nfs4callback.c
@@ -38,6 +38,7 @@
 #include <linux/inet.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/clnt.h>
diff -puN fs/nfsd/nfs4recover.c~detach-schedh-from-mmh fs/nfsd/nfs4recover.c
--- a/fs/nfsd/nfs4recover.c~detach-schedh-from-mmh
+++ a/fs/nfsd/nfs4recover.c
@@ -45,7 +45,7 @@
 #include <asm/uaccess.h>
 #include <asm/scatterlist.h>
 #include <linux/crypto.h>
-
+#include <linux/sched.h>
 
 #define NFSDDBG_FACILITY                NFSDDBG_PROC
 
diff -puN fs/nfsd/nfssvc.c~detach-schedh-from-mmh fs/nfsd/nfssvc.c
--- a/fs/nfsd/nfssvc.c~detach-schedh-from-mmh
+++ a/fs/nfsd/nfssvc.c
@@ -9,7 +9,7 @@
  */
 
 #include <linux/module.h>
-
+#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/errno.h>
 #include <linux/nfs.h>
diff -puN fs/nfs/file.c~detach-schedh-from-mmh fs/nfs/file.c
--- a/fs/nfs/file.c~detach-schedh-from-mmh
+++ a/fs/nfs/file.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff -puN fs/nfs/inode.c~detach-schedh-from-mmh fs/nfs/inode.c
--- a/fs/nfs/inode.c~detach-schedh-from-mmh
+++ a/fs/nfs/inode.c
@@ -15,7 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-
+#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
diff -puN fs/nfs/pagelist.c~detach-schedh-from-mmh fs/nfs/pagelist.c
--- a/fs/nfs/pagelist.c~detach-schedh-from-mmh
+++ a/fs/nfs/pagelist.c
@@ -11,6 +11,7 @@
 
 #include <linux/slab.h>
 #include <linux/file.h>
+#include <linux/sched.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs3.h>
 #include <linux/nfs4.h>
diff -puN fs/ntfs/file.c~detach-schedh-from-mmh fs/ntfs/file.c
--- a/fs/ntfs/file.c~detach-schedh-from-mmh
+++ a/fs/ntfs/file.c
@@ -26,6 +26,7 @@
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
+#include <linux/sched.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
diff -puN fs/ramfs/inode.c~detach-schedh-from-mmh fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~detach-schedh-from-mmh
+++ a/fs/ramfs/inode.c
@@ -32,7 +32,7 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/ramfs.h>
-
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff -puN fs/smbfs/dir.c~detach-schedh-from-mmh fs/smbfs/dir.c
--- a/fs/smbfs/dir.c~detach-schedh-from-mmh
+++ a/fs/smbfs/dir.c
@@ -13,6 +13,7 @@
 #include <linux/smp_lock.h>
 #include <linux/ctype.h>
 #include <linux/net.h>
+#include <linux/sched.h>
 
 #include <linux/smb_fs.h>
 #include <linux/smb_mount.h>
diff -puN fs/smbfs/file.c~detach-schedh-from-mmh fs/smbfs/file.c
--- a/fs/smbfs/file.c~detach-schedh-from-mmh
+++ a/fs/smbfs/file.c
@@ -17,6 +17,7 @@
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
 #include <linux/net.h>
+#include <linux/aio.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff -puN fs/smbfs/inode.c~detach-schedh-from-mmh fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~detach-schedh-from-mmh
+++ a/fs/smbfs/inode.c
@@ -25,6 +25,7 @@
 #include <linux/net.h>
 #include <linux/vfs.h>
 #include <linux/highuid.h>
+#include <linux/sched.h>
 #include <linux/smb_fs.h>
 #include <linux/smbno.h>
 #include <linux/smb_mount.h>
diff -puN fs/smbfs/request.c~detach-schedh-from-mmh fs/smbfs/request.c
--- a/fs/smbfs/request.c~detach-schedh-from-mmh
+++ a/fs/smbfs/request.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/net.h>
+#include <linux/sched.h>
 
 #include <linux/smb_fs.h>
 #include <linux/smbno.h>
diff -puN fs/sysfs/inode.c~detach-schedh-from-mmh fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~detach-schedh-from-mmh
+++ a/fs/sysfs/inode.c
@@ -13,6 +13,7 @@
 #include <linux/backing-dev.h>
 #include <linux/capability.h>
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include <asm/semaphore.h>
 #include "sysfs.h"
 
diff -puN fs/udf/file.c~detach-schedh-from-mmh fs/udf/file.c
--- a/fs/udf/file.c~detach-schedh-from-mmh
+++ a/fs/udf/file.c
@@ -36,6 +36,7 @@
 #include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
+#include <linux/aio.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
diff -puN fs/udf/namei.c~detach-schedh-from-mmh fs/udf/namei.c
--- a/fs/udf/namei.c~detach-schedh-from-mmh
+++ a/fs/udf/namei.c
@@ -30,6 +30,7 @@
 #include <linux/quotaops.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/sched.h>
 
 static inline int udf_match(int len1, const char *name1, int len2, const char *name2)
 {
diff -puN include/asm-arm/tlbflush.h~detach-schedh-from-mmh include/asm-arm/tlbflush.h
--- a/include/asm-arm/tlbflush.h~detach-schedh-from-mmh
+++ a/include/asm-arm/tlbflush.h
@@ -144,6 +144,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/sched.h>
+
 struct cpu_tlb_fns {
 	void (*flush_user_range)(unsigned long, unsigned long, struct vm_area_struct *);
 	void (*flush_kern_range)(unsigned long, unsigned long);
diff -puN include/asm-i386/tlbflush.h~detach-schedh-from-mmh include/asm-i386/tlbflush.h
--- a/include/asm-i386/tlbflush.h~detach-schedh-from-mmh
+++ a/include/asm-i386/tlbflush.h
@@ -90,6 +90,8 @@
 
 #ifndef CONFIG_SMP
 
+#include <linux/sched.h>
+
 #define flush_tlb() __flush_tlb()
 #define flush_tlb_all() __flush_tlb_all()
 #define local_flush_tlb() __flush_tlb()
diff -puN include/asm-mips/pgalloc.h~detach-schedh-from-mmh include/asm-mips/pgalloc.h
--- a/include/asm-mips/pgalloc.h~detach-schedh-from-mmh
+++ a/include/asm-mips/pgalloc.h
@@ -11,6 +11,7 @@
 
 #include <linux/highmem.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
 	pte_t *pte)
diff -puN include/asm-parisc/mmu_context.h~detach-schedh-from-mmh include/asm-parisc/mmu_context.h
--- a/include/asm-parisc/mmu_context.h~detach-schedh-from-mmh
+++ a/include/asm-parisc/mmu_context.h
@@ -2,6 +2,7 @@
 #define __PARISC_MMU_CONTEXT_H
 
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff -puN include/asm-parisc/tlbflush.h~detach-schedh-from-mmh include/asm-parisc/tlbflush.h
--- a/include/asm-parisc/tlbflush.h~detach-schedh-from-mmh
+++ a/include/asm-parisc/tlbflush.h
@@ -4,6 +4,7 @@
 /* TLB flushing routines.... */
 
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <asm/mmu_context.h>
 
 
diff -puN include/asm-powerpc/mmu_context.h~detach-schedh-from-mmh include/asm-powerpc/mmu_context.h
--- a/include/asm-powerpc/mmu_context.h~detach-schedh-from-mmh
+++ a/include/asm-powerpc/mmu_context.h
@@ -8,6 +8,7 @@
 
 #include <linux/kernel.h>	
 #include <linux/mm.h>	
+#include <linux/sched.h>
 #include <asm/mmu.h>	
 #include <asm/cputable.h>
 #include <asm-generic/mm_hooks.h>
diff -puN include/asm-x86_64/calgary.h~detach-schedh-from-mmh include/asm-x86_64/calgary.h
--- a/include/asm-x86_64/calgary.h~detach-schedh-from-mmh
+++ a/include/asm-x86_64/calgary.h
@@ -27,6 +27,7 @@
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/timer.h>
 #include <asm/types.h>
 
 struct iommu_table {
diff -puN include/asm-x86_64/tlbflush.h~detach-schedh-from-mmh include/asm-x86_64/tlbflush.h
--- a/include/asm-x86_64/tlbflush.h~detach-schedh-from-mmh
+++ a/include/asm-x86_64/tlbflush.h
@@ -2,6 +2,7 @@
 #define _X8664_TLBFLUSH_H
 
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <asm/processor.h>
 #include <asm/system.h>
 
diff -puN include/linux/mm.h~detach-schedh-from-mmh include/linux/mm.h
--- a/include/linux/mm.h~detach-schedh-from-mmh
+++ a/include/linux/mm.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_MM_H
 #define _LINUX_MM_H
 
-#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/capability.h>
 
@@ -20,6 +19,7 @@
 
 struct mempolicy;
 struct anon_vma;
+struct user_struct;
 
 #ifndef CONFIG_DISCONTIGMEM          /* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
@@ -738,14 +738,7 @@ extern unsigned long shmem_get_unmapped_
 					     unsigned long flags);
 #endif
 
-static inline int can_do_mlock(void)
-{
-	if (capable(CAP_IPC_LOCK))
-		return 1;
-	if (current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur != 0)
-		return 1;
-	return 0;
-}
+int can_do_mlock(void);
 extern int user_shm_lock(size_t, struct user_struct *);
 extern void user_shm_unlock(size_t, struct user_struct *);
 
diff -puN include/linux/smb_fs.h~detach-schedh-from-mmh include/linux/smb_fs.h
--- a/include/linux/smb_fs.h~detach-schedh-from-mmh
+++ a/include/linux/smb_fs.h
@@ -9,6 +9,7 @@
 #ifndef _LINUX_SMB_FS_H
 #define _LINUX_SMB_FS_H
 
+#include <linux/jiffies.h>
 #include <linux/smb.h>
 
 /*
diff -puN include/linux/task_io_accounting_ops.h~detach-schedh-from-mmh include/linux/task_io_accounting_ops.h
--- a/include/linux/task_io_accounting_ops.h~detach-schedh-from-mmh
+++ a/include/linux/task_io_accounting_ops.h
@@ -4,6 +4,8 @@
 #ifndef __TASK_IO_ACCOUNTING_OPS_INCLUDED
 #define __TASK_IO_ACCOUNTING_OPS_INCLUDED
 
+#include <linux/sched.h>
+
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 static inline void task_io_account_read(size_t bytes)
 {
diff -puN include/linux/writeback.h~detach-schedh-from-mmh include/linux/writeback.h
--- a/include/linux/writeback.h~detach-schedh-from-mmh
+++ a/include/linux/writeback.h
@@ -4,6 +4,8 @@
 #ifndef WRITEBACK_H
 #define WRITEBACK_H
 
+#include <linux/sched.h>
+
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
diff -puN include/rdma/ib_umem.h~detach-schedh-from-mmh include/rdma/ib_umem.h
--- a/include/rdma/ib_umem.h~detach-schedh-from-mmh
+++ a/include/rdma/ib_umem.h
@@ -35,6 +35,7 @@
 
 #include <linux/list.h>
 #include <linux/scatterlist.h>
+#include <linux/workqueue.h>
 
 struct ib_ucontext;
 
diff -puN kernel/profile.c~detach-schedh-from-mmh kernel/profile.c
--- a/kernel/profile.c~detach-schedh-from-mmh
+++ a/kernel/profile.c
@@ -26,6 +26,7 @@
 #include <asm/sections.h>
 #include <asm/semaphore.h>
 #include <asm/irq_regs.h>
+#include <asm/ptrace.h>
 
 struct profile_hit {
 	u32 pc, hits;
diff -puN kernel/time/ntp.c~detach-schedh-from-mmh kernel/time/ntp.c
--- a/kernel/time/ntp.c~detach-schedh-from-mmh
+++ a/kernel/time/ntp.c
@@ -11,6 +11,8 @@
 #include <linux/mm.h>
 #include <linux/time.h>
 #include <linux/timex.h>
+#include <linux/jiffies.h>
+#include <linux/hrtimer.h>
 
 #include <asm/div64.h>
 #include <asm/timex.h>
diff -puN lib/ioremap.c~detach-schedh-from-mmh lib/ioremap.c
--- a/lib/ioremap.c~detach-schedh-from-mmh
+++ a/lib/ioremap.c
@@ -7,7 +7,7 @@
  */
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
-
+#include <linux/sched.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
diff -puN mm/filemap_xip.c~detach-schedh-from-mmh mm/filemap_xip.c
--- a/mm/filemap_xip.c~detach-schedh-from-mmh
+++ a/mm/filemap_xip.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/uio.h>
 #include <linux/rmap.h>
+#include <linux/sched.h>
 #include <asm/tlbflush.h>
 #include "filemap.h"
 
diff -puN mm/madvise.c~detach-schedh-from-mmh mm/madvise.c
--- a/mm/madvise.c~detach-schedh-from-mmh
+++ a/mm/madvise.c
@@ -10,6 +10,7 @@
 #include <linux/syscalls.h>
 #include <linux/mempolicy.h>
 #include <linux/hugetlb.h>
+#include <linux/sched.h>
 
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
diff -puN mm/mlock.c~detach-schedh-from-mmh mm/mlock.c
--- a/mm/mlock.c~detach-schedh-from-mmh
+++ a/mm/mlock.c
@@ -10,7 +10,18 @@
 #include <linux/mm.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
+#include <linux/sched.h>
+#include <linux/module.h>
 
+int can_do_mlock(void)
+{
+	if (capable(CAP_IPC_LOCK))
+		return 1;
+	if (current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur != 0)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(can_do_mlock);
 
 static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 	unsigned long start, unsigned long end, unsigned int newflags)
diff -puN mm/msync.c~detach-schedh-from-mmh mm/msync.c
--- a/mm/msync.c~detach-schedh-from-mmh
+++ a/mm/msync.c
@@ -12,6 +12,7 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/syscalls.h>
+#include <linux/sched.h>
 
 /*
  * MS_SYNC syncs the entire file - including mappings.
diff -puN mm/vmstat.c~detach-schedh-from-mmh mm/vmstat.c
--- a/mm/vmstat.c~detach-schedh-from-mmh
+++ a/mm/vmstat.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
+#include <linux/sched.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
diff -puN sound/sound_firmware.c~detach-schedh-from-mmh sound/sound_firmware.c
--- a/sound/sound_firmware.c~detach-schedh-from-mmh
+++ a/sound/sound_firmware.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 #include "oss/sound_firmware.h"
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-parisc.patch
