Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E4B1D5171;
	Mon, 28 Oct 2024 23:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730159533; cv=none; b=R6VM0qCeSjXU4Gq9QISAwAjBJS8+rQyVKJN+ZqC/P9/8oF1pbxrws1ampKRKvlCYeGb1lQwskEaaTYQoLYplvpRvhiITO7nCgsbskWTS05FDL4Q3ikRaGAR4/2XAgybqsDUC0/b8u45L1uoM2SsIhpOv7WajNRNQqYTuX3bYRE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730159533; c=relaxed/simple;
	bh=JQ/lrItjqcXm/4ktsrc19zrWcrH8BaO6JqbI7d3GTnQ=;
	h=Date:To:From:Subject:Message-Id; b=Nl5meNuvXebNbrYOPo2yd0J6DQCrbamOd68ToC67uktVY1bZorVHTZWWlIjBZDxGNI9yuuH/0S1FucQP/Sy/H16jQKHRYdyWg/Xt0ESIDOzzmZOckbJCUHTg+57RgBJD6LfedZdIdwRPs2Q2X7S6Pd2ZUy96gH3Qt/XW4hBTcv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cfzYzDj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cfzYzDj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42146C4CEC3;
	Mon, 28 Oct 2024 23:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730159532;
	bh=JQ/lrItjqcXm/4ktsrc19zrWcrH8BaO6JqbI7d3GTnQ=;
	h=Date:To:From:Subject:From;
	b=cfzYzDj1taYm1kyUe7izTNFgapsvhMD7OuYgFrHmBt+fkk/Ke5bjbFkdkOAeDsvLY
	 RgqwL2YmQenFXDTZp5DNcoCCJa9mSpNd0j1scP8bZwEb+TruJdmPdeXjaIFH4okXGM
	 1xWZ1eX+S+MjKd6DqZ8wAHHFXkYLhOY3lJM5bXzY=
Date: Mon, 28 Oct 2024 16:52:11 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,weixugc@google.com,stable@vger.kernel.org,shy828301@gmail.com,osalvador@suse.de,dave.hansen@linux.intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscanmigrate-fix-double-decrement-on-node-stats-when-demoting-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20241028235212.42146C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmscan,migrate: fix page count imbalance on node stats when demoting pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     vmscanmigrate-fix-double-decrement-on-node-stats-when-demoting-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmscanmigrate-fix-double-decrement-on-node-stats-when-demoting-pages.patch

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
From: Gregory Price <gourry@gourry.net>
Subject: vmscan,migrate: fix page count imbalance on node stats when demoting pages
Date: Fri, 25 Oct 2024 10:17:24 -0400

When numa balancing is enabled with demotion, vmscan will call
migrate_pages when shrinking LRUs.  migrate_pages will decrement the
the node's isolated page count, leading to an imbalanced count when
invoked from (MG)LRU code.

The result is dmesg output like such:

$ cat /proc/sys/vm/stat_refresh

[77383.088417] vmstat_refresh: nr_isolated_anon -103212
[77383.088417] vmstat_refresh: nr_isolated_file -899642

This negative value may impact compaction and reclaim throttling.

The following path produces the decrement:

shrink_folio_list
  demote_folio_list
    migrate_pages
      migrate_pages_batch
        migrate_folio_move
          migrate_folio_done
            mod_node_page_state(-ve) <- decrement

This path happens for SUCCESSFUL migrations, not failures.  Typically
callers to migrate_pages are required to handle putback/accounting for
failures, but this is already handled in the shrink code.

When accounting for migrations, instead do not decrement the count when
the migration reason is MR_DEMOTION.  As of v6.11, this demotion logic
is the only source of MR_DEMOTION.

Link: https://lkml.kernel.org/r/20241025141724.17927-1-gourry@gourry.net
Fixes: 26aa2d199d6f ("mm/migrate: demote pages during reclaim")
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Xu <weixugc@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~vmscanmigrate-fix-double-decrement-on-node-stats-when-demoting-pages
+++ a/mm/migrate.c
@@ -1178,7 +1178,7 @@ static void migrate_folio_done(struct fo
 	 * not accounted to NR_ISOLATED_*. They can be recognized
 	 * as __folio_test_movable
 	 */
-	if (likely(!__folio_test_movable(src)))
+	if (likely(!__folio_test_movable(src)) && reason != MR_DEMOTION)
 		mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
 				    folio_is_file_lru(src), -folio_nr_pages(src));
 
_

Patches currently in -mm which might be from gourry@gourry.net are

vmscanmigrate-fix-double-decrement-on-node-stats-when-demoting-pages.patch

