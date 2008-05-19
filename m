From: akpm@linux-foundation.org
Subject: + scsi-do-not-automatically-select-scsi_dh-for-dm-multipath.patch added to -mm tree
Date: Mon, 19 May 2008 14:14:47 -0700
Message-ID: <200805192114.m4JLElg4020839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756948AbYESVVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sekharan@us.ibm.com, James.Bottomley@HansenPartnership.com, agk@redhat.com, michaelc@cs.wisc.edu, randy.dunlap@oracle.com


The patch titled
     scsi: do not automatically "select" SCSI_DH for dm-multipath
has been added to the -mm tree.  Its filename is
     scsi-do-not-automatically-select-scsi_dh-for-dm-multipath.patch

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
Subject: scsi: do not automatically "select" SCSI_DH for dm-multipath
From: Chandra Seetharaman <sekharan@us.ibm.com>

SCSI_DH has some problems when CONFIG_SCSI=n:

drivers/built-in.o: In function `activate_path':
dm-mpath.c:(.text+0x18a292): undefined reference to `scsi_dh_activate'
drivers/built-in.o: In function `multipath_ctr':
dm-mpath.c:(.text+0x18a6f0): undefined reference to `scsi_dh_handler_exist'

If SCSI_DH doesn't exist, just do not allow hardware handlers to be used.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/Kconfig     |    1 -
 drivers/md/dm-mpath.c  |    2 ++
 include/scsi/scsi_dh.h |   12 +++++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/md/Kconfig~scsi-do-not-automatically-select-scsi_dh-for-dm-multipath drivers/md/Kconfig
--- a/drivers/md/Kconfig~scsi-do-not-automatically-select-scsi_dh-for-dm-multipath
+++ a/drivers/md/Kconfig
@@ -252,7 +252,6 @@ config DM_ZERO
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
-	select SCSI_DH
 	---help---
 	  Allow volume managers to support multipath hardware.
 
diff -puN drivers/md/dm-mpath.c~scsi-do-not-automatically-select-scsi_dh-for-dm-multipath drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c~scsi-do-not-automatically-select-scsi_dh-for-dm-multipath
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
diff -puN include/scsi/scsi_dh.h~scsi-do-not-automatically-select-scsi_dh-for-dm-multipath include/scsi/scsi_dh.h
--- a/include/scsi/scsi_dh.h~scsi-do-not-automatically-select-scsi_dh-for-dm-multipath
+++ a/include/scsi/scsi_dh.h
@@ -54,6 +54,16 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
