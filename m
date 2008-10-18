From: akpm@linux-foundation.org
Subject: - cirrusfb-simplify-clock-calculation.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:10 -0700
Message-ID: <200810182317.m9INHAS4029032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbYJRXRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: simplify clock calculation
has been removed from the -mm tree.  Its filename was
     cirrusfb-simplify-clock-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: simplify clock calculation
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Simplify clock calculation.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   40 +++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-simplify-clock-calculation drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-simplify-clock-calculation
+++ a/drivers/video/cirrusfb.c
@@ -3075,38 +3075,36 @@ static void bestclock(long freq, long *b
 	f = freq * 10;
 
 	for (n = 32; n < 128; n++) {
+		int s = 0;
+
 		d = (143181 * n) / f;
 		if ((d >= 7) && (d <= 63)) {
-			if (d > 31)
-				d = (d / 2) * 2;
-			h = (14318 * n) / d;
+			int temp = d;
+
+			if (temp > 31) {
+				s = 1;
+				temp >>= 1;
+			}
+			h = ((14318 * n) / temp) >> s;
 			if (abs(h - freq) < abs(*best - freq)) {
 				*best = h;
 				*nom = n;
-				if (d < 32) {
-					*den = d;
-					*div = 0;
-				} else {
-					*den = d / 2;
-					*div = 1;
-				}
+				*den = temp;
+				*div = s;
 			}
 		}
-		d = DIV_ROUND_UP(143181 * n, f);
+		d++;
 		if ((d >= 7) && (d <= 63)) {
-			if (d > 31)
-				d = (d / 2) * 2;
-			h = (14318 * n) / d;
+			if (d > 31) {
+				s = 1;
+				d >>= 1;
+			}
+			h = ((14318 * n) / d) >> s;
 			if (abs(h - freq) < abs(*best - freq)) {
 				*best = h;
 				*nom = n;
-				if (d < 32) {
-					*den = d;
-					*div = 0;
-				} else {
-					*den = d / 2;
-					*div = 1;
-				}
+				*den = d;
+				*div = s;
 			}
 		}
 	}
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

