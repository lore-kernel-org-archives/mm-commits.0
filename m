From: akpm@linux-foundation.org
Subject: + git-scsi-misc-fix-scsi_dh-build-errors.patch added to -mm tree
Date: Tue, 27 May 2008 22:32:24 -0700
Message-ID: <200805280532.m4S5WO43031035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021AbYE1FdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 01:33:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sekharan@us.ibm.com, James.Bottomley@HansenPartnership.com, agk@redhat.com, akpm@linux-foundation.org, andmike@us.ibm.com, hare@suse.de, michaelc@cs.wisc.edu, randy.dunlap@oracle.com


The patch titled
     git-scsi-misc: fix SCSI_DH build errors
has been added to the -mm tree.  Its filename is
     git-scsi-misc-fix-scsi_dh-build-errors.patch

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
Subject: git-scsi-misc: fix SCSI_DH build errors
From: Chandra Seetharaman <sekharan@us.ibm.com>

Do not automatically "select" SCSI_DH for dm-multipath. If SCSI_DH
doesn't exist, just do not allow  hardware handlers to be used.

Handle SCSI_DH being a module also. Make sure it doesn't allow DM_MULTIPATH
to be compiled in when SCSI_DH is a module.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Anderson <andmike@us.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/Kconfig     |    2 +-
 drivers/md/dm-mpath.c  |    2 ++
 include/scsi/scsi_dh.h |   12 +++++++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/md/Kconfig~git-scsi-misc-fix-scsi_dh-build-errors drivers/md/Kconfig
--- a/drivers/md/Kconfig~git-scsi-misc-fix-scsi_dh-build-errors
+++ a/drivers/md/Kconfig
@@ -252,7 +252,7 @@ config DM_ZERO
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
-	select SCSI_DH
+	depends on SCSI_DH || !SCSI_DH
 	---help---
 	  Allow volume managers to support multipath hardware.
 
diff -puN drivers/md/dm-mpath.c~git-scsi-misc-fix-scsi_dh-build-errors drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~git-scsi-misc-fix-scsi_dh-build-errors
+++ a/drivers/md/dm-mpath.c
@@ -664,6 +664,8 @@ static int parse_hw_handler(struct arg_s
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
 		ti->error = "unknown hardware handler type";
+		kfree(m->hw_handler_name);
+		m->hw_handler_name = NULL;
 		return -EINVAL;
 	}
 	consume(as, hw_argc - 1);
diff -puN include/scsi/scsi_dh.h~git-scsi-misc-fix-scsi_dh-build-errors include/scsi/scsi_dh.h
--- a/include/scsi/scsi_dh.h~git-scsi-misc-fix-scsi_dh-build-errors
+++ a/include/scsi/scsi_dh.h
@@ -54,6 +54,16 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
