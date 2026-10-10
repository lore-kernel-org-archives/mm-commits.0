Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64B0367297
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 20:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791665003; cv=none; b=SoDrrIp83NEeGUq50/S8ImlDPHedv2qovGQ9w6pMt1ikzY8AU4POYP++d0qxrYl+ZBI2Z7reeH73eGznGzXJbaLqQ3UTvimC8DBLUyB24LVnj4LPFDPvDQF4UVSaDVD6cSvshSPCBQLERn31AcyTCmIczucPC3bU0U6Ot1rb/jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791665003; c=relaxed/simple;
	bh=/dqtYMxuhPPRhUhaUw/thY3igQD0agOoykzCpom10DY=;
	h=Date:To:From:Subject:Message-Id; b=onR4zEbM0tdSiAPCZtz8j/3ePBmMOnQE3clEKO0bHAFOREQiGbDxk2gF5scfeWWF8HZ2T0bGgZzZQy9gdreclBO42hQglxvU3JKgE9XtvYnIWK7p5K8tIBOBDJRj7mqip8k3cStyEu+lDSIdsawPHvgu3RHeSjo5UoMxAdciQX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aBgCFoRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aBgCFoRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18B61F000FF;
	Sat, 10 Oct 2026 20:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791665001;
	bh=1OjZlEuJbunIigT0bV+yT5DI369xLZ7yWI+Ey+8y5YU=;
	h=Date:To:From:Subject;
	b=aBgCFoRfwaMTI7MJZSa0eqULN9TfFQ+I7c1ZFqXgBWZIeomRStzMZou+Wg8Z2rZod
	 j0k2csOgAwet4PXF/whJr92GeCm+d+vT9Qofa4mhHE6dOj077SYDAt5hAexgLsvjKd
	 3ECdsPg523NLhNVyAKLQV1BA/PpojC4PvBrGCoA0=
Date: Sat, 10 Oct 2026 13:43:21 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-add-zone-mismatch-warning-during-page-init-fix.patch added to mm-unstable branch
Message-Id: <20261010204321.D18B61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! mm/mm_init: add zone mismatch warning during page init
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-add-zone-mismatch-warning-during-page-init-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-add-zone-mismatch-warning-during-page-init-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Muchun Song <muchun.song@linux.dev>
Subject: fixup! mm/mm_init: add zone mismatch warning during page init
Date: Sat, 10 Oct 2026 19:55:23 +0800

Document the ordering of shared and retained struct page initialization.

Link: https://lore.kernel.org/20261010115523.4005071-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Lance Yang <lance.yang@linux.dev>
---

 mm/mm_init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mm_init.c~mm-mm_init-add-zone-mismatch-warning-during-page-init-fix
+++ a/mm/mm_init.c
@@ -618,6 +618,10 @@ void __meminit __init_single_page(struct
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	/*
+	 * Shared tail struct pages are initialized during vmemmap population,
+	 * before retained struct pages reach here.
+	 */
 	vmemmap_optimization_verify_zone(page);
 }
 
_

Patches currently in -mm which might be from muchun.song@linux.dev are

mm-sparse-vmemmap-drop-vmemmap_populate_dax.patch
mm-sparse-vmemmap-support-device-dax-in-common-vmemmap-path.patch
mm-sparse-vmemmap-drop-device-dax-specific-population-path.patch
mm-sparse-vmemmap-remove-the-unused-ptpfn-argument.patch
mm-sparse-vmemmap-open-code-vmemmap_populate_address.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init.patch
mm-mm_init-add-zone-mismatch-warning-during-page-init-fix.patch
mm-fix-missing-page-table-destructor-in-pagetable_free.patch
riscv-mm-fix-hotplug-page-table-destructor-handling.patch
riscv-mm-fix-missing-destructor-for-hotplug-pud-tables.patch
arm64-mm-fix-destructor-for-unconstructed-hotplug-page-tables.patch

