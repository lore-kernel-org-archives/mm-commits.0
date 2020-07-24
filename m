Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3381FC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 03:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C4EF207FC
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 03:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595559695;
	bh=Tyo6xKt+JBhuwxl6OxSpTJl0B7x2Rw6GMZTQ4uzx5Og=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lmsFn0XEWkpcsIcvz9D7AZtYRGLbsObca5OwLxpLDzRNzbWebzka835D63iog5Lo0
	 ZZLhCR77EE/VY/4HKrQHJK2tBReRVgJyrabH5spUKDLh0+WJn4p1VubqZKzAvmF/JE
	 E22otGCb3XfRrE3ukHK3SXnLek/OkpnnabpX/YZs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgGXDBe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 23:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXDBe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 23:01:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97E9420737;
        Fri, 24 Jul 2020 03:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595559693;
        bh=Tyo6xKt+JBhuwxl6OxSpTJl0B7x2Rw6GMZTQ4uzx5Og=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=htFriFRXmq0/j0BpQrCXex7GGCjWwcXOS3W9e3Q9NqShrfh3zJzT62PAJ6tL9qWMo
         TFAm9QrChpQst6qdvjbnmhcAqzwIujWhgHJTcb6gdycZOr6lnPDFYRJMJa+qXtxm/u
         05sj9gr1TT9DbFuKDKewRVnw0vZ6nGUL6AyInLrc=
Date:   Thu, 23 Jul 2020 20:01:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        louhongxiang@huawei.com, mm-commits@vger.kernel.org
Subject:  + mm-mmap-merge-vma-after-call_mmap-if-possible.patch
 added to -mm tree
Message-ID: <20200724030133.LsRHiqvP5%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmap: merge vma after call_mmap() if possible
has been added to the -mm tree.  Its filename is
     mm-mmap-merge-vma-after-call_mmap-if-possible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-merge-vma-after-call_mmap-if-possible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-merge-vma-after-call_mmap-if-possible.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mmap-merge-vma-after-call_mmap-if-possible.patch

