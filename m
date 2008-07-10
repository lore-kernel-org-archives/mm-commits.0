From: akpm@linux-foundation.org
Subject: + rapidio-fix-device-reference-counting.patch added to -mm tree
Date: Wed, 09 Jul 2008 22:37:13 -0700
Message-ID: <200807100542.m6A5geAm011048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902AbYGJFnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jul 2008 01:43:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebs@ebshome.net, mporter@kernel.crashing.org, stable@kernel.org


The patch titled
     rapidio: fix device reference counting
has been added to the -mm tree.  Its filename is
     rapidio-fix-device-reference-counting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix device reference counting
From: Eugene Surovegin <ebs@ebshome.net>

Fix RapidIO device reference counting.

Signed-of-by: Eugene Surovegin <ebs@ebshome.net>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rapidio/rio-driver.c~rapidio-fix-device-reference-counting drivers/rapidio/rio-driver.c
--- a/drivers/rapidio/rio-driver.c~rapidio-fix-device-reference-counting
+++ a/drivers/rapidio/rio-driver.c
@@ -101,8 +101,8 @@ static int rio_device_probe(struct devic
 		if (error >= 0) {
 			rdev->driver = rdrv;
 			error = 0;
+		} else
 			rio_dev_put(rdev);
-		}
 	}
 	return error;
 }
_

Patches currently in -mm which might be from ebs@ebshome.net are

rapidio-fix-device-reference-counting.patch

