Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A14417547
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 16:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727282955; cv=none; b=IoWzsNly3Y0Io0GCvzubS8Q2axmBxbGqLKzkUbW+K3UzM3fQi5o0VXZamNA1lX54hEllAXiso49kaKltweiyWLiTlF1Fxzebhn6jLg3OwT4DvIRtuvSM8W8OtXp+worztlePmimY7vYaNwzhSrkCb/1rw0dr5BNkmRrlNJOx02M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727282955; c=relaxed/simple;
	bh=kYCHsQCn1TY85D9B+TAdgTpVmO/jQeI66Etr4WC2Tto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TodLE7vDI+73FN+MdTGz3h/UewRUIRMpU0xVO5Kri2OZMe/SdSs9XbC1R6x1/cuyghNKSyrp9GwtK3ZagcoMdKm6vOClD3XT4mAeBVUNi1f9rWw09Et+g+IpQj6g8j1p2Q4/2ZeHTWFMb2gwzp3qghfU9nPRMldJR4Q9teFAri4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKLikgyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKLikgyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BC4C4CEC3;
	Wed, 25 Sep 2024 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727282954;
	bh=kYCHsQCn1TY85D9B+TAdgTpVmO/jQeI66Etr4WC2Tto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gKLikgyr+LPVRpRqvN090Bh/v6yP/YBJMui3Pqkl+umwsakkJ7l3gRGQBBx5UpvzC
	 YXe4ovyeD+X1uUeziygCzaAECC8cLNM7x7yerJSXFtmZPoTnCUfr16C03TK7klCGOO
	 6ODNZOd0UMeqezCRQ/0Prv6PYduGw91qQut2iaKGOfHr/UkeO7Hknt5xTmKB8bscja
	 9zhULzwoLyLknQihvzpQ+qH0QDBDfzzphrng/JAt9E7mARSzB4G5KBCsZzoqD90Sb8
	 c9cSxIL7RPNjjeiIHl9fwj1Ioh5OeL7dm0aMkociwqDhx06DNYg6TCux9EJJKrBCsX
	 XsS09JXwJQtmQ==
Date: Wed, 25 Sep 2024 18:49:11 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
	ankur.a.arora@oracle.com, goldside000@outlook.com
Subject: Re: + irq_work-replace-wait-loop-with-rcuwait_wait_event.patch added
 to mm-nonmm-unstable branch
Message-ID: <ZvQ_BxuHmthSqXk_@localhost.localdomain>
References: <20240925001337.6E2A0C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240925001337.6E2A0C4CEC4@smtp.kernel.org>

Le Tue, Sep 24, 2024 at 05:13:36PM -0700, Andrew Morton a écrit :
> 
> The patch titled
>      Subject: irq_work: replace wait loop with rcuwait_wait_event
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      irq_work-replace-wait-loop-with-rcuwait_wait_event.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/irq_work-replace-wait-loop-with-rcuwait_wait_event.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Steven Davis <goldside000@outlook.com>
> Subject: irq_work: replace wait loop with rcuwait_wait_event
> Date: Thu, 19 Sep 2024 11:43:26 -0400
> 
> The previous implementation of irq_work_sync used a busy-wait loop with
> cpu_relax() to check the status of IRQ work.  This approach, while
> functional, could lead to inefficiencies in CPU usage.
> 
> This commit replaces the busy-wait loop with the rcuwait_wait_event
> mechanism.  This change leverages the RCU wait mechanism to handle waiting
> for IRQ work completion more efficiently, improving CPU responsiveness and
> reducing unnecessary CPU usage.
> 
> Link: https://lkml.kernel.org/r/SJ2P223MB10267BCF19A4A37747A52330F7632@SJ2P223MB1026.NAMP223.PROD.OUTLOOK.COM
> Signed-off-by: Steven Davis <goldside000@outlook.com>
> Cc: Ankur Arora <ankur.a.arora@oracle.com>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/irq_work.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/kernel/irq_work.c~irq_work-replace-wait-loop-with-rcuwait_wait_event
> +++ a/kernel/irq_work.c
> @@ -295,8 +295,7 @@ void irq_work_sync(struct irq_work *work
>  		return;
>  	}
>  
> -	while (irq_work_is_busy(work))
> -		cpu_relax();
> +	rcuwait_wait_event(&work->irqwait, !irq_work_is_busy(work), TASK_UNINTERRUPTIBLE);

This misses the wake_up part and also the PREEMPT_RT special case cleanup.
It should be something like the below untested (we could also benefit from the
successful atomic_cmpxchg() implicit smp_mb() and provide an unordered version
of rcuwait_wake_up() but that's for later):

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 2f4fb336dda1..0962ec749dbc 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -227,9 +227,7 @@ void irq_work_single(void *arg)
 	 */
 	(void)atomic_cmpxchg(&work->node.a_flags, flags, flags & ~IRQ_WORK_BUSY);
 
-	if ((IS_ENABLED(CONFIG_PREEMPT_RT) && !irq_work_is_hard(work)) ||
-	    !arch_irq_work_has_interrupt())
-		rcuwait_wake_up(&work->irqwait);
+	rcuwait_wake_up(&work->irqwait);
 }
 
 static void irq_work_run_list(struct llist_head *list)
@@ -288,15 +286,7 @@ void irq_work_sync(struct irq_work *work)
 	lockdep_assert_irqs_enabled();
 	might_sleep();
 
-	if ((IS_ENABLED(CONFIG_PREEMPT_RT) && !irq_work_is_hard(work)) ||
-	    !arch_irq_work_has_interrupt()) {
-		rcuwait_wait_event(&work->irqwait, !irq_work_is_busy(work),
-				   TASK_UNINTERRUPTIBLE);
-		return;
-	}
-
-	while (irq_work_is_busy(work))
-		cpu_relax();
+	rcuwait_wait_event(&work->irqwait, !irq_work_is_busy(work), TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
