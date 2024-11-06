Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA3218801F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854830; cv=none; b=cFyyYw227kR6tfZF46tdi88yahEwn3ACZUDoJzOinBYWcGpdjGuKMLRAay+s6z9bd51XtSWFpWTzTGWNn1itIiwtOfhdevFl5DmTvDRxoYRFo97+8n4I8Xi5SlYriu8qgnzpiQPZPJRAF4xHbQ1I+WuqPguJvD7x8o18FTliWGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854830; c=relaxed/simple;
	bh=kkht6G7K9bLmWz2x/CKErF1jW7Jg/dhCJ9t8RRBgcDY=;
	h=Date:To:From:Subject:Message-Id; b=hS81xbLst9PLG4FzmY+ih4FNFwbGaOVl7vEV6M5EItRXGI1mRcElSeWkApLNtqKd2257a32XgfiHYfVmzuSgmxjOoUNuumUL+E253oQ5a4qt5b5iSF6ncJuiEQ7hrzFVoScXPvujg+lIFZ/ZkLUfZimN89EvRNwqEKWXUfVT3Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GppxIYxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GppxIYxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45408C4CECF;
	Wed,  6 Nov 2024 01:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854830;
	bh=kkht6G7K9bLmWz2x/CKErF1jW7Jg/dhCJ9t8RRBgcDY=;
	h=Date:To:From:Subject:From;
	b=GppxIYxdUl7dSHsoCjSDeDU6amwm0dsQo/95ngT6lKRgUrOKpUWJH1HkxViLzX3Y6
	 aOReRQ9XnurevTyzg3qhynrhm/ClCHwNQjadwrVZGEl9UDstSHyYTvjHKtw2j2D3Z2
	 qg6PPaR+QuYCVQJJLCDbEAdqaDpmFjT2ToJiGgmc=
Date: Tue, 05 Nov 2024 17:00:29 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,david@redhat.com,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-redundant-condition-for-thp-folio.patch removed from -mm tree
Message-Id: <20241106010030.45408C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove redundant condition for THP folio
has been removed from the -mm tree.  Its filename was
     mm-remove-redundant-condition-for-thp-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: remove redundant condition for THP folio
Date: Fri, 18 Oct 2024 15:11:51 +0530

folio_test_pmd_mappable() implies folio_test_large(), therefore, simplify
the expression for is_thp.

Link: https://lkml.kernel.org/r/20241018094151.3458-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-remove-redundant-condition-for-thp-folio
+++ a/mm/migrate.c
@@ -1733,7 +1733,7 @@ static int migrate_pages_batch(struct li
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
 			is_large = folio_test_large(folio);
-			is_thp = is_large && folio_test_pmd_mappable(folio);
+			is_thp = folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
 			cond_resched();
_

Patches currently in -mm which might be from dev.jain@arm.com are


