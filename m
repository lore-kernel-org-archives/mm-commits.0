From: akpm@linux-foundation.org
Subject: [merged] drivers-net-irda-irda-usbc-fix-buffer-overflow.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:18:27 -0800
Message-ID: <200901161918.n0GJIR8V027084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758187AbZAPT1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:27:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josevteg@gmail.com, davem@davemloft.net, linville@tuxdriver.com, samuel@sortiz.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/irda/irda-usb.c: fix buffer overflow
has been removed from the -mm tree.  Its filename was
     drivers-net-irda-irda-usbc-fix-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/irda/irda-usb.c: fix buffer overflow
From: Jos-Vicente Gilabert <josevteg@gmail.com>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=12397

We're doing an sprintf of an 11-char string into an 11-char buffer. 
Whoops.  It breaks firmware uploading.

Reported-by: Jos-Vicente Gilabert <josevteg@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/irda-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/irda/irda-usb.c~drivers-net-irda-irda-usbc-fix-buffer-overflow drivers/net/irda/irda-usb.c
--- a/drivers/net/irda/irda-usb.c~drivers-net-irda-irda-usbc-fix-buffer-overflow
+++ a/drivers/net/irda/irda-usb.c
@@ -1073,7 +1073,7 @@ static int stir421x_patch_device(struct 
 {
 	unsigned int i;
 	int ret;
-	char stir421x_fw_name[11];
+	char stir421x_fw_name[12];
 	const struct firmware *fw;
 	const unsigned char *fw_version_ptr; /* pointer to version string */
 	unsigned long fw_version = 0;
_

Patches currently in -mm which might be from josevteg@gmail.com are

origin.patch

