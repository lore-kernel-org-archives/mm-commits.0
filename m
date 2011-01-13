From: akpm@linux-foundation.org
Subject: [merged] pps-use-bug_on-for-kernel-api-safety-checks.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:26 -0800
Message-ID: <201101132012.p0DKC7e2030254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933755Ab1AMUUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: use BUG_ON for kernel API safety checks
has been removed from the -mm tree.  Its filename was
     pps-use-bug_on-for-kernel-api-safety-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: use BUG_ON for kernel API safety checks
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

This way less overhead is involved when running production kernel.  If you
want to debug a pps client module please define DEBUG to enable the
checks.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/pps/kapi.c~pps-use-bug_on-for-kernel-api-safety-checks drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-use-bug_on-for-kernel-api-safety-checks
+++ a/drivers/pps/kapi.c
@@ -166,10 +166,8 @@ void pps_event(struct pps_device *pps, s
 	int captured = 0;
 	struct pps_ktime ts_real;
 
-	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
-		dev_err(pps->dev, "unknown event (%x)\n", event);
-		return;
-	}
+	/* check event type */
+	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
 
 	dev_dbg(pps->dev, "PPS event at %ld.%09ld\n",
 			ts->ts_real.tv_sec, ts->ts_real.tv_nsec);
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

origin.patch

