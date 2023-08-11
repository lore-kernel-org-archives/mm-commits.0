Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E38C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbjHKXNf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237182AbjHKXNF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B5C3AA5
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 112B467942
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6001BC433C8;
        Fri, 11 Aug 2023 23:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794963;
        bh=23vYacBmicb4uXmRL7VBRT3tsHdkN76bDU3M035tRHw=;
        h=Date:To:From:Subject:From;
        b=pG7rt2esLxXg6aSJtrcTpiduIYBuoreb8thlv3qwG79vuOW01fVyUpk9VENfQEvrn
         eAD1FQe4pluAAMElvSCRoKsBFcYXMroWf7VSo6vogsu2L9e8GT98wMESWmn4PdrJVk
         N9iyUI37RgpvdG/pdc0dudzf0+Mw3cUbzz8l3b3o=
Date:   Fri, 11 Aug 2023 16:02:42 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        surenb@google.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-re-walk-from-mmap_region.patch removed from -mm tree
Message-Id: <20230811230243.6001BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove re-walk from mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-remove-re-walk-from-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm: remove re-walk from mmap_region()
Date: Mon, 24 Jul 2023 14:31:48 -0400

Using vma_iter_set() will reset the tree and cause a re-walk.  Use
vmi_iter_config() to set the write to a sub-set of the range.  Change
the file case to also use vmi_iter_config() so that the end is correctly
set.

Link: https://lkml.kernel.org/r/20230724183157.3939892-7-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++++++
 mm/mmap.c     |   15 ++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/mm/internal.h~mm-remove-re-walk-from-mmap_region
+++ a/mm/internal.h
@@ -1041,6 +1041,14 @@ static inline bool vma_soft_dirty_enable
 	return !(vma->vm_flags & VM_SOFTDIRTY);
 }
 
+static inline void vma_iter_config(struct vma_iterator *vmi,
+		unsigned long index, unsigned long last)
+{
+	MAS_BUG_ON(&vmi->mas, vmi->mas.node != MAS_START &&
+		   (vmi->mas.index > index || vmi->mas.last < index));
+	__mas_set_range(&vmi->mas, index, last - 1);
+}
+
 /*
  * VMA Iterator functions shared between nommu and mmap
  */
--- a/mm/mmap.c~mm-remove-re-walk-from-mmap_region
+++ a/mm/mmap.c
@@ -2676,8 +2676,11 @@ unsigned long mmap_region(struct file *f
 
 	next = vma_next(&vmi);
 	prev = vma_prev(&vmi);
-	if (vm_flags & VM_SPECIAL)
+	if (vm_flags & VM_SPECIAL) {
+		if (prev)
+			vma_iter_next_range(&vmi);
 		goto cannot_expand;
+	}
 
 	/* Attempt to expand an old mapping */
 	/* Check next */
@@ -2698,6 +2701,8 @@ unsigned long mmap_region(struct file *f
 		merge_start = prev->vm_start;
 		vma = prev;
 		vm_pgoff = prev->vm_pgoff;
+	} else if (prev) {
+		vma_iter_next_range(&vmi);
 	}
 
 
@@ -2708,9 +2713,9 @@ unsigned long mmap_region(struct file *f
 		goto expanded;
 	}
 
+	if (vma == prev)
+		vma_iter_set(&vmi, addr);
 cannot_expand:
-	if (prev)
-		vma_iter_next_range(&vmi);
 
 	/*
 	 * Determine the object being mapped and call the appropriate
@@ -2723,7 +2728,7 @@ cannot_expand:
 		goto unacct_error;
 	}
 
-	vma_iter_set(&vmi, addr);
+	vma_iter_config(&vmi, addr, end);
 	vma->vm_start = addr;
 	vma->vm_end = end;
 	vm_flags_init(vma, vm_flags);
@@ -2750,7 +2755,7 @@ cannot_expand:
 		if (WARN_ON((addr != vma->vm_start)))
 			goto close_and_free_vma;
 
-		vma_iter_set(&vmi, addr);
+		vma_iter_config(&vmi, addr, end);
 		/*
 		 * If vm_flags changed after call_mmap(), we should try merge
 		 * vma again as we may succeed this time.
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

