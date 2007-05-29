From: akpm@linux-foundation.org
Subject: - remove-unnecessary-check-in-drivers-scsi-sgc.patch removed from -mm tree
Date: Tue, 29 May 2007 11:55:02 -0700
Message-ID: <200705291855.l4TIt1du008572@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271AbXE2TEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 15:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: snakebyte@gmx.de, James.Bottomley@steeleye.com, dougg@torque.net, mm-commits@vger.kernel.org


The patch titled
     scsi: remove unnecessary check in drivers/scsi/sg.c
has been removed from the -mm tree.  Its filename was
     remove-unnecessary-check-in-drivers-scsi-sgc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: remove unnecessary check in drivers/scsi/sg.c
From: Eric Sesterhenn <snakebyte@gmx.de>

coverity spotted this (cid #758).  All callers dereference sfp, so we dont
need this check.  In addition to this, we dereference it earlier in the
function.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sg.c~remove-unnecessary-check-in-drivers-scsi-sgc drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~remove-unnecessary-check-in-drivers-scsi-sgc
+++ a/drivers/scsi/sg.c
@@ -1842,7 +1842,7 @@ sg_build_indirect(Sg_scatter_hold * schp
 	int blk_size = buff_size;
 	struct page *p = NULL;
 
-	if ((blk_size < 0) || (!sfp))
+	if (blk_size < 0)
 		return -EFAULT;
 	if (0 == blk_size)
 		++blk_size;	/* don't know why */
_

Patches currently in -mm which might be from snakebyte@gmx.de are

git-kvm.patch
git-ubi.patch
git-scsi-misc.patch
