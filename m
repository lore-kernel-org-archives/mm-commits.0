Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3394D7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103973; cv=none; b=Zw6tW4aiTcUJae6goMVZylXLukQXUKq4HlTkNclaZvuNIuRw+OSEEcZ/7IS42pgBIQuek8EOAvI3BfFqwz3OUFRgNXfMSaoMD+0QXCFTV/2/sOZTFog211XGOBBjZDtEGGtuqddBCtvMZvqDxFJu3M6Qo2cRdqIjroa4ewkaRKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103973; c=relaxed/simple;
	bh=wPG3xF2S5Bzo9P25k4sOXcI7Lf42BHbM1Qk7Yt2etA0=;
	h=Date:To:From:Subject:Message-Id; b=bL4It5QBifrZJOUBGXITBVNvqaJ6oCBj+clfZKBVrqAqvzzrO5hChMhTPemJPSEzPCzZDCXHGGIgrJqaVPG1VPxDzJ+Y3RTT0IHKOsZAaYmCJkQVeomPk6JB0jHZ/vaFqQ9iBl7Uv0qOs8aCIIfljR2xP2s4hCi1bzVL5Roe5Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zscV0SDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zscV0SDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DFFC116B1;
	Fri, 26 Apr 2024 03:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103973;
	bh=wPG3xF2S5Bzo9P25k4sOXcI7Lf42BHbM1Qk7Yt2etA0=;
	h=Date:To:From:Subject:From;
	b=zscV0SDfWTT3D0pHMMg273JHyh3wqF0nRF+BaPqDMtA7QfGerS3ymWfC0vQz5itst
	 9QfswP+Dm66qL/MS1mvRea3E9bS8b1QDBhpPJqdFjVjVpqt1VJeYw4Gk8yjAQLHQud
	 z1j2R91E7IxiKnydmxpVlTgjIgHMlaWuP8076o3Y=
Date: Thu, 25 Apr 2024 20:59:32 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,linmiaohe@huawei.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-record-the-migration-reason-for-struct-migration_target_control.patch removed from -mm tree
Message-Id: <20240426035933.07DFFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: record the migration reason for struct migration_target_control
has been removed from the -mm tree.  Its filename was
     mm-record-the-migration-reason-for-struct-migration_target_control.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: record the migration reason for struct migration_target_control
Date: Wed, 6 Mar 2024 18:13:26 +0800

Patch series "make the hugetlb migration strategy consistent", v2.

As discussed in previous thread [1], there is an inconsistency when
handling hugetlb migration.  When handling the migration of freed hugetlb,
it prevents fallback to other NUMA nodes in
alloc_and_dissolve_hugetlb_folio().  However, when dealing with in-use
hugetlb, it allows fallback to other NUMA nodes in
alloc_hugetlb_folio_nodemask(), which can break the per-node hugetlb pool
and might result in unexpected failures when node bound workloads doesn't
get what is asssumed available.

This patchset tries to make the hugetlb migration strategy more clear
and consistent. Please find details in each patch.

[1]
https://lore.kernel.org/all/6f26ce22d2fcd523418a085f2c588fe0776d46e7.1706794035.git.baolin.wang@linux.alibaba.com/


This patch (of 2):

To support different hugetlb allocation strategies during hugetlb
migration based on various migration reasons, record the migration reason
in the migration_target_control structure as a preparation.

Link: https://lkml.kernel.org/r/cover.1709719720.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/7b95d4981e07211f57139fc5b1f7ce91b920cee4.1709719720.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c            |    1 +
 mm/internal.h       |    1 +
 mm/memory-failure.c |    1 +
 mm/memory_hotplug.c |    1 +
 mm/mempolicy.c      |    1 +
 mm/migrate.c        |    1 +
 mm/page_alloc.c     |    1 +
 mm/vmscan.c         |    3 ++-
 8 files changed, 9 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-record-the-migration-reason-for-struct-migration_target_control
+++ a/mm/gup.c
@@ -2145,6 +2145,7 @@ static int migrate_longterm_unpinnable_p
 		struct migration_target_control mtc = {
 			.nid = NUMA_NO_NODE,
 			.gfp_mask = GFP_USER | __GFP_NOWARN,
+			.reason = MR_LONGTERM_PIN,
 		};
 
 		if (migrate_pages(movable_page_list, alloc_migration_target,
--- a/mm/internal.h~mm-record-the-migration-reason-for-struct-migration_target_control
+++ a/mm/internal.h
@@ -1045,6 +1045,7 @@ struct migration_target_control {
 	int nid;		/* preferred node id */
 	nodemask_t *nmask;
 	gfp_t gfp_mask;
+	enum migrate_reason reason;
 };
 
 /*
--- a/mm/memory-failure.c~mm-record-the-migration-reason-for-struct-migration_target_control
+++ a/mm/memory-failure.c
@@ -2669,6 +2669,7 @@ static int soft_offline_in_use_page(stru
 	struct migration_target_control mtc = {
 		.nid = NUMA_NO_NODE,
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+		.reason = MR_MEMORY_FAILURE,
 	};
 
 	if (!huge && folio_test_large(folio)) {
--- a/mm/memory_hotplug.c~mm-record-the-migration-reason-for-struct-migration_target_control
+++ a/mm/memory_hotplug.c
@@ -1841,6 +1841,7 @@ static void do_migrate_range(unsigned lo
 		struct migration_target_control mtc = {
 			.nmask = &nmask,
 			.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+			.reason = MR_MEMORY_HOTPLUG,
 		};
 		int ret;
 
--- a/mm/mempolicy.c~mm-record-the-migration-reason-for-struct-migration_target_control
+++ a/mm/mempolicy.c
@@ -1070,6 +1070,7 @@ static long migrate_to_node(struct mm_st
 	struct migration_target_control mtc = {
 		.nid = dest,
 		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
+		.reason = MR_SYSCALL,
 	};
 
 	nodes_clear(nmask);
--- a/mm/migrate.c~mm-record-the-migration-reason-for-struct-migration_target_control
+++ a/mm/migrate.c
@@ -2060,6 +2060,7 @@ static int do_move_pages_to_node(struct
 	struct migration_target_control mtc = {
 		.nid = node,
 		.gfp_mask = GFP_HIGHUSER_MOVABLE | __GFP_THISNODE,
+		.reason = MR_SYSCALL,
 	};
 
 	err = migrate_pages(pagelist, alloc_migration_target, NULL,
--- a/mm/page_alloc.c~mm-record-the-migration-reason-for-struct-migration_target_control
+++ a/mm/page_alloc.c
@@ -6351,6 +6351,7 @@ int __alloc_contig_migrate_range(struct
 	struct migration_target_control mtc = {
 		.nid = zone_to_nid(cc->zone),
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
+		.reason = MR_CONTIG_RANGE,
 	};
 	struct page *page;
 	unsigned long total_mapped = 0;
--- a/mm/vmscan.c~mm-record-the-migration-reason-for-struct-migration_target_control
+++ a/mm/vmscan.c
@@ -967,7 +967,8 @@ static unsigned int demote_folio_list(st
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOWARN |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
 		.nid = target_nid,
-		.nmask = &allowed_mask
+		.nmask = &allowed_mask,
+		.reason = MR_DEMOTION,
 	};
 
 	if (list_empty(demote_folios))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-page_alloc-allowing-mthp-compaction-to-capture-the-freed-page-directly.patch

