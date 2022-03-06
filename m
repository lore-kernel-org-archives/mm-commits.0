Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6152BC43217
	for <mm-commits@archiver.kernel.org>; Sun,  6 Mar 2022 22:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiCFWKB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 17:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiCFWJ7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 17:09:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03BD22BD6
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 14:09:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D26FB80F79
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 22:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7204C340EC;
        Sun,  6 Mar 2022 22:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646604538;
        bh=HoJbjiFagEbdFC9RWWpyhibq4Jf2Jgrlw4jal1bQavA=;
        h=Date:To:From:Subject:From;
        b=T08eariZ79I430Y5ttG+OFw0vYc9mDoa3lNene/dGhHfehzC+WRf9QiZQufack8PF
         tsv0v5WiKaM4BA3Dzlr2aIIcA+/6YQf7t2UaleA4Q7DxphFuV+q3AgwfVGwX6CzgtB
         Q5fsT6NXcVi7W4vKP3kQ1N300Q3Bk515HuvP2gHU=
Date:   Sun, 06 Mar 2022 14:08:57 -0800
To:     mm-commits@vger.kernel.org, quic_qiancai@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] configs-debug-set-config_debug_info=y-properly.patch removed from -mm tree
Message-Id: <20220306220857.E7204C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: configs/debug: set CONFIG_DEBUG_INFO=y properly
has been removed from the -mm tree.  Its filename was
     configs-debug-set-config_debug_info=y-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


