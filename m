From: akpm@linux-foundation.org
Subject: + cciss-fix-cciss_revalidate-panic.patch added to -mm tree
Date: Mon, 20 Dec 2010 21:33:12 -0800
Message-ID: <201012210536.oBL5abpg020951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525Ab0LUFgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 00:36:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mmarek@suse.cz, axboe@kernel.dk, scameron@beardog.cce.hp.com


The patch titled
     cciss: fix build
has been added to the -mm tree.  Its filename is
     cciss-fix-cciss_revalidate-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

cciss-fix-cciss_revalidate-panic.patch
linux-next.patch

