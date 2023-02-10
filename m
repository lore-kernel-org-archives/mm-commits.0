Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C77EC61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjBJAzM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjBJAyU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084B9721DC
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A62F7B82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5467EC433D2;
        Fri, 10 Feb 2023 00:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990407;
        bh=syLZq2Zuks+CjJHg5iyX3R2YIBShQmu7cCevYL3DkB8=;
        h=Date:To:From:Subject:From;
        b=wrcHHGwgaMsinvzksrRzkz881yiCLi5dGcdlVAYaRnKbg72deGVB6VcjSMKiplHA3
         QqGdXaVIYo3iaM4ORDWGwKmYNMMr4wkgd5I0gVvLbfTPuvpSIOXjSQU3UEiP3yTJ9i
         W16sFmhFfLq/iwX4aW1Y8e/zjgb8FG43iJeZbPeU=
Date:   Thu, 09 Feb 2023 16:53:26 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-convert-vma_adjust-to-vma_expand.patch removed from -mm tree
Message-Id: <20230210005327.5467EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mremap: convert vma_adjust() to vma_expand()
has been removed from the -mm tree.  Its filename was
     mm-mremap-convert-vma_adjust-to-vma_expand.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 include/linux/mm.h |    3 +++
 mm/mmap.c          |    6 +++---
 mm/mremap.c        |    4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

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
@@ -634,9 +634,9 @@ again:
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
@@ -1053,8 +1053,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
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


