Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4653DC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1563421D7F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632875;
	bh=17gTM3q2sumStLGXtQqsRWHvZJ0nie+65KOyyU3pdiU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=J7EZboe5sv8+yDl/LpSIh/mDHQTwq9u6yQHgdS9WoFLQhgUo5b/A9yBRkgM8l+TEE
	 XXtovkZVYJ+uXB1zWmDl9s/dNRyOR/wQ6dUo9VoZqcj23Oz3U1pbVagBzQzdg6wZHn
	 6D/IyK5Ob+MCZGhlyBUQgAzYwxVL4AhZyBjZRUWE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389121AbgJMXry (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXrx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:47:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1825321D81;
        Tue, 13 Oct 2020 23:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632872;
        bh=17gTM3q2sumStLGXtQqsRWHvZJ0nie+65KOyyU3pdiU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=L6zaA4/id/8hkjOipSSQ4/4pfVoqRoqFKxQRf3cWJtaLTaFkNEE7Fy76gx8X+ve7v
         jfQRFpPYddbr9lYE/o7AF9aYPmPWB97uB7Uyc2ekVQ2sjqu9JV4oYZhBwLIRGXVgoI
         RYDlKJ9XGD3XXrq6JirrnpT6WQJEesOy0m9QV+9A=
Date:   Tue, 13 Oct 2020 16:47:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, ast@kernel.org,
        daniel@iogearbox.net, elver@google.com, keescook@chromium.org,
        linux-mm@kvack.org, masahiroy@kernel.org, maskray@google.com,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        sedat.dilek@gmail.com, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [patch 006/181] kasan: remove mentions of unsupported
 Clang versions
Message-ID: <20201013234751.9pYJWzf66%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
