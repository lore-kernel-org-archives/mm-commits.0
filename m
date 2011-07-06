From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-make-copy_from_user-provably-correct.patch added to -mm tree
Date: Wed, 06 Jul 2011 12:56:33 -0700
Message-ID: <201107061956.p66JuXf9026628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755704Ab1GFT4h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 15:56:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm/mempolicy.c: make copy_from_user() provably correct
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-make-copy_from_user-provably-correct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/mempolicy.c: make copy_from_user() provably correct
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Because of x86-implement-strict-user-copy-checks-for-x86_64.patch

When compiling mm/mempolicy.c the following warning is shown.

In file included from arch/x86/include/asm/uaccess.h:572,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:70,
                 from mm/mempolicy.c:68:
In function `copy_from_user',
    inlined from `compat_sys_get_mempolicy' at mm/mempolicy.c:1415:
arch/x86/include/asm/uaccess_64.h:64: warning: call to `copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
  LD      mm/built-in.o

Fix this by passing correct buffer size value.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-make-copy_from_user-provably-correct mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-make-copy_from_user-provably-correct
+++ a/mm/mempolicy.c
@@ -1411,7 +1411,9 @@ asmlinkage long compat_sys_get_mempolicy
 	err = sys_get_mempolicy(policy, nm, nr_bits+1, addr, flags);
 
 	if (!err && nmask) {
-		err = copy_from_user(bm, nm, alloc_size);
+		unsigned long copy_size;
+		copy_size = min_t(unsigned long, sizeof(bm), alloc_size);
+		err = copy_from_user(bm, nm, copy_size);
 		/* ensure entire bitmap is zeroed */
 		err |= clear_user(nmask, ALIGN(maxnode-1, 8) / 8);
 		err |= compat_put_bitmap(nmask, bm, nr_bits);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-reclaimable-lru-check-in-memcg.patch
memcg-fix-reclaimable-lru-check-in-memcg-checkpatch-fixes.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix.patch
memcg-fix-reclaimable-lru-check-in-memcg-fix-2.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
mm-preallocate-page-before-lock_page-at-filemap-cow-fix.patch
mm-mempolicyc-make-copy_from_user-provably-correct.patch
mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

