From: akpm@linux-foundation.org
Subject: + scsi-removed-one-unneeded-shost-active_mode-assignment.patch added to -mm tree
Date: Fri, 21 Mar 2008 14:11:15 -0700
Message-ID: <200803212111.m2LLBFhQ010663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755698AbYCUVLs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 17:11:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com


The patch titled
     scsi: removed one unneeded shost->active_mode assignment
has been added to the -mm tree.  Its filename is
     scsi-removed-one-unneeded-shost-active_mode-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
3w-raid-drivers-memset-not-needed-in-probe.patch
scsi-removed-one-unneeded-shost-active_mode-assignment.patch
ipmi-remove-unused-target-and-action-in-makefile.patch

