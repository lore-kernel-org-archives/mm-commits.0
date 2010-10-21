From: akpm@linux-foundation.org
Subject: + drivers-char-ppdevc-fix-information-leak-to-userland.patch added to -mm tree
Date: Thu, 21 Oct 2010 14:12:13 -0700
Message-ID: <201010212112.o9LLCDrF003952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab0JUVMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 17:12:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segooon@gmail.com


The patch titled
     drivers/char/ppdev.c: fix information leak to userland
has been added to the -mm tree.  Its filename is
     drivers-char-ppdevc-fix-information-leak-to-userland.patch

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
Subject: drivers/char/ppdev.c: fix information leak to userland
From: Vasiliy Kulikov <segooon@gmail.com>

Structure par_timeout is copied to userland with some padding fields
unitialized.  Field tv_usec has type __kernel_suseconds_t, it differs from
tv_sec's type on some architectures.  It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ppdev.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/ppdev.c~drivers-char-ppdevc-fix-information-leak-to-userland drivers/char/ppdev.c
--- a/drivers/char/ppdev.c~drivers-char-ppdevc-fix-information-leak-to-userland
+++ a/drivers/char/ppdev.c
@@ -613,6 +613,7 @@ static int pp_do_ioctl(struct file *file
 
 	case PPGETTIME:
 		to_jiffies = pp->pdev->timeout;
+		memset(&par_timeout, 0, sizeof(par_timeout));
 		par_timeout.tv_sec = to_jiffies / HZ;
 		par_timeout.tv_usec = (to_jiffies % (long)HZ) * (1000000/HZ);
 		if (copy_to_user (argp, &par_timeout, sizeof(struct timeval)))
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
mm-mempolicy-check-return-code-of-check_range.patch
drivers-rtc-classc-fix-device_register-error-handling.patch
drivers-char-applicomc-fix-information-leak-to-userland.patch
drivers-char-hpetc-fix-information-leak-to-userland.patch
drivers-char-hpetc-fix-information-leak-to-userland-fix.patch
drivers-char-ppdevc-fix-information-leak-to-userland.patch
drivers-char-synclink_gtc-fix-information-leak-to-userland.patch
memstick-core-fix-device_register-error-handling.patch

