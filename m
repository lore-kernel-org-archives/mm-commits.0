Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2842475E3
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498956; cv=none; b=hKza9tsmaDg31IfE0A8IdJmJ3M2nVrGucktOkcQDSxBn6yEn3WwpqKKMo9Qnec3zoISFCTEEXGmcCw3xz9456f+St7RSQ8jJSS5w4rcDGPq/TVse8MqB6CGMqwzFYpMWX6gie6bGfbXwoX4FNLcu8BexumffCBxVT02D2w319es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498956; c=relaxed/simple;
	bh=c9dtGgcxkLSYI/Mj62HdVa3VmifB5Drtikb0q8LpDOc=;
	h=Date:To:From:Subject:Message-Id; b=Awkp3TTI6q+pd2kDmg3fPrsnxglCw237IiaY8ASart/xUVfpb5KN7hCniZ039SHKZVDrjWWaSHo8v6IA9GQP8AbEw4kXu+twnCBdIscNYLFT9+Gl0lgmBlct6TEqYNAVs++FOeGcF6ltFgmgWEpvd8cLl/S1pCj7W6qPFDY0e4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t/c45KRv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t/c45KRv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFCEC19424;
	Sat, 18 Apr 2026 07:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498956;
	bh=c9dtGgcxkLSYI/Mj62HdVa3VmifB5Drtikb0q8LpDOc=;
	h=Date:To:From:Subject:From;
	b=t/c45KRvNFeeAOUc8PhxFpHheYl+FNwnIMF/OoniZ8LMWbWTm86Loay38vOK1JFi7
	 D4DTMs5BVbKhJF/YZILvlwFF2O/82rVOR98PQLpAofSW/g8ay0nxyQDEMh0DyDkxVR
	 dKJ/+HiX78eeKaBqqYohMgIwDW/RfZ0EiEUfv9R0=
Date: Sat, 18 Apr 2026 00:55:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,fvdl@google.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path.patch removed from -mm tree
Message-Id: <20260418075555.9BFCEC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: fix preinited section_mem_map clobbering on failure path
has been removed from the -mm tree.  Its filename was
     mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: fix preinited section_mem_map clobbering on failure path
Date: Tue, 31 Mar 2026 19:37:24 +0800

sparse_init_nid() is careful to leave alone every section whose vmemmap
has already been set up by sparse_vmemmap_init_nid_early(); it only clears
section_mem_map for the rest:

        if (!preinited_vmemmap_section(ms))
                ms->section_mem_map = 0;

A leftover line after that conditional block

        ms->section_mem_map = 0;

was supposed to be deleted but was missed in the failure path, causing the
field to be overwritten for all sections when memory allocation fails,
effectively destroying the pre-initialization check.

Drop the stray assignment so that preinited sections retain their
already valid state.

Those pre-inited sections (HugeTLB pages) are not activated.  However,
such failures are extremely rare, so I don't see any major userspace
issues.

Link: https://lore.kernel.org/20260331113724.2080833-1-songmuchun@bytedance.com
Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section init at boot")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/sparse.c~mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path
+++ a/mm/sparse.c
@@ -403,7 +403,6 @@ failed:
 		ms = __nr_to_section(pnum);
 		if (!preinited_vmemmap_section(ms))
 			ms->section_mem_map = 0;
-		ms->section_mem_map = 0;
 	}
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


