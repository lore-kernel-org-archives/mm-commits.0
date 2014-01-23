From: akpm@linux-foundation.org
Subject: [folded-merged] numa-add-a-sysctl-for-numa_balancing-fix.patch
 removed from -mm tree
Date: Thu, 23 Jan 2014 15:19:53 -0800
Message-ID: <52e1a399.BiM3k16vu4C97pZr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaAWXTy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:19:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, mgorman@suse.de, ak@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] numa-add-a-sysctl-for-numa_balancing-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,ak@linux.intel.com,mgorman@suse.de,mingo@elte.hu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:19:53 -0800


The patch titled
     Subject: numa-add-a-sysctl-for-numa_balancing-fix
has been removed from the -mm tree.  Its filename was
     numa-add-a-sysctl-for-numa_balancing-fix.patch

This patch was dropped because it was folded into numa-add-a-sysctl-for-numa_balancing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: numa-add-a-sysctl-for-numa_balancing-fix

s/sched_numa_balancing/sysctl_numa_balancing/

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/sysctl.h |    2 +-
 kernel/sched/core.c          |    2 +-
 kernel/sysctl.c              |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/sched/sysctl.h~numa-add-a-sysctl-for-numa_balancing-fix include/linux/sched/sysctl.h
--- a/include/linux/sched/sysctl.h~numa-add-a-sysctl-for-numa_balancing-fix
+++ a/include/linux/sched/sysctl.h
@@ -99,7 +99,7 @@ extern int sched_rt_handler(struct ctl_t
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
-extern int sched_numa_balancing(struct ctl_table *table, int write,
+extern int sysctl_numa_balancing(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos);
 
diff -puN kernel/sched/core.c~numa-add-a-sysctl-for-numa_balancing-fix kernel/sched/core.c
--- a/kernel/sched/core.c~numa-add-a-sysctl-for-numa_balancing-fix
+++ a/kernel/sched/core.c
@@ -1772,7 +1772,7 @@ void set_numabalancing_state(bool enable
 #endif /* CONFIG_SCHED_DEBUG */
 
 #ifdef CONFIG_PROC_SYSCTL
-int sched_numa_balancing(struct ctl_table *table, int write,
+int sysctl_numa_balancing(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table t;
diff -puN kernel/sysctl.c~numa-add-a-sysctl-for-numa_balancing-fix kernel/sysctl.c
--- a/kernel/sysctl.c~numa-add-a-sysctl-for-numa_balancing-fix
+++ a/kernel/sysctl.c
@@ -394,7 +394,7 @@ static struct ctl_table kern_table[] = {
 		.data		= NULL, /* filled in by handler */
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= sched_numa_balancing,
+		.proc_handler	= sysctl_numa_balancing,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-print-more-details-for-bad_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
numa-add-a-sysctl-for-numa_balancing.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

