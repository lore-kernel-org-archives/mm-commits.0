From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-clarify-a-confusing-comment-of-remap_pfn_range.patch
 added to -mm tree
Date: Wed, 11 Mar 2020 20:14:21 -0700
Message-ID: <20200312031421.3p-gvvF9H%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387453AbgCLDOW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 23:14:22 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, wenhu.wang@vivo.com


The patch titled
     Subject: mm: clarify a confusing comment for remap_pfn_range()
has been added to the -mm tree.  Its filename is
     mm-clarify-a-confusing-comment-of-remap_pfn_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-a-confusing-comment-of-remap_pfn_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-a-confusing-comment-of-remap_pfn_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from wenhu.wang@vivo.com are

mm-clarify-a-confusing-comment-of-remap_pfn_range.patch
