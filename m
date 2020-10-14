Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF0BC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3388922255
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708928;
	bh=a+PdWCMKpTNiB59UUEPRWDQ9x//lZI0PIcpVXFwjkco=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=jZ9Rk1ltfxBwCA3DttwMptiLne3bQ3LWhf8bMNsVTara2bIpHo5g35lKf6Cb0GA5V
	 e//PNBpX8NeNS8y1BjjrY/wx57WDryi5abjxWOp2f09H2A9W4YeXp29hFXOXSAkApE
	 cFA4E2LAKrJcMuHeil6kZ212gTzzoUavF1b4FtQ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgJNUz1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgJNUz1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:27 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D342122250;
        Wed, 14 Oct 2020 20:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708925;
        bh=a+PdWCMKpTNiB59UUEPRWDQ9x//lZI0PIcpVXFwjkco=;
        h=Date:From:To:Subject:From;
        b=nQFchhSOFZdeAluskX5HpAx6OxRTA+ifQtR8NgCoyp7UanKnZ1t4bfT1mmxEy2317
         OKbmvWIbF4PNykxZu5qr7tAoHHGATOoFoers3Le6SkMZw4Ut6eUPqEYisxjoPCOAqG
         1yklvFh0brlIojqlysvZWPhALtvqvSBVh2fUic+0=
Date:   Wed, 14 Oct 2020 13:55:24 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ast@kernel.org, daniel@iogearbox.net,
        elver@google.com, keescook@chromium.org, masahiroy@kernel.org,
        maskray@google.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sedat.dilek@gmail.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [merged]
 revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch
 removed from -mm tree
Message-ID: <20201014205524.970tRZrDY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "kbuild: disable clang's default use of -fmerge-all-constants"
has been removed from the -mm tree.  Its filename was
     revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Revert "kbuild: disable clang's default use of -fmerge-all-constants"

This reverts commit 87e0d4f0f37fb0c8c4aeeac46fff5e957738df79.

-fno-merge-all-constants has been the default since clang-6; the minimum
supported version of clang in the kernel is clang-10 (10.0.1).

Link: https://lkml.kernel.org/r/20200902225911.209899-3-ndesaulniers@google.com
Link: https://reviews.llvm.org/rL329300.
Link: https://github.com/ClangBuiltLinux/linux/issues/9
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    9 ---------
 1 file changed, 9 deletions(-)

--- a/Makefile~revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants
+++ a/Makefile
@@ -921,15 +921,6 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 
-# clang sets -fmerge-all-constants by default as optimization, but this
-# is non-conforming behavior for C and in fact breaks the kernel, so we
-# need to disable it here generally.
-KBUILD_CFLAGS	+= $(call cc-option,-fno-merge-all-constants)
-
-# for gcc -fno-merge-all-constants disables everything, but it is fine
-# to have actual conforming behavior enabled.
-KBUILD_CFLAGS	+= $(call cc-option,-fmerge-constants)
-
 # Make sure -fstack-check isn't enabled (like gentoo apparently did)
 KBUILD_CFLAGS  += $(call cc-option,-fno-stack-check,)
 
_

Patches currently in -mm which might be from ndesaulniers@google.com are


