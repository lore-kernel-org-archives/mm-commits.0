Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2636AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423598; cv=none; b=kWy2frrc1ltYQkJE3QiSs4s/v9KIKUlv7XZbvIjaG/CHBbQPBFdwV1Q339aefHRtAN7Efrx/RS51Ge7zaJDN2g4f00rubm/hiMk0b3UDm2+V7WpuTCGRB6dWw/Ve8+pvFfvP4LNA8FIMijNZGui6y+JzmF6Rjk1t+MNbdIcHJF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423598; c=relaxed/simple;
	bh=Yxba8BS0vu02EAx0MPrcP1/uC8bz2gua6sxJjjE5tJk=;
	h=Date:To:From:Subject:Message-Id; b=alLkrVUgOdwt63755d7jwwgNr1LXF+fTtLEBx7n6JIp+x0+0/frbPNDR67dd64p5dAhyrRUL84USPlHReiiNDhId7bDmiEwRYFR6o6pBubtKdhhW0sJKyZZoO/ktARgVEZiV4V50Xzf25HxWmY+mAWxE9OXksKtu1Ha5bl/0LVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lFkqYd/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lFkqYd/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74744C4CEC2;
	Wed,  4 Sep 2024 04:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423598;
	bh=Yxba8BS0vu02EAx0MPrcP1/uC8bz2gua6sxJjjE5tJk=;
	h=Date:To:From:Subject:From;
	b=lFkqYd/DVd2IQ+roBHD/Xfd+VpbC20GJZmkzBh4sqpkqBUZUn5I7pA4/8tz+M0CGg
	 iw1xCnAecKuTKaPWhQplPl4dx4HN4R/+SYBfX5pcKSgjZOjJ0J536C+Sn8xoKG17aI
	 FXM88UnfXYuCBrpHawkvsR6BVrqkrk+ACm9bzyR0=
Date: Tue, 03 Sep 2024 21:19:57 -0700
To: mm-commits@vger.kernel.org,yu.c.chen@intel.com,xiaoping.zhou@intel.com,vincent.guittot@linaro.org,tim.c.chen@intel.com,raghavendra.kt@amd.com,peterz@infradead.org,mingo@redhat.com,mgorman@techsingularity.net,juri.lelli@redhat.com,yujie.liu@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sched-numa-fix-the-vma-scan-starving-issue.patch removed from -mm tree
Message-Id: <20240904041958.74744C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sched/numa: Fix the vma scan starving issue
has been removed from the -mm tree.  Its filename was
     sched-numa-fix-the-vma-scan-starving-issue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yujie Liu <yujie.liu@intel.com>
Subject: sched/numa: Fix the vma scan starving issue
Date: Tue, 27 Aug 2024 19:29:58 +0800

Problem statement:
Since commit fc137c0ddab2 ("sched/numa: enhance vma scanning logic"), the
Numa vma scan overhead has been reduced a lot.  Meanwhile, the reducing of
the vma scan might create less Numa page fault information.  The
insufficient information makes it harder for the Numa balancer to make
decision.  Later, commit b7a5b537c55c08 ("sched/numa: Complete scanning of
partial VMAs regardless of PID activity") and commit 84db47ca7146d7
("sched/numa: Fix mm numa_scan_seq based unconditional scan") are found to
bring back part of the performance.

Recently when running SPECcpu omnetpp_r on a 320 CPUs/2 Sockets system, a
long duration of remote Numa node read was observed by PMU events: A few
cores having ~500MB/s remote memory access for ~20 seconds.  It causes
high core-to-core variance and performance penalty.  After the
investigation, it is found that many vmas are skipped due to the active
PID check.  According to the trace events, in most cases,
vma_is_accessed() returns false because the history access info stored in
pids_active array has been cleared.

Proposal:
The main idea is to adjust vma_is_accessed() to let it return true easier.
Thus compare the diff between mm->numa_scan_seq and
vma->numab_state->prev_scan_seq.  If the diff has exceeded the threshold,
scan the vma.

This patch especially helps the cases where there are small number of
threads, like the process-based SPECcpu.  Without this patch, if the
SPECcpu process access the vma at the beginning, then sleeps for a long
time, the pid_active array will be cleared.  A a result, if this process
is woken up again, it never has a chance to set prot_none anymore. 
Because only the first 2 times of access is granted for vma scan:
(current->mm->numa_scan_seq) - vma->numab_state->start_scan_seq) < 2 to be
worse, no other threads within the task can help set the prot_none.  This
causes information lost.

Raghavendra helped test current patch and got the positive result
on the AMD platform:

autonumabench NUMA01
                            base                  patched
Amean     syst-NUMA01      194.05 (   0.00%)      165.11 *  14.92%*
Amean     elsp-NUMA01      324.86 (   0.00%)      315.58 *   2.86%*

Duration User      380345.36   368252.04
Duration System      1358.89     1156.23
Duration Elapsed     2277.45     2213.25

autonumabench NUMA02

Amean     syst-NUMA02        1.12 (   0.00%)        1.09 *   2.93%*
Amean     elsp-NUMA02        3.50 (   0.00%)        3.56 *  -1.84%*

Duration User        1513.23     1575.48
Duration System         8.33        8.13
Duration Elapsed       28.59       29.71

kernbench

Amean     user-256    22935.42 (   0.00%)    22535.19 *   1.75%*
Amean     syst-256     7284.16 (   0.00%)     7608.72 *  -4.46%*
Amean     elsp-256      159.01 (   0.00%)      158.17 *   0.53%*

Duration User       68816.41    67615.74
Duration System     21873.94    22848.08
Duration Elapsed      506.66      504.55

Intel 256 CPUs/2 Sockets:
autonuma benchmark also shows improvements:

                                               v6.10-rc5              v6.10-rc5
                                                                         +patch
Amean     syst-NUMA01                  245.85 (   0.00%)      230.84 *   6.11%*
Amean     syst-NUMA01_THREADLOCAL      205.27 (   0.00%)      191.86 *   6.53%*
Amean     syst-NUMA02                   18.57 (   0.00%)       18.09 *   2.58%*
Amean     syst-NUMA02_SMT                2.63 (   0.00%)        2.54 *   3.47%*
Amean     elsp-NUMA01                  517.17 (   0.00%)      526.34 *  -1.77%*
Amean     elsp-NUMA01_THREADLOCAL       99.92 (   0.00%)      100.59 *  -0.67%*
Amean     elsp-NUMA02                   15.81 (   0.00%)       15.72 *   0.59%*
Amean     elsp-NUMA02_SMT               13.23 (   0.00%)       12.89 *   2.53%*

                   v6.10-rc5   v6.10-rc5
                                  +patch
Duration User     1064010.16  1075416.23
Duration System      3307.64     3104.66
Duration Elapsed     4537.54     4604.73

The SPECcpu remote node access issue disappears with the patch applied.

Link: https://lkml.kernel.org/r/20240827112958.181388-1-yu.c.chen@intel.com
Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Co-developed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Yujie Liu <yujie.liu@intel.com>
Reported-by: Xiaoping Zhou <xiaoping.zhou@intel.com>
Reviewed-and-tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/fair.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/sched/fair.c~sched-numa-fix-the-vma-scan-starving-issue
+++ a/kernel/sched/fair.c
@@ -3187,6 +3187,15 @@ static bool vma_is_accessed(struct mm_st
 		return true;
 	}
 
+	/*
+	 * This vma has not been accessed for a while, and if the number
+	 * the threads in the same process is low, which means no other
+	 * threads can help scan this vma, force a vma scan.
+	 */
+	if (READ_ONCE(mm->numa_scan_seq) >
+	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
+		return true;
+
 	return false;
 }
 
_

Patches currently in -mm which might be from yujie.liu@intel.com are


