From: akpm@osdl.org
Subject: - sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:49 -0800
Message-ID: <200612230753.kBN7rnZn010160@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49723 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbWLWHy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, mingo@elte.hu, stable@kernel.org, suresh.b.siddha@intel.com, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: remove __cpuinitdata anotation to cpu_isolated_map
has been removed from the -mm tree.  Its filename was
     sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: remove __cpuinitdata anotation to cpu_isolated_map
From: Tim Chen <tim.c.chen@linux.intel.com>

The structure cpu_isolated_map is used not only during initialization.
Multi-core scheduler configuration changes and exclusive cpusets
use this during run time.  During setting of sched_mc_power_savings
 policy, this structure is accessed to update sched_domains.

Signed-off-by: Tim Chen <tim.c.chen@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map kernel/sched.c
--- a/kernel/sched.c~sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map
+++ a/kernel/sched.c
@@ -5610,7 +5610,7 @@ static void cpu_attach_domain(struct sch
 }
 
 /* cpus with isolated domains */
-static cpumask_t __cpuinitdata cpu_isolated_map = CPU_MASK_NONE;
+static cpumask_t cpu_isolated_map = CPU_MASK_NONE;
 
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are

origin.patch

