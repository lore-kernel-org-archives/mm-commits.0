Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD8267A17
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 05:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369673; cv=none; b=Mh2gEhJ+BbMGrQ1nFkuapk0CGMSpmNhlgjnRxHeHtB3/BGF6AEElYwtyY6nndfaYxQJySmS8TIQ5Ul1qe1USlOxuU3J4Y9V/LShNZfAf8ZzLKnV+DVj/pEus6v6+yCh3p3f94pCd8ln611kYweAh9tP0qsLbl1vvDtv3PjR2Z20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369673; c=relaxed/simple;
	bh=umyoiqP6W9Dg8lE9htB8QSasj7qx4Iz+Rj8U7JmU7FM=;
	h=Date:To:From:Subject:Message-Id; b=teEe26J4zEFO5Eb6ev/QxeCJmE/xXMi+AQRQ2S8FV3VdOQVsCvSxdK9uvdOmAS+Lz4y5MKtF257pSYpYWhyzzkjzbpSVf5C/V8IXpTodHh/hLKibj0nlGe98JBNqdnBacB2ncap8xyb8YJFUS1fpuhRipgt9hrCMVAH+z1bXcFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AbCn3lPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AbCn3lPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975B9C433C7;
	Thu,  8 Feb 2024 05:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369673;
	bh=umyoiqP6W9Dg8lE9htB8QSasj7qx4Iz+Rj8U7JmU7FM=;
	h=Date:To:From:Subject:From;
	b=AbCn3lPcObogkVtp2MHGy4pC4/azvxA74OmsEOQuvFFxgk6Uew2BBWYqt3pq3ZO14
	 IvehvjndTTEiKhzppkqPsaKAnuyMLawlI8eNbdnHeIdd1uSoH+jq3u1wRuwLBS1FgH
	 GPWpsZKzRCzbLat65bRndPjRMRTKzgvEYlnjXBHI=
Date: Wed, 07 Feb 2024 21:21:13 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,david@redhat.com,aarcange@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get.patch removed from -mm tree
Message-Id: <20240208052113.975B9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: UFFDIO_MOVE implementation should use ptep_get()
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/userfaultfd: UFFDIO_MOVE implementation should use ptep_get()
Date: Tue, 23 Jan 2024 14:17:55 +0000

Commit c33c794828f2 ("mm: ptep_get() conversion") converted all (non-arch)
call sites to use ptep_get() instead of doing a direct dereference of the
pte.  Full rationale can be found in that commit's log.

Since then, UFFDIO_MOVE has been implemented which does 7 direct pte
dereferences.  Let's fix those up to use ptep_get().

I've asserted in the past that there is no reliable automated mechanism to
catch these; I'm relying on a combination of Coccinelle (which throws up a
lot of false positives) and some compiler magic to force a compiler error
on dereference.  But given the frequency with which new issues are coming
up, I'll add it to my todo list to try to find an automated solution.

Link: https://lkml.kernel.org/r/20240123141755.3836179-1-ryan.roberts@arm.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/userfaultfd.c~mm-userfaultfd-uffdio_move-implementation-should-use-ptep_get
+++ a/mm/userfaultfd.c
@@ -902,8 +902,8 @@ static int move_present_pte(struct mm_st
 
 	double_pt_lock(dst_ptl, src_ptl);
 
-	if (!pte_same(*src_pte, orig_src_pte) ||
-	    !pte_same(*dst_pte, orig_dst_pte)) {
+	if (!pte_same(ptep_get(src_pte), orig_src_pte) ||
+	    !pte_same(ptep_get(dst_pte), orig_dst_pte)) {
 		err = -EAGAIN;
 		goto out;
 	}
@@ -946,8 +946,8 @@ static int move_swap_pte(struct mm_struc
 
 	double_pt_lock(dst_ptl, src_ptl);
 
-	if (!pte_same(*src_pte, orig_src_pte) ||
-	    !pte_same(*dst_pte, orig_dst_pte)) {
+	if (!pte_same(ptep_get(src_pte), orig_src_pte) ||
+	    !pte_same(ptep_get(dst_pte), orig_dst_pte)) {
 		double_pt_unlock(dst_ptl, src_ptl);
 		return -EAGAIN;
 	}
@@ -1016,7 +1016,7 @@ retry:
 	}
 
 	spin_lock(dst_ptl);
-	orig_dst_pte = *dst_pte;
+	orig_dst_pte = ptep_get(dst_pte);
 	spin_unlock(dst_ptl);
 	if (!pte_none(orig_dst_pte)) {
 		err = -EEXIST;
@@ -1024,7 +1024,7 @@ retry:
 	}
 
 	spin_lock(src_ptl);
-	orig_src_pte = *src_pte;
+	orig_src_pte = ptep_get(src_pte);
 	spin_unlock(src_ptl);
 	if (pte_none(orig_src_pte)) {
 		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
@@ -1054,7 +1054,7 @@ retry:
 			 * page isn't freed under us
 			 */
 			spin_lock(src_ptl);
-			if (!pte_same(orig_src_pte, *src_pte)) {
+			if (!pte_same(orig_src_pte, ptep_get(src_pte))) {
 				spin_unlock(src_ptl);
 				err = -EAGAIN;
 				goto out;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch
arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch

