From: akpm@linux-foundation.org
Subject: [patch 031/114] uuid: cleanup <uapi/linux/uuid.h>
Date: Tue, 06 Feb 2018 15:37:48 -0800
Message-ID: <20180206233748.bsLn-CH4B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXhu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, andy.shevchenko@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: uuid: cleanup <uapi/linux/uuid.h>

Exported header doesn't use anything from <linux/string.h>,
it is <linux/uuid.h> which uses memcmp().

Link: http://lkml.kernel.org/r/20171225171121.GA22754@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uuid.h      |    1 +
 include/uapi/linux/uuid.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/uuid.h~uuid-cleanup-uapi-linux-uuidh include/linux/uuid.h
--- a/include/linux/uuid.h~uuid-cleanup-uapi-linux-uuidh
+++ a/include/linux/uuid.h
@@ -17,6 +17,7 @@
 #define _LINUX_UUID_H_
 
 #include <uapi/linux/uuid.h>
+#include <linux/string.h>
 
 #define UUID_SIZE 16
 
diff -puN include/uapi/linux/uuid.h~uuid-cleanup-uapi-linux-uuidh include/uapi/linux/uuid.h
--- a/include/uapi/linux/uuid.h~uuid-cleanup-uapi-linux-uuidh
+++ a/include/uapi/linux/uuid.h
@@ -19,7 +19,6 @@
 #define _UAPI_LINUX_UUID_H_
 
 #include <linux/types.h>
-#include <linux/string.h>
 
 typedef struct {
 	__u8 b[16];
_
