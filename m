Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A391C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D0F122257
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708939;
	bh=fVKJ3OGI35Fq/payLjG7z6itaaVArRHomW8Wa+rf+Pw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=UsD47jgQa+bYONzO0F0B1jOC1qQf4/B78yQ80KvjLU11mGBXsOIgtWkwX7TNbDQtK
	 1FmVvSYsFeHIY0FeuE3R49UN9yqRs6luvWtGWK/+gB6BmYuHvSNI06YtuXDpHPJ2Jy
	 biHs6mv+dYAZ72L2oYxm/jBs0PqFV5mZCkOITawo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387655AbgJNUzi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNUzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA16222250;
        Wed, 14 Oct 2020 20:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708937;
        bh=fVKJ3OGI35Fq/payLjG7z6itaaVArRHomW8Wa+rf+Pw=;
        h=Date:From:To:Subject:From;
        b=kOi9ko/MDULXNy3ly9n6u0RIn1/FGAy/xemKdF0rJ+vgx1dTrmVLGvdlS+jXErsnI
         Z9F+E+6HqeOzeJWG7wuiD0TX0QI0UuKcIyYV1oWtXmtCOhyUI0af4tuQv1xW0EiDas
         mvc9RTYzuyAhFnx/d8/rb/tb3FmdCwEviW+ENrfM=
Date:   Wed, 14 Oct 2020 13:55:36 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ast@kernel.org, daniel@iogearbox.net,
        elver@google.com, keescook@chromium.org, masahiroy@kernel.org,
        maskray@google.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sedat.dilek@gmail.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [merged]
 kasan-remove-mentions-of-unsupported-clang-versions.patch removed from -mm
 tree
Message-ID: <20201014205536.hEAaH1Pmj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: remove mentions of unsupported Clang versions
has been removed from the -mm tree.  Its filename was
     kasan-remove-mentions-of-unsupported-clang-versions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan: remove mentions of unsupported Clang versions

Since the kernel now requires at least Clang 10.0.1, remove any mention of
old Clang versions and simplify the documentation.

Link: https://lkml.kernel.org/r/20200902225911.209899-7-ndesaulniers@google.com
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    4 ++--
 lib/Kconfig.kasan                 |    9 ++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~kasan-remove-mentions-of-unsupported-clang-versions
+++ a/Documentation/dev-tools/kasan.rst
@@ -13,10 +13,10 @@ KASAN uses compile-time instrumentation
 memory access, and therefore requires a compiler version that supports that.
 
 Generic KASAN is supported in both GCC and Clang. With GCC it requires version
-8.3.0 or later. With Clang it requires version 7.0.0 or later, but detection of
+8.3.0 or later. Any supported Clang version is compatible, but detection of
 out-of-bounds accesses for global variables is only supported since Clang 11.
 
-Tag-based KASAN is only supported in Clang and requires version 7.0.0 or later.
+Tag-based KASAN is only supported in Clang.
 
 Currently generic KASAN is supported for the x86_64, arm64, xtensa, s390 and
 riscv architectures, and tag-based KASAN is supported only for arm64.
--- a/lib/Kconfig.kasan~kasan-remove-mentions-of-unsupported-clang-versions
+++ a/lib/Kconfig.kasan
@@ -54,9 +54,9 @@ config KASAN_GENERIC
 	  Enables generic KASAN mode.
 
 	  This mode is supported in both GCC and Clang. With GCC it requires
-	  version 8.3.0 or later. With Clang it requires version 7.0.0 or
-	  later, but detection of out-of-bounds accesses for global variables
-	  is supported only since Clang 11.
+	  version 8.3.0 or later. Any supported Clang version is compatible,
+	  but detection of out-of-bounds accesses for global variables is
+	  supported only since Clang 11.
 
 	  This mode consumes about 1/8th of available memory at kernel start
 	  and introduces an overhead of ~x1.5 for the rest of the allocations.
@@ -78,8 +78,7 @@ config KASAN_SW_TAGS
 	  Enables software tag-based KASAN mode.
 
 	  This mode requires Top Byte Ignore support by the CPU and therefore
-	  is only supported for arm64. This mode requires Clang version 7.0.0
-	  or later.
+	  is only supported for arm64. This mode requires Clang.
 
 	  This mode consumes about 1/16th of available memory at kernel start
 	  and introduces an overhead of ~20% for the rest of the allocations.
_

Patches currently in -mm which might be from elver@google.com are


