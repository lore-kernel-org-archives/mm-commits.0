From: akpm@linux-foundation.org
Subject: - tridentfb-blade3d-clock-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:33 -0700
Message-ID: <200807242331.m6ONVXwL011643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120AbYGXXbf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: Blade3D clock fixes
has been removed from the -mm tree.  Its filename was
     tridentfb-blade3d-clock-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: Blade3D clock fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes following problems:
- does not allow the m parameter to reach 0 as
  it locks the graphics core (power cycle needed)
- for the newer chips (with new clock registers)
  does not allow of n / m ratio below 4 as it gives
  unstable image on the Blade3D core
- extend shift parameter (k) range  to 2 for the newer
  chips to cope with the n /m >= 4 limit at low resolution
  (bandwidth) modes
- prefer modes with higher n / m ratio (higher k values)

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-blade3d-clock-fixes drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-blade3d-clock-fixes
+++ a/drivers/video/tridentfb.c
@@ -672,15 +672,16 @@ static void set_vclk(struct tridentfb_pa
 	unsigned long fi, d, di;
 	unsigned char best_m = 0, best_n = 0, best_k = 0;
 	unsigned char hi, lo;
+	unsigned char shift = !is_oldclock(par->chip_id) ? 2 : 1;
 
 	d = 20000;
-	for (k = 1; k >= 0; k--)
-		for (m = 0; m < 32; m++) {
-			n = 2 * (m + 2) - 8;
+	for (k = shift; k >= 0; k--)
+		for (m = 1; m < 32; m++) {
+			n = ((m + 2) << shift) - 8;
 			for (n = (n < 0 ? 0 : n); n < 122; n++) {
 				fi = ((14318l * (n + 8)) / (m + 2)) >> k;
 				di = abs(fi - freq);
-				if (di <= d) {
+				if (di < d || (di == d && k == best_k)) {
 					d = di;
 					best_n = n;
 					best_m = m;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

