Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248A828371;
	Thu, 26 Sep 2024 21:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727384650; cv=none; b=lXVv6oEvHcbew4/qGL11yAAr9ynkKi8jKgp82qr86nIc9P9dA3WGJVpKnoaB3nNazndocujiaVC5Aj0WyLZo06evLsg6mV7BrdXFk9EYKHvyNs05yj9KsbbV3rDHB4CovpM3HzgiKApFf1vW/eSvikREEhvLVc/e9QKsixYhVX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727384650; c=relaxed/simple;
	bh=sxDIbHKNeJeS+gjM4ku2TxjXD/PBI/5q2b2CdCYspPQ=;
	h=Date:To:From:Subject:Message-Id; b=fo4CnlyT7P0YAeFCdokCnLXIiBi+thVgg2TBgapJnx+Yg9Z56NBrNOQqg2m+cr+//IhU/UzUAhXMWfMJxUutgP4HmUjxiXWaZkpLIBUi7RNsvTlhugudh5IX5CCU7ZeMwuS1tSDW/Zk7uO6a/XKLunFb9OXUwAw0zev94lp/kHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wfENnOYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wfENnOYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1571C4CEC5;
	Thu, 26 Sep 2024 21:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727384650;
	bh=sxDIbHKNeJeS+gjM4ku2TxjXD/PBI/5q2b2CdCYspPQ=;
	h=Date:To:From:Subject:From;
	b=wfENnOYGQSyMPK1asREBcusHaCE4P5wHmzyExn2lC57MNZze89YeF5IS62FQgHYSq
	 KfF9ylVY5yvMZPcThDIKL0PzNmUN8Ul6PTSjHPhjPDdlTHqlT58CGWsXQr/Ti8K/MY
	 qGrJYJNXcOHeFOMY4XrQSQUhDurYLqDNzvWxpX+4=
Date: Thu, 26 Sep 2024 14:04:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,peterx@redhat.com,muchun.song@linux.dev,jgg@nvidia.com,david@redhat.com,steven.sistare@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch removed from -mm tree
Message-Id: <20240926210409.E1571C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix memfd_pin_folios free_huge_pages leak
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-hugetlb-fix-memfd_pin_folios-free_huge_pages-leak
+++ a/mm/gup.c
@@ -3615,7 +3615,7 @@ long memfd_pin_folios(struct file *memfd
 	pgoff_t start_idx, end_idx, next_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
-	struct hstate *h;
+	struct hstate *h = NULL;
 	long ret = -EINVAL;
 
 	if (start < 0 || start > end || !max_folios)
@@ -3659,6 +3659,8 @@ long memfd_pin_folios(struct file *memfd
 							     &fbatch);
 			if (folio) {
 				folio_put(folio);
+				if (h)
+					folio_put(folio);
 				folio = NULL;
 			}
 
_

Patches currently in -mm which might be from steven.sistare@oracle.com are


