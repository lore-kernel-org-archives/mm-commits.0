From: akpm@linux-foundation.org
Subject: [merged] mm-elide-a-warning-when-casting-void-enum.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:59:32 -0700
Message-ID: <20200408015932.I04bkzRp0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, palmerdabbelt@google.com


The patch titled
     Subject: mm: prevent a warning when casting void* -> enum
has been removed from the -mm tree.  Its filename was
     mm-elide-a-warning-when-casting-void-enum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Palmer Dabbelt <palmerdabbelt@google.com>
Subject: mm: prevent a warning when casting void* -> enum

I recently build the RISC-V port with LLVM trunk, which has introduced a
new warning when casting from a pointer to an enum of a smaller size. 
This patch simply casts to a long in the middle to stop the warning.  I'd
be surprised this is the only one in the kernel, but it's the only one I
saw.

Link: http://lkml.kernel.org/r/20200227211741.83165-1-palmer@dabbelt.com
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-elide-a-warning-when-casting-void-enum
+++ a/mm/rmap.c
@@ -1372,7 +1372,7 @@ static bool try_to_unmap_one(struct page
 	struct page *subpage;
 	bool ret = true;
 	struct mmu_notifier_range range;
-	enum ttu_flags flags = (enum ttu_flags)arg;
+	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 
 	/* munlock has nothing to gain from examining un-locked vmas */
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
_

Patches currently in -mm which might be from palmerdabbelt@google.com are
