Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96EDBC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C17422253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708924;
	bh=iYpI71a0l9JhqL+9GtO80/5iMuW5oy0Sv4bpGY5eSXE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HKhrDJbwfRYygRrSzaSZtHwm9K4llu0KgvFksWLb1CPNLG2I5BozqWBtK4kzjM6wU
	 Y0HjFFVXg2tU0+NCzFPpYq38Fbzm5u5ZUNxOLotnqVhpf2IbCI1Rk+KbM64elIFe7z
	 pV5mWJ5R/GguVOoYk0xQc0i9/a9qcSbnEaflNgUI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgJNUzX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgJNUzX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:23 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E53892224E;
        Wed, 14 Oct 2020 20:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708921;
        bh=iYpI71a0l9JhqL+9GtO80/5iMuW5oy0Sv4bpGY5eSXE=;
        h=Date:From:To:Subject:From;
        b=VQzOkP+K3pHmkkkvK1Re8hgsh9zXlvNWk+3d8bAuine3/K1nei7kVfnu3IqtJbZAn
         2T9yzunGMKhgrUqUOlqjdd9mb/BVkWkogEszH/jtjkrYXnPTLM0ZuT34nnMAa6MXyS
         kTUdEobWIiHQhGD5KTw5eKQAXr5AeM9jd3JiZVIc=
Date:   Wed, 14 Oct 2020 13:55:20 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, ast@kernel.org, daniel@iogearbox.net,
        elver@google.com, keescook@chromium.org, masahiroy@kernel.org,
        maskray@google.com, miguel.ojeda.sandonis@gmail.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, sedat.dilek@gmail.com,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [merged]
 compiler-clang-add-build-check-for-clang-1001.patch removed from -mm tree
Message-ID: <20201014205520.vPH5Hsb0L%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-clang: add build check for clang 10.0.1
has been removed from the -mm tree.  Its filename was
     compiler-clang-add-build-check-for-clang-1001.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: compiler-clang: add build check for clang 10.0.1

Patch series "set clang minimum version to 10.0.1", v3.

Adds a compile time #error to compiler-clang.h setting the effective
minimum supported version to clang 10.0.1.  A separate patch has already
been picked up into the Documentation/ tree also confirming the version.

Next are a series of reverts. One for 32b arm is a partial revert.

Then Marco suggested fixes to KASAN docs.

Finally, improve the warning for GCC too as per Kees.


This patch (of 7):

During Plumbers 2020, we voted to just support the latest release of Clang
for now.  Add a compile time check for this.

We plan to remove workarounds for older versions now, which will break in
subtle and not so subtle ways.

Link: https://lkml.kernel.org/r/20200902225911.209899-1-ndesaulniers@google.com
Link: https://lkml.kernel.org/r/20200902225911.209899-2-ndesaulniers@google.com
Link: https://github.com/ClangBuiltLinux/linux/issues/9
Link: https://github.com/ClangBuiltLinux/linux/issues/941
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/compiler-clang.h~compiler-clang-add-build-check-for-clang-1001
+++ a/include/linux/compiler-clang.h
@@ -3,6 +3,14 @@
 #error "Please don't include <linux/compiler-clang.h> directly, include <linux/compiler.h> instead."
 #endif
 
+#define CLANG_VERSION (__clang_major__ * 10000	\
+		     + __clang_minor__ * 100	\
+		     + __clang_patchlevel__)
+
+#if CLANG_VERSION < 100001
+# error Sorry, your version of Clang is too old - please use 10.0.1 or newer.
+#endif
+
 /* Compiler specific definitions for Clang compiler */
 
 /* same as gcc, this was present in clang-2.6 so we can assume it works
_

Patches currently in -mm which might be from ndesaulniers@google.com are


