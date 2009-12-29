From: akpm@linux-foundation.org
Subject: [merged] drivers-block-mg_diskc-use-resource_size.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:09 -0800
Message-ID: <200912292133.nBTLX9H2008687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbZL2VdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, donari75@gmail.com, hsweeten@visionengravers.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/mg_disk.c: use resource_size()
has been removed from the -mm tree.  Its filename was
     drivers-block-mg_diskc-use-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/mg_disk.c: use resource_size()
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

Use resource_size() for ioremap.

The ioremap appears to be passing the incorrect size for the platform
resource.  Unfortunately, I can't locate a user in mainline to verify
this.  Using resource_size should be the correct fix.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: unsik Kim <donari75@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mg_disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/mg_disk.c~drivers-block-mg_diskc-use-resource_size drivers/block/mg_disk.c
--- a/drivers/block/mg_disk.c~drivers-block-mg_diskc-use-resource_size
+++ a/drivers/block/mg_disk.c
@@ -860,7 +860,7 @@ static int mg_probe(struct platform_devi
 		err = -EINVAL;
 		goto probe_err_2;
 	}
-	host->dev_base = ioremap(rsc->start , rsc->end + 1);
+	host->dev_base = ioremap(rsc->start, resource_size(rsc));
 	if (!host->dev_base) {
 		printk(KERN_ERR "%s:%d ioremap fail\n",
 				__func__, __LINE__);
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch

