From: akpm@linux-foundation.org
Subject: + misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch added
 to -mm tree
Date: Wed, 26 Oct 2016 12:50:36 -0700
Message-ID: <5811090c.0qebaB5QrvNfz2Rg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934349AbcJZTuh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 15:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, sivanich@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: misc: sgi-gru: print a hex number after a 0x prefix
has been added to the -mm tree.  Its filename is
     misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch
cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch

