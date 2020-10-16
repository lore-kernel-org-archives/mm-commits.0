Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CCCC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 615E22083B
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602818021;
	bh=j6U0MSB6fLVvjrkue0RddTVt9C7FtzQIz03zuc8Yhdg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qyMinWLhiZr7WdYuWy8g/0XH6N5LMFRIEMPakJ2hqKYeLQGkSjaxVAi/F/bf+NmQX
	 OBuxQ5Lj9YlS4psZthoN0yn/59U7XJIFsNtgpNyxPUKNSmWzzx/wEHeKONfq4ArXmL
	 sUld57M/K/Pc2Y0M79JqiXAi0r0v68zwtijE3Fyk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393963AbgJPDNl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393799AbgJPDNk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:13:40 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7117120789;
        Fri, 16 Oct 2020 03:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602818020;
        bh=j6U0MSB6fLVvjrkue0RddTVt9C7FtzQIz03zuc8Yhdg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I5uvfCTN0zNQ20sW1yzAa7Zj5OT7GAqDzyjHIGVMKPpkH0G4hAZoDbndltsTF+jFV
         hKmW3Cq+Vnu5Fr1NHdQvqLoXOwqo7DV4ajCUJ+SL5qYKYb9S6pvHIuoiXTY6c7ytp1
         kimjj3hkVCkOUWJOeM4jOnKU9CWwU2GH3C9cBO4s=
Date:   Thu, 15 Oct 2020 20:13:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     a.p.zijlstra@chello.nl, akpm@linux-foundation.org, arnd@arndb.de,
        dbrazdil@google.com, dvyukov@google.com, elver@google.com,
        georgepope@android.com, keescook@chromium.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 153/156] ubsan: introduce
 CONFIG_UBSAN_LOCAL_BOUNDS for Clang
Message-ID: <20201016031338.V8nE_aM_W%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: George Popescu <georgepope@android.com>
Subject: ubsan: introduce CONFIG_UBSAN_LOCAL_BOUNDS for Clang

When the kernel is compiled with Clang, -fsanitize=bounds expands to
-fsanitize=array-bounds and -fsanitize=local-bounds.

Enabling -fsanitize=local-bounds with Clang has the unfortunate
side-effect of inserting traps; this goes back to its original intent,
which was as a hardening and not a debugging feature [1].  The same
feature made its way into -fsanitize=bounds, but the traps remained.  For
that reason, -fsanitize=bounds was split into 'array-bounds' and
'local-bounds' [2].

Since 'local-bounds' doesn't behave like a normal sanitizer, enable it
with Clang only if trapping behaviour was requested by
CONFIG_UBSAN_TRAP=y.

Add the UBSAN_BOUNDS_LOCAL config to Kconfig.ubsan to enable the
'local-bounds' option by default when UBSAN_TRAP is enabled.

[1] http://lists.llvm.org/pipermail/llvm-dev/2012-May/049972.html
[2] http://lists.llvm.org/pipermail/cfe-commits/Week-of-Mon-20131021/091536.html

Link: https://lkml.kernel.org/r/20200922074330.2549523-1-georgepope@google.com
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: David Brazdil <dbrazdil@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: George Popescu <georgepope@android.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |   14 ++++++++++++++
 scripts/Makefile.ubsan |   10 +++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.ubsan~ubsan-introducing-config_ubsan_local_bounds-for-clang
+++ a/lib/Kconfig.ubsan
@@ -47,6 +47,20 @@ config UBSAN_BOUNDS
 	  to the {str,mem}*cpy() family of functions (that is addressed
 	  by CONFIG_FORTIFY_SOURCE).
 
+config UBSAN_LOCAL_BOUNDS
+	bool "Perform array local bounds checking"
+	depends on UBSAN_TRAP
+	depends on CC_IS_CLANG
+	depends on !UBSAN_KCOV_BROKEN
+	help
+	  This option enables -fsanitize=local-bounds which traps when an
+	  exception/error is detected. Therefore, it should be enabled only
+	  if trapping is expected.
+	  Enabling this option detects errors due to accesses through a
+	  pointer that is derived from an object of a statically-known size,
+	  where an added offset (which may not be known statically) is
+	  out-of-bounds.
+
 config UBSAN_MISC
 	bool "Enable all other Undefined Behavior sanity checks"
 	default UBSAN
--- a/scripts/Makefile.ubsan~ubsan-introducing-config_ubsan_local_bounds-for-clang
+++ a/scripts/Makefile.ubsan
@@ -4,7 +4,15 @@ ifdef CONFIG_UBSAN_ALIGNMENT
 endif
 
 ifdef CONFIG_UBSAN_BOUNDS
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
+      ifdef CONFIG_CC_IS_CLANG
+            CFLAGS_UBSAN += -fsanitize=array-bounds
+      else
+            CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
+      endif
+endif
+
+ifdef CONFIG_UBSAN_LOCAL_BOUNDS
+      CFLAGS_UBSAN += -fsanitize=local-bounds
 endif
 
 ifdef CONFIG_UBSAN_MISC
_
