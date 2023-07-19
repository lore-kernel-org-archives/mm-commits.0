Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC69AC0015E
	for <mm-commits@archiver.kernel.org>; Wed, 19 Jul 2023 19:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjGSTVW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjGSTVP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2023 15:21:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163F01FE8
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 12:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 928FF617E5
        for <mm-commits@vger.kernel.org>; Wed, 19 Jul 2023 19:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6DBC433C8;
        Wed, 19 Jul 2023 19:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689794473;
        bh=QXu0quViBsFTIGSfiJ94xhukTLAXEDQpiupIa88OyOQ=;
        h=Date:To:From:Subject:From;
        b=E0S3uLRXdKYLXqMlwLqf0qguzLl0JjZ6MJKo175q1oWvbuD1YIMHLxwYLh92zOxfX
         bETsSUUFx1mc1PiDHOE/qxenNc0e3HCjOteAmXA/gfCFxI2Ez7lpvqZOllC6o1Q8kO
         K14NztB3t6gwN3dm5xKtS9J0chBru8I3fyOlNFLo=
Date:   Wed, 19 Jul 2023 12:21:12 -0700
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        oliver.sang@intel.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-clean-up-validate_mm-calls.patch added to mm-unstable branch
Message-Id: <20230719192112.EC6DBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: clean up validate_mm() calls
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-clean-up-validate_mm-calls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-clean-up-validate_mm-calls.patch

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
@@ -675,7 +676,6 @@ int vma_expand(struct vma_iterator *vmi,
 	vma_iter_store(vmi, vma);
 
 	vma_complete(&vp, vmi, vma->vm_mm);
-	validate_mm(vma->vm_mm);
 	return 0;
 
 nomem:
@@ -715,7 +715,6 @@ int vma_shrink(struct vma_iterator *vmi,
 	vma->vm_end = end;
 	vma->vm_pgoff = pgoff;
 	vma_complete(&vp, vmi, vma->vm_mm);
-	validate_mm(vma->vm_mm);
 	return 0;
 }
 
@@ -888,7 +887,6 @@ struct vm_area_struct *vma_merge(struct
 	pgoff_t pglen = (end - addr) >> PAGE_SHIFT;
 	long adj_start = 0;
 
-	validate_mm(mm);
 	/*
 	 * We later require that vma->vm_flags == vm_flags,
 	 * so this tests vma->vm_flags & VM_SPECIAL, too.
@@ -1015,10 +1013,7 @@ struct vm_area_struct *vma_merge(struct
 	}
 
 	vma_complete(&vp, vmi, mm);
-	vma_iter_free(vmi);
-	validate_mm(mm);
 	khugepaged_enter_vma(res, vm_flags);
-
 	return res;
 }
 
@@ -1193,7 +1188,6 @@ unsigned long do_mmap(struct file *file,
 	vm_flags_t vm_flags;
 	int pkey = 0;
 
-	validate_mm(mm);
 	*populate = 0;
 
 	if (!len)
@@ -2022,6 +2016,7 @@ static int expand_upwards(struct vm_area
 	anon_vma_unlock_write(vma->anon_vma);
 	khugepaged_enter_vma(vma, vma->vm_flags);
 	mas_destroy(&mas);
+	validate_mm(mm);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -2112,6 +2107,7 @@ int expand_downwards(struct vm_area_stru
 	anon_vma_unlock_write(vma->anon_vma);
 	khugepaged_enter_vma(vma, vma->vm_flags);
 	mas_destroy(&mas);
+	validate_mm(mm);
 	return error;
 }
 
@@ -2289,7 +2285,6 @@ static inline void remove_mt(struct mm_s
 		remove_vma(vma, false);
 	}
 	vm_unacct_memory(nr_accounted);
-	validate_mm(mm);
 }
 
 /*
@@ -2326,8 +2321,6 @@ int __split_vma(struct vma_iterator *vmi
 	struct vm_area_struct *new;
 	int err;
 
-	validate_mm(vma->vm_mm);
-
 	WARN_ON(vma->vm_start >= addr);
 	WARN_ON(vma->vm_end <= addr);
 
@@ -2384,7 +2377,6 @@ int __split_vma(struct vma_iterator *vmi
 	/* Success. */
 	if (new_below)
 		vma_next(vmi);
-	validate_mm(vma->vm_mm);
 	return 0;
 
 out_free_mpol:
@@ -2393,7 +2385,6 @@ out_free_vmi:
 	vma_iter_free(vmi);
 out_free_vma:
 	vm_area_free(new);
-	validate_mm(vma->vm_mm);
 	return err;
 }
 
@@ -3044,7 +3035,6 @@ static int do_brk_flags(struct vma_itera
 	struct mm_struct *mm = current->mm;
 	struct vma_prepare vp;
 
-	validate_mm(mm);
 	/*
 	 * Check against address space limits by the changed size
 	 * Note: This happens *after* clearing old mappings in some code paths.
@@ -3096,6 +3086,7 @@ static int do_brk_flags(struct vma_itera
 		goto mas_store_fail;
 
 	mm->map_count++;
+	validate_mm(mm);
 	ksm_add_vma(vma);
 out:
 	perf_event_mmap(vma);
@@ -3104,7 +3095,6 @@ out:
 	if (flags & VM_LOCKED)
 		mm->locked_vm += (len >> PAGE_SHIFT);
 	vm_flags_set(vma, VM_SOFTDIRTY);
-	validate_mm(mm);
 	return 0;
 
 mas_store_fail:
@@ -3285,7 +3275,6 @@ struct vm_area_struct *copy_vma(struct v
 	bool faulted_in_anon_vma = true;
 	VMA_ITERATOR(vmi, mm, addr);
 
-	validate_mm(mm);
 	/*
 	 * If anonymous vma has not yet been faulted, update new pgoff
 	 * to match new location, to increase its chance of merging.
@@ -3344,7 +3333,6 @@ struct vm_area_struct *copy_vma(struct v
 			goto out_vma_link;
 		*need_rmap_locks = false;
 	}
-	validate_mm(mm);
 	return new_vma;
 
 out_vma_link:
@@ -3360,7 +3348,6 @@ out_free_mempol:
 out_free_vma:
 	vm_area_free(new_vma);
 out:
-	validate_mm(mm);
 	return NULL;
 }
 
@@ -3497,7 +3484,6 @@ static struct vm_area_struct *__install_
 	int ret;
 	struct vm_area_struct *vma;
 
-	validate_mm(mm);
 	vma = vm_area_alloc(mm);
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
@@ -3520,12 +3506,10 @@ static struct vm_area_struct *__install_
 
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

mm-mmap-clean-up-validate_mm-calls.patch
maple_tree-relax-lockdep-checks-for-on-stack-trees.patch
mm-mmap-change-detached-vma-locking-scheme.patch
maple_tree-be-more-strict-about-locking.patch

