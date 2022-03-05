Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20504C433FE
	for <mm-commits@archiver.kernel.org>; Sat,  5 Mar 2022 04:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiCEEaE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Mar 2022 23:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiCEEaB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2022 23:30:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1BA3ED33
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 20:29:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1283609FE
        for <mm-commits@vger.kernel.org>; Sat,  5 Mar 2022 04:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52087C004E1;
        Sat,  5 Mar 2022 04:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646454551;
        bh=Ba6bPHTW4yYgrzle9tTjMeLQGIHPn5To0kO7awLkKaE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=2ROiaIi+fIrjXajdE6EgR+VeJnnO4ppHrysqfpSpTgXpbEn+d0MWa+MR+iEdUtgvt
         N5EFUePhr1Evoy/+ss6uElBSaCBxurSjE4uPHN7vQ1AUgDzHXU6aSUCi9/VhX86sOr
         BFslu5TDTRNKQmrzYuq7HgAg6fifMfmEXt5MjHsQ=
Date:   Fri, 04 Mar 2022 20:29:10 -0800
To:     quic_qiancai@quicinc.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220304202822.d47f8084928321c83070d7d7@linux-foundation.org>
Subject: [patch 8/8] configs/debug: set CONFIG_DEBUG_INFO=y properly
Message-Id: <20220305042911.52087C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
