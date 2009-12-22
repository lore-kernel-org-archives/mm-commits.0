From: akpm@linux-foundation.org
Subject: + prctl-return-timerslack-through-pointer.patch added to -mm tree
Date: Tue, 22 Dec 2009 13:50:47 -0800
Message-ID: <200912222150.nBMLolfT026454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbZLVVvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 16:51:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geoffx.smith@intel.com, arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     prctl: return timerslack through pointer
has been added to the -mm tree.  Its filename is
     prctl-return-timerslack-through-pointer.patch

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
Subject: prctl: return timerslack through pointer
From: "Smith, GeoffX" <geoffx.smith@intel.com>

Fix the semantics of prctl() option PR_GET_TIMERSLACK to pass the return
value through *arg2.

With this change, the option now follows the same conventions as the other
"get" options added since 2.6.0, and also brings it into conformance with
the advice in chapter 16 of Documentation/CodingStyle.

In addition, it effectively doubles the range of time slack to 4.29
seconds (on a 32-bit architecture).

The timer slack feature was only added in Sep 2009 (new in 2.6.32.1), so
there are not any production applications to break.  I have also repaired
some unmatched signed/unsigned mismatches in timer slack calculations.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c  |    8 ++++----
 kernel/sys.c |    3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/select.c~prctl-return-timerslack-through-pointer fs/select.c
--- a/fs/select.c~prctl-return-timerslack-through-pointer
+++ a/fs/select.c
@@ -44,10 +44,10 @@
 
 #define MAX_SLACK	(100 * NSEC_PER_MSEC)
 
-static long __estimate_accuracy(struct timespec *tv)
+static unsigned long __estimate_accuracy(struct timespec *tv)
 {
-	long slack;
-	int divfactor = 1000;
+	unsigned long slack;
+	unsigned int divfactor = 1000;
 
 	if (tv->tv_sec < 0)
 		return 0;
@@ -67,7 +67,7 @@ static long __estimate_accuracy(struct t
 	return slack;
 }
 
-static long estimate_accuracy(struct timespec *tv)
+static unsigned long estimate_accuracy(struct timespec *tv)
 {
 	unsigned long ret;
 	struct timespec now;
diff -puN kernel/sys.c~prctl-return-timerslack-through-pointer kernel/sys.c
--- a/kernel/sys.c~prctl-return-timerslack-through-pointer
+++ a/kernel/sys.c
@@ -1638,7 +1638,8 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			error = perf_event_task_enable();
 			break;
 		case PR_GET_TIMERSLACK:
-			error = current->timer_slack_ns;
+			error = put_user(current->timer_slack_ns,
+				(unsigned long __user *)arg2);
 			break;
 		case PR_SET_TIMERSLACK:
 			if (arg2 <= 0)
_

Patches currently in -mm which might be from geoffx.smith@intel.com are

prctl-return-timerslack-through-pointer.patch

