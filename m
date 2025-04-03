Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2779533997
	for <mm-commits@vger.kernel.org>; Thu,  3 Apr 2025 21:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715090; cv=none; b=WVqfJQKwtlPzTXjnD0YG2lAET73LkDcRJ4lvjBPcRXvi7HgwrV660ULUIBtOi9mvgRRIRIUFQhiCemBzs+6PvUenm1rBWTTXFhg52RxDnemoB0LJObSZPkglKNEhhiuyU3zo2n2w+ReiTjeLtb8mK306k2iz7J7rGfCih+Yzt5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715090; c=relaxed/simple;
	bh=b3dbQpRdN36kYKpajUI53mPdTdD7X6IMZXHqv3XJ02w=;
	h=Date:To:From:Subject:Message-Id; b=k9QVK2BdSayRTWp61Ce+XF8LzozpcXB0Ppl9/gox7KZD5c8djWF2pVeu3iWJs4hOgtjna+nqumja8t1djESrkdR1SYjjSf0BdySVEDk6z20XLGKba0zvX4vPQsaaG6cS9tz/y4f6AaqTJliM2VAfbAGkPMi4LnE10gStwawiL00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fK7Z4msH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fK7Z4msH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF61C4CEE3;
	Thu,  3 Apr 2025 21:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743715089;
	bh=b3dbQpRdN36kYKpajUI53mPdTdD7X6IMZXHqv3XJ02w=;
	h=Date:To:From:Subject:From;
	b=fK7Z4msH8I+rElqyh+Gt9ZtyW4qkDQh5uoJ+iBQVTQehcww2GB9+t/cnLwUvgmu0T
	 vjkBfsCifWyUjFbSYCiNUpBcGjQOvTWArV8U0XwoE1H/YBaJL4fTGe6dZ3ak3RyvZo
	 fQ6vSx2HbyY0xF9YLWFm+N3Gs6s/1F2f1EJ3hfF0=
Date: Thu, 03 Apr 2025 14:18:09 -0700
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,joel.granados@kernel.org,brauner@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + exit-skip-irq-disabled-warning-during-power-off.patch added to mm-nonmm-unstable branch
Message-Id: <20250403211809.CBF61C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: exit: skip IRQ disabled warning during power off
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     exit-skip-irq-disabled-warning-during-power-off.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/exit-skip-irq-disabled-warning-during-power-off.patch

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
@@ -894,7 +894,7 @@ void __noreturn do_exit(long code)
 	struct task_struct *tsk = current;
 	int group_dead;
 
-	WARN_ON(irqs_disabled());
+	WARN_ON(irqs_disabled() && system_state != SYSTEM_POWER_OFF);
 
 	synchronize_group_exit(tsk, code);
 
_

Patches currently in -mm which might be from leitao@debian.org are

exit-skip-irq-disabled-warning-during-power-off.patch

