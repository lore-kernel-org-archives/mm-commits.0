From: akpm@linux-foundation.org
Subject: [merged] iscsi_tcp-regression-remove-bogus-warn-on-in-write-path.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:30 -0800
Message-ID: <201002182045.o1IKjUUX002745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0BRUqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:46:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, mm-commits@vger.kernel.org


The patch titled
     iscsi_tcp regression: remove bogus warn on in write path
has been removed from the -mm tree.  Its filename was
     iscsi_tcp-regression-remove-bogus-warn-on-in-write-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
