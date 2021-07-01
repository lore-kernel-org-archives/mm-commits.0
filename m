Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB44C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F7561477
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238541AbhGAB5b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB5a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC6FC61469;
        Thu,  1 Jul 2021 01:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104500;
        bh=xyQsZifqOTOPqjHYoCWAJzwkqgUGBbf2vhRGqG8rrJU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aRJUWtbwaXBsSwTwH/ZTcPPextRhr+SSwjJLWkG25iQOrnIC4bb6oFFIfgiDZj6ha
         yHenyFSVQ1YzLKgcy6unrnWvkAXeNhjwX9Qn6kuMvs0m2MvqyCztxeBIm867md94e4
         tFU/t0J2mJVVcfVd7V0c215RwJyALAMqeBc/Zs98=
Date:   Wed, 30 Jun 2021 18:54:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bjorn.andersson@linaro.org,
        christian.brauner@ubuntu.com, cminyard@mvista.com, deller@gmx.de,
        keescook@chromium.org, linux-mm@kvack.org,
        linux@rasmusvillemoes.dk, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, sboyd@kernel.org,
        sre@kernel.org, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, wei.liu@kernel.org
Subject:  [patch 146/192] kernel.h: split out panic and oops
 helpers
Message-ID: <20210701015459.RNbWvwfIP%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: split out panic and oops helpers

kernel.h is being used as a dump for all kinds of stuff for a long time. 
Here is the attempt to start cleaning it up by splitting out panic and
oops helpers.

There are several purposes of doing this:
- dropping dependency in bug.h
- dropping a loop by moving out panic_notifier.h
- unload kernel.h from something which has its own domain

At the same time convert users tree-wide to use new headers, although for
the time being include new header back to kernel.h to avoid twisted
indirected includes for existing users.

[akpm@linux-foundation.org: thread_info.h needs limits.h]
[andriy.shevchenko@linux.intel.com: ia64 fix]
  Link: https://lkml.kernel.org/r/20210520130557.55277-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20210511074137.33666-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Co-developed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Corey Minyard <cminyard@mvista.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Wei Liu <wei.liu@kernel.org>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Sebastian Reichel <sre@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-by: Helge Deller <deller@gmx.de> # parisc
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/setup.c                         |    2 
 arch/arm64/kernel/setup.c                         |    1 
 arch/ia64/include/asm/pal.h                       |    1 
 arch/mips/kernel/relocate.c                       |    1 
 arch/mips/sgi-ip22/ip22-reset.c                   |    1 
 arch/mips/sgi-ip32/ip32-reset.c                   |    1 
 arch/parisc/kernel/pdc_chassis.c                  |    1 
 arch/powerpc/kernel/setup-common.c                |    1 
 arch/s390/kernel/ipl.c                            |    1 
 arch/sparc/kernel/sstate.c                        |    1 
 arch/um/drivers/mconsole_kern.c                   |    1 
 arch/um/kernel/um_arch.c                          |    1 
 arch/x86/include/asm/desc.h                       |    1 
 arch/x86/kernel/cpu/mshyperv.c                    |    1 
 arch/x86/kernel/setup.c                           |    1 
 arch/x86/purgatory/purgatory.c                    |    2 
 arch/x86/xen/enlighten.c                          |    1 
 arch/xtensa/platforms/iss/setup.c                 |    1 
 drivers/bus/brcmstb_gisb.c                        |    1 
 drivers/char/ipmi/ipmi_msghandler.c               |    1 
 drivers/clk/analogbits/wrpll-cln28hpc.c           |    4 
 drivers/edac/altera_edac.c                        |    1 
 drivers/firmware/google/gsmi.c                    |    1 
 drivers/hv/vmbus_drv.c                            |    1 
 drivers/hwtracing/coresight/coresight-cpu-debug.c |    1 
 drivers/leds/trigger/ledtrig-activity.c           |    1 
 drivers/leds/trigger/ledtrig-heartbeat.c          |    1 
 drivers/leds/trigger/ledtrig-panic.c              |    1 
 drivers/misc/bcm-vk/bcm_vk_dev.c                  |    1 
 drivers/misc/ibmasm/heartbeat.c                   |    1 
 drivers/misc/pvpanic/pvpanic.c                    |    1 
 drivers/net/ipa/ipa_smp2p.c                       |    1 
 drivers/parisc/power.c                            |    1 
 drivers/power/reset/ltc2952-poweroff.c            |    1 
 drivers/remoteproc/remoteproc_core.c              |    1 
 drivers/s390/char/con3215.c                       |    1 
 drivers/s390/char/con3270.c                       |    1 
 drivers/s390/char/sclp.c                          |    1 
 drivers/s390/char/sclp_con.c                      |    1 
 drivers/s390/char/sclp_vt220.c                    |    1 
 drivers/s390/char/zcore.c                         |    1 
 drivers/soc/bcm/brcmstb/pm/pm-arm.c               |    1 
 drivers/staging/olpc_dcon/olpc_dcon.c             |    1 
 drivers/video/fbdev/hyperv_fb.c                   |    1 
 include/asm-generic/bug.h                         |    3 
 include/linux/kernel.h                            |   84 ----------
 include/linux/panic.h                             |   98 ++++++++++++
 include/linux/panic_notifier.h                    |   12 +
 include/linux/thread_info.h                       |    1 
 kernel/hung_task.c                                |    1 
 kernel/kexec_core.c                               |    1 
 kernel/panic.c                                    |    1 
 kernel/rcu/tree.c                                 |    2 
 kernel/sysctl.c                                   |    1 
 kernel/trace/trace.c                              |    1 
 55 files changed, 169 insertions(+), 85 deletions(-)

--- a/arch/alpha/kernel/setup.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/alpha/kernel/setup.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
+#include <linux/panic_notifier.h>
 #include <linux/platform_device.h>
 #include <linux/memblock.h>
 #include <linux/pci.h>
@@ -46,7 +47,6 @@
 #include <linux/log2.h>
 #include <linux/export.h>
 
-extern struct atomic_notifier_head panic_notifier_list;
 static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
 static struct notifier_block alpha_panic_block = {
 	alpha_panic_event,
--- a/arch/arm64/kernel/setup.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/arm64/kernel/setup.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/smp.h>
 #include <linux/fs.h>
+#include <linux/panic_notifier.h>
 #include <linux/proc_fs.h>
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
--- a/arch/ia64/include/asm/pal.h~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/ia64/include/asm/pal.h
@@ -99,6 +99,7 @@
 
 #include <linux/types.h>
 #include <asm/fpu.h>
+#include <asm/intrinsics.h>
 
 /*
  * Data types needed to pass information into PAL procedures and
--- a/arch/mips/kernel/relocate.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/mips/kernel/relocate.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/libfdt.h>
 #include <linux/of_fdt.h>
+#include <linux/panic_notifier.h>
 #include <linux/sched/task.h>
 #include <linux/start_kernel.h>
 #include <linux/string.h>
--- a/arch/mips/sgi-ip22/ip22-reset.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/mips/sgi-ip22/ip22-reset.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/sched/signal.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/pm.h>
 #include <linux/timer.h>
 
--- a/arch/mips/sgi-ip32/ip32-reset.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/mips/sgi-ip32/ip32-reset.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/notifier.h>
--- a/arch/parisc/kernel/pdc_chassis.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/parisc/kernel/pdc_chassis.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/notifier.h>
 #include <linux/cache.h>
--- a/arch/powerpc/kernel/setup-common.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/powerpc/kernel/setup-common.c
@@ -9,6 +9,7 @@
 #undef DEBUG
 
 #include <linux/export.h>
+#include <linux/panic_notifier.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/init.h>
--- a/arch/s390/kernel/ipl.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/s390/kernel/ipl.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/delay.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/ctype.h>
 #include <linux/fs.h>
--- a/arch/sparc/kernel/sstate.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/sparc/kernel/sstate.c
@@ -6,6 +6,7 @@
 
 #include <linux/kernel.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
 
--- a/arch/um/drivers/mconsole_kern.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/um/drivers/mconsole_kern.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/sched/debug.h>
 #include <linux/proc_fs.h>
--- a/arch/um/kernel/um_arch.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/um/kernel/um_arch.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/utsname.h>
--- a/arch/x86/include/asm/desc.h~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/x86/include/asm/desc.h
@@ -9,6 +9,7 @@
 #include <asm/irq_vectors.h>
 #include <asm/cpu_entry_area.h>
 
+#include <linux/debug_locks.h>
 #include <linux/smp.h>
 #include <linux/percpu.h>
 
--- a/arch/x86/kernel/cpu/mshyperv.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/x86/kernel/cpu/mshyperv.c
@@ -17,6 +17,7 @@
 #include <linux/irq.h>
 #include <linux/kexec.h>
 #include <linux/i8253.h>
+#include <linux/panic_notifier.h>
 #include <linux/random.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
--- a/arch/x86/kernel/setup.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/x86/kernel/setup.c
@@ -14,6 +14,7 @@
 #include <linux/initrd.h>
 #include <linux/iscsi_ibft.h>
 #include <linux/memblock.h>
+#include <linux/panic_notifier.h>
 #include <linux/pci.h>
 #include <linux/root_dev.h>
 #include <linux/hugetlb.h>
--- a/arch/x86/purgatory/purgatory.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/x86/purgatory/purgatory.c
@@ -9,6 +9,8 @@
  */
 
 #include <linux/bug.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
 #include <crypto/sha2.h>
 #include <asm/purgatory.h>
 
--- a/arch/x86/xen/enlighten.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/x86/xen/enlighten.c
@@ -6,6 +6,7 @@
 #include <linux/cpu.h>
 #include <linux/kexec.h>
 #include <linux/slab.h>
+#include <linux/panic_notifier.h>
 
 #include <xen/xen.h>
 #include <xen/features.h>
--- a/arch/xtensa/platforms/iss/setup.c~kernelh-split-out-panic-and-oops-helpers
+++ a/arch/xtensa/platforms/iss/setup.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/printk.h>
 #include <linux/string.h>
 
--- a/drivers/bus/brcmstb_gisb.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/bus/brcmstb_gisb.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/sysfs.h>
--- a/drivers/char/ipmi/ipmi_msghandler.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/panic_notifier.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
--- a/drivers/clk/analogbits/wrpll-cln28hpc.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/clk/analogbits/wrpll-cln28hpc.c
@@ -23,8 +23,12 @@
 
 #include <linux/bug.h>
 #include <linux/err.h>
+#include <linux/limits.h>
 #include <linux/log2.h>
 #include <linux/math64.h>
+#include <linux/math.h>
+#include <linux/minmax.h>
+
 #include <linux/clk/analogbits-wrpll-cln28hpc.h>
 
 /* MIN_INPUT_FREQ: minimum input clock frequency, in Hz (Fref_min) */
--- a/drivers/edac/altera_edac.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/edac/altera_edac.c
@@ -20,6 +20,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/panic_notifier.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/types.h>
--- a/drivers/firmware/google/gsmi.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/firmware/google/gsmi.c
@@ -19,6 +19,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/panic_notifier.h>
 #include <linux/ioctl.h>
 #include <linux/acpi.h>
 #include <linux/io.h>
--- a/drivers/hv/vmbus_drv.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/hv/vmbus_drv.c
@@ -25,6 +25,7 @@
 
 #include <linux/delay.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/ptrace.h>
 #include <linux/screen_info.h>
 #include <linux/kdebug.h>
--- a/drivers/hwtracing/coresight/coresight-cpu-debug.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/hwtracing/coresight/coresight-cpu-debug.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/panic_notifier.h>
 #include <linux/pm_qos.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
--- a/drivers/leds/trigger/ledtrig-activity.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/leds/trigger/ledtrig-activity.c
@@ -11,6 +11,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/leds.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
--- a/drivers/leds/trigger/ledtrig-heartbeat.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/leds/trigger/ledtrig-heartbeat.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/panic_notifier.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
--- a/drivers/leds/trigger/ledtrig-panic.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/leds/trigger/ledtrig-panic.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/leds.h>
 #include "../leds.h"
 
--- a/drivers/misc/bcm-vk/bcm_vk_dev.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/misc/bcm-vk/bcm_vk_dev.c
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
+#include <linux/panic_notifier.h>
 #include <linux/kref.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
--- a/drivers/misc/ibmasm/heartbeat.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/misc/ibmasm/heartbeat.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include "ibmasm.h"
 #include "dot_command.h"
 #include "lowlevel.h"
--- a/drivers/misc/pvpanic/pvpanic.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/misc/pvpanic/pvpanic.c
@@ -13,6 +13,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/panic_notifier.h>
 #include <linux/types.h>
 #include <linux/cdev.h>
 #include <linux/list.h>
--- a/drivers/net/ipa/ipa_smp2p.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/net/ipa/ipa_smp2p.c
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/soc/qcom/smem.h>
 #include <linux/soc/qcom/smem_state.h>
 
--- a/drivers/parisc/power.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/parisc/power.c
@@ -38,6 +38,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/sched/signal.h>
 #include <linux/kthread.h>
--- a/drivers/power/reset/ltc2952-poweroff.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/power/reset/ltc2952-poweroff.c
@@ -52,6 +52,7 @@
 #include <linux/slab.h>
 #include <linux/kmod.h>
 #include <linux/module.h>
+#include <linux/panic_notifier.h>
 #include <linux/mod_devicetable.h>
 #include <linux/gpio/consumer.h>
 #include <linux/reboot.h>
--- a/drivers/remoteproc/remoteproc_core.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/remoteproc/remoteproc_core.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/panic_notifier.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/dma-map-ops.h>
--- a/drivers/s390/char/con3215.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/s390/char/con3215.c
@@ -19,6 +19,7 @@
 #include <linux/console.h>
 #include <linux/interrupt.h>
 #include <linux/err.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/serial.h> /* ASYNC_* flags */
 #include <linux/slab.h>
--- a/drivers/s390/char/con3270.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/s390/char/con3270.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/panic_notifier.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/err.h>
--- a/drivers/s390/char/sclp.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/s390/char/sclp.c
@@ -11,6 +11,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/panic_notifier.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
--- a/drivers/s390/char/sclp_con.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/s390/char/sclp_con.c
@@ -10,6 +10,7 @@
 #include <linux/kmod.h>
 #include <linux/console.h>
 #include <linux/init.h>
+#include <linux/panic_notifier.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
 #include <linux/termios.h>
--- a/drivers/s390/char/sclp_vt220.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/s390/char/sclp_vt220.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/panic_notifier.h>
 #include <linux/list.h>
 #include <linux/wait.h>
 #include <linux/timer.h>
--- a/drivers/s390/char/zcore.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/s390/char/zcore.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/debugfs.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 
 #include <asm/asm-offsets.h>
--- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
@@ -28,6 +28,7 @@
 #include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/panic_notifier.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/printk.h>
--- a/drivers/staging/olpc_dcon/olpc_dcon.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/uaccess.h>
 #include <linux/ctype.h>
+#include <linux/panic_notifier.h>
 #include <linux/reboot.h>
 #include <linux/olpc-ec.h>
 #include <asm/tsc.h>
--- a/drivers/video/fbdev/hyperv_fb.c~kernelh-split-out-panic-and-oops-helpers
+++ a/drivers/video/fbdev/hyperv_fb.c
@@ -52,6 +52,7 @@
 #include <linux/completion.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
+#include <linux/panic_notifier.h>
 #include <linux/efi.h>
 #include <linux/console.h>
 
--- a/include/asm-generic/bug.h~kernelh-split-out-panic-and-oops-helpers
+++ a/include/asm-generic/bug.h
@@ -17,7 +17,8 @@
 #endif
 
 #ifndef __ASSEMBLY__
-#include <linux/kernel.h>
+#include <linux/panic.h>
+#include <linux/printk.h>
 
 #ifdef CONFIG_BUG
 
--- a/include/linux/kernel.h~kernelh-split-out-panic-and-oops-helpers
+++ a/include/linux/kernel.h
@@ -14,6 +14,7 @@
 #include <linux/math.h>
 #include <linux/minmax.h>
 #include <linux/typecheck.h>
+#include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/build_bug.h>
 #include <linux/static_call_types.h>
@@ -72,7 +73,6 @@
 #define lower_32_bits(n) ((u32)((n) & 0xffffffff))
 
 struct completion;
-struct pt_regs;
 struct user;
 
 #ifdef CONFIG_PREEMPT_VOLUNTARY
@@ -177,14 +177,6 @@ void __might_fault(const char *file, int
 static inline void might_fault(void) { }
 #endif
 
-extern struct atomic_notifier_head panic_notifier_list;
-extern long (*panic_blink)(int state);
-__printf(1, 2)
-void panic(const char *fmt, ...) __noreturn __cold;
-void nmi_panic(struct pt_regs *regs, const char *msg);
-extern void oops_enter(void);
-extern void oops_exit(void);
-extern bool oops_may_print(void);
 void do_exit(long error_code) __noreturn;
 void complete_and_exit(struct completion *, long) __noreturn;
 
@@ -372,52 +364,8 @@ extern int __kernel_text_address(unsigne
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
 
-#ifdef CONFIG_SMP
-extern unsigned int sysctl_oops_all_cpu_backtrace;
-#else
-#define sysctl_oops_all_cpu_backtrace 0
-#endif /* CONFIG_SMP */
-
 extern void bust_spinlocks(int yes);
-extern int panic_timeout;
-extern unsigned long panic_print;
-extern int panic_on_oops;
-extern int panic_on_unrecovered_nmi;
-extern int panic_on_io_nmi;
-extern int panic_on_warn;
-extern unsigned long panic_on_taint;
-extern bool panic_on_taint_nousertaint;
-extern int sysctl_panic_on_rcu_stall;
-extern int sysctl_max_rcu_stall_to_panic;
-extern int sysctl_panic_on_stackoverflow;
-
-extern bool crash_kexec_post_notifiers;
-
-/*
- * panic_cpu is used for synchronizing panic() and crash_kexec() execution. It
- * holds a CPU number which is executing panic() currently. A value of
- * PANIC_CPU_INVALID means no CPU has entered panic() or crash_kexec().
- */
-extern atomic_t panic_cpu;
-#define PANIC_CPU_INVALID	-1
 
-/*
- * Only to be used by arch init code. If the user over-wrote the default
- * CONFIG_PANIC_TIMEOUT, honor it.
- */
-static inline void set_arch_panic_timeout(int timeout, int arch_default_timeout)
-{
-	if (panic_timeout == arch_default_timeout)
-		panic_timeout = timeout;
-}
-extern const char *print_tainted(void);
-enum lockdep_ok {
-	LOCKDEP_STILL_OK,
-	LOCKDEP_NOW_UNRELIABLE
-};
-extern void add_taint(unsigned flag, enum lockdep_ok);
-extern int test_taint(unsigned flag);
-extern unsigned long get_taint(void);
 extern int root_mountflags;
 
 extern bool early_boot_irqs_disabled;
@@ -436,36 +384,6 @@ extern enum system_states {
 	SYSTEM_SUSPEND,
 } system_state;
 
-/* This cannot be an enum because some may be used in assembly source. */
-#define TAINT_PROPRIETARY_MODULE	0
-#define TAINT_FORCED_MODULE		1
-#define TAINT_CPU_OUT_OF_SPEC		2
-#define TAINT_FORCED_RMMOD		3
-#define TAINT_MACHINE_CHECK		4
-#define TAINT_BAD_PAGE			5
-#define TAINT_USER			6
-#define TAINT_DIE			7
-#define TAINT_OVERRIDDEN_ACPI_TABLE	8
-#define TAINT_WARN			9
-#define TAINT_CRAP			10
-#define TAINT_FIRMWARE_WORKAROUND	11
-#define TAINT_OOT_MODULE		12
-#define TAINT_UNSIGNED_MODULE		13
-#define TAINT_SOFTLOCKUP		14
-#define TAINT_LIVEPATCH			15
-#define TAINT_AUX			16
-#define TAINT_RANDSTRUCT		17
-#define TAINT_FLAGS_COUNT		18
-#define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
-
-struct taint_flag {
-	char c_true;	/* character printed when tainted */
-	char c_false;	/* character printed when not tainted */
-	bool module;	/* also show as a per-module taint flag */
-};
-
-extern const struct taint_flag taint_flags[TAINT_FLAGS_COUNT];
-
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
 #define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
--- /dev/null
+++ a/include/linux/panic.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PANIC_H
+#define _LINUX_PANIC_H
+
+#include <linux/compiler_attributes.h>
+#include <linux/types.h>
+
+struct pt_regs;
+
+extern long (*panic_blink)(int state);
+__printf(1, 2)
+void panic(const char *fmt, ...) __noreturn __cold;
+void nmi_panic(struct pt_regs *regs, const char *msg);
+extern void oops_enter(void);
+extern void oops_exit(void);
+extern bool oops_may_print(void);
+
+#ifdef CONFIG_SMP
+extern unsigned int sysctl_oops_all_cpu_backtrace;
+#else
+#define sysctl_oops_all_cpu_backtrace 0
+#endif /* CONFIG_SMP */
+
+extern int panic_timeout;
+extern unsigned long panic_print;
+extern int panic_on_oops;
+extern int panic_on_unrecovered_nmi;
+extern int panic_on_io_nmi;
+extern int panic_on_warn;
+
+extern unsigned long panic_on_taint;
+extern bool panic_on_taint_nousertaint;
+
+extern int sysctl_panic_on_rcu_stall;
+extern int sysctl_max_rcu_stall_to_panic;
+extern int sysctl_panic_on_stackoverflow;
+
+extern bool crash_kexec_post_notifiers;
+
+/*
+ * panic_cpu is used for synchronizing panic() and crash_kexec() execution. It
+ * holds a CPU number which is executing panic() currently. A value of
+ * PANIC_CPU_INVALID means no CPU has entered panic() or crash_kexec().
+ */
+extern atomic_t panic_cpu;
+#define PANIC_CPU_INVALID	-1
+
+/*
+ * Only to be used by arch init code. If the user over-wrote the default
+ * CONFIG_PANIC_TIMEOUT, honor it.
+ */
+static inline void set_arch_panic_timeout(int timeout, int arch_default_timeout)
+{
+	if (panic_timeout == arch_default_timeout)
+		panic_timeout = timeout;
+}
+
+/* This cannot be an enum because some may be used in assembly source. */
+#define TAINT_PROPRIETARY_MODULE	0
+#define TAINT_FORCED_MODULE		1
+#define TAINT_CPU_OUT_OF_SPEC		2
+#define TAINT_FORCED_RMMOD		3
+#define TAINT_MACHINE_CHECK		4
+#define TAINT_BAD_PAGE			5
+#define TAINT_USER			6
+#define TAINT_DIE			7
+#define TAINT_OVERRIDDEN_ACPI_TABLE	8
+#define TAINT_WARN			9
+#define TAINT_CRAP			10
+#define TAINT_FIRMWARE_WORKAROUND	11
+#define TAINT_OOT_MODULE		12
+#define TAINT_UNSIGNED_MODULE		13
+#define TAINT_SOFTLOCKUP		14
+#define TAINT_LIVEPATCH			15
+#define TAINT_AUX			16
+#define TAINT_RANDSTRUCT		17
+#define TAINT_FLAGS_COUNT		18
+#define TAINT_FLAGS_MAX			((1UL << TAINT_FLAGS_COUNT) - 1)
+
+struct taint_flag {
+	char c_true;	/* character printed when tainted */
+	char c_false;	/* character printed when not tainted */
+	bool module;	/* also show as a per-module taint flag */
+};
+
+extern const struct taint_flag taint_flags[TAINT_FLAGS_COUNT];
+
+enum lockdep_ok {
+	LOCKDEP_STILL_OK,
+	LOCKDEP_NOW_UNRELIABLE,
+};
+
+extern const char *print_tainted(void);
+extern void add_taint(unsigned flag, enum lockdep_ok);
+extern int test_taint(unsigned flag);
+extern unsigned long get_taint(void);
+
+#endif	/* _LINUX_PANIC_H */
--- /dev/null
+++ a/include/linux/panic_notifier.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PANIC_NOTIFIERS_H
+#define _LINUX_PANIC_NOTIFIERS_H
+
+#include <linux/notifier.h>
+#include <linux/types.h>
+
+extern struct atomic_notifier_head panic_notifier_list;
+
+extern bool crash_kexec_post_notifiers;
+
+#endif	/* _LINUX_PANIC_NOTIFIERS_H */
--- a/include/linux/thread_info.h~kernelh-split-out-panic-and-oops-helpers
+++ a/include/linux/thread_info.h
@@ -9,6 +9,7 @@
 #define _LINUX_THREAD_INFO_H
 
 #include <linux/types.h>
+#include <linux/limits.h>
 #include <linux/bug.h>
 #include <linux/restart_block.h>
 #include <linux/errno.h>
--- a/kernel/hung_task.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/hung_task.c
@@ -15,6 +15,7 @@
 #include <linux/kthread.h>
 #include <linux/lockdep.h>
 #include <linux/export.h>
+#include <linux/panic_notifier.h>
 #include <linux/sysctl.h>
 #include <linux/suspend.h>
 #include <linux/utsname.h>
--- a/kernel/kexec_core.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/kexec_core.c
@@ -26,6 +26,7 @@
 #include <linux/suspend.h>
 #include <linux/device.h>
 #include <linux/freezer.h>
+#include <linux/panic_notifier.h>
 #include <linux/pm.h>
 #include <linux/cpu.h>
 #include <linux/uaccess.h>
--- a/kernel/panic.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/kexec.h>
+#include <linux/panic_notifier.h>
 #include <linux/sched.h>
 #include <linux/sysrq.h>
 #include <linux/init.h>
--- a/kernel/rcu/tree.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/rcu/tree.c
@@ -32,6 +32,8 @@
 #include <linux/export.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
+#include <linux/panic.h>
+#include <linux/panic_notifier.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
--- a/kernel/sysctl.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/sysctl.c
@@ -27,6 +27,7 @@
 #include <linux/sysctl.h>
 #include <linux/bitmap.h>
 #include <linux/signal.h>
+#include <linux/panic.h>
 #include <linux/printk.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
--- a/kernel/trace/trace.c~kernelh-split-out-panic-and-oops-helpers
+++ a/kernel/trace/trace.c
@@ -39,6 +39,7 @@
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
+#include <linux/panic_notifier.h>
 #include <linux/poll.h>
 #include <linux/nmi.h>
 #include <linux/fs.h>
_
