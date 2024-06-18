Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F390D16D9CB
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739861; cv=none; b=Ny5fvbHWlm69NsR7+HZL3a/yZcat37Cv3slnMwEv3WE1JkPjP5BG3jLVQdC370PYs6rnEg22h0P0FxvtMuVUweGCoWoH3I5vtOL/G5Brz3Aef0GY3DaWSIEh/onxU7ti20U9ENh9/oq6O/Fc5xczM9+wwejosGKsOOYamrRawqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739861; c=relaxed/simple;
	bh=551KRMAGB3YAjbDQE6MeQCVf7RbcxelSu1w101M+U4M=;
	h=Date:To:From:Subject:Message-Id; b=JQkhyX1SBU0Ox7mxxAk7i7F40KwnrjzHb8FAfKGs7qvzk1nW9hwK/heMVSTbFk7H8G7JpGQ0pjQKutQJ/8nl7v8nEsp/MFLqNvtbEef5eTOxXfEB5cx65fC7rC0GKkrmJIS4KShj9ijX7nz3P9xAFFdzmBbbGq/so8PyHlu2DZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lvnEROYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lvnEROYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7653CC3277B;
	Tue, 18 Jun 2024 19:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739860;
	bh=551KRMAGB3YAjbDQE6MeQCVf7RbcxelSu1w101M+U4M=;
	h=Date:To:From:Subject:From;
	b=lvnEROYD3JMF4+XJsUo/S9R6oXWa5DboPkpgOpSkMHUlja0y5UpALwL58LVbdrMI8
	 KpKl0WYCCe/prfulwBoTAlzvZq5B19vJgD8dbE5DUAbeQq9XkF64e9hdupc1EGsI1+
	 CQXCnz5iXzZJSclTpmH2utn9tKZSr/Atn5W2V1WM=
Date: Tue, 18 Jun 2024 12:44:19 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,shy828301@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-make-migrate_pages_batch-stats-consistent.patch added to mm-hotfixes-unstable branch
Message-Id: <20240618194420.7653CC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: make migrate_pages_batch() stats consistent
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-migrate-make-migrate_pages_batch-stats-consistent.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-make-migrate_pages_batch-stats-consistent.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/migrate: make migrate_pages_batch() stats consistent
Date: Tue, 18 Jun 2024 09:41:51 -0400

As Ying pointed out in [1], stats->nr_thp_failed needs to be updated to
avoid stats inconsistency between MIGRATE_SYNC and MIGRATE_ASYNC when
calling migrate_pages_batch().

[1] https://lore.kernel.org/linux-mm/87msnq7key.fsf@yhuang6-desk2.ccr.corp.intel.com/

Link: https://lkml.kernel.org/r/20240618134151.29214-1-zi.yan@sent.com
Fixes: 7262f208ca68 ("mm/migrate: split source folio if it is on deferred split list")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
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

mm-migrate-make-migrate_pages_batch-stats-consistent.patch

