From: akpm@linux-foundation.org
Subject: [merged] floppy-switch-driver-to-dev_pm_ops.patch removed from -mm tree
Date: Thu, 23 Jul 2009 12:26:26 -0700
Message-ID: <200907231926.n6NJQQCV030241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbZGWT0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 15:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, jens.axboe@oracle.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     floppy: switch driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     floppy-switch-driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: floppy: switch driver to dev_pm_ops
From: Frans Pop <elendil@planet.nl>

Gets rid of the following warning:
Platform driver 'floppy' needs updating - please use dev_pm_ops

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/block/floppy.c~floppy-switch-driver-to-dev_pm_ops drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-switch-driver-to-dev_pm_ops
+++ a/drivers/block/floppy.c
@@ -4151,7 +4151,7 @@ static void floppy_device_release(struct
 {
 }
 
-static int floppy_resume(struct platform_device *dev)
+static int floppy_resume(struct device *dev)
 {
 	int fdc;
 
@@ -4162,10 +4162,14 @@ static int floppy_resume(struct platform
 	return 0;
 }
 
-static struct platform_driver floppy_driver = {
+static struct dev_pm_ops floppy_pm_ops = {
 	.resume = floppy_resume,
+};
+
+static struct platform_driver floppy_driver = {
 	.driver = {
 		.name = "floppy",
+		.pm = &floppy_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch

