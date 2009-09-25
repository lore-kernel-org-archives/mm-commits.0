From: akpm@linux-foundation.org
Subject: + sparc32-convert-to-asm-generic-hardirqh-fix.patch added to -mm tree
Date: Fri, 25 Sep 2009 15:25:06 -0700
Message-ID: <200909252225.n8PMP6XQ012579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbZIYWZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 18:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, hch@lst.de, sam@ravnborg.org


The patch titled
     sparc32-convert-to-asm-generic-hardirqh-fix
has been added to the -mm tree.  Its filename is
     sparc32-convert-to-asm-generic-hardirqh-fix.patch

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
Subject: sparc32-convert-to-asm-generic-hardirqh-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from include/asm-generic/hardirq.h:6,
                 from /usr/src/devel/arch/sparc/include/asm/hardirq_32.h:11,
                 from /usr/src/devel/arch/sparc/include/asm/hardirq.h:6,
                 from include/linux/hardirq.h:10,
                 from include/linux/interrupt.h:12,
                 from /usr/src/devel/arch/sparc/include/asm/irq_32.h:9,
                 from /usr/src/devel/arch/sparc/include/asm/irq.h:6,
                 from include/linux/nmi.h:8,
                 from kernel/sched.c:31:
include/linux/irq.h:216: error: 'NR_IRQS' undeclared here (not in a function)

Cc: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/irq_32.h |    4 ++--
 sparc/include/asm/irq_64.h      |    0 
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sparc/include/asm/irq_32.h~sparc32-convert-to-asm-generic-hardirqh-fix arch/sparc/include/asm/irq_32.h
--- a/arch/sparc/include/asm/irq_32.h~sparc32-convert-to-asm-generic-hardirqh-fix
+++ a/arch/sparc/include/asm/irq_32.h
@@ -6,10 +6,10 @@
 #ifndef _SPARC_IRQ_H
 #define _SPARC_IRQ_H
 
-#include <linux/interrupt.h>
-
 #define NR_IRQS    16
 
+#include <linux/interrupt.h>
+
 #define irq_canonicalize(irq)	(irq)
 
 extern void __init init_IRQ(void);
diff -puN arch/sparc/include/asm/irq_64.h~sparc32-convert-to-asm-generic-hardirqh-fix arch/sparc/include/asm/irq_64.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
sparc32-convert-to-asm-generic-hardirqh-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-input-inputc-fix-config_pm=n-warning.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

