From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-ti-st-st_corec-missing-null-check.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:15 -0700
Message-ID: <20120731184916.1C0B120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:40902 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2GaStS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:18 -0400
Received: by wgbdt11 with SMTP id dt11so291014wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, pavan_savoy@ti.com, rucsoftsec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/ti-st/st_core.c: missing NULL check
has been removed from the -mm tree.  Its filename was
     drivers-misc-ti-st-st_corec-missing-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/misc/ti-st/st_core.c: missing NULL check

Addresses https://bugzilla.kernel.org/show_bug.cgi?44431

Reported-by: <rucsoftsec@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ti-st/st_core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/misc/ti-st/st_core.c~drivers-misc-ti-st-st_corec-missing-null-check drivers/misc/ti-st/st_core.c
--- a/drivers/misc/ti-st/st_core.c~drivers-misc-ti-st-st_corec-missing-null-check
+++ a/drivers/misc/ti-st/st_core.c
@@ -349,6 +349,11 @@ void st_int_recv(void *disc_data,
 			st_gdata->rx_skb = alloc_skb(
 					st_gdata->list[type]->max_frame_size,
 					GFP_ATOMIC);
+			if (st_gdata->rx_skb == NULL) {
+				pr_err("out of memory: dropping\n");
+				goto done;
+			}
+
 			skb_reserve(st_gdata->rx_skb,
 					st_gdata->list[type]->reserve);
 			/* next 2 required for BT only */
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch

