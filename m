Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0911271454
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 20:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215398; cv=none; b=ScLquiBQ2DyMpVyd90OScPl9aJX4f43y8CgzlttUP923AuK6ZFa6ztGX+RmUe+dZ3wOV4d0VCuTVgZGuetBV1LZ3uVXFxhT84QxajM+w4J7ab7UVyXn2O29LuGYbT5LSe3XYuQDvtqIOHRFmQFH+vt1MBm2z1OD/M0YYmedohxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215398; c=relaxed/simple;
	bh=Wv8xLD6AVPwVdvwuTscqbNIbCQZQbrG2mnjfSwqqPXc=;
	h=Date:To:From:Subject:Message-Id; b=Vcr8/FwbIwU8hPZqIRVvDXbEK8HCTm5Tu+R3J8OODNAW4/yf3nGUj3zLr8d3nTyYGx2fHsY2nXuI039GRFeq0W/9SeovfET1g6+1JdqxIEoch0AvSlWAKayxKGz97Ed3ckv2t6GNrfLGVCHPJAIquTJLWfkN/6DCL8xNlEKdtXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TkgY8LCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TkgY8LCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5630DC4CEEB;
	Tue, 22 Jul 2025 20:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753215396;
	bh=Wv8xLD6AVPwVdvwuTscqbNIbCQZQbrG2mnjfSwqqPXc=;
	h=Date:To:From:Subject:From;
	b=TkgY8LCKDvgVEiIe+WDWNfmXjV3OV8UyLajF4g+ENQ254MEuZkJVZ5LbU/AsAxdU9
	 hYQkO26ihYxOF2ZH0iDn8KZU55cKtsO33jxZW6vRyYhpYDYcm+Mht5/3R4HasS//Gq
	 y7Tr/88tARS07kq7zcZuOa4XonGlSG52O/r2MEjw=
Date: Tue, 22 Jul 2025 13:16:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,liam.howlett@oracle.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-rename-mm-to-mm-misc-add-missing-files.patch added to mm-unstable branch
Message-Id: <20250722201636.5630DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: rename MM to MM MISC, add missing files
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-rename-mm-to-mm-misc-add-missing-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-rename-mm-to-mm-misc-add-missing-files.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -15844,6 +15835,48 @@ F:	mm/mempolicy.c
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
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-rename-mm-to-mm-misc-add-missing-files.patch

