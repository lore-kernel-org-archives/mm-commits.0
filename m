Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAD6367
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727223218; cv=none; b=aBCg6Zor9FBuMmPYaGLHrjYfenuqUZCT1cnuZSHozrb1AcEZEYQYtWoeYx6pg9+glxXdFsTcOlNAfm7OJ7JItkjaVcE3orKwy3h360kZrVh/vKHOU25maYF2IQt9zMmVv9jl5mCdDYmKVOgJpUo6ZQveuNT8eNHnBops+KlxQ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727223218; c=relaxed/simple;
	bh=BHxvHLFPDOGdHNzjxNK5ByWv9ImygexisPJ6dYQVOeQ=;
	h=Date:To:From:Subject:Message-Id; b=OEr5jdqVeO38NXHdsfNEOtyGYdgk03h0Ustoz0nz96T2XHvxtqzK+6TZHGzxDLHWB+krDmtG/nQivwfFz/LCxuKKyRSjVf0FUAhk52W8dTqdL+DQA4xi0wMit2wgaurGzvWKyF153ZstobZB0ntkc1sfOb9yxt6xXipKY60C4E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ftUYHTyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ftUYHTyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2A0C4CEC4;
	Wed, 25 Sep 2024 00:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727223217;
	bh=BHxvHLFPDOGdHNzjxNK5ByWv9ImygexisPJ6dYQVOeQ=;
	h=Date:To:From:Subject:From;
	b=ftUYHTyH0eArpaNJDTXBC3SiAG9wFFc+DhibhNRZf26Eld9OYeF7HXHV0IZLy4sJB
	 U0efYxxYS1osOFhx+Yh9LEqnmST5splbC8HjdfHzp1F4VCrEuSjcDUXXyd/mvcbwII
	 D5T6+vAjoKMFR/jgPsCjOajgmQTctPGeKsZ1v1JQ=
Date: Tue, 24 Sep 2024 17:13:36 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,frederic@kernel.org,ankur.a.arora@oracle.com,goldside000@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + irq_work-replace-wait-loop-with-rcuwait_wait_event.patch added to mm-nonmm-unstable branch
Message-Id: <20240925001337.6E2A0C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: irq_work: replace wait loop with rcuwait_wait_event
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     irq_work-replace-wait-loop-with-rcuwait_wait_event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/irq_work-replace-wait-loop-with-rcuwait_wait_event.patch

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
From: Steven Davis <goldside000@outlook.com>
Subject: irq_work: replace wait loop with rcuwait_wait_event
Date: Thu, 19 Sep 2024 11:43:26 -0400

The previous implementation of irq_work_sync used a busy-wait loop with
cpu_relax() to check the status of IRQ work.  This approach, while
functional, could lead to inefficiencies in CPU usage.

This commit replaces the busy-wait loop with the rcuwait_wait_event
mechanism.  This change leverages the RCU wait mechanism to handle waiting
for IRQ work completion more efficiently, improving CPU responsiveness and
reducing unnecessary CPU usage.

Link: https://lkml.kernel.org/r/SJ2P223MB10267BCF19A4A37747A52330F7632@SJ2P223MB1026.NAMP223.PROD.OUTLOOK.COM
Signed-off-by: Steven Davis <goldside000@outlook.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq_work.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/irq_work.c~irq_work-replace-wait-loop-with-rcuwait_wait_event
+++ a/kernel/irq_work.c
@@ -295,8 +295,7 @@ void irq_work_sync(struct irq_work *work
 		return;
 	}
 
-	while (irq_work_is_busy(work))
-		cpu_relax();
+	rcuwait_wait_event(&work->irqwait, !irq_work_is_busy(work), TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
 
_

Patches currently in -mm which might be from goldside000@outlook.com are

irq_work-replace-wait-loop-with-rcuwait_wait_event.patch

