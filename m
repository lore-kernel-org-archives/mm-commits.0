From: akpm@linux-foundation.org
Subject: + drivers-char-applicomc-fix-information-leak-to-userland.patch added to -mm tree
Date: Thu, 21 Oct 2010 14:10:18 -0700
Message-ID: <201010212110.o9LLAIGY003783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757952Ab0JUVKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 17:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com


The patch titled
     drivers/char/applicom.c: fix information leak to userland
has been added to the -mm tree.  Its filename is
     drivers-char-applicomc-fix-information-leak-to-userland.patch

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
Subject: drivers/char/applicom.c: fix information leak to userland
From: Vasiliy Kulikov <segooon@gmail.com>

Structure st_loc is copied to userland with some fields unitialized.  It
leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/applicom.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/applicom.c~drivers-char-applicomc-fix-information-leak-to-userland drivers/char/applicom.c
--- a/drivers/char/applicom.c~drivers-char-applicomc-fix-information-leak-to-userland
+++ a/drivers/char/applicom.c
@@ -566,6 +566,7 @@ static ssize_t ac_read (struct file *fil
 				struct mailbox mailbox;
 
 				/* Got a packet for us */
+				memset(&st_loc, 0, sizeof(st_loc));
 				ret = do_ac_read(i, buf, &st_loc, &mailbox);
 				spin_unlock_irqrestore(&apbs[i].mutex, flags);
 				set_current_state(TASK_RUNNING);
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
mm-mempolicy-check-return-code-of-check_range.patch
drivers-rtc-classc-fix-device_register-error-handling.patch
drivers-char-applicomc-fix-information-leak-to-userland.patch
char-hpet-fix-information-leak-to-userland.patch
char-ppdev-fix-information-leak-to-userland.patch
char-synclink_gt-fix-information-leak-to-userland.patch
memstick-core-fix-device_register-error-handling.patch

