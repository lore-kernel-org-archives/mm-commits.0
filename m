From: akpm@linux-foundation.org
Subject: + memcg-add-mlock-statistic-in-memorystat-fix.patch added to -mm tree
Date: Wed, 18 Apr 2012 16:33:41 -0700
Message-ID: <20120418233341.D2FD2A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35113 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2DRXdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 19:33:43 -0400
Received: by qcsp5 with SMTP id p5so918593qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 16:33:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dan.magenheimer@oracle.com, dhillf@gmail.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, riel@redhat.com, yinghan@google.com


The patch titled
     Subject: memcg-add-mlock-statistic-in-memorystat-fix
has been added to the -mm tree.  Its filename is
     memcg-add-mlock-statistic-in-memorystat-fix.patch

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
Subject: memcg-add-mlock-statistic-in-memorystat-fix

tweak comments

Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ++--
 mm/mlock.c      |    6 +++---
 mm/page_alloc.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/internal.h~memcg-add-mlock-statistic-in-memorystat-fix mm/internal.h
--- a/mm/internal.h~memcg-add-mlock-statistic-in-memorystat-fix
+++ a/mm/internal.h
@@ -188,8 +188,8 @@ static inline void mlock_migrate_page(st
 {
 	/*
 	 * Here we are supposed to update the page memcg's mlock stat and the
-	 * newpage memcgs' mlock. Since the page and newpage are always being
-	 * charged to the same memcg, so no need.
+	 * newpage memcgs' mlock. Since the two pages are always being charged
+	 * to the same memcg there is no need for this.
 	 */
 	if (TestClearPageMlocked(page)) {
 		unsigned long flags;
diff -puN mm/mlock.c~memcg-add-mlock-statistic-in-memorystat-fix mm/mlock.c
--- a/mm/mlock.c~memcg-add-mlock-statistic-in-memorystat-fix
+++ a/mm/mlock.c
@@ -49,9 +49,9 @@ EXPORT_SYMBOL(can_do_mlock);
  */
 
 /*
- *  LRU accounting for clear_page_mlock()
- *  Make sure the caller calls mem_cgroup_begin[end]_update_page_stat,
- *  otherwise it will be race between "move" and "page stat accounting".
+ * LRU accounting for clear_page_mlock()
+ * The caller must use mem_cgroup_begin[end]_update_page_stat to prevent a race
+ * between "move" and "page stat accounting".
  */
 void __clear_page_mlock(struct page *page)
 {
diff -puN mm/page_alloc.c~memcg-add-mlock-statistic-in-memorystat-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memcg-add-mlock-statistic-in-memorystat-fix
+++ a/mm/page_alloc.c
@@ -610,8 +610,8 @@ out:
  * Page should not be on lru, so no need to fix that up.
  * free_pages_check() will verify...
  *
- * Make sure the caller calls mem_cgroup_begin[end]_update_page_stat,
- * otherwise it will be race between "move" and "page stat accounting".
+ * The caller must use mem_cgroup_begin[end]_update_page_stat() to prevent a
+ * race between "move" and "page stat accounting".
  */
 static inline void free_page_mlock(struct page *page)
 {
_
Subject: Subject: memcg-add-mlock-statistic-in-memorystat-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-ledtrig-timer-trigger_data-allocation-fix-fix.patch
lib-string_helpersc-make-arrays-static.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

