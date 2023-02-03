Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55163C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjBCGwl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232514AbjBCGvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBB54F35F
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C925B82982
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC5EC4339C;
        Fri,  3 Feb 2023 06:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407091;
        bh=zYVgfS11hMAfD4kkKHHftSAyawDv/KeC3g5ZEYIb6tg=;
        h=Date:To:From:Subject:From;
        b=T+VJr8Nn/RmvgwBVA9xf856izPCLQGVWSFCJJJpqcub0pO9ZQyb9SbpkrxnYVrlzL
         GM+cLO8/fBq7Ng8VPPNebuehV5WDemJkDUPurUiaNWgVJPHi53SnuBej1VVnIhj61e
         AmYtFwakTgvQd3m6oS1ILi5fTWiZJ3t62UKKysWs=
Date:   Thu, 02 Feb 2023 22:51:30 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch removed from -mm tree
Message-Id: <20230203065130.DAC5EC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: DFLTCC always switch to software inflate for Z_PACKET_FLUSH option
has been removed from the -mm tree.  Its filename was
     lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


