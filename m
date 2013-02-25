From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:08 -0800
Message-ID: <20130225204808.A28B25A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:53737 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:11 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so346502yhr.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, handai.szj@taobao.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: convert printk(KERN_FOO) to pr_foo()
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memcontrol.c: convert printk(KERN_FOO) to pr_foo()

Acked-by: Sha Zhengju <handai.szj@taobao.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-convert-printkkern_foo-to-pr_foo mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-convert-printkkern_foo-to-pr_foo
+++ a/mm/memcontrol.c
@@ -1574,7 +1574,7 @@ void mem_cgroup_print_oom_info(struct me
 	}
 	rcu_read_unlock();
 
-	printk(KERN_INFO "Task in %s killed", memcg_name);
+	pr_info("Task in %s killed", memcg_name);
 
 	rcu_read_lock();
 	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
@@ -1587,19 +1587,18 @@ void mem_cgroup_print_oom_info(struct me
 	/*
 	 * Continues from above, so we don't need an KERN_ level
 	 */
-	printk(KERN_CONT " as a result of limit of %s\n", memcg_name);
+	pr_cont(" as a result of limit of %s\n", memcg_name);
 done:
 
-	printk(KERN_INFO "memory: usage %llukB, limit %llukB, failcnt %llu\n",
+	pr_info("memory: usage %llukB, limit %llukB, failcnt %llu\n",
 		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->res, RES_FAILCNT));
-	printk(KERN_INFO "memory+swap: usage %llukB, limit %llukB, "
-		"failcnt %llu\n",
+	pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %llu\n",
 		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
-	printk(KERN_INFO "kmem: usage %llukB, limit %llukB, failcnt %llu\n",
+	pr_info("kmem: usage %llukB, limit %llukB, failcnt %llu\n",
 		res_counter_read_u64(&memcg->kmem, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->kmem, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->kmem, RES_FAILCNT));
@@ -4426,8 +4425,8 @@ void mem_cgroup_print_bad_page(struct pa
 
 	pc = lookup_page_cgroup_used(page);
 	if (pc) {
-		printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
-		       pc, pc->flags, pc->mem_cgroup);
+		pr_alert("pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
+			 pc, pc->flags, pc->mem_cgroup);
 	}
 }
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

