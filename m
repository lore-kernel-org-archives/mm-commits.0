From: akpm@linux-foundation.org
Subject: [to-be-updated] reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch removed from -mm tree
Date: Thu, 09 May 2013 13:52:02 -0700
Message-ID: <20130509205202.78B335A4282@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:41955 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3EIUwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:52:03 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so334147qcz.2
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:52:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, holt@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix
has been removed from the -mm tree.  Its filename was
     reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix

make the `s' option handling slightly less silly

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

 kernel/reboot.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix Documentation/kernel-parameters.txt
diff -puN arch/arm/kernel/process.c~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix arch/arm/kernel/process.c
diff -puN arch/unicore32/kernel/process.c~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix arch/unicore32/kernel/process.c
diff -puN arch/x86/include/asm/emergency-restart.h~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix arch/x86/include/asm/emergency-restart.h
diff -puN arch/x86/kernel/apic/x2apic_uv_x.c~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix arch/x86/kernel/apic/x2apic_uv_x.c
diff -puN arch/x86/kernel/reboot.c~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix arch/x86/kernel/reboot.c
diff -puN include/linux/reboot.h~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix include/linux/reboot.h
diff -puN kernel/reboot.c~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix kernel/reboot.c
--- a/kernel/reboot.c~reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix
+++ a/kernel/reboot.c
@@ -386,10 +386,11 @@ static int __init reboot_setup(char *str
 
 #ifdef CONFIG_SMP
 		case 's':
-			if (isdigit(*(str+1))) {
-				reboot_cpu = (int) (*(str+1) - '0');
-				if (isdigit(*(str+2)))
-					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
+			if (isdigit(str[1])) {
+				reboot_cpu = str[1] - '0';
+				if (isdigit(str[2]))
+					reboot_cpu = reboot_cpu * 10 +
+							str[2] - '0';
 			}
 			/*
 			 * We will leave sorting out the final value
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
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2.patch
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

