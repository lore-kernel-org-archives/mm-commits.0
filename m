From: akpm@linux-foundation.org
Subject: + cpuset-dont-pass-empty-cpumasks-to-partition_sched_domains.patch added to -mm tree
Date: Wed, 16 Jul 2008 13:27:29 -0700
Message-ID: <200807162027.m6GKRT5w011427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbYGPU1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 16:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, menage@google.com, pj@sgi.com


The patch titled
     cpuset: don't pass empty cpumasks to partition_sched_domains()
has been added to the -mm tree.  Its filename is
     cpuset-dont-pass-empty-cpumasks-to-partition_sched_domains.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -610,8 +610,13 @@ static void rebuild_sched_domains(void)
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

linux-next.patch
rcu-classic-update-qlen-when-cpu-offline.patch
cpuset-dont-pass-empty-cpumasks-to-partition_sched_domains.patch
cpuset-code-cleanup-for-started_after.patch
cpuset-two-minor-code-cleanups.patch

