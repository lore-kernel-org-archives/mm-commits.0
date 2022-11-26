Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A744C43217
	for <mm-commits@archiver.kernel.org>; Sat, 26 Nov 2022 00:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiKZASR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiKZASQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Nov 2022 19:18:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C31651C38
        for <mm-commits@vger.kernel.org>; Fri, 25 Nov 2022 16:18:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9A136101A
        for <mm-commits@vger.kernel.org>; Sat, 26 Nov 2022 00:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385E3C433C1;
        Sat, 26 Nov 2022 00:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669421894;
        bh=0Oup3NOaYHTcxrnbOgwRk050e/CtZ1q/Z4bHAFQckg8=;
        h=Date:To:From:Subject:From;
        b=tPQ0k5eNSGmj664fjEC9NaOI3JKBli87m1sGjk6F4wgwdhwiel2io1zvplJhMA5Q5
         KQ06ecgY7xqp/vNmmhS65bEYlrxPZrIzUwj0xvsaCpGcmAHFMyHZtR5F5WCiREAzPF
         Y4W6SjpAdE1kEA6UGqxuqD7qPADLTmY+397V7bpw=
Date:   Fri, 25 Nov 2022 16:18:13 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com,
        tzimmermann@suse.de, trix@redhat.com, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, ndesaulniers@google.com,
        nathan@kernel.org, mripard@kernel.org,
        maarten.lankhorst@linux.intel.com, harry.wentland@amd.com,
        daniel@ffwll.ch, christian.koenig@amd.com, arnd@arndb.de,
        alexander.deucher@amd.com, airlied@gmail.com, lee@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-amdgpu-temporarily-disable-broken-clang-builds-due-to-blown-stack-frame.patch added to mm-hotfixes-unstable branch
Message-Id: <20221126001814.385E3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drm/amdgpu: temporarily disable broken Clang builds due to blown stack-frame
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     drm-amdgpu-temporarily-disable-broken-clang-builds-due-to-blown-stack-frame.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-amdgpu-temporarily-disable-broken-clang-builds-due-to-blown-stack-frame.patch

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
Subject: drm/amdgpu: temporarily disable broken Clang builds due to blown stack-frame
Date: Fri, 25 Nov 2022 12:07:49 +0000

Patch series "Fix a bunch of allmodconfig errors", v2.

Since b339ec9c229aa ("kbuild: Only default to -Werror if COMPILE_TEST")
WERROR now defaults to COMPILE_TEST meaning that it's enabled for
allmodconfig builds.  This leads to some interesting build failures when
using Clang, each resolved in this set.

With this set applied, I am able to obtain a successful allmodconfig Arm
build.


This patch (of 2):

calculate_bandwidth() is presently broken on all !(X86_64 || SPARC64 ||
ARM64) architectures built with Clang (all released versions), whereby the
stack frame gets blown up to well over 5k.  This would cause an immediate
kernel panic on most architectures.  We'll revert this when the following
bug report has been resolved:
https://github.com/llvm/llvm-project/issues/41896.

Link: https://lkml.kernel.org/r/20221125120750.3537134-1-lee@kernel.org
Link: https://lkml.kernel.org/r/20221125120750.3537134-2-lee@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Lee Jones <lee@kernel.org>
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

 drivers/gpu/drm/amd/display/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/display/Kconfig~drm-amdgpu-temporarily-disable-broken-clang-builds-due-to-blown-stack-frame
+++ a/drivers/gpu/drm/amd/display/Kconfig
@@ -5,6 +5,7 @@ menu "Display Engine Configuration"
 config DRM_AMD_DC
 	bool "AMD DC - Enable new display engine"
 	default y
+	depends on BROKEN || !CC_IS_CLANG || X86_64 || SPARC64 || ARM64
 	select SND_HDA_COMPONENT if SND_HDA_CORE
 	select DRM_AMD_DC_DCN if (X86 || PPC_LONG_DOUBLE_128)
 	help
@@ -12,6 +13,12 @@ config DRM_AMD_DC
 	  support for AMDGPU. This adds required support for Vega and
 	  Raven ASICs.
 
+	  calculate_bandwidth() is presently broken on all !(X86_64 || SPARC64 || ARM64)
+	  architectures built with Clang (all released versions), whereby the stack
+	  frame gets blown up to well over 5k.  This would cause an immediate kernel
+	  panic on most architectures.  We'll revert this when the following bug report
+	  has been resolved: https://github.com/llvm/llvm-project/issues/41896.
+
 config DRM_AMD_DC_DCN
 	def_bool n
 	help
_

Patches currently in -mm which might be from lee@kernel.org are

drm-amdgpu-temporarily-disable-broken-clang-builds-due-to-blown-stack-frame.patch
kconfigdebug-provide-a-little-extra-frame_warn-leeway-when-kasan-is-enabled.patch

