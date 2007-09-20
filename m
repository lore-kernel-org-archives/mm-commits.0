From: akpm@linux-foundation.org
Subject: - net-sched-sch_cbqc-shut-up-uninitialized-variable.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:02 -0700
Message-ID: <200709202115.l8KLF2sI002866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51474 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499AbXITVPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     net/sched/sch_cbq.c: Shut up uninitialized variable warning
has been removed from the -mm tree.  Its filename was
     net-sched-sch_cbqc-shut-up-uninitialized-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/sched/sch_cbq.c: Shut up uninitialized variable warning
From: Satyam Sharma <satyam@infradead.org>

net/sched/sch_cbq.c: In function 'cbq_enqueue':
net/sched/sch_cbq.c:383: warning: 'ret' may be used uninitialized in this function

has been verified to be a bogus case. So let's shut it up.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/sch_cbq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sched/sch_cbq.c~net-sched-sch_cbqc-shut-up-uninitialized-variable net/sched/sch_cbq.c
--- a/net/sched/sch_cbq.c~net-sched-sch_cbqc-shut-up-uninitialized-variable
+++ a/net/sched/sch_cbq.c
@@ -380,7 +380,7 @@ cbq_enqueue(struct sk_buff *skb, struct 
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
 	int len = skb->len;
-	int ret;
+	int uninitialized_var(ret);
 	struct cbq_class *cl = cbq_classify(skb, sch, &ret);
 
 #ifdef CONFIG_NET_CLS_ACT
_

Patches currently in -mm which might be from satyam@infradead.org are

cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-net.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
mpt-fusion-shut-up-uninitialized-variable.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
