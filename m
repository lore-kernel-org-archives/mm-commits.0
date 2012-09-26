From: akpm@linux-foundation.org
Subject: + deviceh-add-missing-inline-to-ifndef-config_printk-dev_vprintk_emit.patch added to -mm tree
Date: Wed, 26 Sep 2012 15:15:23 -0700
Message-ID: <20120926221524.1E664200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:47183 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2IZWP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 18:15:26 -0400
Received: by wgbdt11 with SMTP id dt11so80234wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 15:15:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, geert@linux-m68k.org, greg@kroah.com


The patch titled
     Subject: device.h: add missing inline to #ifndef CONFIG_PRINTK dev_vprintk_emit()
has been added to the -mm tree.  Its filename is
     deviceh-add-missing-inline-to-ifndef-config_printk-dev_vprintk_emit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
deviceh-add-missing-inline-to-ifndef-config_printk-dev_vprintk_emit.patch
maintainers-update-gianfar_ptp-after-renaming.patch
checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch
checkpatch-update-suggested-printk-conversions.patch
checkpatch-check-networking-specific-block-comment-style.patch
codingstyle-add-networking-specific-block-comment-style.patch

