Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FE4185955
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 04:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746938631; cv=none; b=S5ULL/R4h5/WCF+VydUIirH4SJ7aDLpmEL64E9MhNssIe1HhyfTpGYKrTpK6kvAVUfG7ui8000nZNes3J2qYPQ8K/b/bJcWfuXcPWRwBVdAGnBq0INMM6J4Enq0rEVN9LeXHP04CCgpm6tm2hQxuYgn0n/v9Z/9AQIhMIP6SU6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746938631; c=relaxed/simple;
	bh=s76333OhwUjKYcUcbOAgye8ROCcWzLuZVivK5owJcbc=;
	h=Date:To:From:Subject:Message-Id; b=GTH8ufIEk7iV1u2UuUwaT4Q4bTWLlo6jH1RmgQY5rjNKL1T7eHSPW6xZ0xqO8YaNkAPkg3nAwHeGmWunf+qOAWWbjyczCnkjX36NSrArlal4HJk9gqrjfBm4vCpL7AF+rS0QVwh0LFoMwsw3qZOrdp5BTlak8V2g0eD56rA6tg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jKyvJvV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jKyvJvV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F56C4CEE4;
	Sun, 11 May 2025 04:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746938630;
	bh=s76333OhwUjKYcUcbOAgye8ROCcWzLuZVivK5owJcbc=;
	h=Date:To:From:Subject:From;
	b=jKyvJvV/tj6Q72yS/79WildoH28fUckFANkaOWBv/A8NbSDLc0Z3qnmnRao7D7jcK
	 CiNpOnFbyMCp2CqT5ifImN7+k2PPODOeEuuzAsegEWgZoBJfYo2dRYq4g7u2HxPDY1
	 Y8UUeMLR3yd189KFBwnPFSGkBOONsCEA47JUje4g=
Date: Sat, 10 May 2025 21:43:49 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,joel.granados@kernel.org,brauner@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] exit-skip-irq-disabled-warning-during-power-off.patch removed from -mm tree
Message-Id: <20250511044350.62F56C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: exit: skip IRQ disabled warning during power off
has been removed from the -mm tree.  Its filename was
     exit-skip-irq-disabled-warning-during-power-off.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: exit: skip IRQ disabled warning during power off
Date: Thu, 03 Apr 2025 11:01:29 -0700

When the system is shutting down due to pid 1 exiting, which is common on
virtual machines, a warning message is printed.

	WARNING: CPU: 0 PID: 1 at kernel/exit.c:897 do_exit+0x7e3/0xab0

This occurs because do_exit() is called after kernel_power_off(), which
disables interrupts.  native_machine_shutdown() expliclty disable
interrupt to avoid receiving the timer interrupt, forcing scheduler load
balance during the power off phase.

This is the simplified code path:

	kernel_power_off()
	  - native_machine_shutdown()
	  	- local_irq_disable()
	do_exit()

Modify the warning condition in do_exit() to only trigger the warning if
the system is not powering off, since it is expected to have the irq
disabled in that case.

Link: https://lkml.kernel.org/r/20250403-exit-v1-1-8e9266bfc4b7@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/exit.c~exit-skip-irq-disabled-warning-during-power-off
+++ a/kernel/exit.c
@@ -893,7 +893,7 @@ void __noreturn do_exit(long code)
 	struct task_struct *tsk = current;
 	int group_dead;
 
-	WARN_ON(irqs_disabled());
+	WARN_ON(irqs_disabled() && system_state != SYSTEM_POWER_OFF);
 
 	synchronize_group_exit(tsk, code);
 
_

Patches currently in -mm which might be from leitao@debian.org are


