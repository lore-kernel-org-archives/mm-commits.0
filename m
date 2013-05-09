From: akpm@linux-foundation.org
Subject: [to-be-updated] reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2.patch removed from -mm tree
Date: Thu, 09 May 2013 13:52:05 -0700
Message-ID: <20130509205205.8CC145A4282@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:33025 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3EIUwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:52:08 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so358200qab.2
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:52:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gxt@mprc.pku.edu.cn, holt@sgi.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2
has been removed from the -mm tree.  Its filename was
     reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2

add missing breaks to reboot_setup(), per rmk

Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/reboot.c~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2 kernel/reboot.c
--- a/kernel/reboot.c~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2
+++ a/kernel/reboot.c
@@ -403,10 +403,13 @@ static int __init reboot_setup(char *str
 #else
 		case 's':
 			reboot_mode = REBOOT_WARM;
+			break;
 		case 'h':
 			reboot_mode = REBOOT_COLD;
+			break;
 		case 'g':
 			reboot_mode = REBOOT_GPIO;
+			break;
 #endif
 
 		case 'b':
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
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

