From: akpm@linux-foundation.org
Subject: +
 mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch added to
 -mm tree
Date: Thu, 30 Nov 2017 13:02:11 -0800
Message-ID: <5a2071d3.1MNulJfAIe2ZqPOz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55012 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdK3VCM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 16:02:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, mhocko@kernel.org, torvalds@linux-foundation.org, xieyisheng1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kmemleak.c: make cond_resched() rate-limiting more efficient
has been added to the -mm tree.  Its filename is
     mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch

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
Subject: mm/kmemleak.c: make cond_resched() rate-limiting more efficient

bde5f6bc68db5 ("kmemleak: add scheduling point to kmemleak_scan()") tries
to rate-limit the frequency of cond_resched() calls, but does it in a way
which might incur an expensive division operation in the inner loop. 
Simplify this.

Fixes: bde5f6bc68db5 ("kmemleak: add scheduling point to kmemleak_scan()")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient
+++ a/mm/kmemleak.c
@@ -1523,7 +1523,7 @@ static void kmemleak_scan(void)
 			if (page_count(page) == 0)
 				continue;
 			scan_block(page, page + 1, NULL);
-			if (!(pfn % (MAX_SCAN_SIZE / sizeof(*page))))
+			if (!(pfn & 63))
 				cond_resched();
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

