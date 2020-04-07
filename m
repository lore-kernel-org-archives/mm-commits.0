From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 075/166] mm: prevent a warning when casting void*
 -> enum
Date: Mon, 06 Apr 2020 20:08:00 -0700
Message-ID: <20200407030800.mhJqunPQQ%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:02 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, palmerdabbelt@google.com, torvalds@linux-foundation.org

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
