Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC751D5ADC
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 18:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727290772; cv=none; b=H4dLnKdeBNZMa6qOmhEVnLAPxOHun7DXQZPkuKuHeXCOx3crOOETICJL8x82nu3ZJbFmfrF385U796DWCNekotWem5kidu49/JgSdKdXfGsmTmJnw6Subf3etDFNLhcNmgKL992MiGlt+XDY8U81KgOerePg0r/eqNFB4tySOnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727290772; c=relaxed/simple;
	bh=nsunhO8h2QJ77rG6YQVxTDfDls/T4coL8057I2jDHEk=;
	h=Date:To:From:Subject:Message-Id; b=REzav4eARvEOkrTbrS8pLqA0XKM6Nl2OCbej7hdq+21JUAw5mveV32x4fTl1QweZbr6J28RK20IRx4sqXgJQCWDlVM5wKQDEY7GTANx10W2GN0yVU/UcJiPLyePzsEuLOJhhhWmaQWymvanC5qf5l9EAJl14NGN0cOBH1rnP9b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JM9+yo4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JM9+yo4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92EEC4CEC3;
	Wed, 25 Sep 2024 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727290771;
	bh=nsunhO8h2QJ77rG6YQVxTDfDls/T4coL8057I2jDHEk=;
	h=Date:To:From:Subject:From;
	b=JM9+yo4ZezllPBBWwcKJCxflMs170ybTyNZj6jLDKetX84rh4AdoBkRS/vCP080Mm
	 8kUXVoFtH4BkOPSwYZ5EpKvbAStfLXnIg95yvITLg5VbRnWZdvSjlWbIMnZPv4RNI3
	 fz8onNB4Ezc9MMOWCZv9Cc36KStEi0PkqQIlEaig=
Date: Wed, 25 Sep 2024 11:59:31 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,frederic@kernel.org,ankur.a.arora@oracle.com,goldside000@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] irq_work-replace-wait-loop-with-rcuwait_wait_event.patch removed from -mm tree
Message-Id: <20240925185931.A92EEC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: irq_work: replace wait loop with rcuwait_wait_event
has been removed from the -mm tree.  Its filename was
     irq_work-replace-wait-loop-with-rcuwait_wait_event.patch

This patch was dropped because an updated version will be issued

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


