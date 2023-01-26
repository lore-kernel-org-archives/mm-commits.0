Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD642C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbjAZAav (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:30:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235959AbjAZAaq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:30:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D4164DB6
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:30:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54DAAB81C04
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DB3C433D2;
        Thu, 26 Jan 2023 00:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674693023;
        bh=UQhNPriBPIjoYPRCbvkrfPfdkGK2dbdc7j78rcWumzw=;
        h=Date:To:From:Subject:From;
        b=PWKwo6I2GgOHrIUw2SC5t8+An6ynQHsLYVUqGJz/G/Nn4K1ftvgXNwFirabGtT8bg
         nS186A/CMqEgpiPprpMsc8RK9KMAtg/Pone01hhh5x6hnW5rgkBJta6uyVhuC06jHc
         vcRAhyjyg0Bgh2et+mMEZwZO1wzmHqiZt0nf5UfI=
Date:   Wed, 25 Jan 2023 16:30:22 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch added to mm-unstable branch
Message-Id: <20230126003022.E8DB3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace VM_LOCKED_CLEAR_MASK with VM_LOCKED_MASK
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch

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
Subject: mm: replace VM_LOCKED_CLEAR_MASK with VM_LOCKED_MASK
Date: Wed, 25 Jan 2023 15:35:50 -0800

To simplify the usage of VM_LOCKED_CLEAR_MASK in clear_vm_flags(), replace
it with VM_LOCKED_MASK bitmask and convert all users.

Link: https://lkml.kernel.org/r/20230125233554.153109-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/include/linux/mm.h
@@ -421,8 +421,8 @@ extern unsigned int kobjsize(const void
 /* This mask defines which mm->def_flags a process can inherit its parent */
 #define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
 
-/* This mask is used to clear all the VMA flags used by mlock */
-#define VM_LOCKED_CLEAR_MASK	(~(VM_LOCKED | VM_LOCKONFAULT))
+/* This mask represents all the VMA flag bits used by mlock */
+#define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
--- a/kernel/fork.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/kernel/fork.c
@@ -659,7 +659,7 @@ static __latent_entropy int dup_mmap(str
 			tmp->anon_vma = NULL;
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
+		clear_vm_flags(tmp, VM_LOCKED_MASK);
 		file = tmp->vm_file;
 		if (file) {
 			struct address_space *mapping = file->f_mapping;
--- a/mm/hugetlb.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/mm/hugetlb.c
@@ -6973,8 +6973,8 @@ static unsigned long page_table_shareabl
 	unsigned long s_end = sbase + PUD_SIZE;
 
 	/* Allow segments to share if only one is marked locked */
-	unsigned long vm_flags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
-	unsigned long svm_flags = svma->vm_flags & VM_LOCKED_CLEAR_MASK;
+	unsigned long vm_flags = vma->vm_flags & ~VM_LOCKED_MASK;
+	unsigned long svm_flags = svma->vm_flags & ~VM_LOCKED_MASK;
 
 	/*
 	 * match the virtual addresses, permission and the alignment of the
--- a/mm/mlock.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/mm/mlock.c
@@ -497,7 +497,7 @@ static int apply_vma_lock_flags(unsigned
 		if (vma->vm_start != tmp)
 			return -ENOMEM;
 
-		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
 		newflags |= flags;
 		/* Here we know that  vma->vm_start <= nstart < vma->vm_end. */
 		tmp = vma->vm_end;
@@ -661,7 +661,7 @@ static int apply_mlockall_flags(int flag
 	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
-	current->mm->def_flags &= VM_LOCKED_CLEAR_MASK;
+	current->mm->def_flags &= ~VM_LOCKED_MASK;
 	if (flags & MCL_FUTURE) {
 		current->mm->def_flags |= VM_LOCKED;
 
@@ -681,7 +681,7 @@ static int apply_mlockall_flags(int flag
 	for_each_vma(vmi, vma) {
 		vm_flags_t newflags;
 
-		newflags = vma->vm_flags & VM_LOCKED_CLEAR_MASK;
+		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
 		newflags |= to_add;
 
 		/* Ignore errors */
--- a/mm/mmap.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/mm/mmap.c
@@ -2671,7 +2671,7 @@ expanded:
 		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
 					is_vm_hugetlb_page(vma) ||
 					vma == get_gate_vma(current->mm))
-			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
+			clear_vm_flags(vma, VM_LOCKED_MASK);
 		else
 			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
@@ -3340,8 +3340,8 @@ static struct vm_area_struct *__install_
 	vma->vm_start = addr;
 	vma->vm_end = addr + len;
 
-	vma->vm_flags = vm_flags | mm->def_flags | VM_DONTEXPAND | VM_SOFTDIRTY;
-	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
+	init_vm_flags(vma, (vm_flags | mm->def_flags |
+		      VM_DONTEXPAND | VM_SOFTDIRTY) & ~VM_LOCKED_MASK);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	vma->vm_ops = ops;
--- a/mm/mremap.c~mm-replace-vm_locked_clear_mask-with-vm_locked_mask
+++ a/mm/mremap.c
@@ -687,7 +687,7 @@ static unsigned long move_vma(struct vm_
 
 	if (unlikely(!err && (flags & MREMAP_DONTUNMAP))) {
 		/* We always clear VM_LOCKED[ONFAULT] on the old vma */
-		vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
+		clear_vm_flags(vma, VM_LOCKED_MASK);
 
 		/*
 		 * anon_vma links of the old vma is no longer needed after its page
_

Patches currently in -mm which might be from surenb@google.com are

kernel-fork-convert-vma-assignment-to-a-memcpy.patch
mm-introduce-vma-vm_flags-wrapper-functions.patch
mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls.patch
mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch
mm-introduce-mod_vm_flags_nolock-and-use-it-in-untrack_pfn.patch
mm-export-dump_mm.patch

