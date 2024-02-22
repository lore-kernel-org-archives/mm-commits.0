Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE15E1A5A2
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644513; cv=none; b=uZGpU1tB1EvvZoitQ7+HITPnU1mTnGzZ8DeH6AF7nwasqlHtJDQZAoZZCDB9sO6qLg+nm5vMfZ98fTxSa3+uYdWD/9P0M18rku0w6kF47jC7AXJ4cnZU2wxj7CVZ2Ld7IkPPYMZKR4NaiVFfVAxJ7GakMS4y0hYWBlEFnaWNHs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644513; c=relaxed/simple;
	bh=ipvKsGRP3RRUAzoCF7OYAYb+UXYuxCvZBq2mB1Wrhpw=;
	h=Date:To:From:Subject:Message-Id; b=RKwv/LepHQlY4BohD5pIWUztArFwwvs5kqUVDcalh0mjRvBE83mWUi4If2YIcQq1VMl/NvMSAtFSLPTe2QAvVpY8ch2Hc2qcl75DXSvy9g1zv55clhha+aoMLD6TkisOUeBtGkXUMEJSlJMMHwhnPW7xmuY9rCDUFJFX5h3OtYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ceoccrFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ceoccrFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51899C433C7;
	Thu, 22 Feb 2024 23:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644513;
	bh=ipvKsGRP3RRUAzoCF7OYAYb+UXYuxCvZBq2mB1Wrhpw=;
	h=Date:To:From:Subject:From;
	b=ceoccrFtdBz6rFifsXotHC71Vlwslj9UwOXFTQdPzB59bIyCDGECFxB1VeoaZEP62
	 Ib1/r/Ad1P58dzxH40vxKlIkgNs4PGwshEBIu6lLtiNUxS7xobHL1gfPmUOieWAPXm
	 HKKdx/RAnElPkEupoJdZr+eRyKAzCKLuMWa7jiY0=
Date: Thu, 22 Feb 2024 15:28:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rmap-replace-two-calls-to-compound_order-with-folio_order.patch removed from -mm tree
Message-Id: <20240222232833.51899C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rmap: replace two calls to compound_order with folio_order
has been removed from the -mm tree.  Its filename was
     rmap-replace-two-calls-to-compound_order-with-folio_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: rmap: replace two calls to compound_order with folio_order
Date: Thu, 15 Feb 2024 20:53:05 +0000

Removes two unnecessary conversions from folio to page.  Should be no
difference in behaviour.

Link: https://lkml.kernel.org/r/20240215205307.674707-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~rmap-replace-two-calls-to-compound_order-with-folio_order
+++ a/mm/rmap.c
@@ -2169,7 +2169,7 @@ static bool try_to_migrate_one(struct fo
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			set_pte_at(mm, pvmw.address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(pvmw.address, pte_val(swp_pte),
-						compound_order(&folio->page));
+						folio_order(folio));
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
@@ -2261,7 +2261,7 @@ static bool try_to_migrate_one(struct fo
 			else
 				set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
-						compound_order(&folio->page));
+						folio_order(folio));
 			/*
 			 * No need to invalidate here it will synchronize on
 			 * against the special swap migration pte.
_

Patches currently in -mm which might be from willy@infradead.org are

writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

