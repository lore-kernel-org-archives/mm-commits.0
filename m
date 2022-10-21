Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6490FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 18:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJUS3o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiJUS3m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 14:29:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7835B2CE11
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 11:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11F72B82BCD
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 18:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA80EC433C1;
        Fri, 21 Oct 2022 18:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666376973;
        bh=xRX0BAD6+34eOM8dyzzWCmLhnu8YAR0aGw0fAIdHFd4=;
        h=Date:To:From:Subject:From;
        b=IAd/MXkS1rsW6gRgtQf3eVkFnIMyb/pFM3YTYOU0v4swh4UiXe+FZ0QmgY782cj8M
         scL2YLqD2kwrHMKkAt6vsgUgGg59WSSV5K9S2285b6KJIne0UsX7Igm9yenlVw64lD
         2U9tbOyRwdow0u7I+zCpjNj97tMW5OsCQCyOla9U=
Date:   Fri, 21 Oct 2022 11:29:33 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org, memxor@gmail.com,
        keescook@chromium.org, glider@google.com, elver@google.com,
        ashimida@linux.alibaba.com, arnd@arndb.de, andreyknvl@gmail.com,
        ojeda@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize.patch added to mm-unstable branch
Message-Id: <20221021182933.BA80EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc: be consistent with underscores use for `no_sanitize`
has been added to the -mm mm-unstable branch.  Its filename is
     compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miguel Ojeda <ojeda@kernel.org>
Subject: compiler-gcc: be consistent with underscores use for `no_sanitize`
Date: Fri, 21 Oct 2022 13:59:52 +0200

Patch series "compiler-gcc: be consistent with underscores use for
`no_sanitize`".


This patch (of 5):

Other macros that define shorthands for attributes in e.g. 
`compiler_attributes.h` and elsewhere use underscores.

Link: https://lkml.kernel.org/r/20221021115956.9947-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Li <ashimida@linux.alibaba.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/compiler-gcc.h~compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize
+++ a/include/linux/compiler-gcc.h
@@ -83,25 +83,25 @@
 #endif
 
 #if __has_attribute(__no_sanitize_address__)
-#define __no_sanitize_address __attribute__((no_sanitize_address))
+#define __no_sanitize_address __attribute__((__no_sanitize_address__))
 #else
 #define __no_sanitize_address
 #endif
 
 #if defined(__SANITIZE_THREAD__) && __has_attribute(__no_sanitize_thread__)
-#define __no_sanitize_thread __attribute__((no_sanitize_thread))
+#define __no_sanitize_thread __attribute__((__no_sanitize_thread__))
 #else
 #define __no_sanitize_thread
 #endif
 
 #if __has_attribute(__no_sanitize_undefined__)
-#define __no_sanitize_undefined __attribute__((no_sanitize_undefined))
+#define __no_sanitize_undefined __attribute__((__no_sanitize_undefined__))
 #else
 #define __no_sanitize_undefined
 #endif
 
 #if defined(CONFIG_KCOV) && __has_attribute(__no_sanitize_coverage__)
-#define __no_sanitize_coverage __attribute__((no_sanitize_coverage))
+#define __no_sanitize_coverage __attribute__((__no_sanitize_coverage__))
 #else
 #define __no_sanitize_coverage
 #endif
_

Patches currently in -mm which might be from ojeda@kernel.org are

compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_address__.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_thread__.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__.patch
compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__.patch

