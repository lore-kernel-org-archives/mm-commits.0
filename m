Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60F1392806
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298464; cv=none; b=Hi5gNeJ1Afc18ZonUUl85nc4bYabdqkEsv3Gylm/OCoERqP5790cCq5JoyBqjxHGKJDWSSVdu3FMg4/Tc2zBJmFVC0sz8xl92PTxM4cGukTENK5wM6+y65Ey4ailwSQmCEsalCN7I9cDw4cLVwEsEeJyAEYjAfIsiikgXhEqvoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298464; c=relaxed/simple;
	bh=PK8qNulueFVBGPAzzpYGtq0TeEEYh2KNGQQm4QbGrp0=;
	h=Date:To:From:Subject:Message-Id; b=MB8W/ZIu1cDf8a45FYxGwCj50yc7TuTM7+gyy1E3rDPqc827kD9LPt8f+NCg/Ff3HhniC/k3rgeH6RvHbyPlTQZQIs1NrEvJrkxQMqY9EQ8TyBhwNBvAwDNMb6KDQ/K4Jtd16o7AnpDruoQtjMUfOrczpj29vr0z+kGycPnXWHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HzbarsOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HzbarsOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8B31F00A3E;
	Wed, 29 Jul 2026 04:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298462;
	bh=E4DsGD94K64pBI0pXZjk2g/oTrGALK5BT8UNj5ipJjk=;
	h=Date:To:From:Subject;
	b=HzbarsOhmBssv0gv9/0n+eLA5GmwBYC5Oc7aDjkbDmKztiy/CLK1mMKsGRmd0IPCW
	 ukXiMo8N39OTLrvsEylwO3MZlgeD42TgtBYa2XxR8E3oHkdZW+3wdddyg+HsOT5Hdj
	 D+rxWRN5CkJrj9QnoCO8aejdnxvvOmxiujKaJVag=
Date: Tue, 28 Jul 2026 21:14:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch removed from -mm tree
Message-Id: <20260729041422.BC8B31F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: defer sparse_init() until after zone initialization
has been removed from the -mm tree.  Its filename was
     mm-mm_init-defer-sparse_init-until-after-zone-initialization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: defer sparse_init() until after zone initialization
Date: Fri, 12 Jun 2026 11:58:52 +0800

free_area_init() is responsible for initializing pgdat and zone state. 
Calling sparse_init() from there mixes in later vmemmap and struct page
setup, which makes the initialization flow less clear.

Defer sparse_init(), sparse_vmemmap_init_nid_late(), and memmap_init()
until after free_area_init() completes, when zone initialization is fully
done.  This keeps free_area_init() focused on zone setup and ensures that
sparse_init() runs with the relevant zone state already available.

This is also a prerequisite for later hugetlb vmemmap changes that need
zone information during early sparse vmemmap setup.

Link: https://lore.kernel.org/20260612035903.2468601-9-songmuchun@bytedance.com
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

 mm/mm_init.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-defer-sparse_init-until-after-zone-initialization
+++ a/mm/mm_init.c
@@ -1821,7 +1821,6 @@ static void __init free_area_init(void)
 	bool descending;
 
 	arch_zone_limits_init(max_zone_pfn);
-	sparse_init();
 
 	start_pfn = PHYS_PFN(memblock_start_of_DRAM());
 	descending = arch_has_descending_max_zone_pfns();
@@ -1910,11 +1909,7 @@ static void __init free_area_init(void)
 		}
 	}
 
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
-
 	calc_nr_kernel_pages();
-	memmap_init();
 
 	/* disable hash distribution for systems with a single node */
 	fixup_hashdist();
@@ -2686,10 +2681,17 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	int nid;
+
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	free_area_init();
+
+	sparse_init();
+	for_each_node_state(nid, N_MEMORY)
+		sparse_vmemmap_init_nid_late(nid);
+	memmap_init();
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

