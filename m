From: akpm@linux-foundation.org
Subject: + rtc-mxc-fix-memory-leak-fix.patch added to -mm tree
Date: Wed, 03 Feb 2010 15:20:03 -0800
Message-ID: <201002032320.o13NK3Zr025543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755606Ab0BCXUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 18:20:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuasa@linux-mips.org, a.beregalov@gmail.com, a.zummo@towertech.it, daniel@caiaq.de, p_gortmaker@yahoo.com, xiyou.wangcong@gmail.com


The patch titled
     rtc-mxc-fix-memory-leak-fix
has been added to the -mm tree.  Its filename is
     rtc-mxc-fix-memory-leak-fix.patch

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

linux-next.patch
rtc-mxc-fix-memory-leak.patch
rtc-mxc-fix-memory-leak-fix.patch

