From: akpm@osdl.org
Subject: + missing-includes-in-hilkbd.patch added to -mm tree
Date: Sun, 10 Dec 2006 12:01:10 -0800
Message-ID: <200612102001.kBAK1AAX001655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56334 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762465AbWLJUBR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 15:01:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk


The patch titled
     missing includes in hilkbd
has been added to the -mm tree.  Its filename is
     missing-includes-in-hilkbd.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: missing includes in hilkbd
From: Al Viro <viro@ftp.linux.org.uk>

Now that it's built on m68k too...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/input/keyboard/hilkbd.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/input/keyboard/hilkbd.c~missing-includes-in-hilkbd drivers/input/keyboard/hilkbd.c
--- a/drivers/input/keyboard/hilkbd.c~missing-includes-in-hilkbd
+++ a/drivers/input/keyboard/hilkbd.c
@@ -23,7 +23,12 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/hil.h>
+#include <linux/io.h>
 #include <linux/spinlock.h>
+#include <asm/irq.h>
+#ifdef CONFIG_HP300
+#include <asm/hwtest.h>
+#endif
 
 
 MODULE_AUTHOR("Philip Blundell, Matthew Wilcox, Helge Deller");
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

origin.patch
config_computone-should-depend-on-isaeisapci.patch
appldata_mem-dependes-on-vm-counters.patch
uml-problems-with-linux-ioh.patch
missing-includes-in-hilkbd.patch
hci-endianness-annotations.patch
lockd-endianness-annotations-rebased.patch
slab-leaks3-default-y.patch

