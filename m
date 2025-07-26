Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE78220F3F
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567848; cv=none; b=TAL6sjw11BJqUetJcEKwU/x9RfEVPQyRPIe4yvqH7JC8vta2IXQL0HEiJq4XUNbwI2sVIsxOtsChVmsKOysvVcD6PGzUC0vMggSBCaPra01KRDgLcrOyKKVs+Lxj6YSc/4NhKdnCrz9TRnB2+FFgCuY3gMMAvvubXcBFCV+626E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567848; c=relaxed/simple;
	bh=V9FxIoU2lZxcTTrBwHQC6nOKO42vCpCorMx6puSDqgM=;
	h=Date:To:From:Subject:Message-Id; b=P6IHFgB/7/zeUJBGUXPXPD2K5FnOeR9Cq3I3cj1E+fn4kct2PTdtuVoI5YZepr77pjrbAmN/kBovUaN6yogLIr1M2dQiLL9ulThLgGH0w6IHDID54CG2OrJCEuihFDoi1E8S5dgsADKlv8LYJsk9t9bsrCvVUn8HeMESXLAMeRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tXjcHTWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tXjcHTWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE1C4CEED;
	Sat, 26 Jul 2025 22:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567848;
	bh=V9FxIoU2lZxcTTrBwHQC6nOKO42vCpCorMx6puSDqgM=;
	h=Date:To:From:Subject:From;
	b=tXjcHTWQnk3VpmryvInFKzg9A/PbkE4A5efxQ6xE4+7vJgjBcLlG1YXYqxKqkze6C
	 2ADjN6yosVKmLdvOQeJzrVHby49fGkKk43BWxogp/geXMn8dCQZYe7YgDf7Ft8qE/p
	 5E1F2oWP0mEv7prGQ9PlX2OpW4zJBSpSgX7S3/Tc=
Date: Sat, 26 Jul 2025 15:10:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch removed from -mm tree
Message-Id: <20250726221048.B0FE1C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add MM MISC section, add missing files to MISC and CORE
has been removed from the -mm tree.  Its filename was
     maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add MM MISC section, add missing files to MISC and CORE
Date: Thu, 24 Jul 2025 14:33:56 +0100

Add a MEMORY MANAGEMENT - MISC section to contain files that are not
described by other sections, moving all but the catch-all mm/ and
tools/mm/ from MEMORY MANAGEMENT to MEMORY MANAGEMENT - CORE and MEMORY
MANAGEMENT - MISC as appropriate.

In both sections add remaining missing files.  At this point, with the
other recent MAINTAINERS changes, this should now mean that every memory
management-related file has a section and assigned maintainers/reviewers.

Finally, we copy across the maintainers/reviewers from MEMORY MANAGEMENT -
CORE to MEMORY MANAGEMENT - MISC, as it seems the two are sufficiently
related for this to be sensible.

Link: https://lkml.kernel.org/r/20250724133356.49487-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
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
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   72 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 58 insertions(+), 14 deletions(-)

--- a/MAINTAINERS~maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core
+++ a/MAINTAINERS
@@ -15740,22 +15740,8 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
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
 F:	mm/
 F:	tools/mm/
-F:	tools/testing/selftests/mm/
-N:	include/linux/page[-_]*
 
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -15770,18 +15756,40 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/gfp.h
+F:	include/linux/gfp_types.h
+F:	include/linux/highmem.h
 F:	include/linux/memory.h
 F:	include/linux/mm.h
 F:	include/linux/mm_*.h
+F:	include/linux/mmzone.h
 F:	include/linux/mmdebug.h
+F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
+F:	include/linux/pgtable.h
+F:	include/linux/ptdump.h
+F:	include/linux/vmpressure.h
+F:	include/linux/vmstat.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
+F:	mm/folio-compat.c
+F:	mm/highmem.c
 F:	mm/init-mm.c
+F:	mm/internal.h
+F:	mm/maccess.c
 F:	mm/memory.c
+F:	mm/mmu_notifier.c
+F:	mm/mmzone.c
 F:	mm/pagewalk.c
+F:	mm/pgtable-generic.c
+F:	mm/ptdump.c
+F:	mm/sparse-vmemmap.c
+F:	mm/sparse.c
 F:	mm/util.c
+F:	mm/vmpressure.c
+F:	mm/vmstat.c
+N:	include/linux/page[-_]*
 
 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -15844,6 +15852,42 @@ F:	mm/mempolicy.c
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
+F:	include/linux/cma.h
+F:	include/linux/dmapool.h
+F:	include/linux/ioremap.h
+F:	include/linux/memory-tiers.h
+F:	include/linux/page_idle.h
+F:	mm/backing-dev.c
+F:	mm/cma.c
+F:	mm/cma_debug.c
+F:	mm/cma_sysfs.c
+F:	mm/dmapool.c
+F:	mm/dmapool_test.c
+F:	mm/early_ioremap.c
+F:	mm/fadvise.c
+F:	mm/ioremap.c
+F:	mm/mapping_dirty_helpers.c
+F:	mm/memory-tiers.c
+F:	mm/page_idle.c
+F:	mm/pgalloc-track.h
+F:	mm/process_vm_access.c
+F:	tools/testing/selftests/mm/
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

