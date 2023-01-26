Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C69C05027
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjAZXSg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjAZXSY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:18:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD97360A5
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7086B81DC2
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51881C433D2;
        Thu, 26 Jan 2023 23:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674775100;
        bh=UENtvQVQCDMulvE412OloEiLkWSUjwvOZOx+u7s1lyc=;
        h=Date:To:From:Subject:From;
        b=pGfGYn0YNrgqHup9KrdRV5WD9yTZPk9LpnRMmP4I9gFk6LP4UnBKgwyQHcpLQpqjB
         KPaR6PiUsosZv5kuIaSjzLSeqzIoKudsoHALLl1Knt/IPV73T5TczcmGktQcLmqjO8
         exK/zOEj6k6jzb1QMLl2dFeC1ZK9mWWRM9e1fRIs=
Date:   Thu, 26 Jan 2023 15:18:19 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch added to mm-nonmm-unstable branch
Message-Id: <20230126231820.51881C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: DFLTCC always switch to software inflate for Z_PACKET_FLUSH option
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch

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
Subject: lib/zlib: DFLTCC always switch to software inflate for Z_PACKET_FLUSH option
Date: Thu, 26 Jan 2023 14:14:28 +0100

Since hardware inflate does not support Z_PACKET_FLUSH option (used
exclusively by kernel PPP driver), always switch to software like we
already do for Z_BLOCK flush option.  Without this patch, PPP might get
Z_DATA_ERROR return code from zlib_inflate() and disable zlib compression
for the packets.

Link: https://lkml.kernel.org/r/20230126131428.1222214-9-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_dfltcc/dfltcc_inflate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/zlib_dfltcc/dfltcc_inflate.c~lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option
+++ a/lib/zlib_dfltcc/dfltcc_inflate.c
@@ -95,8 +95,10 @@ dfltcc_inflate_action dfltcc_inflate(
     struct dfltcc_param_v0 *param = &dfltcc_state->param;
     dfltcc_cc cc;
 
-    if (flush == Z_BLOCK) {
-        /* DFLTCC does not support stopping on block boundaries */
+    if (flush == Z_BLOCK || flush == Z_PACKET_FLUSH) {
+        /* DFLTCC does not support stopping on block boundaries (Z_BLOCK flush option)
+         * as well as the use of Z_PACKET_FLUSH option (used exclusively by PPP driver)
+         */
         if (dfltcc_inflate_disable(strm)) {
             *ret = Z_STREAM_ERROR;
             return DFLTCC_INFLATE_BREAK;
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

