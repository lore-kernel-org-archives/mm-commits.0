From: akpm@linux-foundation.org
Subject: [merged] cpuset-add-a-missing-unlock-in-cpuset_write_resmask.patch removed from -mm tree
Date: Mon, 07 Mar 2011 13:31:00 -0800
Message-ID: <201103072131.p27LVh9V028057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756141Ab1CGVcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 16:32:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cpuset: add a missing unlock in cpuset_write_resmask()
has been removed from the -mm tree.  Its filename was
     cpuset-add-a-missing-unlock-in-cpuset_write_resmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: add a missing unlock in cpuset_write_resmask()
From: Li Zefan <lizf@cn.fujitsu.com>

Don't forget to release cgroup_mutex if alloc_trial_cpuset() fails.

[akpm@linux-foundation.org: avoid multiple return points]
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpuset-add-a-missing-unlock-in-cpuset_write_resmask kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-add-a-missing-unlock-in-cpuset_write_resmask
+++ a/kernel/cpuset.c
@@ -1575,8 +1575,10 @@ static int cpuset_write_resmask(struct c
 		return -ENODEV;
 
 	trialcs = alloc_trial_cpuset(cs);
-	if (!trialcs)
-		return -ENOMEM;
+	if (!trialcs) {
+		retval = -ENOMEM;
+		goto out;
+	}
 
 	switch (cft->private) {
 	case FILE_CPULIST:
@@ -1591,6 +1593,7 @@ static int cpuset_write_resmask(struct c
 	}
 
 	free_trial_cpuset(trialcs);
+out:
 	cgroup_unlock();
 	return retval;
 }
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
mm-notifier_from_errno-cleanup.patch
cgroup-remove-the-ns_cgroup.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist-v2.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch

