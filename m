From: akpm@linux-foundation.org
Subject: + timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch added to -mm tree
Date: Fri, 18 Jan 2013 13:40:10 -0800
Message-ID: <20130118223126.AF4EE31C05D@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53559 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3ARWb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Jan 2013 17:31:29 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so309522vcd.5
        for <mm-commits@vger.kernel.org>; Fri, 18 Jan 2013 14:31:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davej@redhat.com, johnstul@us.ibm.com, nzimmer@sgi.com, tglx@linutronix.de


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix
has been added to the -mm tree.  Its filename is
     timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch

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
Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix

kernel/time/timer_list.c: In function 'timer_list_show':
kernel/time/timer_list.c:262: warning: cast to pointer from integer of different size
kernel/time/timer_list.c:267: warning: cast to pointer from integer of different size
kernel/time/timer_list.c: In function 'timer_list_start':
kernel/time/timer_list.c:297: warning: cast to pointer from integer of different size

This code is revolting :(

Cc: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix
+++ a/kernel/time/timer_list.c
@@ -259,12 +259,12 @@ static int timer_list_show(struct seq_fi
 			   HRTIMER_MAX_CLOCK_BASES);
 		SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 		SEQ_printf(m, "\n");
-	} else if (v < (void *)(nr_cpu_ids + 2)) {
+	} else if (v < (void *)(unsigned long)(nr_cpu_ids + 2)) {
 		cpu = (unsigned long)(v - 2);
 		print_cpu(m, cpu, now);
 	}
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-	else if (v == (void *)nr_cpu_ids + 2) {
+	else if (v == (void *)(unsigned long)nr_cpu_ids + 2) {
 		timer_list_show_tickdevices_header(m);
 	} else {
 		cpu = (unsigned long)(v - 3 - nr_cpu_ids);
@@ -306,7 +306,7 @@ static void *timer_list_start(struct seq
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 	if (n == nr_cpu_ids + 1)
-		return (void *) (nr_cpu_ids + 2);
+		return (void *)(unsigned long)(nr_cpu_ids + 2);
 
 	if (n < nr_cpu_ids * 2 + 2) {
 		n -= (nr_cpu_ids + 2);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
aio-smoosh-struct-kiocb-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

