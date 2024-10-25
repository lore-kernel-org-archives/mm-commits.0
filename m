Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7D3217F30;
	Fri, 25 Oct 2024 22:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729895281; cv=none; b=r8FNkZsy0nbCdmSdd8VgmUmJA2ZvdtVqQguWbEUBpWa7tY4Rd3e9sLNzqc1SJc5qi3cbG7HaI/JG9BvLQ0i6g+DbIWzquXwosybISfARD3oerSDB7ZYYUgNqf0Y2KLmjb6sMoTAgK8uw7etifghE0iIFDADzuwnRLtSr0JCIyYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729895281; c=relaxed/simple;
	bh=zBhDOg2t3prhPH7OS87raS55yMOVGdtaa0G25RnYt3s=;
	h=Date:To:From:Subject:Message-Id; b=UOkG9Li8fjkbcXPHPOhcG/Bu/4x7Zw+gg7leyAdWFdNltvlsm9mvLo39bHo9tWZCl5b0AoQukmCObpLBdWBysG3F4LE6gPLJfzJNuuAWBLvRkcNb7XA00RbLw6g/FB930kQD+0ULyzss+H9mEFJvCiditSCLRAvln327WQEbLqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=msaPJtRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="msaPJtRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25727C4CEC3;
	Fri, 25 Oct 2024 22:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729895281;
	bh=zBhDOg2t3prhPH7OS87raS55yMOVGdtaa0G25RnYt3s=;
	h=Date:To:From:Subject:From;
	b=msaPJtRqSpdg0vqfGw1qZQ1sf3G8U0Apm23qeerFhD7lQmPelIctwKUCoLHoaf29m
	 rIzSwzOV60lE471mgmBHB7iYpAZtWNrfBMX+jGROh1rbdcAMlqXY+jqxxQRpzeGtRq
	 SswkEjaYq2M3SGG6/15b7PCz3QNPjt0mFGK158zw=
Date: Fri, 25 Oct 2024 15:28:00 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,weixugc@google.com,stable@vger.kernel.org,shy828301@gmail.com,osalvador@suse.de,dave.hansen@linux.intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscanmigrate-fix-double-decrement-on-node-stats-when-demoting-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20241025222801.25727C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmscan,migrate: fix double-decrement on node stats when demoting pages
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
Subject: vmscan,migrate: fix double-decrement on node stats when demoting pages
Date: Fri, 25 Oct 2024 10:17:24 -0400

When numa balancing is enabled with demotion, vmscan will call
migrate_pages when shrinking LRUs.  Successful demotions will cause node
vmstat numbers to double-decrement, leading to an imbalanced page count. 
The result is dmesg output like such:

$ cat /proc/sys/vm/stat_refresh

[77383.088417] vmstat_refresh: nr_isolated_anon -103212
[77383.088417] vmstat_refresh: nr_isolated_file -899642

This negative value may impact compaction and reclaim throttling.

The double-decrement occurs in the migrate_pages path:

caller to shrink_folio_list decrements the count
  shrink_folio_list
    demote_folio_list
      migrate_pages
        migrate_pages_batch
          migrate_folio_move
            migrate_folio_done
              mod_node_page_state(-ve) <- second decrement

This path happens for SUCCESSFUL migrations, not failures.  Typically
callers to migrate_pages are required to handle putback/accounting for
failures, but this is already handled in the shrink code.

When accounting for migrations, instead do not decrement the count when
the migration reason is MR_DEMOTION.  As of v6.11, this demotion logic is
the only source of MR_DEMOTION.

Link: https://lkml.kernel.org/r/20241025141724.17927-1-gourry@gourry.net
Fixes: 26aa2d199d6f2 ("mm/migrate: demote pages during reclaim")
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
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

