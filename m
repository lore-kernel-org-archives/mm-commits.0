From: akpm@linux-foundation.org
Subject: + fix-accidental-implicit-cast-in-hr-timer-conversion.patch added to -mm tree
Date: Thu, 06 Nov 2008 16:35:14 -0800
Message-ID: <200811070035.mA70ZEhR018063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093AbYKGAgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 19:36:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hrtimers: fix accidental implicit cast in HR-timer conversion
has been added to the -mm tree.  Its filename is
     fix-accidental-implicit-cast-in-hr-timer-conversion.patch

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
Subject: hrtimers: fix accidental implicit cast in HR-timer conversion
From: David Howells <dhowells@redhat.com>

Fix the hrtimer_add_expires_ns() function.  It should take a 'u64 ns'
argument, but rather takes an 'unsigned long ns' argument - which might
only be 32-bits.

On FRV, this results in the kernel locking up because hrtimer_forward()
passes the result of a 64-bit multiplication to this function, for which
the compiler discards the top 32-bits - something that didn't happen when
ktime_add_ns() was called directly.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/hrtimer.h~fix-accidental-implicit-cast-in-hr-timer-conversion include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~fix-accidental-implicit-cast-in-hr-timer-conversion
+++ a/include/linux/hrtimer.h
@@ -239,7 +239,7 @@ static inline void hrtimer_add_expires(s
 	timer->_softexpires = ktime_add_safe(timer->_softexpires, time);
 }
 
-static inline void hrtimer_add_expires_ns(struct hrtimer *timer, unsigned long ns)
+static inline void hrtimer_add_expires_ns(struct hrtimer *timer, u64 ns)
 {
 	timer->_expires = ktime_add_ns(timer->_expires, ns);
 	timer->_softexpires = ktime_add_ns(timer->_softexpires, ns);
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
fix-accidental-implicit-cast-in-hr-timer-conversion.patch
mutex-subsystem-synchro-test-module.patch

