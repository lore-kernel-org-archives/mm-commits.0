Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CB4C38A2D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 00:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiJYAFm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 20:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiJYAFP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 20:05:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FACC5FAF0
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 15:22:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31A63B816B7
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 22:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22D6C433C1;
        Mon, 24 Oct 2022 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666650123;
        bh=H40Jblj9heuMNhTxazGE7miwPdRUs8qBpVMC6iNhxFw=;
        h=Date:To:From:Subject:From;
        b=M5T9P5Dk2uJJFnM0Dzcz1crsqt0606YZXLAoTFCnon7qmwlqvo99sQ7VreB9ufcy8
         s0zaqz3WUK54XApR6FcvuC6zsCxLJB8a28sulESY9GrVJNm5R5piJ4LaVGvw0lxwQE
         yBWMLXNe30gFm/SqUWtHS8xPUd4996oksHzbEaxs=
Date:   Mon, 24 Oct 2022 15:22:03 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        masahiroy@kernel.org, keescook@chromium.org, glider@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kconfigdebug-disable-config_frame_warn-for-kmsan-by-default.patch added to mm-hotfixes-unstable branch
Message-Id: <20221024222203.D22D6C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: disable CONFIG_FRAME_WARN for KMSAN by default
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kconfigdebug-disable-config_frame_warn-for-kmsan-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kconfigdebug-disable-config_frame_warn-for-kmsan-by-default.patch

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
From: Alexander Potapenko <glider@google.com>
Subject: Kconfig.debug: disable CONFIG_FRAME_WARN for KMSAN by default
Date: Mon, 24 Oct 2022 23:21:42 +0200

KMSAN adds a lot of instrumentation to the code, which results in
increased stack usage (up to 2048 bytes and more in some cases).  It's
hard to predict how big the stack frames can be, so we disable the
warnings for KMSAN instead.

Link: https://lkml.kernel.org/r/20221024212144.2852069-3-glider@google.com
Link: https://github.com/google/kmsan/issues/89
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~kconfigdebug-disable-config_frame_warn-for-kmsan-by-default
+++ a/lib/Kconfig.debug
@@ -400,8 +400,9 @@ config FRAME_WARN
 	default 1536 if (!64BIT && XTENSA)
 	default 1024 if !64BIT
 	default 2048 if 64BIT
+	default 0 if KMSAN
 	help
-	  Tell gcc to warn at build time for stack frames larger than this.
+	  Tell the compiler to warn at build time for stack frames larger than this.
 	  Setting this too low will cause a lot of warnings.
 	  Setting it to 0 disables the warning.
 
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-export-kmsan_copy_page_meta.patch
x86-purgatory-disable-kmsan-instrumentation.patch
kconfigdebug-disable-config_frame_warn-for-kmsan-by-default.patch
x86-asm-make-sure-__put_user_size-evaluates-pointer-once.patch
x86-fortify-kmsan-fix-kmsan-fortify-builds.patch

