Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73AB153BD9
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854803; cv=none; b=S9Ba/oV66N/CYZIIhWmAD/ZSQCYusdG1vUjjfiJ9S/4trl+5IRvpEflZX1rIgDzS9h1xdmkN/rPOoXv5SQzBlJX0zDiHZ5hK0/4osdczqdm1PENLkWzFwqz4Yo3R2+YizVVoq38JhE/gOitDu6zzq+PAlEpoFxt2stL8VfyQtGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854803; c=relaxed/simple;
	bh=vBj52hZQwGPbA4bHaS8imJu3gEl8fQMjn/M4OVzTXrc=;
	h=Date:To:From:Subject:Message-Id; b=e0lOsbslYY8p4ca8CuqusgJRgc+2Ba7UlwTMYzn2PNC3cIuGZYcMg+isN9Wr8h0sxQ6YEMyW0qXs1sLVvPrDTJVQd989uRdRv+mWjbI/pONPzdFMf/qXT3za8DblqajiMTV9hhLaJkIJ6LaR/st6/tORrD9+ctqv6R69gVq4fRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i5zQCIes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i5zQCIes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F44AC4CECF;
	Wed,  6 Nov 2024 01:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854803;
	bh=vBj52hZQwGPbA4bHaS8imJu3gEl8fQMjn/M4OVzTXrc=;
	h=Date:To:From:Subject:From;
	b=i5zQCIesvDMOKPbxTpVrhqOvgdj4elkUDnwKJeHremc6hv3aGmDRE5FbJGpL+T/WP
	 lPwbnrkzMSL0ktEQuipIrybAoG6430vIYsQxGNgQq/AbB+J4ihq/NMefy2at9dNXTt
	 O+9nEJEkLdKHsZkYXwWhM7VoXOSxnw1W4ij2sb4g=
Date: Tue, 05 Nov 2024 17:00:02 -0800
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,ssengar@microsoft.com,srivatsa@csail.mit.edu,mgorman@techsingularity.net,cl@linux.com,anshuman.khandual@arm.com,ssengar@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch removed from -mm tree
Message-Id: <20241106010003.7F44AC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmstat: defer the refresh_zone_stat_thresholds after all CPUs bringup
has been removed from the -mm tree.  Its filename was
     mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Saurabh Sengar <ssengar@linux.microsoft.com>
Subject: mm/vmstat: defer the refresh_zone_stat_thresholds after all CPUs bringup
Date: Sun, 11 Aug 2024 23:13:40 -0700

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

Link: https://lkml.kernel.org/r/1723443220-20623-1-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Acked-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>
Cc: Saurabh Singh Sengar <ssengar@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup
+++ a/mm/vmstat.c
@@ -1933,6 +1933,7 @@ static const struct seq_operations vmsta
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
+static int vmstat_late_init_done;
 
 #ifdef CONFIG_PROC_FS
 static void refresh_vm_stats(struct work_struct *work)
@@ -2135,7 +2136,8 @@ static void __init init_cpu_node_state(v
 
 static int vmstat_cpu_online(unsigned int cpu)
 {
-	refresh_zone_stat_thresholds();
+	if (vmstat_late_init_done)
+		refresh_zone_stat_thresholds();
 
 	if (!node_state(cpu_to_node(cpu), N_CPU)) {
 		node_set_state(cpu_to_node(cpu), N_CPU);
@@ -2167,6 +2169,14 @@ static int vmstat_cpu_dead(unsigned int
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


