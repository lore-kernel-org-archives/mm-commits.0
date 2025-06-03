Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A8638B
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 03:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748921478; cv=none; b=sdsDL2P3wlxOeSwxE1k3hfv/CE2WLCD9ILA2+9v/VfXNs4sP6mEkKNXMkguR44AKS1HSoCcHRKz1vRtSMKAHFavyUqfei4FgQWyDTIE8va7lY0Y9IYOF0c6iUIMGZOEHhhW7gPd11VDFfRrWMj3e3V1cMOPI0vQNQuNWx7Nyxqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748921478; c=relaxed/simple;
	bh=8Rv7tNsyvMlB0+QffQfIgkQNrDGp+gesS9hCua8KCx0=;
	h=Date:To:From:Subject:Message-Id; b=kk/+RnzOaNa515ARAV33N2cDAPoADzMqaTwxHuiSMcxkM6c35ss/JO0Nhg+DwOR7EKQB8yHiewmXaodnwUWpyahpsS8xUFCt58hbHRtqTQRLzvpJoNl/faoNU9moEMgoTdZmCHVw6YZYiK6WWMFsBYnQTNJ11lXc1qRKFqnHTzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yhKMsQI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yhKMsQI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84314C4CEEB;
	Tue,  3 Jun 2025 03:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748921474;
	bh=8Rv7tNsyvMlB0+QffQfIgkQNrDGp+gesS9hCua8KCx0=;
	h=Date:To:From:Subject:From;
	b=yhKMsQI9/ckV68S45E90k2Xa5zQdxOZ3Wk2Es49etHYWEjgiCGvDARDyUk8Khw4mB
	 px5YUPS3EVT0zReURR1WLMOq1QEwIgKUEcPsbdTT271BqdjL8bylcgQbmE8R7wI6Lm
	 5bYxMtTkvA2qGWDV7rw4Tp5A7UT86yRons65FUyk=
Date: Mon, 02 Jun 2025 20:31:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,osalvador@suse.de,muchun.song@linux.dev,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-hugetlb_change_protection-to-folios.patch added to mm-new branch
Message-Id: <20250603033114.84314C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: convert hugetlb_change_protection() to folios
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-convert-hugetlb_change_protection-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-hugetlb_change_protection-to-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert hugetlb_change_protection() to folios
Date: Wed, 28 May 2025 15:20:13 -0400

The for loop inside hugetlb_change_protection() increments by the huge
page size:

psize = huge_page_size(h);
for (; address < end; address += psize)

so we are operating on the head page of the huge pages between address and
end.  We can safely convert the struct page usage to struct folio.

Link: https://lkml.kernel.org/r/20250528192013.91130-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlb_change_protection-to-folios
+++ a/mm/hugetlb.c
@@ -7186,11 +7186,11 @@ long hugetlb_change_protection(struct vm
 			/* Nothing to do. */
 		} else if (unlikely(is_hugetlb_entry_migration(pte))) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
-			struct page *page = pfn_swap_entry_to_page(entry);
+			struct folio *folio = pfn_swap_entry_folio(entry);
 			pte_t newpte = pte;
 
 			if (is_writable_migration_entry(entry)) {
-				if (PageAnon(page))
+				if (folio_test_anon(folio))
 					entry = make_readable_exclusive_migration_entry(
 								swp_offset(entry));
 				else
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb-convert-hugetlb_change_protection-to-folios.patch

