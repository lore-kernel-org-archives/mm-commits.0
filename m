From: akpm@linux-foundation.org
Subject: + kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch added to -mm tree
Date: Wed, 06 Jul 2011 15:40:16 -0700
Message-ID: <201107062240.p66MeGAM004191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574Ab1GFWk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 18:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pyu@redhat.com, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     kernel/time.c: change jiffies_to_clock_t() input parameter's type to unsigned long
has been added to the -mm tree.  Its filename is
     kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch

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
Subject: kernel/time.c: change jiffies_to_clock_t() input parameter's type to unsigned long
From: hank <pyu@redhat.com>

The parameter's origin type is long.  On an i386 architecture, it can
easily be larger than 0x80000000, causing this function to convert it to a
sign-extended u64 type.  Change the type to unsigned long so we get the
correct result.

Signed-off-by: hank <pyu@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time.c~kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long kernel/time.c
--- a/kernel/time.c~kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long
+++ a/kernel/time.c
@@ -575,7 +575,7 @@ EXPORT_SYMBOL(jiffies_to_timeval);
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
  */
-clock_t jiffies_to_clock_t(long x)
+clock_t jiffies_to_clock_t(unsigned long x)
 {
 #if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
 # if HZ < USER_HZ
_

Patches currently in -mm which might be from pyu@redhat.com are

kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigned-long.patch

