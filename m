From: akpm@linux-foundation.org
Subject: + cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch added to -mm tree
Date: Tue, 27 May 2008 20:48:33 -0700
Message-ID: <200805280348.m4S3mXlu027525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbYE1Dsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 23:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, pj@sgi.com


The patch titled
     cpusets: fix bug when adding nonexistent cpu or mem
has been added to the -mm tree.  Its filename is
     cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch

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
Subject: cpusets: fix bug when adding nonexistent cpu or mem
From: Lai Jiangshan <laijs@cn.fujitsu.com>

Adding a nonexistent cpu to a cpuset will be omitted quietly.  It should
return -EINVAL.

Example: (real_nr_cpus <= 4 < NR_CPUS or cpu#4 was just offline)

# cat cpus
0-1
# /bin/echo 4 > cpus
# /bin/echo $?
0
# cat cpus

#

The same occurs when add a nonexistent mem.
This patch will fix this bug.
And when *buf == "", the check is unneeded.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem
+++ a/kernel/cpuset.c
@@ -797,8 +797,10 @@ static int update_cpumask(struct cpuset 
 		retval = cpulist_parse(buf, trialcs.cpus_allowed);
 		if (retval < 0)
 			return retval;
+
+		if (!cpus_subset(trialcs.cpus_allowed, cpu_online_map))
+			return -EINVAL;
 	}
-	cpus_and(trialcs.cpus_allowed, trialcs.cpus_allowed, cpu_online_map);
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
 		return retval;
@@ -932,9 +934,11 @@ static int update_nodemask(struct cpuset
 		retval = nodelist_parse(buf, trialcs.mems_allowed);
 		if (retval < 0)
 			goto done;
+
+		if (!nodes_subset(trialcs.mems_allowed,
+				node_states[N_HIGH_MEMORY]))
+			return -EINVAL;
 	}
-	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed,
-						node_states[N_HIGH_MEMORY]);
 	oldmem = cs->mems_allowed;
 	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
 		retval = 0;		/* Too easy - nothing to do */
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

rcu-remove-unused-field-struct-rcu_data-rcu_tasklet.patch
cpusets-fix-bug-when-adding-nonexistent-cpu-or-mem.patch

