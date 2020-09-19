Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12D8C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A26F21D7B
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600474625;
	bh=DMMbeF0LS3iXRRevnSDYWt1lPzoPF3pjgpSOVKclhwY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ccNE6iS9GfYY9T9Hs6crGFQ4XA6CFFZXGpD6v1nmDNvkzoDmxIt6faLXmfqVW1NhS
	 EPN1A7qp91Rd0ad9TyAa8HnL1MsW+c+tK2RE0EdMclKM4VKq8APr1YDXU7jR36xK6R
	 5Du6TzaqoOKggKLztvVIc9RAub35woz5XDj9PQFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgISARF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgISARE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:17:04 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A2FE21D43;
        Sat, 19 Sep 2020 00:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600474623;
        bh=DMMbeF0LS3iXRRevnSDYWt1lPzoPF3pjgpSOVKclhwY=;
        h=Date:From:To:Subject:From;
        b=yI5T4RPcPw+5xQCHW1SjtsXEh+Y8ZipRNXQtc0iA6b6EsuvJR92Mg8Xjeh5heSxxU
         uDu3L2jq4KPz7eeXv6f/YdipNnnl2Z6hmDrXkMEZzsUbPuaOi11A/GVxTx7n7loZx5
         ndbmuyUJyZqZzMezOIbXpv0dfgEAVXNUgQkdgs5s=
Date:   Fri, 18 Sep 2020 17:17:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        natechancellor@gmail.com, michal.lkml@markovi.net,
        masahiroy@kernel.org, keescook@chromium.org,
        georgepope@android.com, elver@google.com, dvyukov@google.com,
        dbrazdil@google.com, arnd@arndb.de, a.p.zijlstra@chello.nl,
        georgepope@google.com
Subject:  +
 ubsan-introducing-config_ubsan_bounds_local-for-clang.patch added to -mm tree
Message-ID: <20200919001702.A74EL%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: introduce CONFIG_UBSAN_BOUNDS_LOCAL for Clang
has been added to the -mm tree.  Its filename is
     ubsan-introducing-config_ubsan_bounds_local-for-clang.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ubsan-introducing-config_ubsan_bounds_local-for-clang.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ubsan-introducing-config_ubsan_bounds_local-for-clang.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: George Popescu <georgepope@google.com>
Subject: ubsan: introduce CONFIG_UBSAN_BOUNDS_LOCAL for Clang

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

Link: https://lkml.kernel.org/r/20200918133632.4038538-1-georgepope@google.com
Signed-off-by: George Popescu <georgepope@android.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: David Brazdil <dbrazdil@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |   14 ++++++++++++++
 scripts/Makefile.ubsan |   10 +++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.ubsan~ubsan-introducing-config_ubsan_bounds_local-for-clang
+++ a/lib/Kconfig.ubsan
@@ -47,6 +47,20 @@ config UBSAN_BOUNDS
 	  to the {str,mem}*cpy() family of functions (that is addressed
 	  by CONFIG_FORTIFY_SOURCE).
 
+config UBSAN_BOUNDS_LOCAL
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
--- a/scripts/Makefile.ubsan~ubsan-introducing-config_ubsan_bounds_local-for-clang
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

Patches currently in -mm which might be from georgepope@google.com are

ubsan-introducing-config_ubsan_bounds_local-for-clang.patch

