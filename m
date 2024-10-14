Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E14B13C690
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 19:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728935197; cv=none; b=rOG0PyhK7dgxsVoduzCpV4rHsJvaI6ljCK2pWJquM3H6qaWO8sWgC347gzrZv0pKcagxzbXIAcGpprYBzqMN9xqe2xxuP92E6JyqdN/1WNSAFqLCBWs1lXQse+fAYRIMsSI0UQcGo1/P51PgTHcKlSYRvpbl3Im6EWwwd0jBkh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728935197; c=relaxed/simple;
	bh=UL8ZgRwqgK/ZKYWAHFuqmjeYNha2k8ZUWFCM2sZB0Dk=;
	h=Date:To:From:Subject:Message-Id; b=YakilU7Ag5R0mHWL7SIt1tLMA6iHAz5yZEc2jy4fiqY0sVkHFol0IS+arwNf504kBZVmX7az7ZAiZj/k8UNa8ikwvIcaWpJBYXzcWgmifSuAd8UN6E20CO8qpVwl0nnUsFIJV/mR11msLjfz1hNCX08btZGy5SgPQNQ/QRqLJy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GtNxTNId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GtNxTNId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2472C4CEC3;
	Mon, 14 Oct 2024 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728935197;
	bh=UL8ZgRwqgK/ZKYWAHFuqmjeYNha2k8ZUWFCM2sZB0Dk=;
	h=Date:To:From:Subject:From;
	b=GtNxTNIdbQdnmMhaoDrvk5+B5eTX9zmSbnesHT0/bgRAj7ZWntJtVPBSyd5tkS7y7
	 LkINK3dxd3Bipt8ihmVJAkcKxPSO0TYAA2pNGXVJlwnXJwhaPVzpahnZKOMCTfjYwt
	 1jgfpaLdo/L+4m5EAUUSeDY1v89OwjHF8tDg9/PI=
Date: Mon, 14 Oct 2024 12:46:36 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,srivatsa@csail.mit.edu,mgorman@techsingularity.net,cl@linux.com,ssengar@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch removed from -mm tree
Message-Id: <20241014194636.E2472C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: defer the refresh_zone_stat_thresholds after all CPUs bringup
has been removed from the -mm tree.  Its filename was
     mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: mm/vmstat: defer the refresh_zone_stat_thresholds after all CPUs bringup
Date: Fri, 5 Jul 2024 01:48:21 -0700

refresh_zone_stat_thresholds function has two loops which is expensive for
higher number of CPUs and NUMA nodes.

Below is the rough estimation of total iterations done by these loops
based on number of NUMA and CPUs.

Total number of iterations: nCPU * 2 * Numa * mCPU
Where:
 nCPU = total number of CPUs
 Numa = total number of NUMA nodes
 mCPU = mean value of total CPUs (e.g., 512 for 1024 total CPUs)

For the system under test with 16 NUMA nodes and 1024 CPUs, this results
in a substantial increase in the number of loop iterations during boot-up
when NUMA is enabled:

No NUMA = 1024*2*1*512  =   1,048,576 : Here refresh_zone_stat_thresholds
takes around 224 ms total for all the CPUs in the system under test.
16 NUMA = 1024*2*16*512 =  16,777,216 : Here refresh_zone_stat_thresholds
takes around 4.5 seconds total for all the CPUs in the system under test.

Calling this for each CPU is expensive when there are large number of CPUs
along with multiple NUMAs.  Fix this by deferring
refresh_zone_stat_thresholds to be called later at once when all the
secondary CPUs are up.  Also, register the DYN hooks to keep the existing
hotplug functionality intact.

Without this patch, refresh_zone_stat_threshold was being called 1024
times.  After applying the patch, it is called only once, which is same
as the last iteration of the earlier 1024 calls.  Further testing with
this patch, I observed a 4.5-second improvement in the overall boot
timing due to this fix, which is same as the total time taken by
refresh_zone_stat_thresholds without thie patch, leading me to
reasonably conclude that refresh_zone_stat_threshold now takes a
negligible amount of time (likely just a few milliseconds).

[ssengar@linux.microsoft.com: fix warning]
  Link: https://lkml.kernel.org/r/1723443220-20623-1-git-send-email-ssengar@linux.microsoft.com
Link: https://lkml.kernel.org/r/1720169301-21002-1-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup
+++ a/mm/vmstat.c
@@ -1929,6 +1929,7 @@ static const struct seq_operations vmsta
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
+static int vmstat_late_init_done;
 
 #ifdef CONFIG_PROC_FS
 static void refresh_vm_stats(struct work_struct *work)
@@ -2131,7 +2132,8 @@ static void __init init_cpu_node_state(v
 
 static int vmstat_cpu_online(unsigned int cpu)
 {
-	refresh_zone_stat_thresholds();
+	if (vmstat_late_init_done)
+		refresh_zone_stat_thresholds();
 
 	if (!node_state(cpu_to_node(cpu), N_CPU)) {
 		node_set_state(cpu_to_node(cpu), N_CPU);
@@ -2163,6 +2165,14 @@ static int vmstat_cpu_dead(unsigned int
 	return 0;
 }
 
+static int __init vmstat_late_init(void)
+{
+	refresh_zone_stat_thresholds();
+	vmstat_late_init_done = 1;
+
+	return 0;
+}
+late_initcall(vmstat_late_init);
 #endif
 
 struct workqueue_struct *mm_percpu_wq;
_

Patches currently in -mm which might be from ssengar@linux.microsoft.com are


