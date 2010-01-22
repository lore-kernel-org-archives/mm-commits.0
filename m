From: akpm@linux-foundation.org
Subject: + posix-timersc-dont-export-local-functions.patch added to -mm tree
Date: Fri, 22 Jan 2010 15:03:54 -0800
Message-ID: <201001222303.o0MN3sjl001440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab0AVXED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jan 2010 18:04:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com, tglx@linutronix.de


The patch titled
     posix-timers.c: don't export local functions
has been added to the -mm tree.  Its filename is
     posix-timersc-dont-export-local-functions.patch

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
Subject: posix-timers.c: don't export local functions
From: H Hartley Sweeten <hartleys@visionengravers.com>

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/posix-timers.c~posix-timersc-dont-export-local-functions kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timersc-dont-export-local-functions
+++ a/kernel/posix-timers.c
@@ -256,7 +256,7 @@ static int posix_get_monotonic_coarse(cl
 	return 0;
 }
 
-int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
+static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
 {
 	*tp = ktime_to_timespec(KTIME_LOW_RES);
 	return 0;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
posix-timersc-dont-export-local-functions.patch
scsi-sdc-quiet-all-sparse-noise.patch
init-initramfsc-fix-symbol-shadows-an-earlier-one-noise.patch
nodemaskh-remove-macro-any_online_node.patch
init-mainc-make-setup_max_cpus-static-for-smp.patch

