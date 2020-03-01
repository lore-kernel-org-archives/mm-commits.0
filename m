From: akpm@linux-foundation.org
Subject: +
 mm-fix-ambiguous-comments-for-better-code-readability.patch added to -mm
 tree
Date: Sat, 29 Feb 2020 18:01:45 -0800
Message-ID: <20200301020145.OgO4nCFPG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCACBs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 21:01:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix ambiguous comments for better code readability
has been added to the -mm tree.  Its filename is
     mm-fix-ambiguous-comments-for-better-code-readability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-ambiguous-comments-for-better-code-readability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-ambiguous-comments-for-better-code-readability.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: chenqiwu <chenqiwu@xiaomi.com>
Subject: mm: fix ambiguous comments for better code readability

The parameter of remap_pfn_range() @pfn passed from the caller is actually
a page-frame number converted by corresponding physical address of kernel
memory, the original comment is ambiguous that may mislead the users.

Meanwhile, there is an ambiguous typo "VMM" in the comment of
vm_area_struct.  So fixing them will make the code more readable.

Link: http://lkml.kernel.org/r/1583026921-15279-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 mm/memory.c              |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm_types.h~mm-fix-ambiguous-comments-for-better-code-readability
+++ a/include/linux/mm_types.h
@@ -289,8 +289,8 @@ struct vm_userfaultfd_ctx {};
 #endif /* CONFIG_USERFAULTFD */
 
 /*
- * This struct defines a memory VMM memory area. There is one of these
- * per VM-area/task.  A VM area is any part of the process virtual memory
+ * This struct describes a virtual memory area. There is one of these
+ * per VM-area/task. A VM area is any part of the process virtual memory
  * space that has a special rule for the page-fault handlers (ie a shared
  * library, the executable area etc).
  */
--- a/mm/memory.c~mm-fix-ambiguous-comments-for-better-code-readability
+++ a/mm/memory.c
@@ -1939,8 +1939,8 @@ static inline int remap_p4d_range(struct
  * remap_pfn_range - remap kernel memory to userspace
  * @vma: user vma to map to
  * @addr: target user address to start at
- * @pfn: physical address of kernel memory
- * @size: size of map area
+ * @pfn: page frame number of kernel memory
+ * @size: size of mapping area
  * @prot: page protection flags for this mapping
  *
  * Note: this is only safe if the mm semaphore is held when called.
_

Patches currently in -mm which might be from chenqiwu@xiaomi.com are

mm-slubc-replace-cpu_slab-partial-with-wrapped-apis.patch
mm-slubc-replace-kmem_cache-cpu_partial-with-wrapped-apis.patch
mm-fix-ambiguous-comments-for-better-code-readability.patch
lib-rbtree-fix-coding-style-of-assignments.patch
