Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0D2C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiKIBlC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiKIBkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2C667F54
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE76261803
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4F5C433D6;
        Wed,  9 Nov 2022 01:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957955;
        bh=xgQwNlOT2Dfu5wrRczVtbzcdVo0MX8ld0zLQHT0VntU=;
        h=Date:To:From:Subject:From;
        b=BWVTqwL9N7q15ue2oOs5FyfcoWaic7QZz2YLVNkHJ9GKlIRgRcUgba6aouR3iwNAr
         NSoKkL2N2P9M9raYjLmjiBeioubfJuatW2eRHr5/xdG/hScAvtpvY+xAEesRa+6Y/f
         +ko4D6pU7TgtH7OmW5HQt6B4TN47Gzu0jHcdND0M=
Date:   Tue, 08 Nov 2022 17:39:14 -0800
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org, memxor@gmail.com,
        keescook@chromium.org, glider@google.com, elver@google.com,
        ashimida@linux.alibaba.com, arnd@arndb.de, andreyknvl@gmail.com,
        ojeda@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize.patch removed from -mm tree
Message-Id: <20221109013915.1E4F5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: compiler-gcc: be consistent with underscores use for `no_sanitize`
has been removed from the -mm tree.  Its filename was
     compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Li <ashimida@linux.alibaba.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
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


