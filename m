From: akpm@linux-foundation.org
Subject: [alternative-merged]
 misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch removed from -mm
 tree
Date: Wed, 26 Oct 2016 15:59:22 -0700
Message-ID: <5811354a.0noaQ65cZfEdNKYN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40955 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932334AbcJZW7X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 18:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, sivanich@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: misc: sgi-gru: print a hex number after a 0x prefix
has been removed from the -mm tree.  Its filename was
     misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: misc: sgi-gru: print a hex number after a 0x prefix

It makes the result hard to interpret correctly if a base 10 number is
prefixed by 0x. So change to a hex number.

Link: http://lkml.kernel.org/r/20161026125658.25728-5-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grumain.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sgi-gru/grumain.c~misc-sgi-gru-print-a-hex-number-after-a-0x-prefix drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~misc-sgi-gru-print-a-hex-number-after-a-0x-prefix
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -283,8 +283,9 @@ static void gru_unload_mm_tracker(struct
 	spin_lock(&gru->gs_asid_lock);
 	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
 	asids->mt_ctxbitmap ^= ctxbitmap;
-	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
-		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
+	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%x, asidmap 0x%lx\n",
+		gru->gs_gid, gts, gms, (unsigned)gts->ts_ctxnum,
+		gms->ms_asidmap[0]);
 	spin_unlock(&gru->gs_asid_lock);
 	spin_unlock(&gms->ms_asid_lock);
 }
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are

fs-exofs-print-a-hex-number-after-a-0x-prefix.patch
block-dac960-print-a-hex-number-after-a-0x-prefix.patch
ipack-print-a-hex-number-after-a-0x-prefix.patch
cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch

