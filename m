From: akpm@linux-foundation.org
Subject: [to-be-updated]
 tree-sweep-include-linux-schedh-for-might_sleep-users.patch removed from
 -mm tree
Date: Tue, 10 Sep 2013 16:52:23 -0700
Message-ID: <522fb0b7.5J5LGG48aI8668/4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3IJXwY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 19:52:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl, ak@linux.intel.com

Subject: [to-be-updated] tree-sweep-include-linux-schedh-for-might_sleep-users.patch removed from -mm tree
To: ak@linux.intel.com,a.p.zijlstra@chello.nl,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 16:52:23 -0700


The patch titled
     Subject: tree-sweep: include linux/sched.h for might_sleep users
has been removed from the -mm tree.  Its filename was
     tree-sweep-include-linux-schedh-for-might_sleep-users.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: tree-sweep: include linux/sched.h for might_sleep users

might_sleep is moving from linux/kernel.h to linux/sched.h, so any users
need to include linux/sched.h

This was done with a mechanistic script and some uses may be redundant
(already included in some other include file).  However it's good practice
to always include any needed symbols from the top level .c file.

Tested with x86-64 allyesconfig.  I used to do a x86-32 allyesconfig on a
old kernel, but since that is broken now I didn't retest.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/mcpm_entry.c                              |    1 +
 arch/arm/mach-omap2/omap_hwmod.c                          |    1 +
 arch/arm/mm/highmem.c                                     |    1 +
 arch/blackfin/kernel/bfin_gpio.c                          |    1 +
 arch/frv/mm/highmem.c                                     |    1 +
 arch/m32r/include/asm/uaccess.h                           |    1 +
 arch/microblaze/include/asm/highmem.h                     |    1 +
 arch/mn10300/include/asm/uaccess.h                        |    1 +
 arch/parisc/include/asm/cacheflush.h                      |    1 +
 arch/powerpc/include/asm/highmem.h                        |    1 +
 arch/powerpc/kernel/rtas.c                                |    1 +
 arch/powerpc/lib/checksum_wrappers_64.c                   |    1 +
 arch/powerpc/lib/usercopy_64.c                            |    1 +
 arch/tile/mm/highmem.c                                    |    1 +
 arch/x86/include/asm/checksum_32.h                        |    1 +
 arch/x86/lib/csum-wrappers_64.c                           |    1 +
 arch/x86/mm/highmem_32.c                                  |    1 +
 arch/x86/mm/mmio-mod.c                                    |    1 +
 block/blk-cgroup.c                                        |    1 +
 block/blk-core.c                                          |    1 +
 block/genhd.c                                             |    1 +
 drivers/base/dma-buf.c                                    |    1 +
 drivers/block/rsxx/dev.c                                  |    1 +
 drivers/dma/ipu/ipu_irq.c                                 |    1 +
 drivers/gpio/gpiolib.c                                    |    1 +
 drivers/ide/ide-io.c                                      |    1 +
 drivers/infiniband/hw/amso1100/c2_cq.c                    |    1 +
 drivers/infiniband/hw/cxgb3/iwch_cm.c                     |    1 +
 drivers/infiniband/hw/cxgb4/cm.c                          |    1 +
 drivers/md/dm.c                                           |    1 +
 drivers/md/raid5.c                                        |    1 +
 drivers/mmc/core/core.c                                   |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c          |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c            |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h         |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c         |    1 +
 drivers/net/ethernet/intel/e1000e/netdev.c                |    1 +
 drivers/net/ethernet/intel/igbvf/netdev.c                 |    1 +
 drivers/net/ethernet/sfc/falcon.c                         |    1 +
 drivers/net/ieee802154/at86rf230.c                        |    1 +
 drivers/net/ieee802154/fakelb.c                           |    1 +
 drivers/net/wireless/ath/carl9170/usb.c                   |    1 +
 drivers/net/wireless/ath/wil6210/wmi.c                    |    1 +
 drivers/net/wireless/b43/dma.c                            |    1 +
 drivers/net/wireless/b43/main.c                           |    1 +
 drivers/net/wireless/b43/phy_a.c                          |    1 +
 drivers/net/wireless/b43/phy_g.c                          |    1 +
 drivers/net/wireless/b43legacy/dma.c                      |    1 +
 drivers/net/wireless/b43legacy/radio.c                    |    1 +
 drivers/net/wireless/cw1200/cw1200_spi.c                  |    1 +
 drivers/net/wireless/iwlwifi/dvm/sta.c                    |    1 +
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h                  |    1 +
 drivers/net/wireless/libertas_tf/cmd.c                    |    1 +
 drivers/pci/iov.c                                         |    1 +
 drivers/pci/pci.c                                         |    1 +
 drivers/platform/olpc/olpc-ec.c                           |    1 +
 drivers/ssb/driver_pcicore.c                              |    1 +
 drivers/staging/lustre/lustre/llite/remote_perm.c         |    1 +
 drivers/staging/lustre/lustre/obdclass/cl_lock.c          |    1 +
 drivers/staging/lustre/lustre/obdclass/cl_object.c        |    1 +
 drivers/staging/lustre/lustre/obdclass/cl_page.c          |    1 +
 drivers/staging/lustre/lustre/osc/osc_lock.c              |    1 +
 drivers/staging/lustre/lustre/osc/osc_page.c              |    1 +
 drivers/staging/lustre/lustre/ptlrpc/client.c             |    1 +
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c |    1 +
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c     |    1 +
 drivers/staging/lustre/lustre/ptlrpc/sec.c                |    1 +
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c         |    1 +
 drivers/staging/lustre/lustre/ptlrpc/sec_gc.c             |    1 +
 drivers/usb/core/hcd.c                                    |    1 +
 drivers/usb/core/urb.c                                    |    1 +
 drivers/video/atmel_lcdfb.c                               |    1 +
 fs/block_dev.c                                            |    1 +
 fs/buffer.c                                               |    1 +
 fs/dcache.c                                               |    1 +
 fs/ext3/inode.c                                           |    1 +
 fs/ext4/ext4_jbd2.c                                       |    1 +
 fs/ext4/inode.c                                           |    1 +
 fs/ext4/mballoc.c                                         |    1 +
 fs/file_table.c                                           |    1 +
 fs/inode.c                                                |    1 +
 fs/jbd/revoke.c                                           |    1 +
 fs/jbd2/revoke.c                                          |    1 +
 fs/locks.c                                                |    1 +
 fs/nfs/nfs4filelayoutdev.c                                |    1 +
 fs/nfs/nfs4proc.c                                         |    1 +
 fs/nfs/nfs4state.c                                        |    1 +
 fs/nilfs2/the_nilfs.c                                     |    1 +
 fs/xfs/xfs_mount.c                                        |    1 +
 include/asm-generic/gpio.h                                |    1 +
 include/linux/buffer_head.h                               |    1 +
 include/linux/clk.h                                       |    1 +
 include/linux/gpio.h                                      |    1 +
 include/linux/highmem.h                                   |    1 +
 include/linux/pagemap.h                                   |    1 +
 kernel/fork.c                                             |    1 +
 kernel/freezer.c                                          |    1 +
 kernel/irq/chip.c                                         |    1 +
 kernel/nsproxy.c                                          |    1 +
 kernel/printk/printk.c                                    |    1 +
 kernel/sched/core.c                                       |    1 +
 kernel/smp.c                                              |    1 +
 mm/hugetlb.c                                              |    1 +
 mm/memory.c                                               |    1 +
 mm/mmap.c                                                 |    1 +
 mm/rmap.c                                                 |    1 +
 net/caif/cfcnfg.c                                         |    1 +
 net/mac80211/driver-ops.h                                 |    1 +
 net/mac80211/key.c                                        |    1 +
 net/mac80211/main.c                                       |    1 +
 net/mac80211/sta_info.c                                   |    1 +
 net/phonet/pep.c                                          |    1 +
 net/sunrpc/clnt.c                                         |    1 +
 net/wimax/op-msg.c                                        |    1 +
 net/wimax/op-reset.c                                      |    1 +
 net/wimax/op-rfkill.c                                     |    1 +
 net/wireless/wext-proc.c                                  |    1 +
 sound/core/info.c                                         |    1 +
 virt/kvm/async_pf.c                                       |    1 +
 120 files changed, 120 insertions(+)

diff -puN arch/arm/common/mcpm_entry.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/arm/common/mcpm_entry.c
--- a/arch/arm/common/mcpm_entry.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/arm/common/mcpm_entry.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/irqflags.h>
 
diff -puN arch/arm/mach-omap2/omap_hwmod.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/arm/mach-omap2/omap_hwmod.c
--- a/arch/arm/mach-omap2/omap_hwmod.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/arm/mach-omap2/omap_hwmod.c
@@ -127,6 +127,7 @@
  */
 #undef DEBUG
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/io.h>
diff -puN arch/arm/mm/highmem.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/arm/mm/highmem.c
--- a/arch/arm/mm/highmem.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/arm/mm/highmem.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/interrupt.h>
diff -puN arch/blackfin/kernel/bfin_gpio.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/blackfin/kernel/bfin_gpio.c
--- a/arch/blackfin/kernel/bfin_gpio.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/blackfin/kernel/bfin_gpio.c
@@ -6,6 +6,7 @@
  * Licensed under the GPL-2 or later
  */
 
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/err.h>
diff -puN arch/frv/mm/highmem.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/frv/mm/highmem.c
--- a/arch/frv/mm/highmem.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/frv/mm/highmem.c
@@ -8,6 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 
diff -puN arch/m32r/include/asm/uaccess.h~tree-sweep-include-linux-schedh-for-might_sleep-users arch/m32r/include/asm/uaccess.h
--- a/arch/m32r/include/asm/uaccess.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/m32r/include/asm/uaccess.h
@@ -11,6 +11,7 @@
 /*
  * User space memory access functions
  */
+#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/thread_info.h>
 #include <asm/page.h>
diff -puN arch/microblaze/include/asm/highmem.h~tree-sweep-include-linux-schedh-for-might_sleep-users arch/microblaze/include/asm/highmem.h
--- a/arch/microblaze/include/asm/highmem.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/microblaze/include/asm/highmem.h
@@ -20,6 +20,7 @@
 #ifdef __KERNEL__
 
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <asm/fixmap.h>
diff -puN arch/mn10300/include/asm/uaccess.h~tree-sweep-include-linux-schedh-for-might_sleep-users arch/mn10300/include/asm/uaccess.h
--- a/arch/mn10300/include/asm/uaccess.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/mn10300/include/asm/uaccess.h
@@ -14,6 +14,7 @@
 /*
  * User space memory access functions
  */
+#include <linux/sched.h>
 #include <linux/thread_info.h>
 #include <linux/kernel.h>
 #include <asm/page.h>
diff -puN arch/parisc/include/asm/cacheflush.h~tree-sweep-include-linux-schedh-for-might_sleep-users arch/parisc/include/asm/cacheflush.h
--- a/arch/parisc/include/asm/cacheflush.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -2,6 +2,7 @@
 #define _PARISC_CACHEFLUSH_H
 
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <asm/tlbflush.h>
 
diff -puN arch/powerpc/include/asm/highmem.h~tree-sweep-include-linux-schedh-for-might_sleep-users arch/powerpc/include/asm/highmem.h
--- a/arch/powerpc/include/asm/highmem.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/powerpc/include/asm/highmem.h
@@ -22,6 +22,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
diff -puN arch/powerpc/kernel/rtas.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/powerpc/kernel/rtas.c
--- a/arch/powerpc/kernel/rtas.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/powerpc/kernel/rtas.c
@@ -11,6 +11,7 @@
  *      2 of the License, or (at your option) any later version.
  */
 
+#include <linux/sched.h>
 #include <stdarg.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
diff -puN arch/powerpc/lib/checksum_wrappers_64.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/powerpc/lib/checksum_wrappers_64.c
--- a/arch/powerpc/lib/checksum_wrappers_64.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/powerpc/lib/checksum_wrappers_64.c
@@ -17,6 +17,7 @@
  *
  * Author: Anton Blanchard <anton@au.ibm.com>
  */
+#include <linux/sched.h>
 #include <linux/export.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
diff -puN arch/powerpc/lib/usercopy_64.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/powerpc/lib/usercopy_64.c
--- a/arch/powerpc/lib/usercopy_64.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/powerpc/lib/usercopy_64.c
@@ -6,6 +6,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <asm/uaccess.h>
 
diff -puN arch/tile/mm/highmem.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/tile/mm/highmem.c
--- a/arch/tile/mm/highmem.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/tile/mm/highmem.c
@@ -12,6 +12,7 @@
  *   more details.
  */
 
+#include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
diff -puN arch/x86/include/asm/checksum_32.h~tree-sweep-include-linux-schedh-for-might_sleep-users arch/x86/include/asm/checksum_32.h
--- a/arch/x86/include/asm/checksum_32.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/x86/include/asm/checksum_32.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_CHECKSUM_32_H
 
 #include <linux/in6.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 
diff -puN arch/x86/lib/csum-wrappers_64.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/x86/lib/csum-wrappers_64.c
--- a/arch/x86/lib/csum-wrappers_64.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/x86/lib/csum-wrappers_64.c
@@ -4,6 +4,7 @@
  *
  * Wrappers of assembly checksum functions for x86-64.
  */
+#include <linux/sched.h>
 #include <asm/checksum.h>
 #include <linux/module.h>
 #include <asm/smap.h>
diff -puN arch/x86/mm/highmem_32.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/x86/mm/highmem_32.c
@@ -1,3 +1,4 @@
+#include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/swap.h> /* for totalram_pages */
diff -puN arch/x86/mm/mmio-mod.c~tree-sweep-include-linux-schedh-for-might_sleep-users arch/x86/mm/mmio-mod.c
--- a/arch/x86/mm/mmio-mod.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/arch/x86/mm/mmio-mod.c
@@ -24,6 +24,7 @@
 
 #define DEBUG 1
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
diff -puN block/blk-cgroup.c~tree-sweep-include-linux-schedh-for-might_sleep-users block/blk-cgroup.c
--- a/block/blk-cgroup.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/block/blk-cgroup.c
@@ -11,6 +11,7 @@
  * 	              Nauman Rafique <nauman@google.com>
  */
 #include <linux/ioprio.h>
+#include <linux/sched.h>
 #include <linux/kdev_t.h>
 #include <linux/module.h>
 #include <linux/err.h>
diff -puN block/blk-core.c~tree-sweep-include-linux-schedh-for-might_sleep-users block/blk-core.c
--- a/block/blk-core.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/block/blk-core.c
@@ -11,6 +11,7 @@
 /*
  * This handles all read/write requests to block devices
  */
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/backing-dev.h>
diff -puN block/genhd.c~tree-sweep-include-linux-schedh-for-might_sleep-users block/genhd.c
--- a/block/genhd.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/block/genhd.c
@@ -2,6 +2,7 @@
  *  gendisk handling
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
diff -puN drivers/base/dma-buf.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/base/dma-buf.c
--- a/drivers/base/dma-buf.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/base/dma-buf.c
@@ -22,6 +22,7 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
diff -puN drivers/block/rsxx/dev.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/block/rsxx/dev.c
--- a/drivers/block/rsxx/dev.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/block/rsxx/dev.c
@@ -23,6 +23,7 @@
 */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff -puN drivers/dma/ipu/ipu_irq.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/dma/ipu/ipu_irq.c
--- a/drivers/dma/ipu/ipu_irq.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/dma/ipu/ipu_irq.c
@@ -7,6 +7,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/spinlock.h>
diff -puN drivers/gpio/gpiolib.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/gpio/gpiolib.c
@@ -1,3 +1,4 @@
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
diff -puN drivers/ide/ide-io.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/ide/ide-io.c
--- a/drivers/ide/ide-io.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/ide/ide-io.c
@@ -24,6 +24,7 @@
  */
  
  
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff -puN drivers/infiniband/hw/amso1100/c2_cq.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/infiniband/hw/amso1100/c2_cq.c
--- a/drivers/infiniband/hw/amso1100/c2_cq.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/infiniband/hw/amso1100/c2_cq.c
@@ -35,6 +35,7 @@
  * SOFTWARE.
  *
  */
+#include <linux/sched.h>
 #include <linux/gfp.h>
 
 #include "c2.h"
diff -puN drivers/infiniband/hw/cxgb3/iwch_cm.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/infiniband/hw/cxgb3/iwch_cm.c
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/slab.h>
diff -puN drivers/infiniband/hw/cxgb4/cm.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/infiniband/hw/cxgb4/cm.c
--- a/drivers/infiniband/hw/cxgb4/cm.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/infiniband/hw/cxgb4/cm.c
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/workqueue.h>
diff -puN drivers/md/dm.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/md/dm.c
--- a/drivers/md/dm.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/md/dm.c
@@ -5,6 +5,7 @@
  * This file is released under the GPL.
  */
 
+#include <linux/sched.h>
 #include "dm.h"
 #include "dm-uevent.h"
 
diff -puN drivers/md/raid5.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/md/raid5.c
--- a/drivers/md/raid5.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/md/raid5.c
@@ -43,6 +43,7 @@
  * miss any bits.
  */
 
+#include <linux/sched.h>
 #include <linux/blkdev.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
diff -puN drivers/mmc/core/core.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/mmc/core/core.c
@@ -10,6 +10,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -17,6 +17,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -19,6 +19,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/crc32.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h
@@ -20,6 +20,7 @@
 #define BNX2X_SRIOV_H
 
 #include "bnx2x_vfpf.h"
+#include <linux/sched.h>
 #include "bnx2x.h"
 
 enum sample_bulletin_result {
diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
@@ -17,6 +17,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include "bnx2x_stats.h"
 #include "bnx2x_cmn.h"
 #include "bnx2x_sriov.h"
diff -puN drivers/net/ethernet/intel/e1000e/netdev.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/ethernet/intel/e1000e/netdev.c
--- a/drivers/net/ethernet/intel/e1000e/netdev.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -28,6 +28,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/init.h>
diff -puN drivers/net/ethernet/intel/igbvf/netdev.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/ethernet/intel/igbvf/netdev.c
--- a/drivers/net/ethernet/intel/igbvf/netdev.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -27,6 +27,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/init.h>
diff -puN drivers/net/ethernet/sfc/falcon.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/ethernet/sfc/falcon.c
--- a/drivers/net/ethernet/sfc/falcon.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/ethernet/sfc/falcon.c
@@ -8,6 +8,7 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
+#include <linux/sched.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
diff -puN drivers/net/ieee802154/at86rf230.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/ieee802154/at86rf230.c
--- a/drivers/net/ieee802154/at86rf230.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/ieee802154/at86rf230.c
@@ -21,6 +21,7 @@
  * Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
  */
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
diff -puN drivers/net/ieee802154/fakelb.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/ieee802154/fakelb.c
--- a/drivers/net/ieee802154/fakelb.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/ieee802154/fakelb.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/platform_device.h>
 #include <linux/netdevice.h>
diff -puN drivers/net/wireless/ath/carl9170/usb.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/ath/carl9170/usb.c
--- a/drivers/net/wireless/ath/carl9170/usb.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/ath/carl9170/usb.c
@@ -37,6 +37,7 @@
  *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
diff -puN drivers/net/wireless/ath/wil6210/wmi.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/ath/wil6210/wmi.c
--- a/drivers/net/wireless/ath/wil6210/wmi.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/ath/wil6210/wmi.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 #include <linux/if_arp.h>
 
 #include "wil6210.h"
diff -puN drivers/net/wireless/b43/dma.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/b43/dma.c
--- a/drivers/net/wireless/b43/dma.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/b43/dma.c
@@ -27,6 +27,7 @@
 
 */
 
+#include <linux/sched.h>
 #include "b43.h"
 #include "dma.h"
 #include "main.h"
diff -puN drivers/net/wireless/b43/main.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/b43/main.c
--- a/drivers/net/wireless/b43/main.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/b43/main.c
@@ -32,6 +32,7 @@
 
 */
 
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff -puN drivers/net/wireless/b43/phy_a.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/b43/phy_a.c
--- a/drivers/net/wireless/b43/phy_a.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/b43/phy_a.c
@@ -26,6 +26,7 @@
 
 */
 
+#include <linux/sched.h>
 #include <linux/slab.h>
 
 #include "b43.h"
diff -puN drivers/net/wireless/b43/phy_g.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/b43/phy_g.c
--- a/drivers/net/wireless/b43/phy_g.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/b43/phy_g.c
@@ -26,6 +26,7 @@
 
 */
 
+#include <linux/sched.h>
 #include "b43.h"
 #include "phy_g.h"
 #include "phy_common.h"
diff -puN drivers/net/wireless/b43legacy/dma.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/b43legacy/dma.c
--- a/drivers/net/wireless/b43legacy/dma.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/b43legacy/dma.c
@@ -27,6 +27,7 @@
 
 */
 
+#include <linux/sched.h>
 #include "b43legacy.h"
 #include "dma.h"
 #include "main.h"
diff -puN drivers/net/wireless/b43legacy/radio.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/b43legacy/radio.c
--- a/drivers/net/wireless/b43legacy/radio.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/b43legacy/radio.c
@@ -29,6 +29,7 @@
 
 */
 
+#include <linux/sched.h>
 #include <linux/delay.h>
 
 #include "b43legacy.h"
diff -puN drivers/net/wireless/cw1200/cw1200_spi.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/cw1200/cw1200_spi.c
--- a/drivers/net/wireless/cw1200/cw1200_spi.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/spinlock.h>
diff -puN drivers/net/wireless/iwlwifi/dvm/sta.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/iwlwifi/dvm/sta.c
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -27,6 +27,7 @@
  *
  *****************************************************************************/
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 #include <net/mac80211.h>
 #include "iwl-trans.h"
 #include "dev.h"
diff -puN drivers/net/wireless/iwlwifi/iwl-op-mode.h~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/iwlwifi/iwl-op-mode.h
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -64,6 +64,7 @@
 #define __iwl_op_mode_h__
 
 #include <linux/debugfs.h>
+#include <linux/sched.h>
 
 struct iwl_op_mode;
 struct iwl_trans;
diff -puN drivers/net/wireless/iwlwifi/iwl-trans.h~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/iwlwifi/iwl-trans.h
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -63,6 +63,7 @@
 #ifndef __iwl_trans_h__
 #define __iwl_trans_h__
 
+#include <linux/sched.h>
 #include <linux/ieee80211.h>
 #include <linux/mm.h> /* for page_address */
 #include <linux/lockdep.h>
diff -puN drivers/net/wireless/libertas_tf/cmd.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/net/wireless/libertas_tf/cmd.c
--- a/drivers/net/wireless/libertas_tf/cmd.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/net/wireless/libertas_tf/cmd.c
@@ -9,6 +9,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/sched.h>
 #include <linux/hardirq.h>
 #include <linux/slab.h>
 #include <linux/export.h>
diff -puN drivers/pci/iov.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/pci/iov.c
--- a/drivers/pci/iov.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/pci/iov.c
@@ -8,6 +8,7 @@
  *   Address Translation Service 1.0
  */
 
+#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
diff -puN drivers/pci/pci.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/pci/pci.c
--- a/drivers/pci/pci.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/pci/pci.c
@@ -7,6 +7,7 @@
  *	Copyright 1997 -- 2000 Martin Mares <mj@ucw.cz>
  */
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/init.h>
diff -puN drivers/platform/olpc/olpc-ec.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/platform/olpc/olpc-ec.c
--- a/drivers/platform/olpc/olpc-ec.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/platform/olpc/olpc-ec.c
@@ -6,6 +6,7 @@
  * Licensed under the GPL v2 or later.
  */
 #include <linux/completion.h>
+#include <linux/sched.h>
 #include <linux/debugfs.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
diff -puN drivers/ssb/driver_pcicore.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/ssb/driver_pcicore.c
--- a/drivers/ssb/driver_pcicore.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/ssb/driver_pcicore.c
@@ -8,6 +8,7 @@
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
+#include <linux/sched.h>
 #include <linux/ssb/ssb.h>
 #include <linux/pci.h>
 #include <linux/export.h>
diff -puN drivers/staging/lustre/lustre/llite/remote_perm.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/llite/remote_perm.c
--- a/drivers/staging/lustre/lustre/llite/remote_perm.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/llite/remote_perm.c
@@ -44,6 +44,7 @@
 #define DEBUG_SUBSYSTEM S_LLITE
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 
 #include <lustre_lite.h>
diff -puN drivers/staging/lustre/lustre/obdclass/cl_lock.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/obdclass/cl_lock.c
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_CLASS
 
 #include <obd_class.h>
+#include <linux/sched.h>
 #include <obd_support.h>
 #include <lustre_fid.h>
 #include <linux/list.h>
diff -puN drivers/staging/lustre/lustre/obdclass/cl_object.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/obdclass/cl_object.c
--- a/drivers/staging/lustre/lustre/obdclass/cl_object.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/obdclass/cl_object.c
@@ -52,6 +52,7 @@
 #define DEBUG_SUBSYSTEM S_CLASS
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 /* class_put_type() */
 #include <obd_class.h>
 #include <obd_support.h>
diff -puN drivers/staging/lustre/lustre/obdclass/cl_page.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/obdclass/cl_page.c
--- a/drivers/staging/lustre/lustre/obdclass/cl_page.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/obdclass/cl_page.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_CLASS
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 #include <obd_class.h>
 #include <obd_support.h>
 #include <linux/list.h>
diff -puN drivers/staging/lustre/lustre/osc/osc_lock.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/osc/osc_lock.c
--- a/drivers/staging/lustre/lustre/osc/osc_lock.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/osc/osc_lock.c
@@ -43,6 +43,7 @@
 # include <linux/libcfs/libcfs.h>
 /* fid_build_reg_res_name() */
 #include <lustre_fid.h>
+#include <linux/sched.h>
 
 #include "osc_cl_internal.h"
 
diff -puN drivers/staging/lustre/lustre/osc/osc_page.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/osc/osc_page.c
--- a/drivers/staging/lustre/lustre/osc/osc_page.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/osc/osc_page.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_OSC
 
 #include "osc_cl_internal.h"
+#include <linux/sched.h>
 
 static void osc_lru_del(struct client_obd *cli, struct osc_page *opg, bool del);
 static void osc_lru_add(struct client_obd *cli, struct osc_page *opg);
diff -puN drivers/staging/lustre/lustre/ptlrpc/client.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/ptlrpc/client.c
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -39,6 +39,7 @@
 #define DEBUG_SUBSYSTEM S_RPC
 
 #include <obd_support.h>
+#include <linux/sched.h>
 #include <obd_class.h>
 #include <lustre_lib.h>
 #include <lustre_ha.h>
diff -puN drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_cli_upcall.c
@@ -40,6 +40,7 @@
 
 #define DEBUG_SUBSYSTEM S_SEC
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dcache.h>
diff -puN drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
@@ -48,6 +48,7 @@
 
 #define DEBUG_SUBSYSTEM S_SEC
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dcache.h>
diff -puN drivers/staging/lustre/lustre/ptlrpc/sec.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/ptlrpc/sec.c
--- a/drivers/staging/lustre/lustre/ptlrpc/sec.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/ptlrpc/sec.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_SEC
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 #include <linux/crypto.h>
 #include <linux/key.h>
 
diff -puN drivers/staging/lustre/lustre/ptlrpc/sec_config.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/ptlrpc/sec_config.c
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -37,6 +37,7 @@
 #define DEBUG_SUBSYSTEM S_SEC
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 #include <linux/crypto.h>
 #include <linux/key.h>
 
diff -puN drivers/staging/lustre/lustre/ptlrpc/sec_gc.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/staging/lustre/lustre/ptlrpc/sec_gc.c
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/staging/lustre/lustre/ptlrpc/sec_gc.c
@@ -41,6 +41,7 @@
 #define DEBUG_SUBSYSTEM S_SEC
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/sched.h>
 
 #include <obd_support.h>
 #include <obd_class.h>
diff -puN drivers/usb/core/hcd.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/usb/core/hcd.c
--- a/drivers/usb/core/hcd.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/usb/core/hcd.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/bcd.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/version.h>
 #include <linux/kernel.h>
diff -puN drivers/usb/core/urb.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/usb/core/urb.c
--- a/drivers/usb/core/urb.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/usb/core/urb.c
@@ -1,3 +1,4 @@
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
diff -puN drivers/video/atmel_lcdfb.c~tree-sweep-include-linux-schedh-for-might_sleep-users drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/drivers/video/atmel_lcdfb.c
@@ -8,6 +8,7 @@
  * more details.
  */
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
diff -puN fs/block_dev.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/block_dev.c
--- a/fs/block_dev.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/block_dev.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 2001  Andrea Arcangeli <andrea@suse.de> SuSE
  */
 
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/fcntl.h>
diff -puN fs/buffer.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/buffer.c
--- a/fs/buffer.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/buffer.c
@@ -18,6 +18,7 @@
  * async buffer flushing, 1999 Andrea Arcangeli <andrea@suse.de>
  */
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
diff -puN fs/dcache.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/dcache.c
--- a/fs/dcache.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/dcache.c
@@ -14,6 +14,7 @@
  * the dcache entry is deleted or garbage collected.
  */
 
+#include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/string.h>
 #include <linux/mm.h>
diff -puN fs/ext3/inode.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/ext3/inode.c
--- a/fs/ext3/inode.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/ext3/inode.c
@@ -22,6 +22,7 @@
  *  Assorted race fixes, rewrite of ext3_get_block() by Al Viro, 2000
  */
 
+#include <linux/sched.h>
 #include <linux/highuid.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h>
diff -puN fs/ext4/ext4_jbd2.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/ext4/ext4_jbd2.c
--- a/fs/ext4/ext4_jbd2.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/ext4/ext4_jbd2.c
@@ -2,6 +2,7 @@
  * Interface between ext4 and JBD
  */
 
+#include <linux/sched.h>
 #include "ext4_jbd2.h"
 
 #include <trace/events/ext4.h>
diff -puN fs/ext4/inode.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/ext4/inode.c
--- a/fs/ext4/inode.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/ext4/inode.c
@@ -18,6 +18,7 @@
  *  Assorted race fixes, rewrite of ext4_get_block() by Al Viro, 2000
  */
 
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/jbd2.h>
diff -puN fs/ext4/mballoc.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/ext4/mballoc.c
@@ -22,6 +22,7 @@
  */
 
 #include "ext4_jbd2.h"
+#include <linux/sched.h>
 #include "mballoc.h"
 #include <linux/log2.h>
 #include <linux/module.h>
diff -puN fs/file_table.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/file_table.c
--- a/fs/file_table.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/file_table.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 1997 David S. Miller (davem@caip.rutgers.edu)
  */
 
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/file.h>
diff -puN fs/inode.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/inode.c
--- a/fs/inode.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/inode.c
@@ -2,6 +2,7 @@
  * (C) 1997 Linus Torvalds
  * (C) 1999 Andrea Arcangeli <andrea@suse.de> (dynamic inode allocation)
  */
+#include <linux/sched.h>
 #include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
diff -puN fs/jbd/revoke.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/jbd/revoke.c
@@ -81,6 +81,7 @@
  */
 
 #ifndef __KERNEL__
+#include <linux/sched.h>
 #include "jfs_user.h"
 #else
 #include <linux/time.h>
diff -puN fs/jbd2/revoke.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/jbd2/revoke.c
--- a/fs/jbd2/revoke.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/jbd2/revoke.c
@@ -81,6 +81,7 @@
  */
 
 #ifndef __KERNEL__
+#include <linux/sched.h>
 #include "jfs_user.h"
 #else
 #include <linux/time.h>
diff -puN fs/locks.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/locks.c
--- a/fs/locks.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/locks.c
@@ -114,6 +114,7 @@
  *  Stephen Rothwell <sfr@canb.auug.org.au>, June, 2000.
  */
 
+#include <linux/sched.h>
 #include <linux/capability.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
diff -puN fs/nfs/nfs4filelayoutdev.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/nfs/nfs4filelayoutdev.c
--- a/fs/nfs/nfs4filelayoutdev.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/nfs/nfs4filelayoutdev.c
@@ -29,6 +29,7 @@
  */
 
 #include <linux/nfs_fs.h>
+#include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/sunrpc/addr.h>
diff -puN fs/nfs/nfs4proc.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/nfs/nfs4proc.c
@@ -35,6 +35,7 @@
  *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
diff -puN fs/nfs/nfs4state.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/nfs/nfs4state.c
@@ -39,6 +39,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/nfs_fs.h>
diff -puN fs/nilfs2/the_nilfs.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/nilfs2/the_nilfs.c
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/sched.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
diff -puN fs/xfs/xfs_mount.c~tree-sweep-include-linux-schedh-for-might_sleep-users fs/xfs/xfs_mount.c
--- a/fs/xfs/xfs_mount.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/fs/xfs/xfs_mount.c
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <linux/sched.h>
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
diff -puN include/asm-generic/gpio.h~tree-sweep-include-linux-schedh-for-might_sleep-users include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/include/asm-generic/gpio.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_GPIO_H
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/of.h>
diff -puN include/linux/buffer_head.h~tree-sweep-include-linux-schedh-for-might_sleep-users include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/include/linux/buffer_head.h
@@ -8,6 +8,7 @@
 #define _LINUX_BUFFER_HEAD_H
 
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/linkage.h>
 #include <linux/pagemap.h>
diff -puN include/linux/clk.h~tree-sweep-include-linux-schedh-for-might_sleep-users include/linux/clk.h
--- a/include/linux/clk.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/include/linux/clk.h
@@ -14,6 +14,7 @@
 
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/notifier.h>
 
 struct device;
diff -puN include/linux/gpio.h~tree-sweep-include-linux-schedh-for-might_sleep-users include/linux/gpio.h
--- a/include/linux/gpio.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/include/linux/gpio.h
@@ -2,6 +2,7 @@
 #define __LINUX_GPIO_H
 
 #include <linux/errno.h>
+#include <linux/sched.h>
 
 /* see Documentation/gpio.txt */
 
diff -puN include/linux/highmem.h~tree-sweep-include-linux-schedh-for-might_sleep-users include/linux/highmem.h
--- a/include/linux/highmem.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/include/linux/highmem.h
@@ -2,6 +2,7 @@
 #define _LINUX_HIGHMEM_H
 
 #include <linux/fs.h>
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/mm.h>
diff -puN include/linux/pagemap.h~tree-sweep-include-linux-schedh-for-might_sleep-users include/linux/pagemap.h
--- a/include/linux/pagemap.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/include/linux/pagemap.h
@@ -5,6 +5,7 @@
  * Copyright 1995 Linus Torvalds
  */
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
diff -puN kernel/fork.c~tree-sweep-include-linux-schedh-for-might_sleep-users kernel/fork.c
--- a/kernel/fork.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/kernel/fork.c
@@ -11,6 +11,7 @@
  * management can be a bitch. See 'mm/memory.c': 'copy_page_range()'
  */
 
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/unistd.h>
diff -puN kernel/freezer.c~tree-sweep-include-linux-schedh-for-might_sleep-users kernel/freezer.c
--- a/kernel/freezer.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/kernel/freezer.c
@@ -4,6 +4,7 @@
  * Originally from kernel/power/process.c
  */
 
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include <linux/export.h>
diff -puN kernel/irq/chip.c~tree-sweep-include-linux-schedh-for-might_sleep-users kernel/irq/chip.c
--- a/kernel/irq/chip.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/kernel/irq/chip.c
@@ -10,6 +10,7 @@
  * Detailed information is available in Documentation/DocBook/genericirq
  */
 
+#include <linux/sched.h>
 #include <linux/irq.h>
 #include <linux/msi.h>
 #include <linux/module.h>
diff -puN kernel/nsproxy.c~tree-sweep-include-linux-schedh-for-might_sleep-users kernel/nsproxy.c
--- a/kernel/nsproxy.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/kernel/nsproxy.c
@@ -13,6 +13,7 @@
  *             Pavel Emelianov <xemul@openvz.org>
  */
 
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/nsproxy.h>
diff -puN kernel/printk/printk.c~tree-sweep-include-linux-schedh-for-might_sleep-users kernel/printk/printk.c
--- a/kernel/printk/printk.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/kernel/printk/printk.c
@@ -17,6 +17,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
diff -puN kernel/sched/core.c~tree-sweep-include-linux-schedh-for-might_sleep-users kernel/sched/core.c
--- a/kernel/sched/core.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/kernel/sched/core.c
@@ -26,6 +26,7 @@
  *              Thomas Gleixner, Mike Kravetz
  */
 
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
diff -puN kernel/smp.c~tree-sweep-include-linux-schedh-for-might_sleep-users kernel/smp.c
--- a/kernel/smp.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/kernel/smp.c
@@ -9,6 +9,7 @@
 #include <linux/export.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
diff -puN mm/hugetlb.c~tree-sweep-include-linux-schedh-for-might_sleep-users mm/hugetlb.c
--- a/mm/hugetlb.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/mm/hugetlb.c
@@ -2,6 +2,7 @@
  * Generic hugetlb support.
  * (C) Nadia Yvette Chambers, April 2004
  */
+#include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff -puN mm/memory.c~tree-sweep-include-linux-schedh-for-might_sleep-users mm/memory.c
--- a/mm/memory.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/mm/memory.c
@@ -38,6 +38,7 @@
  * Aug/Sep 2004 Changed to four level page tables (Andi Kleen)
  */
 
+#include <linux/sched.h>
 #include <linux/kernel_stat.h>
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
diff -puN mm/mmap.c~tree-sweep-include-linux-schedh-for-might_sleep-users mm/mmap.c
--- a/mm/mmap.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/mm/mmap.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/mm.h>
diff -puN mm/rmap.c~tree-sweep-include-linux-schedh-for-might_sleep-users mm/rmap.c
--- a/mm/rmap.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/mm/rmap.c
@@ -42,6 +42,7 @@
  *     pte map lock
  */
 
+#include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
diff -puN net/caif/cfcnfg.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/caif/cfcnfg.c
--- a/net/caif/cfcnfg.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/caif/cfcnfg.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s(): " fmt, __func__
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/slab.h>
diff -puN net/mac80211/driver-ops.h~tree-sweep-include-linux-schedh-for-might_sleep-users net/mac80211/driver-ops.h
--- a/net/mac80211/driver-ops.h~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/mac80211/driver-ops.h
@@ -1,6 +1,7 @@
 #ifndef __MAC80211_DRIVER_OPS
 #define __MAC80211_DRIVER_OPS
 
+#include <linux/sched.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "trace.h"
diff -puN net/mac80211/key.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/mac80211/key.c
--- a/net/mac80211/key.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/mac80211/key.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
diff -puN net/mac80211/main.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/mac80211/main.c
--- a/net/mac80211/main.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/mac80211/main.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <net/mac80211.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff -puN net/mac80211/sta_info.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/mac80211/sta_info.c
--- a/net/mac80211/sta_info.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/mac80211/sta_info.c
@@ -7,6 +7,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/etherdevice.h>
diff -puN net/phonet/pep.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/phonet/pep.c
--- a/net/phonet/pep.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/phonet/pep.c
@@ -22,6 +22,7 @@
  * 02110-1301 USA
  */
 
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/socket.h>
diff -puN net/sunrpc/clnt.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/sunrpc/clnt.c
--- a/net/sunrpc/clnt.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/sunrpc/clnt.c
@@ -19,6 +19,7 @@
 
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/kallsyms.h>
 #include <linux/mm.h>
diff -puN net/wimax/op-msg.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/wimax/op-msg.c
--- a/net/wimax/op-msg.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/wimax/op-msg.c
@@ -71,6 +71,7 @@
  *   wimax_msg_alloc()
  *   wimax_msg_send()
  */
+#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <net/genetlink.h>
diff -puN net/wimax/op-reset.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/wimax/op-reset.c
--- a/net/wimax/op-reset.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/wimax/op-reset.c
@@ -28,6 +28,7 @@
  * disconnect and reconnect the device).
  */
 
+#include <linux/sched.h>
 #include <net/wimax.h>
 #include <net/genetlink.h>
 #include <linux/wimax.h>
diff -puN net/wimax/op-rfkill.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/wimax/op-rfkill.c
--- a/net/wimax/op-rfkill.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/wimax/op-rfkill.c
@@ -60,6 +60,7 @@
  * wimax_rfkill_rm()            [called by wimax_dev_add/rm()]
  */
 
+#include <linux/sched.h>
 #include <net/wimax.h>
 #include <net/genetlink.h>
 #include <linux/wimax.h>
diff -puN net/wireless/wext-proc.c~tree-sweep-include-linux-schedh-for-might_sleep-users net/wireless/wext-proc.c
--- a/net/wireless/wext-proc.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/net/wireless/wext-proc.c
@@ -16,6 +16,7 @@
  * The content of the file is basically the content of "struct iw_statistics".
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff -puN sound/core/info.c~tree-sweep-include-linux-schedh-for-might_sleep-users sound/core/info.c
--- a/sound/core/info.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/sound/core/info.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/time.h>
 #include <linux/mm.h>
diff -puN virt/kvm/async_pf.c~tree-sweep-include-linux-schedh-for-might_sleep-users virt/kvm/async_pf.c
--- a/virt/kvm/async_pf.c~tree-sweep-include-linux-schedh-for-might_sleep-users
+++ a/virt/kvm/async_pf.c
@@ -20,6 +20,7 @@
  * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
  */
 
+#include <linux/sched.h>
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
 #include <linux/module.h>
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
mm-migrate-make-core-migration-code-aware-of-hugepage.patch
mm-soft-offline-use-migrate_pages-instead-of-migrate_huge_page.patch
migrate-add-hugepage-migration-code-to-migrate_pages.patch
mm-migrate-add-hugepage-migration-code-to-move_pages.patch
mm-mbind-add-hugepage-migration-code-to-mbind.patch
mm-migrate-remove-vm_hugetlb-from-vma-flag-check-in-vma_migratable.patch
mm-memory-hotplug-enable-memory-hotplug-to-handle-hugepage.patch
mm-migrate-check-movability-of-hugepage-in-unmap_and_move_huge_page.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch
mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable-v2.patch
mm-mempolicy-rename-check_range-to-queue_pages_range.patch
kernel-modsign_pubkeyc-fix-init-const-for-module-signing-code.patch
lto-watchdog-hpwdtc-make-assembler-label-global.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
x86-add-1-2-4-8-byte-optimization-to-64bit-__copy_fromto_user_inatomic.patch
sched-mark-should_resched-__always_inline.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

