Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C3E224C9
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 22:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714169860; cv=none; b=c6NyzO7MgIH276VBrUMaDn8WiVb6xj9//ApRpxNpOUxk7G5aAZReBpnyT0op5AgTOEJa51yRJcxPCfx3K5a/WgWAMjkL3NO+/BfuV3uPUV+4uNW7whMsOBf7EEzil1UK94r8X0otqAxkQ8X2DFOMw5TY2oVu/ot+m58MMEZ87GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714169860; c=relaxed/simple;
	bh=vgT8iSV9NMVtcuAQOYROb/LHGEr7/dOkurbFSZ6yOCw=;
	h=Date:To:From:Subject:Message-Id; b=e2nSEXwfcYxjdM9zDf7JZ+SuOL6YjrwsSNmWagGl8jR3oFKPeezVIyvmLTH5gZbDTsZRvE5s3sCUB1K/1BhfSqSCHJnkmUkYQt2GTorM2INBaMrqzuimeVV+TWXQaJ0MGU/thaBv1ESPMoLPpurvXlWaR3omKCghOTMNtweocTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BX3wiJyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BX3wiJyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA0DC113CD;
	Fri, 26 Apr 2024 22:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714169859;
	bh=vgT8iSV9NMVtcuAQOYROb/LHGEr7/dOkurbFSZ6yOCw=;
	h=Date:To:From:Subject:From;
	b=BX3wiJyDG+IApHwL2TA4PY71PbOo4wpZL/MsWEXn0joktmBRUMHFsxk9S64LCkcqk
	 rNV4g+pseqyLhN8QyKEaCLGPDXjf/3L9EqY8xbenLWh94OuoN+ZV0AysC4KUP004mB
	 eg0u86WHu1yZddohNxZr9pshiFlO6d63++kKQtpk=
Date: Fri, 26 Apr 2024 15:17:39 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-implement-damon_folio_mkold.patch added to mm-unstable branch
Message-Id: <20240426221739.DCA0DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: implement damon_folio_mkold()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-implement-damon_folio_mkold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-implement-damon_folio_mkold.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: implement damon_folio_mkold()
Date: Fri, 26 Apr 2024 12:52:41 -0700

damon_pa_mkold() receives physical address, get the folio covering the
address, and makes the folio as old.  A following commit will reuse the
internal logic for marking a given folio as old.  To avoid duplication of
the code, split the internal logic.  Also, change the rmap walker
function's name from __damon_pa_mkold() to damon_folio_mkold_one(),
following the change of the caller's name and the naming rule that more
commonly used by other rmap walkers.

Link: https://lkml.kernel.org/r/20240426195247.100306-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Tested-by: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-implement-damon_folio_mkold
+++ a/mm/damon/paddr.c
@@ -16,8 +16,8 @@
 #include "../internal.h"
 #include "ops-common.h"
 
-static bool __damon_pa_mkold(struct folio *folio, struct vm_area_struct *vma,
-		unsigned long addr, void *arg)
+static bool damon_folio_mkold_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
 {
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
 
@@ -31,33 +31,38 @@ static bool __damon_pa_mkold(struct foli
 	return true;
 }
 
-static void damon_pa_mkold(unsigned long paddr)
+static void damon_folio_mkold(struct folio *folio)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	struct rmap_walk_control rwc = {
-		.rmap_one = __damon_pa_mkold,
+		.rmap_one = damon_folio_mkold_one,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 	bool need_lock;
 
-	if (!folio)
-		return;
-
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
 		folio_set_idle(folio);
-		goto out;
+		return;
 	}
 
 	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
 	if (need_lock && !folio_trylock(folio))
-		goto out;
+		return;
 
 	rmap_walk(folio, &rwc);
 
 	if (need_lock)
 		folio_unlock(folio);
 
-out:
+}
+
+static void damon_pa_mkold(unsigned long paddr)
+{
+	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+
+	if (!folio)
+		return;
+
+	damon_folio_mkold(folio);
 	folio_put(folio);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch

