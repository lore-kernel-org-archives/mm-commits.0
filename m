Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40B22139A1
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 05:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736399488; cv=none; b=W3eOZ7EezjMRkN5kJQt6NQIIt0qc3VAo1OJdzXFUryVWawGZ55zohTm3aVy/0lqIxnhtd5EsGSz2YDfdymYxfdPoFGBbnsuzv95c0lsLO2DciycnjmD/SF/Q4VW4ppL9wEdP2YNzuh7vl2bopaXEfmFjsmU3SQImiV51I1ntXG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736399488; c=relaxed/simple;
	bh=ZU9v7D4gs/lJJOeGQQumQyVVSTcbNY5D0eZxo0x11ho=;
	h=Date:To:From:Subject:Message-Id; b=GJ2EhaWRZAbcpSMB4mLcokMVz4T+YABMiFVvXqd3AboHSOsQlnb6UxxA85ces1V61KQCqH0r7zurCZ9IcW4d66B+7yoMMJgpaaTNEWHS3yGPPNVlH2MG8G9J82OyIpm3FVCwyPdyfidGMfmFWla5qAYY3shQFjBqBz74L4SidgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RFCO70Fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RFCO70Fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433CCC4CED2;
	Thu,  9 Jan 2025 05:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736399488;
	bh=ZU9v7D4gs/lJJOeGQQumQyVVSTcbNY5D0eZxo0x11ho=;
	h=Date:To:From:Subject:From;
	b=RFCO70Fl95JDfba/KVXeIEGqgVRyQF3ImAShaMESKlf5LT2RpUs8TVgjGluYHRBqO
	 HTgH7ouJ00ckeQDJ2d/sDlL59hzq7F6oX1IZI7tnq/N0zCFx/BrvRjX6jgJYalBIuz
	 5ZBZsFd2xekFNA+5HTUsVAtdUOZmpiQlFV5VQOzY=
Date: Wed, 08 Jan 2025 21:11:27 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,chenhuacai@kernel.org,koichiro.den@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch added to mm-hotfixes-unstable branch
Message-Id: <20250109051128.433CCC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmstat: disable vmstat_work on vmstat_cpu_down_prep()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Koichiro Den <koichiro.den@canonical.com>
Subject: vmstat: disable vmstat_work on vmstat_cpu_down_prep()
Date: Wed, 8 Jan 2025 13:28:07 +0900

The upstream commit adcfb264c3ed ("vmstat: disable vmstat_work on
vmstat_cpu_down_prep()") introduced another warning during the boot phase
so was soon reverted on upstream by commit cd6313beaeae ("Revert "vmstat:
disable vmstat_work on vmstat_cpu_down_prep()"").  This commit resolves it
and reattempts the original fix.

Even after mm/vmstat:online teardown, shepherd may still queue work for
the dying cpu until the cpu is removed from online mask.  While it's quite
rare, this means that after unbind_workers() unbinds a per-cpu kworker, it
potentially runs vmstat_update for the dying CPU on an irrelevant cpu
before entering atomic AP states.  When CONFIG_DEBUG_PREEMPT=y, it results
in the following error with the backtrace.

  BUG: using smp_processor_id() in preemptible [00000000] code: \
                                               kworker/7:3/1702
  caller is refresh_cpu_vm_stats+0x235/0x5f0
  CPU: 0 UID: 0 PID: 1702 Comm: kworker/7:3 Tainted: G
  Tainted: [N]=TEST
  Workqueue: mm_percpu_wq vmstat_update
  Call Trace:
   <TASK>
   dump_stack_lvl+0x8d/0xb0
   check_preemption_disabled+0xce/0xe0
   refresh_cpu_vm_stats+0x235/0x5f0
   vmstat_update+0x17/0xa0
   process_one_work+0x869/0x1aa0
   worker_thread+0x5e5/0x1100
   kthread+0x29e/0x380
   ret_from_fork+0x2d/0x70
   ret_from_fork_asm+0x1a/0x30
   </TASK>

So, for mm/vmstat:online, disable vmstat_work reliably on teardown and
symmetrically enable it on startup.

For secondary CPUs during CPU hotplug scenarios, ensure the delayed work
is disabled immediately after the initialization.  These CPUs are not yet
online when start_shepherd_timer() runs on boot CPU.  vmstat_cpu_online()
will enable the work for them.

Link: https://lkml.kernel.org/r/20250108042807.3429745-1-koichiro.den@canonical.com
Signed-off-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Suggested-by: Huacai Chen <chenhuacai@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/vmstat.c~vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep
+++ a/mm/vmstat.c
@@ -2122,10 +2122,20 @@ static void __init start_shepherd_timer(
 {
 	int cpu;
 
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);
 
+		/*
+		 * For secondary CPUs during CPU hotplug scenarios,
+		 * vmstat_cpu_online() will enable the work.
+		 * mm/vmstat:online enables and disables vmstat_work
+		 * symmetrically during CPU hotplug events.
+		 */
+		if (!cpu_online(cpu))
+			disable_delayed_work_sync(&per_cpu(vmstat_work, cpu));
+	}
+
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
 }
@@ -2148,13 +2158,14 @@ static int vmstat_cpu_online(unsigned in
 	if (!node_state(cpu_to_node(cpu), N_CPU)) {
 		node_set_state(cpu_to_node(cpu), N_CPU);
 	}
+	enable_delayed_work(&per_cpu(vmstat_work, cpu));
 
 	return 0;
 }
 
 static int vmstat_cpu_down_prep(unsigned int cpu)
 {
-	cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
+	disable_delayed_work_sync(&per_cpu(vmstat_work, cpu));
 	return 0;
 }
 
_

Patches currently in -mm which might be from koichiro.den@canonical.com are

vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch
hugetlb-prioritize-surplus-allocation-from-current-node.patch

