Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F44140E34
	for <mm-commits@vger.kernel.org>; Mon, 14 Oct 2024 19:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728935366; cv=none; b=K9pm38sIIVcaJ1dVLahM5mZPwkWwofsFqaTl8CtCVdsC7QZs7V5r0frO5RCvUiyoQoCGJymqveBzlK+8s1i6K/1+azA2teW/cKKa1uuedkWr6qW2QkGEGIwZOG2AuJJtqf+cW2cXxRuQnUP82xgpT2WM9zKxstzSg3tKmKHKFRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728935366; c=relaxed/simple;
	bh=PTd/hCVeOq/N2TZtq0SqCk8BGdZxhWn4TUP7byURWno=;
	h=Date:To:From:Subject:Message-Id; b=FU6FdLydFFlJX2manAyvA5n3IX38pYyyNMgXljBYL65nIUDgGgS6jTXzr/6vqlIBN54AFXPG49qFPX+8qUMzTNkTDsfcKmyGLzUbnUqBr0CkGoPbEEU/wFa1JA9CaWd4sZ3/jwnAKOeTgwdxCthYN8K3aFDvbgxHGnKh1n08LUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LXxcQRNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LXxcQRNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410C1C4CEC3;
	Mon, 14 Oct 2024 19:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728935366;
	bh=PTd/hCVeOq/N2TZtq0SqCk8BGdZxhWn4TUP7byURWno=;
	h=Date:To:From:Subject:From;
	b=LXxcQRNa65rIqOYeSvnBNWZz3kq34Lk3AkoCrpdMAnAXvv73Q0lWJGLr/heeXa/06
	 dOiBYopYTqWwccyfV3LLo6tLhYjHIsmW3+h15807OGCIngd6iD3aVxadme0ML9UF4a
	 39jc3cUV2mhRqjMxNw7okWfmaKA9de7N3POQVIXE=
Date: Mon, 14 Oct 2024 12:49:25 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,ssengar@microsoft.com,srivatsa@csail.mit.edu,mgorman@techsingularity.net,cl@linux.com,anshuman.khandual@arm.com,ssengar@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch added to mm-unstable branch
Message-Id: <20241014194926.410C1C4CEC3@smtp.kernel.org>
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

mm-vmstat-defer-the-refresh_zone_stat_thresholds-after-all-cpus-bringup.patch

