From: akpm@linux-foundation.org
Subject: + timersc-document-meaning-of-deferrable-timer.patch added to -mm tree
Date: Thu, 08 Jul 2010 15:19:46 -0700
Message-ID: <201007082219.o68MJkw8032379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926Ab0GHWT6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 18:19:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, tglx@linutronix.de


The patch titled
     timers.c: document meaning of deferrable timer
has been added to the -mm tree.  Its filename is
     timersc-document-meaning-of-deferrable-timer.patch

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
Subject: timers.c: document meaning of deferrable timer
From: J. Bruce Fields <bfields@citi.umich.edu>

Steal some text from 6e453a67510 "Add support for deferrable timers".  A
reader shouldn't have to dig through the git logs for the basic
description of a deferrable timer.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN kernel/timer.c~timersc-document-meaning-of-deferrable-timer kernel/timer.c
--- a/kernel/timer.c~timersc-document-meaning-of-deferrable-timer
+++ a/kernel/timer.c
@@ -90,8 +90,13 @@ static DEFINE_PER_CPU(struct tvec_base *
 
 /*
  * Note that all tvec_bases are 2 byte aligned and lower bit of
- * base in timer_list is guaranteed to be zero. Use the LSB for
- * the new flag to indicate whether the timer is deferrable
+ * base in timer_list is guaranteed to be zero. Use the LSB to
+ * indicate whether the timer is deferrable.
+ *
+ * A deferrable timer will work normally when the system is busy, but
+ * will not cause a CPU to come out of idle just to service it; instead,
+ * the timer will be serviced when the CPU eventually wakes up with a
+ * subsequent non-deferrable timer.
  */
 #define TBASE_DEFERRABLE_FLAG		(0x1)
 
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

linux-next.patch
timersc-document-meaning-of-deferrable-timer.patch
reiser4.patch

