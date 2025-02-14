Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D8F1C84D9
	for <mm-commits@vger.kernel.org>; Fri, 14 Feb 2025 23:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739576434; cv=none; b=dQkm3QJ/VOTxJfFHIARpVTbq3IwKL0YYEPWm3bzSpxG+ZIlINCTinPEwaeQoNBlSbgk9SKb0YoL08Oq7GoakvD9HvmUQXbfLqFMP3GHv0SR7lAbDhyZY9rya+yeHQNxBNQjb/nLKmRlyFZnJIdwKdcO3UWVvHSVgL9cvAErMZiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739576434; c=relaxed/simple;
	bh=ntJSCUwQbRPDVF/b6Tog882nPDevKCQpb2IIezyIXEg=;
	h=Date:To:From:Subject:Message-Id; b=e1jL1HfUOivJEIU6hYoOkrN2qazNVC+OaeDaDLpHtFb1WqR5CnuR4TXCMBSgnXGnj/XkVwGjSPL+pNWxMy/ARFLb4UqPtMBNsOEIZzzEXuOPKxgqXibsnaSJaYQb6Pcj/nsp5M8dF67uXA1yYQt186iP4awuZ1YEP6WMW/4mUho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uJK62Akz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uJK62Akz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA4DC4CED1;
	Fri, 14 Feb 2025 23:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739576433;
	bh=ntJSCUwQbRPDVF/b6Tog882nPDevKCQpb2IIezyIXEg=;
	h=Date:To:From:Subject:From;
	b=uJK62AkzlEP+x4bCcyb2jxCvPv2cj55iGE0WKqogPSYtM2EgR9w4wMqKM1HFs6YJ3
	 WWNwAao0tj6GFfhytV6MFy0UMC0b11TNTk9OHHba8QwXdyhc9BqcroZ7B4R2qmqgVH
	 5jWBzJ7lZWvbN0g8j7wrE9H01nZMnMXeAPzGxVB0=
Date: Fri, 14 Feb 2025 15:40:32 -0800
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jane.chu@oracle.com,dave.jiang@intel.com,dan.j.williams@intel.com,apopple@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-remove-access-to-page-index.patch added to mm-unstable branch
Message-Id: <20250214234033.8AA4DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax: remove access to page->index
has been added to the -mm mm-unstable branch.  Its filename is
     dax-remove-access-to-page-index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-remove-access-to-page-index.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: dax: remove access to page->index
Date: Mon, 16 Dec 2024 15:53:55 +0000

This looks like a complete mess (why are we setting page->index at page
fault time?), but I no longer care about DAX, and there's no reason to let
DAX hold us back from removing page->index.

Link: https://lkml.kernel.org/r/20241216155408.8102-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/dax/device.c~dax-remove-access-to-page-index
+++ a/drivers/dax/device.c
@@ -89,14 +89,13 @@ static void dax_set_mapping(struct vm_fa
 			ALIGN_DOWN(vmf->address, fault_size));
 
 	for (i = 0; i < nr_pages; i++) {
-		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
+		struct folio *folio = pfn_folio(pfn_t_to_pfn(pfn) + i);
 
-		page = compound_head(page);
-		if (page->mapping)
+		if (folio->mapping)
 			continue;
 
-		page->mapping = filp->f_mapping;
-		page->index = pgoff + i;
+		folio->mapping = filp->f_mapping;
+		folio->index = pgoff + i;
 	}
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch

