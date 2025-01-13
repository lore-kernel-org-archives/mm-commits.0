Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672DA4315A
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 03:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737464; cv=none; b=EuOoFB/a1qfENYsFqwKAjeUzxCvyl1KJLU5J/XD4L3A+/0o6mAYYdy2sXdcMUa/hddA/b+DzZ/3RPf0DqO4LXZQ4t6EHbqt24bSavdhCphM51bFpFBMogj8PNqBZ/nvpl3Un0hMN1RQh/x0MIFvsIAJWMpZvJkEjYxqmcQ+2WRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737464; c=relaxed/simple;
	bh=BPTTy+GrTL1bp0IEo4sSUHWQPacKnZy5EUXaZ6zjGmM=;
	h=Date:To:From:Subject:Message-Id; b=bxSDuoAmHiWDwsBMpXtZECRLL8UlTPjXywOZJWzS1PvIGxmWf9/0HMIMuDCgMBrpv4v74580g3f35UmkAjV1YCcSS40N8Yg4Gdhhmkjq6mkUqUVO1J+97Rt8QdZJxfLhhItue9YERVnX17P1JOk5FiDCnYPZYFVqxW2A1Boj/x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EMoyrZ8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EMoyrZ8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB67C4CEE0;
	Mon, 13 Jan 2025 03:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737464;
	bh=BPTTy+GrTL1bp0IEo4sSUHWQPacKnZy5EUXaZ6zjGmM=;
	h=Date:To:From:Subject:From;
	b=EMoyrZ8dGJJf0ZvI4Mz4m5DdIO0YAIm589TrROrr8MMNv260EbI5IWVJa2Lfk1HcM
	 DcaezaFq3A6xVZRJMR5McFHYoTlkmdNHKMrOP9Y4jfXIFVnaSFhx85Y1qCvTIZqoKD
	 D57T8sq2FChmKJByGHiUKilm9L7e4CsA4NKx6Lno=
Date: Sun, 12 Jan 2025 19:04:23 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,chenhuacai@kernel.org,charmitro@posteo.net,koichiro.den@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch removed from -mm tree
Message-Id: <20250113030424.3BB67C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmstat: disable vmstat_work on vmstat_cpu_down_prep()
has been removed from the -mm tree.  Its filename was
     vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Charalampos Mitrodimas <charmitro@posteo.net>
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

hugetlb-prioritize-surplus-allocation-from-current-node.patch

