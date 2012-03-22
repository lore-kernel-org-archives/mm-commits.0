From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrolc-s-stealed-stolen.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:20:04 -0700
Message-ID: <20120322202004.4B79AA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39689 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759235Ab2CVUUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:20:05 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so62245qab.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:20:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: s/stealed/stolen/
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-s-stealed-stolen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memcontrol.c: s/stealed/stolen/

A grammatical fix.

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-s-stealed-stolen mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-s-stealed-stolen
+++ a/mm/memcontrol.c
@@ -1332,8 +1332,8 @@ static void mem_cgroup_end_move(struct m
 /*
  * 2 routines for checking "mem" is under move_account() or not.
  *
- * mem_cgroup_stealed() - checking a cgroup is mc.from or not. This is used
- *			  for avoiding race in accounting. If true,
+ * mem_cgroup_stolen() -  checking whether a cgroup is mc.from or not. This
+ *			  is used for avoiding races in accounting.  If true,
  *			  pc->mem_cgroup may be overwritten.
  *
  * mem_cgroup_under_move() - checking a cgroup is mc.from or mc.to or
@@ -1341,7 +1341,7 @@ static void mem_cgroup_end_move(struct m
  *			  waiting at hith-memory prressure caused by "move".
  */
 
-static bool mem_cgroup_stealed(struct mem_cgroup *memcg)
+static bool mem_cgroup_stolen(struct mem_cgroup *memcg)
 {
 	VM_BUG_ON(!rcu_read_lock_held());
 	return atomic_read(&memcg->moving_account) > 0;
@@ -1389,7 +1389,7 @@ static bool mem_cgroup_wait_acct_move(st
  * Take this lock when
  * - a code tries to modify page's memcg while it's USED.
  * - a code tries to modify page state accounting in a memcg.
- * see mem_cgroup_stealed(), too.
+ * see mem_cgroup_stolen(), too.
  */
 static void move_lock_mem_cgroup(struct mem_cgroup *memcg,
 				  unsigned long *flags)
@@ -1932,9 +1932,9 @@ again:
 	 * If this memory cgroup is not under account moving, we don't
 	 * need to take move_lock_page_cgroup(). Because we already hold
 	 * rcu_read_lock(), any calls to move_account will be delayed until
-	 * rcu_read_unlock() if mem_cgroup_stealed() == true.
+	 * rcu_read_unlock() if mem_cgroup_stolen() == true.
 	 */
-	if (!mem_cgroup_stealed(memcg))
+	if (!mem_cgroup_stolen(memcg))
 		return;
 
 	move_lock_mem_cgroup(memcg, flags);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-mfd-twl-corec-wtf-isnt-this-fixed-yet.patch
drivers-mfd-twl-corec-unbork.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
drivers-platform-x86-samsung-laptopc-fix-build.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
percpu-remove-percpu_xxx-functions-fix.patch
thermal-thermal_sys-fix-build-warning.patch
thermal-add-support-for-thermal-sensor-present-on-spear13xx-machines.patch
net-netfilter-nfnetlink_acctc-use-linux-atomich.patch
sched-fix-compiler-warning-about-declared-inline-after-use.patch
brlocks-lglocks-cleanups.patch
simple_open-automatically-convert-to-simple_open-checkpatch-fixes.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions-fix.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
arch-powerpc-platforms-pseries-eeh_eventc-slightly-fix-set_current_state-wart.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
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
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
selftests-makefile-make-run_tests-depend-on-all.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

