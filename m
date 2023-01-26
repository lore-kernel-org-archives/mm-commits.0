Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C15C05027
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjAZXSM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjAZXSL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:18:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8032935241
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:18:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DCEAB81ED5
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D552EC4339B;
        Thu, 26 Jan 2023 23:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674775087;
        bh=RjFkp71PybJhRphFv+xl2dioetuA5Zz8XA54PMERcqg=;
        h=Date:To:From:Subject:From;
        b=r4Q1igayQvVBidoETtOPXH5ph4EQF+2U5ySgkQWgJed/T5YmNOTInUmv9tv8aPakl
         FRy7p1pKGLFajSdmIhGppnGNdO842+TEzlDu6F8RGXvuOKjVlc20dpqGeYjH5w/uSO
         aODs5RaYIww3rh7l3C93ZwuoGiWh2313b5e8PtXE=
Date:   Thu, 26 Jan 2023 15:18:07 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-implement-switching-between-dfltcc-and-software.patch added to mm-nonmm-unstable branch
Message-Id: <20230126231807.D552EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: implement switching between DFLTCC and software
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-implement-switching-between-dfltcc-and-software.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-implement-switching-between-dfltcc-and-software.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

 lib/zlib_dfltcc/dfltcc_deflate.c |   38 ++++++++++++++++-------------
 1 file changed, 22 insertions(+), 16 deletions(-)

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

lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch
lib-zlib-implement-switching-between-dfltcc-and-software.patch
lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch
lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch
lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch
lib-zlib-split-deflate-and-inflate-states-for-dfltcc.patch
lib-zlib-dfltcc-support-inflate-with-small-window.patch
lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch

