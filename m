From: akpm@linux-foundation.org
Subject: [merged] iopoll-avoid-wint-in-bool-context-warning.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:23:27 -0800
Message-ID: <20171120212327.1h1RjdZ1-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbdKTVX2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:23:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, broonie@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: iopoll: avoid -Wint-in-bool-context warning
has been removed from the -mm tree.  Its filename was
     iopoll-avoid-wint-in-bool-context-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: iopoll: avoid -Wint-in-bool-context warning

When we pass the result of a multiplication as the timeout or the delay,
we can get a warning from gcc-7:

drivers/mmc/host/bcm2835.c:596:149: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/mfd/arizona-core.c:247:195: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/gpu/drm/sun4i/sun4i_hdmi_i2c.c:49:27: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]

The warning is a bit questionable inside of a macro, but this is
intentional on the side of the gcc developers.  It is also an indication
of another problem: we evaluate the timeout and sleep arguments multiple
times, which can have undesired side-effects when those are complex
expressions.

This changes the two iopoll variants to use local variables for storing
copies of the timeouts.  This adds some more type safety, and avoids both
the double-evaluation and the gcc warning.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81484
Link: http://lkml.kernel.org/r/20170726133756.2161367-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/20171102114048.1526955-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iopoll.h |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN include/linux/iopoll.h~iopoll-avoid-wint-in-bool-context-warning include/linux/iopoll.h
--- a/include/linux/iopoll.h~iopoll-avoid-wint-in-bool-context-warning
+++ a/include/linux/iopoll.h
@@ -42,18 +42,21 @@
  */
 #define readx_poll_timeout(op, addr, val, cond, sleep_us, timeout_us)	\
 ({ \
-	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
-	might_sleep_if(sleep_us); \
+	u64 __timeout_us = (timeout_us); \
+	unsigned long __sleep_us = (sleep_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
+	might_sleep_if((__sleep_us) != 0); \
 	for (;;) { \
 		(val) = op(addr); \
 		if (cond) \
 			break; \
-		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
+		if (__timeout_us && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
 			(val) = op(addr); \
 			break; \
 		} \
-		if (sleep_us) \
-			usleep_range((sleep_us >> 2) + 1, sleep_us); \
+		if (__sleep_us) \
+			usleep_range((__sleep_us >> 2) + 1, __sleep_us); \
 	} \
 	(cond) ? 0 : -ETIMEDOUT; \
 })
@@ -77,17 +80,20 @@
  */
 #define readx_poll_timeout_atomic(op, addr, val, cond, delay_us, timeout_us) \
 ({ \
-	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
+	u64 __timeout_us = (timeout_us); \
+	unsigned long __delay_us = (delay_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
 	for (;;) { \
 		(val) = op(addr); \
 		if (cond) \
 			break; \
-		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
+		if (__timeout_us && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
 			(val) = op(addr); \
 			break; \
 		} \
-		if (delay_us) \
-			udelay(delay_us);	\
+		if (__delay_us) \
+			udelay(__delay_us);	\
 	} \
 	(cond) ? 0 : -ETIMEDOUT; \
 })
_

Patches currently in -mm which might be from arnd@arndb.de are


