From: akpm@linux-foundation.org
Subject: - pm2fb-pixclock-setting-restriction.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:04 -0700
Message-ID: <200705090302.l49324Bq010787@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033133AbXEIDCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm2fb: pixclock setting restriction
has been removed from the -mm tree.  Its filename was
     pm2fb-pixclock-setting-restriction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm2fb: pixclock setting restriction
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds restrictions to calculations of m, n and p factors
which sets the pixclock for the Permedia 2V. I found during tests
that synchronization is unstable if m (divisor) is bigger than
half of the n (numerator). The patch disallows such settings
combination.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-pixclock-setting-restriction drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-pixclock-setting-restriction
+++ a/drivers/video/pm2fb.c
@@ -302,10 +302,10 @@ static void pm2v_mnp(u32 clk, unsigned c
 	s32 delta = 1000;
 
 	*mm = *nn = *pp = 0;
-	for (n = 1; n; n++) {
-		for ( m = 1; m; m++) {
+	for ( m = 1; m < 128; m++) {
+		for (n = 2 * m + 1; n; n++) {
 			for ( p = 0; p < 2; p++) {
-				f = PM2_REFERENCE_CLOCK * n / (m * (1 << (p + 1)));
+				f = ( PM2_REFERENCE_CLOCK >> ( p + 1 )) * n / m;
 				if ( clk > f - delta && clk < f + delta ) {
 					delta = ( clk > f ) ? clk - f : f - clk;
 					*mm=m;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
