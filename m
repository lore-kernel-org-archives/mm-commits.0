From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-efic-remove-empty-function.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:33:54 -0700
Message-ID: <51db1422.7mbL5TDR/XlgErsf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3GHTdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dannf@hp.com, sachin.kamat@linaro.org

Subject: [merged] drivers-rtc-rtc-efic-remove-empty-function.patch removed from -mm tree
To: sachin.kamat@linaro.org,dannf@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:54 -0700


The patch titled
     Subject: drivers/rtc/rtc-efi.c: remove empty function
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-efic-remove-empty-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-efi.c: remove empty function

After the switch to devm_* functions and the removal of
rtc_device_unregister(), the 'remove' function does not do anything.
Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: dann frazier <dannf@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/rtc/rtc-efi.c~drivers-rtc-rtc-efic-remove-empty-function drivers/rtc/rtc-efi.c
--- a/drivers/rtc/rtc-efi.c~drivers-rtc-rtc-efic-remove-empty-function
+++ a/drivers/rtc/rtc-efi.c
@@ -201,17 +201,11 @@ static int __init efi_rtc_probe(struct p
 	return 0;
 }
 
-static int __exit efi_rtc_remove(struct platform_device *dev)
-{
-	return 0;
-}
