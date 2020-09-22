Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E4BC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F20B423A9C
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794404;
	bh=mbnm6hxuzcWIz0UtcV6Y8R+ZXv0lM0WDuejvYAWLFxs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rYaH8ERCxINA7qaPExC1VvZMP7cyFGgFueImGG3Y6X0p2loopwtCq5alYLYVh9yzS
	 wcWapC0kZKrT7i/Ib1HaYgeMsgTfbiYeiWG7rI/bp+uyIs8cc58ffuibaLUuL59i43
	 lYDt3T+qD+ke8UYlOHQ45qfdj0UdpY0n0sAZ/2P0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIVRGn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgIVRGn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:06:43 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B536C207C3;
        Tue, 22 Sep 2020 17:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794402;
        bh=mbnm6hxuzcWIz0UtcV6Y8R+ZXv0lM0WDuejvYAWLFxs=;
        h=Date:From:To:Subject:From;
        b=zHwzZE6BEsXZbU2NFODd7FZvi9sDXgheFfDRpu/2iemju5AbEXJ3Kg2ALPHbxfuSp
         jTAatkrUwKtJT2WlBYUH4QfvvsvNSUcrhKsFp9KUwDpwGGbW3E2F5z+7yshDpyJfPM
         TC2bIkG/ne1LFKBt6itCryAByp6/z8iQuElwegRk=
Date:   Tue, 22 Sep 2020 10:06:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        natechancellor@gmail.com, michal.lkml@markovi.net,
        masahiroy@kernel.org, keescook@chromium.org,
        georgepope@android.com, elver@google.com, dvyukov@google.com,
        dbrazdil@google.com, arnd@arndb.de, a.p.zijlstra@chello.nl,
        georgepope@google.com
Subject:  [to-be-updated]
 ubsan-introducing-config_ubsan_bounds_local-for-clang.patch removed from -mm
 tree
Message-ID: <20200922170640.z7mDS%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: introduce CONFIG_UBSAN_BOUNDS_LOCAL for Clang
has been removed from the -mm tree.  Its filename was
     ubsan-introducing-config_ubsan_bounds_local-for-clang.patch

This patch was dropped because an updated version will be merged

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

ubsan-introducing-config_ubsan_local_bounds-for-clang.patch

