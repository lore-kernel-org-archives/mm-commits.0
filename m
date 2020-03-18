From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-clarify-a-confusing-comment-for-vm_iomap_memory.patch added to -mm tree
Date: Wed, 18 Mar 2020 13:39:00 -0700
Message-ID: <20200318203900.BLNm0-3qs%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgCRUjB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 16:39:01 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, wenhu.wang@vivo.com


The patch titled
     Subject: mm/memory.c: clarify a confusing comment for vm_iomap_memory
has been added to the -mm tree.  Its filename is
     mm-clarify-a-confusing-comment-for-vm_iomap_memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-a-confusing-comment-for-vm_iomap_memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-a-confusing-comment-for-vm_iomap_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Wenhu <wenhu.wang@vivo.com>
Subject: mm/memory.c: clarify a confusing comment for vm_iomap_memory

The param "start" actually referes to the physical memory start, which is
to be mapped into virtual area vma.  And it is the field vma->vm_start
which stands for the start of the area.

Most of the time, we do not read through whole implementation of a
function but only the definition and essential comments.  Accurate
comments are definitely the base stone.

Link: http://lkml.kernel.org/r/20200318052206.105104-1-wenhu.wang@vivo.com
Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-clarify-a-confusing-comment-for-vm_iomap_memory
+++ a/mm/memory.c
@@ -2009,7 +2009,7 @@ EXPORT_SYMBOL(remap_pfn_range);
 /**
  * vm_iomap_memory - remap memory to userspace
  * @vma: user vma to map to
- * @start: start of area
+ * @start: start of the physical memory to be mapped
  * @len: size of area
  *
  * This is a simplified io_remap_pfn_range() for common driver use. The
_

Patches currently in -mm which might be from wenhu.wang@vivo.com are

mm-clarify-a-confusing-comment-of-remap_pfn_range.patch
mm-clarify-a-confusing-comment-for-vm_iomap_memory.patch
