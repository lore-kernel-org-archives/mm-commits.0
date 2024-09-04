Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB7A1E6DDE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 19:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725479925; cv=none; b=I6ARbXOcfcxEMmtu6vjlUnvYFsKSsEBE+4ZS1BkTykUpOmm6aHHbXJ1G3qdmmTzdThl3/3Hpqml8bvDChvefu+O8gCOBPFeEcCOVT+SN7Wq0McKZeJYM3NpKyq//n6xOn6We/alAXf8GLcXs0xihqh3WbjYWr9psQLQwz0Psl2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725479925; c=relaxed/simple;
	bh=7uQ0erOPAokHpE118CqRUaQVgaozW6BGXVsl9Zc3lQI=;
	h=Date:To:From:Subject:Message-Id; b=jHzP5i9dCEogmQrxZdyt0rZCAx9v2RM7SLz7LetGKcAzv1fv3d765gW00xErFfHZGt724ODqQGf4siJlLrOX//UB5mGrruKFInv/ci7a0bAPBuZ900bC4EZpKMAYp92g8/5GM3TKrqwKZGEbFwnad3IA4Fl/yfUdXoYsADbT+L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s+ZKofA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s+ZKofA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99242C4CEC2;
	Wed,  4 Sep 2024 19:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725479924;
	bh=7uQ0erOPAokHpE118CqRUaQVgaozW6BGXVsl9Zc3lQI=;
	h=Date:To:From:Subject:From;
	b=s+ZKofA7Y62BcZ/80PVdvl0AGoM3/pO8VmJMnpDX3woq3xO/Jx35nGYCh9uN8AiIF
	 7sHQQ026eH+1TUO6CH8JVs7eE6nB2+2cFdscn+4kAUxdq6R4Xon59lmTmY022Ou7Fk
	 PgsIuhWu4ip4hcVK6UO3jeHdp2l3lFQw0WlMXzw0=
Date: Wed, 04 Sep 2024 12:58:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20240904195844.99242C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: simplify refs in memfd_alloc_folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch

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
Subject: mm/hugetlb: simplify refs in memfd_alloc_folio
Date: Wed, 4 Sep 2024 12:41:08 -0700

The folio_try_get in memfd_alloc_folio is not necessary.  Delete it, and
delete the matching folio_put in memfd_pin_folios.  This also avoids
leaking a ref if the memfd_alloc_folio call to hugetlb_add_to_page_cache
fails, which would otherwise need an additional folio_put.  This is a
continuation of the fix
  "mm/hugetlb: fix memfd_pin_folios free_huge_pages leak"

Link: https://lkml.kernel.org/r/1725478868-61732-1-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Suggested-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c   |    4 +---
 mm/memfd.c |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-hugetlb-simplify-refs-in-memfd_alloc_folio
+++ a/mm/gup.c
@@ -3618,7 +3618,7 @@ long memfd_pin_folios(struct file *memfd
 	pgoff_t start_idx, end_idx, next_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
-	struct hstate *h = NULL;
+	struct hstate *h;
 	long ret = -EINVAL;
 
 	if (start < 0 || start > end || !max_folios)
@@ -3662,8 +3662,6 @@ long memfd_pin_folios(struct file *memfd
 							     &fbatch);
 			if (folio) {
 				folio_put(folio);
-				if (h)
-					folio_put(folio);
 				folio = NULL;
 			}
 
--- a/mm/memfd.c~mm-hugetlb-simplify-refs-in-memfd_alloc_folio
+++ a/mm/memfd.c
@@ -89,7 +89,7 @@ struct folio *memfd_alloc_folio(struct f
 						    numa_node_id(),
 						    NULL,
 						    gfp_mask);
-		if (folio && folio_try_get(folio)) {
+		if (folio) {
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
_

Patches currently in -mm which might be from steven.sistare@oracle.com are

mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch
mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch
mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch
mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch
mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch
mm-hugetlb-simplify-refs-in-memfd_alloc_folio.patch

