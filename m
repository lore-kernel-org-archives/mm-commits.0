Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C7FC05027
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbjAZXKJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbjAZXKI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:10:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBB869500
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:10:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1936B6191F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7057CC433D2;
        Thu, 26 Jan 2023 23:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674774603;
        bh=/yHDu0hH+HCJVhmxU0Ev1HEqOUOjAgUeKhd0/Hh8KMg=;
        h=Date:To:From:Subject:From;
        b=XiyQhhEYj2VTz/gv9z72/Sg8vonOqZ9shfEY2KmfBacINsH1KeyynUUo+sBb7OQIO
         4JAjZ2f0tKZIaFIk9XZo1DJa16rPSrGLKOw7ZPoCRU4p4+KKWCLQQOTyPra8MZinVF
         sHxXjH4rOn3xLg9jqXFKHma94QyeO8nBuVREVDow=
Date:   Thu, 26 Jan 2023 15:10:02 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, songliubraving@fb.com, soheil@google.com,
        shakeelb@google.com, sebastian.reichel@collabora.com,
        rppt@kernel.org, rientjes@google.com, punit.agrawal@bytedance.com,
        posk@google.com, peterz@infradead.org, peterx@redhat.com,
        paulmck@kernel.org, mingo@redhat.com, minchan@google.com,
        mhocko@suse.com, mgorman@techsingularity.net, luto@kernel.org,
        lstoakes@gmail.com, Liam.Howlett@Oracle.com, ldufour@linux.ibm.com,
        kent.overstreet@linux.dev, joelaf@google.com, jannh@google.com,
        hughd@google.com, hannes@cmpxchg.org, gthelen@google.com,
        edumazet@google.com, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, bigeasy@linutronix.de, axelrasmussen@google.com,
        arjunroy@google.com, surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch added to mm-unstable branch
Message-Id: <20230126231003.7057CC433D2@smtp.kernel.org>
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
Date: Thu, 26 Jan 2023 11:37:50 -0800

Replace indirect modifications to vma->vm_flags with calls to modifier
functions to be able to track flag changes and to keep vma locking
correctness.

Link: https://lkml.kernel.org/r/20230126193752.297968-6-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@google.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Oskolkov <posk@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c |    6 +++++-
 arch/s390/mm/gmap.c                |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

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
@@ -409,12 +410,15 @@ static int kvmppc_memslot_page_merge(str
 			ret = H_STATE;
 			break;
 		}
+		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
+		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-			  merge_flag, &vma->vm_flags);
+			  merge_flag, &vm_flags);
 		if (ret) {
 			ret = H_STATE;
 			break;
 		}
+		vm_flags_reset(vma, vm_flags);
 		start = vma->vm_end;
 	} while (end > vma->vm_end);
 
--- a/arch/s390/mm/gmap.c~mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise
+++ a/arch/s390/mm/gmap.c
@@ -2587,14 +2587,18 @@ int gmap_mark_unmergeable(void)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
+	unsigned long vm_flags;
 	int ret;
 	VMA_ITERATOR(vmi, mm, 0);
 
 	for_each_vma(vmi, vma) {
+		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
+		vm_flags = vma->vm_flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-				  MADV_UNMERGEABLE, &vma->vm_flags);
+				  MADV_UNMERGEABLE, &vm_flags);
 		if (ret)
 			return ret;
+		vm_flags_reset(vma, vm_flags);
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
mm-introduce-__vm_flags_mod-and-use-it-in-untrack_pfn.patch
mm-export-dump_mm.patch

