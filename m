Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBA5C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiI0CyC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiI0Cvn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:51:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2368F25F1
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96FA7B8190D
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53031C4347C;
        Tue, 27 Sep 2022 02:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246970;
        bh=6l8l/FnprBHS9L6O+/axzNvlu7yNedQio9m1FojJ6cU=;
        h=Date:To:From:Subject:From;
        b=yIGv6eZnsr0nmCb9jIFU+76adOTHiuTlNnhFSMT8/7VTKTgp9edUqZX0TtS5fMyC+
         H+WmMXEdBKtYvWIZbrQyOxPqWr4VWPRUbG/uq7yTmPJ6ud5i3SXXYv+d2T6t4l6fld
         96Pnk00lEPc1aQdmehKs0UErMg/215htMhzMC7Ns=
Date:   Mon, 26 Sep 2022 19:49:29 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch removed from -mm tree
Message-Id: <20220927024930.53031C4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: userfaultfd: use maple tree iterator to iterate VMAs
has been removed from the -mm tree.  Its filename was
     userfaultfd-use-maple-tree-iterator-to-iterate-vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: userfaultfd: use maple tree iterator to iterate VMAs
Date: Tue, 6 Sep 2022 19:48:57 +0000

Don't use the mm_struct linked list or the vma->vm_next in prep for
removal.

Link: https://lkml.kernel.org/r/20220906194824.2110408-45-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   62 +++++++++++++++++++++-----------
 include/linux/userfaultfd_k.h |    7 +--
 mm/mmap.c                     |    2 -
 3 files changed, 46 insertions(+), 25 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-use-maple-tree-iterator-to-iterate-vmas
+++ a/fs/userfaultfd.c
@@ -611,14 +611,16 @@ static void userfaultfd_event_wait_compl
 	if (release_new_ctx) {
 		struct vm_area_struct *vma;
 		struct mm_struct *mm = release_new_ctx->mm;
+		VMA_ITERATOR(vmi, mm, 0);
 
 		/* the various vma->vm_userfaultfd_ctx still points to it */
 		mmap_write_lock(mm);
-		for (vma = mm->mmap; vma; vma = vma->vm_next)
+		for_each_vma(vmi, vma) {
 			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx) {
 				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 				vma->vm_flags &= ~__VM_UFFD_FLAGS;
 			}
+		}
 		mmap_write_unlock(mm);
 
 		userfaultfd_ctx_put(release_new_ctx);
@@ -799,11 +801,13 @@ static bool has_unmap_ctx(struct userfau
 	return false;
 }
 
-int userfaultfd_unmap_prep(struct vm_area_struct *vma,
-			   unsigned long start, unsigned long end,
-			   struct list_head *unmaps)
+int userfaultfd_unmap_prep(struct mm_struct *mm, unsigned long start,
+			   unsigned long end, struct list_head *unmaps)
 {
-	for ( ; vma && vma->vm_start < end; vma = vma->vm_next) {
+	VMA_ITERATOR(vmi, mm, start);
+	struct vm_area_struct *vma;
+
+	for_each_vma_range(vmi, vma, end) {
 		struct userfaultfd_unmap_ctx *unmap_ctx;
 		struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
 
@@ -853,6 +857,7 @@ static int userfaultfd_release(struct in
 	/* len == 0 means wake all */
 	struct userfaultfd_wake_range range = { .len = 0, };
 	unsigned long new_flags;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	WRITE_ONCE(ctx->released, true);
 
@@ -869,7 +874,7 @@ static int userfaultfd_release(struct in
 	 */
 	mmap_write_lock(mm);
 	prev = NULL;
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+	mas_for_each(&mas, vma, ULONG_MAX) {
 		cond_resched();
 		BUG_ON(!!vma->vm_userfaultfd_ctx.ctx ^
 		       !!(vma->vm_flags & __VM_UFFD_FLAGS));
@@ -883,10 +888,13 @@ static int userfaultfd_release(struct in
 				 vma->vm_file, vma->vm_pgoff,
 				 vma_policy(vma),
 				 NULL_VM_UFFD_CTX, anon_vma_name(vma));
-		if (prev)
+		if (prev) {
+			mas_pause(&mas);
 			vma = prev;
-		else
+		} else {
 			prev = vma;
+		}
+
 		vma->vm_flags = new_flags;
 		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
 	}
@@ -1268,6 +1276,7 @@ static int userfaultfd_register(struct u
 	bool found;
 	bool basic_ioctls;
 	unsigned long start, end, vma_end;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	user_uffdio_register = (struct uffdio_register __user *) arg;
 
@@ -1310,7 +1319,8 @@ static int userfaultfd_register(struct u
 		goto out;
 
 	mmap_write_lock(mm);
-	vma = find_vma_prev(mm, start, &prev);
+	mas_set(&mas, start);
+	vma = mas_find(&mas, ULONG_MAX);
 	if (!vma)
 		goto out_unlock;
 
@@ -1335,7 +1345,7 @@ static int userfaultfd_register(struct u
 	 */
 	found = false;
 	basic_ioctls = false;
-	for (cur = vma; cur && cur->vm_start < end; cur = cur->vm_next) {
+	for (cur = vma; cur; cur = mas_next(&mas, end - 1)) {
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
@@ -1395,8 +1405,10 @@ static int userfaultfd_register(struct u
 	}
 	BUG_ON(!found);
 
-	if (vma->vm_start < start)
-		prev = vma;
+	mas_set(&mas, start);
+	prev = mas_prev(&mas, 0);
+	if (prev != vma)
+		mas_next(&mas, ULONG_MAX);
 
 	ret = 0;
 	do {
@@ -1426,6 +1438,8 @@ static int userfaultfd_register(struct u
 				 ((struct vm_userfaultfd_ctx){ ctx }),
 				 anon_vma_name(vma));
 		if (prev) {
+			/* vma_merge() invalidated the mas */
+			mas_pause(&mas);
 			vma = prev;
 			goto next;
 		}
@@ -1433,11 +1447,15 @@ static int userfaultfd_register(struct u
 			ret = split_vma(mm, vma, start, 1);
 			if (ret)
 				break;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
 		if (vma->vm_end > end) {
 			ret = split_vma(mm, vma, end, 0);
 			if (ret)
 				break;
+			/* split_vma() invalidated the mas */
+			mas_pause(&mas);
 		}
 	next:
 		/*
@@ -1454,8 +1472,8 @@ static int userfaultfd_register(struct u
 	skip:
 		prev = vma;
 		start = vma->vm_end;
-		vma = vma->vm_next;
-	} while (vma && vma->vm_start < end);
+		vma = mas_next(&mas, end - 1);
+	} while (vma);
 out_unlock:
 	mmap_write_unlock(mm);
 	mmput(mm);
@@ -1499,6 +1517,7 @@ static int userfaultfd_unregister(struct
 	bool found;
 	unsigned long start, end, vma_end;
 	const void __user *buf = (void __user *)arg;
+	MA_STATE(mas, &mm->mm_mt, 0, 0);
 
 	ret = -EFAULT;
 	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
@@ -1517,7 +1536,8 @@ static int userfaultfd_unregister(struct
 		goto out;
 
 	mmap_write_lock(mm);
-	vma = find_vma_prev(mm, start, &prev);
+	mas_set(&mas, start);
+	vma = mas_find(&mas, ULONG_MAX);
 	if (!vma)
 		goto out_unlock;
 
@@ -1542,7 +1562,7 @@ static int userfaultfd_unregister(struct
 	 */
 	found = false;
 	ret = -EINVAL;
-	for (cur = vma; cur && cur->vm_start < end; cur = cur->vm_next) {
+	for (cur = vma; cur; cur = mas_next(&mas, end - 1)) {
 		cond_resched();
 
 		BUG_ON(!!cur->vm_userfaultfd_ctx.ctx ^
@@ -1562,8 +1582,10 @@ static int userfaultfd_unregister(struct
 	}
 	BUG_ON(!found);
 
-	if (vma->vm_start < start)
-		prev = vma;
+	mas_set(&mas, start);
+	prev = mas_prev(&mas, 0);
+	if (prev != vma)
+		mas_next(&mas, ULONG_MAX);
 
 	ret = 0;
 	do {
@@ -1632,8 +1654,8 @@ static int userfaultfd_unregister(struct
 	skip:
 		prev = vma;
 		start = vma->vm_end;
-		vma = vma->vm_next;
-	} while (vma && vma->vm_start < end);
+		vma = mas_next(&mas, end - 1);
+	} while (vma);
 out_unlock:
 	mmap_write_unlock(mm);
 	mmput(mm);
--- a/include/linux/userfaultfd_k.h~userfaultfd-use-maple-tree-iterator-to-iterate-vmas
+++ a/include/linux/userfaultfd_k.h
@@ -175,9 +175,8 @@ extern bool userfaultfd_remove(struct vm
 			       unsigned long start,
 			       unsigned long end);
 
-extern int userfaultfd_unmap_prep(struct vm_area_struct *vma,
-				  unsigned long start, unsigned long end,
-				  struct list_head *uf);
+extern int userfaultfd_unmap_prep(struct mm_struct *mm, unsigned long start,
+				  unsigned long end, struct list_head *uf);
 extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 
@@ -258,7 +257,7 @@ static inline bool userfaultfd_remove(st
 	return true;
 }
 
-static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
+static inline int userfaultfd_unmap_prep(struct mm_struct *mm,
 					 unsigned long start, unsigned long end,
 					 struct list_head *uf)
 {
--- a/mm/mmap.c~userfaultfd-use-maple-tree-iterator-to-iterate-vmas
+++ a/mm/mmap.c
@@ -2545,7 +2545,7 @@ do_mas_align_munmap(struct ma_state *mas
 		 * split, despite we could. This is unlikely enough
 		 * failure that it's not worth optimizing it for.
 		 */
-		error = userfaultfd_unmap_prep(vma, start, end, uf);
+		error = userfaultfd_unmap_prep(mm, start, end, uf);
 
 		if (error)
 			goto userfaultfd_error;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


