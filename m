From: akpm@linux-foundation.org
Subject: + posix_timer-remove-wrong-comment.patch added to -mm tree
Date: Thu, 20 May 2010 12:32:04 -0700
Message-ID: <201005201932.o4KJW4dB000383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754430Ab0ETTdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 15:33:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org, oleg@tv-sign.ru, sgruszka@redhat.com, tglx@linutronix.de, xemul@openvz.org


The patch titled
     posix_timer: remove wrong comment
has been added to the -mm tree.  Its filename is
     posix_timer-remove-wrong-comment.patch

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
Subject: posix_timer: remove wrong comment
From: Andrey Vagin <avagin@openvz.org>

Currently "The next step is hard to back out if there is an error."
comment is not right, release_posix_timer() does put_pid().

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/posix-timers.c~posix_timer-remove-wrong-comment kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix_timer-remove-wrong-comment
+++ a/kernel/posix-timers.c
@@ -563,10 +563,6 @@ SYSCALL_DEFINE3(timer_create, const cloc
 	if (error)
 		goto out;
 
-	/*
-	 * return the timer_id now.  The next step is hard to
-	 * back out if there is an error.
-	 */
 	if (copy_to_user(created_timer_id,
 			 &new_timer_id, sizeof (new_timer_id))) {
 		error = -EFAULT;
_

Patches currently in -mm which might be from avagin@openvz.org are

posix_timer-remove-wrong-comment.patch
posix_timer-fix-error-path-in-timer_create.patch
posix_timer-move-copy_to_usercreated_timer_id-down-in-timer_create.patch

