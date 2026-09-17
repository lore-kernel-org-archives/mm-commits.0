Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13694B7A2E
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 23:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689452; cv=none; b=fJKYHmvnXJuaPzglny8k8QNhSM/YTV+RGMH/1iA6ApcxY3kQqeudzPnM802a+a3GwftnY05SXOhbou0Zl2uer3ZV80K3D5MCMG0FHdfdADJhnf1t523CVlsdNLsshtGbNkAZToGvdm73m8uiQwS2azbU0LOpOaxxBRj3/kwOY/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689452; c=relaxed/simple;
	bh=4/XAGS1q/jg5qIgS1SShP/NMMFl32kcmIlaOHzOoExo=;
	h=Date:To:From:Subject:Message-Id; b=QDRR+2AVlbBGkH092ly83vLiFrzIeM2arn6xXV3UyqLpS1FN3NEiEJ/lpaBfNPXigKsNZ5hSSaMP27vtqEUP80glKQXSNauaURYNjZNPSDNK9vx8fPUT6vUQYBb3f6f7+58i8P6nxhZ7WIcn24ONPR18XB7/oZtOJ7S+5EFo8I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uWlxdyRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uWlxdyRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454841F000FF;
	Thu, 17 Sep 2026 23:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789689450;
	bh=IQ1FloTO2PyK6gSL/8eDy2qa7votLx4WF8e2Gfcwix4=;
	h=Date:To:From:Subject;
	b=uWlxdyRzN6khYBrjfL1579Rb9TJXGZNO0IIhKjX8Shna/tiDdce94hqhEfyJdLTiD
	 UBRxPx6ILPAet6YTA83oby7LlpwYEUuymnkSJ4lgxMNqXhxd1mT7anj7Bl2WGw/DHP
	 gALrD+40b+UnNLCF6Dwuf3Jmupxh9JlccVnPvZ7A=
Date: Thu, 17 Sep 2026 16:57:29 -0700
To: mm-commits@vger.kernel.org,wyihan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases.patch added to mm-new branch
Message-Id: <20260917235730.454841F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lisa Wang <wyihan@google.com>
Subject: mm: memory_failure: Generalize extra_pins handling to all MF_DELAYED cases
Date: Thu, 17 Sep 2026 20:43:50 +0000

Generalize extra_pins handling to all MF_DELAYED cases not only
shmem_mapping.

If MF_DELAYED is returned, the filemap continues to hold refcounts on the
folio.  Hence, take that into account when checking for extra refcounts.

As clarified in an earlier patch, a return value of MF_DELAYED implies
that the page still has elevated refcounts.  Hence, set extra_pins to true
if the return value is MF_DELAYED.  This is aligned with the
implementation in me_swapcache_dirty(), where, if a folio is still in the
swap cache, ret is set to MF_DELAYED and extra_pins is set to true.

Link: https://lore.kernel.org/20260917-memory-failure-mf-delayed-fix-v6-4-4b00856b5364@google.com
Signed-off-by: Lisa Wang <wyihan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
---

 mm/memory-failure.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases
+++ a/mm/memory-failure.c
@@ -1040,17 +1040,13 @@ static int me_pagecache_clean(struct pag
 	}
 
 	/*
-	 * The shmem page is kept in page cache instead of truncating
-	 * so is expected to have an extra refcount after error-handling.
-	 */
-	extra_pins = shmem_mapping(mapping);
-
-	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
+
+	extra_pins = ret == MF_DELAYED;
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 
_

Patches currently in -mm which might be from wyihan@google.com are

mm-memory_failure-clarify-the-mf_delayed-definition.patch
mm-memory_failure-allow-truncate_error_folio-to-return-mf_delayed.patch
mm-shmem-update-shmem-handler-to-the-mf_delayed-definition.patch
mm-memory_failure-generalize-extra_pins-handling-to-all-mf_delayed-cases.patch
mm-selftests-add-shmem-into-memory-failure-test.patch

