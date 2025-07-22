Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90714A2D
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 20:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215154; cv=none; b=oO7a5P5922k6UOgpM4eR3ZkEt1YLClgmt8p6TLbgdC4NpsGJy09352XeK0jTc/eE8QM7P9Hz1FUYpfO5hxSWxd2hPZDB6mmnk6wsXGojJmcRP5fCIr/X8dHEa6Fe3h0FM7bZlu9bnpkD73lZUMq3WEGusPndQryOEKRsK4FcOYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215154; c=relaxed/simple;
	bh=dypzgcuxLSmTUx1Ax0R4CbyR30qmzrJCtia0XFn893A=;
	h=Date:To:From:Subject:Message-Id; b=MvDQZjkeF8KwMDbGC1mhQCVlB2SHqEak+Kg0D7u0woAm4e94mnto8PwT8EqIZjItkz1OuneIivpc6IAv63inDawJMssiNVY+g3mSEteC8ifkhDTmwYq22yl1F86A1mlmN5OnF6Y8PjeTGxkMTG+PEA5KSxzqI0RSpgkujC8AOQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2oOJnW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2oOJnW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66415C4CEEB;
	Tue, 22 Jul 2025 20:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753215154;
	bh=dypzgcuxLSmTUx1Ax0R4CbyR30qmzrJCtia0XFn893A=;
	h=Date:To:From:Subject:From;
	b=E2oOJnW/GYqmlKyLYoO84ScmFmYFpQt3nldhfmwNCtT3BBY+2Jxt7yQ1L4BOzLQxT
	 gKkn84En3R96xJTu3cnpmOddxTK5OzELXNxwFKYJeEs53XLLHwZnob58lPjsPtXK6B
	 PBMpcj7c4fmqqXMvuCLVmF6qmcJ6zqMGvv7QF1bU=
Date: Tue, 22 Jul 2025 13:12:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,liam.howlett@oracle.com,jannh@google.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-missing-files-to-page-alloc-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250722201234.66415C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add missing files to page alloc section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-missing-files-to-page-alloc-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-missing-files-to-page-alloc-section.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: MAINTAINERS: add missing files to page alloc section
Date: Tue, 22 Jul 2025 18:41:43 +0100

There are a couple of mm/-specific header files that were accidentally
missed previously, and some page ref debug code also that ought to live
here.

Link: https://lkml.kernel.org/r/20250722174143.147143-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-files-to-page-alloc-section
+++ a/MAINTAINERS
@@ -15880,6 +15880,7 @@ F:	include/linux/gfp.h
 F:	include/linux/page-isolation.h
 F:	mm/compaction.c
 F:	mm/debug_page_alloc.c
+F:	mm/debug_page_ref.c
 F:	mm/fail_page_alloc.c
 F:	mm/page_alloc.c
 F:	mm/page_ext.c
@@ -15888,8 +15889,10 @@ F:	mm/page_isolation.c
 F:	mm/page_owner.c
 F:	mm/page_poison.c
 F:	mm/page_reporting.c
+F:	mm/page_reporting.h
 F:	mm/show_mem.c
 F:	mm/shuffle.c
+F:	mm/shuffle.h
 
 MEMORY MANAGEMENT - RECLAIM
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
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

