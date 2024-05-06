Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9C63A8E4
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957172; cv=none; b=D3DdI2Oir67h0nJZXXW0PUIco8QbXV/iKnU/QjZLjEGoZ8mHG+x+GYuNuLhKVgb3z0kwMP8tvZlBilLeDk1zquFA+0ksGePWIaRumC+YmficULfcXMAzGgbYOTVvFUi36J549/fAuZfpNEO2ufim6RKP+V+TJTX+cvv/OorkvEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957172; c=relaxed/simple;
	bh=rmuahZu/FC0yOmNQhmh0wzek3ufi6losWYPzugMAx58=;
	h=Date:To:From:Subject:Message-Id; b=ltZ3aj5ubEKzUkSAzdrup9lf9lNfwGUEAAOds2U6dYVQLEtmUJm9dI3zPw21+C4F8ZQGMuZwI86SP9lM7iqvxBMuYbMl/ESt2+g4YioYVy2UXX5nXVf+eCnK3XCVVVa61kF7czvn2j7H28CR70OfBUIeyYpneL0taGo0840WihY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ev6CU1H+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ev6CU1H+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A262C113CC;
	Mon,  6 May 2024 00:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957172;
	bh=rmuahZu/FC0yOmNQhmh0wzek3ufi6losWYPzugMAx58=;
	h=Date:To:From:Subject:From;
	b=Ev6CU1H+ukboWXpw9vtB5Ce6D3n9THTBuSk/8Gpgk3lRuoVF90DL+BBbqppEEaGJK
	 IWyY+PW343VTVcu1TmrhQsZb8OdhreBxPNUpPom84Ld0GEW5X0F+rCxUXxAxlVISIA
	 LtHrgyRmd/HysJ4Xx8puoJI5XqTcrGk2aJEBvqkQ=
Date: Sun, 05 May 2024 17:59:31 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch removed from -mm tree
Message-Id: <20240506005932.1A262C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: remove ignore_references argument of reclaim_folio_list()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/vmscan: remove ignore_references argument of reclaim_folio_list()
Date: Mon, 29 Apr 2024 15:44:51 -0700

All reclaim_folio_list() callers are passing 'true' for
'ignore_references' parameter.  In other words, the parameter is not
really being used.  Simplify the code by removing the parameter.

Link: https://lkml.kernel.org/r/20240429224451.67081-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list
+++ a/mm/vmscan.c
@@ -2109,8 +2109,7 @@ static void shrink_active_list(unsigned
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
-				      struct pglist_data *pgdat,
-				      bool ignore_references)
+				      struct pglist_data *pgdat)
 {
 	struct reclaim_stat dummy_stat;
 	unsigned int nr_reclaimed;
@@ -2123,7 +2122,7 @@ static unsigned int reclaim_folio_list(s
 		.no_demotion = 1,
 	};
 
-	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &dummy_stat, ignore_references);
+	nr_reclaimed = shrink_folio_list(folio_list, pgdat, &sc, &dummy_stat, true);
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
@@ -2155,12 +2154,11 @@ unsigned long reclaim_pages(struct list_
 			continue;
 		}
 
-		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid),
-						   true);
+		nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
 		nid = folio_nid(lru_to_folio(folio_list));
 	} while (!list_empty(folio_list));
 
-	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid), true);
+	nr_reclaimed += reclaim_folio_list(&node_folio_list, NODE_DATA(nid));
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 
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

