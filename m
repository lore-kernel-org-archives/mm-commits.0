Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE331AB6DB
	for <mm-commits@vger.kernel.org>; Tue,  3 Sep 2024 20:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725394963; cv=none; b=cecPwuWltfEO2VKpAY10uhweH3r9M9pcIIhLbdx+O5PeSrGgdIpAd7922vuMZNQfL1NJmr5qjF7gqoUXcOXCKllwsTbjRRGAbVC5beN9Vu3Cbpvm+vke+traPw5OheX5vj8IL7rfi7yLhJC5BUnh2wm1MwI9q8IJacQyEcC+mKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725394963; c=relaxed/simple;
	bh=Dv6ecrF6nTWGKdFBvTn660C6ACxZLeUGGBegtvUAvOg=;
	h=Date:To:From:Subject:Message-Id; b=oXKmvDrBVCJxuVZ0evHk4AVojCYaKMmanb8Bxw2nikC0PXETslyPonHUDKRnvQ/elqEVqraq3xj9cvnRpQQr3IOqRbKSVsbZ2or8QNxaXeYHPzX16JhLF8n5nDxyRPbiheCOqT4ZOJdFi3xYISGCO1FIJTQ0wh/XdF7nip8iWnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UzsJAdw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UzsJAdw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76519C4CEC4;
	Tue,  3 Sep 2024 20:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725394962;
	bh=Dv6ecrF6nTWGKdFBvTn660C6ACxZLeUGGBegtvUAvOg=;
	h=Date:To:From:Subject:From;
	b=UzsJAdw+svzziyu8JmQEA6ke44fo7vQR7U1ffVveX2NqZjtO7p/oysfDh1GF109Fy
	 D3rj5Mkk0mhg/1naWQLjWJO2WfAsDMCYi+zfY6TdOlX62BN/Uib90gSdhp1CtUjkeh
	 SSfeD875Hrbn6sOm1PUNhxqVFg4ub71zbjv39THQ=
Date: Tue, 03 Sep 2024 13:22:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch added to mm-hotfixes-unstable branch
Message-Id: <20240903202242.76519C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix memfd_pin_folios free_huge_pages leak
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch

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
Subject: mm/hugetlb: fix memfd_pin_folios free_huge_pages leak
Date: Tue, 3 Sep 2024 07:25:18 -0700

memfd_pin_folios followed by unpin_folios fails to restore free_huge_pages
if the pages were not already faulted in, because the folio refcount for
pages created by memfd_alloc_folio never goes to 0.  memfd_pin_folios
needs another folio_put to undo the folio_try_get below:

memfd_alloc_folio()
  alloc_hugetlb_folio_nodemask()
    dequeue_hugetlb_folio_nodemask()
      dequeue_hugetlb_folio_node_exact()
        folio_ref_unfreeze(folio, 1);    ; adds 1 refcount
  folio_try_get()                        ; adds 1 refcount
  hugetlb_add_to_page_cache()            ; adds 512 refcount (on x86)

With the fix, after memfd_pin_folios + unpin_folios, the refcount for the
(unfaulted) page is 512, which is correct, as the refcount for a faulted
unpinned page is 513.

Link: https://lkml.kernel.org/r/1725373521-451395-3-git-send-email-steven.sistare@oracle.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak
+++ a/mm/gup.c
@@ -3618,7 +3618,7 @@ long memfd_pin_folios(struct file *memfd
 	pgoff_t start_idx, end_idx, next_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
-	struct hstate *h;
+	struct hstate *h = NULL;
 	long ret = -EINVAL;
 
 	if (start < 0 || start > end || !max_folios)
@@ -3662,6 +3662,8 @@ long memfd_pin_folios(struct file *memfd
 							     &fbatch);
 			if (folio) {
 				folio_put(folio);
+				if (h)
+					folio_put(folio);
 				folio = NULL;
 			}
 
_

Patches currently in -mm which might be from steven.sistare@oracle.com are

mm-filemap-fix-filemap_get_folios_contig-thp-panic.patch
mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch
mm-hugetlb-fix-memfd_pin_folios-resv_huge_pages-leak.patch
mm-gup-fix-memfd_pin_folios-hugetlb-page-allocation.patch
mm-gup-fix-memfd_pin_folios-alloc-race-panic.patch

