Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4C438F96
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957130; cv=none; b=Mbr8oj0skCzapCqJxvZ2txDd+UErVFWB3NC/Y/7F9eydxZW5MqLdnbPBegvjmWyq2KrUotIzyeaoyIWVCRzPTAxg8YQbCti5wOjmH0MKW8w45Mp/rLoQpY5nCjN38RYkQ9vmdh+OLaXe1EwUtYOC1H74k3QSBr7WISFzqkox7dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957130; c=relaxed/simple;
	bh=7breso9+H7Qt5RGqqHDV/VU8nYGk39ocCZ7E7fsvLoY=;
	h=Date:To:From:Subject:Message-Id; b=I+bG7Pui2lLyhrtkSQuNsJxDtP01x6Aa5SCtHOiA0rGloSI0spkaMx2u+jMoGjBom0HydrLENy7F1sSVuad47tgAFhd/FZ3P1n1A2vv+AbjjLgr8anq5uP0XSz7mhO24pJVXnTElHOUzMe9OmI95BK5ZmaozU3qK4DoAyAMQJ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oJPgwpjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oJPgwpjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84315C113CC;
	Mon,  6 May 2024 00:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957130;
	bh=7breso9+H7Qt5RGqqHDV/VU8nYGk39ocCZ7E7fsvLoY=;
	h=Date:To:From:Subject:From;
	b=oJPgwpjXiUxADT07Ww5Uil2hFpdBhtfOVYi5A0xXLnMHqrtZa4HN0V5it6/ivzi1K
	 7r8y4/eJlFDqSddDE+ApEax01dCWZ5i7ZGVDY6jW/oG1UUCDhpFjhmUpgyYkq2mZ2Q
	 VQJ87pERq3xRaD+731Ca5kOTIlHhBdZjJP8bTeRg=
Date: Sun, 05 May 2024 17:58:50 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-implement-damon_folio_mkold.patch removed from -mm tree
Message-Id: <20240506005850.84315C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/paddr: implement damon_folio_mkold()
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-implement-damon_folio_mkold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

