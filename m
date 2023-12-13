Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFF515A4
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kTkypWcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491C3C433C8;
	Wed, 13 Dec 2023 01:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430349;
	bh=WlW5SLtU3FMjur+omyxsRiDh4hGElxRw1Q5eeiL2mP8=;
	h=Date:To:From:Subject:From;
	b=kTkypWcJBpdQhAgEqO96aLhwptV2BoG0jXenCX1uBN1Vu7mdMTbJ4Hv8Ouz76EAjv
	 qQhf+vUp/eJRfaWYRNKiX3IzWqps6C17xCV83g/zTL4EdjP3cbtUKp6nEKVKhi/pY6
	 Hhly7mjvOR7Cmz14iwQ0R2QNTU23Lk2mDcHJA30k=
Date: Tue, 12 Dec 2023 17:19:08 -0800
To: mm-commits@vger.kernel.org,stevensd@chromium.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch removed from -mm tree
Message-Id: <20231213011909.491C3C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch

This patch was dropped because it was folded into mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix
Date: Wed Jun  7 11:58:24 AM PDT 2023

tidy up comment layout

Cc: David Stevens <stevensd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix
+++ a/mm/shmem.c
@@ -1085,10 +1085,12 @@ whole_folios:
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
 					/*
-					 * If we split a page, reset the loop so that we
-					 * pick up the new sub pages. Otherwise the THP
-					 * was entirely dropped or the target range was
-					 * zeroed, so just continue the loop as is.
+					 * If we split a page, reset the loop so
+					 * that we pick up the new sub pages.
+					 * Otherwise the THP was entirely
+					 * dropped or the target range was
+					 * zeroed, so just continue the loop as
+					 * is.
 					 */
 					if (!folio_test_large(folio)) {
 						folio_unlock(folio);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch

