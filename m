Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDC82F6900
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 23:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775085489; cv=none; b=i8Yq4zhH/9wAOCCRMJBwN3nYzYJFZQvckMO/zfhti1OdQ6qcb1CjVFaALh78qWENV/uiEtCADodVDfGT7LxEYAlPl7txAxQRfTyqBl5jU5MHm00tXK/3nGO/8qAm3k4W4I7Yg9PG4ImLAxkMrahilfglKpWjaqbqZThPGk+rfsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775085489; c=relaxed/simple;
	bh=LtOrUSUzrPUGxrUF0OKhf2s9/lfDx+cFfS5nwjb1H0Q=;
	h=Date:To:From:Subject:Message-Id; b=UvmnGXKhSTHbQ99qKnnbPqmp+1q3r/FRT1b1lfI0R2VwsagyoI1icYCsJN7Bsk81oP6Fq/5NktdcSAXU8z3Sz65wD7IoZVJeGHvtWLDbYdVpwWK3muOPG/BV8h+AAT99OdgzDmZOdW+105lJ+W6l6PtZUmOozr4djRrENigfM/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tipvIQuq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tipvIQuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3A0C4CEF7;
	Wed,  1 Apr 2026 23:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775085489;
	bh=LtOrUSUzrPUGxrUF0OKhf2s9/lfDx+cFfS5nwjb1H0Q=;
	h=Date:To:From:Subject:From;
	b=tipvIQuqkFEio3ocaL7T8dQb45MhNivfOP8wZTSBxt9T8uRnMeGI4uXjLaV0emP6U
	 J2unS0143XXtiYR/RwMmNjGmxrp6HwA64Yej8EScpWDq4qtAaJtklnncCDiTHY/GMA
	 EEJRyof3yqvVgmyjqjHJPFz7VaDx3BzQ/TopxyYc=
Date: Wed, 01 Apr 2026 16:18:08 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-deferred-split-queue-races-during-migration-fix.patch removed from -mm tree
Message-Id: <20260401231808.DF3A0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-deferred-split-queue-races-during-migration-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-deferred-split-queue-races-during-migration-fix.patch

This patch was dropped because it was folded into mm-fix-deferred-split-queue-races-during-migration.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm-fix-deferred-split-queue-races-during-migration-fix
Date: Wed, 1 Apr 2026 18:52:43 -0400

move the comment

Link: https://lkml.kernel.org/r/FB71A764-0F10-4E5A-B4A0-BA4C7F138408@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-fix-deferred-split-queue-races-during-migration-fix
+++ a/mm/huge_memory.c
@@ -4551,15 +4551,18 @@ retry:
 		}
 		folio_unlock(folio);
 next:
+		/*
+		 * If thp_underused() returns false, or if split_folio()
+		 * succeeds, or if split_folio() fails in the case it was
+		 * underused, then consider it used and don't add it back to
+		 * split_queue.
+		 */
 		if (did_split || !folio_test_partially_mapped(folio))
 			continue;
 requeue:
 		/*
-		 * Add back partially mapped folios, or underused folios
-		 * that we could not lock this round.  If thp_underused()
-		 * returns false, or if split_folio() succeeds, or if
-		 * split_folio() fails in the case it was underused, then
-		 * consider it used and don't add it back to split_queue.
+		 * Add back partially mapped folios, or underused folios that
+		 * we could not lock this round.
 		 */
 		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
 		if (list_empty(&folio->_deferred_list)) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-fix-deferred-split-queue-races-during-migration.patch

