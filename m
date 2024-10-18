Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8CE18D65E
	for <mm-commits@vger.kernel.org>; Fri, 18 Oct 2024 21:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729286564; cv=none; b=Gb7JEnupa+KR9wNwp6UgJS62L1gnfAWuKkVv7VetLdLd5wwKEOvD37oGRxn1A9ro673/meZXsVJeHhfRrFC6IcvKflOamOAmx9s+FS6B520NuHdoiDtRFMaPEURgIZEo//FkzBU8TkN+HIljFQ3+kc3AXrY7DxCixE5cufS4ces=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729286564; c=relaxed/simple;
	bh=Wnci3Mq6zjKW2i9LcdoUATLrdS0rDmSMYEdVwWjZFp4=;
	h=Date:To:From:Subject:Message-Id; b=ZlJ3zJ97pUlfturP0xdliXiMWxx8WtrDs2mL+UoZxys5+yyw4oSl76XtR2RSXhcC/cGUchcZHIMRIDHjuxiaIk/8c6lkornidPWgisq1GvPZlE7OpCGf8H8XS3VbMSFEfkBGvEqUHA7ZzhVDfRWXwXkHmcw0jGGESklzaMzDYPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vajw8uKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vajw8uKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C62C4CEC3;
	Fri, 18 Oct 2024 21:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729286563;
	bh=Wnci3Mq6zjKW2i9LcdoUATLrdS0rDmSMYEdVwWjZFp4=;
	h=Date:To:From:Subject:From;
	b=vajw8uKiQMJkUAuQxs32oAvg62/2Gc0ZXyaa2ivm7j4cYPPw/1HOf7S5tTFSGTHsp
	 DvSCyWLY7qNjOhMZf0jGvGfSbmirnPty0KMAzACilERaaQHhc9378hsBTU47qWFaC3
	 LpSRtDIAdv2JfydOQr/FrMo55D2hLigZ+pVHxNwc=
Date: Fri, 18 Oct 2024 14:22:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,david@redhat.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-redundant-condition-for-thp-folio.patch added to mm-unstable branch
Message-Id: <20241018212243.C0C62C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove redundant condition for THP folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-redundant-condition-for-thp-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-redundant-condition-for-thp-folio.patch

This patch will later appear in the mm-unstable branch at
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
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-remove-redundant-condition-for-thp-folio
+++ a/mm/migrate.c
@@ -1732,7 +1732,7 @@ static int migrate_pages_batch(struct li
 
 		list_for_each_entry_safe(folio, folio2, from, lru) {
 			is_large = folio_test_large(folio);
-			is_thp = is_large && folio_test_pmd_mappable(folio);
+			is_thp = folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
 			cond_resched();
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-abstract-thp-allocation.patch
mm-allocate-thp-on-hugezeropage-wp-fault.patch
mm-remove-redundant-condition-for-thp-folio.patch

