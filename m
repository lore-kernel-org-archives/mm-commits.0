From: akpm@linux-foundation.org
Subject: +
 drivers-misc-sgi-gru-grumainc-remove-bogus-0x-prefix-from-printk.patch
 added to -mm tree
Date: Wed, 26 Oct 2016 16:00:49 -0700
Message-ID: <581135a1./cXBvNYz5H4b8Tzh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40979 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcJZXAu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 19:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sivanich@sgi.com, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/sgi-gru/grumain.c: remove bogus 0x prefix from printk
has been added to the -mm tree.  Its filename is
     drivers-misc-sgi-gru-grumainc-remove-bogus-0x-prefix-from-printk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-misc-sgi-gru-grumainc-remove-bogus-0x-prefix-from-printk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-misc-sgi-gru-grumainc-remove-bogus-0x-prefix-from-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from sivanich@sgi.com are

drivers-misc-sgi-gru-grumainc-remove-bogus-0x-prefix-from-printk.patch

