Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61205C43217
	for <mm-commits@archiver.kernel.org>; Sat, 26 Nov 2022 00:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKZAS0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiKZASY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Nov 2022 19:18:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE805215B
        for <mm-commits@vger.kernel.org>; Fri, 25 Nov 2022 16:18:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 24C58CE125D
        for <mm-commits@vger.kernel.org>; Sat, 26 Nov 2022 00:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5957BC433C1;
        Sat, 26 Nov 2022 00:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669421896;
        bh=/ScXBlfUskzhQaCqpkSNS7HOVxdrn2itOjeo2J40nmc=;
        h=Date:To:From:Subject:From;
        b=POjksnoSNwf6a+kH9APATxGEooTBMMMfK3u46YlWwkvNJWy/GqkLX6w5zNv6CICUD
         KUv5bwuQuKGFfuNY1PgwkqULcqzAaPFUhX2UVr3xKdfGeagZCnnmbR1QX6z5udoZlZ
         PAsGimy/oVP4eFE7etT4It7A/ujIpIN2yh2zJrb8=
Date:   Fri, 25 Nov 2022 16:18:15 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        tzimmermann@suse.de, trix@redhat.com, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, ndesaulniers@google.com,
        nathan@kernel.org, mripard@kernel.org,
        maarten.lankhorst@linux.intel.com, harry.wentland@amd.com,
        daniel@ffwll.ch, christian.koenig@amd.com, arnd@arndb.de,
        alexander.deucher@amd.com, airlied@gmail.com, lee@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kconfigdebug-provide-a-little-extra-frame_warn-leeway-when-kasan-is-enabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20221126001816.5957BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kconfigdebug-provide-a-little-extra-frame_warn-leeway-when-kasan-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kconfigdebug-provide-a-little-extra-frame_warn-leeway-when-kasan-is-enabled.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lee Jones <lee@kernel.org>
Subject: Kconfig.debug: provide a little extra FRAME_WARN leeway when KASAN is enabled
Date: Fri, 25 Nov 2022 12:07:50 +0000

When enabled, KASAN enlarges function's stack-frames.  Pushing quite a few
over the current threshold.  This can mainly be seen on 32-bit
architectures where the present limit (when !GCC) is a lowly 1024-Bytes.

Link: https://lkml.kernel.org/r/20221125120750.3537134-3-lee@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/Kconfig.debug~kconfigdebug-provide-a-little-extra-frame_warn-leeway-when-kasan-is-enabled
+++ a/lib/Kconfig.debug
@@ -399,6 +399,7 @@ config FRAME_WARN
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
 	default 2048 if PARISC
 	default 1536 if (!64BIT && XTENSA)
+	default 1280 if KASAN && !64BIT
 	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
_

Patches currently in -mm which might be from lee@kernel.org are

drm-amdgpu-temporarily-disable-broken-clang-builds-due-to-blown-stack-frame.patch
kconfigdebug-provide-a-little-extra-frame_warn-leeway-when-kasan-is-enabled.patch

