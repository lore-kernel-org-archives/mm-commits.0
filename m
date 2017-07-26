From: akpm@linux-foundation.org
Subject: + iopoll-avoid-wint-in-bool-context-warning.patch added to -mm
 tree
Date: Wed, 26 Jul 2017 14:39:15 -0700
Message-ID: <59790c03.7fUZzAcFkNU2kZ3w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750982AbdGZVjQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 17:39:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, broonie@kernel.org, ckeepax@opensource.wolfsonmicro.com, m.grzeschik@pengutronix.de, minimumlaw@rambler.ru, ramesh.shanmugasundaram@bp.renesas.com, tony@atomide.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: iopoll: avoid -Wint-in-bool-context warning
has been added to the -mm tree.  Its filename is
     iopoll-avoid-wint-in-bool-context-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/iopoll-avoid-wint-in-bool-context-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/iopoll-avoid-wint-in-bool-context-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: iopoll: avoid -Wint-in-bool-context warning

When we pass the result of a multiplication as the timeout or the delay,
we can get a warning:

drivers/mmc/host/bcm2835.c:596:149: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/mfd/arizona-core.c:247:195: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/gpu/drm/sun4i/sun4i_hdmi_i2c.c:49:27: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]

The warning is a bit questionable inside of a macro, but this is
intentional on the side of the gcc developers.  It is also an indication
of another problem: we evaluate the timeout and sleep arguments multiple
times, which can have undesired side-effects when those are complex
expressions.

This changes the three iopoll variants to use local variables for storing
copies of the timeouts.  This adds some more type safety, and avoids both
the double-evaluation and the gcc warning.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81484
Link: http://lkml.kernel.org/r/20170726133756.2161367-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iopoll.h |   24 +++++++++++++++---------
 include/linux/regmap.h |   12 +++++++-----
 2 files changed, 22 insertions(+), 14 deletions(-)

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
diff -puN include/linux/regmap.h~iopoll-avoid-wint-in-bool-context-warning include/linux/regmap.h
--- a/include/linux/regmap.h~iopoll-avoid-wint-in-bool-context-warning
+++ a/include/linux/regmap.h
@@ -120,22 +120,24 @@ struct reg_sequence {
  */
 #define regmap_read_poll_timeout(map, addr, val, cond, sleep_us, timeout_us) \
 ({ \
-	ktime_t __timeout = ktime_add_us(ktime_get(), timeout_us); \
+	u64 __timeout_us = (timeout_us); \
+	unsigned long __sleep_us = (sleep_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
 	int __ret; \
-	might_sleep_if(sleep_us); \
+	might_sleep_if(__sleep_us); \
 	for (;;) { \
 		__ret = regmap_read((map), (addr), &(val)); \
 		if (__ret) \
 			break; \
 		if (cond) \
 			break; \
-		if ((timeout_us) && \
+		if (__timeout_us && \
 		    ktime_compare(ktime_get(), __timeout) > 0) { \
 			__ret = regmap_read((map), (addr), &(val)); \
 			break; \
 		} \
-		if (sleep_us) \
-			usleep_range(((sleep_us) >> 2) + 1, sleep_us); \
+		if (__sleep_us) \
+			usleep_range((__sleep_us >> 2) + 1, __sleep_us); \
 	} \
 	__ret ?: ((cond) ? 0 : -ETIMEDOUT); \
 })
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning-v3.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch
iopoll-avoid-wint-in-bool-context-warning.patch

