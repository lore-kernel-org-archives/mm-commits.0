From: akpm@linux-foundation.org
Subject: - memstick-make-sure-number-of-command-retries-is-exactly-as-specified.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:21:47 -0700
Message-ID: <200803110321.m2B3Lla1019745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060AbYCKDWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: make sure number of command retries is exactly as specified
has been removed from the -mm tree.  Its filename was
     memstick-make-sure-number-of-command-retries-is-exactly-as-specified.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: make sure number of command retries is exactly as specified
From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/memstick/core/memstick.c~memstick-make-sure-number-of-command-retries-is-exactly-as-specified drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-make-sure-number-of-command-retries-is-exactly-as-specified
+++ a/drivers/memstick/core/memstick.c
@@ -236,7 +236,7 @@ int memstick_next_req(struct memstick_ho
 		rc = host->card->next_request(host->card, mrq);
 
 	if (!rc)
-		host->retries = cmd_retries;
+		host->retries = cmd_retries > 1 ? cmd_retries - 1 : 1;
 	else
 		*mrq = NULL;
 
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch

