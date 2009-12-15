From: akpm@linux-foundation.org
Subject: [merged] drivers-mmc-move-dereference-after-null-test.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:30 -0800
Message-ID: <200912152158.nBFLwUBG015824__1903.82174118913$1260914807$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755618AbZLOWFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:05:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/mmc: Move dereference after NULL test
has been removed from the -mm tree.  Its filename was
     drivers-mmc-move-dereference-after-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mmc: Move dereference after NULL test
From: Julia Lawall <julia@diku.dk>

If the NULL test on mrq is needed, then the derefernce should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/s3cmci.c~drivers-mmc-move-dereference-after-null-test drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~drivers-mmc-move-dereference-after-null-test
+++ a/drivers/mmc/host/s3cmci.c
@@ -820,7 +820,7 @@ fail_request:
 static void finalize_request(struct s3cmci_host *host)
 {
 	struct mmc_request *mrq = host->mrq;
-	struct mmc_command *cmd = host->cmd_is_stop ? mrq->stop : mrq->cmd;
+	struct mmc_command *cmd;
 	int debug_as_failure = 0;
 
 	if (host->complete_what != COMPLETION_FINALIZE)
@@ -828,6 +828,7 @@ static void finalize_request(struct s3cm
 
 	if (!mrq)
 		return;
+	cmd = host->cmd_is_stop ? mrq->stop : mrq->cmd;
 
 	if (cmd->data && (cmd->error == 0) &&
 	    (cmd->data->error == 0)) {
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-media-video-move-dereference-after-null-test.patch
drivers-isdn-eliminate-duplicated-test.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-block-dac960c-use-dac960_v2_controller.patch
drivers-usb-wusbcore-introduce-missing-usb_free_urb.patch
drivers-video-move-dereference-after-null-test.patch
drivers-char-ipmi-use-kcs_idle_state.patch
drivers-edac-introduce-missing-kfree.patch

