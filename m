From: akpm@linux-foundation.org
Subject: [merged] cciss-fix-cciss_revalidate-panic.patch removed from -mm tree
Date: Tue, 21 Dec 2010 13:14:16 -0800
Message-ID: <201012212117.oBLLHlQ8026709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434Ab0LUVSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 16:18:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mmarek@suse.cz, axboe@kernel.dk, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix build
has been removed from the -mm tree.  Its filename was
     cciss-fix-cciss_revalidate-panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix build
From: Michal Marek <mmarek@suse.cz>

drivers/block/cciss.c:2839:3: error: expected ';' before 'if'

Signed-off-by: Michal Marek <mmarek@suse.cz>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss-fix-cciss_revalidate-panic drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-cciss_revalidate-panic
+++ a/drivers/block/cciss.c
@@ -2835,7 +2835,7 @@ static int cciss_revalidate(struct gendi
 
 	for (logvol = 0; logvol < CISS_MAX_LUN; logvol++) {
 		if (!h->drv[logvol])
-			continue
+			continue;
 		if (memcmp(h->drv[logvol]->LunID, drv->LunID,
 			sizeof(drv->LunID)) == 0) {
 			FOUND = 1;
_

Patches currently in -mm which might be from mmarek@suse.cz are

linux-next.patch

