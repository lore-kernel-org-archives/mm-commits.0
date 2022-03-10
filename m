Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FA0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Mar 2022 01:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbiCJBLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Mar 2022 20:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiCJBLr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2022 20:11:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B91121682
        for <mm-commits@vger.kernel.org>; Wed,  9 Mar 2022 17:10:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 798966136D
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 01:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10DFC340E8;
        Thu, 10 Mar 2022 01:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646874646;
        bh=FE7lHsX6eHEPcQFVakhMGWSnZWpCqB6AaV2znYL93KE=;
        h=Date:To:From:Subject:From;
        b=LTrBKWs0lIHevRArBrHf1UPV/NcfTS00z2U/kSAFJKedMxRRcyIocl4OBvQNARAGG
         0NMQFRmfwjI+ihZsqxvsKTfcqAZ25QXKCqLIYKLbnu412/U0qJsDV9Z6nrGwkOt0Yo
         c2cFcX+26n+HXBWIG/1PUK75GMWhPGsK4Eu6eFQw=
Date:   Wed, 09 Mar 2022 17:10:46 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        daniel.thompson@linaro.org, quic_qiancai@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + configs-debug-restore-debug_info=y-for-overriding.patch added to -mm tree
Message-Id: <20220310011046.D10DFC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: configs/debug: restore DEBUG_INFO=y for overriding
has been added to the -mm tree.  Its filename is
     configs-debug-restore-debug_info=y-for-overriding.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/configs-debug-restore-debug_info=y-for-overriding.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/configs-debug-restore-debug_info=y-for-overriding.patch

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

configs-debug-restore-debug_info=y-for-overriding.patch

