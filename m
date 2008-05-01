From: akpm@linux-foundation.org
Subject: + drivers-scsi-ncr53c8xxc-fix-warning.patch added to -mm tree
Date: Thu, 01 May 2008 03:45:50 -0700
Message-ID: <200805011045.m41Ajo58001336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754248AbYEAKpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 06:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, harvey.harrison@gmail.com


The patch titled
     drivers/scsi/ncr53c8xx.c: fix warning
has been added to the -mm tree.  Its filename is
     drivers-scsi-ncr53c8xxc-fix-warning.patch

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
Subject: drivers/scsi/ncr53c8xx.c: fix warning
From: Andrew Morton <akpm@linux-foundation.org>

drivers/scsi/ncr53c8xx.c: In function 'process_waiting_list':
drivers/scsi/ncr53c8xx.c:8225: warning: suggest parentheses around assignment used as truth value

recently added by

commit 172c122df5186e7cbd413d61757ff90267331002
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Mon Apr 28 16:50:03 2008 -0700

    scsi: fix integer as NULL pointer warnings

Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ncr53c8xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ncr53c8xx.c~drivers-scsi-ncr53c8xxc-fix-warning drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c~drivers-scsi-ncr53c8xxc-fix-warning
+++ a/drivers/scsi/ncr53c8xx.c
@@ -8222,7 +8222,7 @@ static void process_waiting_list(struct 
 #ifdef DEBUG_WAITING_LIST
 	if (waiting_list) printk("%s: waiting_list=%lx processing sts=%d\n", ncr_name(np), (u_long) waiting_list, sts);
 #endif
-	while (wcmd = waiting_list) {
+	while ((wcmd = waiting_list)) {
 		waiting_list = (struct scsi_cmnd *) wcmd->next_wcmd;
 		wcmd->next_wcmd = NULL;
 		if (sts == DID_OK) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pnp-fix-printk-format-warnings.patch
drivers-char-synclinkc-inbreak-mgsl_put_char.patch
drivers-char-synclinkc-inbreak-mgsl_put_char-fix.patch
drivers-scsi-ncr53c8xxc-fix-warning.patch

