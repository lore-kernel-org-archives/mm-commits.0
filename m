Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1786C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjBJAzf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjBJAyi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:54:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439306BD30
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:53:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D16D561C36
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EB2C433D2;
        Fri, 10 Feb 2023 00:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990427;
        bh=iNNyARJLZhdLCjabsjtpq8i4K+K/0nXnjAFtDWt5oeA=;
        h=Date:To:From:Subject:From;
        b=USuMCHCQ0h3YdjZw5s9WMZMKWTeyYj4YJApx01w2FcjISo2/FWJN3/Da+mPVQ/nbs
         njJ67PaIiIVmxyNG0vOIjDE/rKCXPF6Z6uwENOkqErrB91OvS2mn1A4H9ga4k16x3z
         wWqyPqbx6VXCpkxGbjfSjJVPsY4Oj7RHgWvPxkYM=
Date:   Thu, 09 Feb 2023 16:53:46 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, songliubraving@fb.com, soheil@google.com,
        shakeelb@google.com, sebastian.reichel@collabora.com,
        rppt@kernel.org, rientjes@google.com, punit.agrawal@bytedance.com,
        posk@google.com, peterz@infradead.org, peterx@redhat.com,
        paulmck@kernel.org, mpe@ellerman.id.au, mingo@redhat.com,
        minchan@google.com, mhocko@suse.com, mgorman@techsingularity.net,
        luto@kernel.org, lstoakes@gmail.com, Liam.Howlett@Oracle.com,
        ldufour@linux.ibm.com, kent.overstreet@linux.dev,
        joelaf@google.com, jannh@google.com, hughd@google.com,
        hannes@cmpxchg.org, gthelen@google.com, edumazet@google.com,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        bigeasy@linutronix.de, axelrasmussen@google.com,
        arjunroy@google.com, 42.hyeyoo@gmail.com, surenb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch removed from -mm tree
Message-Id: <20230210005347.32EB2C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: replace vma->vm_flags indirect modification in ksm_madvise
has been removed from the -mm tree.  Its filename was
     mm-replace-vma-vm_flags-indirect-modification-in-ksm_madvise.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Michael Ellerman <mpe@ellerman.id.au>	[powerpc]
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
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


