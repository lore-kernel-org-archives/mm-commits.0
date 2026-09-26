Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A644A1DED
	for <mm-commits@vger.kernel.org>; Sat, 26 Sep 2026 20:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456144; cv=none; b=KcGvLTec3IL751sZrbXtxssLRTGYlnMvOcfPSJnj8zcfkbl7y7vwejCOR/vaKBq6mjWEQzUSR8benEDV7mQdOd4vVyZTMknCxX1EY9YqIpw4A208vtUWT3WgetiUBHQGbZJ/xnN8fqIFW60rDRO8UK9yO26ANoEO4U+1bPOpjps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456144; c=relaxed/simple;
	bh=YT0K3pJrcfUpJRkVRzWhQR22IsLBQNfrFASg32BPoSk=;
	h=Date:To:From:Subject:Message-Id; b=QUEY1sLvOc4WlKNxaYiD3XgCFqdBW2jmqfsqmvcMuuk0+4BwDdAXepKp8yxEP3Xy7OCWyxNamfVVXQkRzWdLyX9uV2XXCZTS5EEd4e2EYIzdWwKqoS2NToDFefO6S8VWFfMAbkIzcJTdP/mCI9RUyzntkmHjU0M+nxQEJLR2F/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AYOnKwDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AYOnKwDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9BC1F00893;
	Sat, 26 Sep 2026 20:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456143;
	bh=V8EOlb/gRI3XLZY4PiRI3Fa+JKy0Il315I2ZeSrrrzg=;
	h=Date:To:From:Subject;
	b=AYOnKwDaLNciNXGRW808pwAXKRC1HjO2FF0IKW1MzHDvOkhweVO6NcxJTYLgbUS7H
	 flkFrKzjW/HTLukatB5cJwcaFLBeTpcCnzrRQ8BanGhyjpV51sq7kQecPGVoy+mh+S
	 NfckzMyKBuWT1JD+WsvHCBj0joSYIhfZa70c6gOM=
Date: Sat, 26 Sep 2026 13:55:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,rakie.kim@sk.com,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,gourry@gourry.net,byungchul@sk.com,apopple@nvidia.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-split-up-memory-management-memory-policy-and-migration.patch removed from -mm tree
Message-Id: <20260926205543.1F9BC1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
has been removed from the -mm tree.  Its filename was
     maintainers-split-up-memory-management-memory-policy-and-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
Date: Fri, 18 Sep 2026 18:34:24 +0200

Patch series "MAINTAINERS: rework MEMORY MANAGEMENT - MEMORY POLICY".

Let's rework MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION.

As I can use some maintenance help in that area, add Gregory as a new
co-maintainer for the split out MEMORY MANAGEMENT - NUMA PLACEMENT
section.


This patch (of 3):

Let's split it up into MIGRATION and NUMA PLACEMENT.  The latter is a
better fitting description for mempolicy.c.

Make a best guess about which pieces existing reviewers are interested in.
Move the split sections to keep alphabetical order.

Link: https://lore.kernel.org/20260918-maintainers-mempolicy-v1-1-9a94cac6d135@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
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

 MAINTAINERS |   62 +++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

--- a/MAINTAINERS~maintainers-split-up-memory-management-memory-policy-and-migration
+++ a/MAINTAINERS
@@ -17208,31 +17208,6 @@ F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 F:	mm/mm_slot.h
 
-MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@kernel.org>
-R:	Zi Yan <ziy@nvidia.com>
-R:	Matthew Brost <matthew.brost@intel.com>
-R:	Joshua Hahn <joshua.hahnjy@gmail.com>
-R:	Rakie Kim <rakie.kim@sk.com>
-R:	Byungchul Park <byungchul@sk.com>
-R:	Gregory Price <gourry@gourry.net>
-R:	Ying Huang <ying.huang@linux.alibaba.com>
-R:	Alistair Popple <apopple@nvidia.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
-F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
-F:	include/linux/mempolicy.h
-F:	include/uapi/linux/mempolicy.h
-F:	include/linux/migrate.h
-F:	include/linux/migrate_mode.h
-F:	mm/mempolicy.c
-F:	mm/migrate.c
-F:	mm/migrate_device.c
-
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Kairui Song <kasong@tencent.com>
@@ -17255,6 +17230,25 @@ F:	include/linux/mmzone.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
+MEMORY MANAGEMENT - MIGRATION
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@kernel.org>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Matthew Brost <matthew.brost@intel.com>
+R:	Joshua Hahn <joshua.hahnjy@gmail.com>
+R:	Byungchul Park <byungchul@sk.com>
+R:	Gregory Price <gourry@gourry.net>
+R:	Ying Huang <ying.huang@linux.alibaba.com>
+R:	Alistair Popple <apopple@nvidia.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/migrate.h
+F:	include/linux/migrate_mode.h
+F:	mm/migrate.c
+F:	mm/migrate_device.c
+
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
@@ -17307,6 +17301,24 @@ F:	mm/numa.c
 F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
+MEMORY MANAGEMENT - NUMA PLACEMENT
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@kernel.org>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Joshua Hahn <joshua.hahnjy@gmail.com>
+R:	Rakie Kim <rakie.kim@sk.com>
+R:	Gregory Price <gourry@gourry.net>
+R:	Ying Huang <ying.huang@linux.alibaba.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+F:	include/linux/mempolicy.h
+F:	include/uapi/linux/mempolicy.h
+F:	mm/mempolicy.c
+
 MEMORY MANAGEMENT - OOM KILLER
 M:	Michal Hocko <mhocko@suse.com>
 R:	David Rientjes <rientjes@google.com>
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

