From: akpm@linux-foundation.org
Subject: - firmware-loader-printk-when-requesting-firmware.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:13 -0700
Message-ID: <200804300541.m3U5fDJW029038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756238AbYD3Flo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ciaran.mccreesh@googlemail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     firmware loader: printk when requesting firmware
has been removed from the -mm tree.  Its filename was
     firmware-loader-printk-when-requesting-firmware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: firmware loader: printk when requesting firmware
From: Ciaran McCreesh <ciaran.mccreesh@googlemail.com>

Before requesting firmware, printk a message saying what we're requesting. This
makes it easier to see what's going on, and provides an explanation for the
huge silent delay that one would otherwise get after accidentally building
ipw2200 as a non-module.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/firmware_class.c~firmware-loader-printk-when-requesting-firmware drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-loader-printk-when-requesting-firmware
+++ a/drivers/base/firmware_class.c
@@ -396,6 +396,8 @@ _request_firmware(const struct firmware 
 	if (!firmware_p)
 		return -EINVAL;
 
+	printk(KERN_INFO "firmware: requesting %s\n", name);
+
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
_

Patches currently in -mm which might be from ciaran.mccreesh@googlemail.com are

origin.patch

