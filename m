Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297FEC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjBCGwk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbjBCGvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1514DBC4
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F1BB80966
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B6EC433EF;
        Fri,  3 Feb 2023 06:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407089;
        bh=OA7/14VbVXiS+hNF3/aWyCHx8/5jdJVju+f4Hz3Rprw=;
        h=Date:To:From:Subject:From;
        b=wciS4/H+XwZzLX9W6acXkwzjINVTvEf9YCWeLAAn2AYDPqsU5/VocuGfnaVHF54ps
         WnHo+DRV3IQglA/cU7fXaqxLfMWCRvybL3ZNxaQrE0d0ou+ZEmKRbAws0h5uZ5bSXg
         plSR4BCWFAu9h4EAGgOJYGoutXBCmqCJnSoOUFSU=
Date:   Thu, 02 Feb 2023 22:51:28 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-split-deflate-and-inflate-states-for-dfltcc.patch removed from -mm tree
Message-Id: <20230203065128.E7B6EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: Split deflate and inflate states for DFLTCC
has been removed from the -mm tree.  Its filename was
     lib-zlib-split-deflate-and-inflate-states-for-dfltcc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: lib/zlib: Split deflate and inflate states for DFLTCC
Date: Thu, 26 Jan 2023 14:14:26 +0100

Currently deflate and inflate both use a common state struct. There are
several variables in this struct that we don't need for inflate, and
more may be coming in the future. Therefore split them in two separate
structs.
Apart from that, introduce separate headers for dfltcc_deflate and
dfltcc_inflate.

This commit is based on:
  https://github.com/zlib-ng/zlib-ng/commit/c592b1b

Link: https://lkml.kernel.org/r/20230126131428.1222214-7-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/zlib_deflate/deflate.c~lib-zlib-split-deflate-and-inflate-states-for-dfltcc
+++ a/lib/zlib_deflate/deflate.c
@@ -54,7 +54,7 @@
 
 /* architecture-specific bits */
 #ifdef CONFIG_ZLIB_DFLTCC
-#  include "../zlib_dfltcc/dfltcc.h"
+#  include "../zlib_dfltcc/dfltcc_deflate.h"
 #else
 #define DEFLATE_RESET_HOOK(strm) do {} while (0)
 #define DEFLATE_HOOK(strm, flush, bstate) 0
@@ -106,7 +106,7 @@ typedef struct deflate_workspace {
     deflate_state deflate_memory;
 #ifdef CONFIG_ZLIB_DFLTCC
     /* State memory for s390 hardware deflate */
-    struct dfltcc_state dfltcc_memory;
+    struct dfltcc_deflate_state dfltcc_memory;
 #endif
     Byte *window_memory;
     Pos *prev_memory;
--- a/lib/zlib_dfltcc/dfltcc.c~lib-zlib-split-deflate-and-inflate-states-for-dfltcc
+++ a/lib/zlib_dfltcc/dfltcc.c
@@ -23,37 +23,18 @@ char *oesc_msg(
     }
 }
 
-void dfltcc_reset(
-    z_streamp strm,
-    uInt size
-)
-{
-    struct dfltcc_state *dfltcc_state =
-        (struct dfltcc_state *)((char *)strm->state + size);
-    struct dfltcc_qaf_param *param =
-        (struct dfltcc_qaf_param *)&dfltcc_state->param;
-
+void dfltcc_reset_state(struct dfltcc_state *dfltcc_state) {
     /* Initialize available functions */
     if (is_dfltcc_enabled()) {
-        dfltcc(DFLTCC_QAF, param, NULL, NULL, NULL, NULL, NULL);
-        memmove(&dfltcc_state->af, param, sizeof(dfltcc_state->af));
+        dfltcc(DFLTCC_QAF, &dfltcc_state->param, NULL, NULL, NULL, NULL, NULL);
+        memmove(&dfltcc_state->af, &dfltcc_state->param, sizeof(dfltcc_state->af));
     } else
         memset(&dfltcc_state->af, 0, sizeof(dfltcc_state->af));
 
     /* Initialize parameter block */
     memset(&dfltcc_state->param, 0, sizeof(dfltcc_state->param));
     dfltcc_state->param.nt = 1;
-
-    /* Initialize tuning parameters */
-    if (zlib_dfltcc_support == ZLIB_DFLTCC_FULL_DEBUG)
-        dfltcc_state->level_mask = DFLTCC_LEVEL_MASK_DEBUG;
-    else
-        dfltcc_state->level_mask = DFLTCC_LEVEL_MASK;
-    dfltcc_state->block_size = DFLTCC_BLOCK_SIZE;
-    dfltcc_state->block_threshold = DFLTCC_FIRST_FHT_BLOCK_SIZE;
-    dfltcc_state->dht_threshold = DFLTCC_DHT_MIN_SAMPLE_SIZE;
     dfltcc_state->param.ribm = DFLTCC_RIBM;
 }
-EXPORT_SYMBOL(dfltcc_reset);
 
 MODULE_LICENSE("GPL");
--- a/lib/zlib_dfltcc/dfltcc_deflate.c~lib-zlib-split-deflate-and-inflate-states-for-dfltcc
+++ a/lib/zlib_dfltcc/dfltcc_deflate.c
@@ -2,11 +2,13 @@
 
 #include "../zlib_deflate/defutil.h"
 #include "dfltcc_util.h"
-#include "dfltcc.h"
+#include "dfltcc_deflate.h"
 #include <asm/setup.h>
 #include <linux/export.h>
 #include <linux/zutil.h>
 
+#define GET_DFLTCC_DEFLATE_STATE(state) ((struct dfltcc_deflate_state *)GET_DFLTCC_STATE(state))
+
 /*
  * Compress.
  */
@@ -15,7 +17,7 @@ int dfltcc_can_deflate(
 )
 {
     deflate_state *state = (deflate_state *)strm->state;
-    struct dfltcc_state *dfltcc_state = GET_DFLTCC_STATE(state);
+    struct dfltcc_deflate_state *dfltcc_state = GET_DFLTCC_DEFLATE_STATE(state);
 
     /* Check for kernel dfltcc command line parameter */
     if (zlib_dfltcc_support == ZLIB_DFLTCC_DISABLED ||
@@ -28,15 +30,32 @@ int dfltcc_can_deflate(
         return 0;
 
     /* Unsupported hardware */
-    if (!is_bit_set(dfltcc_state->af.fns, DFLTCC_GDHT) ||
-            !is_bit_set(dfltcc_state->af.fns, DFLTCC_CMPR) ||
-            !is_bit_set(dfltcc_state->af.fmts, DFLTCC_FMT0))
+    if (!is_bit_set(dfltcc_state->common.af.fns, DFLTCC_GDHT) ||
+            !is_bit_set(dfltcc_state->common.af.fns, DFLTCC_CMPR) ||
+            !is_bit_set(dfltcc_state->common.af.fmts, DFLTCC_FMT0))
         return 0;
 
     return 1;
 }
 EXPORT_SYMBOL(dfltcc_can_deflate);
 
+void dfltcc_reset_deflate_state(z_streamp strm) {
+    deflate_state *state = (deflate_state *)strm->state;
+    struct dfltcc_deflate_state *dfltcc_state = GET_DFLTCC_DEFLATE_STATE(state);
+
+    dfltcc_reset_state(&dfltcc_state->common);
+
+    /* Initialize tuning parameters */
+    if (zlib_dfltcc_support == ZLIB_DFLTCC_FULL_DEBUG)
+        dfltcc_state->level_mask = DFLTCC_LEVEL_MASK_DEBUG;
+    else
+        dfltcc_state->level_mask = DFLTCC_LEVEL_MASK;
+    dfltcc_state->block_size = DFLTCC_BLOCK_SIZE;
+    dfltcc_state->block_threshold = DFLTCC_FIRST_FHT_BLOCK_SIZE;
+    dfltcc_state->dht_threshold = DFLTCC_DHT_MIN_SAMPLE_SIZE;
+}
+EXPORT_SYMBOL(dfltcc_reset_deflate_state);
+
 static void dfltcc_gdht(
     z_streamp strm
 )
@@ -104,8 +123,8 @@ int dfltcc_deflate(
 )
 {
     deflate_state *state = (deflate_state *)strm->state;
-    struct dfltcc_state *dfltcc_state = GET_DFLTCC_STATE(state);
-    struct dfltcc_param_v0 *param = &dfltcc_state->param;
+    struct dfltcc_deflate_state *dfltcc_state = GET_DFLTCC_DEFLATE_STATE(state);
+    struct dfltcc_param_v0 *param = &dfltcc_state->common.param;
     uInt masked_avail_in;
     dfltcc_cc cc;
     int need_empty_block;
@@ -244,7 +263,7 @@ again:
     } while (cc == DFLTCC_CC_AGAIN);
 
     /* Translate parameter block to stream */
-    strm->msg = oesc_msg(dfltcc_state->msg, param->oesc);
+    strm->msg = oesc_msg(dfltcc_state->common.msg, param->oesc);
     state->bi_valid = param->sbb;
     if (state->bi_valid == 0)
         state->bi_buf = 0; /* Avoid accessing next_out */
--- /dev/null
+++ a/lib/zlib_dfltcc/dfltcc_deflate.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: Zlib
+#ifndef DFLTCC_DEFLATE_H
+#define DFLTCC_DEFLATE_H
+
+#include "dfltcc.h"
+
+/* External functions */
+int dfltcc_can_deflate(z_streamp strm);
+int dfltcc_deflate(z_streamp strm,
+                   int flush,
+                   block_state *result);
+void dfltcc_reset_deflate_state(z_streamp strm);
+
+#define DEFLATE_RESET_HOOK(strm) \
+    dfltcc_reset_deflate_state((strm))
+
+#define DEFLATE_HOOK dfltcc_deflate
+
+#define DEFLATE_NEED_CHECKSUM(strm) (!dfltcc_can_deflate((strm)))
+
+#endif /* DFLTCC_DEFLATE_H */
--- a/lib/zlib_dfltcc/dfltcc.h~lib-zlib-split-deflate-and-inflate-states-for-dfltcc
+++ a/lib/zlib_dfltcc/dfltcc.h
@@ -93,64 +93,32 @@ static_assert(sizeof(struct dfltcc_param
 struct dfltcc_state {
     struct dfltcc_param_v0 param;      /* Parameter block */
     struct dfltcc_qaf_param af;        /* Available functions */
+    char msg[64];                      /* Buffer for strm->msg */
+};
+
+/*
+ *  Extension of inflate_state and deflate_state for DFLTCC.
+ */
+struct dfltcc_deflate_state {
+    struct dfltcc_state common;        /* Parameter block */
     uLong level_mask;                  /* Levels on which to use DFLTCC */
     uLong block_size;                  /* New block each X bytes */
     uLong block_threshold;             /* New block after total_in > X */
     uLong dht_threshold;               /* New block only if avail_in >= X */
-    char msg[64];                      /* Buffer for strm->msg */
 };
 
 #define ALIGN_UP(p, size) (__typeof__(p))(((uintptr_t)(p) + ((size) - 1)) & ~((size) - 1))
 /* Resides right after inflate_state or deflate_state */
 #define GET_DFLTCC_STATE(state) ((struct dfltcc_state *)((char *)(state) + ALIGN_UP(sizeof(*state), 8)))
 
-/* External functions */
-int dfltcc_can_deflate(z_streamp strm);
-int dfltcc_deflate(z_streamp strm,
-                   int flush,
-                   block_state *result);
-void dfltcc_reset(z_streamp strm, uInt size);
-int dfltcc_can_inflate(z_streamp strm);
-typedef enum {
-    DFLTCC_INFLATE_CONTINUE,
-    DFLTCC_INFLATE_BREAK,
-    DFLTCC_INFLATE_SOFTWARE,
-} dfltcc_inflate_action;
-dfltcc_inflate_action dfltcc_inflate(z_streamp strm,
-                                     int flush, int *ret);
+void dfltcc_reset_state(struct dfltcc_state *dfltcc_state);
+
 static inline int is_dfltcc_enabled(void)
 {
 return (zlib_dfltcc_support != ZLIB_DFLTCC_DISABLED &&
         test_facility(DFLTCC_FACILITY));
 }
 
-#define DEFLATE_RESET_HOOK(strm) \
-    dfltcc_reset((strm), sizeof(deflate_state))
-
-#define DEFLATE_HOOK dfltcc_deflate
-
-#define DEFLATE_NEED_CHECKSUM(strm) (!dfltcc_can_deflate((strm)))
-
 #define DEFLATE_DFLTCC_ENABLED() is_dfltcc_enabled()
 
-#define INFLATE_RESET_HOOK(strm) \
-    dfltcc_reset((strm), sizeof(struct inflate_state))
-
-#define INFLATE_TYPEDO_HOOK(strm, flush) \
-    if (dfltcc_can_inflate((strm))) { \
-        dfltcc_inflate_action action; \
-\
-        RESTORE(); \
-        action = dfltcc_inflate((strm), (flush), &ret); \
-        LOAD(); \
-        if (action == DFLTCC_INFLATE_CONTINUE) \
-            break; \
-        else if (action == DFLTCC_INFLATE_BREAK) \
-            goto inf_leave; \
-    }
-
-#define INFLATE_NEED_CHECKSUM(strm) (!dfltcc_can_inflate((strm)))
-
-#define INFLATE_NEED_UPDATEWINDOW(strm) (!dfltcc_can_inflate((strm)))
-
 #endif /* DFLTCC_H */
--- a/lib/zlib_dfltcc/dfltcc_inflate.c~lib-zlib-split-deflate-and-inflate-states-for-dfltcc
+++ a/lib/zlib_dfltcc/dfltcc_inflate.c
@@ -2,7 +2,7 @@
 
 #include "../zlib_inflate/inflate.h"
 #include "dfltcc_util.h"
-#include "dfltcc.h"
+#include "dfltcc_inflate.h"
 #include <asm/setup.h>
 #include <linux/export.h>
 #include <linux/zutil.h>
@@ -32,6 +32,14 @@ int dfltcc_can_inflate(
 }
 EXPORT_SYMBOL(dfltcc_can_inflate);
 
+void dfltcc_reset_inflate_state(z_streamp strm) {
+    struct inflate_state *state = (struct inflate_state *)strm->state;
+    struct dfltcc_state *dfltcc_state = GET_DFLTCC_STATE(state);
+
+    dfltcc_reset_state(dfltcc_state);
+}
+EXPORT_SYMBOL(dfltcc_reset_inflate_state);
+
 static int dfltcc_was_inflate_used(
     z_streamp strm
 )
--- /dev/null
+++ a/lib/zlib_dfltcc/dfltcc_inflate.h
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: Zlib
+#ifndef DFLTCC_INFLATE_H
+#define DFLTCC_INFLATE_H
+
+#include "dfltcc.h"
+
+/* External functions */
+void dfltcc_reset_inflate_state(z_streamp strm);
+int dfltcc_can_inflate(z_streamp strm);
+typedef enum {
+    DFLTCC_INFLATE_CONTINUE,
+    DFLTCC_INFLATE_BREAK,
+    DFLTCC_INFLATE_SOFTWARE,
+} dfltcc_inflate_action;
+dfltcc_inflate_action dfltcc_inflate(z_streamp strm,
+                                     int flush, int *ret);
+#define INFLATE_RESET_HOOK(strm) \
+    dfltcc_reset_inflate_state((strm))
+
+#define INFLATE_TYPEDO_HOOK(strm, flush) \
+    if (dfltcc_can_inflate((strm))) { \
+        dfltcc_inflate_action action; \
+\
+        RESTORE(); \
+        action = dfltcc_inflate((strm), (flush), &ret); \
+        LOAD(); \
+        if (action == DFLTCC_INFLATE_CONTINUE) \
+            break; \
+        else if (action == DFLTCC_INFLATE_BREAK) \
+            goto inf_leave; \
+    }
+
+#define INFLATE_NEED_CHECKSUM(strm) (!dfltcc_can_inflate((strm)))
+
+#define INFLATE_NEED_UPDATEWINDOW(strm) (!dfltcc_can_inflate((strm)))
+
+#endif /* DFLTCC_DEFLATE_H */
--- a/lib/zlib_inflate/inflate.c~lib-zlib-split-deflate-and-inflate-states-for-dfltcc
+++ a/lib/zlib_inflate/inflate.c
@@ -17,7 +17,7 @@
 
 /* architecture-specific bits */
 #ifdef CONFIG_ZLIB_DFLTCC
-#  include "../zlib_dfltcc/dfltcc.h"
+#  include "../zlib_dfltcc/dfltcc_inflate.h"
 #else
 #define INFLATE_RESET_HOOK(strm) do {} while (0)
 #define INFLATE_TYPEDO_HOOK(strm, flush) do {} while (0)
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are


