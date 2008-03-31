From: akpm@linux-foundation.org
Subject: - scsi-removed-one-unneeded-shost-active_mode-assignment.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:19:04 -0700
Message-ID: <200803312019.m2VKJ4Dn024177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754829AbYCaU1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:27:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     scsi: removed one unneeded shost->active_mode assignment
has been removed from the -mm tree.  Its filename was
     scsi-removed-one-unneeded-shost-active_mode-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: removed one unneeded shost->active_mode assignment
From: Denis Cheng <crquan@gmail.com>

In the following if/else statement, shost->active_mode will always be set, so
this assignment is unneeded.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hosts.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/hosts.c~scsi-removed-one-unneeded-shost-active_mode-assignment drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~scsi-removed-one-unneeded-shost-active_mode-assignment
+++ a/drivers/scsi/hosts.c
@@ -341,7 +341,6 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
-	shost->active_mode = sht->supported_mode;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
_

Patches currently in -mm which might be from crquan@gmail.com are

git-gfs2-nmw.patch
git-scsi-misc.patch
ipmi-remove-unused-target-and-action-in-makefile.patch

