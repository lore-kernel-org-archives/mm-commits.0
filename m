Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88916C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352438AbiCYBhC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357497AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE86532EFA
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7592AB82727
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141ADC340F1;
        Fri, 25 Mar 2022 01:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172027;
        bh=sHlFBAUx2uiLmgR1mWiXQvInF4GCtFrNG7HcV2tMFpI=;
        h=Date:To:From:Subject:From;
        b=QgXA3eiMmu/Tw7JmySbPaiTjL3n3d/E0FG+oZ5LPDlCNekOR8RBufrMOiOsVl9AUl
         lvI8egglD6iU7V4hjY4skX0qzTWdMSDiFp4HzToAvF+HEBsvK42OrewzxcBBIFVPyg
         1raFIepIoWlHJ6mUMlDLGEj6ajkRtoQFnb+NzYO0=
Date:   Thu, 24 Mar 2022 18:33:46 -0700
To:     mm-commits@vger.kernel.org, ojeda@kernel.org,
        ndesaulniers@google.com, nathan@kernel.org, keescook@chromium.org,
        linux@rasmusvillemoes.dk, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] include-drop-pointless-__compiler_offsetof-indirection.patch removed from -mm tree
Message-Id: <20220325013347.141ADC340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include: drop pointless __compiler_offsetof indirection
has been removed from the -mm tree.  Its filename was
     include-drop-pointless-__compiler_offsetof-indirection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: include: drop pointless __compiler_offsetof indirection

(1) compiler_types.h is unconditionally included via an -include flag
    (see scripts/Makefile.lib), and it defines __compiler_offsetof
    unconditionally.  So testing for definedness of __compiler_offsetof is
    mostly pointless.

(2) Every relevant compiler provides __builtin_offsetof (even sparse
    has had that for 14 years), and if for whatever reason one would end
    up picking up the poor man's fallback definition (C file compiler with
    completely custom CFLAGS?), newer clang versions won't treat the
    result as an Integer Constant Expression, so if used in place where
    such is required (static initializer or static_assert), one would get
    errors like

t.c:11:16: error: static_assert expression is not an integral constant expression
t.c:11:16: note: cast that performs the conversions of a reinterpret_cast is not allowed in a constant expression
t.c:4:33: note: expanded from macro 'offsetof'
#define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)

So just define offsetof unconditionally and directly in terms of
__builtin_offsetof.

Link: https://lkml.kernel.org/r/20220202102147.326672-1-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |    2 --
 include/linux/stddef.h         |    6 +-----
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/include/linux/compiler_types.h~include-drop-pointless-__compiler_offsetof-indirection
+++ a/include/linux/compiler_types.h
@@ -138,8 +138,6 @@ struct ftrace_likely_data {
  */
 #define __naked			__attribute__((__naked__)) notrace
 
-#define __compiler_offsetof(a, b)	__builtin_offsetof(a, b)
-
 /*
  * Prefer gnu_inline, so that extern inline functions do not emit an
  * externally visible function. This makes extern inline behave as per gnu89
--- a/include/linux/stddef.h~include-drop-pointless-__compiler_offsetof-indirection
+++ a/include/linux/stddef.h
@@ -13,11 +13,7 @@ enum {
 };
 
 #undef offsetof
-#ifdef __compiler_offsetof
-#define offsetof(TYPE, MEMBER)	__compiler_offsetof(TYPE, MEMBER)
-#else
-#define offsetof(TYPE, MEMBER)	((size_t)&((TYPE *)0)->MEMBER)
-#endif
+#define offsetof(TYPE, MEMBER)	__builtin_offsetof(TYPE, MEMBER)
 
 /**
  * sizeof_field() - Report the size of a struct field in bytes
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are


