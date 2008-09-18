From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-reject-invalid-transfer-sizes.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:55:55 -0700
Message-ID: <200809182055.m8IKttjj019145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828AbYIRU43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacmet@sunsite.dk, Joakim.Tjernlund@transmode.se, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: reject invalid transfer sizes
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-reject-invalid-transfer-sizes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: reject invalid transfer sizes
From: Peter Korsgaard <jacmet@sunsite.dk>

Error out on transfer length != multiple of bytes per word with -EINVAL. 
Fixes a buffer overrun crash if length < bytes per word.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-reject-invalid-transfer-sizes drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-reject-invalid-transfer-sizes
+++ a/drivers/spi/spi_mpc83xx.c
@@ -312,11 +312,20 @@ static int mpc83xx_spi_bufs(struct spi_d
 	if (t->bits_per_word)
 		bits_per_word = t->bits_per_word;
 	len = t->len;
-	if (bits_per_word > 8)
+	if (bits_per_word > 8) {
+		/* invalid length? */
+		if (len & 1)
+			return -EINVAL;
 		len /= 2;
-	if (bits_per_word > 16)
+	}
+	if (bits_per_word > 16) {
+		/* invalid length? */
+		if (len & 1)
+			return -EINVAL;
 		len /= 2;
+	}
 	mpc83xx_spi->count = len;
+
 	INIT_COMPLETION(mpc83xx_spi->done);
 
 	/* enable rx ints */
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

origin.patch
linux-next.patch
smc911x-remove-duplicate-debug-printout.patch

