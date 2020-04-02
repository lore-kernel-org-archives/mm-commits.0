From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 102/155] mm: clarify a confusing comment for
 remap_pfn_range()
Date: Wed, 01 Apr 2020 21:09:03 -0700
Message-ID: <20200402040903.y3mjI6PGf%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDBEJF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:05 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, wenhu.wang@vivo.com

From: WANG Wenhu <wenhu.wang@vivo.com>
Subject: mm: clarify a confusing comment for remap_pfn_range()

It really made me scratch my head.  Replace the comment with an accurate
and consistent description.

The parameter pfn actually refers to the page frame number which is
right-shifted by PAGE_SHIFT from the physical address.

Link: http://lkml.kernel.org/r/20200310073955.43415-1-wenhu.wang@vivo.com
Signed-off-by: WANG Wenhu <wenhu.wang@vivo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-clarify-a-confusing-comment-of-remap_pfn_range
+++ a/mm/memory.c
@@ -1939,7 +1939,7 @@ static inline int remap_p4d_range(struct
  * remap_pfn_range - remap kernel memory to userspace
  * @vma: user vma to map to
  * @addr: target user address to start at
- * @pfn: physical address of kernel memory
+ * @pfn: page frame number of kernel physical memory address
  * @size: size of map area
  * @prot: page protection flags for this mapping
  *
_
