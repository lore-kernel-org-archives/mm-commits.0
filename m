From: akpm@linux-foundation.org
Subject: [merged] drivers-hvc-add-missing-__devexit_p.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:40:03 -0700
Message-ID: <200906171840.n5HIe3cv006104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbZFQSzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, anton@samba.org, benh@kernel.crashing.org, miltonm@bga.com, paulus@samba.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     drivers/hvc: add missing __devexit_p()
has been removed from the -mm tree.  Its filename was
     drivers-hvc-add-missing-__devexit_p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/hvc: add missing __devexit_p()
From: Mike Frysinger <vapier@gentoo.org>

The remove function uses __devexit, so the .remove assignment needs
__devexit_p() to fix a build error with hotplug disabled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Milton Miller <miltonm@bga.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hvc_iseries.c |    2 +-
 drivers/char/hvc_vio.c     |    2 +-
 drivers/char/hvcs.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/hvc_iseries.c~drivers-hvc-add-missing-__devexit_p drivers/char/hvc_iseries.c
--- a/drivers/char/hvc_iseries.c~drivers-hvc-add-missing-__devexit_p
+++ a/drivers/char/hvc_iseries.c
@@ -241,7 +241,7 @@ static int __devexit hvc_vio_remove(stru
 static struct vio_driver hvc_vio_driver = {
 	.id_table	= hvc_driver_table,
 	.probe		= hvc_vio_probe,
-	.remove		= hvc_vio_remove,
+	.remove		= __devexit_p(hvc_vio_remove),
 	.driver		= {
 		.name	= hvc_driver_name,
 		.owner	= THIS_MODULE,
diff -puN drivers/char/hvc_vio.c~drivers-hvc-add-missing-__devexit_p drivers/char/hvc_vio.c
--- a/drivers/char/hvc_vio.c~drivers-hvc-add-missing-__devexit_p
+++ a/drivers/char/hvc_vio.c
@@ -113,7 +113,7 @@ static int __devexit hvc_vio_remove(stru
 static struct vio_driver hvc_vio_driver = {
 	.id_table	= hvc_driver_table,
 	.probe		= hvc_vio_probe,
-	.remove		= hvc_vio_remove,
+	.remove		= __devexit_p(hvc_vio_remove),
 	.driver		= {
 		.name	= hvc_driver_name,
 		.owner	= THIS_MODULE,
diff -puN drivers/char/hvcs.c~drivers-hvc-add-missing-__devexit_p drivers/char/hvcs.c
--- a/drivers/char/hvcs.c~drivers-hvc-add-missing-__devexit_p
+++ a/drivers/char/hvcs.c
@@ -868,7 +868,7 @@ static int __devexit hvcs_remove(struct 
 static struct vio_driver hvcs_vio_driver = {
 	.id_table	= hvcs_driver_table,
 	.probe		= hvcs_probe,
-	.remove		= hvcs_remove,
+	.remove		= __devexit_p(hvcs_remove),
 	.driver		= {
 		.name	= hvcs_driver_name,
 		.owner	= THIS_MODULE,
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch
istallion-add-missing-__devexit-marking.patch
edac-add-missing-__devexit_p.patch

