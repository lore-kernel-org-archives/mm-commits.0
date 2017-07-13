From: akpm@linux-foundation.org
Subject: [merged]
 arm-samsung-usb-ohci-move-inline-before-return-type.patch removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:43:45 -0700
Message-ID: <20170713204345.KCg9hGZjR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59956 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753097AbdGMUnq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:43:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: samsung: usb-ohci: move inline before return type
has been removed from the -mm tree.  Its filename was
     arm-samsung-usb-ohci-move-inline-before-return-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ARM: samsung: usb-ohci: move inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/667a515b8d0f10f2465d519f8595edd91552fc5e.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/platform_data/usb-ohci-s3c2410.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/platform_data/usb-ohci-s3c2410.h~arm-samsung-usb-ohci-move-inline-before-return-type include/linux/platform_data/usb-ohci-s3c2410.h
--- a/include/linux/platform_data/usb-ohci-s3c2410.h~arm-samsung-usb-ohci-move-inline-before-return-type
+++ a/include/linux/platform_data/usb-ohci-s3c2410.h
@@ -31,7 +31,7 @@ struct s3c2410_hcd_info {
 	void		(*report_oc)(struct s3c2410_hcd_info *, int ports);
 };
 
-static void inline s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
+static inline void s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
 {
 	if (info->report_oc != NULL) {
 		(info->report_oc)(info, ports);
_

Patches currently in -mm which might be from joe@perches.com are


