Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C82C433E5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 492CB619AD
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhC1TLq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhC1TLh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF80F619A0;
        Sun, 28 Mar 2021 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958697;
        bh=kFP++UmzFwicXClm+iUmDrStZ3XpWe8iQ410UaVbtT4=;
        h=Date:From:To:Subject:From;
        b=VVcMBTg7Y3oMTltgTkqeOGbDKeGZZ5Rf037US6ZXDafmB6l1Fn1JI/j9PH8XMZJ8b
         Z8Ws1aq68qdKkZM8lDFLmCKvOv0+Q1t9rceq2ZzuhiiRaC9vabrtWDCFT9RFHzgR+e
         fdVWZLBxoPNkMcsrr5dF7Cdbr/MwmAajFdpkT4fw=
Date:   Sun, 28 Mar 2021 12:11:36 -0700
From:   akpm@linux-foundation.org
To:     chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch, hch@lst.de,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rodrigo.vivi@intel.com
Subject:  + mm-add-remap_pfn_range_notrack.patch added to -mm tree
Message-ID: <20210328191136.NTLOjx41R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add remap_pfn_range_notrack
has been added to the -mm tree.  Its filename is
     mm-add-remap_pfn_range_notrack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-remap_pfn_range_notrack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-remap_pfn_range_notrack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: add remap_pfn_range_notrack

Patch series "add remap_pfn_range_notrack instead of reinventing it in i915", v2.

i915 has some reason to want to avoid the track_pfn_remap overhead in
remap_pfn_range.  Add a function to the core VM to do just that rather
than reinventing the functionality poorly in the driver.

Note that the remap_io_sg path does get exercises when using Xorg on my
Thinkpad X1, so this should be considered lightly tested, I've not managed
to hit the remap_io_mapping path at all.


This patch (of 4):

Add a version of remap_pfn_range that does not call track_pfn_range.  This
will be used to fix horrible abuses of VM internals in the i915 driver.

Link: https://lkml.kernel.org/r/20210326055505.1424432-1-hch@lst.de
Link: https://lkml.kernel.org/r/20210326055505.1424432-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +
 mm/memory.c        |   51 ++++++++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 20 deletions(-)

--- a/include/linux/mm.h~mm-add-remap_pfn_range_notrack
+++ a/include/linux/mm.h
@@ -2722,6 +2722,8 @@ unsigned long change_prot_numa(struct vm
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
+int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
--- a/mm/memory.c~mm-add-remap_pfn_range_notrack
+++ a/mm/memory.c
@@ -2260,26 +2260,17 @@ static inline int remap_p4d_range(struct
 	return 0;
 }
 
-/**
- * remap_pfn_range - remap kernel memory to userspace
- * @vma: user vma to map to
- * @addr: target page aligned user address to start at
- * @pfn: page frame number of kernel physical memory address
- * @size: size of mapping area
- * @prot: page protection flags for this mapping
- *
- * Note: this is only safe if the mm semaphore is held when called.
- *
- * Return: %0 on success, negative error code otherwise.
+/*
+ * Variant of remap_pfn_range that does not call track_pfn_remap.  The caller
+ * must have pre-validated the caching bits of the pgprot_t.
  */
-int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
-		    unsigned long pfn, unsigned long size, pgprot_t prot)
+int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
 	pgd_t *pgd;
 	unsigned long next;
 	unsigned long end = addr + PAGE_ALIGN(size);
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long remap_pfn = pfn;
 	int err;
 
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
@@ -2309,10 +2300,6 @@ int remap_pfn_range(struct vm_area_struc
 		vma->vm_pgoff = pfn;
 	}
 
-	err = track_pfn_remap(vma, &prot, remap_pfn, addr, PAGE_ALIGN(size));
-	if (err)
-		return -EINVAL;
-
 	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 
 	BUG_ON(addr >= end);
@@ -2324,12 +2311,36 @@ int remap_pfn_range(struct vm_area_struc
 		err = remap_p4d_range(mm, pgd, addr, next,
 				pfn + (addr >> PAGE_SHIFT), prot);
 		if (err)
-			break;
+			return err;
 	} while (pgd++, addr = next, addr != end);
 
+	return 0;
+}
+
+/**
+ * remap_pfn_range - remap kernel memory to userspace
+ * @vma: user vma to map to
+ * @addr: target page aligned user address to start at
+ * @pfn: page frame number of kernel physical memory address
+ * @size: size of mapping area
+ * @prot: page protection flags for this mapping
+ *
+ * Note: this is only safe if the mm semaphore is held when called.
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		    unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	int err;
+
+	err = track_pfn_remap(vma, &prot, pfn, addr, PAGE_ALIGN(size));
 	if (err)
-		untrack_pfn(vma, remap_pfn, PAGE_ALIGN(size));
+		return -EINVAL;
 
+	err = remap_pfn_range_notrack(vma, addr, pfn, size, prot);
+	if (err)
+		untrack_pfn(vma, pfn, PAGE_ALIGN(size));
 	return err;
 }
 EXPORT_SYMBOL(remap_pfn_range);
_

Patches currently in -mm which might be from hch@lst.de are

mm-add-remap_pfn_range_notrack.patch
mm-add-a-io_mapping_map_user-helper.patch
i915-use-io_mapping_map_user.patch
i915-fix-remap_io_sg-to-verify-the-pgprot.patch
samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch
mm-unexport-remap_vmalloc_range_partial.patch

