Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F28C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjBCGwg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjBCGvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA741709
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9906F61DBB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE19EC4339B;
        Fri,  3 Feb 2023 06:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407088;
        bh=6GbAzNKfGy9StgXn1P2OAqRXkzBROEMO7cuazAIQno4=;
        h=Date:To:From:Subject:From;
        b=S1wO4l4pfiKe7z878VYt0u2I2Qv39AwNJDjCf4z1b6IN5qzZeLLFERsewEsUirsIH
         6duC2fVyhhp/EKkqdNR75HMZFiRTClNViaWiVSAdulpMGVi4s9z0ASfhX5trR4PGDn
         xpa9RI7v6ZTFvRCy/L0iqzjeXFgXFJPHV7zoIKsI=
Date:   Thu, 02 Feb 2023 22:51:27 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch removed from -mm tree
Message-Id: <20230203065127.EE19EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: DFLTCC not writing header bits when avail_out == 0
has been removed from the -mm tree.  Its filename was
     lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: lib/zlib: DFLTCC not writing header bits when avail_out == 0
Date: Thu, 26 Jan 2023 14:14:25 +0100

This commit is based on:
  https://github.com/zlib-ng/zlib-ng/commit/ce409c6

Link: https://lkml.kernel.org/r/20230126131428.1222214-6-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/zlib_dfltcc/dfltcc_deflate.c~lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0
+++ a/lib/zlib_dfltcc/dfltcc_deflate.c
@@ -170,13 +170,18 @@ again:
             param->bcf = 0;
             dfltcc_state->block_threshold =
                 strm->total_in + dfltcc_state->block_size;
-            if (strm->avail_out == 0) {
-                *result = need_more;
-                return 1;
-            }
         }
     }
 
+    /* No space for compressed data. If we proceed, dfltcc_cmpr() will return
+     * DFLTCC_CC_OP1_TOO_SHORT without buffering header bits, but we will still
+     * set BCF=1, which is wrong. Avoid complications and return early.
+     */
+    if (strm->avail_out == 0) {
+        *result = need_more;
+        return 1;
+    }
+
     /* The caller gave us too much data. Pass only one block worth of
      * uncompressed data to DFLTCC and mask the rest, so that on the next
      * iteration we start a new block.
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are


