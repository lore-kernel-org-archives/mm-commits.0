From: akpm@linux-foundation.org
Subject: + s3c2410fb-fix-un-initialised-dev-field.patch added to -mm tree
Date: Thu, 15 Feb 2007 21:57:16 -0800
Message-ID: <200702160557.l1G5vGvh021073@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608AbXBPF5m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 00:57:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@fluff.org.uk, ben-linux@fluff.org, jsimmons@infradead.org


The patch titled
     s3c2410fb: fix un-initialised dev field
has been added to the -mm tree.  Its filename is
     s3c2410fb-fix-un-initialised-dev-field.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mfd-sm501-core-driver-3.patch
s3c2410fb-fix-un-initialised-dev-field.patch
