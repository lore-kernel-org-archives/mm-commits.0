From: akpm@linux-foundation.org
Subject: - rapidio-fix-device-reference-counting.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:50:31 -0700
Message-ID: <200807112350.m6BNoVDK010965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbYGKXuw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:50:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebs@ebshome.net, mporter@kernel.crashing.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rapidio: fix device reference counting
has been removed from the -mm tree.  Its filename was
     rapidio-fix-device-reference-counting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

