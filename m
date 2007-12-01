From: akpm@linux-foundation.org
Subject: - wait_task_stopped-pass-correct-exit_code-to.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:24:07 -0800
Message-ID: <200712010024.lB10O7sE032041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757939AbXLAA2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:28:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scott@ubuntu.com, oleg@tv-sign.ru, roland@redhat.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     wait_task_stopped(): pass correct exit_code to wait_noreap_copyout()
has been removed from the -mm tree.  Its filename was
     wait_task_stopped-pass-correct-exit_code-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: wait_task_stopped(): pass correct exit_code to wait_noreap_copyout()
From: Scott James Remnant <scott@ubuntu.com>

In wait_task_stopped() exit_code already contains the right value for the
si_status member of siginfo, and this is simply set in the non WNOWAIT
case.

If you call waitid() with a stopped or traced process, you'll get the signal
in siginfo.si_status as expected -- however if you call waitid(WNOWAIT) at the
same time, you'll get the signal << 8 | 0x7f

Pass it unchanged to wait_noreap_copyout(); we would only need to shift it
and add 0x7f if we were returning it in the user status field and that
isn't used for any function that permits WNOWAIT.

Signed-off-by: Scott James Remnant <scott@ubuntu.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~wait_task_stopped-pass-correct-exit_code-to kernel/exit.c
--- a/kernel/exit.c~wait_task_stopped-pass-correct-exit_code-to
+++ a/kernel/exit.c
@@ -1388,7 +1388,7 @@ static int wait_task_stopped(struct task
 		if (unlikely(!exit_code) || unlikely(p->exit_state))
 			goto bail_ref;
 		return wait_noreap_copyout(p, pid, uid,
-					   why, (exit_code << 8) | 0x7f,
+					   why, exit_code,
 					   infop, ru);
 	}
 
_

Patches currently in -mm which might be from scott@ubuntu.com are

origin.patch
