Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094B7C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C8D2177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781398;
	bh=wr7hbxBJUgPqvbbeDGCkgzNhXXmdkej7C4QWaoE1IlY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=isKw/Kt5D1yGlfHUC+FA/ak+Dq7gpB91d5HTm/uNQc521eocmqLqMshfucvH6cVkF
	 WoNnAjbAZUYooQwbwij/pboW2xwFspmyXOGN8+ACRER7AdcMVWw/cH/IgNtvyzbK5q
	 Kj6M3Jl/yCU30MZHJ2sq4EJkqqEIyMxvtTpEgkk8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGGXS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGXS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:23:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40D60221E5;
        Fri,  7 Aug 2020 06:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781397;
        bh=wr7hbxBJUgPqvbbeDGCkgzNhXXmdkej7C4QWaoE1IlY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=b54NoXL7RJdVXY0fJ6QJtZQfNWAjI65DuPgvLMwsTVei9cfLft9Ty/7ZDNv16rcJ7
         ziwlrjQMImNYds9Hm8PCW5/tI3+VJwaY2inHcYhv044/VLrwpvQL3K5TiNPyDWwbdA
         5ilywuuZk1g5BLdwPPafi1C7mSYl//sbiLi/2n7c=
Date:   Thu, 06 Aug 2020 23:23:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andi.kleen@intel.com, cai@lca.pw,
        cl@linux.com, dave.hansen@intel.com, dennis@kernel.org,
        feng.tang@intel.com, haiyangz@microsoft.com, hannes@cmpxchg.org,
        keescook@chromium.org, kys@microsoft.com, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        rong.a.chen@intel.com, tim.c.chen@intel.com, tj@kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 108/163] mm: adjust vm_committed_as_batch
 according to vm overcommit policy
Message-ID: <20200807062315.nuQITHzCh%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>
Subject: mm: adjust vm_committed_as_batch according to vm overcommit policy

When checking a performance change for will-it-scale scalability mmap test
[1], we found very high lock contention for spinlock of percpu counter
'vm_committed_as':

    94.14%     0.35%  [kernel.kallsyms]         [k] _raw_spin_lock_irqsave
    48.21% _raw_spin_lock_irqsave;percpu_counter_add_batch;__vm_enough_memory;mmap_region;do_mmap;
    45.91% _raw_spin_lock_irqsave;percpu_counter_add_batch;__do_munmap;

Actually this heavy lock contention is not always necessary.  The
'vm_committed_as' needs to be very precise when the strict
OVERCOMMIT_NEVER policy is set, which requires a rather small batch number
for the percpu counter.

So keep 'batch' number unchanged for strict OVERCOMMIT_NEVER policy, and
lift it to 64X for OVERCOMMIT_ALWAYS and OVERCOMMIT_GUESS policies.  Also
add a sysctl handler to adjust it when the policy is reconfigured.

Benchmark with the same testcase in [1] shows 53% improvement on a 8C/16T
desktop, and 2097%(20X) on a 4S/72C/144T server.  We tested with test
platforms in 0day (server, desktop and laptop), and 80%+ platforms shows
improvements with that test.  And whether it shows improvements depends on
if the test mmap size is bigger than the batch number computed.

And if the lift is 16X, 1/3 of the platforms will show improvements,
though it should help the mmap/unmap usage generally, as Michal Hocko
mentioned:

: I believe that there are non-synthetic worklaods which would benefit from
: a larger batch.  E.g.  large in memory databases which do large mmaps
: during startups from multiple threads.

[1] https://lore.kernel.org/lkml/20200305062138.GI5972@shao2-debian/

Link: http://lkml.kernel.org/r/1589611660-89854-4-git-send-email-feng.tang@intel.com
Link: http://lkml.kernel.org/r/1592725000-73486-4-git-send-email-feng.tang@intel.com
Link: http://lkml.kernel.org/r/1594389708-60781-5-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Qian Cai <cai@lca.pw>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: kernel test robot <rong.a.chen@intel.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    2 ++
 include/linux/mman.h |    4 ++++
 kernel/sysctl.c      |    2 +-
 mm/mm_init.c         |   20 +++++++++++++++-----
 mm/util.c            |   41 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 63 insertions(+), 6 deletions(-)

--- a/include/linux/mman.h~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/include/linux/mman.h
@@ -57,8 +57,12 @@ extern struct percpu_counter vm_committe
 
 #ifdef CONFIG_SMP
 extern s32 vm_committed_as_batch;
+extern void mm_compute_batch(int overcommit_policy);
 #else
 #define vm_committed_as_batch 0
+static inline void mm_compute_batch(int overcommit_policy)
+{
+}
 #endif
 
 unsigned long vm_memory_committed(void);
--- a/include/linux/mm.h~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/include/linux/mm.h
@@ -206,6 +206,8 @@ int overcommit_ratio_handler(struct ctl_
 		loff_t *);
 int overcommit_kbytes_handler(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
+int overcommit_policy_handler(struct ctl_table *, int, void *, size_t *,
+		loff_t *);
 
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
--- a/kernel/sysctl.c~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/kernel/sysctl.c
@@ -2671,7 +2671,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_overcommit_memory,
 		.maxlen		= sizeof(sysctl_overcommit_memory),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= overcommit_policy_handler,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
--- a/mm/mm_init.c~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/mm/mm_init.c
@@ -13,6 +13,7 @@
 #include <linux/memory.h>
 #include <linux/notifier.h>
 #include <linux/sched.h>
+#include <linux/mman.h>
 #include "internal.h"
 
 #ifdef CONFIG_DEBUG_MEMORY_INIT
@@ -144,14 +145,23 @@ EXPORT_SYMBOL_GPL(mm_kobj);
 #ifdef CONFIG_SMP
 s32 vm_committed_as_batch = 32;
 
-static void __meminit mm_compute_batch(void)
+void mm_compute_batch(int overcommit_policy)
 {
 	u64 memsized_batch;
 	s32 nr = num_present_cpus();
 	s32 batch = max_t(s32, nr*2, 32);
+	unsigned long ram_pages = totalram_pages();
 
-	/* batch size set to 0.4% of (total memory/#cpus), or max int32 */
-	memsized_batch = min_t(u64, (totalram_pages()/nr)/256, 0x7fffffff);
+	/*
+	 * For policy OVERCOMMIT_NEVER, set batch size to 0.4% of
+	 * (total memory/#cpus), and lift it to 25% for other policies
+	 * to easy the possible lock contention for percpu_counter
+	 * vm_committed_as, while the max limit is INT_MAX
+	 */
+	if (overcommit_policy == OVERCOMMIT_NEVER)
+		memsized_batch = min_t(u64, ram_pages/nr/256, INT_MAX);
+	else
+		memsized_batch = min_t(u64, ram_pages/nr/4, INT_MAX);
 
 	vm_committed_as_batch = max_t(s32, memsized_batch, batch);
 }
@@ -162,7 +172,7 @@ static int __meminit mm_compute_batch_no
 	switch (action) {
 	case MEM_ONLINE:
 	case MEM_OFFLINE:
-		mm_compute_batch();
+		mm_compute_batch(sysctl_overcommit_memory);
 	default:
 		break;
 	}
@@ -176,7 +186,7 @@ static struct notifier_block compute_bat
 
 static int __init mm_compute_batch_init(void)
 {
-	mm_compute_batch();
+	mm_compute_batch(sysctl_overcommit_memory);
 	register_hotmemory_notifier(&compute_batch_nb);
 
 	return 0;
--- a/mm/util.c~mm-adjust-vm_committed_as_batch-according-to-vm-overcommit-policy
+++ a/mm/util.c
@@ -746,6 +746,47 @@ int overcommit_ratio_handler(struct ctl_
 	return ret;
 }
 
+static void sync_overcommit_as(struct work_struct *dummy)
+{
+	percpu_counter_sync(&vm_committed_as);
+}
+
+int overcommit_policy_handler(struct ctl_table *table, int write, void *buffer,
+		size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+	int new_policy;
+	int ret;
+
+	/*
+	 * The deviation of sync_overcommit_as could be big with loose policy
+	 * like OVERCOMMIT_ALWAYS/OVERCOMMIT_GUESS. When changing policy to
+	 * strict OVERCOMMIT_NEVER, we need to reduce the deviation to comply
+	 * with the strict "NEVER", and to avoid possible race condtion (even
+	 * though user usually won't too frequently do the switching to policy
+	 * OVERCOMMIT_NEVER), the switch is done in the following order:
+	 *	1. changing the batch
+	 *	2. sync percpu count on each CPU
+	 *	3. switch the policy
+	 */
+	if (write) {
+		t = *table;
+		t.data = &new_policy;
+		ret = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
+		if (ret)
+			return ret;
+
+		mm_compute_batch(new_policy);
+		if (new_policy == OVERCOMMIT_NEVER)
+			schedule_on_each_cpu(sync_overcommit_as);
+		sysctl_overcommit_memory = new_policy;
+	} else {
+		ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	}
+
+	return ret;
+}
+
 int overcommit_kbytes_handler(struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos)
 {
_
