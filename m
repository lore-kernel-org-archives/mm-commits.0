From: akpm@linux-foundation.org
Subject: + headers-untangle-kmemleakh-from-mmh.patch added to -mm tree
Date: Fri, 16 Feb 2018 16:34:56 -0800
Message-ID: <5a8778b0.KYgkwHcQSAw5633h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48470 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbeBQAe5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 19:34:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, fengguang.wu@intel.com, gregkh@linuxfoundation.org, john.johansen@canonical.com, mcgrof@kernel.org, mingo@kernel.org, mpe@ellerman.id.au, weiyongjun1@huawei.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: headers: untangle kmemleak.h from mm.h
has been added to the -mm tree.  Its filename is
     headers-untangle-kmemleakh-from-mmh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/headers-untangle-kmemleakh-from-mmh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/headers-untangle-kmemleakh-from-mmh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: headers: untangle kmemleak.h from mm.h

Currently <linux/slab.h> #includes <linux/kmemleak.h> for no obvious
reason.  It looks like it's only a convenience, so remove kmemleak.h from
slab.h and add <linux/kmemleak.h> to any users of kmemleak_* that don't
already #include it.  Also remove <linux/kmemleak.h> from source files
that do not use it.

This is tested on i386 allmodconfig and x86_64 allmodconfig.  It would be
good to run it through the 0day bot for other $ARCHes.  I have neither the
horsepower nor the storage space for the other $ARCHes.

Update: This patch has been extensively build-tested by both the 0day bot
& kisskb/ozlabs build farms.  Both of them reported 2 build failures for
which patches are included here (in v2).

[slab.h is the second most used header file after module.h; kernel.h is
right there with slab.h.  There could be some minor error in the counting
due to some #includes having comments after them and I didn't combine all
of those.]

Link: http://lkml.kernel.org/r/e4309f98-3749-93e1-4bb7-d9501a39d015@infradead.org
Link: http://kisskb.ellerman.id.au/kisskb/head/13396/
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Reported-by: Michael Ellerman <mpe@ellerman.id.au>	[2 build failures]
Reported-by: Fengguang Wu <fengguang.wu@intel.com>	[2 build failures]
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: John Johansen <john.johansen@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/dart_iommu.c                          |    1 +
 arch/powerpc/sysdev/msi_bitmap.c                          |    1 +
 arch/s390/kernel/nmi.c                                    |    2 +-
 arch/s390/kernel/smp.c                                    |    1 -
 arch/sparc/kernel/irq_64.c                                |    1 -
 arch/x86/kernel/pci-dma.c                                 |    1 -
 drivers/iommu/exynos-iommu.c                              |    1 +
 drivers/iommu/mtk_iommu_v1.c                              |    1 -
 drivers/net/ethernet/ti/cpsw.c                            |    1 +
 drivers/net/wireless/realtek/rtlwifi/pci.c                |    1 -
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c |    1 -
 drivers/staging/rtl8188eu/hal/fw.c                        |    2 +-
 drivers/staging/rtlwifi/pci.c                             |    1 -
 drivers/virtio/virtio_ring.c                              |    1 -
 include/linux/slab.h                                      |    1 -
 kernel/ucount.c                                           |    1 +
 lib/test_firmware.c                                       |    1 +
 mm/cma.c                                                  |    1 +
 mm/memblock.c                                             |    1 +
 net/core/sysctl_net_core.c                                |    1 -
 net/ipv4/route.c                                          |    1 -
 security/apparmor/lsm.c                                   |    1 -
 security/integrity/digsig.c                               |    1 +
 23 files changed, 11 insertions(+), 14 deletions(-)

diff -puN arch/powerpc/sysdev/dart_iommu.c~headers-untangle-kmemleakh-from-mmh arch/powerpc/sysdev/dart_iommu.c
--- a/arch/powerpc/sysdev/dart_iommu.c~headers-untangle-kmemleakh-from-mmh
+++ a/arch/powerpc/sysdev/dart_iommu.c
@@ -38,6 +38,7 @@
 #include <linux/suspend.h>
 #include <linux/memblock.h>
 #include <linux/gfp.h>
+#include <linux/kmemleak.h>
 #include <asm/io.h>
 #include <asm/prom.h>
 #include <asm/iommu.h>
diff -puN arch/powerpc/sysdev/msi_bitmap.c~headers-untangle-kmemleakh-from-mmh arch/powerpc/sysdev/msi_bitmap.c
--- a/arch/powerpc/sysdev/msi_bitmap.c~headers-untangle-kmemleakh-from-mmh
+++ a/arch/powerpc/sysdev/msi_bitmap.c
@@ -10,6 +10,7 @@
 
 #include <linux/slab.h>
 #include <linux/kernel.h>
+#include <linux/kmemleak.h>
 #include <linux/bitmap.h>
 #include <linux/bootmem.h>
 #include <asm/msi_bitmap.h>
diff -puN arch/s390/kernel/nmi.c~headers-untangle-kmemleakh-from-mmh arch/s390/kernel/nmi.c
--- a/arch/s390/kernel/nmi.c~headers-untangle-kmemleakh-from-mmh
+++ a/arch/s390/kernel/nmi.c
@@ -15,7 +15,7 @@
 #include <linux/hardirq.h>
 #include <linux/log2.h>
 #include <linux/kprobes.h>
-#include <linux/slab.h>
+#include <linux/kmemleak.h>
 #include <linux/time.h>
 #include <linux/module.h>
 #include <linux/sched/signal.h>
diff -puN arch/s390/kernel/smp.c~headers-untangle-kmemleakh-from-mmh arch/s390/kernel/smp.c
--- a/arch/s390/kernel/smp.c~headers-untangle-kmemleakh-from-mmh
+++ a/arch/s390/kernel/smp.c
@@ -27,7 +27,6 @@
 #include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/kernel_stat.h>
-#include <linux/kmemleak.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/irqflags.h>
diff -puN arch/sparc/kernel/irq_64.c~headers-untangle-kmemleakh-from-mmh arch/sparc/kernel/irq_64.c
--- a/arch/sparc/kernel/irq_64.c~headers-untangle-kmemleakh-from-mmh
+++ a/arch/sparc/kernel/irq_64.c
@@ -22,7 +22,6 @@
 #include <linux/seq_file.h>
 #include <linux/ftrace.h>
 #include <linux/irq.h>
-#include <linux/kmemleak.h>
 
 #include <asm/ptrace.h>
 #include <asm/processor.h>
diff -puN arch/x86/kernel/pci-dma.c~headers-untangle-kmemleakh-from-mmh arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~headers-untangle-kmemleakh-from-mmh
+++ a/arch/x86/kernel/pci-dma.c
@@ -6,7 +6,6 @@
 #include <linux/bootmem.h>
 #include <linux/gfp.h>
 #include <linux/pci.h>
-#include <linux/kmemleak.h>
 
 #include <asm/proto.h>
 #include <asm/dma.h>
diff -puN drivers/iommu/exynos-iommu.c~headers-untangle-kmemleakh-from-mmh drivers/iommu/exynos-iommu.c
--- a/drivers/iommu/exynos-iommu.c~headers-untangle-kmemleakh-from-mmh
+++ a/drivers/iommu/exynos-iommu.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/iommu.h>
 #include <linux/interrupt.h>
+#include <linux/kmemleak.h>
 #include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_iommu.h>
diff -puN drivers/iommu/mtk_iommu_v1.c~headers-untangle-kmemleakh-from-mmh drivers/iommu/mtk_iommu_v1.c
--- a/drivers/iommu/mtk_iommu_v1.c~headers-untangle-kmemleakh-from-mmh
+++ a/drivers/iommu/mtk_iommu_v1.c
@@ -25,7 +25,6 @@
 #include <linux/io.h>
 #include <linux/iommu.h>
 #include <linux/iopoll.h>
-#include <linux/kmemleak.h>
 #include <linux/list.h>
 #include <linux/of_address.h>
 #include <linux/of_iommu.h>
diff -puN drivers/net/ethernet/ti/cpsw.c~headers-untangle-kmemleakh-from-mmh drivers/net/ethernet/ti/cpsw.c
--- a/drivers/net/ethernet/ti/cpsw.c~headers-untangle-kmemleakh-from-mmh
+++ a/drivers/net/ethernet/ti/cpsw.c
@@ -35,6 +35,7 @@
 #include <linux/of_net.h>
 #include <linux/of_device.h>
 #include <linux/if_vlan.h>
+#include <linux/kmemleak.h>
 
 #include <linux/pinctrl/consumer.h>
 
diff -puN drivers/net/wireless/realtek/rtlwifi/pci.c~headers-untangle-kmemleakh-from-mmh drivers/net/wireless/realtek/rtlwifi/pci.c
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c~headers-untangle-kmemleakh-from-mmh
+++ a/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -31,7 +31,6 @@
 #include "efuse.h"
 #include <linux/interrupt.h>
 #include <linux/export.h>
-#include <linux/kmemleak.h>
 #include <linux/module.h>
 
 MODULE_AUTHOR("lizhaoming	<chaoming_li@realsil.com.cn>");
diff -puN drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c~headers-untangle-kmemleakh-from-mmh drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c~headers-untangle-kmemleakh-from-mmh
+++ a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -32,7 +32,6 @@
 #include "../rtl8192ce/def.h"
 #include "fw_common.h"
 #include <linux/export.h>
-#include <linux/kmemleak.h>
 
 static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 {
diff -puN drivers/staging/rtl8188eu/hal/fw.c~headers-untangle-kmemleakh-from-mmh drivers/staging/rtl8188eu/hal/fw.c
--- a/drivers/staging/rtl8188eu/hal/fw.c~headers-untangle-kmemleakh-from-mmh
+++ a/drivers/staging/rtl8188eu/hal/fw.c
@@ -30,7 +30,7 @@
 #include "rtl8188e_hal.h"
 
 #include <linux/firmware.h>
-#include <linux/kmemleak.h>
+#include <linux/slab.h>
 
 static void _rtl88e_enable_fw_download(struct adapter *adapt, bool enable)
 {
diff -puN drivers/staging/rtlwifi/pci.c~headers-untangle-kmemleakh-from-mmh drivers/staging/rtlwifi/pci.c
--- a/drivers/staging/rtlwifi/pci.c~headers-untangle-kmemleakh-from-mmh
+++ a/drivers/staging/rtlwifi/pci.c
@@ -31,7 +31,6 @@
 #include "efuse.h"
 #include <linux/interrupt.h>
 #include <linux/export.h>
-#include <linux/kmemleak.h>
 #include <linux/module.h>
 
 MODULE_AUTHOR("lizhaoming	<chaoming_li@realsil.com.cn>");
diff -puN drivers/virtio/virtio_ring.c~headers-untangle-kmemleakh-from-mmh drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c~headers-untangle-kmemleakh-from-mmh
+++ a/drivers/virtio/virtio_ring.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/hrtimer.h>
-#include <linux/kmemleak.h>
 #include <linux/dma-mapping.h>
 #include <xen/xen.h>
 
diff -puN include/linux/slab.h~headers-untangle-kmemleakh-from-mmh include/linux/slab.h
--- a/include/linux/slab.h~headers-untangle-kmemleakh-from-mmh
+++ a/include/linux/slab.h
@@ -125,7 +125,6 @@
 #define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
 				(unsigned long)ZERO_SIZE_PTR)
 
-#include <linux/kmemleak.h>
 #include <linux/kasan.h>
 
 struct mem_cgroup;
diff -puN kernel/ucount.c~headers-untangle-kmemleakh-from-mmh kernel/ucount.c
--- a/kernel/ucount.c~headers-untangle-kmemleakh-from-mmh
+++ a/kernel/ucount.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 #include <linux/cred.h>
 #include <linux/hash.h>
+#include <linux/kmemleak.h>
 #include <linux/user_namespace.h>
 
 #define UCOUNTS_HASHTABLE_BITS 10
diff -puN lib/test_firmware.c~headers-untangle-kmemleakh-from-mmh lib/test_firmware.c
--- a/lib/test_firmware.c~headers-untangle-kmemleakh-from-mmh
+++ a/lib/test_firmware.c
@@ -21,6 +21,7 @@
 #include <linux/uaccess.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/vmalloc.h>
 
 #define TEST_FIRMWARE_NAME	"test-firmware.bin"
 #define TEST_FIRMWARE_NUM_REQS	4
diff -puN mm/cma.c~headers-untangle-kmemleakh-from-mmh mm/cma.c
--- a/mm/cma.c~headers-untangle-kmemleakh-from-mmh
+++ a/mm/cma.c
@@ -35,6 +35,7 @@
 #include <linux/cma.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
+#include <linux/kmemleak.h>
 #include <trace/events/cma.h>
 
 #include "cma.h"
diff -puN mm/memblock.c~headers-untangle-kmemleakh-from-mmh mm/memblock.c
--- a/mm/memblock.c~headers-untangle-kmemleakh-from-mmh
+++ a/mm/memblock.c
@@ -17,6 +17,7 @@
 #include <linux/poison.h>
 #include <linux/pfn.h>
 #include <linux/debugfs.h>
+#include <linux/kmemleak.h>
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 
diff -puN net/core/sysctl_net_core.c~headers-untangle-kmemleakh-from-mmh net/core/sysctl_net_core.c
--- a/net/core/sysctl_net_core.c~headers-untangle-kmemleakh-from-mmh
+++ a/net/core/sysctl_net_core.c
@@ -15,7 +15,6 @@
 #include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/kmemleak.h>
 
 #include <net/ip.h>
 #include <net/sock.h>
diff -puN net/ipv4/route.c~headers-untangle-kmemleakh-from-mmh net/ipv4/route.c
--- a/net/ipv4/route.c~headers-untangle-kmemleakh-from-mmh
+++ a/net/ipv4/route.c
@@ -108,7 +108,6 @@
 #include <net/rtnetlink.h>
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
-#include <linux/kmemleak.h>
 #endif
 #include <net/secure_seq.h>
 #include <net/ip_tunnels.h>
diff -puN security/apparmor/lsm.c~headers-untangle-kmemleakh-from-mmh security/apparmor/lsm.c
--- a/security/apparmor/lsm.c~headers-untangle-kmemleakh-from-mmh
+++ a/security/apparmor/lsm.c
@@ -23,7 +23,6 @@
 #include <linux/sysctl.h>
 #include <linux/audit.h>
 #include <linux/user_namespace.h>
-#include <linux/kmemleak.h>
 #include <net/sock.h>
 
 #include "include/apparmor.h"
diff -puN security/integrity/digsig.c~headers-untangle-kmemleakh-from-mmh security/integrity/digsig.c
--- a/security/integrity/digsig.c~headers-untangle-kmemleakh-from-mmh
+++ a/security/integrity/digsig.c
@@ -18,6 +18,7 @@
 #include <linux/cred.h>
 #include <linux/key-type.h>
 #include <linux/digsig.h>
+#include <linux/vmalloc.h>
 #include <crypto/public_key.h>
 #include <keys/system_keyring.h>
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-swap_slots-use-conditional-compilation-for-swap_slotsc.patch
headers-untangle-kmemleakh-from-mmh.patch

