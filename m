From: akpm@linux-foundation.org
Subject: + pm2fb-pixclock-setting-restriction.patch added to -mm tree
Date: Wed, 25 Apr 2007 17:33:28 -0700
Message-ID: <200704260033.l3Q0XS8A017026@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423454AbXDZAdb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 20:33:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: pixclock setting restriction
has been added to the -mm tree.  Its filename is
     pm2fb-pixclock-setting-restriction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

skeletonfb-various-corrections.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
