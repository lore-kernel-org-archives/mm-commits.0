From: akpm@linux-foundation.org
Subject: + proc-fix-reported-unit-for-rlimit_cpu.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:06:14 -0700
Message-ID: <200907212306.n6LN6EjU005882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756167AbZGUXGp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:06:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kees.cook@canonical.com, nhorman@tuxdriver.com, xiyou.wangcong@gmail.com


The patch titled
     proc: fix reported unit for RLIMIT_CPU
has been added to the -mm tree.  Its filename is
     proc-fix-reported-unit-for-rlimit_cpu.patch

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
Subject: proc: fix reported unit for RLIMIT_CPU
From: Kees Cook <kees.cook@canonical.com>

/proc/$pid/limits should show RLIMIT_CPU as seconds, which is the unit
used in kernel/posix-cpu-timers.c:

        unsigned long psecs = cputime_to_secs(ptime);
        ...
        if (psecs >= sig->rlim[RLIMIT_CPU].rlim_max) {
                ...
                __group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-fix-reported-unit-for-rlimit_cpu fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-reported-unit-for-rlimit_cpu
+++ a/fs/proc/base.c
@@ -460,7 +460,7 @@ struct limit_names {
 };
 
 static const struct limit_names lnames[RLIM_NLIMITS] = {
-	[RLIMIT_CPU] = {"Max cpu time", "ms"},
+	[RLIMIT_CPU] = {"Max cpu time", "seconds"},
 	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
 	[RLIMIT_DATA] = {"Max data size", "bytes"},
 	[RLIMIT_STACK] = {"Max stack size", "bytes"},
_

Patches currently in -mm which might be from kees.cook@canonical.com are

linux-next.patch
proc-fix-reported-unit-for-rlimit_cpu.patch

