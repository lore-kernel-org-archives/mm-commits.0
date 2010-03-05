From: akpm@linux-foundation.org
Subject: [folded] rtc-mxc-fix-memory-leak-fix.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:25:16 -0800
Message-ID: <201003052125.o25LPGcf028507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab0CEV0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:26:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuasa@linux-mips.org, a.beregalov@gmail.com, a.zummo@towertech.it, daniel@caiaq.de, p_gortmaker@yahoo.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rtc-mxc-fix-memory-leak-fix
has been removed from the -mm tree.  Its filename was
     rtc-mxc-fix-memory-leak-fix.patch

This patch was dropped because it was folded into rtc-mxc-fix-memory-leak.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-mxc-fix-memory-leak-fix
From: Yoichi Yuasa <yuasa@linux-mips.org>

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-mxc.c~rtc-mxc-fix-memory-leak-fix drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-mxc-fix-memory-leak-fix
+++ a/drivers/rtc/rtc-mxc.c
@@ -397,6 +397,7 @@ static int __init mxc_rtc_probe(struct p
 
 	clk = clk_get(&pdev->dev, "ckil");
 	if (IS_ERR(clk)) {
+		iounmap(pdata->ioaddr);
 		ret = PTR_ERR(clk);
 		goto exit_free_pdata;
 	}
_

Patches currently in -mm which might be from yuasa@linux-mips.org are

origin.patch
rtc-mxc-fix-memory-leak.patch
rtc-mxc-fix-memory-leak-fix.patch

