Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113FFC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 16:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjGXQlH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjGXQk4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 12:40:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629E910F4
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 09:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D71AD61275
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 16:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37119C433C8;
        Mon, 24 Jul 2023 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690216854;
        bh=S0r8t18wJNY7WB8uLFqafw0JdcYiTkJLTpsFurDKvjw=;
        h=Date:To:From:Subject:From;
        b=E0pOOotYrtRZhScdMvmil42jgXuTemJsM34ZQcQqeLW8BKzQSTnHXYJZarxp2tV33
         tPmcP6pM7g+28sxDfVnVJqW93O4lGH6pXxnLfmsVFU9d0QzGvG924RHPO19e8hZkGI
         /UtS/pNOtyw66im55ixEWbo8zleuaLmC9cLwjA1g=
Date:   Mon, 24 Jul 2023 09:40:53 -0700
To:     mm-commits@vger.kernel.org, nicolas@fjasle.eu,
        ndesaulniers@google.com, nathan@kernel.org, masahiroy@kernel.org,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kbuild-flatten-kbuild_cflags.patch removed from -mm tree
Message-Id: <20230724164054.37119C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kbuild: flatten KBUILD_CFLAGS
has been removed from the -mm tree.  Its filename was
     kbuild-flatten-kbuild_cflags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

