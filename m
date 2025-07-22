Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DB4285070
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 20:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215152; cv=none; b=Psa4oK5aypQ9lyEErYOTkQETJh+aMVl9Bl5PJQHfgtgQcxCamC4cRQXtmm/R5KINOVlqvG7iBvrIYeza1nuNx50Dm/cPxoqH6YD58xksAUCEl0UGOyU+cE19abPApSuk7p4hzSImSom4CQj396Gg1TPcguFx+j1NoDFMHLNwvzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215152; c=relaxed/simple;
	bh=pBhels7eqY5h0lXfDT0ab5e/3qAEczAEHY0QAX9xuXA=;
	h=Date:To:From:Subject:Message-Id; b=PxlfMzrTpZCKIQQTFWWtOWoTV8dLpodU7ro6poZaj5yjhEHF3KfXtbuWLZIbHfmSI+Q1ygO6eI/6nGL1QmwnwGQoMnDCAkJXEE2mBfA4KboyorlJuPHZs0OgbeWjfGkKeyNnM4SLcPd4TaNdj9bNuQyujCSWrljScP1aMvS3JGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K3NH0LIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K3NH0LIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386D4C4CEEB;
	Tue, 22 Jul 2025 20:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753215152;
	bh=pBhels7eqY5h0lXfDT0ab5e/3qAEczAEHY0QAX9xuXA=;
	h=Date:To:From:Subject:From;
	b=K3NH0LIRl1oktOSlRiouRBp6IFoPQBZmWrK7xlOInAVkAIC8/Msxp5VjamK8B8E5Y
	 AGzQNzPOZfiIFuss7VhJZXFJ8eLC42lgrEN1EPtJkx94P5TxFY+CG4DdGyJWqv0goz
	 C9etIMe+GhIPYVgL4Wi1U3C7R/1dA0USkbkbPbLU=
Date: Tue, 22 Jul 2025 13:12:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,liam.howlett@oracle.com,jannh@google.com,dennis@kernel.org,david@redhat.com,david@fromorbit.com,cl@gentwo.org,apopple@nvidia.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-missing-shrinker-files.patch added to mm-hotfixes-unstable branch
Message-Id: <20250722201232.386D4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add missing shrinker files
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-missing-shrinker-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-missing-shrinker-files.patch

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
Subject: MAINTAINERS: add missing shrinker files
Date: Tue, 22 Jul 2025 18:34:36 +0100

The mm/list_lru.[ch] files implement a shrinker-specific data structure so
seem most suited to the SHRINKER section.

Link: https://lkml.kernel.org/r/20250722173436.145526-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-missing-shrinker-files
+++ a/MAINTAINERS
@@ -22630,7 +22630,9 @@ R:	Muchun Song <muchun.song@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/shrinker_debugfs.rst
+F:	include/linux/list_lru.h
 F:	include/linux/shrinker.h
+F:	mm/list_lru.c
 F:	mm/shrinker.c
 F:	mm/shrinker_debug.c
 
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

