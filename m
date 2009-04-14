From: akpm@linux-foundation.org
Subject: [merged] cx88-dsp-fixing-64bit-math-on-32bit-kernels.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:27 -0700
Message-ID: <200904141950.n3EJoRY3020184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752AbZDNTwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sustmidown@centrum.cz, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     cx88-dsp: fixing 64bit math on 32bit kernels
has been removed from the -mm tree.  Its filename was
     cx88-dsp-fixing-64bit-math-on-32bit-kernels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cx88-dsp: fixing 64bit math on 32bit kernels
From: Miroslav Sustek <sustmidown@centrum.cz>


Some gcc versions report the missing of __divdi3

[mchehab.redhat.com: CodingStyle fixes]
Signed-off-by: Miroslav Sustek <sustmidown@centrum.cz>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-dsp.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/cx88/cx88-dsp.c~cx88-dsp-fixing-64bit-math-on-32bit-kernels drivers/media/video/cx88/cx88-dsp.c
--- a/drivers/media/video/cx88/cx88-dsp.c~cx88-dsp-fixing-64bit-math-on-32bit-kernels
+++ a/drivers/media/video/cx88/cx88-dsp.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
+#include <asm/div64.h>
 
 #include "cx88.h"
 #include "cx88-reg.h"
@@ -100,13 +101,25 @@ static u32 int_goertzel(s16 x[], u32 N, 
 	s32 s_prev2 = 0;
 	s32 coeff = 2*int_cos(freq);
 	u32 i;
+
+	u64 tmp;
+	u32 divisor;
+
 	for (i = 0; i < N; i++) {
 		s32 s = x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
 		s_prev2 = s_prev;
 		s_prev = s;
 	}
-	return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
-		      (s64)coeff*s_prev2*s_prev/32768)/N/N);
+
+	tmp = (s64)s_prev2 * s_prev2 + (s64)s_prev * s_prev -
+		      (s64)coeff * s_prev2 * s_prev / 32768;
+
+	/* XXX: N must be low enough so that N*N fits in s32.
+	 * Else we need two divisions. */
+	divisor = N * N;
+	do_div(tmp, divisor);
+
+	return (u32) tmp;
 }
 
 static u32 freq_magnitude(s16 x[], u32 N, u32 freq)
_

Patches currently in -mm which might be from sustmidown@centrum.cz are

linux-next.patch

