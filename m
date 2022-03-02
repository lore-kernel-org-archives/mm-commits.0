Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4C1C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Mar 2022 00:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiCBAZa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 19:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiCBAZ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 19:25:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BA58CD89
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 16:24:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D2D5FCE203A
        for <mm-commits@vger.kernel.org>; Wed,  2 Mar 2022 00:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B8FC340EE;
        Wed,  2 Mar 2022 00:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646180682;
        bh=jN81KJrLZoXryhKhDGi7la28dUaNj90mO4VTyU6Gvdc=;
        h=Date:To:From:Subject:From;
        b=1sZBdiGS5rJQJG/64z8lhcSJC1VXlIXsSkj/sEKHnTkT1n32BOvTBKKwBAdXkX/Rd
         k8E9Vnktx/8c1WCCzDtI2HctvuC/FeIXERJfD09EOHjWU857xcrRs2fcQjPswusehM
         zFc09DwIieKEAgrfMn8higgHu1wSZVanAX1Izwho=
Date:   Tue, 01 Mar 2022 16:24:42 -0800
To:     mm-commits@vger.kernel.org, quic_qiancai@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + configs-debug-set-config_debug_info=y-properly.patch added to -mm tree
Message-Id: <20220302002442.D2B8FC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: configs/debug: set CONFIG_DEBUG_INFO=y properly
has been added to the -mm tree.  Its filename is
     configs-debug-set-config_debug_info=y-properly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/configs-debug-set-config_debug_info=y-properly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/configs-debug-set-config_debug_info=y-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qian Cai <quic_qiancai@quicinc.com>
Subject: configs/debug: set CONFIG_DEBUG_INFO=y properly

CONFIG_DEBUG_INFO can't be set by user directly, so set
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y instead.  Otherwise, we end up
with no debuginfo in vmlinux which is a big no-no for kernel debugging.

Link: https://lkml.kernel.org/r/20220301202920.18488-1-quic_qiancai@quicinc.com
Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/debug.config |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/configs/debug.config~configs-debug-set-config_debug_info=y-properly
+++ a/kernel/configs/debug.config
@@ -16,7 +16,7 @@ CONFIG_SYMBOLIC_ERRNAME=y
 #
 # Compile-time checks and compiler options
 #
-CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DEBUG_SECTION_MISMATCH=y
 CONFIG_FRAME_WARN=2048
 CONFIG_SECTION_MISMATCH_WARN_ONLY=y
_

Patches currently in -mm which might be from quic_qiancai@quicinc.com are

configs-debug-set-config_debug_info=y-properly.patch

