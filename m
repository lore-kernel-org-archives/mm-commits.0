From: akpm@linux-foundation.org
Subject: [merged] pps-initialize-ts_real-properly.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:11:01 -0800
Message-ID: <201102282111.p1SLB1CT029374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755247Ab1B1VLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@linux.it, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pps: initialize ts_real properly
has been removed from the -mm tree.  Its filename was
     pps-initialize-ts_real-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: initialize ts_real properly
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Initialize ts_real.flags to fix compiler warning about possible
uninitialized use of this field.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/kapi.c~pps-initialize-ts_real-properly drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-initialize-ts_real-properly
+++ a/drivers/pps/kapi.c
@@ -168,7 +168,7 @@ void pps_event(struct pps_device *pps, s
 {
 	unsigned long flags;
 	int captured = 0;
-	struct pps_ktime ts_real;
+	struct pps_ktime ts_real = { .sec = 0, .nsec = 0, .flags = 0 };
 
 	/* check event type */
 	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

origin.patch
pps-make-pps_gen_parport-depend-on-broken.patch
pps-remove-unreachable-code.patch

