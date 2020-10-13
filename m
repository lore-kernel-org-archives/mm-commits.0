Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773C1C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BEC121D7F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632878;
	bh=E02l5tEJHAICIFBZCSW2oqj+4F/y71f99ImXn80EBWY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=uRnwIRMHMg2fDWpS4xMIGYLnMo2BwM6LbnFvfIjC3mbNYBAN54pzmB+4Ce5FG6cW8
	 AlnRzGQ6AVTXPcVuDRJbH118Yvhr53vk3BLp6yEM69oBsC1YxrNukfmLL0zd5ABwLR
	 fETfaGTcSLotvxaHVmyUa4afb1gLdz76xqUsNoHQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389124AbgJMXr5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:47:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9723521D7B;
        Tue, 13 Oct 2020 23:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632876;
        bh=E02l5tEJHAICIFBZCSW2oqj+4F/y71f99ImXn80EBWY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TY6dUY5+Ug2oirODh0yYV1mW7iYO3ifQDKr/5bFiW9Rz9QE9t9ch8jsVK3n86TZpN
         nabXjz6u/VGEnJUhnKV0rppG+fYx9TYDkqtTLlOBjy9II/m4gRJCRylxKmI3r7fX+h
         wHD+tnin5QUdepOCAy18Ct7VIUhq9h3eJBjzPDh4=
Date:   Tue, 13 Oct 2020 16:47:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, ast@kernel.org,
        daniel@iogearbox.net, elver@google.com, keescook@chromium.org,
        linux-mm@kvack.org, masahiroy@kernel.org, maskray@google.com,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        sedat.dilek@gmail.com, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will@kernel.org
Subject:  [patch 007/181] compiler-gcc: improve version error
Message-ID: <20201013234755.E37ffaRXs%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Subject: compiler-gcc: improve version error

As Kees suggests, doing so provides developers with two useful pieces of
information:
- The kernel build was attempting to use GCC.
  (Maybe they accidentally poked the wrong configs in a CI.)
- They need 4.9 or better.
  ("Upgrade to what version?" doesn't need to be dug out of documentation,
   headers, etc.)

Link: https://lkml.kernel.org/r/20200902225911.209899-8-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler-gcc.h~compiler-gcc-improve-version-error
+++ a/include/linux/compiler-gcc.h
@@ -12,7 +12,7 @@
 
 /* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145 */
 #if GCC_VERSION < 40900
-# error Sorry, your compiler is too old - please upgrade it.
+# error Sorry, your version of GCC is too old - please use 4.9 or newer.
 #endif
 
 /* Optimization barrier */
_
