Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924A31CD5DB
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719598204; cv=none; b=uplsGhaOwf+TglDixBrU1j5ejANiQpaqX9QjyVMGRPaIahA0p4Eaqyo61ki7rA4fKXxB/sZzZtgDZgitW8fEKiKzQXrIS6rIauajFOqBUHLgAb9nsYW+FNQGrUGfKhwGhi3QB3D32FO/W1YBLF3wmRFrtOf5b7HafZ75jAy1I2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719598204; c=relaxed/simple;
	bh=dKB8ZljEPQifWemmJ+Y4NA0vhow1HLrhImKegVG1F8U=;
	h=Date:To:From:Subject:Message-Id; b=uXfpDPM+gzOWYaIwwBEfbFB5o6rGZfq67qgQKKXv6P6MHShLO+eEiSbJ79EbXwtkuO7irnaMahLf9gLM+p3ZXFflz2f/Mdsu5IAYj8x3VKiU519gE3eB/p+iKIIY4eVy1vZq8jNxEXJ3RB+VXpdZ+tsucKCIqg8GsWvzdFZXESM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MfAVkvMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MfAVkvMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BA0C2BD10;
	Fri, 28 Jun 2024 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719598204;
	bh=dKB8ZljEPQifWemmJ+Y4NA0vhow1HLrhImKegVG1F8U=;
	h=Date:To:From:Subject:From;
	b=MfAVkvMMNmtbhwk6nEnkmVVQ9PQajCVFd7d83tu0THBhoNigetp9Qq4mXQLwthFXJ
	 ePjnyxxqcvX6j0DqVWYxUOUjYjFcOESrFQRB3i33dV+AEojzH47g+ag0IfQvHSonr5
	 ohq+fbLUubLUKaWvAjSQ7GVVPbpJCyQzn2vS4TGs=
Date: Fri, 28 Jun 2024 11:10:03 -0700
To: mm-commits@vger.kernel.org,vincent.whitchurch@axis.com,tandersen@netflix.com,oleg@redhat.com,minchan@google.com,mhocko@suse.com,liumartin@google.com,brauner@kernel.org,bigeasy@linutronix.de,ardb@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + signal-on-exit-skip-waiting-for-an-ack-from-the-tracer-if-it-is-frozen.patch added to mm-nonmm-unstable branch
Message-Id: <20240628181004.05BA0C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: signal: on exit skip waiting for an ack from the tracer if it is frozen
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     signal-on-exit-skip-waiting-for-an-ack-from-the-tracer-if-it-is-frozen.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/signal-on-exit-skip-waiting-for-an-ack-from-the-tracer-if-it-is-frozen.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: signal: on exit skip waiting for an ack from the tracer if it is frozen
Date: Fri, 28 Jun 2024 10:32:47 -0700

When a process is being killed or exiting and it has a tracer, it will
notify the tracer and wait for an ack from the tracer to proceed.  However
if the tracer is frozen, this ack will not arrive until the tracer gets
thawed.  This poses a problem especially during memory pressure because
resources of the process are not released.

Things become even more interesting if OOM killer picks such tracee and
adds it into oom_victims.  oom_victims counter will get incremented and
stay that way until tracee exits.  In the meantime, if the system tries to
go into suspend, it will call oom_killer_disable() after freezing all
processes.  That call will fail due to positive oom_victims, but not until
freeze_timeout_msecs passes.  For the whole duration of the
freeze_timeout_msecs (20sec by default) the system will appear
unresponsive.

To fix this problem, skip the ack waiting step in the tracee when it's
exiting and the tracer is frozen.  Per ptrace(2) manual, the tracer cannot
assume that the ptrace-stopped tracee exists.  Therefore this change does
not break any valid assumptions.

Link: https://lkml.kernel.org/r/20240628173247.3507846-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Debugged-by: Martin Liu <liumartin@google.com>
Debugged-by: Minchan Kim <minchan@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tycho Andersen <tandersen@netflix.com>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/signal.c~signal-on-exit-skip-waiting-for-an-ack-from-the-tracer-if-it-is-frozen
+++ a/kernel/signal.c
@@ -2321,6 +2321,19 @@ static int ptrace_stop(int exit_code, in
 		do_notify_parent_cldstop(current, false, why);
 
 	/*
+	 * If tracer is frozen, it won't ack until it gets unfrozen and if the
+	 * tracee is exiting this means its resources do not get freed until
+	 * the tracer is thawed. Skip waiting for the tracer. Per ptrace(2)
+	 * manual, the tracer cannot assume that the ptrace-stopped tracee
+	 * exists, so exiting now should not be an issue.
+	 */
+	if (current->ptrace && (exit_code >> 8) == PTRACE_EVENT_EXIT &&
+	    cgroup_task_frozen(current->parent)) {
+		read_unlock(&tasklist_lock);
+		goto skip_wait;
+	}
+
+	/*
 	 * The previous do_notify_parent_cldstop() invocation woke ptracer.
 	 * One a PREEMPTION kernel this can result in preemption requirement
 	 * which will be fulfilled after read_unlock() and the ptracer will be
@@ -2356,6 +2369,7 @@ static int ptrace_stop(int exit_code, in
 	schedule();
 	cgroup_leave_frozen(true);
 
+skip_wait:
 	/*
 	 * We are back.  Now reacquire the siglock before touching
 	 * last_siginfo, so that we are sure to have synchronized with
_

Patches currently in -mm which might be from surenb@google.com are

signal-on-exit-skip-waiting-for-an-ack-from-the-tracer-if-it-is-frozen.patch

