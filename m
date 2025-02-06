Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E02224AFD
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738827644; cv=none; b=YAWWhKFlAWq3Q42Rs6p/Cq3CMG8qd3MPd3F0W3haLnrk9HRd9n8zAlrfrf1GuGTAV6v6TS/ln8t9CKS0jNJShrW4UC/Nt03W5a7MJkr/MpbUx8efF9RIMpDUj+Ww0PnHWfwXLVTsnUCbHWMcAOITwM/V2Kw1b03RZedozE+EsCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738827644; c=relaxed/simple;
	bh=KXpRi1yhBni8JbrHgkQirOIrEKBIX9ZsPPMZ5ao6FOI=;
	h=Date:To:From:Subject:Message-Id; b=NCJKJgKkfh8U/SsO9PXxiuHLiNYp3ZNUUNpN8PkyReTvL73YGai/7slOqI2fDpvvnkrCW6vTuQNuFu6RZLnfDlSP51aVwa0MOyUozOcAieHTr9ChSudnsqgXAlVUjIJGIVlI7q1riqiEiFrPsM/8mXwKfOfQqU55c8A6HuUyXGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wTtLRAet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wTtLRAet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18D8C4CEDD;
	Thu,  6 Feb 2025 07:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738827642;
	bh=KXpRi1yhBni8JbrHgkQirOIrEKBIX9ZsPPMZ5ao6FOI=;
	h=Date:To:From:Subject:From;
	b=wTtLRAetAAmyFiS/fQaprhFGkqgpAzRN9JAkE6oTOpeOCZ/NWXNoWIUugCF2ztHl7
	 P7hohJgV8ZBAw3LXyizT1MzYPtmjm2RfdA/pAsJX5kGdP9jW+KB3e8BL7b0S+4rTEq
	 6RBzJ8MvG7VIyoMGr4YigLZdxLAyyhM8HtpscZ9M=
Date: Wed, 05 Feb 2025 23:40:42 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,dave@stgolabs.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch added to mm-unstable branch
Message-Id: <20250206074042.C18D8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: remove redundant mmap_lock operations from process_madvise()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/madvise: remove redundant mmap_lock operations from process_madvise()
Date: Wed, 5 Feb 2025 22:15:17 -0800

Optimize redundant mmap lock operations from process_madvise() by directly
doing the mmap locking first, and then the remaining works for all ranges
in the loop.

Link: https://lkml.kernel.org/r/20250206061517.2958-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise
+++ a/mm/madvise.c
@@ -1761,9 +1761,26 @@ static ssize_t vector_madvise(struct mm_
 
 	total_len = iov_iter_count(iter);
 
+	ret = madvise_lock(mm, behavior);
+	if (ret)
+		return ret;
+
 	while (iov_iter_count(iter)) {
-		ret = do_madvise(mm, (unsigned long)iter_iov_addr(iter),
-				 iter_iov_len(iter), behavior);
+		unsigned long start = (unsigned long)iter_iov_addr(iter);
+		size_t len_in = iter_iov_len(iter);
+		size_t len;
+
+		if (!is_valid_madvise(start, len_in, behavior)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		len = PAGE_ALIGN(len_in);
+		if (start + len == start)
+			ret = 0;
+		else
+			ret = madvise_do_behavior(mm, start, len_in, len,
+					behavior);
 		/*
 		 * An madvise operation is attempting to restart the syscall,
 		 * but we cannot proceed as it would not be correct to repeat
@@ -1779,12 +1796,17 @@ static ssize_t vector_madvise(struct mm_
 				ret = -EINTR;
 				break;
 			}
+
+			/* Drop and reacquire lock to unwind race. */
+			madvise_unlock(mm, behavior);
+			madvise_lock(mm, behavior);
 			continue;
 		}
 		if (ret < 0)
 			break;
 		iov_iter_advance(iter, iter_iov_len(iter));
 	}
+	madvise_unlock(mm, behavior);
 
 	ret = (total_len - iov_iter_count(iter)) ? : ret;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch

