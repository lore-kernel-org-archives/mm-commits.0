Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3073655E4
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 07:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783237555; cv=none; b=CbV8MYY0VgO7Vdg6IRr8KfY5AdbK6BcsaOCXrkN+O5WEHMuKaY9sMMfE6mXmAdWk6CGSEsPqXpaC3JQOknTK3+RRNBW81WpTFY9yP2hi+nuTKTFNk5IeDHnDQWsOE22grnZwoVE28M6MDQZa5ZPZT2/6SmA+zMsEqhElFFYStuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783237555; c=relaxed/simple;
	bh=pDsRMIuu4d+scz8PzfflDZgCAMJzlL8FIdIvUO4aSD0=;
	h=Date:To:From:Subject:Message-Id; b=DSD7dOyCXZMave7081NF4gQDRx8TNHFIHKvBDrw3gXHwMnFdAOoRF1PGXtel/romMMdnHYdd1XC9wWiYDtSn26FnWJcxD1U5eGjxeOS6C3yOJ5TJUa6g/kk/RSIWJsh13NB6KmKhZUxskXUJcltWHJ9hpYCNrunZl1P9SQenJaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gZGzRm0i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gZGzRm0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199A81F000E9;
	Sun,  5 Jul 2026 07:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783237548;
	bh=ujSW1QqGgYMHSqgFK0mUIEj4Ts2EPIp56Ah22U8Ax4M=;
	h=Date:To:From:Subject;
	b=gZGzRm0iIftK0+NRnJ0OmqyRb1u4xkggqTIIA6s/mFogDGyYQQiwv3nOyIlgGW92Y
	 rfv0pDQyjELFMsN9pPBwoWcIb69YtDPZBy6w9rNVMRJ3BSK2npZyZhskDVIwsH6ieF
	 V496BcACTwba1U3qXIeEKGWTxkBJiIdoci6V9NKs=
Date: Sun, 05 Jul 2026 00:45:47 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-use-huge_ptep_get-for-hugetlb.patch added to mm-new branch
Message-Id: <20260705074548.199A81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mprotect: use huge_ptep_get() for hugetlb
has been added to the -mm mm-new branch.  Its filename is
     mm-mprotect-use-huge_ptep_get-for-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-use-huge_ptep_get-for-hugetlb.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/mprotect: use huge_ptep_get() for hugetlb
Date: Fri, 3 Jul 2026 11:41:59 +0000

prot_none_hugetlb_entry() is the hugetlb callback for the early
mprotect(PROT_NONE) PFN permission walk on x86.

The callback passes the decoded PFN to pfn_modify_allowed().  For a
hugetlb callback, the pte pointer refers to a hugetlb entry.  On
architectures where hugetlb entries need huge_ptep_get(), reading that
entry with ptep_get() can make the permission check use the wrong PFN.

Use huge_ptep_get() before decoding the hugetlb PFN.

Currently there is no path which can trigger a bug: huge_ptep_get() is a
simple ptep_get() for x86, and the prot_none walk occurs only for x86.

So no need to backport - use the correct helper anyways.

Link: https://lore.kernel.org/20260703114202.365553-7-dev.jain@arm.com
Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Jun'ichi "Nick" Nomura <j-nomura@ce.jp.nec.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-use-huge_ptep_get-for-hugetlb
+++ a/mm/mprotect.c
@@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pt
 		0 : -EACCES;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
 static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
 				   unsigned long addr, unsigned long next,
 				   struct mm_walk *walk)
 {
-	return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
-				  *(pgprot_t *)(walk->private)) ?
-		0 : -EACCES;
+	const pte_t entry = huge_ptep_get(walk->mm, addr, pte);
+
+	if (pfn_modify_allowed(pte_pfn(entry), *(pgprot_t *)(walk->private)))
+		return 0;
+	return -EACCESS;
 }
+#else
+#define prot_none_hugetlb_entry	NULL
+#endif
 
 static const struct mm_walk_ops prot_none_walk_ops = {
 	.pte_entry		= prot_none_pte_entry,
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-swap-rename-subpage-page-in-folio_dup_swap-folio_put_swap.patch
mm-mprotect-drop-sub-from-batching-context.patch
arm64-make-huge_ptep_get-handled-unaligned-addresses.patch
mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch

