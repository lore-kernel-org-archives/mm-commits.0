Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8AA34F48F
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 18:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788027855; cv=none; b=MPnyBRSfAAKPkraCVgqdoGNw/xiKwOwZHp7AX4PlO7NyqxFYcMXCnZDpG1u5TSWpoTr4Q+w+BG5cEPEOV4cgDJtirI9iamYi7W/L1yy9CAMw2Uav4JasnIL3zpKOS52Y2I6/xNeHPMOpW0o1R1qLRlEdft+p2gqCzn1LleaDopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788027855; c=relaxed/simple;
	bh=PyHMoTKLkp/UjNdfhkzxW9sheDIRaO26AQUyrYPVNeI=;
	h=Date:To:From:Subject:Message-Id; b=rHEQuMs/vtpOfLPBC4epUgFOhLrs0mWu3WIQYV0yl50uy4f3M10dAR48duh9lRRBbNcl+pcx32TEEhXluSesYN5z0Ou6ryYbxZnrM0i6qh66CF5l4yY/u/cFzBMuaG3uidV7XOMbuxxF5sXXC360LEbrNPoPIXxr5CGYCYNM8mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xh6su2fW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xh6su2fW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAA11F000E9;
	Sat, 29 Aug 2026 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788027854;
	bh=sU+ZOdXweXil1M2I5USbx6DW7QUJ+stjugkLmy21BxI=;
	h=Date:To:From:Subject;
	b=Xh6su2fWOwl69jeNglmhl3OqErMbGlW4kAQfam0M/BXp6Hc/ay+OE66DAw1fC/2vQ
	 YaL02fKg2vt1/zzWyPgKljIW4uiDGtS/n+M1y0BMdL+xOjZv6S8A5JsdblmycT/o/f
	 qCO1CtZ6pzV42PCZt7THfvleZIu5/6GMRkcz8SbU=
Date: Sat, 29 Aug 2026 11:24:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,saravanand@crusoe.ai,ryan.roberts@arm.com,peterx@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,clg@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20260829182414.6FAA11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: renames for Lorenzo's mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings patch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix-2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zi Yan <ziy@nvidia.com>
Subject: renames for Lorenzo's mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings patch
Date: Sat, 29 Aug 2026 10:02:02 -0400

rename some functions

Link: https://lore.kernel.org/DL1HIHWYJ7TB.1CY76SJS0V03L@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Cedric Le Goater <clg@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Saravanan D <saravanand@crusoe.ai>
Cc: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix-2
+++ a/mm/huge_memory.c
@@ -118,7 +118,7 @@ static bool vma_is_special_huge(const st
 	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
-static bool vma_bypass_thp_tuneables_file(const struct vm_area_struct *vma,
+static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
 		enum tva_type type)
 {
 	const bool has_huge_fault = vma->vm_ops->huge_fault;
@@ -132,7 +132,7 @@ static bool vma_bypass_thp_tuneables_fil
 	return false;
 }
 
-static bool vma_thp_tuneables_allow_file(vm_flags_t vm_flags)
+static bool vma_file_allow_thp_tuneables(vm_flags_t vm_flags)
 {
 	/* THP=always? */
 	if (hugepage_global_always())
@@ -143,11 +143,11 @@ static bool vma_thp_tuneables_allow_file
 	return false;
 }
 
-static bool vma_check_thp_tuneables_file(const struct vm_area_struct *vma,
+static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type type)
 {
-	return vma_bypass_thp_tuneables_file(vma, type) ||
-		vma_thp_tuneables_allow_file(vm_flags);
+	return vma_file_bypass_thp_tuneables(vma, type) ||
+		vma_file_allow_thp_tuneables(vm_flags);
 }
 
 static bool vma_can_map_huge_file(const struct vm_area_struct *vma,
@@ -159,7 +159,7 @@ static bool vma_can_map_huge_file(const
 	 * Enforce THP collapse requirements as necessary. Anonymous vmas
 	 * were already handled in thp_vma_allowable_orders().
 	 */
-	if (!vma_check_thp_tuneables_file(vma, vm_flags, type))
+	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
 		return false;
 
 	switch (type) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings-fix-2.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

