From: akpm@linux-foundation.org
Subject: + memcg-use-new-logic-for-page-stat-accounting-fix.patch added to -mm tree
Date: Fri, 17 Feb 2012 13:45:57 -0800
Message-ID: <20120217214557.EECF5A01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:34425 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2BQVp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 17 Feb 2012 16:45:59 -0500
Received: by mail-ww0-f74.google.com with SMTP id ds12so132991wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2012 13:45:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: memcg-use-new-logic-for-page-stat-accounting-fix
has been added to the -mm tree.  Its filename is
     memcg-use-new-logic-for-page-stat-accounting-fix.patch

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
Subject: memcg-use-new-logic-for-page-stat-accounting-fix

s/lock/locked/

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   18 +++++++++---------
 mm/memcontrol.c            |    8 +++-----
 2 files changed, 12 insertions(+), 14 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-use-new-logic-for-page-stat-accounting-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-use-new-logic-for-page-stat-accounting-fix
+++ a/include/linux/memcontrol.h
@@ -141,27 +141,27 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
-void __mem_cgroup_begin_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags);
+void __mem_cgroup_begin_update_page_stat(struct page *page, bool *locked,
+					 unsigned long *flags);
 
 static inline void mem_cgroup_begin_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags)
+					bool *locked, unsigned long *flags)
 {
 	if (mem_cgroup_disabled())
 		return;
 	rcu_read_lock();
-	*lock = false;
-	return __mem_cgroup_begin_update_page_stat(page, lock, flags);
+	*locked = false;
+	return __mem_cgroup_begin_update_page_stat(page, locked, flags);
 }
 
 void __mem_cgroup_end_update_page_stat(struct page *page,
 				unsigned long *flags);
 static inline void mem_cgroup_end_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags)
+					bool *locked, unsigned long *flags)
 {
 	if (mem_cgroup_disabled())
 		return;
-	if (*lock)
+	if (*locked)
 		__mem_cgroup_end_update_page_stat(page, flags);
 	rcu_read_unlock();
 }
@@ -367,12 +367,12 @@ mem_cgroup_print_oom_info(struct mem_cgr
 }
 
 static inline void mem_cgroup_begin_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags)
+					bool *locked, unsigned long *flags)
 {
 }
 
 static inline void mem_cgroup_end_update_page_stat(struct page *page,
-					bool *lock, unsigned long *flags)
+					bool *locked, unsigned long *flags)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-use-new-logic-for-page-stat-accounting-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-new-logic-for-page-stat-accounting-fix
+++ a/mm/memcontrol.c
@@ -1878,7 +1878,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
  */
 
 void __mem_cgroup_begin_update_page_stat(struct page *page,
-				bool *lock, unsigned long *flags)
+				bool *locked, unsigned long *flags)
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
@@ -1902,11 +1902,10 @@ again:
 		move_unlock_mem_cgroup(memcg, flags);
 		goto again;
 	}
-	*lock = true;
+	*locked = true;
 }
 
-void __mem_cgroup_end_update_page_stat(struct page *page,
-				unsigned long *flags)
+void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 
@@ -1918,7 +1917,6 @@ void __mem_cgroup_end_update_page_stat(s
 	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
 }
 
-
 void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_page_stat_item idx, int val)
 {
_
Subject: Subject: memcg-use-new-logic-for-page-stat-accounting-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
ata-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
fs-btrfs-inode-mapc-fix-warnings.patch
hpet-factor-timer-allocate-from-open.patch
thermal-thermal_sys-fix-build-warning.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
slab-introduce-kmalloc_array.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
posix_types-remove-fd_set-macros-checkpatch-fixes.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-checkpatch-fixes.patch
fs-proc-namespacesc-prevent-crash-when-ns_entries-is-empty.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

