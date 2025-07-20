Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC54D2907
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 00:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752970707; cv=none; b=LJN3Gn6JqRQy3f7wZpi2Oyx4Fzv+h1laOwZJuw1j7l5hjug8cuCRr+ISm6braFTK4Ffc9OM0b8ddoLnhGa5s19xoaPlLc3GBcnPRoF/cYQ0UdWzW+/nCSyH8giLhQARC89OH0NqF6wDUS5MJ+IkmKxtZcc+O1UAHGntRurkEOTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752970707; c=relaxed/simple;
	bh=7+CrfihwmiciUCsD6RLwL2yIKMKDde7Onoj6I2Pyd2c=;
	h=Date:To:From:Subject:Message-Id; b=kDr0VqSxCUOPbPMN6J68NmiVRO7PvyoNu3aNXYAkQYBoLBkXiQNxbcrNriVsILmHNckIlSNR4cVsFdBf+H77FzMYE9qQhXX7WNX2P7e5wEy0v3YwyefMJUa24RMccHb301K1ezvTzSkguZ07f0Udtqvp2LKs3+B4yeK2INllVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SPMO837M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SPMO837M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E15EC4CEE3;
	Sun, 20 Jul 2025 00:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752970707;
	bh=7+CrfihwmiciUCsD6RLwL2yIKMKDde7Onoj6I2Pyd2c=;
	h=Date:To:From:Subject:From;
	b=SPMO837MZZYZyfh08yU/2laQ1Ilt/a2zLpxeHogjc14S/vkidB3G+r5aoskLJTFby
	 /JF53koTY73SyJ3UxRPBwFstwO2+qvxYf6eDN5HBTrPnsNz3JK07SLwF5ZiT4OOK5j
	 4g9G/SG2LEgwcpJIafaiIQehfxUp4vhoXKxiB2YA=
Date: Sat, 19 Jul 2025 17:18:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch added to mm-new branch
Message-Id: <20250720001827.4E15EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce FPB_RESPECT_WRITE for PTE batching infrastructure
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm: introduce FPB_RESPECT_WRITE for PTE batching infrastructure
Date: Fri, 18 Jul 2025 14:32:41 +0530

Patch 6 ("mm: Optimize mprotect() by PTE batching") optimizes mprotect()
by batch clearing the ptes, masking in the new protections, and batch
setting the ptes.  Suppose that the first pte of the batch is writable -
with the current implementation of folio_pte_batch(), it is not guaranteed
that the other ptes in the batch are already writable too, so we may
incorrectly end up setting the writable bit on all ptes via
modify_prot_commit_ptes().

Therefore, introduce FPB_RESPECT_WRITE so that all ptes in the batch are
writable or not.

Link: https://lkml.kernel.org/r/20250718090244.21092-5-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/mm/internal.h~mm-introduce-fpb_respect_write-for-pte-batching-infrastructure
+++ a/mm/internal.h
@@ -208,17 +208,20 @@ typedef int __bitwise fpb_t;
 /* Compare PTEs respecting the soft-dirty bit. */
 #define FPB_RESPECT_SOFT_DIRTY		((__force fpb_t)BIT(1))
 
+/* Compare PTEs respecting the writable bit. */
+#define FPB_RESPECT_WRITE		((__force fpb_t)BIT(2))
+
 /*
  * Merge PTE write bits: if any PTE in the batch is writable, modify the
  * PTE at @ptentp to be writable.
  */
-#define FPB_MERGE_WRITE			((__force fpb_t)BIT(2))
+#define FPB_MERGE_WRITE			((__force fpb_t)BIT(3))
 
 /*
  * Merge PTE young and dirty bits: if any PTE in the batch is young or dirty,
  * modify the PTE at @ptentp to be young or dirty, respectively.
  */
-#define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(3))
+#define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(4))
 
 static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
 {
@@ -226,7 +229,9 @@ static inline pte_t __pte_batch_clear_ig
 		pte = pte_mkclean(pte);
 	if (likely(!(flags & FPB_RESPECT_SOFT_DIRTY)))
 		pte = pte_clear_soft_dirty(pte);
-	return pte_wrprotect(pte_mkold(pte));
+	if (likely(!(flags & FPB_RESPECT_WRITE)))
+		pte = pte_wrprotect(pte);
+	return pte_mkold(pte);
 }
 
 /**
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function.patch
mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch
mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch
mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch
mm-split-can_change_pte_writable-into-private-and-shared-parts.patch
mm-optimize-mprotect-by-pte-batching.patch
arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch

