From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 dynamic_debug-use-address-of-operator-on-section-symbols.patch added to -mm
 tree
Date: Fri, 20 Mar 2020 17:40:04 -0700
Message-ID: <20200321004004.OSskxIzRJ%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUAkF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 20:40:05 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, mm-commits@vger.kernel.org, natechancellor@gmail.com, ndesaulniers@google.com


The patch titled
     Subject: lib/dynamic_debug.c: use address-of operator on section symbols
has been added to the -mm tree.  Its filename is
     dynamic_debug-use-address-of-operator-on-section-symbols.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-use-address-of-operator-on-section-symbols.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-use-address-of-operator-on-section-symbols.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1013,7 +1013,7 @@ static int __init dynamic_debug_init(voi
 	int n = 0, entries = 0, modct = 0;
 	int verbose_bytes = 0;
 
-	if (__start___verbose == __stop___verbose) {
+	if (&__start___verbose == &__stop___verbose) {
 		pr_warn("_ddebug table is empty in a CONFIG_DYNAMIC_DEBUG build\n");
 		return 1;
 	}
_

Patches currently in -mm which might be from natechancellor@gmail.com are

mm-kmemleak-use-address-of-operator-on-section-symbols.patch
kernel-extable-use-address-of-operator-on-section-symbols.patch
dynamic_debug-use-address-of-operator-on-section-symbols.patch
