From: akpm@linux-foundation.org
Subject: [merged] deviceh-add-missing-inline-to-ifndef-config_printk-dev_vprintk_emit.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:28:12 -0700
Message-ID: <20121001192813.115B620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62446 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2JAT2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:28:15 -0400
Received: by eaaq10 with SMTP id q10so343742eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:28:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, geert@linux-m68k.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: device.h: add missing inline to #ifndef CONFIG_PRINTK dev_vprintk_emit()
has been removed from the -mm tree.  Its filename was
     deviceh-add-missing-inline-to-ifndef-config_printk-dev_vprintk_emit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: device.h: add missing inline to #ifndef CONFIG_PRINTK dev_vprintk_emit()

Also add __printf() verification for format string.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/device.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/device.h~deviceh-add-missing-inline-to-ifndef-config_printk-dev_vprintk_emit include/linux/device.h
--- a/include/linux/device.h~deviceh-add-missing-inline-to-ifndef-config_printk-dev_vprintk_emit
+++ a/include/linux/device.h
@@ -902,8 +902,9 @@ extern const char *dev_driver_string(con
 
 #ifdef CONFIG_PRINTK
 
-extern int dev_vprintk_emit(int level, const struct device *dev,
-			    const char *fmt, va_list args);
+extern __printf(3, 0)
+int dev_vprintk_emit(int level, const struct device *dev,
+		     const char *fmt, va_list args);
 extern __printf(3, 4)
 int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...);
 
@@ -927,8 +928,9 @@ int _dev_info(const struct device *dev, 
 
 #else
 
-static int dev_vprintk_emit(int level, const struct device *dev,
-			    const char *fmt, va_list args)
+static inline __printf(3, 0)
+int dev_vprintk_emit(int level, const struct device *dev,
+		     const char *fmt, va_list args)
 { return 0; }
 static inline __printf(3, 4)
 int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...)
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-gianfar_ptp-after-renaming.patch
checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch
checkpatch-update-suggested-printk-conversions.patch
checkpatch-check-networking-specific-block-comment-style.patch
codingstyle-add-networking-specific-block-comment-style.patch

