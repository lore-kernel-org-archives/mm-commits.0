From: akpm@linux-foundation.org
Subject: - md-skip-all-metadata-update-processing-when-using-external-metadata.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:29 -0700
Message-ID: <200805010925.m419PTRN030205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755340AbYEAJ0C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:26:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: skip all metadata update processing when using external metadata.
has been removed from the -mm tree.  Its filename was
     md-skip-all-metadata-update-processing-when-using-external-metadata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: skip all metadata update processing when using external metadata.
From: NeilBrown <neilb@suse.de>

All the metadata update processing for external metadata is on in user-space
or through the sysfs interfaces, so make "md_update_sb" a no-op in that case.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/md/md.c~md-skip-all-metadata-update-processing-when-using-external-metadata drivers/md/md.c
--- a/drivers/md/md.c~md-skip-all-metadata-update-processing-when-using-external-metadata
+++ a/drivers/md/md.c
@@ -1652,6 +1652,8 @@ static void md_update_sb(mddev_t * mddev
 	int sync_req;
 	int nospares = 0;
 
+	if (mddev->external)
+		return;
 repeat:
 	spin_lock_irq(&mddev->write_lock);
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch

