From: akpm@linux-foundation.org
Subject: +
 mm-memoryc-make-remap_pfn_range-reject-unaligned-addr.patch added to -mm tree
Date: Wed, 17 Jun 2020 16:45:31 -0700
Message-ID: <20200617234531.L-eYq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgFQXpe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 19:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhangalex@google.com


The patch titled
     Subject: mm/memory.c: make remap_pfn_range() reject unaligned addr
has been added to the -mm tree.  Its filename is
     mm-memoryc-make-remap_pfn_range-reject-unaligned-addr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-make-remap_pfn_range-reject-unaligned-addr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-make-remap_pfn_range-reject-unaligned-addr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Zhang <zhangalex@google.com>
Subject: mm/memory.c: make remap_pfn_range() reject unaligned addr

This function implicitly assumes that the addr passed in is page aligned. 
A non page aligned addr could ultimately cause a kernel bug in
remap_pte_range as the exit condition in the logic loop may never be
satisfied.  This patch documents the need for the requirement, as well as
explicitly adds a check for it.

Link: http://lkml.kernel.org/r/20200617233512.177519-1-zhangalex@google.com
Signed-off-by: Alex Zhang <zhangalex@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-make-remap_pfn_range-reject-unaligned-addr
+++ a/mm/memory.c
@@ -2081,7 +2081,7 @@ static inline int remap_p4d_range(struct
 /**
  * remap_pfn_range - remap kernel memory to userspace
  * @vma: user vma to map to
- * @addr: target user address to start at
+ * @addr: target page aligned user address to start at
  * @pfn: page frame number of kernel physical memory address
  * @size: size of mapping area
  * @prot: page protection flags for this mapping
@@ -2100,6 +2100,9 @@ int remap_pfn_range(struct vm_area_struc
 	unsigned long remap_pfn = pfn;
 	int err;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
+		return -EINVAL;
+
 	/*
 	 * Physically remapped pages are special. Tell the
 	 * rest of the world about it:
_

Patches currently in -mm which might be from zhangalex@google.com are

mm-memoryc-make-remap_pfn_range-reject-unaligned-addr.patch
