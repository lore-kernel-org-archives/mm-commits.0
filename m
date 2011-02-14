From: akpm@linux-foundation.org
Subject: [merged] drivers-w1-masters-omap_hdqc-add-missing-clk_put.patch removed from -mm tree
Date: Mon, 14 Feb 2011 12:19:45 -0800
Message-ID: <201102142019.p1EKJjHF023014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015Ab1BNUUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 15:20:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, amit.kucheria@canonical.com, johnpol@2ka.mipt.ru, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     drivers/w1/masters/omap_hdq.c: add missing clk_put
has been removed from the -mm tree.  Its filename was
     drivers-w1-masters-omap_hdqc-add-missing-clk_put.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/w1/masters/omap_hdq.c: add missing clk_put
From: Julia Lawall <julia@diku.dk>

This code makes two calls to clk_get, then test both return values and
fails if either failed.  The problem is that in the first inner if, where
the first call to clk_get has failed, it don't know if the second call has
failed as well.  So it don't know whether clk_get should be called on the
result of the second call.  Of course, it would be possible to test that
value again.  A simpler solution is just to test the result of calling
clk_get directly after each call.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
position p1,p2;
expression e;
statement S;
@@

e = clk_get@p1(...)
...
if@p2 (IS_ERR(e)) S

@@
expression e;
statement S;
identifier l;
position r.p1, p2 != r.p2;
@@

*e = clk_get@p1(...)
... when != clk_put(e)
*if@p2 (...)
{
  ... when != clk_put(e)
* return ...;
}// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Amit Kucheria <amit.kucheria@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/w1/masters/omap_hdq.c~drivers-w1-masters-omap_hdqc-add-missing-clk_put drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~drivers-w1-masters-omap_hdqc-add-missing-clk_put
+++ a/drivers/w1/masters/omap_hdq.c
@@ -593,19 +593,17 @@ static int __devinit omap_hdq_probe(stru
 
 	/* get interface & functional clock objects */
 	hdq_data->hdq_ick = clk_get(&pdev->dev, "ick");
-	hdq_data->hdq_fck = clk_get(&pdev->dev, "fck");
+	if (IS_ERR(hdq_data->hdq_ick)) {
+		dev_dbg(&pdev->dev, "Can't get HDQ ick clock object\n");
+		ret = PTR_ERR(hdq_data->hdq_ick);
+		goto err_ick;
+	}
 
-	if (IS_ERR(hdq_data->hdq_ick) || IS_ERR(hdq_data->hdq_fck)) {
-		dev_dbg(&pdev->dev, "Can't get HDQ clock objects\n");
-		if (IS_ERR(hdq_data->hdq_ick)) {
-			ret = PTR_ERR(hdq_data->hdq_ick);
-			goto err_clk;
-		}
-		if (IS_ERR(hdq_data->hdq_fck)) {
-			ret = PTR_ERR(hdq_data->hdq_fck);
-			clk_put(hdq_data->hdq_ick);
-			goto err_clk;
-		}
+	hdq_data->hdq_fck = clk_get(&pdev->dev, "fck");
+	if (IS_ERR(hdq_data->hdq_fck)) {
+		dev_dbg(&pdev->dev, "Can't get HDQ fck clock object\n");
+		ret = PTR_ERR(hdq_data->hdq_fck);
+		goto err_fck;
 	}
 
 	hdq_data->hdq_usecount = 0;
@@ -665,10 +663,12 @@ err_fnclk:
 	clk_disable(hdq_data->hdq_ick);
 
 err_intfclk:
-	clk_put(hdq_data->hdq_ick);
 	clk_put(hdq_data->hdq_fck);
 
-err_clk:
+err_fck:
+	clk_put(hdq_data->hdq_ick);
+
+err_ick:
 	iounmap(hdq_data->hdq_base);
 
 err_ioremap:
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
drivers-mtd-maps-ts5500_flashc-avoid-calling-map_destroy-on-null.patch
drivers-char-bfin_jtag_commc-avoid-calling-put_tty_driver-on-null.patch
drivers-char-specialixc-convert-func_enter-to-func_exit.patch

