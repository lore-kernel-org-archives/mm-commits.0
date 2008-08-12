From: akpm@linux-foundation.org
Subject: + v4l1-make-pms-not-autoprobe-when-builtin.patch added to -mm tree
Date: Mon, 11 Aug 2008 17:09:31 -0700
Message-ID: <200808120009.m7C09VPs029442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbYHLAKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 20:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, alan@redhat.com, mchehab@infradead.org, rene.herman@gmail.com


The patch titled
     V4L1: make PMS not autoprobe when builtin.
has been added to the -mm tree.  Its filename is
     v4l1-make-pms-not-autoprobe-when-builtin.patch

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
Subject: V4L1: make PMS not autoprobe when builtin.
From: Rene Herman <rene.herman@keyaccess.nl>

The old Mediavision Pro Movie Studio legacy ISA V4L1 driver was found to
hang the boot during Ingo Molnar's testing of randconfig kernels.  Have it
require a "pms.enable=1" kernel parameter to enable the driver when
builtin which avoids such problems.

This is a deprecated and, very likely, unused driver.  Nothing changes
modular behaviour moreover.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pms.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/media/video/pms.c~v4l1-make-pms-not-autoprobe-when-builtin drivers/media/video/pms.c
--- a/drivers/media/video/pms.c~v4l1-make-pms-not-autoprobe-when-builtin
+++ a/drivers/media/video/pms.c
@@ -1019,10 +1019,22 @@ static int init_mediavision(void)
  *	Initialization and module stuff
  */
 
+#ifndef MODULE
+static int enable;
+module_param(enable, int, 0);
+#endif
+
 static int __init init_pms_cards(void)
 {
 	printk(KERN_INFO "Mediavision Pro Movie Studio driver 0.02\n");
 
+#ifndef MODULE
+	if (!enable) {
+		printk(KERN_INFO "Not enabled\n");
+		return -ENODEV;
+	}
+#endif
+
 	data_port = io_port +1;
 
 	if(init_mediavision())
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

v4l1-make-pms-not-autoprobe-when-builtin.patch
i2c-dont-autograb-i2c-pca-is.patch
pnp-make-the-resource-type-an-unsigned-long.patch
pnp-make-the-resource-type-an-unsigned-long-fix.patch

