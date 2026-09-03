Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589134FDE75
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 19:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788463411; cv=none; b=p+qYmo9SRIkbjihvP6gu5k7QKIj+lMYbLlCa3dUBKm6/T9tBWVO7Bf4/x/dFMFtUxDkillTpc+8SgemuJrAL/rgfLrHsd4rnSem0NyS3AljSsO1sFWso+rld3dmDY+p1WwzhTDk5R5fzV0+UUql1djmmvHAllVe8vj6/PYL2ZiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788463411; c=relaxed/simple;
	bh=D8B8spozbLIKoP3TT6ud/lLwUmxNdRHx0JUna1RH5GU=;
	h=Date:To:From:Subject:Message-Id; b=BHBUKaSam71LAToyqlFEfuB5IG/0SE8IVaccTUKZMl/+OWEMaT/6o5cDu6HAIe7c7IT3PbjjsZK5rTbXktdcySt0nzZc01Eolv2kkmQlqiIUbpWuxIJlq5S9FDjka/BQJBPnuOAlqsUwfc0+/NoGQdwmbH25T8cvWFHTFR+r95g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YBZ7q2RD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YBZ7q2RD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE091F00A3D;
	Thu,  3 Sep 2026 19:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788463398;
	bh=T7kISHY9RHu6lMMRlHBFn4eZcCcTZc7DQgPVrTm4upg=;
	h=Date:To:From:Subject;
	b=YBZ7q2RD4VbCwDe70EcL67mxLwktVUXAD01zOULFDPWvZyv9UlgiEgV5FnvdezvlO
	 QQ2/Hc4Fk76SPxP9nHxkk3MOxfZrXpxURdN9OF8/01ONzPIf4Cv1Qf9Mvi5b8REyn7
	 jtOteDyNMy8SJKNBJYY0xm7Z4r51VSXdUxN+6aWk=
Date: Thu, 03 Sep 2026 12:23:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,christosskarlos.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-various-coding-style-warnings.patch added to mm-new branch
Message-Id: <20260903192317.EDE091F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix various coding style warnings
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-fix-various-coding-style-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-various-coding-style-warnings.patch

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
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: mm/huge_memory: fix various coding style warnings
Date: Thu, 3 Sep 2026 12:22:00 +0300

Resolve coding style issues flagged by checkpatch.pl Specifically:
- Add missing blank lines after variable declarations.
- Remove unnecessary braces {} for a single statement block.

No functional changes are introduced.

Link: https://lore.kernel.org/20260903092200.88910-1-christosskarlos.kernel@gmail.com
Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-various-coding-style-warnings
+++ a/mm/huge_memory.c
@@ -1146,6 +1146,7 @@ subsys_initcall(hugepage_init);
 static int __init setup_transparent_hugepage(char *str)
 {
 	int ret = 0;
+
 	if (!str)
 		goto out;
 	if (!strcmp(str, "always")) {
@@ -1552,6 +1553,7 @@ static void set_huge_zero_folio(pgtable_
 		struct folio *zero_folio)
 {
 	pmd_t entry;
+
 	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
 	entry = pmd_mkspecial(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
@@ -2661,6 +2663,7 @@ bool move_huge_pmd(struct vm_area_struct
 
 		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
 			pgtable_t pgtable;
+
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
@@ -3949,9 +3952,8 @@ int folio_check_splittable(struct folio
 	 * swapcache folio split. Only uniform split to order-0 can be used
 	 * here.
 	 */
-	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio))
 		return -EINVAL;
-	}
 
 	if (is_huge_zero_folio(folio))
 		return -EINVAL;
_

Patches currently in -mm which might be from christosskarlos.kernel@gmail.com are

mm-huge_memory-fix-various-coding-style-warnings.patch

