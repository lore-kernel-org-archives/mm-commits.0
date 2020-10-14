Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0C8C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D22B822257
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708932;
	bh=MWXjreOboxOoni9SeknIWqHtETbIucRgR56lB+P/DYg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bTtdXt2LiBAVbRGAmZXLoXjJyopmKRIbjMsHkpN/Qgqt8K8NALB5mp9l/8jdSuRUR
	 qA7YbGbdg3GDC1fuV4yUUjUXVzsokooHov42Ygx3iYZNhJ+ssIOxzEXULgln0EAxD1
	 zb/iSz7dbW0sTnZJ5rhiPSn2Z05Htri5pwgKmzeQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgJNUzc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgJNUzc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1874722254;
        Wed, 14 Oct 2020 20:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708931;
        bh=MWXjreOboxOoni9SeknIWqHtETbIucRgR56lB+P/DYg=;
        h=Date:From:To:Subject:From;
        b=Vh769KiJ2bapI0rF21b+dhe49Y2uT19ueEIAB50LzTEKKVXvhXW1Dsdb5XMAV1GaP
         /wV0G19gg8F9hfO572umP8x/eP5+MlzUvDBs5RokjYisJxMXnzWYPODZKeqHKcnYXW
         Ae0BZVtH570wTGOkNwLiVJ6Ar34jFdbI3titYKuk=
Date:   Wed, 14 Oct 2020 13:55:30 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ast@kernel.org, daniel@iogearbox.net,
        elver@google.com, keescook@chromium.org, masahiroy@kernel.org,
        maskray@google.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sedat.dilek@gmail.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [merged]
 revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch removed
 from -mm tree
Message-ID: <20201014205530.C40Ur-_Lr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "arm64: vdso: Fix compilation with clang older than 8"
has been removed from the -mm tree.  Its filename was
     revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Revert "arm64: vdso: Fix compilation with clang older than 8"

This reverts commit 3acf4be235280f14d838581a750532219d67facc.

The minimum supported version of clang is clang 10.0.1.

Link: https://lkml.kernel.org/r/20200902225911.209899-5-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/vdso/Makefile |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/arm64/kernel/vdso/Makefile~revert-arm64-vdso-fix-compilation-with-clang-older-than-8
+++ a/arch/arm64/kernel/vdso/Makefile
@@ -43,13 +43,6 @@ ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -include $(c-gettimeofday-y)
 endif
 
-# Clang versions less than 8 do not support -mcmodel=tiny
-ifeq ($(CONFIG_CC_IS_CLANG), y)
-  ifeq ($(shell test $(CONFIG_CLANG_VERSION) -lt 80000; echo $$?),0)
-    CFLAGS_REMOVE_vgettimeofday.o += -mcmodel=tiny
-  endif
-endif
-
 # Disable gcov profiling for VDSO code
 GCOV_PROFILE := n
 
_

Patches currently in -mm which might be from ndesaulniers@google.com are


