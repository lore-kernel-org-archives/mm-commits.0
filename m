From: akpm@linux-foundation.org
Subject: + um-fix-global-timer-issue-when-using-config_no_hz.patch added to -mm tree
Date: Mon, 18 Oct 2010 13:05:33 -0700
Message-ID: <201010182005.o9IK5XAQ031341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756004Ab0JRUFr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Oct 2010 16:05:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, jdike@addtoit.com, penberg@kernel.org, stable@kernel.org


The patch titled
     um: fix global timer issue when using CONFIG_NO_HZ
has been added to the -mm tree.  Its filename is
     um-fix-global-timer-issue-when-using-config_no_hz.patch

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
Subject: um: fix global timer issue when using CONFIG_NO_HZ
From: Richard Weinberger <richard@nod.at>

This fixes a issue which was introduced by fe2cc53e ("uml: track and make
up lost ticks").

timeval_to_ns() returns long long and not int.  Due to that UML's timer
did not work properlt and caused timer freezes.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/os-Linux/time.c~um-fix-global-timer-issue-when-using-config_no_hz arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~um-fix-global-timer-issue-when-using-config_no_hz
+++ a/arch/um/os-Linux/time.c
@@ -60,7 +60,7 @@ static inline long long timeval_to_ns(co
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
-	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
+	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
hostfs-fix-uml-crash.patch
um-migrate-from-__do_irq-to-generic_handle_irq.patch
um-fix-global-timer-issue-when-using-config_no_hz.patch

