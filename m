Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985675C8F7;
	Sat, 21 Dec 2024 03:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734753446; cv=none; b=IaXKwHF2eLpyCB5P/GbW0grcrWsdOy0k7wXMZ9LIfKJ5RF9fvgNtOiUyXeF/mk2mTviDWURdDo0fgSILngjV+AFVYdNoFoAdv8NUZe4/j41CpWsTe1NmEDq1xZEvgGwu0IaXWiA2JqUYWzxHBIsHG2oxR9bIgpeVmsPm7Tg+UaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734753446; c=relaxed/simple;
	bh=PiIPBe0UUPa7OxWNxW5c8SxznkJstqepPuAZSArOjOw=;
	h=Date:To:From:Subject:Message-Id; b=KDXP5/5nIU1chIW6EBY1zaQR+PLC1fMBP21rGwp1XTeEeuRVUdxNKxs5W3z8HTvHqJNnpxftCjXtRmPWQhffubZYRWR605ohTmg9kStlnmsNMz1Jkn4Io4gdk61KVr/wRT7p4QHUVhyiVPrkmHL6w65tvjXLsnOM6PYa5i6CcyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MvFYgfRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MvFYgfRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C82C4CECE;
	Sat, 21 Dec 2024 03:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734753446;
	bh=PiIPBe0UUPa7OxWNxW5c8SxznkJstqepPuAZSArOjOw=;
	h=Date:To:From:Subject:From;
	b=MvFYgfRIpv4YVMe+ay6kERAagZqLgyhJnYvG5AaeeYC2c8MNEtMHMYztoAIPjf0vI
	 RDxbCczoK9IvmtTfZA5pkZ1Qxil5offFfkgbCs9X57x83JNHd3MOg33Z5rFb3slFYn
	 2WYdaGqiHyN47LzoaPp40cV0gUY+OZmV+lKapSag=
Date: Fri, 20 Dec 2024 19:57:25 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,bigeasy@linutronix.de,koichiro.den@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch added to mm-hotfixes-unstable branch
Message-Id: <20241221035726.38C82C4CECE@smtp.kernel.org>
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
Date: Sat, 21 Dec 2024 12:33:20 +0900

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

Link: https://lkml.kernel.org/r/20241221033321.4154409-1-koichiro.den@canonical.com
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmstat.c~vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep
+++ a/mm/vmstat.c
@@ -2148,13 +2148,14 @@ static int vmstat_cpu_online(unsigned in
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

