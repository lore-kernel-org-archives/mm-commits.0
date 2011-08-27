From: akpm@linux-foundation.org
Subject: + driver-misc-fsa9480c-fix-potential-null-pointer-dereference.patch added to -mm tree
Date: Fri, 26 Aug 2011 17:18:53 -0700
Message-ID: <201108270018.p7R0Ircp020952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754643Ab1H0AS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 20:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhbird.choi@samsung.com, dg77.kim@samsung.com, kyungmin.park@samsung.com


The patch titled
     driver/misc/fsa9480.c fix potential null-pointer dereference
has been added to the -mm tree.  Its filename is
     driver-misc-fsa9480c-fix-potential-null-pointer-dereference.patch

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
Subject: driver/misc/fsa9480.c fix potential null-pointer dereference
From: Jonghwan Choi <jhbird.choi@samsung.com>

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/fsa9480.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/fsa9480.c~driver-misc-fsa9480c-fix-potential-null-pointer-dereference drivers/misc/fsa9480.c
--- a/drivers/misc/fsa9480.c~driver-misc-fsa9480c-fix-potential-null-pointer-dereference
+++ a/drivers/misc/fsa9480.c
@@ -400,7 +400,8 @@ static int fsa9480_irq_init(struct fsa94
 			return ret;
 		}
 
-		device_init_wakeup(&client->dev, pdata->wakeup);
+		if (pdata)
+			device_init_wakeup(&client->dev, pdata->wakeup);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from jhbird.choi@samsung.com are

linux-next.patch
mm-memblock-small-function-definition-fixes.patch
driver-misc-fsa9480c-fix-potential-null-pointer-dereference.patch

