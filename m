Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170F0EECC
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 00:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600234; cv=none; b=B3xiK0KhxTdF4JXLt4kOQEw8PQEtjAaLBvOIzfciEGiC5FhiKnOfaar4jY8KdPmkXU5VJBTJQu/Qw+O29k4LRHkAueLR88n0URM53qDDx7GnHq4vbyldn/TNi6yYSzqqqdnlUK8oOjwqyy3W+RfL/0Ll/6ebeYnHvLR1zFyyNNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600234; c=relaxed/simple;
	bh=pFG6HmW4rUmuZL6jVHMM9gtYmyMg5j0UVCWZ7XusIuw=;
	h=Date:To:From:Subject:Message-Id; b=hY9hkxQgI2vEm4J7TZNlR3csLUvHDW/51tzj3ExuXxJ5c8CAVK0LUCDSqzbWAbljiJ7C9vzjrVMfs3cHyIvs/BJKcoADarrGKLSCJVOwO3rQVZdPEHopFFx5FQZd7203OchuhyLFT0gbQUdwEGV+DB2A2isJ79XIx80yTDhx4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xRFu1sqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xRFu1sqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F726C433F1;
	Tue,  5 Mar 2024 00:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600233;
	bh=pFG6HmW4rUmuZL6jVHMM9gtYmyMg5j0UVCWZ7XusIuw=;
	h=Date:To:From:Subject:From;
	b=xRFu1sqr4z5ZLcqZujrmI9vpmEPzqd5FhLt4X+07VMUVwfOFSKsW+8QI3fQ1KhQ5S
	 8ygee/8e5aThxDH5Hx+eXM9BGLzr8ltcEHhqXZDh+2kCpXIMBoZbfLfiYLkWBeFY2O
	 4oFKJymps0qAXmb7JgiJNR3u88RoBhhQIYdapED0=
Date: Mon, 04 Mar 2024 16:57:12 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-thp-split-huge-page-to-any-lower-order-pages-fix.patch removed from -mm tree
Message-Id: <20240305005713.8F726C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-thp-split-huge-page-to-any-lower-order-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-split-huge-page-to-any-lower-order-pages-fix.patch

This patch was dropped because it was folded into mm-thp-split-huge-page-to-any-lower-order-pages.patch

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm-thp-split-huge-page-to-any-lower-order-pages-fix
Date: Wed, 28 Feb 2024 10:52:23 -0500

fixup per discussion with Ryan at https://lore.kernel.org/linux-mm/408df79a-130e-43cd-a21a-9b3a2ddef617

Link: https://lkml.kernel.org/r/494F48CD-1F0F-4CAD-884E-6D48F40AF990@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-thp-split-huge-page-to-any-lower-order-pages-fix
+++ a/mm/huge_memory.c
@@ -3059,11 +3059,8 @@ int split_huge_page_to_list_to_order(str
 
 	if (new_order) {
 		/* Only swapping a whole PMD-mapped folio is supported */
-		if (folio_test_swapcache(folio)) {
-			VM_WARN_ONCE(1,
-				"Cannot split swap-cached folio to non-0 order");
+		if (folio_test_swapcache(folio))
 			return -EINVAL;
-		}
 		/* Split shmem folio to non-zero order not supported */
 		if (shmem_mapping(folio->mapping)) {
 			VM_WARN_ONCE(1,
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-only-split-pmd-mapping-when-necessary-in-unmap_folio.patch
mm-memcg-use-order-instead-of-nr-in-split_page_memcg.patch
mm-page_owner-use-order-instead-of-nr-in-split_page_owner.patch
mm-memcg-make-memcg-huge-page-split-support-any-order-split.patch
mm-page_owner-add-support-for-splitting-to-any-order-in-split-page_owner.patch
mm-thp-split-huge-page-to-any-lower-order-pages.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order.patch
mm-huge_memory-enable-debugfs-to-split-huge-pages-to-any-order-fix.patch

