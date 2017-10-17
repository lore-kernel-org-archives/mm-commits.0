From: akpm@linux-foundation.org
Subject: [folded-merged] mm-sysctl-make-numa-stats-configurable-fix.patch
 removed from -mm tree
Date: Tue, 17 Oct 2017 15:45:42 -0700
Message-ID: <59e68816.qzUU9nVzltIQKFVe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751935AbdJQWpo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aaron.lu@intel.com, andi.kleen@intel.com, bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, keescook@chromium.org, kemi.wang@intel.com, mcgrof@kernel.org, mgorman@techsingularity.net, mhocko@suse.com, tim.c.chen@intel.com, vbabka@suse.cz, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-sysctl-make-numa-stats-configurable-fix
has been removed from the -mm tree.  Its filename was
     mm-sysctl-make-numa-stats-configurable-fix.patch

This patch was dropped because it was folded into mm-sysctl-make-numa-stats-configurable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-sysctl-make-numa-stats-configurable-fix

- tweak documentation

- move advisory message from start_kernel() into mm_init() (I'm not sure
  we really need this message)

- use strcasecmp() in __parse_vm_numa_stats_mode()

- clean up coding style amd nessages in sysctl_vm_numa_stats_mode_handler()

Cc: Aaron Lu <aaron.lu@intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Christopher Lameter <cl@linux.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kemi Wang <kemi.wang@intel.com>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ying Huang <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   15 ++++++-------
 init/main.c                 |    6 ++---
 mm/vmstat.c                 |   39 +++++++++++++++-------------------
 3 files changed, 29 insertions(+), 31 deletions(-)

diff -puN Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable-fix
+++ a/Documentation/sysctl/vm.txt
@@ -853,7 +853,7 @@ ten times more freeable objects than the
 
 numa_stats_mode
 
-This interface allows numa statistics configurable.
+This interface allows runtime configuration or numa statistics.
 
 When page allocation performance becomes a bottleneck and you can tolerate
 some possible tool breakage and decreased numa counter precision, you can
@@ -864,13 +864,14 @@ When page allocation performance is not
 tooling to work, you can do:
 	echo [S|s]trict > /proc/sys/vm/numa_stat_mode
 
-We recommend automatic detection of numa statistics by system, because numa
-statistics does not affect system's decision and it is very rarely
-consumed. you can do:
+We recommend automatic detection of numa statistics by system, because
+numa statistics do not affect system decisions and it is very rarely
+consumed.  In this case you can do:
 	echo [A|a]uto > /proc/sys/vm/numa_stats_mode
-This is also system default configuration, with this default setting, numa
-counters update is skipped unless the counter is *read* by users at least
-once.
+
+This is the system default configuration.  With this default setting, numa
+counter updates are skipped until the counter is *read* by userspace at
+least once.
 
 ==============================================================
 
diff -puN init/main.c~mm-sysctl-make-numa-stats-configurable-fix init/main.c
--- a/init/main.c~mm-sysctl-make-numa-stats-configurable-fix
+++ a/init/main.c
@@ -504,6 +504,9 @@ static void __init mm_init(void)
 	pgtable_init();
 	vmalloc_init();
 	ioremap_huge_init();
+#ifdef CONFIG_NUMA
+	pr_info("vmstat: NUMA stat updates are skipped unless they have been used\n");
+#endif
 }
 
 asmlinkage __visible void __init start_kernel(void)
@@ -567,9 +570,6 @@ asmlinkage __visible void __init start_k
 	sort_main_extable();
 	trap_init();
 	mm_init();
-#ifdef CONFIG_NUMA
-	pr_info("vmstat: NUMA stats is skipped unless it has been consumed\n");
-#endif
 
 	ftrace_init();
 
diff -puN mm/vmstat.c~mm-sysctl-make-numa-stats-configurable-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-sysctl-make-numa-stats-configurable-fix
+++ a/mm/vmstat.c
@@ -40,13 +40,11 @@ static DEFINE_MUTEX(vm_numa_stats_mode_l
 
 static int __parse_vm_numa_stats_mode(char *s)
 {
-	const char *str = s;
-
-	if (strcmp(str, "auto") == 0 || strcmp(str, "Auto") == 0)
+	if (strcasecmp(s, "auto"))
 		vm_numa_stats_mode = VM_NUMA_STAT_AUTO_MODE;
-	else if (strcmp(str, "strict") == 0 || strcmp(str, "Strict") == 0)
+	else if (strcasecmp(s, "strict") == 0)
 		vm_numa_stats_mode = VM_NUMA_STAT_STRICT_MODE;
-	else if (strcmp(str, "coarse") == 0 || strcmp(str, "Coarse") == 0)
+	else if (strcasecmp(s, "coarse"))
 		vm_numa_stats_mode = VM_NUMA_STAT_COARSE_MODE;
 	else {
 		pr_warn("Ignoring invalid vm_numa_stats_mode value: %s\n", s);
@@ -86,30 +84,29 @@ int sysctl_vm_numa_stats_mode_handler(st
 			/* no change */
 			mutex_unlock(&vm_numa_stats_mode_lock);
 			return 0;
-		} else if (vm_numa_stats_mode == VM_NUMA_STAT_AUTO_MODE)
+		} else if (vm_numa_stats_mode == VM_NUMA_STAT_AUTO_MODE) {
 			/*
-			 * Keep the branch selection in last time when numa stats
-			 * is changed to auto mode.
+			 * Keep the branch selection in last time when numa
+			 * stats is changed to auto mode.
 			 */
-			pr_info("numa stats changes from %s mode to auto mode\n",
-					vm_numa_stats_mode_name[oldval]);
-		else if (vm_numa_stats_mode == VM_NUMA_STAT_STRICT_MODE) {
+			pr_info("numa stats changed from %s to auto mode\n",
+				 vm_numa_stats_mode_name[oldval]);
+		} else if (vm_numa_stats_mode == VM_NUMA_STAT_STRICT_MODE) {
 			static_branch_enable(&vm_numa_stats_mode_key);
-			pr_info("numa stats changes from %s mode to strict mode\n",
-					vm_numa_stats_mode_name[oldval]);
+			pr_info("numa stats changes from %s to strict mode\n",
+				 vm_numa_stats_mode_name[oldval]);
 		} else if (vm_numa_stats_mode == VM_NUMA_STAT_COARSE_MODE) {
 			static_branch_disable(&vm_numa_stats_mode_key);
 			/*
-			 * Invalidate numa counters when vmstat mode is set to coarse
-			 * mode, because users can't tell the difference between the
-			 * dead state and when allocator activity is quiet once
-			 * zone_statistics() is turned off.
+			 * Invalidate numa counters when vmstat mode is set to
+			 * coarse mode, because users can't tell the difference
+			 * between the dead state and when allocator activity is
+			 * quiet once zone_statistics() is turned off.
 			 */
 			invalid_numa_statistics();
-			pr_info("numa stats changes from %s mode to coarse mode\n",
-					vm_numa_stats_mode_name[oldval]);
-		} else
-			pr_warn("invalid vm_numa_stats_mode:%d\n", vm_numa_stats_mode);
+			pr_info("numa stats changes from %s to coarse mode\n",
+				 vm_numa_stats_mode_name[oldval]);
+		}
 	}
 
 	mutex_unlock(&vm_numa_stats_mode_lock);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-sysctl-make-numa-stats-configurable.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

