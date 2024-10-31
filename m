Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA0513699A;
	Thu, 31 Oct 2024 03:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344521; cv=none; b=lvBvw65PVx7xLeOnuOL2rUNxlCWDRYS0xJgbM5HMoJr5oecx1Ns8G1wdQvCU/LK0wtcmfhUdxDVISgHHn5BpAxvorJ4CSkZ++fyenVrNMIRtOHiuUhxzEvTY2IXhn4Qrn2zy7cLvuQYvqfDRa9u/grgxO0pxCrRxUb81ILUiHDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344521; c=relaxed/simple;
	bh=6dhqCd17MZYjOxClJ9nHc+y0HjDN/59G1SIM7Oo9cH4=;
	h=Date:To:From:Subject:Message-Id; b=sR4OZfyYo7MRVT1Gn3JdWit6o282TFSUs6Qb+TXiER4DQ7UES+0K1nlxUC83EVSLi9Wq3T1X7ZlqWhXNxTrkAQN7kEaw0mENPQlNEFpnC0bdsBd218rNFHOi8GSqA1mDFzeSejs4CoAR16FMC2q9xdANaj1T0vuUn3j4EXiLJ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rRZXGLHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rRZXGLHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA392C4CECE;
	Thu, 31 Oct 2024 03:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344519;
	bh=6dhqCd17MZYjOxClJ9nHc+y0HjDN/59G1SIM7Oo9cH4=;
	h=Date:To:From:Subject:From;
	b=rRZXGLHWpUdCFAta4wfRxlWc2VzrpTSmnp4Kx3lVu/2IqKaODfltNK7pj8JdngBxW
	 31gF0o6oKJbI0nF5GXaMEEZ8/9MI/zZtkaKsaKfw3YeKznT4nonLO1fz2exB+bjaLk
	 eNZYUH5lLOVg0DhnNwlE7rxuCp8jSYSq601tBdCU=
Date: Wed, 30 Oct 2024 20:15:19 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,weixugc@google.com,stable@vger.kernel.org,shy828301@gmail.com,shakeel.butt@linux.dev,osalvador@suse.de,dave@stgolabs.net,dave.hansen@linux.intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] vmscanmigrate-fix-double-decrement-on-node-stats-when-demoting-pages.patch removed from -mm tree
Message-Id: <20241031031519.DA392C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmscan,migrate: fix page count imbalance on node stats when demoting pages
has been removed from the -mm tree.  Its filename was
     vmscanmigrate-fix-double-decrement-on-node-stats-when-demoting-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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


