Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC7514AD1A
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 21:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725484242; cv=none; b=eLZPD6p58T2EKNJOIOKmcna60xo62upWYOGzQZVL91do4GR4SkWfAQB4gfpJJIfy4zOcf064IMEPRlIXupBDnvq97R5OQBkh2J9iIsH9fg9kK9G7jlizf8HXva95wzb0LBBSPw22YWNoeaUgiNMbHfV7CQcTh7GfCsAwrxilm0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725484242; c=relaxed/simple;
	bh=WF2JKbybmcTDub+IGZCv5uwV2HIrnlN2DM8TGsP90ME=;
	h=Date:To:From:Subject:Message-Id; b=b0+DGRMkKPk3jaS53O9wL1Sefz0ZyxnOxhFyjhl6bvKlzSXD7VwFqBLCgu2HGQPSKyTlAc3UNK/Bs1BcR/8OhYZOIc1NCSwKZc+Zfqaph299TgSGko1U8OUqPehcUINwzPa18K662Z+g8w5jUT4LSIjXw6oW0JRof5W9nwjiZ8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tbktVEQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tbktVEQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3776AC4CEC2;
	Wed,  4 Sep 2024 21:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725484242;
	bh=WF2JKbybmcTDub+IGZCv5uwV2HIrnlN2DM8TGsP90ME=;
	h=Date:To:From:Subject:From;
	b=tbktVEQdcfYB2mr8XfQn/eqOv3nObeTAvi/mh+zMx+HO4jpt9NCtuUJ7SIF6IHFN3
	 YFBzERKlQcl1d4CIyazErsHyRVLyYh4qA4Fb4vHcQ1Q74oYXSkOQdRFGFjbgfffR4K
	 dWdytT+iLJjKIQ/5UizxRzmotPKI5U4MZTaGFbRw=
Date: Wed, 04 Sep 2024 14:10:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240904211042.3776AC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2.patch

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
From: Steve Sistare <steven.sistare@oracle.com>
Subject: mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2
Date: Wed, 4 Sep 2024 13:32:00 -0700

remove explicit call to free_huge_folio(), per Matthew

Link: https://lkml.kernel.org/r/Zti-7nPVMcGgpcbi@casper.infradead.org
Link: https://lkml.kernel.org/r/1725481920-82506-1-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Suggested-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memfd.c~mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2
+++ a/mm/memfd.c
@@ -95,7 +95,6 @@ struct folio *memfd_alloc_folio(struct f
 							idx);
 			if (err) {
 				folio_put(folio);
-				free_huge_folio(folio);
 				return ERR_PTR(err);
 			}
 			folio_unlock(folio);
_

Patches currently in -mm which might be from steven.sistare@oracle.com are

mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch
mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch
mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch
mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch
mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch
mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch
mm-hugetlb-simplify-refs-in-memfd_alloc_folio-v2.patch

