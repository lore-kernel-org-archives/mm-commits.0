From: akpm@linux-foundation.org
Subject: - cpuacct-export-percpu-cpuacct-cgroup-stats.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:19:17 -0800
Message-ID: <200812291919.mBTJJH1V031553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170AbYL2TUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:20:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpuacct: export percpu cpuacct cgroup stats
has been removed from the -mm tree.  Its filename was
     cpuacct-export-percpu-cpuacct-cgroup-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuacct: export percpu cpuacct cgroup stats
From: Ken Chen <kenchen@google.com>

Export per-cpu CPU cycle usage for a given cpuacct cgroup.  There is a
need for a user space monitor daemon to track group CPU usage on per-cpu
base.  It is also useful for monitoring CFS load balancer behavior by
tracking per CPU group usage.

Signed-off-by: Ken Chen <kenchen@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN kernel/sched.c~cpuacct-export-percpu-cpuacct-cgroup-stats kernel/sched.c
--- a/kernel/sched.c~cpuacct-export-percpu-cpuacct-cgroup-stats
+++ a/kernel/sched.c
@@ -9458,12 +9458,32 @@ out:
 	return err;
 }
 
+static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				   struct seq_file *m)
+{
+	struct cpuacct *ca = cgroup_ca(cgroup);
+	u64 percpu;
+	int i;
+
+	for_each_present_cpu(i) {
+		percpu = cpuacct_cpuusage_read(ca, i);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
 		.read_u64 = cpuusage_read,
 		.write_u64 = cpuusage_write,
 	},
+	{
+		.name = "usage_percpu",
+		.read_seq_string = cpuacct_percpu_seq_read,
+	},
+
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
linux-next.patch
hugetlb-unsigned-ret-cannot-be-negative.patch

