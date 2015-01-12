From: akpm@linux-foundation.org
Subject: + sysrq-convert-printk-to-pr_-equivalent.patch added to -mm tree
Date: Mon, 12 Jan 2015 15:59:59 -0800
Message-ID: <54b45fff.zCYT7D6NYb1w+CLJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbAMAAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:00:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysrq: convert printk to pr_* equivalent
has been added to the -mm tree.  Its filename is
     sysrq-convert-printk-to-pr_-equivalent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysrq-convert-printk-to-pr_-equivalent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysrq-convert-printk-to-pr_-equivalent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: sysrq: convert printk to pr_* equivalent

While touching this area let's convert printk to pr_*.  This also makes
the printing of continuation lines done properly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/tty/sysrq.c~sysrq-convert-printk-to-pr_-equivalent drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~sysrq-convert-printk-to-pr_-equivalent
+++ a/drivers/tty/sysrq.c
@@ -90,7 +90,7 @@ static void sysrq_handle_loglevel(int ke
 
 	i = key - '0';
 	console_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
-	printk("Loglevel set to %d\n", i);
+	pr_info("Loglevel set to %d\n", i);
 	console_loglevel = i;
 }
 static struct sysrq_key_op sysrq_loglevel_op = {
@@ -220,7 +220,7 @@ static void showacpu(void *dummy)
 		return;
 
 	spin_lock_irqsave(&show_lock, flags);
-	printk(KERN_INFO "CPU%d:\n", smp_processor_id());
+	pr_info("CPU%d:\n", smp_processor_id());
 	show_stack(NULL, NULL);
 	spin_unlock_irqrestore(&show_lock, flags);
 }
@@ -243,7 +243,7 @@ static void sysrq_handle_showallcpus(int
 		struct pt_regs *regs = get_irq_regs();
 
 		if (regs) {
-			printk(KERN_INFO "CPU%d:\n", smp_processor_id());
+			pr_info("CPU%d:\n", smp_processor_id());
 			show_regs(regs);
 		}
 		schedule_work(&sysrq_showallcpus);
@@ -522,7 +522,7 @@ void __handle_sysrq(int key, bool check_
 	 */
 	orig_log_level = console_loglevel;
 	console_loglevel = CONSOLE_LOGLEVEL_DEFAULT;
-	printk(KERN_INFO "SysRq : ");
+	pr_info("SysRq : ");
 
         op_p = __sysrq_get_key_op(key);
         if (op_p) {
@@ -531,14 +531,14 @@ void __handle_sysrq(int key, bool check_
 		 * should not) and is the invoked operation enabled?
 		 */
 		if (!check_mask || sysrq_on_mask(op_p->enable_mask)) {
-			printk("%s\n", op_p->action_msg);
+			pr_cont("%s\n", op_p->action_msg);
 			console_loglevel = orig_log_level;
 			op_p->handler(key);
 		} else {
-			printk("This sysrq operation is disabled.\n");
+			pr_cont("This sysrq operation is disabled.\n");
 		}
 	} else {
-		printk("HELP : ");
+		pr_cont("HELP : ");
 		/* Only print the help msg once per handler */
 		for (i = 0; i < ARRAY_SIZE(sysrq_key_table); i++) {
 			if (sysrq_key_table[i]) {
@@ -549,10 +549,10 @@ void __handle_sysrq(int key, bool check_
 					;
 				if (j != i)
 					continue;
-				printk("%s ", sysrq_key_table[i]->help_msg);
+				pr_cont("%s ", sysrq_key_table[i]->help_msg);
 			}
 		}
-		printk("\n");
+		pr_cont("\n");
 		console_loglevel = orig_log_level;
 	}
 	rcu_read_unlock();
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
vmscan-per-memory-cgroup-slab-shrinkers-fix.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

