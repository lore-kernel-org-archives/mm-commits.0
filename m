Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2369338F9A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 03:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287565; cv=none; b=XtBrIwuTaWpqDkuBnFxSgNPHwyboXJRvSpVi+g3DkAo3xPf06YtkrKu7sADohpt+ECTN/IwxkzVnHIYiLUhVukBII+szB79U3FdE0iju3W5B8jeC40IljOR2g2w30MNn1fjy/vlj2NHBHHiQQwZvJNLNuKeHaF5W2CukWO/whx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287565; c=relaxed/simple;
	bh=/uzIBSywLRZNwEDK/x+eBvvnvr0Dof2YPl4oy9DpmLo=;
	h=Date:To:From:Subject:Message-Id; b=ppwiKx+QiQeqX2QsZTunlyz3v286hmd+MxGAnfnET9hd/WkzWUf8F/Ij7u0kVWxM2/HQERdtjVK/7soHDA3BW2uHJ/UM9PW5xFuWdS67Xizw+05bGgSTqxvkA7RftmUXhgEwFCOSz5GnMK56fTB7hTNSSCWyA65ZeaXo+F1UH8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pZjscSPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pZjscSPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB733C32789;
	Tue, 25 Jun 2024 03:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287565;
	bh=/uzIBSywLRZNwEDK/x+eBvvnvr0Dof2YPl4oy9DpmLo=;
	h=Date:To:From:Subject:From;
	b=pZjscSPRwwpsqWGx6xslEmxRYPMz4ed5As5UfMVQOK4/bCuPBzQQqk9zMjR2rVj0u
	 +KEB8m+ich3LhvyT9B315n8db36Qwt+SGxLd8f137KNnispD3hVkET5MdBgR79lKTt
	 qzg1NtJOGBGDkABoNOU42GN9x6ep2QFXhi8UNfeQ=
Date: Mon, 24 Jun 2024 20:52:44 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,shy828301@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-migrate-make-migrate_pages_batch-stats-consistent.patch removed from -mm tree
Message-Id: <20240625035244.EB733C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: make migrate_pages_batch() stats consistent
has been removed from the -mm tree.  Its filename was
     mm-migrate-make-migrate_pages_batch-stats-consistent.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: make migrate_pages_batch() stats consistent
Date: Tue, 18 Jun 2024 09:41:51 -0400

As Ying pointed out in [1], stats->nr_thp_failed needs to be updated to
avoid stats inconsistency between MIGRATE_SYNC and MIGRATE_ASYNC when
calling migrate_pages_batch().

Because if not, when migrate_pages_batch() is called via
migrate_pages(MIGRATE_ASYNC), nr_thp_failed will not be increased and when
migrate_pages_batch() is called via migrate_pages(MIGRATE_SYNC*),
nr_thp_failed will be increase in migrate_pages_sync() by
stats->nr_thp_failed += astats.nr_thp_split.

[1] https://lore.kernel.org/linux-mm/87msnq7key.fsf@yhuang6-desk2.ccr.corp.intel.com/

Link: https://lkml.kernel.org/r/20240620012712.19804-1-zi.yan@sent.com
Link: https://lkml.kernel.org/r/20240618134151.29214-1-zi.yan@sent.com
Fixes: 7262f208ca68 ("mm/migrate: split source folio if it is on deferred split list")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/migrate.c~mm-migrate-make-migrate_pages_batch-stats-consistent
+++ a/mm/migrate.c
@@ -1659,6 +1659,10 @@ static int migrate_pages_batch(struct li
 			 * migrate_pages() may report success with (split but
 			 * unmigrated) pages still on its fromlist; whereas it
 			 * always reports success when its fromlist is empty.
+			 * stats->nr_thp_failed should be increased too,
+			 * otherwise stats inconsistency will happen when
+			 * migrate_pages_batch is called via migrate_pages()
+			 * with MIGRATE_SYNC and MIGRATE_ASYNC.
 			 *
 			 * Only check it without removing it from the list.
 			 * Since the folio can be on deferred_split_scan()
@@ -1675,6 +1679,7 @@ static int migrate_pages_batch(struct li
 			   !list_empty(&folio->_deferred_list)) {
 				if (try_split_folio(folio, split_folios) == 0) {
 					nr_failed++;
+					stats->nr_thp_failed += is_thp;
 					stats->nr_thp_split += is_thp;
 					stats->nr_split++;
 					continue;
_

Patches currently in -mm which might be from ziy@nvidia.com are


