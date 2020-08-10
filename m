Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37428C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 065C12075D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027109;
	bh=jY13Tyyma85mosH9FtEACJUmmvFKaeqCOuW9OciT/Lc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uFSGtsS5q60cIUVpaoCGKSYkOEvTOkS3Is1H7B6BDVXKa0DvLRY4eS3brqblQMHeN
	 en7mr4cLaofeRtVYW90Wpj+95YUcPtZU+05NqbpxpMYvJ16b4z0ouVXcb9YVVHCoAp
	 XSWSdD1U46lXHCUIxNPHDSuJvitZYOlD7LB3xw5g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHJCi2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCi2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A21962065D;
        Mon, 10 Aug 2020 02:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027107;
        bh=jY13Tyyma85mosH9FtEACJUmmvFKaeqCOuW9OciT/Lc=;
        h=Date:From:To:Subject:From;
        b=gKQxIN+kx847+Yv5vuCVF3Mt0UxRfyC2PM/7kgLy4JOSNPb+gVUJ7VyRkZDge0h3o
         zyl50ruHQz6/IRjZeubaXmcn1v6Qj+cI7lGmT0mdhFd4E5eIbaAQrUYX1Yve6Xs+47
         okT7IxyyzeFtVsa4HrDfhp2I1vpuCR9eVwAsNBF0=
Date:   Sun, 09 Aug 2020 19:38:27 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        louhongxiang@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-mmap-merge-vma-after-call_mmap-if-possible.patch removed from -mm tree
Message-ID: <20200810023827.XqfZnqZFU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: merge vma after call_mmap() if possible
has been removed from the -mm tree.  Its filename was
     mm-mmap-merge-vma-after-call_mmap-if-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: mmap: merge vma after call_mmap() if possible

The vm_flags may be changed after call_mmap() because drivers may set some
flags for their own purpose.  As a result, we failed to merge the adjacent
vma due to the different vm_flags as userspace can't pass in the same one.
Try to merge vma after call_mmap() to fix this issue.

Link: http://lkml.kernel.org/r/1594954065-23733-1-git-send-email-linmiaohe@huawei.com
Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-merge-vma-after-call_mmap-if-possible
+++ a/mm/mmap.c
@@ -1690,7 +1690,7 @@ unsigned long mmap_region(struct file *f
 		struct list_head *uf)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *prev;
+	struct vm_area_struct *vma, *prev, *merge;
 	int error;
 	struct rb_node **rb_link, *rb_parent;
 	unsigned long charged = 0;
@@ -1774,6 +1774,25 @@ unsigned long mmap_region(struct file *f
 		if (error)
 			goto unmap_and_free_vma;
 
+		/* If vm_flags changed after call_mmap(), we should try merge vma again
+		 * as we may succeed this time.
+		 */
+		if (unlikely(vm_flags != vma->vm_flags && prev)) {
+			merge = vma_merge(mm, prev, vma->vm_start, vma->vm_end, vma->vm_flags,
+				NULL, vma->vm_file, vma->vm_pgoff, NULL, NULL_VM_UFFD_CTX);
+			if (merge) {
+				fput(file);
+				vm_area_free(vma);
+				vma = merge;
+				/* Update vm_flags and possible addr to pick up the change. We don't
+				 * warn here if addr changed as the vma is not linked by vma_link().
+				 */
+				addr = vma->vm_start;
+				vm_flags = vma->vm_flags;
+				goto unmap_writable;
+			}
+		}
+
 		/* Can addr have changed??
 		 *
 		 * Answer: Yes, several device drivers can do it in their
@@ -1796,6 +1815,7 @@ unsigned long mmap_region(struct file *f
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
 	if (file) {
+unmap_writable:
 		if (vm_flags & VM_SHARED)
 			mapping_unmap_writable(file->f_mapping);
 		if (vm_flags & VM_DENYWRITE)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


