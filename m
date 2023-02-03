Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52806C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjBCGwf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjBCGvk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00FB8E05D
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AA6E61DC2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE135C433EF;
        Fri,  3 Feb 2023 06:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407085;
        bh=UV1div/UYuHkKTpSrlpfSL5+ZStLFc0b/ffDmKd1X4Q=;
        h=Date:To:From:Subject:From;
        b=VKM+bthOSKTqo0055yEPskKtqWZmUD7C8cfzB2HihEquL5DpmknhzFiRnP7e7PtyB
         vOOAdaYY1V7Ybe0n1Wi58AdMTlPc8YXXyPxNQ6o7Zl5JfrHKZO9wAhsPfVPY22zGoH
         UxiDgiM6ElEpd2aLbHxPSugwB5VIH5CyQGA76Po8=
Date:   Thu, 02 Feb 2023 22:51:24 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-implement-switching-between-dfltcc-and-software.patch removed from -mm tree
Message-Id: <20230203065124.DE135C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: implement switching between DFLTCC and software
has been removed from the -mm tree.  Its filename was
     lib-zlib-implement-switching-between-dfltcc-and-software.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: lib/zlib: implement switching between DFLTCC and software
Date: Thu, 26 Jan 2023 14:14:22 +0100

This commit is based on:
  https://github.com/zlib-ng/zlib-ng/commit/fc04275

Link: https://lkml.kernel.org/r/20230126131428.1222214-3-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/zlib_dfltcc/dfltcc_deflate.c~lib-zlib-implement-switching-between-dfltcc-and-software
+++ a/lib/zlib_dfltcc/dfltcc_deflate.c
@@ -112,30 +112,36 @@ int dfltcc_deflate(
     int soft_bcc;
     int no_flush;
 
-    if (!dfltcc_can_deflate(strm))
+    if (!dfltcc_can_deflate(strm)) {
+        /* Clear history. */
+        if (flush == Z_FULL_FLUSH)
+            param->hl = 0;
         return 0;
+    }
 
 again:
     masked_avail_in = 0;
     soft_bcc = 0;
     no_flush = flush == Z_NO_FLUSH;
 
-    /* Trailing empty block. Switch to software, except when Continuation Flag
-     * is set, which means that DFLTCC has buffered some output in the
-     * parameter block and needs to be called again in order to flush it.
+    /* No input data. Return, except when Continuation Flag is set, which means
+     * that DFLTCC has buffered some output in the parameter block and needs to
+     * be called again in order to flush it.
      */
-    if (flush == Z_FINISH && strm->avail_in == 0 && !param->cf) {
-        if (param->bcf) {
-            /* A block is still open, and the hardware does not support closing
-             * blocks without adding data. Thus, close it manually.
-             */
+    if (strm->avail_in == 0 && !param->cf) {
+        /* A block is still open, and the hardware does not support closing
+         * blocks without adding data. Thus, close it manually.
+         */
+        if (!no_flush && param->bcf) {
             send_eobs(strm, param);
             param->bcf = 0;
         }
-        return 0;
-    }
-
-    if (strm->avail_in == 0 && !param->cf) {
+        /* Let one of deflate_* functions write a trailing empty block. */
+        if (flush == Z_FINISH)
+            return 0;
+        /* Clear history. */
+        if (flush == Z_FULL_FLUSH)
+            param->hl = 0;
         *result = need_more;
         return 1;
     }
@@ -189,7 +195,7 @@ again:
     param->cvt = CVT_ADLER32;
     if (!no_flush)
         /* We need to close a block. Always do this in software - when there is
-         * no input data, the hardware will not nohor BCC. */
+         * no input data, the hardware will not hohor BCC. */
         soft_bcc = 1;
     if (flush == Z_FINISH && !param->bcf)
         /* We are about to open a BFINAL block, set Block Header Final bit
@@ -204,8 +210,8 @@ again:
     param->sbb = (unsigned int)state->bi_valid;
     if (param->sbb > 0)
         *strm->next_out = (Byte)state->bi_buf;
-    if (param->hl)
-        param->nt = 0; /* Honor history */
+    /* Honor history and check value */
+    param->nt = 0;
     param->cv = strm->adler;
 
     /* When opening a block, choose a Huffman-Table Type */
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are


