Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC28812A177
	for <mm-commits@vger.kernel.org>; Sat,  1 Feb 2025 11:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410622; cv=none; b=sW63AF9cDfn2vg/P6H3sMD+MuLx5eYiFZl12wB4einTil+ro9hlSk+5rjBXfJerLN5nJb2cQ13aLcMufUMSER2uPCFa2L/lvaY67eqMfIMF1LGFHoPLde+daPC8LLxOJvtrrLqTzPzxdulvZlwy48f5mgKJ5LrpTPLIEaQ56PAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410622; c=relaxed/simple;
	bh=6wOcURlT4XdWxkGoCnQb+7T53P9R7mIAmvX/aybK+Z0=;
	h=Date:To:From:Subject:Message-Id; b=fxADDLFCWlVW3mbpKKaxyNMnYB40c0BNpo0ukVF7bzK3MbHyy8dRtyD73W4H4yJCMfpNr4FsMMoQKhJPuyEWewFgZyxW5aamtZ90VDxo4ZbwZGKTG2Vr5wn8LlTWh3H0dK7+TpCCyf9K7qjwZ+5CVc0islNPpUPJI4FXwKg5beY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KOZvbYs6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KOZvbYs6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A35C4CEE1;
	Sat,  1 Feb 2025 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410621;
	bh=6wOcURlT4XdWxkGoCnQb+7T53P9R7mIAmvX/aybK+Z0=;
	h=Date:To:From:Subject:From;
	b=KOZvbYs6D67SafMzVNzbtSVqCofCWd/hz9KHu9U0zxFAo1jpuXgutyDJD3kdMLpkF
	 Chz6+R0KOW/v7EP09CIz6+WFm0DYxFRLgVHWFE++zBh5YRrjpVwkKpl1dGP2HqTp1o
	 edyHjiKyVVLE3IAScUvLj8RWJe+5XrjxLTrT3iTc=
Date: Sat, 01 Feb 2025 03:50:20 -0800
To: mm-commits@vger.kernel.org,kaiyang2@cs.cmu.edu,lizhijian@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2.patch removed from -mm tree
Message-Id: <20250201115021.30A35C4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2
has been removed from the -mm tree.  Its filename was
     mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2.patch

This patch was dropped because it was folded into mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch

------------------------------------------------------
From: Li Zhijian <lizhijian@fujitsu.com>
Subject: mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2
Date: Sat, 11 Jan 2025 09:52:53 +0800

introduce local nr_demoted to fix nr_reclaimed double counting

Link: https://lkml.kernel.org/r/20250111015253.425693-1-lizhijian@fujitsu.com
Fixes: f77f0c751478 ("mm,memcg: provide per-cgroup counters for NUMA balancing operations")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Cc: Kaiyang Zhao <kaiyang2@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics-v2
+++ a/mm/vmscan.c
@@ -1086,7 +1086,7 @@ static unsigned int shrink_folio_list(st
 	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
 	LIST_HEAD(demote_folios);
-	unsigned int nr_reclaimed = 0;
+	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
@@ -1550,8 +1550,9 @@ keep:
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	stat->nr_demoted += demote_folio_list(&demote_folios, pgdat);
-	nr_reclaimed += stat->nr_demoted;
+	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_reclaimed += nr_demoted;
+	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
 		/* Folios which weren't demoted go back on @folio_list */
_

Patches currently in -mm which might be from lizhijian@fujitsu.com are

mm-vmscan-accumulate-nr_demoted-for-accurate-demotion-statistics.patch

