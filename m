Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B928A253F35
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 21:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753392223; cv=none; b=jpztmaoEOVcicx9dK8+hMb27W73LehbkfnL8QEqcxHfdrcUFIMymz6FCm0pAmE2oyWFsvkKAmFxnpFpwJ6Mkp0HIf51a5clzNcYo8o/BbKcQuGrkAdMQzUlfQ6Y0e0MlRG1mD19C9Xg4ztT62LZDEH8GUY0Gz6/u+psCr2Ta0lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753392223; c=relaxed/simple;
	bh=yQJFzVECgkmi7mHCx911V+EQI2MIs4klq0iii2vek4Y=;
	h=Date:To:From:Subject:Message-Id; b=lM049Chb9yY0+MGwk4q7BdWx2vgzvQv2SrKgoLZIp7tLPIHRIP8U4wNZM8CPy0I0otKkItXCckl3gcjztTYLcvzakr5TLugyUx0VYGhMq8zecPaqkTaE+/SWUZArU3ZgqPQ8SdLUWtWeN3KgIklSGWT0lmB7khNpoM9CN4IHI+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2IMW4eeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2IMW4eeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB36C4CEED;
	Thu, 24 Jul 2025 21:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753392223;
	bh=yQJFzVECgkmi7mHCx911V+EQI2MIs4klq0iii2vek4Y=;
	h=Date:To:From:Subject:From;
	b=2IMW4eeDvh+OTNnkVNW6iIwc0dc2tjnsxqzFkFJdZQIUUjtDyOsdBSj9hLCEUbfLM
	 EClun/dYc5R9mKe7jJP4GD9PZNlO/kq+ScAUsJBkR1hpcVpRmMHJrNzldj4P/jte4U
	 0WhKQvQ+yBqtyX3mn2xq4FG3uFHfiFMpTIZCKVDo=
Date: Thu, 24 Jul 2025 14:23:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maintainers-rename-mm-to-mm-misc-add-missing-files.patch removed from -mm tree
Message-Id: <20250724212343.0DB36C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: rename MM to MM MISC, add missing files
has been removed from the -mm tree.  Its filename was
     maintainers-rename-mm-to-mm-misc-add-missing-files.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: rename MM to MM MISC, add missing files
Date: Tue, 22 Jul 2025 20:27:04 +0100

To fit in with other sections within MAINTAINERS for memory management
files, rename the MEMORY MANAGEMENT section to MEMORY MANAGEMENT - MISC to
contain files that are not described by other sections.

We also add missing files to MEMORY MANAGEMENT - MISC and MEMORY MANAGEMENT
- CORE sections.

Move over appropriate files to the core section, and in both sections add
remaining missing files. At this point, with the other recent MAINTAINERS
changes, this should now mean that every memory management-related file has
a section and assigned maintainers/reviewers.

For the time being, we maintain catch-all mm/ and tools/mm/ entries for MM
- MISC, though in future we may wish to remove these to make it obvious
when files don't have assigned entries.

Finally, we copy across the maintainers/reviewers from MEMORY MANAGEMENT -
CORE to MEMORY MANAGEMENT - MISC, as it seems the two are sufficiently
related for this to be sensible.

Link: https://lkml.kernel.org/r/20250722192704.164758-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   81 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 24 deletions(-)

--- a/MAINTAINERS~maintainers-rename-mm-to-mm-misc-add-missing-files
+++ a/MAINTAINERS
@@ -15734,30 +15734,6 @@ F:	mm/memremap.c
 F:	mm/memory_hotplug.c
 F:	tools/testing/selftests/memory-hotplug/
 
-MEMORY MANAGEMENT
-M:	Andrew Morton <akpm@linux-foundation.org>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
-F:	Documentation/admin-guide/mm/
-F:	Documentation/mm/
-F:	include/linux/gfp.h
-F:	include/linux/gfp_types.h
-F:	include/linux/memory_hotplug.h
-F:	include/linux/memory-tiers.h
-F:	include/linux/mempolicy.h
-F:	include/linux/mempool.h
-F:	include/linux/mmzone.h
-F:	include/linux/mmu_notifier.h
-F:	include/linux/pagewalk.h
-F:	include/trace/events/ksm.h
-F:	mm/
-F:	tools/mm/
-F:	tools/testing/selftests/mm/
-N:	include/linux/page[-_]*
-
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
@@ -15771,18 +15747,33 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
+F:	include/linux/gfp.h
+F:	include/linux/gfp_types.h
 F:	include/linux/memory.h
 F:	include/linux/mm.h
 F:	include/linux/mm_*.h
+F:	include/linux/mmzone.h
 F:	include/linux/mmdebug.h
 F:	include/linux/pagewalk.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
+F:	mm/folio-compat.c
+F:	mm/highmem.c
 F:	mm/init-mm.c
+F:	mm/internal.h
+F:	mm/maccess.c
 F:	mm/memory.c
+F:	mm/mmzone.c
 F:	mm/pagewalk.c
+F:	mm/pgtable-generic.c
+F:	mm/sparse-vmemmap.c
+F:	mm/sparse.c
 F:	mm/util.c
+F:	mm/vmpressure.c
+F:	mm/vmstat.c
+N:	include/linux/page[-_]*
 
 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -15845,6 +15836,48 @@ F:	mm/mempolicy.c
 F:	mm/migrate.c
 F:	mm/migrate_device.c
 
+MEMORY MANAGEMENT - MISC
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Mike Rapoport <rppt@kernel.org>
+R:	Suren Baghdasaryan <surenb@google.com>
+R:	Michal Hocko <mhocko@suse.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/
+F:	Documentation/mm/
+F:	include/linux/memory-tiers.h
+F:	include/linux/mempolicy.h
+F:	include/linux/mempool.h
+F:	include/linux/memremap.h
+F:	include/linux/mmu_notifier.h
+F:	include/trace/events/ksm.h
+F:	mm/
+F:	mm/backing-dev.c
+F:	mm/cma.c
+F:	mm/cma_debug.c
+F:	mm/cma_sysfs.c
+F:	mm/dmapool.c
+F:	mm/dmapool_test.c
+F:	mm/early_ioremap.c
+F:	mm/fadvise.c
+F:	mm/io-mapping.c
+F:	mm/ioremap.c
+F:	mm/mapping_dirty_helpers.c
+F:	mm/memory-tiers.c
+F:	mm/mmu_notifier.c
+F:	mm/page_idle.c
+F:	mm/pgalloc-track.h
+F:	mm/process_vm_access.c
+F:	mm/ptdump.c
+F:	tools/mm/
+F:	tools/testing/selftests/mm/
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-check-remap-conditions-earlier-fix.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas.patch
tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch
tools-testing-selftests-explicitly-test-split-multi-vma-mremap-move.patch
docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch
docs-update-thp-documentation-to-clarify-sysfs-never-setting-fix.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch

