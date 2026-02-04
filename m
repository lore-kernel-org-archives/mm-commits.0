Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973FC20F067
	for <mm-commits@vger.kernel.org>; Wed,  4 Feb 2026 22:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770244711; cv=none; b=FsLy6HbZmVT/1Hx+JifsmtSgoB05qd8poiNpt5svYC1/iD1KGieVdR9Y6iKQTiDkqaVqIN3epMhjGqLPqBrMoJGrXG6eqnAYF02MTaTd37zPP9PwSjm86/wr6aLuCS5I9+2YJSP/wY29TWijKijVhIKFvSkvGtPePEYTpdnjPvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770244711; c=relaxed/simple;
	bh=eUS19H74kvkk1Cx8GjxAUQRyz0ihFzzKLLE/ZP5PsTU=;
	h=Date:To:From:Subject:Message-Id; b=hFV2hl2uqmJxrX0LIEAWS0VCO51klspjzIZax4Jz755aLGKu8JJVGsInmmguv9V8OdwNujCHqhfCk6Vl6sgPIitRPmfd4k3P+u/bXP2iJqttKKEjI96CNPtB+S3nPIQnChe0FAh4PmVeo5btDdwaRxJ2xC8TkU8FW/R/ldQUhIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RdsBAcQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RdsBAcQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2CEC4CEF7;
	Wed,  4 Feb 2026 22:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770244711;
	bh=eUS19H74kvkk1Cx8GjxAUQRyz0ihFzzKLLE/ZP5PsTU=;
	h=Date:To:From:Subject:From;
	b=RdsBAcQWkRNiWiSzwmiRDQsNjcavcfijp6uAxA7Kd+Ox2DMC1yUDhOPetaDnEJRMa
	 uZ1n94MbPDejYfbZ1Pi4bAo2qCu8b6OPyIWtgy/uLQmQHcSbKEQqFSxdADE/k2Yl6l
	 GTGvH5b86iKTOuV/rAqNIFou77HDC30+DHT+Pguw=
Date: Wed, 04 Feb 2026 14:38:30 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,jane.chu@oracle.com,david@kernel.org,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-hugetlb-simplify-remove_inode_hugepages-return-type.patch added to mm-new branch
Message-Id: <20260204223831.0A2CEC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: hugetlb: simplify remove_inode_hugepages() return type
has been added to the -mm mm-new branch.  Its filename is
     fs-hugetlb-simplify-remove_inode_hugepages-return-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-hugetlb-simplify-remove_inode_hugepages-return-type.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Link: https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@oracle.com [2]
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Suggested-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
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

fs-hugetlb-simplify-remove_inode_hugepages-return-type.patch

