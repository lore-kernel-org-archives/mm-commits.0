From: akpm@linux-foundation.org
Subject: +
 ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
 added to -mm tree
Date: Tue, 29 Jul 2014 15:03:24 -0700
Message-ID: <53d81a2c.ABVeeNRag081PAmX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:49177 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbaG2WDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jul 2014 18:03:25 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so138213ieb.0
        for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2014 15:03:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cpandya@codeaurora.org, hughd@google.com, john.stultz@linaro.org, mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix
has been added to the -mm tree.  Its filename is
     ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch

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

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
mm-debugfs-move-rounddown_pow_of_two-out-from-do_fault-path-fix.patch
mm-fix-filemapc-pagecache_get_page-kernel-doc-warnings-fix-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

