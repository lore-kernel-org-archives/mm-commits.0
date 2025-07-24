Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA762CA8
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 00:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753318087; cv=none; b=jKW0bo2el1f6hywp9P8uLuklVft0x87HBvzoyVcjwwZsSliVN8PELRYlDzeexFD5pjTmMvkOpj5MwloQvhqux+fa/ptO7PrnuGRuQ7dNj4qNE8qoGwzspBy4cUG8k/46ndcskjgF3eK/T93ROOgBWAW5Wt5pDzVerWXPkcWN+F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753318087; c=relaxed/simple;
	bh=V6CesZ+VqnxJlQiRcWfo3MNioUQYHkIfl6nLw6n+1vo=;
	h=Date:To:From:Subject:Message-Id; b=jQXIunPeG0zoOHDg3WavvRW3lCxl9EMie//tpSuXqz+6tG7oEw3IosEP5boYekpTasugKZyy+9LRL3jpwlWXa3FOHuqVOb1w7pPEsT8PmtDcxzShOhfYEo6Wbo/irh9SAmdXtguEE7FHsBznmEyxVb7ux7lfpLwWI7ekNW6wa90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZHoLBM5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZHoLBM5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306FFC4CEE7;
	Thu, 24 Jul 2025 00:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753318086;
	bh=V6CesZ+VqnxJlQiRcWfo3MNioUQYHkIfl6nLw6n+1vo=;
	h=Date:To:From:Subject:From;
	b=ZHoLBM5lMjqn79HJ0WLjmi3amT9kJJqtQtB2KQ6NACwbB9d1WE/5rUVzFcKKkbo2T
	 u8Cx4aY9cR67NXR1Czv4B2vomyo6QAKZ9NFHpTy0uu/NZybqO8aYOb7hUeVjFa5DAb
	 ZTbSqc5y1aNoC9QF3hZBZTyT++0jf8wlPHtVXAzo=
Date: Wed, 23 Jul 2025 17:48:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,surenb@google.com,rppt@kernel.org,roman.gushchin@linux.dev,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-missing-mm_sloth-file-thp-section-fix.patch added to mm-unstable branch
Message-Id: <20250724004806.306FFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: also add mm_slot.h to KSM section
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-missing-mm_sloth-file-thp-section-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-missing-mm_sloth-file-thp-section-fix.patch

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
Subject: MAINTAINERS: also add mm_slot.h to KSM section
Date: Wed, 23 Jul 2025 05:50:08 +0100

The mm_slot implementation is in fact common between THP and KSM so ought
to be included in both sections.

Link: https://lkml.kernel.org/r/685747e2-a8cb-4620-a0c0-5cd9048d69b8@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-missing-mm_sloth-file-thp-section-fix
+++ a/MAINTAINERS
@@ -15821,6 +15821,7 @@ F:	Documentation/mm/ksm.rst
 F:	include/linux/ksm.h
 F:	include/trace/events/ksm.h
 F:	mm/ksm.c
+F:	mm/mm_slot.h
 
 MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
 M:	Andrew Morton <akpm@linux-foundation.org>
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
maintainers-rename-mm-to-mm-misc-add-missing-files.patch

