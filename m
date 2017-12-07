From: akpm@linux-foundation.org
Subject: + lib-ubsanc-s-missaligned-misaligned.patch added to -mm tree
Date: Wed, 06 Dec 2017 17:24:33 -0800
Message-ID: <5a289851.25RcS5v05RLGcj+H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34654 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752498AbdLGBYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 20:24:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, David.Laight@ACULAB.COM, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/ubsan.c: s/missaligned/misaligned/
has been added to the -mm tree.  Its filename is
     lib-ubsanc-s-missaligned-misaligned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-ubsanc-s-missaligned-misaligned.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-ubsanc-s-missaligned-misaligned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/ubsan.c: s/missaligned/misaligned/

A vist from the spelling fairy.

Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/ubsan.c~lib-ubsanc-s-missaligned-misaligned lib/ubsan.c
--- a/lib/ubsan.c~lib-ubsanc-s-missaligned-misaligned
+++ a/lib/ubsan.c
@@ -281,7 +281,7 @@ static void handle_null_ptr_deref(struct
 	ubsan_epilogue(&flags);
 }
 
-static void handle_missaligned_access(struct type_mismatch_data *data,
+static void handle_misaligned_access(struct type_mismatch_data *data,
 				unsigned long ptr)
 {
 	unsigned long flags;
@@ -323,7 +323,7 @@ void __ubsan_handle_type_mismatch(struct
 		handle_null_ptr_deref(data);
 	else if (data->alignment && !IS_ALIGNED(ptr, data->alignment))
 		if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
-			handle_missaligned_access(data, ptr);
+			handle_misaligned_access(data, ptr);
 	else
 		handle_object_size_mismatch(data, ptr);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage-fix.patch
mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

