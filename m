Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FB14C99
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711769022; cv=none; b=vCgg8yG5Wn2PpG2WPt9+Zup4YntFOSiupW2MfICLIJX8GpzhZkNubmWOn5Kze17xVv5dfWmyduAATJ+I7hey1OcgL8Wgx9nF8DqVAqNDQKPAXTyHqyKW+B+9W53wL6SnX9dXA7EG9uKEzObW4gKI2BjLCQzaYYwZY+DixuGY5r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711769022; c=relaxed/simple;
	bh=wsTCpu12BK4StZ6c+b/hrPNEMwWY6tlMGaFxOpPScJk=;
	h=Date:To:From:Subject:Message-Id; b=LXBhouiT8iLxiSJRmP2/KZ7SW2p+1+Cbe6fiXwYb6yHieu5T89wm5N7OoCSCoipCbUBIFfMnEvm//FYX+uhQ7xMAjDEp25gliUCHUUv/m9HbYaPnG7WD1+/t8nhuY7/+Qm+M4fOugme36dPWCbeJbnENkq+WKSaI6OaDgvZcBag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uMQDGZwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uMQDGZwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BCFC433C7;
	Sat, 30 Mar 2024 03:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711769021;
	bh=wsTCpu12BK4StZ6c+b/hrPNEMwWY6tlMGaFxOpPScJk=;
	h=Date:To:From:Subject:From;
	b=uMQDGZwyXXkrkub3t1ttDv8C6fi4PlO3dApKXh9/Yo6NMLpfLv0b9ycupCVpWLs4F
	 p37NdWqyQnskjBVRJsTps1Hh9aPQQ6eEaGbGhElKoDB3sPYvtkhsiOogzmWR54tLCB
	 QfPYrATwWyQ2FhtJFVCluk/b4L8q3abNWGcQyOrE=
Date: Fri, 29 Mar 2024 20:23:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rientjes@google.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,itaru.kitayama@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,catalin.marinas@arm.com,apopple@nvidia.com,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch added to mm-unstable branch
Message-Id: <20240330032341.51BCFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: alloc_anon_folio: avoid doing vma_thp_gfp_mask in fallback cases
has been added to the -mm mm-unstable branch.  Its filename is
     mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: alloc_anon_folio: avoid doing vma_thp_gfp_mask in fallback cases
Date: Fri, 29 Mar 2024 20:37:50 +1300

Fallback rates surpassing 90% have been observed on phones utilizing 64KiB
CONT-PTE mTHP.  In these scenarios, when one out of every 16 PTEs fails to
allocate large folios, the remaining 15 PTEs fallback.  Consequently,
invoking vma_thp_gfp_mask seems redundant in such cases.  Furthermore,
abstaining from its use can also contribute to improved code readability.

Link: https://lkml.kernel.org/r/20240329073750.20012-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memory.c~mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases
+++ a/mm/memory.c
@@ -4359,6 +4359,9 @@ static struct folio *alloc_anon_folio(st
 
 	pte_unmap(pte);
 
+	if (!orders)
+		goto fallback;
+
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

arm64-mm-swap-support-thp_swap-on-hardware-with-mte.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio.patch
mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch

