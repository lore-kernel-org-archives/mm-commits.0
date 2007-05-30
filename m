From: akpm@linux-foundation.org
Subject: - ide_in_drive_list-all-is-not-a-wildcard-anymore.patch removed from -mm tree
Date: Wed, 30 May 2007 16:28:30 -0700
Message-ID: <200705302328.l4UNSTAF007759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884AbXE3X2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 19:28:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junkio@cox.net, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ide_in_drive_list(): "ALL" is not a wildcard anymore
has been removed from the -mm tree.  Its filename was
     ide_in_drive_list-all-is-not-a-wildcard-anymore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide_in_drive_list(): "ALL" is not a wildcard anymore
From: Junio C Hamano <junkio@cox.net>

This removes the support to treat "ALL" as a wildcard for firmware revision. 
This is made a separate patch, as it will break out-of-tree ide drivers that
feed its own table that uses "ALL" as the wildcard to ide_in_drive_list().

Signed-off-by: Junio C Hamano <junkio@cox.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-dma.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/ide/ide-dma.c~ide_in_drive_list-all-is-not-a-wildcard-anymore drivers/ide/ide-dma.c
--- a/drivers/ide/ide-dma.c~ide_in_drive_list-all-is-not-a-wildcard-anymore
+++ a/drivers/ide/ide-dma.c
@@ -148,7 +148,6 @@ int ide_in_drive_list(struct hd_driveid 
 	for ( ; drive_table->id_model ; drive_table++)
 		if ((!strcmp(drive_table->id_model, id->model)) &&
 		    (!drive_table->id_firmware ||
-		     !strcmp(drive_table->id_firmware, "ALL") || /* to be removed later */
 		     strstr(id->fw_rev, drive_table->id_firmware)))
 			return 1;
 	return 0;
_

Patches currently in -mm which might be from junkio@cox.net are
