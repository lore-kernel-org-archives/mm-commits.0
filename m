Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF687250F7
	for <mm-commits@vger.kernel.org>; Wed, 17 Jan 2024 20:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705524932; cv=none; b=PBk+ulXygHSEvGUcVkATktKSq394OdfeH4w8f73dKe02IT95kt2GK2KXDq6IVsZZvsydrB3hRjeKMCEFOmfLqH8QB9e3EUZtdncvt9P3pcLTF529+uwVD/zowk90NXeHUkI2s5i5M+0sf/1pMvGZ4fmI84InKNFBC954egfrrso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705524932; c=relaxed/simple;
	bh=4h+DEye5qYVPonkmSCK/eycHV2a4kr/YrbVHbs2ZrQ0=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=iPF/xim6FKKOBTx+sFVJ17DE/C8rUkBCPmLDIk+vXV0i1sN7JpBvUtK/VRbbST/4N6VVAfpXZNK2lwjY9aQjIbtz2zgcr1jEK6MH3IpZEbRN88tQ7lmbd11aQ1eAU6iIwIe8/THReEDs0yJ9JlL44dsn3wHdPsd8OSuOOTW7JfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UU3FVf/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UU3FVf/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BF7C433F1;
	Wed, 17 Jan 2024 20:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705524932;
	bh=4h+DEye5qYVPonkmSCK/eycHV2a4kr/YrbVHbs2ZrQ0=;
	h=Date:To:From:Subject:From;
	b=UU3FVf/+aQ4ckxBzIDy3E94ao7J73upDt2BfdhvFQRqdqFwHex/1BxQw4SCQC6vD9
	 xn5/nT558dhu9dOHjLHpxw30p02R7TZgVs9gSxYrZdiHB8FLslHlZeMKppu9/4Tqr7
	 nJUFq0iA8RXXYF5g79JoUM4hAGQ6T+1lj2mntvi0=
Date: Wed, 17 Jan 2024 12:55:30 -0800
To: mm-commits@vger.kernel.org,yangjihong1@huawei.com,tglx@linutronix.de,rick.p.edgecombe@intel.com,pmladek@suse.com,peterz@infradead.org,paulmck@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mic@digikod.net,mhiramat@kernel.org,juerg.haefliger@canonical.com,jkl820.git@gmail.com,eric.devolder@oracle.com,dianders@chromium.org,davem@davemloft.net,chenzhongjin@huawei.com,anil.s.keshavamurthy@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240117205532.08BF7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch

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

kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch

