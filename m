Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39774250F7
	for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 20:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705524930; cv=none; b=kJiY8apnhh2AQ4aqHDx6HyG0hh/8G5zOK8sUTJ/V9XRcFtOQ9TTcd987s8orAAn9aDaybDj4SsV6hCRS3UmR/NVp+p6H1+07rIZomef/ZUuZNEsNAzGPqPNlfuG9BPEBRVuN5lRNk7arLDp9VaIDgD4UkrNy6U02WvGHSKtwnPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705524930; c=relaxed/simple;
	bh=0dXi9jAgcqbXQisc1YqVpuA6c8Jktw+PnrgEUhkcKS4=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=LrbX9ynAMlZdse4NSU8P0AEtkkvN0fRuAHsO/Djb0q6p9qF432b+EgRKCRYP5MHZ1Iy9ITprcVYsgs195Ev4DSJ1LGvNCMzeuiOBpxeYMns15cX4JcyOMYwHQlwtXbq8GOiPlP3GCQz1d3MHSCKQL06NPQp7BCUZ1sA2FGnxD3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eD8bUrfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eD8bUrfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F53C433C7;
	Wed, 17 Jan 2024 20:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705524929;
	bh=0dXi9jAgcqbXQisc1YqVpuA6c8Jktw+PnrgEUhkcKS4=;
	h=Date:To:From:Subject:From;
	b=eD8bUrfaGxA46YfnsXJ/5T0SlxGJ7x3DSTCbNgMxxVx1pN+5QUCHVeEYd37560tF+
	 jGuRkKfdgw9L7g3mvd4GFBFatuXElDh3y5Ld5oDRpIrB80HDs/b/ExmHnYiJzaSdQu
	 0MG0zpPO2lO3C7FkcbekTQlMgEeEYqHg41uKt74s=
Date: Wed, 17 Jan 2024 12:55:27 -0800
To: mm-commits@vger.kernel.org,yangjihong1@huawei.com,tglx@linutronix.de,rick.p.edgecombe@intel.com,pmladek@suse.com,peterz@infradead.org,paulmck@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mic@digikod.net,mhiramat@kernel.org,juerg.haefliger@canonical.com,jkl820.git@gmail.com,eric.devolder@oracle.com,dianders@chromium.org,davem@davemloft.net,anil.s.keshavamurthy@intel.com,chenzhongjin@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer.patch added to mm-nonmm-unstable branch
Message-Id: <20240117205529.57F53C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kprobes: use synchronize_rcu_tasks_rude in kprobe_optimizer
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

Link: https://lkml.kernel.org/r/20240117061636.288412-1-chenzhongjin@huawei.com
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
 kernel/kprobes.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
@@ -623,7 +623,7 @@ static void kprobe_optimizer(struct work
 	 * Note that on non-preemptive kernel, this is transparently converted
 	 * to synchronoze_sched() to wait for all interrupts to have completed.
 	 */
-	synchronize_rcu_tasks();
+	synchronize_rcu_tasks_rude();
 
 	/* Step 3: Optimize kprobes after quiesence period */
 	do_optimize_kprobes();
_

Patches currently in -mm which might be from chenzhongjin@huawei.com are

kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer.patch

