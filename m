Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F3DC0015E
	for <mm-commits@archiver.kernel.org>; Sat,  5 Aug 2023 16:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjHEQ4V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Aug 2023 12:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjHEQ4R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 5 Aug 2023 12:56:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7875B1BD
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 09:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1664F60C25
        for <mm-commits@vger.kernel.org>; Sat,  5 Aug 2023 16:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F93EC433C7;
        Sat,  5 Aug 2023 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691254575;
        bh=vTmxPUGdNqFD7Ek0BqYQR7cJ0a7llF5GXhqaZZBGA/0=;
        h=Date:To:From:Subject:From;
        b=Eu4NtTMlJByOXyCtsOHFBznOi/Orzlu2uIHObwFdwQgq/Gws5Vpn+aohz57ME/PLQ
         hsCU2SK2hBlcbuCCUhRFoBS9oBWacoH6bYQnJ/699issgnHaaU8MHcUKM1OUb2coVs
         LLV85MsLubwv+yyklkeap+xvWHhh5Yz1AuU/0Bmo=
Date:   Sat, 05 Aug 2023 09:56:14 -0700
To:     mm-commits@vger.kernel.org, torvalds@linuxfoundation.org,
        Liam.Howlett@oracle.com, jannh@google.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-vma-locking-out-of-vma_prepare-and-dup_anon_vma.patch added to mm-unstable branch
Message-Id: <20230805165615.6F93EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move vma locking out of vma_prepare and dup_anon_vma
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-vma-locking-out-of-vma_prepare-and-dup_anon_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-vma-locking-out-of-vma_prepare-and-dup_anon_vma.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: move vma locking out of vma_prepare and dup_anon_vma
Date: Fri, 4 Aug 2023 08:27:24 -0700

vma_prepare() is currently the central place where vmas are being locked
before vma_complete() applies changes to them. While this is convenient,
it also obscures vma locking and makes it harder to follow the locking
rules. Move vma locking out of vma_prepare() and take vma locks
explicitly at the locations where vmas are being modified. Move vma
locking and replace it with an assertion inside dup_anon_vma() to further
clarify the locking pattern inside vma_merge().

Link: https://lkml.kernel.org/r/20230804152724.3090321-7-surenb@google.com
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Suggested-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

--- a/mm/mmap.c~mm-move-vma-locking-out-of-vma_prepare-and-dup_anon_vma
+++ a/mm/mmap.c
@@ -462,16 +462,6 @@ static inline void init_vma_prep(struct
  */
 static inline void vma_prepare(struct vma_prepare *vp)
 {
-	vma_start_write(vp->vma);
-	if (vp->adj_next)
-		vma_start_write(vp->adj_next);
-	if (vp->insert)
-		vma_start_write(vp->insert);
-	if (vp->remove)
-		vma_start_write(vp->remove);
-	if (vp->remove2)
-		vma_start_write(vp->remove2);
-
 	if (vp->file) {
 		uprobe_munmap(vp->vma, vp->vma->vm_start, vp->vma->vm_end);
 
@@ -605,7 +595,7 @@ static inline int dup_anon_vma(struct vm
 	 * anon pages imported.
 	 */
 	if (src->anon_vma && !dst->anon_vma) {
-		vma_start_write(dst);
+		vma_assert_write_locked(dst);
 		dst->anon_vma = src->anon_vma;
 		return anon_vma_clone(dst, src);
 	}
@@ -637,10 +627,12 @@ int vma_expand(struct vma_iterator *vmi,
 	bool remove_next = false;
 	struct vma_prepare vp;
 
+	vma_start_write(vma);
 	if (next && (vma != next) && (end == next->vm_end)) {
 		int ret;
 
 		remove_next = true;
+		vma_start_write(next);
 		ret = dup_anon_vma(vma, next);
 		if (ret)
 			return ret;
@@ -696,6 +688,8 @@ int vma_shrink(struct vma_iterator *vmi,
 	if (vma_iter_prealloc(vmi, NULL))
 		return -ENOMEM;
 
+	vma_start_write(vma);
+
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, start, end, 0);
@@ -921,16 +915,21 @@ struct vm_area_struct *vma_merge(struct
 	if (!merge_prev && !merge_next)
 		return NULL; /* Not mergeable. */
 
+	if (merge_prev)
+		vma_start_write(prev);
+
 	res = vma = prev;
 	remove = remove2 = adjust = NULL;
 
 	/* Can we merge both the predecessor and the successor? */
 	if (merge_prev && merge_next &&
 	    is_mergeable_anon_vma(prev->anon_vma, next->anon_vma, NULL)) {
+		vma_start_write(next);
 		remove = next;				/* case 1 */
 		vma_end = next->vm_end;
 		err = dup_anon_vma(prev, next);
 		if (curr) {				/* case 6 */
+			vma_start_write(curr);
 			remove = curr;
 			remove2 = next;
 			if (!next->anon_vma)
@@ -938,6 +937,7 @@ struct vm_area_struct *vma_merge(struct
 		}
 	} else if (merge_prev) {			/* case 2 */
 		if (curr) {
+			vma_start_write(curr);
 			err = dup_anon_vma(prev, curr);
 			if (end == curr->vm_end) {	/* case 7 */
 				remove = curr;
@@ -947,8 +947,10 @@ struct vm_area_struct *vma_merge(struct
 			}
 		}
 	} else { /* merge_next */
+		vma_start_write(next);
 		res = next;
 		if (prev && addr < prev->vm_end) {	/* case 4 */
+			vma_start_write(prev);
 			vma_end = addr;
 			adjust = next;
 			adj_start = -(prev->vm_end - addr);
@@ -964,6 +966,7 @@ struct vm_area_struct *vma_merge(struct
 			vma_pgoff = next->vm_pgoff - pglen;
 			if (curr) {			/* case 8 */
 				vma_pgoff = curr->vm_pgoff;
+				vma_start_write(curr);
 				remove = curr;
 				err = dup_anon_vma(next, curr);
 			}
@@ -2366,6 +2369,9 @@ int __split_vma(struct vma_iterator *vmi
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
+	vma_start_write(vma);
+	vma_start_write(new);
+
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
@@ -3071,6 +3077,8 @@ static int do_brk_flags(struct vma_itera
 		if (vma_iter_prealloc(vmi, vma))
 			goto unacct_fail;
 
+		vma_start_write(vma);
+
 		init_vma_prep(&vp, vma);
 		vma_prepare(&vp);
 		vma_adjust_trans_huge(vma, vma->vm_start, addr + len, 0);
_

Patches currently in -mm which might be from surenb@google.com are

mm-enable-page-walking-api-to-lock-vmas-during-the-walk.patch
swap-remove-remnants-of-polling-from-read_swap_cache_async.patch
mm-add-missing-vm_fault_result_trace-name-for-vm_fault_completed.patch
mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed.patch
mm-change-folio_lock_or_retry-to-use-vm_fault-directly.patch
mm-handle-swap-page-faults-under-per-vma-lock.patch
mm-handle-userfaults-under-vma-lock.patch
mm-handle-userfaults-under-vma-lock-fix.patch
mm-for-config_per_vma_lock-equate-write-lock-assertion-for-vma-and-mmap.patch
mm-replace-mmap-with-vma-write-lock-assertions-when-operating-on-a-vma.patch
mm-lock-vma-explicitly-before-doing-vm_flags_reset-and-vm_flags_reset_once.patch
mm-always-lock-new-vma-before-inserting-into-vma-tree.patch
mm-move-vma-locking-out-of-vma_prepare-and-dup_anon_vma.patch

