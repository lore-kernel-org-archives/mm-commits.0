From: akpm@linux-foundation.org
Subject: + remove-duplicate-includes-from-many-files.patch added to -mm tree
Date: Wed, 20 Oct 2010 16:15:55 -0700
Message-ID: <201010202315.o9KNFtii010444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249Ab0JTXP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Oct 2010 19:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: napohybelskurwysynom2010@gmail.com


The patch titled
     Remove duplicate includes from many files
has been added to the -mm tree.  Its filename is
     remove-duplicate-includes-from-many-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove duplicate includes from many files
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>

Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-tegra/timer.c                    |    1 -
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    1 -
 arch/tile/kernel/setup.c                       |    2 --
 arch/x86/mm/init_64.c                          |    1 -
 arch/x86/xen/enlighten.c                       |    1 -
 drivers/media/IR/lirc_dev.c                    |    1 -
 drivers/platform/x86/intel_pmic_gpio.c         |    1 -
 include/linux/virtio_9p.h                      |    1 -
 kernel/trace/trace_kprobe.c                    |    1 -
 net/netfilter/xt_ipvs.c                        |    1 -
 10 files changed, 11 deletions(-)

diff -puN arch/arm/mach-tegra/timer.c~remove-duplicate-includes-from-many-files arch/arm/mach-tegra/timer.c
--- a/arch/arm/mach-tegra/timer.c~remove-duplicate-includes-from-many-files
+++ a/arch/arm/mach-tegra/timer.c
@@ -28,7 +28,6 @@
 #include <linux/cnt32_to_63.h>
 
 #include <asm/mach/time.h>
-#include <asm/mach/time.h>
 #include <asm/localtimer.h>
 
 #include <mach/iomap.h>
diff -puN arch/arm/plat-nomadik/include/plat/ste_dma40.h~remove-duplicate-includes-from-many-files arch/arm/plat-nomadik/include/plat/ste_dma40.h
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h~remove-duplicate-includes-from-many-files
+++ a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -12,7 +12,6 @@
 #include <linux/dmaengine.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
-#include <linux/dmaengine.h>
 
 /* dev types for memcpy */
 #define STEDMA40_DEV_DST_MEMORY (-1)
diff -puN arch/tile/kernel/setup.c~remove-duplicate-includes-from-many-files arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c~remove-duplicate-includes-from-many-files
+++ a/arch/tile/kernel/setup.c
@@ -30,8 +30,6 @@
 #include <linux/timex.h>
 #include <asm/setup.h>
 #include <asm/sections.h>
-#include <asm/sections.h>
-#include <asm/cacheflush.h>
 #include <asm/cacheflush.h>
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
diff -puN arch/x86/mm/init_64.c~remove-duplicate-includes-from-many-files arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~remove-duplicate-includes-from-many-files
+++ a/arch/x86/mm/init_64.c
@@ -51,7 +51,6 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
-#include <linux/bootmem.h>
 
 static int __init parse_direct_gbpages_off(char *arg)
 {
diff -puN arch/x86/xen/enlighten.c~remove-duplicate-includes-from-many-files arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c~remove-duplicate-includes-from-many-files
+++ a/arch/x86/xen/enlighten.c
@@ -60,7 +60,6 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
-#include <asm/setup.h>
 #include <asm/stackprotector.h>
 #include <asm/hypervisor.h>
 
diff -puN drivers/media/IR/lirc_dev.c~remove-duplicate-includes-from-many-files drivers/media/IR/lirc_dev.c
--- a/drivers/media/IR/lirc_dev.c~remove-duplicate-includes-from-many-files
+++ a/drivers/media/IR/lirc_dev.c
@@ -27,7 +27,6 @@
 #include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/completion.h>
-#include <linux/errno.h>
 #include <linux/mutex.h>
 #include <linux/wait.h>
 #include <linux/unistd.h>
diff -puN drivers/platform/x86/intel_pmic_gpio.c~remove-duplicate-includes-from-many-files drivers/platform/x86/intel_pmic_gpio.c
--- a/drivers/platform/x86/intel_pmic_gpio.c~remove-duplicate-includes-from-many-files
+++ a/drivers/platform/x86/intel_pmic_gpio.c
@@ -29,7 +29,6 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
-#include <linux/interrupt.h>
 #include <asm/intel_scu_ipc.h>
 #include <linux/device.h>
 #include <linux/intel_pmic_gpio.h>
diff -puN include/linux/virtio_9p.h~remove-duplicate-includes-from-many-files include/linux/virtio_9p.h
--- a/include/linux/virtio_9p.h~remove-duplicate-includes-from-many-files
+++ a/include/linux/virtio_9p.h
@@ -5,7 +5,6 @@
 #include <linux/types.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
-#include <linux/types.h>
 
 /* The feature bitmap for virtio 9P */
 
diff -puN kernel/trace/trace_kprobe.c~remove-duplicate-includes-from-many-files kernel/trace/trace_kprobe.c
--- a/kernel/trace/trace_kprobe.c~remove-duplicate-includes-from-many-files
+++ a/kernel/trace/trace_kprobe.c
@@ -31,7 +31,6 @@
 #include <linux/perf_event.h>
 #include <linux/stringify.h>
 #include <linux/limits.h>
-#include <linux/uaccess.h>
 #include <asm/bitsperlong.h>
 
 #include "trace.h"
diff -puN net/netfilter/xt_ipvs.c~remove-duplicate-includes-from-many-files net/netfilter/xt_ipvs.c
--- a/net/netfilter/xt_ipvs.c~remove-duplicate-includes-from-many-files
+++ a/net/netfilter/xt_ipvs.c
@@ -16,7 +16,6 @@
 #include <linux/ip_vs.h>
 #include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_ipvs.h>
 #include <net/netfilter/nf_conntrack.h>
 
_

Patches currently in -mm which might be from napohybelskurwysynom2010@gmail.com are

linux-next.patch
remove-duplicate-includes-from-many-files.patch

