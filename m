From: akpm@linux-foundation.org
Subject: [merged] rtc-vr41xx-use-resource_size.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:05 -0800
Message-ID: <200912162035.nBGKZ5DZ013066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935248AbZLPUfN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuasa@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     rtc-vr41xx: use resource_size()
has been removed from the -mm tree.  Its filename was
     rtc-vr41xx-use-resource_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-vr41xx: use resource_size()
From: Yoichi Yuasa <yuasa@linux-mips.org>

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-vr41xx.c~rtc-vr41xx-use-resource_size drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-vr41xx-use-resource_size
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -327,7 +327,7 @@ static int __devinit rtc_probe(struct pl
 	if (!res)
 		return -EBUSY;
 
-	rtc1_base = ioremap(res->start, res->end - res->start + 1);
+	rtc1_base = ioremap(res->start, resource_size(res));
 	if (!rtc1_base)
 		return -EBUSY;
 
@@ -337,7 +337,7 @@ static int __devinit rtc_probe(struct pl
 		goto err_rtc1_iounmap;
 	}
 
-	rtc2_base = ioremap(res->start, res->end - res->start + 1);
+	rtc2_base = ioremap(res->start, resource_size(res));
 	if (!rtc2_base) {
 		retval = -EBUSY;
 		goto err_rtc1_iounmap;
_

Patches currently in -mm which might be from yuasa@linux-mips.org are

origin.patch

