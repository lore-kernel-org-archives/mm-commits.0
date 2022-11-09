Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4836C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiKIBld (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiKIBkD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA3667F67
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CB8961824
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F405BC43470;
        Wed,  9 Nov 2022 01:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957960;
        bh=xHzt41NuZMClrahUfFR+rvRbZPF0Naud79QGFhNAbZE=;
        h=Date:To:From:Subject:From;
        b=fztK14N9mjUTD4EW+xvM0yqvST6kX4sFmsIWp2PlZBLZJ5fMhixvQKvJs1jFfejBo
         O65F+proAXtUbaRcNNMDOP2yc16FJKYAhMUxPhi5Zk3soDwN8vw6ukXxWSOHX8lhyj
         06wIJ9hORPGARXJwudVSpCDFNQYfxRYyFpeSQBEg=
Date:   Tue, 08 Nov 2022 17:39:19 -0800
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org, memxor@gmail.com,
        keescook@chromium.org, glider@google.com, elver@google.com,
        ashimida@linux.alibaba.com, arnd@arndb.de, andreyknvl@gmail.com,
        ojeda@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__.patch removed from -mm tree
Message-Id: <20221109013919.F405BC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: compiler-gcc: document minimum version for `__no_sanitize_coverage__`
has been removed from the -mm tree.  Its filename was
     compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miguel Ojeda <ojeda@kernel.org>
Subject: compiler-gcc: document minimum version for `__no_sanitize_coverage__`
Date: Fri, 21 Oct 2022 13:59:56 +0200

The attribute was added in GCC 12.1.

This will simplify future cleanups, and is closer to what we do
in `compiler_attributes.h`.

Link: https://godbolt.org/z/MGbT76j6G
Link: https://lkml.kernel.org/r/20221021115956.9947-5-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
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

 include/linux/compiler-gcc.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/compiler-gcc.h~compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__
+++ a/include/linux/compiler-gcc.h
@@ -92,6 +92,9 @@
 
 #define __no_sanitize_undefined __attribute__((__no_sanitize_undefined__))
 
+/*
+ * Only supported since gcc >= 12
+ */
 #if defined(CONFIG_KCOV) && __has_attribute(__no_sanitize_coverage__)
 #define __no_sanitize_coverage __attribute__((__no_sanitize_coverage__))
 #else
_

Patches currently in -mm which might be from ojeda@kernel.org are


