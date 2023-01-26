Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DDAC05027
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjAZXSX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjAZXSR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:18:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219073645F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:18:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3480B81F40
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D808C4339B;
        Thu, 26 Jan 2023 23:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674775093;
        bh=vwdp5ZKW3+3jWwCuGl15zjpn9wNkv6KyUw6nkNuKPSw=;
        h=Date:To:From:Subject:From;
        b=T/vxhXJHxmaEM2AtvqSAlzoLaqrN7ILG4xGlwnXE4jPUCR9XM3rQsEU97PWEWsLdd
         oZJ8k0zbS1W/o2zwds5uST07aKorX/yt0b1hZkfXDA7EWt6KOrWnfmQTbWJHL79oMy
         8QgxwaRvrOx9j9MqABjCCOjmkVei33taSHrgilz0=
Date:   Thu, 26 Jan 2023 15:18:12 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch added to mm-nonmm-unstable branch
Message-Id: <20230126231813.5D808C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: DFLTCC not writing header bits when avail_out == 0
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch

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

 lib/zlib_dfltcc/dfltcc_deflate.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

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

lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch
lib-zlib-implement-switching-between-dfltcc-and-software.patch
lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch
lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch
lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch
lib-zlib-split-deflate-and-inflate-states-for-dfltcc.patch
lib-zlib-dfltcc-support-inflate-with-small-window.patch
lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch

