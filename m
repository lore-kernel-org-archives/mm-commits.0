From: akpm@linux-foundation.org
Subject: [folded-merged]
 cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix.patch removed from -mm tree
Date: Mon, 20 May 2013 13:14:00 -0700
Message-ID: <519a8408.Vs4/+yUoYBW24WfK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab3ETUOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 May 2013 16:14:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, stable@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com, shawn.guo@linaro.org, rja@sgi.com, mingo@elte.hu, linux@arm.linux.org.uk, hpa@zytor.com, holt@sgi.com, gxt@mprc.pku.edu.cn, akpm@linux-foundation.org

Subject: [folded-merged] cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,gxt@mprc.pku.edu.cn,holt@sgi.com,hpa@zytor.com,linux@arm.linux.org.uk,mingo@elte.hu,rja@sgi.com,shawn.guo@linaro.org,srivatsa.bhat@linux.vnet.ibm.com,stable@vger.kernel.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 20 May 2013 13:14:00 -0700


The patch titled
     Subject: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix
has been removed from the -mm tree.  Its filename was
     cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix.patch

This patch was dropped because it was folded into cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix

a pox on macros, for the 1000th time

Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN include/linux/cpu.h~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix include/linux/cpu.h
--- a/include/linux/cpu.h~cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix
+++ a/include/linux/cpu.h
@@ -173,8 +173,13 @@ static inline void cpu_maps_update_done(
 extern void cpu_hotplug_enable(void);
 extern void cpu_hotplug_disable(void);
 #else
-#define cpu_hotplug_enable()	do { } while (0)
-#define cpu_hotplug_disable()	do { } while (0)
+static inline void cpu_hotplug_enable(void)
+{
+}
+
+static inline void cpu_hotplug_disable(void)
+{
+}
 #endif
 
 extern struct bus_type cpu_subsys;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
revert-selftest-add-simple-test-for-soft-dirty-bit.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-prep-work-for-batch-completion-fix-4.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

