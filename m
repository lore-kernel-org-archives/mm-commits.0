Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D349324B2F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 06:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720766754; cv=none; b=iV2iE5Jsm3kpitMyDMlf2XYCAECjarIHYnW1nl3cD6URRHGqd/YomwWdQiR+ITZRe3EqIB+Yaidffae63GZjSePP0UhF+mabvvW5vgLueU5L7ZIXH9zdqRlbRxS8e7qpRMcNJjQiNyGBPGx4LexxSQ3rsjTe9Dfg2Lkb1UIC+pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720766754; c=relaxed/simple;
	bh=1rjHZvf9h7nRkzbIy3X9BSxHvwaxdbwg6th8JG6h7VU=;
	h=Date:To:From:Subject:Message-Id; b=s6tGHxCpeHmuTWqwZ5Ngh/gXIcElpwmp8OUo5UG+z8ToMc7O3nQUGaLq2f0OOUE35RMavARdaFItg62YQu1vxGjsfYVv3yqwMC4t56/pVcQdYXMvNyumhjClZbxEaa3DDW2wLPo71Q441xJ6wZkrl1f0FRHBZHgOUnCX0iuqpE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vvMpD1HB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vvMpD1HB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A75C3277B;
	Fri, 12 Jul 2024 06:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720766753;
	bh=1rjHZvf9h7nRkzbIy3X9BSxHvwaxdbwg6th8JG6h7VU=;
	h=Date:To:From:Subject:From;
	b=vvMpD1HBNxCu2ydF/4jtGDakGJ9FmMdvnkqPuibE7MfuVGJv3KD8NH/jQaG6anVMc
	 VpLdmNaQAbPHeF1p7+WA5cDBVJYcCtrEyJkEGLdAOhB/Aerf3IMrDkLosQvsfKQkJ/
	 JlXdhYkiWHcDvoXAhHK0TJ2QWM/C7+ycmJVPj+ZA=
Date: Thu, 11 Jul 2024 23:45:52 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,chengming.zhou@linux.dev,aris@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlbc-undo-errant-change.patch added to mm-unstable branch
Message-Id: <20240712064553.89A75C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb.c: undo errant change
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlbc-undo-errant-change.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlbc-undo-errant-change.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb.c: undo errant change
Date: Thu Jul 11 11:36:42 PM PDT 2024

During conflict resolution a line was unintentionally removed by a ksm.c
patch.

Link: https://lkml.kernel.org/r/85b0d694-d1ac-8e7a-2e50-1edc03eee21a@google.com
Fixes: ac90c56bbd73 ("mm/ksm: refactor out try_to_merge_with_zero_page()")
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlbc-undo-errant-change
+++ a/mm/hugetlb.c
@@ -2634,6 +2634,7 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
+		folio = NULL;
 		for_each_node_mask(node, cpuset_current_mems_allowed) {
 			if (!mbind_nodemask || node_isset(node, *mbind_nodemask)) {
 				folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlbc-undo-errant-change.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix-fix.patch
mm-migrate-putback-split-folios-when-numa-hint-migration-fails-fix.patch

