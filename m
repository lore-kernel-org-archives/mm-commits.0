From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:48 -0800
Message-ID: <52e2b8d8.Zj+iBOFo6Thl6Nvx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaAXTCs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, duanj.fnst@cn.fujitsu.com

Subject: [merged] drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch removed from -mm tree
To: duanj.fnst@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:48 -0800


The patch titled
     Subject: drivers/rtc/rtc-pcf2127.c: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: drivers/rtc/rtc-pcf2127.c: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Fix a coccinelle error regarding usage of IS_ERR and PTR_ERR instead of
PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2127.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-pcf2127.c~drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero drivers/rtc/rtc-pcf2127.c
--- a/drivers/rtc/rtc-pcf2127.c~drivers-rtc-rtc-pcf2127c-replace-is_err-and-ptr_err-with-ptr_err_or_zero
+++ a/drivers/rtc/rtc-pcf2127.c
@@ -197,10 +197,7 @@ static int pcf2127_probe(struct i2c_clie
 				pcf2127_driver.driver.name,
 				&pcf2127_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(pcf2127->rtc))
-		return PTR_ERR(pcf2127->rtc);
