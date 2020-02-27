From: akpm@linux-foundation.org
Subject: + mm-elide-a-warning-when-casting-void-enum.patch added
 to -mm tree
Date: Thu, 27 Feb 2020 15:08:30 -0800
Message-ID: <20200227230830.87frJdf7U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbgB0XIb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 27 Feb 2020 18:08:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, palmerdabbelt@google.com


The patch titled
     Subject: mm: prevent a warning when casting void* -> enum
has been added to the -mm tree.  Its filename is
     mm-elide-a-warning-when-casting-void-enum.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-elide-a-warning-when-casting-void-enum.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-elide-a-warning-when-casting-void-enum.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1366,7 +1366,7 @@ static bool try_to_unmap_one(struct page
 	struct page *subpage;
 	bool ret = true;
 	struct mmu_notifier_range range;
-	enum ttu_flags flags = (enum ttu_flags)arg;
+	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 
 	/* munlock has nothing to gain from examining un-locked vmas */
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
_

Patches currently in -mm which might be from palmerdabbelt@google.com are

mm-elide-a-warning-when-casting-void-enum.patch
