Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918FCC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbjDFDEW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbjDFDEF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982D99769
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 346D064125
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89907C433D2;
        Thu,  6 Apr 2023 03:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750227;
        bh=nDd8ai+OaQhd4tHw/PAA8BSoTQGzzNy/llDW6Ut0wiw=;
        h=Date:To:From:Subject:From;
        b=K+wEQldjfB1cgN1UNlcdmK0DYDXVrNVU3rmJqvG8ibtoGXe0q/82H/6k9Qo68vtP0
         NaW+wakDNIjsq4sZQwsdfaLnBJIpojdzuMGIhAetYsYQnbBolrXQ5VSpjFMwgwXKYl
         g24HLTNXKvkJKLcDps5zo+K9cNnyiL1zbx7b5EAw=
Date:   Wed, 05 Apr 2023 20:03:46 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-vma-detached-flag.patch removed from -mm tree
Message-Id: <20230406030347.89907C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: introduce vma detached flag
has been removed from the -mm tree.  Its filename was
     mm-introduce-vma-detached-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: introduce vma detached flag
Date: Mon, 27 Feb 2023 09:36:21 -0800

Per-vma locking mechanism will search for VMA under RCU protection and
then after locking it, has to ensure it was not removed from the VMA tree
after we found it.  To make this check efficient, introduce a
vma->detached flag to mark VMAs which were removed from the VMA tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-23-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   11 +++++++++++
 include/linux/mm_types.h |    3 +++
 mm/mmap.c                |    2 ++
 3 files changed, 16 insertions(+)

--- a/include/linux/mm.h~mm-introduce-vma-detached-flag
+++ a/include/linux/mm.h
@@ -711,6 +711,14 @@ static inline void vma_assert_write_lock
 	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
 
+static inline void vma_mark_detached(struct vm_area_struct *vma, bool detached)
+{
+	/* When detaching vma should be write-locked */
+	if (detached)
+		vma_assert_write_locked(vma);
+	vma->detached = detached;
+}
+
 #else /* CONFIG_PER_VMA_LOCK */
 
 static inline void vma_init_lock(struct vm_area_struct *vma) {}
@@ -721,6 +729,8 @@ static inline void vma_start_write(struc
 static inline bool vma_try_start_write(struct vm_area_struct *vma)
 		{ return true; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma) {}
+static inline void vma_mark_detached(struct vm_area_struct *vma,
+				     bool detached) {}
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
@@ -732,6 +742,7 @@ static inline void vma_init(struct vm_ar
 	vma->vm_mm = mm;
 	vma->vm_ops = &dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
+	vma_mark_detached(vma, false);
 	vma_init_lock(vma);
 }
 
--- a/include/linux/mm_types.h~mm-introduce-vma-detached-flag
+++ a/include/linux/mm_types.h
@@ -506,6 +506,9 @@ struct vm_area_struct {
 #ifdef CONFIG_PER_VMA_LOCK
 	int vm_lock_seq;
 	struct rw_semaphore lock;
+
+	/* Flag to indicate areas detached from the mm->mm_mt tree */
+	bool detached;
 #endif
 
 	/*
--- a/mm/mmap.c~mm-introduce-vma-detached-flag
+++ a/mm/mmap.c
@@ -599,6 +599,7 @@ static inline void vma_complete(struct v
 
 	if (vp->remove) {
 again:
+		vma_mark_detached(vp->remove, true);
 		if (vp->file) {
 			uprobe_munmap(vp->remove, vp->remove->vm_start,
 				      vp->remove->vm_end);
@@ -2276,6 +2277,7 @@ static inline int munmap_sidetree(struct
 	if (mas_store_gfp(mas_detach, vma, GFP_KERNEL))
 		return -ENOMEM;
 
+	vma_mark_detached(vma, true);
 	if (vma->vm_flags & VM_LOCKED)
 		vma->vm_mm->locked_vm -= vma_pages(vma);
 
_

Patches currently in -mm which might be from surenb@google.com are


