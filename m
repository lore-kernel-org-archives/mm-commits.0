From: akpm@linux-foundation.org
Subject: + signals-check-group_stop_count-after-tracehook_get_signal.patch added to -mm tree
Date: Fri, 30 Oct 2009 15:51:50 -0700
Message-ID: <200910302251.n9UMpobZ003614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932983AbZJ3Ww2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 18:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     signals: check ->group_stop_count after tracehook_get_signal()
has been added to the -mm tree.  Its filename is
     signals-check-group_stop_count-after-tracehook_get_signal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: check ->group_stop_count after tracehook_get_signal()
From: Oleg Nesterov <oleg@redhat.com>

Move the call to do_signal_stop() down, after tracehook call.  This makes
->group_stop_count condition visible to tracers before do_signal_stop()
will participate in this group-stop.

Currently the patch has no effect, tracehook_get_signal() always returns 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/signal.c~signals-check-group_stop_count-after-tracehook_get_signal kernel/signal.c
--- a/kernel/signal.c~signals-check-group_stop_count-after-tracehook_get_signal
+++ a/kernel/signal.c
@@ -1810,11 +1810,6 @@ relock:
 
 	for (;;) {
 		struct k_sigaction *ka;
-
-		if (unlikely(signal->group_stop_count > 0) &&
-		    do_signal_stop(0))
-			goto relock;
-
 		/*
 		 * Tracing can induce an artifical signal and choose sigaction.
 		 * The return value in @signr determines the default action,
@@ -1826,6 +1821,10 @@ relock:
 		if (unlikely(signr != 0))
 			ka = return_ka;
 		else {
+			if (unlikely(signal->group_stop_count > 0) &&
+			    do_signal_stop(0))
+				goto relock;
+
 			signr = dequeue_signal(current, &current->blocked,
 					       info);
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch
signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch
signals-cosmetic-collect_signal-use-si_user.patch
signals-kill-force_sig_specific.patch
signals-check-group_stop_count-after-tracehook_get_signal.patch
utrace-core.patch

