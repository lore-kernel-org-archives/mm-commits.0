Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E850E49620
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 00:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172076; cv=none; b=R7gS74AoMRyPuwYdyC8qBY9hJWl8aSFPBcH45D57bKm9DTFfp11JzVpoTOUymw9MBLrQpX3qmtzXYIQdF9tExxne+AkZMFDmjSdOrFmz7Sd22fqfS1uHNZwm7eu4ehYPK8+P18zeE+1D3ENp+4iXVMQkr3nGbviqwV6tZSPC7yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172076; c=relaxed/simple;
	bh=PwEH6i+k74xyxFVjSV1KIBwyPBbE24dejflu4XiVuLE=;
	h=Date:To:From:Subject:Message-Id; b=jDBtCzWiLeg4tonPq933pNEuSThG21D1Qma1OirG/ZkydXW0zPDdqQ6+gsyIUbdc20mRoAhISQLK45LVJjg7Jb0giZOfFnpUpIkI3E8pfuirpYXffndeyLfynrKTKkqabTMco+xx0t9KHN/ElaPHoGlN2Th30Yg/XMpjkPQwv8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yx02s8LF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yx02s8LF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60062C4CEDD;
	Mon, 17 Mar 2025 00:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172074;
	bh=PwEH6i+k74xyxFVjSV1KIBwyPBbE24dejflu4XiVuLE=;
	h=Date:To:From:Subject:From;
	b=yx02s8LFV1SvWdnecaPYNFuoePxPLHl7oOmgcgxqIs9UFXcH8cqqGVTz40Tt0fImg
	 Q5hF7uBNyAzu2rDTbFoN3rHM3lOGqwHKNJKdjp1dEmtSvrVz8V0ul3iMlIFxGCjQoh
	 lzO3juGhHBfs8Fwae04LhmlzxcAs6CxrczAn249s=
Date: Sun, 16 Mar 2025 17:41:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,vbabka@suse.cz,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vma-do-not-register-private-anon-mappings-with-khugepaged-during-mmap.patch removed from -mm tree
Message-Id: <20250317004114.60062C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: do not register private-anon mappings with khugepaged during mmap
has been removed from the -mm tree.  Its filename was
     mm-vma-do-not-register-private-anon-mappings-with-khugepaged-during-mmap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/vma: do not register private-anon mappings with khugepaged during mmap
Date: Thu, 6 Mar 2025 12:00:37 +0530

We already are registering private-anon VMAs with khugepaged during fault
time, in do_huge_pmd_anonymous_page().  Commit "register suitable readonly
file vmas for khugepaged" moved the khugepaged registration logic from
shmem_mmap to the generic mmap path.

The userspace-visible effect should be this: khugepaged will unnecessarily
scan mm's which haven't yet faulted in.  Note that it won't actually
collapse because all PTEs are none.

Now that I think about it, the mm is going to have a file VMA anyways
during fork+exec, so the mm already gets registered during mmap due to the
non-anon case (I *think*), so at least one of either the mmap registration
or fault-time registration is redundant.

Make this logic specific for non-anon mappings.

Link: https://lkml.kernel.org/r/20250306063037.16299-1-dev.jain@arm.com
Fixes: 613bec092fe7 ("mm: mmap: register suitable readonly file vmas for khugepaged")
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-do-not-register-private-anon-mappings-with-khugepaged-during-mmap
+++ a/mm/vma.c
@@ -2381,7 +2381,8 @@ static int __mmap_new_vma(struct mmap_st
 	 * vma_merge_new_range() calls khugepaged_enter_vma() too, the below
 	 * call covers the non-merge case.
 	 */
-	khugepaged_enter_vma(vma, map->flags);
+	if (!vma_is_anonymous(vma))
+		khugepaged_enter_vma(vma, map->flags);
 	ksm_add_vma(vma);
 	*vmap = vma;
 	return 0;
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-remove-redundant-return-in-set_huge_zero_folio.patch

