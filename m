From: akpm@linux-foundation.org
Subject: - paride-pf-driver-fixes.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:20 -0800
Message-ID: <200711152109.lAFL9Ke5015435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759600AbXKOVQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, mm-commits@vger.kernel.org


The patch titled
     paride: pf driver fixes
has been removed from the -mm tree.  Its filename was
     paride-pf-driver-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paride: pf driver fixes
From: Ondrej Zary <linux@rainbow-software.org>

The pf driver for parallel port floppy drives seems to be broken.  At least
with Imation SuperDisk with EPAT chip, the driver calls pi_connect() and
pi_disconnect after each transferred sector.  At least with EPAT, this
operation is very expensive - causes drive recalibration.  Thus, transferring
even a single byte (dd if=/dev/pf0 of=/dev/null bs=1 count=1) takes 20
seconds, making the driver useless.

The pf_next_buf() function seems to be broken as it returns 1 always (except
when pf_run is non-zero), causing the loop in do_pf_read_drq (and
do_pf_write_drq) to be executed only once.

The following patch fixes this problem.  It also fixes swapped descriptions in
pf_lock() function and removes DBMSG macro, which seems useless.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/pf.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN drivers/block/paride/pf.c~paride-pf-driver-fixes drivers/block/paride/pf.c
--- a/drivers/block/paride/pf.c~paride-pf-driver-fixes
+++ a/drivers/block/paride/pf.c
@@ -488,13 +488,11 @@ static int pf_atapi(struct pf_unit *pf, 
 	return r;
 }
 
-#define DBMSG(msg)      ((verbose>1)?(msg):NULL)
-
 static void pf_lock(struct pf_unit *pf, int func)
 {
 	char lo_cmd[12] = { ATAPI_LOCK, pf->lun << 5, 0, 0, func, 0, 0, 0, 0, 0, 0, 0 };
 
-	pf_atapi(pf, lo_cmd, 0, pf_scratch, func ? "unlock" : "lock");
+	pf_atapi(pf, lo_cmd, 0, pf_scratch, func ? "lock" : "unlock");
 }
 
 static void pf_eject(struct pf_unit *pf)
@@ -555,7 +553,7 @@ static void pf_mode_sense(struct pf_unit
 	    { ATAPI_MODE_SENSE, pf->lun << 5, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0 };
 	char buf[8];
 
-	pf_atapi(pf, ms_cmd, 8, buf, DBMSG("mode sense"));
+	pf_atapi(pf, ms_cmd, 8, buf, "mode sense");
 	pf->media_status = PF_RW;
 	if (buf[3] & 0x80)
 		pf->media_status = PF_RO;
@@ -591,7 +589,7 @@ static void pf_get_capacity(struct pf_un
 	char buf[8];
 	int bs;
 
-	if (pf_atapi(pf, rc_cmd, 8, buf, DBMSG("get capacity"))) {
+	if (pf_atapi(pf, rc_cmd, 8, buf, "get capacity")) {
 		pf->media_status = PF_NM;
 		return;
 	}
@@ -804,13 +802,18 @@ static int pf_next_buf(void)
 	pf_buf += 512;
 	pf_block++;
 	if (!pf_run)
-		return 0;
-	if (!pf_count)
 		return 1;
-	spin_lock_irqsave(&pf_spin_lock, saved_flags);
-	pf_end_request(1);
-	spin_unlock_irqrestore(&pf_spin_lock, saved_flags);
-	return 1;
+	if (!pf_count) {
+		spin_lock_irqsave(&pf_spin_lock, saved_flags);
+		pf_end_request(1);
+		pf_req = elv_next_request(pf_queue);
+		spin_unlock_irqrestore(&pf_spin_lock, saved_flags);
+		if (!pf_req)
+			return 1;
+		pf_count = pf_req->current_nr_sectors;
+		pf_buf = pf_req->buffer;
+	}
+	return 0;
 }
 
 static inline void next_request(int success)
_

Patches currently in -mm which might be from linux@rainbow-software.org are

origin.patch
