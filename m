From: akpm@linux-foundation.org
Subject: - hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:02 -0700
Message-ID: <200810202035.m9KKZ2VY011063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754342AbYJTUrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@euromail.se, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, rkoktarianto@gmail.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: applesmc: specified number of bytes to read should match actual
has been removed from the -mm tree.  Its filename was
     hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: applesmc: specified number of bytes to read should match actual
From: Henrik Rydberg <rydberg@euromail.se>

At one single place in the code, the specified number of bytes to read and
the actual number of bytes read differ by one.  This one-liner patch fixes
that inconsistency.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Nicolas Boichat <nicolas@boichat.ch>
Cc: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/applesmc.c~hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual
+++ a/drivers/hwmon/applesmc.c
@@ -325,7 +325,7 @@ static int applesmc_get_key_type(char* k
 			return -EIO;
 	}
 
-	outb(5, APPLESMC_DATA_PORT);
+	outb(6, APPLESMC_DATA_PORT);
 
 	for (i = 0; i < 6; i++) {
 		if (__wait_status(0x05))
_

Patches currently in -mm which might be from rydberg@euromail.se are

origin.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch

