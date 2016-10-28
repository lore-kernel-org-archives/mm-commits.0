From: akpm@linux-foundation.org
Subject: [patch 20/20] drivers/misc/sgi-gru/grumain.c: remove bogus 0x
 prefix from printk
Date: Thu, 27 Oct 2016 17:47:12 -0700
Message-ID: <5812a010.fxiqp5uXTQUxU7bo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935453AbcJ1ArN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:47:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sivanich@sgi.com, u.kleine-koenig@pengutronix.de

From: Dimitri Sivanich <sivanich@sgi.com>
Subject: drivers/misc/sgi-gru/grumain.c: remove bogus 0x prefix from printk

Would like to have this be a decimal number.

Link: http://lkml.kernel.org/r/20161026134746.GA30169@sgi.com
Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grumain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grumain.c~drivers-misc-sgi-gru-grumainc-remove-bogus-0x-prefix-from-printk drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~drivers-misc-sgi-gru-grumainc-remove-bogus-0x-prefix-from-printk
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -283,7 +283,7 @@ static void gru_unload_mm_tracker(struct
 	spin_lock(&gru->gs_asid_lock);
 	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
 	asids->mt_ctxbitmap ^= ctxbitmap;
-	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
+	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum %d, asidmap 0x%lx\n",
 		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
 	spin_unlock(&gru->gs_asid_lock);
 	spin_unlock(&gms->ms_asid_lock);
_
