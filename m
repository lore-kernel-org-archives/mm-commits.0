From: akpm@linux-foundation.org
Subject: [merged] tools-build-tweak-unused-value-workaround.patch
 removed from -mm tree
Date: Thu, 23 Apr 2020 12:51:43 -0700
Message-ID: <20200423195143.GXQKDALWu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgDWTvo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:51:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gbiv@google.com, mm-commits@vger.kernel.org, ndesaulniers@google.com


The patch titled
     Subject: tools/build: tweak unused value workaround
has been removed from the -mm tree.  Its filename was
     tools-build-tweak-unused-value-workaround.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from gbiv@google.com are
