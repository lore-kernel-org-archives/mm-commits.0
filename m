Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744FE216602
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188384; cv=none; b=og+iTgbtNiu96wF2aKENvQXaZ2ICoMoUmBFVpDrymVYddExib8eKaplD/lAJPc3KYYLZW3XIvYY7pkxE9WUaohMxMv0VP4tGHtBVnzbDX/psJnKQjcphlQ4yBUmTiKazJH+Hq3wkih51sV9Ti2p2ZYUMuVCa/yThcikzloK44mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188384; c=relaxed/simple;
	bh=I55yfSnFrVP/XgxS29o3ik6sDFckopTHpxz9wnZ8tWo=;
	h=Date:To:From:Subject:Message-Id; b=lr1tgI+7Bx4Yi0BqGCqYBrOcs0OMyarCiHEHwS1nZChRkA3AVA9jDFmP+1Zuff/E0oQ0UljExOKlMinoFIqOHhv79omlkzqMuMduvsyTcQf6KqLTYSTKUN5HDo5qxrjwCQLxXTBOO7R9WaBoSKw1Qp/DwHuU1Edtqgivmug8Xj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VKcIagzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VKcIagzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A29C4CEEC;
	Mon, 17 Mar 2025 05:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188384;
	bh=I55yfSnFrVP/XgxS29o3ik6sDFckopTHpxz9wnZ8tWo=;
	h=Date:To:From:Subject:From;
	b=VKcIagzhPLGfLGRKOcviSdsRI98rPSSZvoU8UB73URVN90JY3nHI/l5fg8DGiusJs
	 r0h7ujKlvQdSuZEy+/7Z4JhrBFUi725fEMNCDVAX1uN5lGQp/ehcbKWr/G3DSM1abl
	 dOrMQvFpF8A2TyNhu47W6dZ1BlBuLkpFZ0jtwilg=
Date: Sun, 16 Mar 2025 22:13:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch removed from -mm tree
Message-Id: <20250317051304.48A29C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc
Date: Fri, 28 Feb 2025 18:29:16 +0000

Architectures that want pre-HVO of hugetlb vmemmap pages will need to call
hugetlb_bootmem_alloc from an earlier spot in boot (before sparse_init). 
To facilitate some architectures doing this, protect hugetlb_bootmem_alloc
against multiple calls.

Also provide a helper function to check if it's been called, so that the
early HVO code, to be added later, can see if there is anything to do.

Link: https://lkml.kernel.org/r/20250228182928.2645936-16-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    6 ++++++
 mm/hugetlb.c            |   12 ++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/hugetlb.h~mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc
+++ a/include/linux/hugetlb.h
@@ -175,6 +175,7 @@ extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
 void hugetlb_bootmem_alloc(void);
+bool hugetlb_bootmem_allocated(void);
 
 /* arch callbacks */
 
@@ -1263,6 +1264,11 @@ static inline bool hugetlbfs_pagecache_p
 static inline void hugetlb_bootmem_alloc(void)
 {
 }
+
+static inline bool hugetlb_bootmem_allocated(void)
+{
+	return false;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
--- a/mm/hugetlb.c~mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc
+++ a/mm/hugetlb.c
@@ -4918,16 +4918,28 @@ static int __init default_hugepagesz_set
 }
 hugetlb_early_param("default_hugepagesz", default_hugepagesz_setup);
 
+static bool __hugetlb_bootmem_allocated __initdata;
+
+bool __init hugetlb_bootmem_allocated(void)
+{
+	return __hugetlb_bootmem_allocated;
+}
+
 void __init hugetlb_bootmem_alloc(void)
 {
 	struct hstate *h;
 
+	if (__hugetlb_bootmem_allocated)
+		return;
+
 	hugetlb_parse_params();
 
 	for_each_hstate(h) {
 		if (hstate_is_gigantic(h))
 			hugetlb_hstate_alloc_pages(h);
 	}
+
+	__hugetlb_bootmem_allocated = true;
 }
 
 static unsigned int allowed_mems_nr(struct hstate *h)
_

Patches currently in -mm which might be from fvdl@google.com are


