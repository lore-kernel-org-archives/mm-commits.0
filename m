Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A11C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D3D621D7F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632884;
	bh=1IE0rXmrIv5WEpxIUQFbF+jl/alNJTZrKr0kJ0mM3ao=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=l5afaX830D7kZu4qWu4ydQw0ZmLKJA8aeLAgTJbkhnUCF/FpPBDBbQK5btEj+/WAl
	 RTKjo1luVKcdeDKiHEr1dWcwu5cS1VJvtaIi3W0Ak6qokRzMhnO7zw9XRgu5JwD7hG
	 Z7zGn/KaJTskyvIMaW28uvi774sCFKpbSNRJrjCo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389127AbgJMXsD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXsD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DC3C21D7A;
        Tue, 13 Oct 2020 23:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632882;
        bh=1IE0rXmrIv5WEpxIUQFbF+jl/alNJTZrKr0kJ0mM3ao=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JFA016Z7tWF4TmfyvM8J/O17jgETStu9tYsT9jjGrXOLlS2dTcRoFV0SfAmJCON88
         KDBAQnw7FXtZsminykfsM2OgPZuSdnvfRoE00o+EJAPChDJBIET6YHvJFiIvbJkvOP
         f92uN25V4oNdQ1TpiuOmowUyVHR1Olnxiv7JCawk=
Date:   Tue, 13 Oct 2020 16:48:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        jeyu@kernel.org, keescook@chromium.org, linux-mm@kvack.org,
        lkp@intel.com, maennich@google.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        torvalds@linux-foundation.org, will@kernel.org,
        yamada.masahiro@socionext.com
Subject:  [patch 009/181] export.h: fix section name for
 CONFIG_TRIM_UNUSED_KSYMS for Clang
Message-ID: <20201013234801.zMU594pMt%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: Kees Cook <keescook@chromium.org>
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
