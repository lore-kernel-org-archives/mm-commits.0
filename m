From: akpm@linux-foundation.org
Subject: [merged] rtc-mxc-fix-memory-leak.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:16 -0800
Message-ID: <201003091910.o29JAGWM031587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782Ab0CITLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:11:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, a.zummo@towertech.it, daniel@caiaq.de, p_gortmaker@yahoo.com, xiyou.wangcong@gmail.com, yuasa@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     rtc: mxc: fix memory leak
has been removed from the -mm tree.  Its filename was
     rtc-mxc-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: mxc: fix memory leak
From: Alexander Beregalov <a.beregalov@gmail.com>

Free pdata before exit.  Found by cppcheck.

[yuasa@linux-mips.org: add missing iounmap()]
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-mxc-fix-memory-leak drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-mxc-fix-memory-leak
+++ a/drivers/rtc/rtc-mxc.c
@@ -396,8 +396,11 @@ static int __init mxc_rtc_probe(struct p
 	pdata->ioaddr = ioremap(res->start, resource_size(res));
 
 	clk = clk_get(&pdev->dev, "ckil");
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
+	if (IS_ERR(clk)) {
+		iounmap(pdata->ioaddr);
+		ret = PTR_ERR(clk);
+		goto exit_free_pdata;
+	}
 
 	rate = clk_get_rate(clk);
 	clk_put(clk);
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

linux-next.patch

