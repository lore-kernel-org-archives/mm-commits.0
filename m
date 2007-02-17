From: akpm@linux-foundation.org
Subject: - s3c2410fb-fix-un-initialised-dev-field.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:37 -0800
Message-ID: <200702170716.l1H7Gbaf021722@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946521AbXBQHQ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@fluff.org.uk, ben-linux@fluff.org, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: fix un-initialised dev field
has been removed from the -mm tree.  Its filename was
     s3c2410fb-fix-un-initialised-dev-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3c2410fb: fix un-initialised dev field
From: Ben Dooks <ben@fluff.org.uk>

The current driver is not setting the dev field in the private data
structure, which can lead to an OOPS if the driver tries to report an
error.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-fix-un-initialised-dev-field drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-fix-un-initialised-dev-field
+++ a/drivers/video/s3c2410fb.c
@@ -791,6 +791,8 @@ static int __init s3c2410fb_probe(struct
 
 	info = fbinfo->par;
 	info->fb = fbinfo;
+	info->dev = &pdev->dev;
+
 	platform_set_drvdata(pdev, fbinfo);
 
 	dprintk("devinit\n");
_

Patches currently in -mm which might be from ben@fluff.org.uk are

origin.patch
mfd-sm501-core-driver-3.patch
fb-sm501-framebuffer-driver-5.patch
