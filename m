From: akpm@linux-foundation.org
Subject: [merged] h8300-move-new-timerh-from-include-asm-h8300-to-arch-h8300-include-asm.patch removed from -mm tree
Date: Fri, 17 Apr 2009 11:14:10 -0700
Message-ID: <200904171814.n3HIEA8H019000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760716AbZDQSRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, rolandd@cisco.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: move new timer.h from include/asm-h8300 to arch/h8300/include/asm
has been removed from the -mm tree.  Its filename was
     h8300-move-new-timerh-from-include-asm-h8300-to-arch-h8300-include-asm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: h8300: move new timer.h from include/asm-h8300 to arch/h8300/include/asm
From: Roland Dreier <rdreier@cisco.com>

Commit e0b0f9e4 ("h8300: update timer handler - new files") added a new
<asm/timer.h> for h8300 under include/, but since 758db3f2 ("[h8300] move
include/asm-h8300 to arch/h8300/include/asm") the h8300 includes have been
in arch/h8300/include/asm.  Move timer.h there too.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/timer.h |   25 +++++++++++++++++++++++++
 include/asm-h8300/timer.h      |   25 -------------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff -puN include/asm-h8300/timer.h~h8300-move-new-timerh-from-include-asm-h8300-to-arch-h8300-include-asm /dev/null
--- a/include/asm-h8300/timer.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __H8300_TIMER_H
-#define __H8300_TIMER_H
-
-void h8300_timer_tick(void);
-void h8300_timer_setup(void);
-void h8300_gettod(unsigned int *year, unsigned int *mon, unsigned int *day,
-		   unsigned int *hour, unsigned int *min, unsigned int *sec);
-
-#define TIMER_FREQ (CONFIG_CPU_CLOCK*10000) /* Timer input freq. */
-
-#define calc_param(cnt, div, rate, limit)			\
-do {								\
-	cnt = TIMER_FREQ / HZ;					\
-	for (div = 0; div < ARRAY_SIZE(divide_rate); div++) {	\
-		if (rate[div] == 0)				\
-			continue;				\
-		if ((cnt / rate[div]) > limit)			\
-			break;					\
-	}							\
-	if (div == ARRAY_SIZE(divide_rate))			\
-		panic("Timer counter overflow");		\
-	cnt /= divide_rate[div];				\
-} while(0)
-
-#endif
diff -puN /dev/null arch/h8300/include/asm/timer.h
--- /dev/null
+++ a/arch/h8300/include/asm/timer.h
@@ -0,0 +1,25 @@
+#ifndef __H8300_TIMER_H
+#define __H8300_TIMER_H
+
+void h8300_timer_tick(void);
+void h8300_timer_setup(void);
+void h8300_gettod(unsigned int *year, unsigned int *mon, unsigned int *day,
+		   unsigned int *hour, unsigned int *min, unsigned int *sec);
+
+#define TIMER_FREQ (CONFIG_CPU_CLOCK*10000) /* Timer input freq. */
+
+#define calc_param(cnt, div, rate, limit)			\
+do {								\
+	cnt = TIMER_FREQ / HZ;					\
+	for (div = 0; div < ARRAY_SIZE(divide_rate); div++) {	\
+		if (rate[div] == 0)				\
+			continue;				\
+		if ((cnt / rate[div]) > limit)			\
+			break;					\
+	}							\
+	if (div == ARRAY_SIZE(divide_rate))			\
+		panic("Timer counter overflow");		\
+	cnt /= divide_rate[div];				\
+} while(0)
+
+#endif
_

Patches currently in -mm which might be from rdreier@cisco.com are


