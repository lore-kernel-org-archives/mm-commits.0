From: akpm@linux-foundation.org
Subject: [merged] macintosh-wrong-test-in-fan_readwrite_reg.patch removed from -mm tree
Date: Mon, 24 Jan 2011 11:36:06 -0800
Message-ID: <201101241936.p0OJa6OB005733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194Ab1AXTgj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Jan 2011 14:36:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     macintosh: wrong test in fan_{read,write}_reg()
has been removed from the -mm tree.  Its filename was
     macintosh-wrong-test-in-fan_readwrite_reg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: macintosh: wrong test in fan_{read,write}_reg()
From: roel kluin <roel.kluin@gmail.com>

Fix error test in fan_{read,write}_reg()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/therm_pm72.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/macintosh/therm_pm72.c~macintosh-wrong-test-in-fan_readwrite_reg drivers/macintosh/therm_pm72.c
--- a/drivers/macintosh/therm_pm72.c~macintosh-wrong-test-in-fan_readwrite_reg
+++ a/drivers/macintosh/therm_pm72.c
@@ -443,7 +443,7 @@ static int fan_read_reg(int reg, unsigne
 	tries = 0;
 	for (;;) {
 		nr = i2c_master_recv(fcu, buf, nb);
-		if (nr > 0 || (nr < 0 && nr != ENODEV) || tries >= 100)
+		if (nr > 0 || (nr < 0 && nr != -ENODEV) || tries >= 100)
 			break;
 		msleep(10);
 		++tries;
@@ -464,7 +464,7 @@ static int fan_write_reg(int reg, const 
 	tries = 0;
 	for (;;) {
 		nw = i2c_master_send(fcu, buf, nb);
-		if (nw > 0 || (nw < 0 && nw != EIO) || tries >= 100)
+		if (nw > 0 || (nw < 0 && nw != -EIO) || tries >= 100)
 			break;
 		msleep(10);
 		++tries;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

