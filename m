From: akpm@linux-foundation.org
Subject: + firmware-loader-printk-when-requesting-firmware.patch added to -mm tree
Date: Sun, 27 Apr 2008 14:02:20 -0700
Message-ID: <200804272102.m3RL2KWR024665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbYD0VCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 17:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ciaran.mccreesh@googlemail.com, greg@kroah.com


The patch titled
     firmware loader: printk when requesting firmware
has been added to the -mm tree.  Its filename is
     firmware-loader-printk-when-requesting-firmware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

firmware-loader-printk-when-requesting-firmware.patch

