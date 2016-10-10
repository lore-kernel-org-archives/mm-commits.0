From: akpm@linux-foundation.org
Subject: [merged]
 jiffies-add-time-comparison-functions-for-64-bit-jiffies.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:42:27 -0700
Message-ID: <57fc1953.c/N2T5tTBja4Y/0M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36581 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752183AbcJJWnj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Jason@zx2c4.com, john.stultz@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: jiffies: add time comparison functions for 64 bit jiffies
has been removed from the -mm tree.  Its filename was
     jiffies-add-time-comparison-functions-for-64-bit-jiffies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: jiffies: add time comparison functions for 64 bit jiffies

Though the time_before and time_after family of functions were nicely
extended to support jiffies64, so that the interface would be consistent,
it was forgotten to also extend the before/after jiffies functions to
support jiffies64.  This commit brings the interface to parity between
jiffies and jiffies64, which is quite convenient.

Link: http://lkml.kernel.org/r/20160929033319.12188-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/jiffies.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/jiffies.h~jiffies-add-time-comparison-functions-for-64-bit-jiffies include/linux/jiffies.h
--- a/include/linux/jiffies.h~jiffies-add-time-comparison-functions-for-64-bit-jiffies
+++ a/include/linux/jiffies.h
@@ -150,15 +150,19 @@ static inline u64 get_jiffies_64(void)
 
 /* time_is_before_jiffies(a) return true if a is before jiffies */
 #define time_is_before_jiffies(a) time_after(jiffies, a)
+#define time_is_before_jiffies64(a) time_after64(get_jiffies_64(), a)
 
 /* time_is_after_jiffies(a) return true if a is after jiffies */
 #define time_is_after_jiffies(a) time_before(jiffies, a)
+#define time_is_after_jiffies64(a) time_before64(get_jiffies_64(), a)
 
 /* time_is_before_eq_jiffies(a) return true if a is before or equal to jiffies*/
 #define time_is_before_eq_jiffies(a) time_after_eq(jiffies, a)
+#define time_is_before_eq_jiffies64(a) time_after_eq64(get_jiffies_64(), a)
 
 /* time_is_after_eq_jiffies(a) return true if a is after or equal to jiffies*/
 #define time_is_after_eq_jiffies(a) time_before_eq(jiffies, a)
+#define time_is_after_eq_jiffies64(a) time_before_eq64(get_jiffies_64(), a)
 
 /*
  * Have the 32 bit jiffies value wrap 5 minutes after boot
_

Patches currently in -mm which might be from Jason@zx2c4.com are


