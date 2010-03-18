From: akpm@linux-foundation.org
Subject: + iscsi-change-to.patch added to -mm tree
Date: Thu, 18 Mar 2010 12:24:23 -0700
Message-ID: <201003181924.o2IJONt5011034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181Ab0CRTYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 15:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu


The patch titled
     iscsi: change & to &&
has been added to the -mm tree.  Its filename is
     iscsi-change-to.patch

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
Subject: iscsi: change & to &&
From: Dan Carpenter <error27@gmail.com>

This change is basically a clean up.

datadgst_en is an int which comes from the user.  I didn't see anything
limiting it to 1 and 0 although obviously that's what it's supposed to be.
 If the user passed in 2 this test would fail.

This same if condition is repeated in another function and it uses &&
there.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libiscsi_tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/libiscsi_tcp.c~iscsi-change-to drivers/scsi/libiscsi_tcp.c
--- a/drivers/scsi/libiscsi_tcp.c~iscsi-change-to
+++ a/drivers/scsi/libiscsi_tcp.c
@@ -420,7 +420,7 @@ iscsi_tcp_data_recv_prep(struct iscsi_tc
 	struct iscsi_conn *conn = tcp_conn->iscsi_conn;
 	struct hash_desc *rx_hash = NULL;
 
-	if (conn->datadgst_en &
+	if (conn->datadgst_en &&
 	    !(conn->session->tt->caps & CAP_DIGEST_OFFLOAD))
 		rx_hash = tcp_conn->rx_hash;
 
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
memcontrol-fix-potential-null-deref.patch
rtc-mc13783-fix-use-after-free-bug.patch
linux-next.patch
dpt_i20-several-use-after-free-issues.patch
i915-fix-small-leak-on-error-path.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
proc-cleanup-remove-unused-assignments.patch

