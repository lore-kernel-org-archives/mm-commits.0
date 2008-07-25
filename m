From: akpm@linux-foundation.org
Subject: - cpuset-dont-pass-empty-cpumasks-to-partition_sched_domains.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:09 -0700
Message-ID: <200807252259.m6PMx94E003356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbYGYXGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: don't pass empty cpumasks to partition_sched_domains()
has been removed from the -mm tree.  Its filename was
     cpuset-dont-pass-empty-cpumasks-to-partition_sched_domains.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: don't pass empty cpumasks to partition_sched_domains()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

I create lots of empty cpusets(empty cpumasks) and turn off the
"sched_load_balance" in top cpuset.

I found that all these empty cpumasks are passed to
partition_sched_domains() in rebuild_sched_domains(), it's very
time-consuming for partition_sched_domains() and it's not need.

It also reduce memory consumed and some works in rebuild_sched_domains()
too.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN kernel/cpuset.c~cpuset-dont-pass-empty-cpumasks-to-partition_sched_domains kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-dont-pass-empty-cpumasks-to-partition_sched_domains
+++ a/kernel/cpuset.c
@@ -610,8 +610,13 @@ void rebuild_sched_domains(void)
 	while (__kfifo_get(q, (void *)&cp, sizeof(cp))) {
 		struct cgroup *cont;
 		struct cpuset *child;   /* scans child cpusets of cp */
+
+		if (cpus_empty(cp->cpus_allowed))
+			continue;
+
 		if (is_sched_load_balance(cp))
 			csa[csn++] = cp;
+
 		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
 			__kfifo_put(q, (void *)&child, sizeof(cp));
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

