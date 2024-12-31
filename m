Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A69487BF;
	Tue, 31 Dec 2024 02:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610413; cv=none; b=iIDNwUPlMVGkXKmgAIAUeOUwcy+TDESbKnLVSeKzM9qobmVnviSeJpV3bx1Tnm+oBYZgV5COUxnSJHyIAFejzuRZ85pNlvFcY2NE40EgJabnc7COdv8fgg+aHJq+A0WLDjHhFzYzBUtA/RFX6EVL4RXSoU2sT9Au8NDGiOTqyu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610413; c=relaxed/simple;
	bh=r2wuNpqaIe87/duu5/9b0nz8O35JCX5Z5oI3vRQNKlI=;
	h=Date:To:From:Subject:Message-Id; b=T8hPyzDRrkaMxcRrnlIN/z96XXT92qkXpSNuXXzXwvuG+tQuc5zF5j69La6NA0+1zf7a8S0ElMFb7wdfxo1ADmOAuGKFXmhYKDmHIDNYOiieLetuK7iLI0KUTzcZQ5Il5RSOWgP6vOKCeXU35GZlovhAZieZvn3eB1k+eQsIt04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LdvfNCXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LdvfNCXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CEDC4CED7;
	Tue, 31 Dec 2024 02:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610413;
	bh=r2wuNpqaIe87/duu5/9b0nz8O35JCX5Z5oI3vRQNKlI=;
	h=Date:To:From:Subject:From;
	b=LdvfNCXPzF9zjQmLt1l/1EcdAonxektOFrtggoIbOZU+giXg16voR6+hx1IMul53S
	 Sl9CwJtSjNAgQyEflBxLF4J5lp8rWpNBZLQqxTVYnwvRMS47GQmi4zJ0ma+O8fVxMe
	 p/IvU5WelA9J/Nh6Hy2e8mzD/cPjk9kEI9e92+Y8=
Date: Mon, 30 Dec 2024 18:00:13 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,bigeasy@linutronix.de,koichiro.den@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] vmstat-disable-vmstat_work-on-vmstat_cpu_down_prep.patch removed from -mm tree
Message-Id: <20241231020013.98CEDC4CED7@smtp.kernel.org>
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

hugetlb-prioritize-surplus-allocation-from-current-node.patch

