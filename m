From: akpm@osdl.org
Subject: + fix-unaligned-exception-in-drivers-net-wireless-orinococ.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:25:39 -0800
Message-ID: <200701240725.l0O7PdqX011555@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56341 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933180AbXAXHcr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:32:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Michael.Hennerich@analog.com, jeff@garzik.org, jt@hpl.hp.com, linville@tuxdriver.com


The patch titled
     fix unaligned exception in /drivers/net/wireless/orinoco.c
has been added to the -mm tree.  Its filename is
     fix-unaligned-exception-in-drivers-net-wireless-orinococ.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix unaligned exception in /drivers/net/wireless/orinoco.c
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>

Prevent an unaligned exception to occur.  (GCC 4.1) tmp is defined as char
pointer while it is later accessed as short.

Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/wireless/orinoco.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/orinoco.c~fix-unaligned-exception-in-drivers-net-wireless-orinococ drivers/net/wireless/orinoco.c
--- a/drivers/net/wireless/orinoco.c~fix-unaligned-exception-in-drivers-net-wireless-orinococ
+++ a/drivers/net/wireless/orinoco.c
@@ -2059,7 +2059,7 @@ static int determine_firmware(struct net
 	int err;
 	struct comp_id nic_id, sta_id;
 	unsigned int firmver;
-	char tmp[SYMBOL_MAX_VER_LEN+1];
+	char tmp[SYMBOL_MAX_VER_LEN+1] __attribute__((aligned(2)));
 
 	/* Get the hardware version */
 	err = HERMES_READ_RECORD(hw, USER_BAP, HERMES_RID_NICID, &nic_id);
_

Patches currently in -mm which might be from Michael.Hennerich@analog.com are

fix-unaligned-exception-in-drivers-net-wireless-orinococ.patch
