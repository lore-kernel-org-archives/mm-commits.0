Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932D518C900
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 02:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736303410; cv=none; b=PHUGDdJMqbrmshJSy2lR+VS5wfyu1apJwDNWKk0241lJGzcFE1t9fNxzuGxgMzOPPwPbo2GpAvb57Tl7W/tb7Fqgh+oDJZvSkMb0oghq+jXPoweNvrHcvCsunSTfKJJF+Ma7Ta/JPIU6CI4qwBInVi21UbK92erw7VizthMrp98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736303410; c=relaxed/simple;
	bh=6z3ik+Ogsc1r8EO95LDbP4uZrxHxAIW28RzfS5Bm+e4=;
	h=Date:To:From:Subject:Message-Id; b=DDsMSulAC0JPoM/rnjnw9IXNxAp4W66TMeMtKbGM60drq5ibroEOoshB3EmnaU6mlIF+C0JWqjxI1tok9cALGLZsYgNEeQSZxPmdzsOaF8V3w1O8AjplhO+lTdalEj1fkvz2+aXGFaqFWRpE/aEhEsHHIzCy4O6ZQrEpz4Tbt1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jTmzqtP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jTmzqtP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A13C4CEDF;
	Wed,  8 Jan 2025 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736303410;
	bh=6z3ik+Ogsc1r8EO95LDbP4uZrxHxAIW28RzfS5Bm+e4=;
	h=Date:To:From:Subject:From;
	b=jTmzqtP5C9pQ2B8LMEIJHlmQVgLydqksxFljZ7LTuD74aiVRn3v1E9snUPsJQpin6
	 bZd1Z0UEaDYhfU1XT1w/6nbJeZBLWJIDlCYAGtzPy9sGn2vk/o3sGUR8lcjE4s1JFH
	 jLuSg2xImPAeiaVs6qqd4/MhLse6vML7tbLfjX5Y=
Date: Tue, 07 Jan 2025 18:30:09 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,kasong@tencent.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch added to mm-unstable branch
Message-Id: <20250108023009.E3A13C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch

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
Subject: mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix
Date: Tue Jan  7 06:25:19 PM PST 2025

use IS_ENABLED(), tweak comment grammar 

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix
+++ a/mm/shmem.c
@@ -1978,16 +1978,14 @@ static struct folio *shmem_swap_alloc_fo
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
-	 * limit chance of success by further cpuset and node constraints.
+	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order > 0) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && order > 0) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
 		gfp = limit_gfp_mask(huge_gfp, gfp);
 	}
-#endif
 
 	new = shmem_alloc_folio(gfp, order, info, index);
 	if (!new)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
xarray-port-tests-to-kunit-fix.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

