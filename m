Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5634C05027
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjAZXSg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbjAZXSW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:18:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A12335241
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:18:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F4E61997
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3D7C433EF;
        Thu, 26 Jan 2023 23:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674775098;
        bh=aemIIZ/CcI8pt3YnWxWPGxLNMXa7S97z0kfw8XckV3k=;
        h=Date:To:From:Subject:From;
        b=mNiw8SR9ph0nWxkM+MQdmz9SS41LvHK8mTq948eHiUHDL2ZNiqUflblKjHkzFLskS
         B1OdAiW8QHRDltMWDJCko3y1kpBaJVoEtfuA5A92na6wjfQjGIKq05vvjnfyM7uwmE
         VoKwt+/lPVwsqzvILtNRdn+gIryh3gYATDwQ7Gqc=
Date:   Thu, 26 Jan 2023 15:18:18 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-dfltcc-support-inflate-with-small-window.patch added to mm-nonmm-unstable branch
Message-Id: <20230126231818.7A3D7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: DFLTCC support inflate with small window
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-dfltcc-support-inflate-with-small-window.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-dfltcc-support-inflate-with-small-window.patch

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

 lib/zlib_dfltcc/dfltcc_inflate.c |    8 --------
 1 file changed, 8 deletions(-)

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

lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch
lib-zlib-implement-switching-between-dfltcc-and-software.patch
lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch
lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch
lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch
lib-zlib-split-deflate-and-inflate-states-for-dfltcc.patch
lib-zlib-dfltcc-support-inflate-with-small-window.patch
lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch

