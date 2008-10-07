From: akpm@linux-foundation.org
Subject: - orion_spi-fix-handling-of-default-transfer-speed.patch removed from -mm tree
Date: Tue, 07 Oct 2008 16:38:55 -0700
Message-ID: <200810072339.m97Nctc4009449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757976AbYJGXjd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Oct 2008 19:39:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, buytenh@marvell.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     orion_spi: fix handling of default transfer speed
has been removed from the -mm tree.  Its filename was
     orion_spi-fix-handling-of-default-transfer-speed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-arm.patch
git-net.patch
orion_spi-handle-88f6183-erratum.patch

