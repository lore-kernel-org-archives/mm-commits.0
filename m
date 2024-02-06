Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FAB17753
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 20:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707250697; cv=none; b=c3SWCFCHVDUlQ6t35lftI9ur5Gn1q6E4NOBYFL0dzBRGlq/hUVtMSCEcdKznJe5sJUbsl4BwLJsK61cBp/95nzYPdcmPl0LxIViA5jKJ6XQsTCCDB60iGbCmnnKrKZfWdy+HVKaRH9EdQEqyTjQsNbjuxfvVyhxH5OZ+meVX3uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707250697; c=relaxed/simple;
	bh=0jAVMI0BdZqaK4taTXgJcLOoi+1aaw9NtZFz1p2MUzI=;
	h=Date:To:From:Subject:Message-Id; b=OML15JAVjGZH7wLoKvUT5H6doX9D+wbnAUICQh0H4ekeWsewaSZNPY8OjDIJ0l/Em7bvzCiBXDYp0DxSuvZW66bgMUbG/kFHMNkKpRfUukZrfYTtXkf6dvvaMxdUpja19B/0wydo+3+tOghztrnCW1LtQaAEoAD0tqSdEMhXTUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qQjAYhPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQjAYhPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6F9C433C7;
	Tue,  6 Feb 2024 20:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707250697;
	bh=0jAVMI0BdZqaK4taTXgJcLOoi+1aaw9NtZFz1p2MUzI=;
	h=Date:To:From:Subject:From;
	b=qQjAYhPg6Cbd4gCa3ONfNtR5czodGjRLbXZA/pmwE92lTDhWtt/Yg9NHP0HBdaRo9
	 CZ6zAtU8DIaajYB3sFyzeJvyyUL66NEwDP88Ze9mAbToCa5VABexA2N7Da+4Mv9C3S
	 e1hhjxq+uVW9EQaxed//Dl0oXomZn88TK/mfIYFY=
Date: Tue, 06 Feb 2024 12:18:16 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb.patch added to mm-unstable branch
Message-Id: <20240206201817.3A6F9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: improve the handling of hugetlb allocation failure for freed or in-use hugetlb
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: hugetlb: improve the handling of hugetlb allocation failure for freed or in-use hugetlb
Date: Tue, 6 Feb 2024 11:08:11 +0800

alloc_and_dissolve_hugetlb_folio() preallocates a new hugetlb page before
it takes hugetlb_lock.  In 3 out of 4 cases the page is not really used
and therefore the newly allocated page is just freed right away.  This is
wasteful and it might cause pre-mature failures in those cases.

Address that by moving the allocation down to the only case (hugetlb page
is really in the free pages pool).  We need to drop hugetlb_lock to do so
and therefore need to recheck the page state after regaining it.

The patch is more of a cleanup than an actual fix to an existing problem. 
There are no known reports about pre-mature failures.

Link: https://lkml.kernel.org/r/62890fd60b1ecd5bf1cdc476c973f60fe37aa0cb.1707181934.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb
+++ a/mm/hugetlb.c
@@ -3031,21 +3031,9 @@ static int alloc_and_dissolve_hugetlb_fo
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 	int nid = folio_nid(old_folio);
-	struct folio *new_folio;
+	struct folio *new_folio = NULL;
 	int ret = 0;
 
-	/*
-	 * Before dissolving the folio, we need to allocate a new one for the
-	 * pool to remain stable.  Here, we allocate the folio and 'prep' it
-	 * by doing everything but actually updating counters and adding to
-	 * the pool.  This simplifies and let us do most of the processing
-	 * under the lock.
-	 */
-	new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, NULL, NULL);
-	if (!new_folio)
-		return -ENOMEM;
-	__prep_new_hugetlb_folio(h, new_folio);
-
 retry:
 	spin_lock_irq(&hugetlb_lock);
 	if (!folio_test_hugetlb(old_folio)) {
@@ -3075,6 +3063,16 @@ retry:
 		cond_resched();
 		goto retry;
 	} else {
+		if (!new_folio) {
+			spin_unlock_irq(&hugetlb_lock);
+			new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid,
+							      NULL, NULL);
+			if (!new_folio)
+				return -ENOMEM;
+			__prep_new_hugetlb_folio(h, new_folio);
+			goto retry;
+		}
+
 		/*
 		 * Ok, old_folio is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
@@ -3102,9 +3100,11 @@ retry:
 
 free_new:
 	spin_unlock_irq(&hugetlb_lock);
-	/* Folio has a zero ref count, but needs a ref to be freed */
-	folio_ref_unfreeze(new_folio, 1);
-	update_and_free_hugetlb_folio(h, new_folio, false);
+	if (new_folio) {
+		/* Folio has a zero ref count, but needs a ref to be freed */
+		folio_ref_unfreeze(new_folio, 1);
+		update_and_free_hugetlb_folio(h, new_folio, false);
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages.patch
mm-hugetlb-improve-the-handling-of-hugetlb-allocation-failure-for-freed-or-in-use-hugetlb.patch

