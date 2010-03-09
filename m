From: akpm@linux-foundation.org
Subject: [merged] pca953x-minor-include-cleanup.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:10 -0800
Message-ID: <201003091911.o29JBAFD031715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756068Ab0CITWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, david-b@pacbell.net, khali@linux-fr.org, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     pca953x: minor include cleanup
has been removed from the -mm tree.  Its filename was
     pca953x-minor-include-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pca953x: minor include cleanup
From: Olof Johansson <olof@lixom.net>

linux/i2c/pca953x.h is a very bare include file.  Fix check for multiple
includes of linux/i2c/pca953x.h, and add dependent includes into the
header file.

Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/i2c/pca953x.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/i2c/pca953x.h~pca953x-minor-include-cleanup include/linux/i2c/pca953x.h
--- a/include/linux/i2c/pca953x.h~pca953x-minor-include-cleanup
+++ a/include/linux/i2c/pca953x.h
@@ -1,3 +1,9 @@
+#ifndef _LINUX_PCA953X_H
+#define _LINUX_PCA953X_H
+
+#include <linux/types.h>
+#include <linux/i2c.h>
+
 /* platform data for the PCA9539 16-bit I/O expander driver */
 
 struct pca953x_platform_data {
@@ -17,3 +23,5 @@ struct pca953x_platform_data {
 				void *context);
 	char		**names;
 };
+
+#endif /* _LINUX_PCA953X_H */
_

Patches currently in -mm which might be from olof@lixom.net are


