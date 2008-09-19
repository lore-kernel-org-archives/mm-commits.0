From: akpm@linux-foundation.org
Subject: + hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual.patch added to -mm tree
Date: Fri, 19 Sep 2008 15:55:33 -0700
Message-ID: <200809192255.m8JMtXU4010698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbYISWz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 18:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, khali@linux-fr.org, mhoffman@lightlink.com, nicolas@boichat.ch, rkoktarianto@gmail.com


The patch titled
     hwmon: applesmc: specified number of bytes to read should match actual
has been added to the -mm tree.  Its filename is
     hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual.patch

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

linux-next.patch
input-mousedev-distinguish-a-moving-finger-from-a-tapping-finger.patch
hwmon-applesmc-specified-number-of-bytes-to-read-should-match-actual.patch
hwmon-applesmc-fix-the-wait-status-failed-c-=-8-problem.patch
hwmon-applesmc-prolong-status-wait.patch
hwmon-applesmc-allow-for-variable-alv0-and-alv1-package-length.patch
hwmon-applesmc-add-support-for-macbook-air.patch

