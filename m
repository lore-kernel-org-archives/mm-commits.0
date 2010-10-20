From: akpm@linux-foundation.org
Subject: + kernel-stop_machinec-fix-unused-variable-warning.patch added to -mm tree
Date: Wed, 20 Oct 2010 16:22:06 -0700
Message-ID: <201010202322.o9KNM694010685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467Ab0JTXWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Oct 2010 19:22:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, mingo@elte.hu


The patch titled
     kernel/stop_machine.c: fix unused variable warning
has been added to the -mm tree.  Its filename is
     kernel-stop_machinec-fix-unused-variable-warning.patch

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
Subject: kernel/stop_machine.c: fix unused variable warning
From: Rakib Mullick <rakib.mullick@gmail.com>

kernel/stop_machine.c: In function `cpu_stopper_thread':
kernel/stop_machine.c:265: warning: unused variable `ksym_buf'

ksym_buf[] is unused if WARN_ON() is a no-op.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/stop_machine.c~kernel-stop_machinec-fix-unused-variable-warning kernel/stop_machine.c
--- a/kernel/stop_machine.c~kernel-stop_machinec-fix-unused-variable-warning
+++ a/kernel/stop_machine.c
@@ -262,7 +262,7 @@ repeat:
 		cpu_stop_fn_t fn = work->fn;
 		void *arg = work->arg;
 		struct cpu_stop_done *done = work->done;
-		char ksym_buf[KSYM_NAME_LEN];
+		char ksym_buf[KSYM_NAME_LEN] __maybe_unused;
 
 		__set_current_state(TASK_RUNNING);
 
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
kernel-stop_machinec-fix-unused-variable-warning.patch

