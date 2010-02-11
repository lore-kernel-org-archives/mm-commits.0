From: akpm@linux-foundation.org
Subject: + iscsi_tcp-regression-remove-bogus-warn-on-in-write-path.patch added to -mm tree
Date: Thu, 11 Feb 2010 15:01:20 -0800
Message-ID: <201002112301.o1BN1Koh001371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757197Ab0BKXBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 18:01:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com


The patch titled
     iscsi_tcp regression: remove bogus warn on in write path
has been added to the -mm tree.  Its filename is
     iscsi_tcp-regression-remove-bogus-warn-on-in-write-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iscsi_tcp regression: remove bogus warn on in write path
From: Mike Christie <michaelc@cs.wisc.edu>

An empty r2tqueue is a valid state.  It just means that we have processed
all that there was to do.  This patch removes the WARN_ON that was added
when the kfifo changes were merged.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libiscsi_tcp.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/libiscsi_tcp.c~iscsi_tcp-regression-remove-bogus-warn-on-in-write-path drivers/scsi/libiscsi_tcp.c
--- a/drivers/scsi/libiscsi_tcp.c~iscsi_tcp-regression-remove-bogus-warn-on-in-write-path
+++ a/drivers/scsi/libiscsi_tcp.c
@@ -992,12 +992,10 @@ static struct iscsi_r2t_info *iscsi_tcp_
 		if (r2t == NULL) {
 			if (kfifo_out(&tcp_task->r2tqueue,
 			    (void *)&tcp_task->r2t, sizeof(void *)) !=
-			    sizeof(void *)) {
-				WARN_ONCE(1, "unexpected fifo state");
+			    sizeof(void *))
 				r2t = NULL;
-			}
