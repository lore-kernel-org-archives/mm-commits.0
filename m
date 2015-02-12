From: akpm@linux-foundation.org
Subject: [merged] sysrq-convert-printk-to-pr_-equivalent.patch removed
 from -mm tree
Date: Thu, 12 Feb 2015 11:37:08 -0800
Message-ID: <54dd00e4.Hy9kuJmDbjC3i5tD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbbBLThJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:37:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, oleg@redhat.com, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysrq: convert printk to pr_* equivalent
has been removed from the -mm tree.  Its filename was
     sysrq-convert-printk-to-pr_-equivalent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

