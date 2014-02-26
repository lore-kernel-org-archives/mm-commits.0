From: akpm@linux-foundation.org
Subject: +
 wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process.patch added to -mm tree
Date: Wed, 26 Feb 2014 15:45:06 -0800
Message-ID: <530e7c82.VZhFZt+rGM0NeRlq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaBZXpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:45:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@ZenIV.linux.org.uk, tj@kernel.org, roland@hack.frob.com, mschmidt@redhat.com, lpoetter@redhat.com, jan.kratochvil@redhat.com, oleg@redhat.com

Subject: + wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process.patch added to -mm tree
To: oleg@redhat.com,jan.kratochvil@redhat.com,lpoetter@redhat.com,mschmidt@redhat.com,roland@hack.frob.com,tj@kernel.org,viro@ZenIV.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:45:06 -0800


The patch titled
     Subject: wait: WSTOPPED|WCONTINUED doesn't work if a zombie leader is traced by another process
has been added to the -mm tree.  Its filename is
     wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: wait: WSTOPPED|WCONTINUED doesn't work if a zombie leader is traced by another process

Even if the main thread is dead the process still can stop/continue. 
However, if the leader is ptraced wait_consider_task(ptrace => false)
always skips wait_task_stopped/wait_task_continued, so WSTOPPED or
WCONTINUED can never work for the natural parent in this case.

Move the "A zombie ptracee is only visible to its ptracer" check into the
"if (!delay_group_leader(p))" block.  ->notask_error is cleared by the
"fall through" code below.

This depends on the previous change, wait_task_stopped/continued must be
avoided if !delay_group_leader() and the tracer is ->real_parent. 
Otherwise WSTOPPED|WEXITED could wrongly report "stopped" when the child
is already dead (single-threaded or not).  If it is traced by another task
then the "stopped" state is fine until the debugger detaches and reveals a
zombie state.

Stupid test-case:

	void *tfunc(void *arg)
	{
		sleep(1);	// wait for zombie leader
		raise(SIGSTOP);
		exit(0x13);
		return NULL;
	}

	int run_child(void)
	{
		pthread_t thread;

		if (!fork()) {
			int tracee = getppid();

			assert(ptrace(PTRACE_ATTACH, tracee, 0,0) == 0);
			do
				ptrace(PTRACE_CONT, tracee, 0,0);
			while (wait(NULL) > 0);

			return 0;
		}

		sleep(1);	// wait for PTRACE_ATTACH
		assert(pthread_create(&thread, NULL, tfunc, NULL) == 0);
		pthread_exit(NULL);
	}

	int main(void)
	{
		int child, stat;

		child = fork();
		if (!child)
			return run_child();

		assert(child == waitpid(-1, &stat, WSTOPPED));
		assert(stat == 0x137f);

		kill(child, SIGCONT);

		assert(child == waitpid(-1, &stat, WCONTINUED));
		assert(stat == 0xffff);

		assert(child == waitpid(-1, &stat, 0));
		assert(stat == 0x1300);

		return 0;
	}

Without this patch it hangs in waitpid(WSTOPPED), wait_task_stopped() is
never called.

Note: this doesn't fix all problems with a zombie delay_group_leader(),
WCONTINUED | WEXITED check is not exactly right.  debugger can't assume it
will be notified if another thread reaps the whole thread group.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Lennart Poettering <lpoetter@redhat.com>
Cc: Michal Schmidt <mschmidt@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN kernel/exit.c~wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process kernel/exit.c
--- a/kernel/exit.c~wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process
+++ a/kernel/exit.c
@@ -1382,20 +1382,16 @@ static int wait_consider_task(struct wai
 
 	/* slay zombie? */
 	if (p->exit_state == EXIT_ZOMBIE) {
-		/*
-		 * A zombie ptracee is only visible to its ptracer.
-		 * Notification and reaping will be cascaded to the real
-		 * parent when the ptracer detaches.
-		 */
-		if (likely(!ptrace) && unlikely(p->ptrace)) {
-			/* it will become visible, clear notask_error */
-			wo->notask_error = 0;
-			return 0;
-		}
-
 		/* we don't reap group leaders with subthreads */
-		if (!delay_group_leader(p))
-			return wait_task_zombie(wo, p);
+		if (!delay_group_leader(p)) {
+			/*
+			 * A zombie ptracee is only visible to its ptracer.
+			 * Notification and reaping will be cascaded to the
+			 * real parent when the ptracer detaches.
+			 */
+			if (unlikely(ptrace) || likely(!p->ptrace))
+				return wait_task_zombie(wo, p);
+		}
 
 		/*
 		 * Allow access to stopped/continued state via zombie by
_

Patches currently in -mm which might be from oleg@redhat.com are

kthread-ensure-locality-of-task_struct-allocations.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
exitc-call-proc_exit_connector-after-exit_state-is-set.patch
wait-fix-reparent_leader-vs-exit_dead-exit_zombie-race.patch
wait-introduce-exit_trace-to-avoid-the-racy-exit_dead-exit_zombie-transition.patch
wait-use-exit_trace-only-if-thread_group_leaderzombie.patch
wait-completely-ignore-the-exit_dead-tasks.patch
wait-swap-exit_zombie-and-exit_dead-to-hide-exit_trace-from-user-space.patch
wait-wstoppedwcontinued-hangs-if-a-zombie-child-is-traced-by-real_parent.patch
wait-wstoppedwcontinued-doesnt-work-if-a-zombie-leader-is-traced-by-another-process.patch
linux-next.patch

