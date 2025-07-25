Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B463219312
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409734; cv=none; b=qQ3sUgDheQQzD8/0w0J9MkUQqPAYSCEjSA5p595DNyQ+0o15+siJwE5rqQEKQOXsNqsVBnlv8+mMGaVUjUjc5C1ij3BevTT+LjOWCgyHdpMFL8HHPjOWRSufH8rUaNFNrp2XwqOplbEcvEUG8VNdMJlEeRNBUpJRLmeKuq/sAUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409734; c=relaxed/simple;
	bh=BNMnDU49flLaz14LxMUYTSzwQuJeZjdVwiArbfZ80pM=;
	h=Date:To:From:Subject:Message-Id; b=ASltSScOhHBVn8VA9L/RipKOp3lqRcoUtMpyvFXZwn6YtD9XyITDbMR5vWcloe5GAUDRllxkSiC98GJPXuYLDuK7D8ZvxqxcQ8MXkXGpZdjVt+NJDj3P2JueqgH3w5W9IeL1v5R4tzbPfiLTwzLxdqGTIGacbkewmErqL3eYSjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S/S5CIbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S/S5CIbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12686C4CEED;
	Fri, 25 Jul 2025 02:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409734;
	bh=BNMnDU49flLaz14LxMUYTSzwQuJeZjdVwiArbfZ80pM=;
	h=Date:To:From:Subject:From;
	b=S/S5CIbw5nxPjsa3neYr3E08GWcc4+b5Qhq5L68JpgdRfFxRkXMisPQ9kJiRz9QMu
	 n6NIeWpXwUaX5Y59o3myNplFzmaGO3qI1wO03WVWNIQPWzDPJUs3Yg4IWOEwr1usp2
	 vs2eIcrALo+rw6cGXRnkbet4EFfrr5QXK7bE/UeQ=
Date: Thu, 24 Jul 2025 19:15:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch removed from -mm tree
Message-Id: <20250725021534.12686C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce FPB_RESPECT_WRITE for PTE batching infrastructure
has been removed from the -mm tree.  Its filename was
     mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
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

khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch
khugepaged-optimize-collapse_pte_mapped_thp-by-pte-batching.patch

