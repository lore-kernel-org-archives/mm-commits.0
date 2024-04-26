Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ABD74E26
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714102812; cv=none; b=E/Su//RnutS0yklqQOTo4pu+JdXZ1tjXm4eMgt/rl92uAD9D+EjLl7IhNppkxFPtrOFNYuUr28FiSQW10ddS0GbP6T7C7OCpDwAk5XG0OizSgsERgp3MZPnfZ2HUwl7fZ7SY1lQa52ay9TOZEKZiP+0G1kNmXxWaivPx4t9OYm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714102812; c=relaxed/simple;
	bh=3x1R1QHiQrTNqOVQUGrKdvucXsCKdU+/h4MNSJk8zfI=;
	h=Date:To:From:Subject:Message-Id; b=Y2OFUNo5ucSkmHVH7Dz7NvpJqeR8RdVmmLVipHj3Q0MViZAjcfZ1cYTUo7DkebMnZ3+2N/BNQe3hcvGKKJPN/Su6xchy+HmOb/tqytknxniACTMkyvJXbivATJmXR58jM4uiYVj9clqEwrdFjeL/HcHq1hqu5xhBObSindfBA38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pGcJmA4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pGcJmA4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD0C113CD;
	Fri, 26 Apr 2024 03:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714102812;
	bh=3x1R1QHiQrTNqOVQUGrKdvucXsCKdU+/h4MNSJk8zfI=;
	h=Date:To:From:Subject:From;
	b=pGcJmA4N5lgr6h2scUi02EhnFOTorUjEDt39cPD0T5hg9mMvYf/f24zXL5PrnZMWB
	 5xyDaXAnKs5Y5xRsmclv5jSDSfqfWe+l1eYqUysC3PzrGqLHhphZB5SuWFd0wlJgmE
	 q+dNFBrJaNXnrk6wV6DqVu61iygRa1a+4nkJaRoU=
Date: Thu, 25 Apr 2024 20:40:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,peterx@redhat.com,nathan@kernel.org,kernel@xen0n.name,jgg@nvidia.com,david@redhat.com,chenhuacai@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch removed from -mm tree
Message-Id: <20240426034012.08AD0C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch

This patch was dropped because it was folded into mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix
Date: Thu Apr  4 01:27:47 PM PDT 2024

simplify PageAnonExclusive(), per Matthew

Link: https://lkml.kernel.org/r/Zg3u5Sh9EbbYPhaI@casper.infradead.org
Cc: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix
+++ a/include/linux/page-flags.h
@@ -1096,11 +1096,10 @@ static __always_inline int PageAnonExclu
 {
 	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
 	/*
-	 * Allow the anon-exclusive check to work on hugetlb tail pages.
-	 * Here hugetlb pages will always guarantee the anon-exclusiveness
-	 * of the head page represents the tail pages.
+	 * HugeTLB stores this information on the head page; THP keeps it per
+	 * page
 	 */
-	if (PageHuge(page) && !PageHead(page))
+	if (PageHuge(page))
 		page = compound_head(page);
 	return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-allow-anon-exclusive-check-over-hugetlb-tail-pages.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

