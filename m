Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A477E76408
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102749; cv=none; b=EDK87p8yMDTApe/4CYNPFnQMpIKUgqTZzr52fIPGbqCpD5VrnHGiwEW1GGmlFHg1oPVGARK/JQ0p1VFW+1cHqXJV/DgNjzngIbYZ53vvsmUoOrQTpjz8btXVHBBQtr+05En6pU2TpGKcTwkfb+axtEF6oCNjh6WF/gJNpu20oeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102749; c=relaxed/simple;
	bh=1k6WLOPqw4Xyxa4tFG/0th4L/fX8PsvtZGbyC6PMPgg=;
	h=Date:To:From:Subject:Message-Id; b=sUfXTb3GgzZOZfsJ3qv6g3EUMJYpY635sbNVAgnlQhoP6wcxjn284M6BAI7umHAxmrnxV396UpGViFLtP3UcpsAN3l5CxpAzOnkmsneV/K0P8IwkCmxwAWrqVM3qsKNW2P3GRzTd0iE3gIYDaS2HAo9ryrYVnpxvJu4DtM42xj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Cry79j1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Cry79j1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1569FC113CD;
	Fri, 26 Apr 2024 03:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102749;
	bh=1k6WLOPqw4Xyxa4tFG/0th4L/fX8PsvtZGbyC6PMPgg=;
	h=Date:To:From:Subject:From;
	b=1Cry79j1lhDHgFq+nt0qE99Yi0sHhTg0DoEWPouPMdTVCtFRaDozpM/O9h+Cu1Q5O
	 Y478NGAzteWz3qTcq97F+vLPzk/OPqVXLWkEeiZifNR8by+/oaQogY0nVHODfYxYEV
	 /NsAqsMtP6GNAIdkxqfHHHqzRWH64e1ZXAd48cl0=
Date: Thu, 25 Apr 2024 20:39:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,peterx@redhat.com,muchun.song@linux.dev,mpe@ellerman.id.au,mike.kravetz@oracle.com,lstoakes@gmail.com,kirill@shutemov.name,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,hch@infradead.org,david@redhat.com,christophe.leroy@csgroup.eu,axelrasmussen@google.com,aneesh.kumar@kernel.org,andrew.jones@linux.dev,aarcange@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch removed from -mm tree
Message-Id: <20240426033909.1569FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch

This patch was dropped because it was folded into mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix
Date: Thu Mar 28 11:57:50 AM PDT 2024

fix comment, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix
+++ a/mm/gup.c
@@ -2858,7 +2858,7 @@ static int gup_hugepte(pte_t *ptep, unsi
  * GUP updates.  When hugepd will be extended to support non-hugetlbfs or
  * even anonymous memory, we need to do extra check as what we do with most
  * of the other folios. See writable_file_mapping_allowed() and
- * folio_fast_pin_allowed() for more information.
+ * gup_fast_folio_allowed() for more information.
  */
 static int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
 		unsigned int pdshift, unsigned long end, unsigned int flags,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

