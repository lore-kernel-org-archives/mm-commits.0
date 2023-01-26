Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0632C54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbjAZAb1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236245AbjAZAbX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:31:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7805F64683
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:31:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B925F616F7
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A86C433D2;
        Thu, 26 Jan 2023 00:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674693060;
        bh=IzEosNU5pINq68H6mwWafed58kQvbl1eRy9IaSD4PVQ=;
        h=Date:To:From:Subject:From;
        b=SyZJXGNBy09q89p1QQmjVeMvMS0VVnDh9koyCYsEqKQb+1003m0EKTOJu6QiA77Hz
         SPaELoEhma0pENkXxLU5y1rE4SZLK4F1ACEqlRsucx6YAPAWuO+Ix4/G5EkfU3EaS0
         DWv86qe11j/AYAdZSkW4GzCqs6lSbE/VFGYx+9xw=
Date:   Wed, 25 Jan 2023 16:30:59 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch added to mm-unstable branch
Message-Id: <20230126003100.18A86C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace vma->vm_flags indirect modification in ksm_madvise
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch

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
Subject: mm: replace vma->vm_flags indirect modification in ksm_madvise
Date: Wed, 25 Jan 2023 15:35:52 -0800

Replace indirect modifications to vma->vm_flags with calls to modifier
functions to be able to track flag changes and to keep vma locking
correctness.

Link: https://lkml.kernel.org/r/20230125233554.153109-6-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -393,6 +393,7 @@ static int kvmppc_memslot_page_merge(str
 {
 	unsigned long gfn = memslot->base_gfn;
 	unsigned long end, start = gfn_to_hva(kvm, gfn);
+	unsigned long vm_flags;
 	int ret = 0;
 	struct vm_area_struct *vma;
 	int merge_flag = (merge) ? MADV_MERGEABLE : MADV_UNMERGEABLE;
@@ -409,12 +410,14 @@ static int kvmppc_memslot_page_merge(str
 			ret = H_STATE;
 			break;
 		}
+		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-			  merge_flag, &vma->vm_flags);
+			  merge_flag, &vm_flags);
 		if (ret) {
 			ret = H_STATE;
 			break;
 		}
+		reset_vm_flags(vma, vm_flags);
 		start = vma->vm_end;
 	} while (end > vma->vm_end);
 
--- a/arch/s390/mm/gmap.c~mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise
+++ a/arch/s390/mm/gmap.c
@@ -2587,14 +2587,17 @@ int gmap_mark_unmergeable(void)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
+	unsigned long vm_flags;
 	int ret;
 	VMA_ITERATOR(vmi, mm, 0);
 
 	for_each_vma(vmi, vma) {
+		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-				  MADV_UNMERGEABLE, &vma->vm_flags);
+				  MADV_UNMERGEABLE, &vm_flags);
 		if (ret)
 			return ret;
+		reset_vm_flags(vma, vm_flags);
 	}
 	mm->def_flags &= ~VM_MERGEABLE;
 	return 0;
_

Patches currently in -mm which might be from surenb@google.com are

kernel-fork-convert-vma-assignment-to-a-memcpy.patch
mm-introduce-vma-vm_flags-wrapper-functions.patch
mm-replace-vm_locked_clear_mask-with-vm_locked_mask.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls.patch
mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch
mm-introduce-mod_vm_flags_nolock-and-use-it-in-untrack_pfn.patch
mm-export-dump_mm.patch

