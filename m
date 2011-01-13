From: akpm@linux-foundation.org
Subject: [merged] pps-simplify-conditions-a-bit.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:27 -0800
Message-ID: <201101132012.p0DKC8jA030257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933703Ab1AMUMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, mm-commits@vger.kernel.org


The patch titled
     pps: simplify conditions a bit
has been removed from the -mm tree.  Its filename was
     pps-simplify-conditions-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: simplify conditions a bit
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Bitwise conjunction is distributive so we can simplify some conditions.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/pps/kapi.c~pps-simplify-conditions-a-bit drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-simplify-conditions-a-bit
+++ a/drivers/pps/kapi.c
@@ -182,8 +182,7 @@ void pps_event(struct pps_device *pps, s
 
 	/* Check the event */
 	pps->current_mode = pps->params.mode;
-	if ((event & PPS_CAPTUREASSERT) &
-			(pps->params.mode & PPS_CAPTUREASSERT)) {
+	if (event & pps->params.mode & PPS_CAPTUREASSERT) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
 			pps_add_offset(&ts_real,
@@ -197,8 +196,7 @@ void pps_event(struct pps_device *pps, s
 
 		captured = ~0;
 	}
-	if ((event & PPS_CAPTURECLEAR) &
-			(pps->params.mode & PPS_CAPTURECLEAR)) {
+	if (event & pps->params.mode & PPS_CAPTURECLEAR) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETCLEAR)
 			pps_add_offset(&ts_real,
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

origin.patch

