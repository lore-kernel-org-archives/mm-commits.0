Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C847216602
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188400; cv=none; b=L+CoxAY7xDhtjJGqnHZMJLDi0d41ju0anJRZvGIf5iOky+2AfFass+dbSESHxH8/GTzSYtN3vdKt5KTPxGuDpJFJG20gt1OOPymtyMYcU+7U6xT3kHHBDYkfo6I2EPp8z6qZTVS1FVpxPzfaiyHhPJdDbQ9VFvIfZQW+IRRPt6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188400; c=relaxed/simple;
	bh=LiYCNTdvR7RYVB7vfTI3Yc7l5L2SCbiX8bHLMZj90kU=;
	h=Date:To:From:Subject:Message-Id; b=FzjxhFabqRjY4v4rD4dAg96k0TL3YuHHi3ZfR3yXSZ9218S7QkQKJEOSZdObpeEOkLhT4HNRY6f96s++Cnd6QKMu6QLDtVHdCpGlYlbx6IeJB1LFT5GV9e83qMVmDykffenVodpp2tpN2J5ju6DRa16dweySeeU0qfecPl/Asuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hGAPDPn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hGAPDPn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705AAC4CEEC;
	Mon, 17 Mar 2025 05:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188400;
	bh=LiYCNTdvR7RYVB7vfTI3Yc7l5L2SCbiX8bHLMZj90kU=;
	h=Date:To:From:Subject:From;
	b=hGAPDPn/v6HPlybtnJWEq8vdh/N4OH6WiARes+yRh7K5z0bkg4FJvqkBrAZMceoX3
	 aLqvuP5rJ9hceYPHagZb/A49RRwkWrL6WH3izP4sF/+NB+6fU7SQA+5Yb8O7FoGKYY
	 PBPYmQJ0edmmqfkbytL+thdwb25t0fJq125z+Wp0=
Date: Sun, 16 Mar 2025 22:13:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch removed from -mm tree
Message-Id: <20250317051320.705AAC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: add hugetlb_cma_only cmdline option
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-hugetlb_cma_only-cmdline-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/hugetlb: add hugetlb_cma_only cmdline option
Date: Fri, 28 Feb 2025 18:29:26 +0000

Add an option to force hugetlb gigantic pages to be allocated using CMA
only (if hugetlb_cma is enabled).  This avoids a fallback to allocation
from the rest of system memory if the CMA allocation fails.  This makes
the size of hugetlb_cma a hard upper boundary for gigantic hugetlb page
allocations.

This is useful because, with a large CMA area, the kernel's unmovable
allocations will have less room to work with and it is undesirable for new
hugetlb gigantic page allocations to be done from that remaining area.  It
will eat in to the space available for unmovable allocations, leading to
unwanted system behavior (OOMs because the kernel fails to do unmovable
allocations).

So, with this enabled, an administrator can force a hard upper bound for
runtime gigantic page allocations, and have more predictable system
behavior.

Link: https://lkml.kernel.org/r/20250228182928.2645936-26-fvdl@google.com
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

 Documentation/admin-guide/kernel-parameters.txt |    7 +++++++
 mm/hugetlb.c                                    |   14 ++++++++++++++
 2 files changed, 21 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb-add-hugetlb_cma_only-cmdline-option
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1892,6 +1892,13 @@
 			hugepages using the CMA allocator. If enabled, the
 			boot-time allocation of gigantic hugepages is skipped.
 
+	hugetlb_cma_only=
+			[HW,CMA,EARLY] When allocating new HugeTLB pages, only
+			try to allocate from the CMA areas.
+
+			This option does nothing if hugetlb_cma= is not also
+			specified.
+
 	hugetlb_free_vmemmap=
 			[KNL] Requires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 			enabled.
--- a/mm/hugetlb.c~mm-hugetlb-add-hugetlb_cma_only-cmdline-option
+++ a/mm/hugetlb.c
@@ -59,6 +59,7 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 static struct cma *hugetlb_cma[MAX_NUMNODES];
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 #endif
+static bool hugetlb_cma_only;
 static unsigned long hugetlb_cma_size __initdata;
 
 __initdata struct list_head huge_boot_pages[MAX_NUMNODES];
@@ -1510,6 +1511,9 @@ retry:
 	}
 #endif
 	if (!folio) {
+		if (hugetlb_cma_only)
+			return NULL;
+
 		folio = folio_alloc_gigantic(order, gfp_mask, nid, nodemask);
 		if (!folio)
 			return NULL;
@@ -4750,6 +4754,9 @@ static __init void hugetlb_parse_params(
 
 		hcp->setup(hcp->val);
 	}
+
+	if (!hugetlb_cma_size)
+		hugetlb_cma_only = false;
 }
 
 /*
@@ -7862,6 +7869,13 @@ static int __init cmdline_parse_hugetlb_
 
 early_param("hugetlb_cma", cmdline_parse_hugetlb_cma);
 
+static int __init cmdline_parse_hugetlb_cma_only(char *p)
+{
+	return kstrtobool(p, &hugetlb_cma_only);
+}
+
+early_param("hugetlb_cma_only", cmdline_parse_hugetlb_cma_only);
+
 void __init hugetlb_cma_reserve(int order)
 {
 	unsigned long size, reserved, per_node;
_

Patches currently in -mm which might be from fvdl@google.com are


