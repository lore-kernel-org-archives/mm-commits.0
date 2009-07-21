From: akpm@linux-foundation.org
Subject: + floppy-switch-driver-to-dev_pm_ops.patch added to -mm tree
Date: Tue, 21 Jul 2009 16:30:09 -0700
Message-ID: <200907212330.n6LNU9JE010948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502AbZGUXa6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 19:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, jens.axboe@oracle.com, rjw@sisk.pl


The patch titled
     floppy: switch driver to dev_pm_ops
has been added to the -mm tree.  Its filename is
     floppy-switch-driver-to-dev_pm_ops.patch

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

origin.patch
linux-next.patch
hp-wmi-switch-driver-to-dev_pm_ops.patch
floppy-switch-driver-to-dev_pm_ops.patch

