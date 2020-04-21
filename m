From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 08/15] tools/build: tweak unused value workaround
Date: Mon, 20 Apr 2020 18:14:01 -0700
Message-ID: <20200421011401.UOadM_a5p%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbgDUBOC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 21:14:02 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gbiv@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, ndesaulniers@google.com, torvalds@linux-foundation.org

From: George Burgess IV <gbiv@google.com>
Subject: tools/build: tweak unused value workaround

Clang has -Wself-assign enabled by default under -Wall, which always gets
-Werror'ed on this file, causing sync-compare-and-swap to be disabled by
default.  The generally-accepted way to spell "this value is intentionally
unused," is casting it to `void`.  This is accepted by both GCC and Clang
with -Wall enabled: https://godbolt.org/z/qqZ9r3

Link: http://lkml.kernel.org/r/20200414195638.156123-1-gbiv@google.com
Signed-off-by: George Burgess IV <gbiv@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/build/feature/test-sync-compare-and-swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/build/feature/test-sync-compare-and-swap.c~tools-build-tweak-unused-value-workaround
+++ a/tools/build/feature/test-sync-compare-and-swap.c
@@ -7,7 +7,7 @@ int main(int argc, char *argv[])
 {
 	uint64_t old, new = argc;
 
-	argv = argv;
+	(void)argv;
 	do {
 		old = __sync_val_compare_and_swap(&x, 0, 0);
 	} while (!__sync_bool_compare_and_swap(&x, old, new));
_
