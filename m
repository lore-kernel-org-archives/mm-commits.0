Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C53DC001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbjHKXFg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236859AbjHKXD4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545C2448A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEB436464E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4557FC433CA;
        Fri, 11 Aug 2023 23:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794919;
        bh=yP3JJGN3v0rToEbaDwZ5AV4XKiVY+XWCb84b1TpqFSw=;
        h=Date:To:From:Subject:From;
        b=Ij5TroqySlZte3uVFNL27eohEte8wTpyuYxYE/V9gv+rC9JjyMZIe/HaFqsb99Vdb
         dRVABfkonBtTKPrSBNUlDGgnGOQTi6rMcKmHSHOoO7T6vWg8Jl4ubG9Jsq4rryDY5B
         qw3B+1veO/0f+B7EBk68pYMCRR6QPDK45x5JMCVo=
Date:   Fri, 11 Aug 2023 16:01:58 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-clean-up-validate_mm-calls.patch removed from -mm tree
Message-Id: <20230811230159.4557FC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: clean up validate_mm() calls
has been removed from the -mm tree.  Its filename was
     mm-mmap-clean-up-validate_mm-calls.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: clean up validate_mm() calls
Date: Fri, 14 Jul 2023 15:55:48 -0400

Patch series "More strict maple tree lockdep", v2.

Linus asked for more strict maple tree lockdep checking [1] and for them
to resume the normal path through Andrews tree.

This series of patches adds checks to ensure the lock is held in write
mode during the write path of the maple tree instead of checking if it's
held at all.

It also reduces the validate_mm() calls by consolidating into commonly
used functions (patch 0001), and removes the necessity of holding the lock
on the detached tree during munmap() operations.


This patch (of 4):

validate_mm() calls are too spread out and duplicated in numerous
locations.  Also, now that the stack write is done under the write lock,
it is not necessary to validate the mm prior to write operations.

Add a validate_mm() to the stack expansions, and to vma_complete() so
that numerous others may be dropped.

Note that vma_link() (and also insert_vm_struct() by call path) already
call validate_mm().

vma_merge() also had an unnecessary call to vma_iter_free() since the
logic change to abort earlier if no merging is necessary.

Drop extra validate_mm() calls at the start of functions and error paths
which won't write to the tree.

Relocate the validate_mm() call in the do_brk_flags() to avoid
re-running the same test when vma_complete() is used.

The call within the error path of mmap_region() is left intentionally
because of the complexity of the function and the potential of drivers
modifying the tree.

Link: https://lkml.kernel.org/r/20230714195551.894800-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230714195551.894800-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Sang <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

--- a/mm/mmap.c~mm-mmap-clean-up-validate_mm-calls
+++ a/mm/mmap.c
@@ -594,6 +594,7 @@ again:
 	}
 	if (vp->insert && vp->file)
 		uprobe_mmap(vp->insert);
+	validate_mm(mm);
 }
 
 /*
@@ -676,7 +677,6 @@ int vma_expand(struct vma_iterator *vmi,
 	vma_iter_store(vmi, vma);
 
 	vma_complete(&vp, vmi, vma->vm_mm);
-	validate_mm(vma->vm_mm);
 	return 0;
 
 nomem:
@@ -716,7 +716,6 @@ int vma_shrink(struct vma_iterator *vmi,
 	vma->vm_end = end;
 	vma->vm_pgoff = pgoff;
 	vma_complete(&vp, vmi, vma->vm_mm);
-	validate_mm(vma->vm_mm);
 	return 0;
 }
 
@@ -889,7 +888,6 @@ struct vm_area_struct *vma_merge(struct
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	long adj_start = 0;
 
-	validate_mm(mm);
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
 	 * so this tests vma->vm_flags & VM_SPECIAL, too.
@@ -1016,10 +1014,7 @@ struct vm_area_struct *vma_merge(struct
 	}
 
 	vma_complete(&vp, vmi, mm);
-	vma_iter_free(vmi);
-	validate_mm(mm);
 	khugepaged_enter_vma(res, vm_flags);
-
 	return res;
 }
 
@@ -1194,7 +1189,6 @@ unsigned long do_mmap(struct file *file,
 	vm_flags_t vm_flags;
 	int pkey = 0;
 
-	validate_mm(mm);
 	*populate = 0;
 
 	if (!len)
@@ -2023,6 +2017,7 @@ static int expand_upwards(struct vm_area
 	anon_vma_unlock_write(vma->anon_vma);
 	khugepaged_enter_vma(vma, vma->vm_flags);
 	mas_destroy(&mas);
+	validate_mm(mm);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -2113,6 +2108,7 @@ int expand_downwards(struct vm_area_stru
 	anon_vma_unlock_write(vma->anon_vma);
 	khugepaged_enter_vma(vma, vma->vm_flags);
 	mas_destroy(&mas);
+	validate_mm(mm);
 	return error;
 }
 
@@ -2290,7 +2286,6 @@ static inline void remove_mt(struct mm_s
 		remove_vma(vma, false);
 	}
 	vm_unacct_memory(nr_accounted);
-	validate_mm(mm);
 }
 
 /*
@@ -2327,8 +2322,6 @@ int __split_vma(struct vma_iterator *vmi
 	struct vm_area_struct *new;
 	int err;
 
-	validate_mm(vma->vm_mm);
-
 	WARN_ON(vma->vm_start >= addr);
 	WARN_ON(vma->vm_end <= addr);
 
@@ -2385,7 +2378,6 @@ int __split_vma(struct vma_iterator *vmi
 	/* Success. */
 	if (new_below)
 		vma_next(vmi);
-	validate_mm(vma->vm_mm);
 	return 0;
 
 out_free_mpol:
@@ -2394,7 +2386,6 @@ out_free_vmi:
 	vma_iter_free(vmi);
 out_free_vma:
 	vm_area_free(new);
-	validate_mm(vma->vm_mm);
 	return err;
 }
 
@@ -3045,7 +3036,6 @@ static int do_brk_flags(struct vma_itera
 	struct mm_struct *mm = current->mm;
 	struct vma_prepare vp;
 
-	validate_mm(mm);
 	/*
 	 * Check against address space limits by the changed size
 	 * Note: This happens *after* clearing old mappings in some code paths.
@@ -3097,6 +3087,7 @@ static int do_brk_flags(struct vma_itera
 		goto mas_store_fail;
 
 	mm->map_count++;
+	validate_mm(mm);
 	ksm_add_vma(vma);
 out:
 	perf_event_mmap(vma);
@@ -3105,7 +3096,6 @@ out:
 	if (flags & VM_LOCKED)
 		mm->locked_vm += (len >> PAGE_SHIFT);
 	vm_flags_set(vma, VM_SOFTDIRTY);
-	validate_mm(mm);
 	return 0;
 
 mas_store_fail:
@@ -3286,7 +3276,6 @@ struct vm_area_struct *copy_vma(struct v
 	bool faulted_in_anon_vma = true;
 	VMA_ITERATOR(vmi, mm, addr);
 
-	validate_mm(mm);
 	/*
 	 * If anonymous vma has not yet been faulted, update new pgoff
 	 * to match new location, to increase its chance of merging.
@@ -3345,7 +3334,6 @@ struct vm_area_struct *copy_vma(struct v
 			goto out_vma_link;
 		*need_rmap_locks = false;
 	}
-	validate_mm(mm);
 	return new_vma;
 
 out_vma_link:
@@ -3361,7 +3349,6 @@ out_free_mempol:
 out_free_vma:
 	vm_area_free(new_vma);
 out:
-	validate_mm(mm);
 	return NULL;
 }
 
@@ -3498,7 +3485,6 @@ static struct vm_area_struct *__install_
 	int ret;
 	struct vm_area_struct *vma;
 
-	validate_mm(mm);
 	vma = vm_area_alloc(mm);
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
@@ -3521,12 +3507,10 @@ static struct vm_area_struct *__install_
 
 	perf_event_mmap(vma);
 
-	validate_mm(mm);
 	return vma;
 
 out:
 	vm_area_free(vma);
-	validate_mm(mm);
 	return ERR_PTR(ret);
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-hex-output-to-maple_arange64-dump.patch
maple_tree-reorder-replacement-of-nodes-to-avoid-live-lock.patch
maple_tree-introduce-mas_put_in_tree.patch
maple_tree-introduce-mas_tree_parent-definition.patch
maple_tree-change-mas_adopt_children-parent-usage.patch
maple_tree-replace-data-before-marking-dead-in-split-and-spanning-store.patch

