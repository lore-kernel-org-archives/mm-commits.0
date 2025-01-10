Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AF2207DFD
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 23:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736550279; cv=none; b=GTH62PgG7/7xirsTu8ZLYX9pb++J7IWyjpSb2bn9a2Gs4cmqGjL701JcntAd6ELgVXQe1CKxoOEfKgM2Wi+BCrv5N2dD4TATlMKaEiFuYRd6mx11hWR25Pyx+Ngkr5MpBosymJRnGX4MN91+tFtvwlIIZ4AO2+fk1/k/lB8dfnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736550279; c=relaxed/simple;
	bh=MdGBCdkUVLAzknIsFhadhyOPbdpIaASFGU2UBpjCAjo=;
	h=Date:To:From:Subject:Message-Id; b=X42GgBaaDlWAfeNiBcs65aL/KPqb64lUckJ8lW6bzzsSNGZkbFVVlSIELoyulKFLDdzWELft5/XMgZ7+jvSBZX5oTwAZvq7QVSik++oTuJP07ScwLe+UjBRYcNyAUiPJHkhh37//wiJtwRXvQ6w5nm/SHcK9+cIEqMf+BMjYFRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Rrf9IuAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rrf9IuAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21022C4CED6;
	Fri, 10 Jan 2025 23:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736550279;
	bh=MdGBCdkUVLAzknIsFhadhyOPbdpIaASFGU2UBpjCAjo=;
	h=Date:To:From:Subject:From;
	b=Rrf9IuAh7Du7t0OjkgXWTK1vfo5SDofMjKzE9W7cyko/xxIk0a3ksy20JX9PCxgoO
	 k8lElh52j92z2sLIRj4jjgLUNa91iymeLbIsHA1LTNZ31xrSZhMkNYTAZ83WU2DSZv
	 ggfXtImvPhPnhWHC6NnC1dme91k4kws6/2V/JF9Q=
Date: Fri, 10 Jan 2025 15:04:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch added to mm-unstable branch
Message-Id: <20250110230439.21022C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch

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
Subject: mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix
Date: Fri Jan 10 03:02:30 PM PST 2025

fix kernekdoc, per Matthew

Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix
+++ a/mm/hugetlb.c
@@ -7418,7 +7418,7 @@ __weak unsigned long hugetlb_mask_last_p
 #endif /* CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
 /**
- * folio_isolate_hugetlb: try to isolate an allocated hugetlb folio
+ * folio_isolate_hugetlb - try to isolate an allocated hugetlb folio
  * @folio: the folio to isolate
  * @list: the list to add the folio to on success
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb-fix.patch
xarray-port-tests-to-kunit-fix.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

