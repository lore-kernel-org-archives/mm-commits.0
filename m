From: akpm@linux-foundation.org
Subject: - remove-extra-newline-from-info-message.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:49 -0800
Message-ID: <200702170716.l1H7Gn4Q021743@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51183 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946518AbXBQHQ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     remove extra newline from info message
has been removed from the -mm tree.  Its filename was
     remove-extra-newline-from-info-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove extra newline from info message
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

remove extra newline from info message

This extra newline character introduces a completely empty line in dmesg as
the calling function itself adds a newline.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_osm.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~remove-extra-newline-from-info-message drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~remove-extra-newline-from-info-message
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -418,7 +418,6 @@ ahd_linux_info(struct Scsi_Host *host)
 	strcat(bp, "        ");
 	ahd_controller_info(ahd, ahd_info);
 	strcat(bp, ahd_info);
-	strcat(bp, "\n");
 
 	return (bp);
 }
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

origin.patch
git-scsi-misc.patch
