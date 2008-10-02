From: akpm@linux-foundation.org
Subject: + orion_spi-fix-handling-of-default-transfer-speed.patch added to -mm tree
Date: Thu, 02 Oct 2008 16:35:15 -0700
Message-ID: <200810022335.m92NZFGD032622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949AbYJBXf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 19:35:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, buytenh@marvell.com, dbrownell@users.sourceforge.net


The patch titled
     orion_spi: fix handling of default transfer speed
has been added to the -mm tree.  Its filename is
     orion_spi-fix-handling-of-default-transfer-speed.patch

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
Subject: orion_spi: fix handling of default transfer speed
From: Lennert Buytenhek <buytenh@wantstofly.org>

Accept zero (the default!) as a per-transfer clock speed override.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/orion_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/orion_spi.c~orion_spi-fix-handling-of-default-transfer-speed drivers/spi/orion_spi.c
--- a/drivers/spi/orion_spi.c~orion_spi-fix-handling-of-default-transfer-speed
+++ a/drivers/spi/orion_spi.c
@@ -427,7 +427,7 @@ static int orion_spi_transfer(struct spi
 			goto msg_rejected;
 		}
 
-		if (t->speed_hz < orion_spi->min_speed) {
+		if (t->speed_hz && t->speed_hz < orion_spi->min_speed) {
 			dev_err(&spi->dev,
 				"message rejected : "
 				"device min speed (%d Hz) exceeds "
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

orion_spi-fix-handling-of-default-transfer-speed.patch
git-arm.patch
git-net.patch
orion_spi-handle-88f6183-erratum.patch

