From: akpm@linux-foundation.org
Subject: + watchdog-update-watchdog_tresh-properly-fix.patch added to -mm
 tree
Date: Wed, 18 Sep 2013 16:23:19 -0700
Message-ID: <523a35e7.tSJAcYQXJnh7kM+y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3IRXXU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 19:23:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org, mhocko@suse.cz, fweisbec@gmail.com, dzickus@redhat.com, akpm@linux-foundation.org

Subject: + watchdog-update-watchdog_tresh-properly-fix.patch added to -mm tree
To: akpm@linux-foundation.org,dzickus@redhat.com,fweisbec@gmail.com,mhocko@suse.cz,mingo@kernel.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 16:23:19 -0700


The patch titled
     Subject: watchdog-update-watchdog_tresh-properly-fix
has been added to the -mm tree.  Its filename is
     watchdog-update-watchdog_tresh-properly-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-update-watchdog_tresh-properly-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-update-watchdog_tresh-properly-fix.patch

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
Subject: watchdog-update-watchdog_tresh-properly-fix

the UP version of __smp_call_function_single ended up in the wrong place

Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/smp.h~watchdog-update-watchdog_tresh-properly-fix include/linux/smp.h
--- a/include/linux/smp.h~watchdog-update-watchdog_tresh-properly-fix
+++ a/include/linux/smp.h
@@ -155,14 +155,14 @@ smp_call_function_any(const struct cpuma
 
 static inline void kick_all_cpus_sync(void) {  }
 
-#endif /* !SMP */
-
 static inline void __smp_call_function_single(int cpuid,
 		struct call_single_data *data, int wait)
 {
 	on_each_cpu(data->func, data->info, wait);
 }
 
+#endif /* !SMP */
+
 /*
  * smp_processor_id(): get the current CPU ID.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly-fix.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-gcov-fsc-use-pr_warn.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

