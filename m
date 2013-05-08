From: akpm@linux-foundation.org
Subject: + reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch added to -mm tree
Date: Wed, 08 May 2013 13:55:48 -0700
Message-ID: <20130508205548.AF02F31C15D@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:55981 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3EHUzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 16:55:49 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so224221qen.2
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 13:55:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, holt@sgi.com


The patch titled
     Subject: reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix
has been added to the -mm tree.  Its filename is
     reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch

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
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch
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

