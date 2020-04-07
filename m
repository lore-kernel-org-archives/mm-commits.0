From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 086/166] mm: fix ambiguous comments for better
 code readability
Date: Mon, 06 Apr 2020 20:08:33 -0700
Message-ID: <20200407030833.cfAvOm4Oa%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:35 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenqiwu@xiaomi.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
 mm/memory.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

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
@@ -1952,7 +1952,7 @@ static inline int remap_p4d_range(struct
  * @vma: user vma to map to
  * @addr: target user address to start at
  * @pfn: page frame number of kernel physical memory address
- * @size: size of map area
+ * @size: size of mapping area
  * @prot: page protection flags for this mapping
  *
  * Note: this is only safe if the mm semaphore is held when called.
_
