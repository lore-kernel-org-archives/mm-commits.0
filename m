Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574E230649C
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 04:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788236593; cv=none; b=NmBcqeMxNy9//6oXI+3WJWt2zK1dKj2pohr2WzPa7hUOaRG7hKM7E9ErYmZFmMIiBIvZg48u7M5wm/qvT2njZnO/PH3+fjJTAWB6B+362DY/nzYmqCWt5s40YkNJtXDCAGtyc4L5XHwQlTIqpwTOX4cSDomjSoxb9FoZfbs7MZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788236593; c=relaxed/simple;
	bh=fW+iLZBmXqqUDwZXaG7KB3qpDqATXnY/RcMv+rcUqYQ=;
	h=Date:To:From:Subject:Message-Id; b=gQdRwAlkhFWDNx3iq3y7Xvz1OZ1d1d/86Bz1RYcpSi/XpPMOavFG2zWpiGWtER3z/GVCEJIg3BPTlTHSFTu0fvq6WtvsOCNlhY5yM8BWPLr4XYVccx6MO3xpqHe5fx/72C5c/N1j8GxmHBcWAeEeqj/FJi9uRef2r8whZWcUaOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KvEiI4XE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KvEiI4XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9571F000E9;
	Tue,  1 Sep 2026 04:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788236591;
	bh=7VvMbNhADMUkFl+5nU+EQi9sBoipnOvX7YEjYY5wAOk=;
	h=Date:To:From:Subject;
	b=KvEiI4XEhdHkamfwFjhoShaIlaUE9iLMz0G0qAxmKUCjAW/MjUv25y/XN1a+jbmjd
	 nxA65kU3YC46TpQ2TWNZohyCSMcVmuPTUR3Oa5lsmhlZa0deklYIalNTJ/c7G5gw9r
	 cY2/RN+pKNARM0v3dTJydQtk8x2aopun/ONlhHEE=
Date: Mon, 31 Aug 2026 21:23:11 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch added to mm-new branch
Message-Id: <20260901042311.BE9571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: add explicit pmd_none check in pte_clear_range
has been added to the -mm mm-new branch.  Its filename is
     mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/page_table_check: add explicit pmd_none check in pte_clear_range
Date: Wed, 19 Aug 2026 10:55:15 +0800

In __page_table_check_pte_clear_range(), the condition to determine
whether to iterate over PTEs only checked pmd_bad() and pmd_leaf().  This
relies on the implicit assumption that pmd_none() is always a subset of
pmd_bad() on all architectures supporting PAGE_TABLE_CHECK.

While this assumption currently holds for x86_64, arm64, s390, riscv, and
powerpc, it is an architecture-dependent behavior that may not hold for
future architectures.  Add an explicit pmd_none() check to make the intent
clear and avoid calling pte_offset_map() on an empty PMD, which could lead
to undefined behavior.

Link: https://lore.kernel.org/20260819025516.2967199-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_table_check.c~mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range
+++ a/mm/page_table_check.c
@@ -278,7 +278,7 @@ void __page_table_check_pte_clear_range(
 	if (&init_mm == mm)
 		return;
 
-	if (!pmd_bad(pmd) && !pmd_leaf(pmd)) {
+	if (!pmd_none(pmd) && !pmd_bad(pmd) && !pmd_leaf(pmd)) {
 		pte_t *ptep = pte_offset_map(&pmd, addr);
 		unsigned long i;
 
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-fix-vmap_purge_lock-livelock-under-memory-pressure.patch
tools-mm-page_owner_sort-fix-sort-option-being-silently-ignored.patch
tools-mm-page_owner_sort-add-module-name-sort-cull-filter-support.patch
tools-mm-page_owner_sort-show-available-sort-keys-in-usage-text.patch
mm-oom_kill-remove-unreachable-__gfp_thisnode-check-in-constrained_alloc.patch
mm-oom_kill-proc-replace-magic-number-1000-with-oom_score_adj_max.patch
mm-page_table_check-add-explicit-pmd_none-check-in-pte_clear_range.patch

