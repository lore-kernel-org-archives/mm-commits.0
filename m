From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-reject-invalid-transfer-sizes.patch added to -mm tree
Date: Wed, 10 Sep 2008 19:25:17 -0700
Message-ID: <200809110225.m8B2PH7w006338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946AbYIKCZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 22:25:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacmet@sunsite.dk, Joakim.Tjernlund@transmode.se, dbrownell@users.sourceforge.net


The patch titled
     spi_mpc83xx: reject invalid transfer sizes
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-reject-invalid-transfer-sizes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: reject invalid transfer sizes
From: Peter Korsgaard <jacmet@sunsite.dk>

Error out on transfer length != multiple of bytes per word.

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

spi_mpc83xx-fix-clockrate-calculation-for-low-speed.patch
smc911x-remove-duplicate-debug-printout.patch
spi_mpc83xx-reject-invalid-transfer-sizes.patch

