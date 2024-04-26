Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E810C7602B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101735; cv=none; b=DbB3u/6uP00J562xFgniyA6f3fz0lszCmrTCg19dTLSwF4YW+/oJ0gqcFUaeLpQUvFhTR8WS+CpaqcDMYPfN7FJGQVqd84TKJUBAZvXx0tJ8v6Khc7oJQTUgj98idu/OFCnfsovlelnG7H0qMuTc10q0+ehH1PPON95kg7G4FSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101735; c=relaxed/simple;
	bh=663SWwcF67fIZagK/r+Ef25ytdTVx6mKgpAATlG4G1Q=;
	h=Date:To:From:Subject:Message-Id; b=RE3oG3bSHxHJXTW3CgQpNtGlKQfvuUJ2d3qwSFmSwt2FLVlTMRaoUXEQtR/EhEN3vfLCgco8CwLITsBEf46YlvVIxTW57mbNIE6flM4FcOEbYzpPJgVlIJkRAUAqcxEtECR+MnZudVnsbj8jYoWyQ6FNOsL3xjLm/wK6LyZFd5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tUIAGD4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tUIAGD4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6471BC113CD;
	Fri, 26 Apr 2024 03:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101734;
	bh=663SWwcF67fIZagK/r+Ef25ytdTVx6mKgpAATlG4G1Q=;
	h=Date:To:From:Subject:From;
	b=tUIAGD4VG2F6XYmbKkbLPRRm78AZpmyMh2iOMwF1S6Y+CqX4b2azkbBwss10irTuS
	 O/AY5x9LQCEAGWQFjf+3vn7zW4whi4KiEdjoWMWIYYo2nlOPKVhaQWCbQRu/5zdk8e
	 135ZezuIbu6K8G8KWjQ9f5A2LIkEA1DAfjT4Wnp0=
Date: Thu, 25 Apr 2024 20:22:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,sj@kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,fengwei.yin@intel.com,baolin.wang@linux.alibaba.com,zi.yan@sent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix.patch removed from -mm tree
Message-Id: <20240426032214.6471BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix
has been removed from the -mm tree.  Its filename was
     mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix.patch

This patch was dropped because it was folded into mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch

------------------------------------------------------
From: Zi Yan <zi.yan@sent.com>
Subject: mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix
Date: Tue, 26 Mar 2024 11:00:31 -0400

fix an error in migrate_misplaced_folio() reported by Baolin Wang

Link: https://lkml.kernel.org/r/20240326150031.569387-1-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/df9a644c-a007-46ac-98e3-61d4014fcfff@linux.alibaba.com/
Fixes: 616b8371539a ("mm: thp: enable thp migration in generic path")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-split-source-folio-if-it-is-on-deferred-split-list-fix
+++ a/mm/migrate.c
@@ -1668,7 +1668,7 @@ static int migrate_pages_batch(struct li
 			 */
 			if (nr_pages > 2 &&
 			   !list_empty(&folio->_deferred_list)) {
-				if (try_split_folio(folio, from) == 0) {
+				if (try_split_folio(folio, split_folios) == 0) {
 					stats->nr_thp_split += is_thp;
 					stats->nr_split++;
 					continue;
_

Patches currently in -mm which might be from zi.yan@sent.com are

mm-migrate-split-source-folio-if-it-is-on-deferred-split-list.patch

