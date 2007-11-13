From: akpm@linux-foundation.org
Subject: + sigwait-eats-blocked-default-ignore-signals.patch added to -mm tree
Date: Mon, 12 Nov 2007 16:02:55 -0800
Message-ID: <200711130002.lAD02txg015475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55979 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbXKMADL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 19:03:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com


The patch titled
     sigwait eats blocked default-ignore signals
has been added to the -mm tree.  Its filename is
     sigwait-eats-blocked-default-ignore-signals.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sigwait eats blocked default-ignore signals
From: Roland McGrath <roland@redhat.com>

cf http://bugzilla.kernel.org/show_bug.cgi?id=9347

While a signal is blocked, it must be posted even if its action is SIG_IGN
or is SIG_DFL with the default action to ignore.  This works right most of
the time, but is broken when a sigwait (rt_sigtimedwait) is in progress. 
This changes the early-discard check to respect real_blocked.  ~blocked is
the set to check for "should wake up now", but ~(blocked|real_blocked) is
the set for "blocked" semantics as defined by POSIX.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~sigwait-eats-blocked-default-ignore-signals kernel/signal.c
--- a/kernel/signal.c~sigwait-eats-blocked-default-ignore-signals
+++ a/kernel/signal.c
@@ -55,7 +55,7 @@ static int sig_ignored(struct task_struc
 	 * signal handler may change by the time it is
 	 * unblocked.
 	 */
-	if (sigismember(&t->blocked, sig))
+	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
 	/* Is it explicitly or implicitly ignored? */
_

Patches currently in -mm which might be from roland@redhat.com are

get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
sigwait-eats-blocked-default-ignore-signals.patch
i386-and-x86_64-randomize-brk.patch
i386-and-x86_64-randomize-brk-fix.patch
i386-and-x86_64-randomize-brk-fix-2.patch
x86_64-ia32-ptrace-thread_area-fix.patch
x86-32-bit-ptrace-emulation-mishandles-6th-arg.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
