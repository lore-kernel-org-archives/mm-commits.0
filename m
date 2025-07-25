Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA70A219300
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409722; cv=none; b=WYLqtSg/taUnWgKne8WAWXg0ibySe2qjERaPaYYUD2jRmQiOjBJdljc8QE4FYOb3LdmlYzHEkusSwOsQPVWXNMh3CQ6YRISGqRfbaQwl9JT9QZJYVU6ssWHlt0UQo95UwKwM2f0lmx9F7avHNTUmWK4SVNHY6ffyKYRN6RG3g2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409722; c=relaxed/simple;
	bh=8Allgi/g/Q3CjHQWmdZ7MP1Ky8/8oh1ifdbglGdOE0U=;
	h=Date:To:From:Subject:Message-Id; b=WVfKe8zDcq5qNztLmx9X5pCWODa6KeWylRhlTTz5UK+NvqJAjUc42BOhaAdySWpmaOBfc1tfppDPOJJLryf+YH3UQXDRQlzNUxeI5oHv/yhBai94tIYAzJh9RwUEd2vnvNUH1lcHgnbQWYTIIWgxSR5jRT9+9zazr3pRBlc+NGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z1eXBtmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z1eXBtmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF8AC4CEED;
	Fri, 25 Jul 2025 02:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409722;
	bh=8Allgi/g/Q3CjHQWmdZ7MP1Ky8/8oh1ifdbglGdOE0U=;
	h=Date:To:From:Subject:From;
	b=Z1eXBtmT4ykIkvewgX8MORX8WW7JP7dl5Rp7xY7Loha6UI+rngBoblKSpveMOiP1/
	 ISptSWSpKoyc6TfFca3IinvpDw9HGwbWOTYuHBZIY5Phi015cypR41ZRyL1xUEMwA8
	 e/0MjH18hduYA+a2h0JuO2IxuGBnOZ3idVrbWXcQ=
Date: Thu, 24 Jul 2025 19:15:21 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,k.shutemov@gmail.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,antonio@mandelbit.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch removed from -mm tree
Message-Id: <20250725021522.7EF8AC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove after_split label in __split_unmapped_folio()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: remove after_split label in __split_unmapped_folio()
Date: Fri, 18 Jul 2025 14:37:16 -0400

Check stop_split instead to avoid the goto statement.

Link: https://lkml.kernel.org/r/20250718183720.4054515-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <k.shutemov@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-after_split-label-in-__split_unmapped_folio
+++ a/mm/huge_memory.c
@@ -3463,18 +3463,18 @@ static int __split_unmapped_folio(struct
 				if (xas_error(xas)) {
 					ret = xas_error(xas);
 					stop_split = true;
-					goto after_split;
 				}
 			}
 		}
 
-		folio_split_memcg_refs(folio, old_order, split_order);
-		split_page_owner(&folio->page, old_order, split_order);
-		pgalloc_tag_split(folio, old_order, split_order);
+		if (!stop_split) {
+			folio_split_memcg_refs(folio, old_order, split_order);
+			split_page_owner(&folio->page, old_order, split_order);
+			pgalloc_tag_split(folio, old_order, split_order);
 
-		__split_folio_to_order(folio, old_order, split_order);
+			__split_folio_to_order(folio, old_order, split_order);
+		}
 
-after_split:
 		/*
 		 * Iterate through after-split folios and update folio stats.
 		 * But in buddy allocator like split, the folio
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_alloc-remove-trace_mm_alloc_contig_migrate_range_info.patch

