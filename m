Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D59C43217
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiKIBld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiKIBkD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A41E67F68
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2711EB81CDB
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB92C433C1;
        Wed,  9 Nov 2022 01:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957958;
        bh=554A9fcJY2U29q/axtdzJZ4eFRtdBQAy2zqX4BgdCgw=;
        h=Date:To:From:Subject:From;
        b=IpbKUyXljZiygrMuX55nDbIv61Cu+8ldtdYthyRZXe9LeNIpzyu8IU24CLPwwVXhB
         GFlLVZ2VagwX9W7bFM2jAuhzYV5MdbK4Al5CgtDqWYvSYBae3rJfEFirCMyXDl16uG
         YrILHNUwKImLEzTy95jlapA8fpc+UIAM2FDy1c40=
Date:   Tue, 08 Nov 2022 17:39:18 -0800
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org, memxor@gmail.com,
        keescook@chromium.org, glider@google.com, elver@google.com,
        ashimida@linux.alibaba.com, arnd@arndb.de, andreyknvl@gmail.com,
        ojeda@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__.patch removed from -mm tree
Message-Id: <20221109013918.BFB92C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: compiler-gcc: remove attribute support check for `__no_sanitize_undefined__`
has been removed from the -mm tree.  Its filename was
     compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miguel Ojeda <ojeda@kernel.org>
Subject: compiler-gcc: remove attribute support check for `__no_sanitize_undefined__`
Date: Fri, 21 Oct 2022 13:59:55 +0200

The attribute was added in GCC 4.9, while the minimum GCC version
supported by the kernel is GCC 5.1.

Therefore, remove the check.

Link: https://godbolt.org/z/GrMeo6fYr
Link: https://lkml.kernel.org/r/20221021115956.9947-4-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Li <ashimida@linux.alibaba.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/compiler-gcc.h~compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__
+++ a/include/linux/compiler-gcc.h
@@ -90,11 +90,7 @@
 #define __no_sanitize_thread
 #endif
 
-#if __has_attribute(__no_sanitize_undefined__)
 #define __no_sanitize_undefined __attribute__((__no_sanitize_undefined__))
-#else
-#define __no_sanitize_undefined
-#endif
 
 #if defined(CONFIG_KCOV) && __has_attribute(__no_sanitize_coverage__)
 #define __no_sanitize_coverage __attribute__((__no_sanitize_coverage__))
_

Patches currently in -mm which might be from ojeda@kernel.org are


