Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F39835F8A8
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388478; cv=none; b=cY2UlocYSeoWaKiPCG/BI8C19MsUuxOUlE6xqtJG7fCGzLIyatYyM0pNSSXwTAf1lkFDZRDS5m4FoiAY3z1GxbT+/6t92KN83YuL95zljboyBtUQTmz3m7tRhKhEEoNkvzw8TaE3xXLetpDOqY9ChAuTkRrSnVbmMyj7FZg/yMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388478; c=relaxed/simple;
	bh=3jNIoK5tPAg2puIKCjQmsfLVZchEd746UKL+I0iLjKc=;
	h=Date:To:From:Subject:Message-Id; b=aYWOhsrSZ+zJwwU3vq8QeuUmwKIhG4rGyesKS07KEK0FqKx0sUgRLQZtjH6qYsg+f5yiPIhZyhtBx/KQrx9+437dEcG8ykbLITA+NA0h83DOY2DFrbSkLJvaC609d1fd/lnEKDyi0er2gmG7sWeMM5e4IGnKKz+i60cnmgxR2tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DnivjNpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DnivjNpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1611FC19424;
	Tue, 24 Mar 2026 21:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388478;
	bh=3jNIoK5tPAg2puIKCjQmsfLVZchEd746UKL+I0iLjKc=;
	h=Date:To:From:Subject:From;
	b=DnivjNpj7Qha2rGUlTzLoNgFMzw1j7fOD2Dww/B1Uma502KHJr2PcooKSS8v8mNLa
	 J5QaHDd32ihoTtp359yAJvi5G4QyeiMXp5t2S5rhhNparssD+Ty4Tjv9WmGnUsYTeQ
	 y05x2tOCWolNQYW2mF20/ct9wiW/6C4ubPTPDhfk=
Date: Tue, 24 Mar 2026 14:41:17 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,muchun.song@linux.dev,jane.chu@oracle.com,david@kernel.org,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-hugetlb-simplify-remove_inode_hugepages-return-type.patch removed from -mm tree
Message-Id: <20260324214118.1611FC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: hugetlb: simplify remove_inode_hugepages() return type
has been removed from the -mm tree.  Its filename was
     fs-hugetlb-simplify-remove_inode_hugepages-return-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: fs: hugetlb: simplify remove_inode_hugepages() return type
Date: Wed, 4 Feb 2026 21:47:41 +0000

When remove_inode_hugepages() was introduced in commit c86272287bc6
("hugetlb: create remove_inode_single_folio to remove single file folio")
it used to return a boolean to indicate if it bailed out due to race with
page faults.  However, since the race is already solved by [1],
remove_inode_hugepages() doesn't have any path to return false anymore.

Simplify remove_inode_hugepages() return type to void, remove the
unnecessary ret variable, and adjust the call site in
remove_inode_hugepages().  No functional change in this commit.

Link: https://lkml.kernel.org/r/20260204214741.3161520-1-jiaqiyan@google.com
Link: https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@oracle.com [1]
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Suggested-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/fs/hugetlbfs/inode.c~fs-hugetlb-simplify-remove_inode_hugepages-return-type
+++ a/fs/hugetlbfs/inode.c
@@ -513,15 +513,11 @@ hugetlb_vmdelete_list(struct rb_root_cac
 
 /*
  * Called with hugetlb fault mutex held.
- * Returns true if page was actually removed, false otherwise.
  */
-static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
-					struct address_space *mapping,
-					struct folio *folio, pgoff_t index,
-					bool truncate_op)
+static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
+		struct address_space *mapping, struct folio *folio,
+		pgoff_t index, bool truncate_op)
 {
-	bool ret = false;
-
 	/*
 	 * If folio is mapped, it was faulted in after being
 	 * unmapped in caller or hugetlb_vmdelete_list() skips
@@ -543,7 +539,6 @@ static bool remove_inode_single_folio(st
 	 */
 	VM_BUG_ON_FOLIO(folio_test_hugetlb_restore_reserve(folio), folio);
 	hugetlb_delete_from_page_cache(folio);
-	ret = true;
 	if (!truncate_op) {
 		if (unlikely(hugetlb_unreserve_pages(inode, index,
 							index + 1, 1)))
@@ -551,7 +546,6 @@ static bool remove_inode_single_folio(st
 	}
 
 	folio_unlock(folio);
-	return ret;
 }
 
 /*
@@ -599,9 +593,9 @@ static void remove_inode_hugepages(struc
 			/*
 			 * Remove folio that was part of folio_batch.
 			 */
-			if (remove_inode_single_folio(h, inode, mapping, folio,
-							index, truncate_op))
-				freed++;
+			remove_inode_single_folio(h, inode, mapping, folio,
+						  index, truncate_op);
+			freed++;
 
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
_

Patches currently in -mm which might be from jiaqiyan@google.com are


