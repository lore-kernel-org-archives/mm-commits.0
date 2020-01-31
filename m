From: akpm@linux-foundation.org
Subject: [merged]
 lib-zlib-add-zlib_deflate_dfltcc_enabled-function.patch removed from -mm
 tree
Date: Fri, 31 Jan 2020 15:20:26 -0800
Message-ID: <20200131232026.Nz1hCe7II%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXU2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: borntraeger@de.ibm.com, clm@fb.com, dsterba@suse.com, edward6@linux.ibm.com, gor@linux.ibm.com, heiko.carstens@de.ibm.com, iii@linux.ibm.com, josef@toxicpanda.com, mm-commits@vger.kernel.org, rpurdie@rpsys.net, zaslonko@linux.ibm.com


The patch titled
     Subject: lib/zlib: add zlib_deflate_dfltcc_enabled() function
has been removed from the -mm tree.  Its filename was
     lib-zlib-add-zlib_deflate_dfltcc_enabled-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: lib/zlib: add zlib_deflate_dfltcc_enabled() function

Add a new function to zlib.h checking if s390 Deflate-Conversion facility
is installed and enabled.

Link: http://lkml.kernel.org/r/20200103223334.20669-6-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Eduard Shishkin <edward6@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zlib.h            |    6 ++++++
 lib/zlib_deflate/deflate.c      |    6 ++++++
 lib/zlib_deflate/deflate_syms.c |    1 +
 lib/zlib_dfltcc/dfltcc.h        |   11 +++++++++++
 lib/zlib_dfltcc/dfltcc_util.h   |    9 ---------
 5 files changed, 24 insertions(+), 9 deletions(-)

--- a/include/linux/zlib.h~lib-zlib-add-zlib_deflate_dfltcc_enabled-function
+++ a/include/linux/zlib.h
@@ -191,6 +191,12 @@ extern int zlib_deflate_workspacesize (i
    exceed those passed here.
 */
 
+extern int zlib_deflate_dfltcc_enabled (void);
+/*
+   Returns 1 if Deflate-Conversion facility is installed and enabled,
+   otherwise 0.
+*/
+
 /* 
 extern int deflateInit (z_streamp strm, int level);
 
--- a/lib/zlib_deflate/deflate.c~lib-zlib-add-zlib_deflate_dfltcc_enabled-function
+++ a/lib/zlib_deflate/deflate.c
@@ -59,6 +59,7 @@
 #define DEFLATE_RESET_HOOK(strm) do {} while (0)
 #define DEFLATE_HOOK(strm, flush, bstate) 0
 #define DEFLATE_NEED_CHECKSUM(strm) 1
+#define DEFLATE_DFLTCC_ENABLED() 0
 #endif
 
 /* ===========================================================================
@@ -1138,3 +1139,8 @@ int zlib_deflate_workspacesize(int windo
         + zlib_deflate_head_memsize(memLevel)
         + zlib_deflate_overlay_memsize(memLevel);
 }
+
+int zlib_deflate_dfltcc_enabled(void)
+{
+	return DEFLATE_DFLTCC_ENABLED();
+}
--- a/lib/zlib_deflate/deflate_syms.c~lib-zlib-add-zlib_deflate_dfltcc_enabled-function
+++ a/lib/zlib_deflate/deflate_syms.c
@@ -12,6 +12,7 @@
 #include <linux/zlib.h>
 
 EXPORT_SYMBOL(zlib_deflate_workspacesize);
+EXPORT_SYMBOL(zlib_deflate_dfltcc_enabled);
 EXPORT_SYMBOL(zlib_deflate);
 EXPORT_SYMBOL(zlib_deflateInit2);
 EXPORT_SYMBOL(zlib_deflateEnd);
--- a/lib/zlib_dfltcc/dfltcc.h~lib-zlib-add-zlib_deflate_dfltcc_enabled-function
+++ a/lib/zlib_dfltcc/dfltcc.h
@@ -3,6 +3,8 @@
 #define DFLTCC_H
 
 #include "../zlib_deflate/defutil.h"
+#include <asm/facility.h>
+#include <asm/setup.h>
 
 /*
  * Tuning parameters.
@@ -14,6 +16,8 @@
 #define DFLTCC_DHT_MIN_SAMPLE_SIZE 4096
 #define DFLTCC_RIBM 0
 
+#define DFLTCC_FACILITY 151
+
 /*
  * Parameter Block for Query Available Functions.
  */
@@ -113,6 +117,11 @@ typedef enum {
 } dfltcc_inflate_action;
 dfltcc_inflate_action dfltcc_inflate(z_streamp strm,
                                      int flush, int *ret);
+static inline int is_dfltcc_enabled(void)
+{
+return (zlib_dfltcc_support != ZLIB_DFLTCC_DISABLED &&
+        test_facility(DFLTCC_FACILITY));
+}
 
 #define DEFLATE_RESET_HOOK(strm) \
     dfltcc_reset((strm), sizeof(deflate_state))
@@ -121,6 +130,8 @@ dfltcc_inflate_action dfltcc_inflate(z_s
 
 #define DEFLATE_NEED_CHECKSUM(strm) (!dfltcc_can_deflate((strm)))
 
+#define DEFLATE_DFLTCC_ENABLED() is_dfltcc_enabled()
+
 #define INFLATE_RESET_HOOK(strm) \
     dfltcc_reset((strm), sizeof(struct inflate_state))
 
--- a/lib/zlib_dfltcc/dfltcc_util.h~lib-zlib-add-zlib_deflate_dfltcc_enabled-function
+++ a/lib/zlib_dfltcc/dfltcc_util.h
@@ -3,8 +3,6 @@
 #define DFLTCC_UTIL_H
 
 #include <linux/zutil.h>
-#include <asm/facility.h>
-#include <asm/setup.h>
 
 /*
  * C wrapper for the DEFLATE CONVERSION CALL instruction.
@@ -24,7 +22,6 @@ typedef enum {
 #define HBT_CIRCULAR (1 << 7)
 #define HB_BITS 15
 #define HB_SIZE (1 << HB_BITS)
-#define DFLTCC_FACILITY 151
 
 static inline dfltcc_cc dfltcc(
     int fn,
@@ -101,12 +98,6 @@ static inline int dfltcc_are_params_ok(
         (strategy == Z_DEFAULT_STRATEGY);
 }
 
-static inline int is_dfltcc_enabled(void)
-{
-    return (zlib_dfltcc_support != ZLIB_DFLTCC_DISABLED &&
-            test_facility(DFLTCC_FACILITY));
-}
