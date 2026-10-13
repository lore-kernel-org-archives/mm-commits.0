Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F6E48594B
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866046; cv=none; b=hXys1TPkJrjKhIpZpbvFsx4/bqUnh1eckSPYMyEGzqWUUw25k6p0Bfhdz6Igs2htNfdCCvR861Kup1Qw2uwlIMgDmwjKcJZpnVHdsdfRhfpJQJqHWPKBJeJL+1eNEn2VYAoLyJ6u44wn3zL2GYo8o0hikg/LvcIIBlcjl7h5FGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866046; c=relaxed/simple;
	bh=jYcb7QLXhBWq/KjHMEWfwXzFdXVpLYLcXQBA0DECYqQ=;
	h=Date:To:From:Subject:Message-Id; b=B925b3DyHtipDj+/yghqce+u0us4WRjos39zlmoiWnTYxtCGuxO4WIBs2V7MzenXVN/hfSoLvLIA9fU5irYWcz+wLyMuB+dBxnx8D4AuFdEd5A+WELBIYFEdwkeU6CO+krY4IhR7HnrHXFGw87qS/FmKTGWtmr/lH0teqGNEEtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0RBVfKL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0RBVfKL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9D01F00899;
	Tue, 13 Oct 2026 04:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866042;
	bh=3fVm1iO+7yOQiTdlkyqMlbMDX5HzHWwwhnbgR1fvG8M=;
	h=Date:To:From:Subject;
	b=0RBVfKL1IsJrM9NrexstTbG8kAyf3NA7UoztHof+FRERmW4XgFUHQ3JDhGhYr1GJn
	 Xa0Xep1wbgfkQy5zYPQZK6svdoXNEe9Tvm+C7pzRSu0QGYAMyBpmNXmZYwPcza60TK
	 yANNmYgIE9Wp+fyAdMbJeuYTzwd7TtbboFGyZ5G0=
Date: Mon, 12 Oct 2026 21:34:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage.patch removed from -mm tree
Message-Id: <20261013043401.EE9D01F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: disallow raw PFN mappings of huge/shared zeropage
has been removed from the -mm tree.  Its filename was
     mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm: disallow raw PFN mappings of huge/shared zeropage
Date: Mon, 21 Sep 2026 13:42:25 +0800

Handling the huge/shared zeropage correctly in vmf_insert_pfn_pmd() and
vmf_insert_pfn_prot() is more involved.  We would need to check whether
the VMA allows it and keep the mapping read-only, similar to the checks in
vm_mixed_ok().

No in-tree user needs that support, so reject these mappings with
VM_FAULT_SIGBUS rather than complicate the code for now.

Link: https://lore.kernel.org/20260921054225.28537-1-lance.yang@linux.dev
Link: https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
---

 mm/huge_memory.c |    3 +++
 mm/memory.c      |    3 +++
 2 files changed, 6 insertions(+)

--- a/mm/huge_memory.c~mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage
+++ a/mm/huge_memory.c
@@ -1727,6 +1727,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 
+	if (unlikely(is_huge_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
 	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
--- a/mm/memory.c~mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage
+++ a/mm/memory.c
@@ -2860,6 +2860,9 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
 
+	if (unlikely(is_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
 
_

Patches currently in -mm which might be from lance.yang@linux.dev are


