Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6471C4727C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E62320848
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601409758;
	bh=3aTi1rFE1mR7AD+GsJUzn3hFhCfZls2Wf6yMSOlnqXQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=D+vSgfZwJVdRgRakaD1w1yiETfYaMtV2afCLFA6oGBChMfIIup7fhyzUz2bUYcdB8
	 c7/hTCkLsoGZyBmRCzeOPubVCqy/rzhfO33lQYJlbrIOrQ+Tui0ilLaiAxu0Vy0uOC
	 SwfLDxXtvhOHHVHk3P4cTTimqMFoozuf1TastlqA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgI2UCi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbgI2UCh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Sep 2020 16:02:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21EAF20679;
        Tue, 29 Sep 2020 20:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601409755;
        bh=3aTi1rFE1mR7AD+GsJUzn3hFhCfZls2Wf6yMSOlnqXQ=;
        h=Date:From:To:Subject:From;
        b=gfc8Yb9hjZnUTbfT7KSFoj/LPuZ+7FDIxjvAmFL++sxDcMe2Z9cehZVJ1oMqH9NWR
         EvnNpJsS9OYzNmhhRkEYonHOYzGJN0J06wqxWdNeBq0Sya+U1uJCWogVhoMz3fPD71
         o/WmQb9ccZ/qukwV8aN9AB9H5Row7y1asij/4JZ4=
Date:   Tue, 29 Sep 2020 13:02:34 -0700
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, jeyu@kernel.org, keescook@chromium.org,
        lkp@intel.com, maennich@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com, will@kernel.org,
        yamada.masahiro@socionext.com
Subject:  +
 exporth-fix-section-name-for-config_trim_unused_ksyms-for-clang.patch added
 to -mm tree
Message-ID: <20200929200234.h_AUrSmiN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: export.h: fix section name for CONFIG_TRIM_UNUSED_KSYMS for Clang
has been added to the -mm tree.  Its filename is
     exporth-fix-section-name-for-config_trim_unused_ksyms-for-clang.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/exporth-fix-section-name-for-config_trim_unused_ksyms-for-clang.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/exporth-fix-section-name-for-config_trim_unused_ksyms-for-clang.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: export.h: fix section name for CONFIG_TRIM_UNUSED_KSYMS for Clang

When enabling CONFIG_TRIM_UNUSED_KSYMS, the linker will warn about the
orphan sections:

(".discard.ksym") is being placed in '".discard.ksym"'

repeatedly when linking vmlinux.  This is because the stringification
operator, `#`, in the preprocessor escapes strings.  GCC and Clang differ
in how they treat section names that contain \".

The portable solution is to not use a string literal with the preprocessor
stringification operator.

Link: https://bugs.llvm.org/show_bug.cgi?id=42950
Link: https://github.com/ClangBuiltLinux/linux/issues/1166
Link: https://lkml.kernel.org/r/20200929190701.398762-1-ndesaulniers@google.com
Fixes: commit bbda5ec671d3 ("kbuild: simplify dependency generation for CONFIG_TRIM_UNUSED_KSYMS")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthias Maennich <maennich@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/export.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/export.h~exporth-fix-section-name-for-config_trim_unused_ksyms-for-clang
+++ a/include/linux/export.h
@@ -130,7 +130,7 @@ struct kernel_symbol {
  * discarded in the final link stage.
  */
 #define __ksym_marker(sym)	\
-	static int __ksym_marker_##sym[0] __section(".discard.ksym") __used
+	static int __ksym_marker_##sym[0] __section(.discard.ksym) __used
 
 #define __EXPORT_SYMBOL(sym, sec, ns)					\
 	__ksym_marker(sym);						\
_

Patches currently in -mm which might be from ndesaulniers@google.com are

compiler-clang-add-build-check-for-clang-1001.patch
revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch
revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support.patch
revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch
partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer.patch
compiler-gcc-improve-version-error.patch
compilerh-avoid-escaped-section-names.patch
exporth-fix-section-name-for-config_trim_unused_ksyms-for-clang.patch

