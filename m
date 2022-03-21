Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AEAC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 21 Mar 2022 20:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240609AbiCUUGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352886AbiCUUGx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2022 16:06:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557B9366A5
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 13:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17659B819BC
        for <mm-commits@vger.kernel.org>; Mon, 21 Mar 2022 20:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FA7C340F0;
        Mon, 21 Mar 2022 20:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647893124;
        bh=7oIX5ucCoPLYKbJ6E8TwpwRxyh/Ha0LaTLmtyDL8lFA=;
        h=Date:To:From:Subject:From;
        b=zQ8VfNcFNPVImXSbe8TnQnpNzbIqrf4v3wZvThBWR2NVkPA9OKy8Vz+0nK8FyMsx3
         /ttSFooHz0v/QZ9aNt2K+aSHdiU+goZGfahQ1YI2yOF7w+eCHTVx2IoLCv5Eo+zRLR
         OB8kPLxsE5f0gYdIYtEDYJq/3niiX/ViG/HFv4O8=
Date:   Mon, 21 Mar 2022 13:05:24 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        daniel.thompson@linaro.org, quic_qiancai@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] configs-debug-restore-debug_info=y-for-overriding.patch removed from -mm tree
Message-Id: <20220321200524.A3FA7C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: configs/debug: restore DEBUG_INFO=y for overriding
has been removed from the -mm tree.  Its filename was
     configs-debug-restore-debug_info=y-for-overriding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from quic_qiancai@quicinc.com are


