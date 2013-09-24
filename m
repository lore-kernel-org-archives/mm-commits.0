From: akpm@linux-foundation.org
Subject: [folded-merged] watchdog-update-watchdog_tresh-properly-fix.patch removed from -mm tree
Date: Tue, 24 Sep 2013 15:19:56 -0700
Message-ID: <5242100c.D3YlqWNggQmZD8VI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3IXWT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 18:19:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org, mhocko@suse.cz, fweisbec@gmail.com, dzickus@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] watchdog-update-watchdog_tresh-properly-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dzickus@redhat.com,fweisbec@gmail.com,mhocko@suse.cz,mingo@kernel.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 15:19:56 -0700


The patch titled
     Subject: watchdog-update-watchdog_tresh-properly-fix
has been removed from the -mm tree.  Its filename was
     watchdog-update-watchdog_tresh-properly-fix.patch

This patch was dropped because it was folded into watchdog-update-watchdog_tresh-properly.patch

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
kernel-rebootc-re-enable-the-function-of-variable-reboot_default-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

