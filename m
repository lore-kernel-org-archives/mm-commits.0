Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6EA3921E9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298467; cv=none; b=riFjhArUxjIeisQURu+R4WJs3OWtuVILKLAeXCl/wFFGeclYuayXEN2DGRFjHEaehewIvAuY7E4cORDWRMwp9VQoEvPWwI50EPGFaLCmob79P5sMSeG8buZtT66PqJnEcX4/1HivzAs80BMz0Aa6ptrpJzeN0OpivQkOcDyxU/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298467; c=relaxed/simple;
	bh=f/v7cIr1Pqu8FQ2evEB1ObN6yPbHiE9DzqzpxKQVj10=;
	h=Date:To:From:Subject:Message-Id; b=lF743IxApZrZ76C6gcW3zzkqZKv3nIejZBZIL51bG4txSDWCmgNEOa1Oo8Onz9yTjsEEFHbkX/3LKGzeadlUBIiLPTXusE8qJUs6A+mps0tpQd1mpmiS9p2vBwrxRhh1rB6Xy8Hg5ZolDNNJ4/27npuouLD5KJsURzP/BHZv8bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wlE6VjUF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wlE6VjUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E531F000E9;
	Wed, 29 Jul 2026 04:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298466;
	bh=t8lt7MtL5+GMLP+ENBc+/olfCoLvEVO8Rdj+nqX9dZI=;
	h=Date:To:From:Subject;
	b=wlE6VjUF0+aGA1iKjS8hG3F8VTabpjFQiX8H/6x0jP+4yP6QNSr/bkLVWzDaSEYrX
	 PBcpOX6m+eVI2Vdvegq3Sl5xjRgmte+PyPQTKVuYIoGojb1cKmo0/txJ+N0+szzhBu
	 ny/G4+ovSlt+KbpqfDWd2LLP+u01e5t1mOfCuwtY=
Date: Tue, 28 Jul 2026 21:14:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch removed from -mm tree
Message-Id: <20260729041426.81E531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: move sparse_vmemmap_init_nid_late() into sparse_init_nid()
has been removed from the -mm tree.  Its filename was
     mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: move sparse_vmemmap_init_nid_late() into sparse_init_nid()
Date: Fri, 12 Jun 2026 11:58:55 +0800

sparse_vmemmap_init_nid_late() is still called separately from
mm_core_init_early(), away from the rest of the sparse initialization
path.

Now that sparse_init() runs after zone initialization, call
sparse_vmemmap_init_nid_late() from sparse_init_nid() instead.  This keeps
both sparse_vmemmap_init_nid_early() and sparse_vmemmap_init_nid_late() in
the sparse setup path.

Link: https://lore.kernel.org/20260612035903.2468601-12-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    4 ----
 mm/sparse.c  |    1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/mm/mm_init.c~mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid
+++ a/mm/mm_init.c
@@ -2681,16 +2681,12 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
-	int nid;
-
 	free_area_init();
 
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	sparse_init();
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
 	memmap_init();
 }
 
--- a/mm/sparse.c~mm-sparse-move-sparse_vmemmap_init_nid_late-into-sparse_init_nid
+++ a/mm/sparse.c
@@ -320,6 +320,7 @@ static void __init sparse_init_nid(int n
 		}
 	}
 	sparse_usage_fini();
+	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

