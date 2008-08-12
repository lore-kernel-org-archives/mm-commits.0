From: akpm@linux-foundation.org
Subject: + isdn-make-icn-not-autograb-when-builtin.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:12:39 -0700
Message-ID: <200808120012.m7C0Cdx4029572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbYHLAN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, alan@lxorguk.ukuu.org.uk, fritz@isdn4linux.de, kkeil@suse.de, rene.herman@gmail.com


The patch titled
     ISDN: make ICN not autograb when builtin
has been added to the -mm tree.  Its filename is
     isdn-make-icn-not-autograb-when-builtin.patch

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
Subject: ISDN: make ICN not autograb when builtin
From: Rene Herman <rene.herman@keyaccess.nl>

The old ISDN ICN legacy ISA driver was found to break the boot during Ingo
Molnar's testing of randconfig kernels by grabbing bus resources even
without the hardware present.  Insist that the (existing) icn=io parameter
be specified when builtin so as to avoid such.

This is a deprecated driver (stack, even) and highly likely unused. 
Nothing changes modular moreover.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Karsten Keil <kkeil@suse.de>
Cc: Fritz Elfert <fritz@isdn4linux.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/icn/icn.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/icn/icn.c~isdn-make-icn-not-autograb-when-builtin drivers/isdn/icn/icn.c
--- a/drivers/isdn/icn/icn.c~isdn-make-icn-not-autograb-when-builtin
+++ a/drivers/isdn/icn/icn.c
@@ -1596,6 +1596,8 @@ icn_addcard(int port, char *id1, char *i
 }
 
 #ifndef MODULE
+static int enable;
+
 static int __init
 icn_setup(char *line)
 {
@@ -1605,8 +1607,10 @@ icn_setup(char *line)
 	static char sid2[20];
 
 	str = get_options(line, 2, ints);
-	if (ints[0])
+	if (ints[0]) {
 		portbase = ints[1];
+		enable = 1;
+	}
 	if (ints[0] > 1)
 		membase = (unsigned long)ints[2];
 	if (str && *str) {
@@ -1628,6 +1632,12 @@ static int __init icn_init(void)
 	char *p;
 	char rev[10];
 
+#ifndef MODULE
+	if (!enable) {
+		printk(KERN_INFO "ICN: please specify io\n");
+		return -ENODEV;
+	}
+#endif
 	memset(&dev, 0, sizeof(icn_dev));
 	dev.memaddr = (membase & 0x0ffc000);
 	dev.channel = -1;
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

v4l1-make-pms-not-autoprobe-when-builtin.patch
v4l1-make-pms-not-autoprobe-when-builtin-update.patch
i2c-dont-autograb-i2c-pca-is.patch
isdn-make-icn-not-autograb-when-builtin.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch

