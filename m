From: akpm@linux-foundation.org
Subject: + kill-sig-1-must-only-apply-to-callers-namespace.patch added to -mm tree
Date: Mon, 27 Oct 2008 14:58:28 -0700
Message-ID: <200810272158.m9RLwSLG014140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338AbYJ0V6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 17:58:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@linux.vnet.ibm.com, daniel@hozac.com, ebiederm@xmission.com, oleg@redhat.com


The patch titled
     'kill sig -1' must only apply to caller's namespace
has been added to the -mm tree.  Its filename is
     kill-sig-1-must-only-apply-to-callers-namespace.patch

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
Subject: 'kill sig -1' must only apply to caller's namespace
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Currently "kill <sig> -1" kills processes in all namespaces and breaks the
isolation of namespaces.  Earlier attempt to fix this was discussed at:

	http://lkml.org/lkml/2008/7/23/148

As suggested by Oleg Nesterov in that thread, use "task_pid_vnr() > 1"
check since task_pid_vnr() returns 0 if process is outside the caller's
namespace.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Tested-by: Daniel Hokka Zakrisson <daniel@hozac.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~kill-sig-1-must-only-apply-to-callers-namespace kernel/signal.c
--- a/kernel/signal.c~kill-sig-1-must-only-apply-to-callers-namespace
+++ a/kernel/signal.c
@@ -1144,7 +1144,8 @@ static int kill_something_info(int sig, 
 		struct task_struct * p;
 
 		for_each_process(p) {
-			if (p->pid > 1 && !same_thread_group(p, current)) {
+			if (task_pid_vnr(p) > 1 &&
+					!same_thread_group(p, current)) {
 				int err = group_send_sig_info(sig, info, p);
 				++count;
 				if (err != -EPERM)
_

Patches currently in -mm which might be from sukadev@linux.vnet.ibm.com are

kill-sig-1-must-only-apply-to-callers-namespace.patch
linux-next.patch

