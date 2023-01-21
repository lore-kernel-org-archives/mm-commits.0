Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9CCC05027
	for <mm-commits@archiver.kernel.org>; Sat, 21 Jan 2023 01:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjAUBHr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjAUBHZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 20:07:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAB073EF9
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2023 17:07:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 358CC60C98
        for <mm-commits@vger.kernel.org>; Sat, 21 Jan 2023 01:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1FDC433EF;
        Sat, 21 Jan 2023 01:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674263242;
        bh=Z8Zi+mtw8vIoY4+tWNAcyD2+Q5VTqpdAX6eZedN5lJg=;
        h=Date:To:From:Subject:From;
        b=NPVO4v+ozbD4rGzteqcz4EEOi+uH5A9YSazeszNXOiVUkKCHK0wRveI+frdQd3pPZ
         ycsSXEu+W1EhDQSBLUGxBnz+e1L0ZEQ9EvsVJ6hh1FN+keLK6TNCXl0FDaTfvu8QrW
         q0HygQKvV7sHDGuz3MC+Pgq6JgHGuIJiV/I/MmFA=
Date:   Fri, 20 Jan 2023 17:07:21 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-convert-vma_adjust-to-vma_expand.patch added to mm-unstable branch
Message-Id: <20230121010722.8C1FDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: convert vma_adjust() to vma_expand()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-convert-vma_adjust-to-vma_expand.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-convert-vma_adjust-to-vma_expand.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mremap: convert vma_adjust() to vma_expand()
Date: Fri, 20 Jan 2023 11:26:45 -0500

Stop using vma_adjust() in preparation for removing the function.  Export
vma_expand() to use instead.

Link: https://lkml.kernel.org/r/20230120162650.984577-45-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-mremap-convert-vma_adjust-to-vma_expand
+++ a/include/linux/mm.h
@@ -2839,6 +2839,9 @@ static inline int vma_adjust(struct vma_
 {
 	return __vma_adjust(vmi, vma, start, end, pgoff, NULL);
 }
+extern int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
+		      unsigned long start, unsigned long end, pgoff_t pgoff,
+		      struct vm_area_struct *next);
 extern struct vm_area_struct *vma_merge(struct vma_iterator *vmi,
 	struct mm_struct *, struct vm_area_struct *prev, unsigned long addr,
 	unsigned long end, unsigned long vm_flags, struct anon_vma *,
--- a/mm/mmap.c~mm-mremap-convert-vma_adjust-to-vma_expand
+++ a/mm/mmap.c
@@ -637,9 +637,9 @@ again:
  *
  * Returns: 0 on success
  */
-inline int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		      unsigned long start, unsigned long end, pgoff_t pgoff,
-		      struct vm_area_struct *next)
+int vma_expand(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	       unsigned long start, unsigned long end, pgoff_t pgoff,
+	       struct vm_area_struct *next)
 {
 	bool remove_next = false;
 	struct vma_prepare vp;
--- a/mm/mremap.c~mm-mremap-convert-vma_adjust-to-vma_expand
+++ a/mm/mremap.c
@@ -1052,8 +1052,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 					extension_end, vma->vm_flags, vma->anon_vma,
 					vma->vm_file, extension_pgoff, vma_policy(vma),
 					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
-			} else if (vma_adjust(&vmi, vma, vma->vm_start,
-					addr + new_len, vma->vm_pgoff)) {
+			} else if (vma_expand(&vmi, vma, vma->vm_start,
+					addr + new_len, vma->vm_pgoff, NULL)) {
 				vma = NULL;
 			}
 			if (!vma) {
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-handle-of-invalidated-state-in-mas_wr_store_setup.patch
maple_tree-fix-mas_prev-and-mas_find-state-handling.patch
nommu-pass-through-vma-iterator-to-shrink_vma.patch
mm-damon-vaddr-testh-stop-using-vma_mas_store-for-maple-tree-store.patch
mm-mremap-convert-vma_adjust-to-vma_expand.patch

