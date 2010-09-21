From: akpm@linux-foundation.org
Subject: + printk-add-lock-context-annotation.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:11:23 -0700
Message-ID: <201009212311.o8LNBN2U008386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab0IUXLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, mingo@elte.hu


The patch titled
     printk: add lock context annotation
has been added to the -mm tree.  Its filename is
     printk-add-lock-context-annotation.patch

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
Subject: printk: add lock context annotation
From: Namhyung Kim <namhyung@gmail.com>

acquire_console_semaphore_for_printk() releases logbuf_lock but
was missing proper annotation. Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/printk.c~printk-add-lock-context-annotation kernel/printk.c
--- a/kernel/printk.c~printk-add-lock-context-annotation
+++ a/kernel/printk.c
@@ -647,6 +647,7 @@ static inline int can_use_console(unsign
  * released but interrupts still disabled.
  */
 static int acquire_console_semaphore_for_printk(unsigned int cpu)
+	__releases(&logbuf_lock)
 {
 	int retval = 0;
 
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
init-mark-__user-address-space-on-string-literals.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

