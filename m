Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5056BC64EC4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjBCGwh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjBCGvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2E6193FD
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E16CB82984
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EFCC433D2;
        Fri,  3 Feb 2023 06:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407090;
        bh=Fol6oxuEfj7FagW4T7lScC/4rCbuwDEIw3kZLdhbSvs=;
        h=Date:To:From:Subject:From;
        b=wuhV2sSvKEyT8XMk+Qs7j2yEONpUI5DCrsuYcTmDpTGVL6Sog48a8xAwW8m5Zm5ew
         QUN10adMCYogA9IGV4zyhv4kKTQEWIthjDtDjot8xDvNsb1VUXNOPICAgyG8zABwQs
         rlU3++JT4PpDx5p0QS2iDwnQKp7C48QFJ8sV2i/U=
Date:   Thu, 02 Feb 2023 22:51:29 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-dfltcc-support-inflate-with-small-window.patch removed from -mm tree
Message-Id: <20230203065129.E2EFCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: DFLTCC support inflate with small window
has been removed from the -mm tree.  Its filename was
     lib-zlib-dfltcc-support-inflate-with-small-window.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: lib/zlib: DFLTCC support inflate with small window
Date: Thu, 26 Jan 2023 14:14:27 +0100

There is no hardware control for DFLTCC window size.  After this change,
software and hardware window formats no longer match: the software will
use wbits and wsize, and the hardware will use HB_BITS and HB_SIZE.

Since neither dictionary manipulation nor internal allocation functions
are relevant to kernel zlib and zlib_inflate_workspacesize() always use
MAX_WBITS for window size calculation, only dfltcc_can_inflate() and
dfltcc_inflate() functions are affected by this patch.

This commit is based on:
  https://github.com/zlib-ng/zlib-ng/commit/3eab317

Link: https://lkml.kernel.org/r/20230126131428.1222214-8-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/zlib_dfltcc/dfltcc_inflate.c~lib-zlib-dfltcc-support-inflate-with-small-window
+++ a/lib/zlib_dfltcc/dfltcc_inflate.c
@@ -22,10 +22,6 @@ int dfltcc_can_inflate(
             zlib_dfltcc_support == ZLIB_DFLTCC_DEFLATE_ONLY)
         return 0;
 
-    /* Unsupported compression settings */
-    if (state->wbits != HB_BITS)
-        return 0;
-
     /* Unsupported hardware */
     return is_bit_set(dfltcc_state->af.fns, DFLTCC_XPND) &&
                is_bit_set(dfltcc_state->af.fmts, DFLTCC_FMT0);
@@ -129,8 +125,6 @@ dfltcc_inflate_action dfltcc_inflate(
     /* Translate stream to parameter block */
     param->cvt = CVT_ADLER32;
     param->sbb = state->bits;
-    param->hl = state->whave; /* Software and hardware history formats match */
-    param->ho = (state->write - state->whave) & ((1 << HB_BITS) - 1);
     if (param->hl)
         param->nt = 0; /* Honor history for the first block */
     param->cv = state->check;
@@ -144,8 +138,6 @@ dfltcc_inflate_action dfltcc_inflate(
     strm->msg = oesc_msg(dfltcc_state->msg, param->oesc);
     state->last = cc == DFLTCC_CC_OK;
     state->bits = param->sbb;
-    state->whave = param->hl;
-    state->write = (param->ho + param->hl) & ((1 << HB_BITS) - 1);
     state->check = param->cv;
     if (cc == DFLTCC_CC_OP2_CORRUPT && param->oesc != 0) {
         /* Report an error if stream is corrupted */
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are


