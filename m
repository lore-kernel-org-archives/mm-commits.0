From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch removed from -mm tree
Date: Tue, 12 Aug 2014 13:17:23 -0700
Message-ID: <53ea7653.vd4Oi9AotJyjsI1L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63830 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaHLURY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:17:24 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1316207vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:17:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cpandya@codeaurora.org, hughd@google.com, john.stultz@linaro.org, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2
has been removed from the -mm tree.  Its filename was
     ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2

fix build

Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/ksm.c~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2 mm/ksm.c
--- a/mm/ksm.c~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2
+++ a/mm/ksm.c
@@ -1720,8 +1720,6 @@ static int ksmd_should_run(void)
 
 static int ksm_scan_thread(void *nothing)
 {
-	signed long to;
-
 	set_freezable();
 	set_user_nice(current, 5);
 
@@ -1735,7 +1733,9 @@ static int ksm_scan_thread(void *nothing
 		try_to_freeze();
 
 		if (ksmd_should_run()) {
-			timeout = msecs_to_jiffies(ksm_thread_sleep_millisecs);
+			signed long to;
+
+			to = msecs_to_jiffies(ksm_thread_sleep_millisecs);
 			if (use_deferrable_timer)
 				schedule_timeout_deferrable_interruptible(to);
 			else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

