Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8C117BDC
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644697; cv=none; b=CUqfGIZQLDZXjP/GpDGGK61Oh1f9Fws59rk46xb5k0tDunJbRC8bpH3YXKKrsahe5a/2RpWHeTNrmXzpG2fgKHo46dsaY/N4zJKovtdrNl/GIt6/1VCKdJmZV2raLhGAkkje4OmLE2dHrjhY3AlPgFwTw6QrrTbeVMrLcXTarx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644697; c=relaxed/simple;
	bh=iffSiLKr7ZYVaV7VyLOfpQ2tbQEabqYbTyZo5okvWfE=;
	h=Date:To:From:Subject:Message-Id; b=SsjDdIExnUW4Gb2eDMyvQK7ZNiBo0RMN4ubb3lhWAD2EKxthUzov9Js2/MmNmT/+vVx6UDr87a08cEMWmeuhOzuhRFNQVlh6+6WWxbRFTqwqK0M4ny9TOeyle+E/C0jawEHQ9bMk+wLvnRkbVtpVYe3XB4Lc+KWr2g+2/Vuek2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c89iVMnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c89iVMnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B170DC433F1;
	Thu, 22 Feb 2024 23:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644696;
	bh=iffSiLKr7ZYVaV7VyLOfpQ2tbQEabqYbTyZo5okvWfE=;
	h=Date:To:From:Subject:From;
	b=c89iVMnFCy1+KS/BFE6mypxFJNhHfdS01WIY/sAq2uKpsDJAZwOLhf0Xts4itEsNd
	 NdrkC7KJ7xaJIxK3rRZ8kPKB3xzgEF7dpoWQyahoNgoMU7QLj/MKwQElCsUJn9JPMu
	 vDtchzAFOvJKgrW41lnPkCKo0LOOEdxvGDIWO6Gs=
Date: Thu, 22 Feb 2024 15:31:36 -0800
To: mm-commits@vger.kernel.org,yangjihong1@huawei.com,tglx@linutronix.de,rick.p.edgecombe@intel.com,pmladek@suse.com,peterz@infradead.org,paulmck@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mic@digikod.net,mhiramat@kernel.org,juerg.haefliger@canonical.com,jkl820.git@gmail.com,eric.devolder@oracle.com,dianders@chromium.org,davem@davemloft.net,anil.s.keshavamurthy@intel.com,chenzhongjin@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer.patch removed from -mm tree
Message-Id: <20240222233136.B170DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kprobes: use synchronize_rcu_tasks_rude in kprobe_optimizer
has been removed from the -mm tree.  Its filename was
     kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chen Zhongjin <chenzhongjin@huawei.com>
Subject: kprobes: use synchronize_rcu_tasks_rude in kprobe_optimizer
Date: Wed, 17 Jan 2024 06:16:36 +0000

There is a deadlock scenario in kprobe_optimizer():

pid A				pid B			pid C
kprobe_optimizer()		do_exit()		perf_kprobe_init()
mutex_lock(&kprobe_mutex)	exit_tasks_rcu_start()	mutex_lock(&kprobe_mutex)
synchronize_rcu_tasks()		zap_pid_ns_processes()	// waiting kprobe_mutex
// waiting tasks_rcu_exit_srcu	kernel_wait4()
				// waiting pid C exit

To avoid this deadlock loop, use synchronize_rcu_tasks_rude() in
kprobe_optimizer() rather than synchronize_rcu_tasks(). 
synchronize_rcu_tasks_rude() can also promise that all preempted tasks
have scheduled, but it will not wait tasks_rcu_exit_srcu.

[akpm@linux-foundation.org: unrelated comment typo fix]
Link: https://lkml.kernel.org/r/20240117061636.288412-1-chenzhongjin@huawei.com
Fixes: a30b85df7d59 ("kprobes: Use synchronize_rcu_tasks() for optprobe with CONFIG_PREEMPT=y")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Jakob Koschel <jkl820.git@gmail.com>
Cc: Juerg Haefliger <juerg.haefliger@canonical.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Mickaël Salaün <mic@digikod.net>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig     |    2 +-
 kernel/kprobes.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/Kconfig~kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer
+++ a/arch/Kconfig
@@ -104,7 +104,7 @@ config STATIC_CALL_SELFTEST
 config OPTPROBES
 	def_bool y
 	depends on KPROBES && HAVE_OPTPROBES
-	select TASKS_RCU if PREEMPTION
+	select TASKS_RUDE_RCU
 
 config KPROBES_ON_FTRACE
 	def_bool y
--- a/kernel/kprobes.c~kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer
+++ a/kernel/kprobes.c
@@ -621,9 +621,9 @@ static void kprobe_optimizer(struct work
 	 * instruction is preempted. In that case, such tasks can return
 	 * to 2nd-Nth byte of jump instruction. This wait is for avoiding it.
 	 * Note that on non-preemptive kernel, this is transparently converted
-	 * to synchronoze_sched() to wait for all interrupts to have completed.
+	 * to synchronize_sched() to wait for all interrupts to have completed.
 	 */
-	synchronize_rcu_tasks();
+	synchronize_rcu_tasks_rude();
 
 	/* Step 3: Optimize kprobes after quiesence period */
 	do_optimize_kprobes();
_

Patches currently in -mm which might be from chenzhongjin@huawei.com are


