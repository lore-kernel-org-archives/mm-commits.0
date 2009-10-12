From: akpm@linux-foundation.org
Subject: + rtc-fix-compile-failure-in-drivers-char-rtcc.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:29:35 -0700
Message-ID: <200910122229.n9CMTZiF010377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933485AbZJLWa7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:30:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dfeng@redhat.com, a.zummo@towertech.it, adobriyan@gmail.com, clem@clem.clem-digital.net, david-b@pacbell.net, xtfeng@gmail.com


The patch titled
     rtc: fix compile failure in drivers/char/rtc.c
has been added to the -mm tree.  Its filename is
     rtc-fix-compile-failure-in-drivers-char-rtcc.patch

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
Subject: rtc: fix compile failure in drivers/char/rtc.c
From: Xiaotian Feng <dfeng@redhat.com>

commit d43c36d ("headers: remove sched.h from interrupt.h") removed
sched.h from interrupt.h, this causes compile failure in
drivers/char/rtc.c.

Reported-by: Pete Clements <clem@clem.clem-digital.net>
Signed-of-by: Xiaotian Feng <xtfeng@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/rtc.c~rtc-fix-compile-failure-in-drivers-char-rtcc drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-fix-compile-failure-in-drivers-char-rtcc
+++ a/drivers/char/rtc.c
@@ -62,6 +62,7 @@
  */
 
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
_

Patches currently in -mm which might be from dfeng@redhat.com are

rtc-fix-compile-failure-in-drivers-char-rtcc.patch
linux-next.patch

