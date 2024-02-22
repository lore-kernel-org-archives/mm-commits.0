Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BA217BDC
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644675; cv=none; b=ARLEGFGO5YU3lgb2wRc/dr/c/DGFUFyzveSasfsbeVctBt2L/FqW1Kg1CHsSFeODCQH2rmQUmqgC2Hgek/LJUIhFnJQXreKp77f8nIKZTQw2MMhI6jMH4RDq6Hg5jDTltMENcAoh6NTEEWdP4+ca3MQuReggqxHvM+/crosaECo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644675; c=relaxed/simple;
	bh=9t9TgREpQg4/vo2h1gB0ifShtoL+wXbcJ0mMcnRv4b0=;
	h=Date:To:From:Subject:Message-Id; b=WHeu8bXhNcoLvE6BdtuEzuAtJBlplfZ06a1jP9b6r+DH4bQ37DkXBp0DAjF0vekONSuWxUUYKWWZSgI7lr3nC1w//4ViiZa2l5hbXboNYSTDFxQ51S5EwnSdsQiXYz5kbhTbj7NZlU3yG4JN7De9r51t57xHd2op05LX/IAF6jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H2N3ngSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H2N3ngSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249DCC433C7;
	Thu, 22 Feb 2024 23:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644675;
	bh=9t9TgREpQg4/vo2h1gB0ifShtoL+wXbcJ0mMcnRv4b0=;
	h=Date:To:From:Subject:From;
	b=H2N3ngSKp05TlFgJgGwsMD0XDuP+BsEWPm6GGgMRv7KKhd12XSgDo6ID8tEfhrezq
	 4HTMgL0jt/4syWH1Gwk1stUICAQXSgN8NducyQH8Bceg1bhr+8vj/4pAn4wMwK+5sA
	 NKgu+CQmgKTR/i1LlAqrbjSX0Oa7g4YZ/JeIrn0M=
Date: Thu, 22 Feb 2024 15:31:14 -0800
To: mm-commits@vger.kernel.org,yangjihong1@huawei.com,tglx@linutronix.de,rick.p.edgecombe@intel.com,pmladek@suse.com,peterz@infradead.org,paulmck@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mic@digikod.net,mhiramat@kernel.org,juerg.haefliger@canonical.com,jkl820.git@gmail.com,eric.devolder@oracle.com,dianders@chromium.org,davem@davemloft.net,chenzhongjin@huawei.com,anil.s.keshavamurthy@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch removed from -mm tree
Message-Id: <20240222233115.249DCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix
has been removed from the -mm tree.  Its filename was
     kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch

This patch was dropped because it was folded into kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix
Date: Wed Jan 17 12:33:11 PM PST 2024

unrelated comment typo fix

Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Chen Zhongjin <chenzhongjin@huawei.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Jakob Koschel <jkl820.git@gmail.com>
Cc: Juerg Haefliger <juerg.haefliger@canonical.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
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

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kprobes.c~kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix
+++ a/kernel/kprobes.c
@@ -621,7 +621,7 @@ static void kprobe_optimizer(struct work
 	 * instruction is preempted. In that case, such tasks can return
 	 * to 2nd-Nth byte of jump instruction. This wait is for avoiding it.
 	 * Note that on non-preemptive kernel, this is transparently converted
-	 * to synchronoze_sched() to wait for all interrupts to have completed.
+	 * to synchronize_sched() to wait for all interrupts to have completed.
 	 */
 	synchronize_rcu_tasks_rude();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

