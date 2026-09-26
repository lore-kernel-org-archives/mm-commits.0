Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB6F39C637
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456145; cv=none; b=fTIW2eIicwuA5oqIlbR2eTmv7vxABnj/HCHdGO/IOuXK5EbojzkbNiwIHLZ0ZgAtoeVzG1SbXE430lVV4WiPeOnQAiL0ARemY5rO6IZ5amZhsYPKXwqTv548v/HzelWSMd1Kfn0I6PgeyzIu4o7T6Qzxx+i5rfei07zplDUBzm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456145; c=relaxed/simple;
	bh=XatcBZwofyzXSkjC2MZmaJdz2SVmzREAHqQKdVX4r7g=;
	h=Date:To:From:Subject:Message-Id; b=t+Ts0q/5UxOOKSN7a/UUQrVsFqnqbmPZmdsMEX9Bl2bGUNU1W5KfWt9n8jmrmh0X3arvqIGzNO2gu07TU/3U+HnQZygN+Cn/LMdvt0dqvZ3LjAMROFr/Hy1uNBb4cKmIJwgpuNDXX4PecUqpBoRwT3WUnAxMuNBSlDJSddzroAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oBtsv8mE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oBtsv8mE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D3E1F000FF;
	Sat, 26 Sep 2026 20:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456144;
	bh=S0TI5hBOGIWDKegq8iAFpqJtP9NKZB8Vu/M9KSZVDTQ=;
	h=Date:To:From:Subject;
	b=oBtsv8mEK+APIGiYdRVedWobpvHk8Vun1YoJP2Jl1ueaMmvwYb7sR7UCbKQEnADBj
	 GFbbnMP/dvqXeqmo2hT5AIDIqbJoei9BjT2ovZ6FxwXOmsDy8i9AXUk4Uwyr5RKtuu
	 hejCayq5NbRv5Ky6fgY39cDR6R5T+i+GVbi16Tsc=
Date: Sat, 26 Sep 2026 13:55:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,byungchul@sk.com,apopple@nvidia.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-move-memory-tiering-under-memory-management-numa-placement.patch removed from -mm tree
Message-Id: <20260926205544.43D3E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: move memory tiering under MEMORY MANAGEMENT - NUMA PLACEMENT
has been removed from the -mm tree.  Its filename was
     maintainers-move-memory-tiering-under-memory-management-numa-placement.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: move memory tiering under MEMORY MANAGEMENT - NUMA PLACEMENT
Date: Fri, 18 Sep 2026 18:34:25 +0200

NUMA PLACEMENT is a better place for memory tiering.

My best guess is that existing MISC reviewers are not that interested in
memory tiering, so don't carry any over.

Link: https://lore.kernel.org/20260918-maintainers-mempolicy-v1-2-9a94cac6d135@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-byt: SJ Park <sj@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-move-memory-tiering-under-memory-management-numa-placement
+++ a/MAINTAINERS
@@ -17264,7 +17264,6 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/ABI/testing/sysfs-kernel-mm
 F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
-F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
@@ -17272,7 +17271,6 @@ F:	drivers/char/mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
-F:	include/linux/memory-tiers.h
 F:	include/linux/page_idle.h
 F:	mm/backing-dev.c
 F:	mm/cma.c
@@ -17284,7 +17282,6 @@ F:	mm/early_ioremap.c
 F:	mm/fadvise.c
 F:	mm/ioremap.c
 F:	mm/mapping_dirty_helpers.c
-F:	mm/memory-tiers.c
 F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
@@ -17313,10 +17310,13 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
+F:	mm/memory-tiers.c
 F:	mm/mempolicy.c
 
 MEMORY MANAGEMENT - OOM KILLER
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

