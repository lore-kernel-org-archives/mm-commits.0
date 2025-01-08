Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5156F3FBB3
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736318164; cv=none; b=GlQbubgm/jievNE95KF4dDuxDKma7e+zd1ZYdr8gzhFxQYIkq2/rg5os9yIXIQ6V+l3YqjU4UYXQWadRc/7zFvdnqcH7CHkOxxKqYybsJyLk5owN5zTogps86uMLAP7iDnCw8a+q1uhhcP7JiLyt4mkUBK4cJcaskeuwse6eJns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736318164; c=relaxed/simple;
	bh=lcAjl+nJwdZOml903ncIpkKkG7NOPjA90snVej9A6to=;
	h=Date:To:From:Subject:Message-Id; b=TZ5WYVWY52wLurksNkZmmr/S0sltmYNhC07Lee7K6CTFMcLq98P1mu0ci+7zsniBW279PnsSF8byNSXMR6obBb03+SxXDNmUm+Z9LZBh2k7DJIgR6fAacEqC8pa73BDOMLtJ4L/aPId6sUH5ZIXpCa+PuqPnqRKhzwQ+Fq77j7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aqEErjrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aqEErjrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C425BC4CED0;
	Wed,  8 Jan 2025 06:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736318163;
	bh=lcAjl+nJwdZOml903ncIpkKkG7NOPjA90snVej9A6to=;
	h=Date:To:From:Subject:From;
	b=aqEErjrT4riRTU2Q6MxO9iCqMbWTIP6OI2od9sXb1nSgupe3jQlz1SdGhsRjBfdEF
	 314uSSWgG/+EOAc0jmozBDVEuj3xsczAn91x5m9HccIOujMl4Hy32zMWgMno4wKL62
	 IXrEZjs/ah/eCdqe8pCEeCHEpi49REr3tmowsqdA=
Date: Tue, 07 Jan 2025 22:36:03 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + huge_memory-add-vmf_insert_folio_pud-fix.patch added to mm-unstable branch
Message-Id: <20250108063603.C425BC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: huge_memory-add-vmf_insert_folio_pud-fix
has been added to the -mm mm-unstable branch.  Its filename is
     huge_memory-add-vmf_insert_folio_pud-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/huge_memory-add-vmf_insert_folio_pud-fix.patch

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
Subject: huge_memory-add-vmf_insert_folio_pud-fix
Date: Tue Jan  7 10:34:59 PM PST 2025

fix vmf_insert_folio_pud() kerneldoc

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501081149.VDLF8cwh-lkp@intel.com/
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~huge_memory-add-vmf_insert_folio_pud-fix
+++ a/mm/huge_memory.c
@@ -1552,7 +1552,7 @@ EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud);
 /**
  * vmf_insert_folio_pud - insert a pud size folio mapped by a pud entry
  * @vmf: Structure describing the fault
- * @pfn: pfn of the page to insert
+ * @folio: folio to insert
  * @write: whether it's a write fault
  *
  * Return: vm_fault_t value.
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
rmap-add-support-for-pud-sized-mappings-to-rmap-fix.patch
huge_memory-add-vmf_insert_folio_pud-fix.patch
xarray-port-tests-to-kunit-fix.patch
checkpatch-check-return-of-git_commit_info-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

