Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE07E14A600
	for <mm-commits@vger.kernel.org>; Sat, 10 Aug 2024 07:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723273461; cv=none; b=o1wJ7h9atc/zq/k1BvO7HGyWR4FyJtgFzEMjTvanFxw2L8bG9LQlOhA6xXcz7DMz6AtyvXblYa9ucNLPETcROC/8W7FwOZsa16DQQc99wS6ssRxhk2WMegI/fKtA/n3EZKoUkVcnQHQgpCGxbwu6r+nFnQCFklF5zXBPA4RAjuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723273461; c=relaxed/simple;
	bh=cv2gY58QsWWeaw2zwx4BahRghzbnvVa9RrQRLHWZwsA=;
	h=Date:To:From:Subject:Message-Id; b=ZXIqZQouz6K61Th77tv/21vtHfo9HcEB4yh0cMvOa2OEvYPC4ViI+gUl0GHMMzPJapXES69IZXfE7oBZx0UDlPdecg/7O0QlS/4TgapfH1ClaPZ5JtKB9ltCggMo77wIQuLJu5jNwXtYaLu3Kt24bQOfsww92gkSwZRg/6rTuos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vQ+O6a2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vQ+O6a2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C781C32781;
	Sat, 10 Aug 2024 07:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723273461;
	bh=cv2gY58QsWWeaw2zwx4BahRghzbnvVa9RrQRLHWZwsA=;
	h=Date:To:From:Subject:From;
	b=vQ+O6a2jSqHlhdRWglpHmRPbsnPkDe9RXIMle1C2RPnsD0DifQ3YgKim35DLHqGT9
	 Vhy+c6u9Ayo1lxRTnctQ2alBPcMS8Uvvrf7n9oTG8uDt1z++tunL7QH0evQx1o9z4I
	 7VHGxxXm3WqdSaTsClqgnyK0hMK3kz6M6kew37eg=
Date: Sat, 10 Aug 2024 00:04:20 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,ssengar@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch added to mm-unstable branch
Message-Id: <20240810070421.5C781C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: defer the refresh_zone_stat_thresholds after all CPUs bringup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/1720169301-21002-1-git-send-email-ssengar@linux.microsoft.com
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/vmstat.c~mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup
+++ a/mm/vmstat.c
@@ -31,6 +31,7 @@
 
 #include "internal.h"
 
+static int vmstat_late_init_done;
 #ifdef CONFIG_NUMA
 int sysctl_vm_numa_stat = ENABLE_NUMA_STAT;
 
@@ -2130,7 +2131,8 @@ static void __init init_cpu_node_state(v
 
 static int vmstat_cpu_online(unsigned int cpu)
 {
-	refresh_zone_stat_thresholds();
+	if (vmstat_late_init_done)
+		refresh_zone_stat_thresholds();
 
 	if (!node_state(cpu_to_node(cpu), N_CPU)) {
 		node_set_state(cpu_to_node(cpu), N_CPU);
@@ -2162,6 +2164,14 @@ static int vmstat_cpu_dead(unsigned int
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

mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch

