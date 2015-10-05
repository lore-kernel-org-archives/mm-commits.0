From: akpm@linux-foundation.org
Subject: + change-current_is_single_threaded-to-use-for_each_thread.patch
 added to -mm tree
Date: Mon, 05 Oct 2015 13:52:43 -0700
Message-ID: <5612e31b.xAyAztDb9U0OCZp7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbbJEUwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 16:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/is_single_threaded.c: change current_is_single_threaded() to use for_each_thread()
has been added to the -mm tree.  Its filename is
     change-current_is_single_threaded-to-use-for_each_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/change-current_is_single_threaded-to-use-for_each_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/change-current_is_single_threaded-to-use-for_each_thread.patch

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
Subject: lib/is_single_threaded.c: change current_is_single_threaded() to use for_each_thread()

Change current_is_single_threaded() to use for_each_thread() rather than
deprecated while_each_thread().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/is_single_threaded.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/is_single_threaded.c~change-current_is_single_threaded-to-use-for_each_thread lib/is_single_threaded.c
--- a/lib/is_single_threaded.c~change-current_is_single_threaded-to-use-for_each_thread
+++ a/lib/is_single_threaded.c
@@ -36,8 +36,7 @@ bool current_is_single_threaded(void)
 		if (unlikely(p == task->group_leader))
 			continue;
 
-		t = p;
-		do {
+		for_each_thread(p, t) {
 			if (unlikely(t->mm == mm))
 				goto found;
 			if (likely(t->mm))
@@ -48,7 +47,7 @@ bool current_is_single_threaded(void)
 			 * forked before exiting.
 			 */
 			smp_rmb();
-		} while_each_thread(p, t);
+		}
 	}
 	ret = true;
 found:
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
mm-oom_kill-remove-the-wrong-fatal_signal_pending-check-in-oom_kill_process.patch
mm-oom_kill-cleanup-the-kill-sharing-same-memory-loop.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

