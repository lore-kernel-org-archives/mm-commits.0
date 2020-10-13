Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BDFC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01BD21D7F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632863;
	bh=2AL3fCHOgwWkmQNuYfao6/jVxeYZ2nQpNp1rmCQgWqE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=c33gDn4/8SBmmvtZI8ROqYjyHoixpt+rbz15TTbR71UOrbrO4SkPMXgqJJNn7mK9j
	 5O83XrNRbNy96jwpfvbGakA6BBA409MB05FWwea/HuI6BJhf0HygREHK5tnluORE4Q
	 8lKfKiJjLef1fA6zuLVWFMDGgTtA1MMGHPAGJjrk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389108AbgJMXrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXrm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:47:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 127FD21D7A;
        Tue, 13 Oct 2020 23:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632862;
        bh=2AL3fCHOgwWkmQNuYfao6/jVxeYZ2nQpNp1rmCQgWqE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ecquh0YwAEvsDTvTo1BJ98HBzy95r0iO+cR9flpmeAgwgzzYQYgRG8ZgAA8vGOa3H
         O6sYeC7B0a5gp7iF/X4DXKtAVA7A/maZJT/pG/IHuOnX5SaNlo6OyDI2qpw/8o+kWW
         glD4SnZ9CqtWBd7HPm1cdCCa7RJRM04F5vc+WdeE=
Date:   Tue, 13 Oct 2020 16:47:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, ast@kernel.org,
        daniel@iogearbox.net, elver@google.com, keescook@chromium.org,
        linux-mm@kvack.org, masahiroy@kernel.org, maskray@google.com,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        sedat.dilek@gmail.com, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [patch 003/181] Revert "arm64: bti: Require clang >=
 10.0.1 for in-kernel BTI support"
Message-ID: <20201013234740.kAjddy0WG%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Revert "arm64: bti: Require clang >= 10.0.1 for in-kernel BTI support"

This reverts commit b9249cba25a5dce5de87e5404503a5e11832c2dd.

The minimum supported version of clang is now 10.0.1.

Link: https://lkml.kernel.org/r/20200902225911.209899-4-ndesaulniers@google.com
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

 arch/arm64/Kconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/Kconfig~revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support
+++ a/arch/arm64/Kconfig
@@ -1612,8 +1612,6 @@ config ARM64_BTI_KERNEL
 	depends on CC_HAS_BRANCH_PROT_PAC_RET_BTI
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94697
 	depends on !CC_IS_GCC || GCC_VERSION >= 100100
-	# https://reviews.llvm.org/rGb8ae3fdfa579dbf366b1bb1cbfdbf8c51db7fa55
-	depends on !CC_IS_CLANG || CLANG_VERSION >= 100001
 	depends on !(CC_IS_CLANG && GCOV_KERNEL)
 	depends on (!FUNCTION_GRAPH_TRACER || DYNAMIC_FTRACE_WITH_REGS)
 	help
_
