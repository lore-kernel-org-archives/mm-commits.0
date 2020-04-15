From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-build-tweak-unused-value-workaround.patch added
 to -mm tree
Date: Tue, 14 Apr 2020 17:00:28 -0700
Message-ID: <20200415000028.0WXTVlaZl%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgDOAAa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 20:00:30 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gbiv@google.com, mm-commits@vger.kernel.org, ndesaulniers@google.com


The patch titled
     Subject: tools/build: tweak unused value workaround
has been added to the -mm tree.  Its filename is
     tools-build-tweak-unused-value-workaround.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-build-tweak-unused-value-workaround.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-build-tweak-unused-value-workaround.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tools-build-tweak-unused-value-workaround.patch
