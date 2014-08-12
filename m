From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 13:17:21 -0700
Message-ID: <53ea7651.aBfLnWVm6rLCLgD0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:51775 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaHLURW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:17:22 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so1313336yha.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:17:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cpandya@codeaurora.org, hughd@google.com, john.stultz@linaro.org, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix
has been removed from the -mm tree.  Its filename was
     ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix

clean up docs, fix deferrable_timer_store() error handling

Cc: Chintan Pandya <cpandya@codeaurora.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/ksm.txt |   12 ++++++------
 mm/ksm.c                 |    9 +++++----
 2 files changed, 11 insertions(+), 10 deletions(-)

diff -puN Documentation/vm/ksm.txt~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix
+++ a/Documentation/vm/ksm.txt
@@ -88,12 +88,12 @@ pages_unshared   - how many pages unique
 pages_volatile   - how many pages changing too fast to be placed in a tree
 full_scans       - how many times all mergeable areas have been scanned
 deferrable_timer - whether to use deferrable timers or not
-                 e.g. "echo 1 > /sys/kernel/mm/ksm/deferrable_timer"
-                 Default: 0 (means, we are not using deferrable timers. Users
-		 might want to set deferrable_timer option if they donot want
-		 ksm thread to wakeup CPU to carryout ksm activities thus
-		 gaining on battery while compromising slightly on memory
-		 that could have been saved.)
+                   e.g. "echo 1 > /sys/kernel/mm/ksm/deferrable_timer"
+                   Default: 0 (means, we are not using deferrable timers. Users
+		   might want to set deferrable_timer option if they donot want
+		   ksm thread to wakeup CPU to carryout ksm activities thus
+		   gaining on battery while compromising slightly on memory
+		   that could have been saved.)
 
 A high ratio of pages_sharing to pages_shared indicates good sharing, but
 a high ratio of pages_unshared to pages_sharing indicates wasted effort.
diff -puN mm/ksm.c~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix mm/ksm.c
--- a/mm/ksm.c~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix
+++ a/mm/ksm.c
@@ -2202,10 +2202,11 @@ static ssize_t deferrable_timer_store(st
 	int err;
 
 	err = kstrtoul(buf, 10, &enable);
-
-	if (enable == 0 || enable == 1)
-		use_deferrable_timer = enable;
-
+	if (err < 0)
+		return err;
+	if (enable >= 1)
+		return -EINVAL;
+	use_deferrable_timer = enable;
 	return count;
 }
 KSM_ATTR(deferrable_timer);
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
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

