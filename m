From: akpm@linux-foundation.org
Subject: + signals-cosmetic-collect_signal-use-si_user.patch added to -mm tree
Date: Fri, 16 Oct 2009 15:20:17 -0700
Message-ID: <200910162220.n9GMKHok000424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbZJPWUh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 18:20:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, sukadev@us.ibm.com


The patch titled
     signals: cosmetic, collect_signal: use SI_USER
has been added to the -mm tree.  Its filename is
     signals-cosmetic-collect_signal-use-si_user.patch

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
Subject: signals: cosmetic, collect_signal: use SI_USER
From: Oleg Nesterov <oleg@redhat.com>

Trivial, s/0/SI_USER/ in collect_signal() for grep.

This is a bit confusing, we don't know the source of this signal.
But we don't care, and "info->si_code = 0" is imho worse.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/signal.c~signals-cosmetic-collect_signal-use-si_user kernel/signal.c
--- a/kernel/signal.c~signals-cosmetic-collect_signal-use-si_user
+++ a/kernel/signal.c
@@ -400,7 +400,7 @@ still_pending:
 		 */
 		info->si_signo = sig;
 		info->si_errno = 0;
-		info->si_code = 0;
+		info->si_code = SI_USER;
 		info->si_pid = 0;
 		info->si_uid = 0;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
connector-fix-regression-introduced-by-sid-connector.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch
signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch
signals-cosmetic-collect_signal-use-si_user.patch
signals-kill-force_sig_specific.patch
utrace-core.patch

