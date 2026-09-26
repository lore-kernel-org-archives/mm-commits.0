Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E2949D5A0
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456146; cv=none; b=rY7TqET+PPfwQI6cC1wUlyX0FFILr81iVZjgjwKhIPwBA0sHcgv2Lnk+8fWaXasZg/CngQeb4U4G8G1GsyyAcuIDjIjMlwTCnr30oNCDcImS0T+mUJPQM4a3I/Gcui1a6sBbGPmAL4/1OOhJpO+pTdOjTmw6bH+C8l3eEnFv4eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456146; c=relaxed/simple;
	bh=mdCYyet81dlGTaB6UWUJtf0n4D9hEhntIbt9pczUdKQ=;
	h=Date:To:From:Subject:Message-Id; b=i52LpZG3yRFBaTq0eBBf4tua+BB0WC71M/jAPJREoU2jOd8aSj4QiOtwd6sHP4fXYCblDEwF1FkvMLG49qMHfsqCzfCc61Alr+k/o0bcq8gmEAR8stne2gOhZbYcLUACja9euQsLnml5SGOV6UDGI0FHB1WJlhRNeMF2bv/9lkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y67DPhEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y67DPhEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEF81F00893;
	Sat, 26 Sep 2026 20:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456145;
	bh=GDNWifvSyKwJHY4btem6Z6OLJ5n+Jx1a3y9Lg+HQ/3s=;
	h=Date:To:From:Subject;
	b=Y67DPhEkWGf30nzRDLj0+bezELWwgFknR73ngVBKJADyIPkAne5lkxZZQSR1zASVn
	 tQnAVZ7Y2nQokUuRInXi0M5Pugok0Xv++W8CVJl8YAOTHUYpRght9WzJybvE+5kg+4
	 abl7IkluIAUIOsxmH1FGP94xDjfKDMCX3rE4ukd8=
Date: Sat, 26 Sep 2026 13:55:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,byungchul@sk.com,apopple@nvidia.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch removed from -mm tree
Message-Id: <20260926205545.6BEF81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: make Gregory a co-maintainer of MEMORY MANAGEMENT - NUMA PLACEMENT
has been removed from the -mm tree.  Its filename was
     maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: make Gregory a co-maintainer of MEMORY MANAGEMENT - NUMA PLACEMENT
Date: Fri, 18 Sep 2026 18:34:26 +0200

Gregory is extremely familiar with NUMA placement handling and volunteer
to help co-maintain the numa placement bits.  So add him as a
co-maintainer.

Link: https://lore.kernel.org/20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement
+++ a/MAINTAINERS
@@ -17301,10 +17301,10 @@ F:	mm/numa_memblks.c
 MEMORY MANAGEMENT - NUMA PLACEMENT
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
+M:	Gregory Price <gourry@gourry.net>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Joshua Hahn <joshua.hahnjy@gmail.com>
 R:	Rakie Kim <rakie.kim@sk.com>
-R:	Gregory Price <gourry@gourry.net>
 R:	Ying Huang <ying.huang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from david@kernel.org are

selftests-mm-khugepaged-remove-str_dup-usage.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch

