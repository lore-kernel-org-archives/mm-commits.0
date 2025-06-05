Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9046820330
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 21:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749159240; cv=none; b=ogF55TWksc3Wjmb/JhukxxYdFOtcP1A2TET97xKQ1HEB/SlVOozKm78DLWgQOlNrirTnYt1DMXhlEdUAFTvw4IPIaNQI9gzuEU7wyhNcmpwozbDcnLVe9NubUq+rXddKygiRegxX8VI5dNj+CpGxtKOKTA8Os4M7iXRNu6HfjMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749159240; c=relaxed/simple;
	bh=BtdghWIZk7PcRRTLbgBBjFIWNv6z3gZN76+cfIvfod0=;
	h=Date:To:From:Subject:Message-Id; b=d5p37h7uMTobcc5jmqumuPxGx2CPMN2aclrsUcrDr+bPgxe6MgZ8zzTSaWfCq1ExBR1++dYz10yRoWmSRsCe+lhWL4lN6/JYMT1B+k1WHYiYX0MHPkrikuGkJgtdIkFxKghZbYPct/uJuVIyreakf5gZ8B0h3dYZgqJ6dtuVFsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eufF62db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eufF62db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B76C4CEE7;
	Thu,  5 Jun 2025 21:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749159240;
	bh=BtdghWIZk7PcRRTLbgBBjFIWNv6z3gZN76+cfIvfod0=;
	h=Date:To:From:Subject:From;
	b=eufF62dbnmJM4U8u1wSafCp9AqW2AQxxfP9mbfGMERIyp79QrIU87t/aQDTQ2l9Kb
	 V9s6e93daABlvLFSPiFCc/nI3zkLjN7S4gCfD6A272zClfsXm8rB2nrhZFdaBKPFMx
	 dFLJ3V4cjqVct6QF8B22NdFT91Sdpc519286fKaA=
Date: Thu, 05 Jun 2025 14:33:59 -0700
To: mm-commits@vger.kernel.org,zhengtangquan@oppo.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,dev.jain@arm.com,david@redhat.com,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch added to mm-new branch
Message-Id: <20250605213359.E8B76C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: madvise: use walk_page_range_vma() instead of walk_page_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: madvise: use walk_page_range_vma() instead of walk_page_range()
Date: Thu, 5 Jun 2025 20:31:44 +1200

We've already found the VMA within madvise_walk_vmas() before calling
specific madvise behavior functions like madvise_free_single_vma().  So
calling walk_page_range() and doing find_vma() again seems unnecessary. 
It also prevents potential optimizations in those madvise callbacks,
particularly the use of dedicated per-VMA locking.

Link: https://lkml.kernel.org/r/20250605083144.43046-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/madvise.c~mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range
+++ a/mm/madvise.c
@@ -282,7 +282,7 @@ static long madvise_willneed(struct vm_a
 	*prev = vma;
 #ifdef CONFIG_SWAP
 	if (!file) {
-		walk_page_range(vma->vm_mm, start, end, &swapin_walk_ops, vma);
+		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
 		lru_add_drain(); /* Push any new pages onto the LRU now */
 		return 0;
 	}
@@ -581,7 +581,7 @@ static void madvise_cold_page_range(stru
 	};
 
 	tlb_start_vma(tlb, vma);
-	walk_page_range(vma->vm_mm, addr, end, &cold_walk_ops, &walk_private);
+	walk_page_range_vma(vma, addr, end, &cold_walk_ops, &walk_private);
 	tlb_end_vma(tlb, vma);
 }
 
@@ -619,7 +619,7 @@ static void madvise_pageout_page_range(s
 	};
 
 	tlb_start_vma(tlb, vma);
-	walk_page_range(vma->vm_mm, addr, end, &cold_walk_ops, &walk_private);
+	walk_page_range_vma(vma, addr, end, &cold_walk_ops, &walk_private);
 	tlb_end_vma(tlb, vma);
 }
 
@@ -825,7 +825,7 @@ static int madvise_free_single_vma(struc
 
 	mmu_notifier_invalidate_range_start(&range);
 	tlb_start_vma(tlb, vma);
-	walk_page_range(vma->vm_mm, range.start, range.end,
+	walk_page_range_vma(vma, range.start, range.end,
 			&madvise_free_walk_ops, tlb);
 	tlb_end_vma(tlb, vma);
 	mmu_notifier_invalidate_range_end(&range);
@@ -1160,7 +1160,7 @@ static long madvise_guard_install(struct
 		unsigned long nr_pages = 0;
 
 		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
-		err = walk_page_range_mm(vma->vm_mm, start, end,
+		err = walk_page_range_vma(vma, start, end,
 					 &guard_install_walk_ops, &nr_pages);
 		if (err < 0)
 			return err;
@@ -1244,7 +1244,7 @@ static long madvise_guard_remove(struct
 	if (!is_valid_guard_vma(vma, /* allow_locked = */true))
 		return -EINVAL;
 
-	return walk_page_range(vma->vm_mm, start, end,
+	return walk_page_range_vma(vma, start, end,
 			       &guard_remove_walk_ops, NULL);
 }
 
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-madvise-use-walk_page_range_vma-instead-of-walk_page_range.patch

