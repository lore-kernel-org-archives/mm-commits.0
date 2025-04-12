Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE1DDAB;
	Sat, 12 Apr 2025 00:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418033; cv=none; b=WEuLrM5/w+hN6fOl5py/KeYGPz9cWqhmsX05Tkcbe3S+BGWDzcyBaV4xZQjaJrFg1u5YY0MMQ4du2Rcvwj+WV2NmFAOnKeW3ydiUWQSJZYsqSY6Olgq+zdfV6qqLYzhrrkd+3C4dTud2Jj45nZn9Xkoo8ozCAdV1dKR8djXL+vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418033; c=relaxed/simple;
	bh=4YBUtJxxe7H7a7/0Of+mMvC4zQtMmNlVeJDJOwiSlpY=;
	h=Date:To:From:Subject:Message-Id; b=diXG6XS/yidKSjh5J3FyaSAFRhjhh3eTrV/q3m9Xcd1fTTt062m7Vl1NH8LLWf6IJ6q7IgRWUhOC+9rn5gw5wkXSBm6hLpy11EZ11geLJ5QBJiLmPTnelpfL6BmdsHb/wEBnnaIWkKeoPWMU2K04jAbf432X/VU1HHUav1qTBCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NDqMLJUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NDqMLJUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3289C4CEE2;
	Sat, 12 Apr 2025 00:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418032;
	bh=4YBUtJxxe7H7a7/0Of+mMvC4zQtMmNlVeJDJOwiSlpY=;
	h=Date:To:From:Subject:From;
	b=NDqMLJUgbCz9WffT0lKYLTE7DffEemTIu8/LCZ+2cSEuOze9fFUppBuSNGjMEMRoG
	 941QSAtBTjwV3TQnYx3DYZn4k2DZK5QzCnAa/U7N6n9R67bYA0CEqMNHzW0nXT7L0E
	 0+HZkBtXDi4Xlg7nb/iYlQR7FDH/Yi4ORr/7s1iM=
Date: Fri, 11 Apr 2025 17:33:52 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,dja@axtens.net,david@redhat.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-apply_to_existing_page_range.patch removed from -mm tree
Message-Id: <20250412003352.B3289C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix apply_to_existing_page_range()
has been removed from the -mm tree.  Its filename was
     mm-fix-apply_to_existing_page_range.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix apply_to_existing_page_range()
Date: Wed, 9 Apr 2025 12:40:43 +0300

In the case of apply_to_existing_page_range(), apply_to_pte_range() is
reached with 'create' set to false.  When !create, the loop over the PTE
page table is broken.

apply_to_pte_range() will only move to the next PTE entry if 'create' is
true or if the current entry is not pte_none().

This means that the user of apply_to_existing_page_range() will not have
'fn' called for any entries after the first pte_none() in the PTE page
table.

Fix the loop logic in apply_to_pte_range().

There are no known runtime issues from this, but the fix is trivial enough
for stable@ even without a known buggy user. 

Link: https://lkml.kernel.org/r/20250409094043.1629234-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: be1db4753ee6 ("mm/memory.c: add apply_to_existing_page_range() helper")
Cc: Daniel Axtens <dja@axtens.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-fix-apply_to_existing_page_range
+++ a/mm/memory.c
@@ -2938,11 +2938,11 @@ static int apply_to_pte_range(struct mm_
 	if (fn) {
 		do {
 			if (create || !pte_none(ptep_get(pte))) {
-				err = fn(pte++, addr, data);
+				err = fn(pte, addr, data);
 				if (err)
 					break;
 			}
-		} while (addr += PAGE_SIZE, addr != end);
+		} while (pte++, addr += PAGE_SIZE, addr != end);
 	}
 	*mask |= PGTBL_PTE_MODIFIED;
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-page_alloc-fix-deadlock-on-cpu_hotplug_lock-in-__accept_page.patch

