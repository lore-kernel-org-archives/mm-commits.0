Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FC7234994
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 06:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971347; cv=none; b=iQ/d9Wz6noqdeICZU/CrQ/BevR7VBh+mOzjWBcR9tuYpcjIF917btN56y50D5u5+WKLXnsNrGtVrgWTYqM+ZtI3pb4205Lv4R5qMPicHGKnUeiI4M5s7CKaPfZcOTgmjh0JkD02PvnR+ng/Fn0BrnJib6W+v1mxx3Wd5kZkdFKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971347; c=relaxed/simple;
	bh=U+BZmlJlH6/QGjrxwSWeU2Y5vyPujkdpXIzRyUEOJ+A=;
	h=Date:To:From:Subject:Message-Id; b=EsL8uLXC+OvEI51eAWjQ1VxXdr1q/yJiQkhGiXjPIdT9jY3d+OzMj7CX6OdNpnBD9pSnZvLMveJws/VwzfdBcHxQ0ha38eH+Nl6bkrqychL4abmTmF+wOGvywuoemSHmIgMZXN2xGhtY707RmOOBn0s/FVGujgKxT+UYVnjWnI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vVJkIG21; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vVJkIG21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E5D1F000FF;
	Mon, 21 Sep 2026 06:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789971345;
	bh=bR8yO+YIF8tuYtS7lXTO2zAltGICyiLCQv4bX9ID3Cg=;
	h=Date:To:From:Subject;
	b=vVJkIG21pWWkGNqIAW1XEZLhh2j+U0ThWnZP8GWqOX/35VNXvqYdAzzeUdgnCm/3m
	 HrLN8u8nx1SCdF7zgU3i9kSEJ2STZBPfprZX1XTSVYFipinOFSDZGARbq2sF7jLBWY
	 mmv3gFfCmmJnHskJgMtDsmRwW47txzhAl0TQQgzs=
Date: Sun, 20 Sep 2026 23:15:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kas@kernel.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage.patch added to mm-new branch
Message-Id: <20260921061545.32E5D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: disallow raw PFN mappings of huge/shared zeropage
has been added to the -mm mm-new branch.  Its filename is
     mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage.patch

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 mm/huge_memory.c |    3 +++
 mm/memory.c      |    3 +++
 2 files changed, 6 insertions(+)

--- a/mm/huge_memory.c~mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage
+++ a/mm/huge_memory.c
@@ -1723,6 +1723,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 
+	if (unlikely(is_huge_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
 	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
--- a/mm/memory.c~mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage
+++ a/mm/memory.c
@@ -2956,6 +2956,9 @@ vm_fault_t vmf_insert_pfn_prot(struct vm
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
 
+	if (unlikely(is_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
 
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-huge_memory-simplify-pgtable-deposit-detection.patch
mm-disallow-raw-pfn-mappings-of-huge-shared-zeropage.patch

