From: akpm@linux-foundation.org
Subject: - cfag12864b-fix-crash-when-built-in-and-no-parport.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:41 -0800
Message-ID: <200702211045.l1LAjf6G006391@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbXBUKps (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cfag12864b: fix crash when built-in and no parport present
has been removed from the -mm tree.  Its filename was
     cfag12864b-fix-crash-when-built-in-and-no-parport.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cfag12864b: fix crash when built-in and no parport present
From: Miguel Ojeda <maxextreme@gmail.com>

The problem comes when ks0108/cfag12864b are built-in and no parallel port is
present.  ks0108_init() is called first, as it should be, but fails to load
(as there is no parallel port to use).

After that, cfag12864b_init() gets called, without knowing anything about
ks0108 failed, and calls ks0108_writecontrol(), which dereferences an
uninitialized pointer.

Init order is OK, I think.  The problem is how to stop cfag12864b_init() being
called if ks0108 failed to load.  modprobe does it for us, but, how when
built-in?

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/cfag12864b.c   |   19 +++++++++++++++++++
 drivers/auxdisplay/cfag12864bfb.c |   10 +++++++++-
 drivers/auxdisplay/ks0108.c       |   12 ++++++++++++
 include/linux/cfag12864b.h        |    5 +++++
 include/linux/ks0108.h            |    3 +++
 5 files changed, 48 insertions(+), 1 deletion(-)

diff -puN drivers/auxdisplay/cfag12864b.c~cfag12864b-fix-crash-when-built-in-and-no-parport drivers/auxdisplay/cfag12864b.c
--- a/drivers/auxdisplay/cfag12864b.c~cfag12864b-fix-crash-when-built-in-and-no-parport
+++ a/drivers/auxdisplay/cfag12864b.c
@@ -312,6 +312,17 @@ EXPORT_SYMBOL_GPL(cfag12864b_disable);
 EXPORT_SYMBOL_GPL(cfag12864b_isenabled);
 
 /*
+ * Is the module inited?
+ */
+
+static unsigned char cfag12864b_inited;
+unsigned char cfag12864b_isinited(void)
+{
+	return cfag12864b_inited;
+}
+EXPORT_SYMBOL_GPL(cfag12864b_isinited);
+
+/*
  * Module Init & Exit
  */
 
@@ -319,6 +330,13 @@ static int __init cfag12864b_init(void)
 {
 	int ret = -EINVAL;
 
+	/* ks0108_init() must be called first */
+	if (!ks0108_isinited()) {
+		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
+			"ks0108 is not initialized\n");
+		goto none;
+	}
+
 	if (PAGE_SIZE < CFAG12864B_SIZE) {
 		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
 			"page size (%i) < cfag12864b size (%i)\n",
@@ -354,6 +372,7 @@ static int __init cfag12864b_init(void)
 	cfag12864b_clear();
 	cfag12864b_on();
 
+	cfag12864b_inited = 1;
 	return 0;
 
 cachealloced:
diff -puN drivers/auxdisplay/cfag12864bfb.c~cfag12864b-fix-crash-when-built-in-and-no-parport drivers/auxdisplay/cfag12864bfb.c
--- a/drivers/auxdisplay/cfag12864bfb.c~cfag12864b-fix-crash-when-built-in-and-no-parport
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -137,7 +137,14 @@ static struct platform_device *cfag12864
 
 static int __init cfag12864bfb_init(void)
 {
-	int ret;
+	int ret = -EINVAL;
+
+	/* cfag12864b_init() must be called first */
+	if (!cfag12864b_isinited()) {
+		printk(KERN_ERR CFAG12864BFB_NAME ": ERROR: "
+			"cfag12864b is not initialized\n");
+		goto none;
+	}
 
 	if (cfag12864b_enable()) {
 		printk(KERN_ERR CFAG12864BFB_NAME ": ERROR: "
@@ -162,6 +169,7 @@ static int __init cfag12864bfb_init(void
 		}
 	}
 
+none:
 	return ret;
 }
 
diff -puN drivers/auxdisplay/ks0108.c~cfag12864b-fix-crash-when-built-in-and-no-parport drivers/auxdisplay/ks0108.c
--- a/drivers/auxdisplay/ks0108.c~cfag12864b-fix-crash-when-built-in-and-no-parport
+++ a/drivers/auxdisplay/ks0108.c
@@ -111,6 +111,17 @@ EXPORT_SYMBOL_GPL(ks0108_address);
 EXPORT_SYMBOL_GPL(ks0108_page);
 
 /*
+ * Is the module inited?
+ */
+
+static unsigned char ks0108_inited;
+unsigned char ks0108_isinited(void)
+{
+	return ks0108_inited;
+}
+EXPORT_SYMBOL_GPL(ks0108_isinited);
+
+/*
  * Module Init & Exit
  */
 
@@ -142,6 +153,7 @@ static int __init ks0108_init(void)
 		goto registered;
 	}
 
+	ks0108_inited = 1;
 	return 0;
 
 registered:
diff -puN include/linux/cfag12864b.h~cfag12864b-fix-crash-when-built-in-and-no-parport include/linux/cfag12864b.h
--- a/include/linux/cfag12864b.h~cfag12864b-fix-crash-when-built-in-and-no-parport
+++ a/include/linux/cfag12864b.h
@@ -73,5 +73,10 @@ extern void cfag12864b_disable(void);
  */
 extern unsigned char cfag12864b_isenabled(void);
 
+/*
+ * Is the module inited?
+ */
+extern unsigned char cfag12864b_isinited(void);
+
 #endif /* _CFAG12864B_H_ */
 
diff -puN include/linux/ks0108.h~cfag12864b-fix-crash-when-built-in-and-no-parport include/linux/ks0108.h
--- a/include/linux/ks0108.h~cfag12864b-fix-crash-when-built-in-and-no-parport
+++ a/include/linux/ks0108.h
@@ -43,4 +43,7 @@ extern void ks0108_address(unsigned char
 /* Set the controller's current page (0..7) */
 extern void ks0108_page(unsigned char page);
 
+/* Is the module inited? */
+extern unsigned char ks0108_isinited(void);
+
 #endif /* _KS0108_H_ */
_

Patches currently in -mm which might be from maxextreme@gmail.com are
