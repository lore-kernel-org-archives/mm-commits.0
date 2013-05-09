From: akpm@linux-foundation.org
Subject: + cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix.patch added to -mm tree
Date: Thu, 09 May 2013 15:02:28 -0700
Message-ID: <20130509220228.E1ECA5A4005@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:62863 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3EIWCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 18:02:30 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so341734yho.4
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 15:02:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gxt@mprc.pku.edu.cn, holt@sgi.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, stable@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix
has been added to the -mm tree.  Its filename is
     cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
ipcsem-fix-semctl-getzcnt-fix.patch
ipcsem-fix-semctl-getncnt-fix.patch
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
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

