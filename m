Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8358C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Mar 2022 23:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbiCPXQY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Mar 2022 19:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiCPXQY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2022 19:16:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3D325F0
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 16:15:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 963B46165F
        for <mm-commits@vger.kernel.org>; Wed, 16 Mar 2022 23:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2A8C340F0;
        Wed, 16 Mar 2022 23:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647472507;
        bh=GcbgBfbmdsgKzXYTotfD37FdjeSjVzjYMevfGpeN48U=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=UcxSdmHklPhA0lec5rKi8nepTAqNQalUOLmo21EJ1Z7EsJaiK+1JJ3ECBHpPOx3DS
         yKO+uEilLu/DQWXeH7NqbNoB3/ke/jA8H7RToPyV4OVEES+WYWGKnmBEKypZdeUrIC
         j8HpIDMVDDVXrwwuuyhLKeCYZQ46bCJWY07rRYN4=
Date:   Wed, 16 Mar 2022 16:15:06 -0700
To:     keescook@chromium.org, daniel.thompson@linaro.org,
        quic_qiancai@quicinc.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220316161433.5c2e137a69eaee50d2249a27@linux-foundation.org>
Subject: [patch 2/4] configs/debug: restore DEBUG_INFO=y for overriding
Message-Id: <20220316231506.EB2A8C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Qian Cai <quic_qiancai@quicinc.com>
Subject: configs/debug: restore DEBUG_INFO=y for overriding

Previously, I failed to realize that Kees' patch [1] has not been merged
into the mainline yet, and dropped DEBUG_INFO=y too eagerly from the
mainline.  As the results, "make debug.config" won't be able to flip
DEBUG_INFO=n from the existing .config.  This should close the gaps of a
few weeks before Kees' patch is there, and work regardless of their
merging status anyway.

[1] https://lore.kernel.org/all/20220125075126.891825-1-keescook@chromium.org/

Link: https://lkml.kernel.org/r/20220308153524.8618-1-quic_qiancai@quicinc.com
Signed-off-by: Qian Cai <quic_qiancai@quicinc.com>
Reported-by: Daniel Thompson <daniel.thompson@linaro.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/configs/debug.config |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/configs/debug.config~configs-debug-restore-debug_info=y-for-overriding
+++ a/kernel/configs/debug.config
@@ -16,6 +16,7 @@ CONFIG_SYMBOLIC_ERRNAME=y
 #
 # Compile-time checks and compiler options
 #
+CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
 CONFIG_DEBUG_SECTION_MISMATCH=y
 CONFIG_FRAME_WARN=2048
_
