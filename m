From: akpm@linux-foundation.org
Subject: - fix-accidental-implicit-cast-in-hr-timer-conversion.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:34:32 -0800
Message-ID: <200811102034.mAAKYWqB025123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754998AbYKJUfa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:35:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, arjan@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimers: fix accidental implicit cast in HR-timer conversion
has been removed from the -mm tree.  Its filename was
     fix-accidental-implicit-cast-in-hr-timer-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
frv-use-the-new-byteorder-headers.patch
mutex-subsystem-synchro-test-module.patch

