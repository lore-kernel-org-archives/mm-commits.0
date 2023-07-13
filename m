Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6CEC001B0
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 19:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjGMTDe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 15:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjGMTDe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 15:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1318E171D
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 12:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98AF161B36
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 19:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FA4C433C7;
        Thu, 13 Jul 2023 19:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689275012;
        bh=zTdI4YEYxkdNSMPXjInwx731G/bkyR+WnyCryqMk2VQ=;
        h=Date:To:From:Subject:From;
        b=XbH4eOc1+x8ANEFJO115BAn79RqfvI+toisRLeH8toovCo2p7IQLRjC3fTpEPp7S3
         Le5xrsLYuXCDRxwMWc/JSNAXL8+6xyMQmS891c2tSDnhfitJwAbLSx8bIKA9NbtbOD
         y+PpO0RHt7pTl72qEytKqdM4ZoBiTTxIRPZwclHg=
Date:   Thu, 13 Jul 2023 12:03:30 -0700
To:     mm-commits@vger.kernel.org, nicolas@fjasle.eu,
        ndesaulniers@google.com, nathan@kernel.org, masahiroy@kernel.org,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-flatten-kbuild_cflags.patch added to mm-nonmm-unstable branch
Message-Id: <20230713190331.D8FA4C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: flatten KBUILD_CFLAGS
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-flatten-kbuild_cflags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-flatten-kbuild_cflags.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: kbuild: flatten KBUILD_CFLAGS
Date: Thu, 13 Jul 2023 21:52:28 +0300

Make it slightly easier to see which compiler options are added and
removed (and not worry about column limit too!).

Link: https://lkml.kernel.org/r/4f414a87-0c54-44bd-b218-f6f0b22c57ef@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/Makefile~kbuild-flatten-kbuild_cflags
+++ a/Makefile
@@ -555,11 +555,23 @@ LINUXINCLUDE    := \
 		$(USERINCLUDE)
 
 KBUILD_AFLAGS   := -D__ASSEMBLY__ -fno-PIE
-KBUILD_CFLAGS   := -Wall -Wundef -Werror=strict-prototypes -Wno-trigraphs \
-		   -fno-strict-aliasing -fno-common -fshort-wchar -fno-PIE \
-		   -Werror=implicit-function-declaration -Werror=implicit-int \
-		   -Werror=return-type -Wno-format-security -funsigned-char \
-		   -std=gnu11
+
+KBUILD_CFLAGS :=
+KBUILD_CFLAGS += -std=gnu11
+KBUILD_CFLAGS += -fshort-wchar
+KBUILD_CFLAGS += -funsigned-char
+KBUILD_CFLAGS += -fno-common
+KBUILD_CFLAGS += -fno-PIE
+KBUILD_CFLAGS += -fno-strict-aliasing
+KBUILD_CFLAGS += -Wall
+KBUILD_CFLAGS += -Wundef
+KBUILD_CFLAGS += -Werror=implicit-function-declaration
+KBUILD_CFLAGS += -Werror=implicit-int
+KBUILD_CFLAGS += -Werror=return-type
+KBUILD_CFLAGS += -Werror=strict-prototypes
+KBUILD_CFLAGS += -Wno-format-security
+KBUILD_CFLAGS += -Wno-trigraphs
+
 KBUILD_CPPFLAGS := -D__KERNEL__
 KBUILD_RUSTFLAGS := $(rust_common_flags) \
 		    --target=$(objtree)/scripts/target.json \
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-support-proc-empty-vm-test-on-i386.patch
proc-skip-proc-empty-vm-on-anything-but-amd64-and-i386.patch
kbuild-flatten-kbuild_cflags.patch

