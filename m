From: akpm@linux-foundation.org
Subject: + rtc-mxc-fix-memory-leak.patch added to -mm tree
Date: Tue, 12 Jan 2010 17:46:05 -0800
Message-ID: <201001130146.o0D1k50r008061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab0AMBqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 20:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.beregalov@gmail.com, a.zummo@towertech.it, daniel@caiaq.de, p_gortmaker@yahoo.com, xiyou.wangcong@gmail.com


The patch titled
     rtc: mxc: fix memory leak
has been added to the -mm tree.  Its filename is
     rtc-mxc-fix-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: mxc: fix memory leak
From: Alexander Beregalov <a.beregalov@gmail.com>

Free pdata before exit.  Found by cppcheck.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Daniel Mack <daniel@caiaq.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-mxc-fix-memory-leak drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-mxc-fix-memory-leak
+++ a/drivers/rtc/rtc-mxc.c
@@ -396,8 +396,10 @@ static int __init mxc_rtc_probe(struct p
 	pdata->ioaddr = ioremap(res->start, resource_size(res));
 
 	clk = clk_get(&pdev->dev, "ckil");
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		goto exit_free_pdata;
+	}
 
 	rate = clk_get_rate(clk);
 	clk_put(clk);
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
linux-next.patch
rtc-mxc-fix-memory-leak.patch

