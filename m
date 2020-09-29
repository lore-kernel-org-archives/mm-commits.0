Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AA9C4727C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9D3820774
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601409655;
	bh=wGqh/di4AF88SIk1QQgcRPV8rx1xyZOAO2Cj3rbJtTU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=A2FAoQ+cXZXND4VrLnC4dqNfM3D/RUPYmoEE+csON7QasAARDKhBYXO/PxWwC9UJ1
	 Q+SmwVv6lkmNJWv2FZvM5e8gK3DqSeVdcZ1VZtMQCwh+QWKO7YqwUYMiEQMyoLaedz
	 S1nJgfAmbVr+k2rxKiFXg7Yfu44rFPlDLLyjL/o0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbgI2UAz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbgI2UAz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Sep 2020 16:00:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BB6420679;
        Tue, 29 Sep 2020 20:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601409654;
        bh=wGqh/di4AF88SIk1QQgcRPV8rx1xyZOAO2Cj3rbJtTU=;
        h=Date:From:To:Subject:From;
        b=T6TPmPLs24U68sSXGH+uUJ2l6NT6/mDobgLA2nP6AD16isB0Qnzv1l1UZPF2zQcM4
         tEc/FpHVBG6v4202CY2HTYCM/t2pcj/ZUTIHwUrG0c50OGrUYNdM2xDCmhg4fzQ8pE
         6k6PycW8ROtMJUcsHdtgTms23nGUwWqRaONnf1ds=
Date:   Tue, 29 Sep 2020 13:00:53 -0700
From:   akpm@linux-foundation.org
To:     luc.vanoostenryck@gmail.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com
Subject:  + compilerh-avoid-escaped-section-names.patch added to
 -mm tree
Message-ID: <20200929200053.MvI5Y1sRm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler.h: avoid escaped section names
has been added to the -mm tree.  Its filename is
     compilerh-avoid-escaped-section-names.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compilerh-avoid-escaped-section-names.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compilerh-avoid-escaped-section-names.patch

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
Subject: compiler.h: avoid escaped section names

The stringification operator, `#`, in the preprocessor escapes strings. 
For example, `# "foo"` becomes `"\"foo\""`.  GCC and Clang differ in how
they treat section names that contain \".

The portable solution is to not use a string literal with the preprocessor
stringification operator.

In this case, since __section unconditionally uses the stringification
operator, we actually want the more verbose
__attribute__((__section__())).

Link: https://bugs.llvm.org/show_bug.cgi?id=42950
Link: https://lkml.kernel.org/r/20200929194318.548707-1-ndesaulniers@google.com
Fixes: commit e04462fb82f8 ("Compiler Attributes: remove uses of __attribute__ from compiler.h")
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler.h~compilerh-avoid-escaped-section-names
+++ a/include/linux/compiler.h
@@ -155,7 +155,7 @@ void ftrace_likely_update(struct ftrace_
 	extern typeof(sym) sym;					\
 	static const unsigned long __kentry_##sym		\
 	__used							\
-	__section("___kentry" "+" #sym )			\
+	__attribute__((__section__("___kentry+" #sym)))		\
 	= (unsigned long)&sym;
 #endif
 
_

Patches currently in -mm which might be from ndesaulniers@google.com are

compiler-clang-add-build-check-for-clang-1001.patch
revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch
revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support.patch
revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch
partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer.patch
compiler-gcc-improve-version-error.patch
compilerh-avoid-escaped-section-names.patch

