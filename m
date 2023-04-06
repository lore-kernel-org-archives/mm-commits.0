Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A22C77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbjDFDEX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbjDFDEF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF41976E
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A736640CA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1584C433EF;
        Thu,  6 Apr 2023 03:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750228;
        bh=iV6NMwLylrUIYxVYYM9WyLI81DKwWRlDhfh1xDwub8E=;
        h=Date:To:From:Subject:From;
        b=AtMXG0LgQwhpmhIzNS7M12JsAKdRJcBr59t24FG+vYRtovjl1T9YUYMuW1nhp+4pg
         r0Z8qcGCHnB4c2EdUUk6TiKAwJbVFnHNwM6gGJubxn3Xy+ikpDTeI71aDlQDl2fLge
         sVnm8IcyyLvzCx2eKcoPaCzOCJzfyWXlrvBgk/fc=
Date:   Wed, 05 Apr 2023 20:03:48 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch removed from -mm tree
Message-Id: <20230406030348.B1584C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: introduce lock_vma_under_rcu to be used from arch-specific code
has been removed from the -mm tree.  Its filename was
     mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: introduce lock_vma_under_rcu to be used from arch-specific code
Date: Mon, 27 Feb 2023 09:36:22 -0800

Introduce lock_vma_under_rcu function to lookup and lock a VMA during page
fault handling.  When VMA is not found, can't be locked or changes after
being locked, the function returns NULL.  The lookup is performed under
RCU protection to prevent the found VMA from being destroyed before the
VMA lock is acquired.  VMA lock statistics are updated according to the
results.  For now only anonymous VMAs can be searched this way.  In other
cases the function returns NULL.

Link: https://lkml.kernel.org/r/20230227173632.3292573-24-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++
 mm/memory.c        |   46 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

--- a/include/linux/mm.h~mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code
+++ a/include/linux/mm.h
@@ -719,6 +719,9 @@ static inline void vma_mark_detached(str
 	vma->detached = detached;
 }
 
+struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
+					  unsigned long address);
+
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline void vma_init_lock(struct vm_area_struct *vma) {}
--- a/mm/memory.c~mm-introduce-lock_vma_under_rcu-to-be-used-from-arch-specific-code
+++ a/mm/memory.c
@@ -5232,6 +5232,52 @@ vm_fault_t handle_mm_fault(struct vm_are
 }
 EXPORT_SYMBOL_GPL(handle_mm_fault);
 
+#ifdef CONFIG_PER_VMA_LOCK
+/*
+ * Lookup and lock a VMA under RCU protection. Returned VMA is guaranteed to be
+ * stable and not isolated. If the VMA is not found or is being modified the
+ * function returns NULL.
+ */
+struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
+					  unsigned long address)
+{
+	MA_STATE(mas, &mm->mm_mt, address, address);
+	struct vm_area_struct *vma;
+
+	rcu_read_lock();
+retry:
+	vma = mas_walk(&mas);
+	if (!vma)
+		goto inval;
+
+	/* Only anonymous vmas are supported for now */
+	if (!vma_is_anonymous(vma))
+		goto inval;
+
+	if (!vma_start_read(vma))
+		goto inval;
+
+	/* Check since vm_start/vm_end might change before we lock the VMA */
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
+		vma_end_read(vma);
+		goto inval;
+	}
+
+	/* Check if the VMA got isolated after we found it */
+	if (vma->detached) {
+		vma_end_read(vma);
+		/* The area was replaced with another one */
+		goto retry;
+	}
+
+	rcu_read_unlock();
+	return vma;
+inval:
+	rcu_read_unlock();
+	return NULL;
+}
+#endif /* CONFIG_PER_VMA_LOCK */
+
 #ifndef __PAGETABLE_P4D_FOLDED
 /*
  * Allocate p4d page table.
_

Patches currently in -mm which might be from surenb@google.com are


