Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8932EC61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 21:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBWVuf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 16:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBWVue (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 16:50:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8DD1ADDC
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 13:50:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 054B261792
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 21:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1112AC433D2;
        Thu, 23 Feb 2023 21:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677189027;
        bh=w5GKUdAkD49mY0FWDL6IkgzhB/P6fOHDp11sorVpnIc=;
        h=Date:To:From:Subject:From;
        b=vSsxrK+6X+MckVpz7SFUqbe/muT3OK++UTB5bb/j6IjDMdgAZC1pQ8Csry1g3ALIb
         51kJpjmkc80hCv959Yx9YfVFHx9GamDY0HDKAI7Ixx4BmX0Ys2MY35kGoMRJrzvWgc
         kXpTMZu4tTsYVL66RG6fBq2XmskVKgiayUElEzVg=
Date:   Thu, 23 Feb 2023 13:50:26 -0800
To:     mm-commits@vger.kernel.org, pgofman@codeweavers.com,
        peterx@redhat.com, david@redhat.com, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-support-wp-on-multiple-vmas.patch added to mm-unstable branch
Message-Id: <20230223215027.1112AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/userfaultfd: support WP on multiple VMAs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-support-wp-on-multiple-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-support-wp-on-multiple-vmas.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: mm/userfaultfd: support WP on multiple VMAs
Date: Fri, 17 Feb 2023 15:55:58 +0500

mwriteprotect_range() errors out if [start, end) doesn't fall in one VMA. 
We are facing a use case where multiple VMAs are present in one range of
interest.  For example, the following pseudocode reproduces the error
which we are trying to fix:

- Allocate memory of size 16 pages with PROT_NONE with mmap
- Register userfaultfd
- Change protection of the first half (1 to 8 pages) of memory to
  PROT_READ | PROT_WRITE. This breaks the memory area in two VMAs.
- Now UFFDIO_WRITEPROTECT_MODE_WP on the whole memory of 16 pages errors
  out.

This is a simple use case where user may or may not know if the memory
area has been divided into multiple VMAs.

We need an implementation which doesn't disrupt the already present users.
So keeping things simple, stop going over all the VMAs if any one of the
VMA hasn't been registered in WP mode.  While at it, remove the un-needed
error check as well.

Link: https://lkml.kernel.org/r/20230217105558.832710-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reported-by: Paul Gofman <pgofman@codeweavers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   47 +++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-support-wp-on-multiple-vmas
+++ a/mm/userfaultfd.c
@@ -717,6 +717,8 @@ long uffd_wp_range(struct mm_struct *dst
 	struct mmu_gather tlb;
 	long ret;
 
+	VM_WARN_ON_ONCE(start < dst_vma->vm_start || start + len > dst_vma->vm_end,
+			"The address range exceeds VMA boundary.\n");
 	if (enable_wp)
 		mm_cp_flags = MM_CP_UFFD_WP;
 	else
@@ -741,9 +743,12 @@ int mwriteprotect_range(struct mm_struct
 			unsigned long len, bool enable_wp,
 			atomic_t *mmap_changing)
 {
+	unsigned long end = start + len;
+	unsigned long _start, _end;
 	struct vm_area_struct *dst_vma;
 	unsigned long page_mask;
 	long err;
+	VMA_ITERATOR(vmi, dst_mm, start);
 
 	/*
 	 * Sanitize the command parameters:
@@ -766,28 +771,30 @@ int mwriteprotect_range(struct mm_struct
 		goto out_unlock;
 
 	err = -ENOENT;
-	dst_vma = find_dst_vma(dst_mm, start, len);
+	for_each_vma_range(vmi, dst_vma, end) {
 
-	if (!dst_vma)
-		goto out_unlock;
-	if (!userfaultfd_wp(dst_vma))
-		goto out_unlock;
-	if (!vma_can_userfault(dst_vma, dst_vma->vm_flags))
-		goto out_unlock;
-
-	if (is_vm_hugetlb_page(dst_vma)) {
-		err = -EINVAL;
-		page_mask = vma_kernel_pagesize(dst_vma) - 1;
-		if ((start & page_mask) || (len & page_mask))
-			goto out_unlock;
-	}
-
-	err = uffd_wp_range(dst_mm, dst_vma, start, len, enable_wp);
-
-	/* Return 0 on success, <0 on failures */
-	if (err > 0)
+		if (!userfaultfd_wp(dst_vma)) {
+			err = -ENOENT;
+			break;
+		}
+
+		if (is_vm_hugetlb_page(dst_vma)) {
+			err = -EINVAL;
+			page_mask = vma_kernel_pagesize(dst_vma) - 1;
+			if ((start & page_mask) || (len & page_mask))
+				break;
+		}
+
+		_start = max(dst_vma->vm_start, start);
+		_end = min(dst_vma->vm_end, end);
+
+		err = uffd_wp_range(dst_mm, dst_vma, _start, _end - _start, enable_wp);
+
+		/* Return 0 on success, <0 on failures */
+		if (err < 0)
+			break;
 		err = 0;
-
+	}
 out_unlock:
 	mmap_read_unlock(dst_mm);
 	return err;
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

mm-userfaultfd-support-wp-on-multiple-vmas.patch

