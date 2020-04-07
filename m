From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 126/166] lib/dynamic_debug.c: use address-of
 operator on section symbols
Date: Mon, 06 Apr 2020 20:10:45 -0700
Message-ID: <20200407031045.KqfxtQns2%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgDGDKr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:10:47 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbaron@akamai.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, natechancellor@gmail.com, ndesaulniers@google.com, torvalds@linux-foundation.org

From: Nathan Chancellor <natechancellor@gmail.com>
Subject: lib/dynamic_debug.c: use address-of operator on section symbols

Clang warns:

../lib/dynamic_debug.c:1034:24: warning: array comparison always
evaluates to false [-Wtautological-compare]
        if (__start___verbose == __stop___verbose) {
                              ^
1 warning generated.

These are not true arrays, they are linker defined symbols, which are just
addresses.  Using the address of operator silences the warning and does
not change the resulting assembly with either clang/ld.lld or gcc/ld
(tested with diff + objdump -Dr).

Link: https://github.com/ClangBuiltLinux/linux/issues/894
Link: http://lkml.kernel.org/r/20200220051320.10739-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/dynamic_debug.c~dynamic_debug-use-address-of-operator-on-section-symbols
+++ a/lib/dynamic_debug.c
@@ -1031,7 +1031,7 @@ static int __init dynamic_debug_init(voi
 	int n = 0, entries = 0, modct = 0;
 	int verbose_bytes = 0;
 
-	if (__start___verbose == __stop___verbose) {
+	if (&__start___verbose == &__stop___verbose) {
 		pr_warn("_ddebug table is empty in a CONFIG_DYNAMIC_DEBUG build\n");
 		return 1;
 	}
_
