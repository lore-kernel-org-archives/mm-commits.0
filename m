Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC8F54F9D
	for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2024 19:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710185365; cv=none; b=S02i8PaV88vUEO5exXw9xoeGs9W4b/BJ/+JjiAN6Ect7bg0sQ96cbDOWZsy7VzUVYk6ax/5beBKYUu34i50wBYKF+XZkRoATCMcjFvJ/YMDRGAbX+9KRkvr8I3CKO2qZux6DeUFwejZvNsXwCLqjqE4mSasz7+jSm2ScpSxqWHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710185365; c=relaxed/simple;
	bh=vGaQk5/L/lYmTQP0vG/o6MM0vmT+4jjrN4XpiRarL2U=;
	h=Date:To:From:Subject:Message-Id; b=Er+n4SofQ3wLlmh9yuJyAPeJ2WfQvZBZnmWvIKTocp5iDc3GOXm/z4ySQn+FE9SDifxgfti4eHUHU5PykPN0LsB4UapZNtQR5RFkbTQeyuEJRdflXYeHcrkUI83olDggIuVKx0Bp/hJdHeZYywwcNZqCkVMJvECkxoC9/1qWgyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1NtCBKFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1NtCBKFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F87C433C7;
	Mon, 11 Mar 2024 19:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710185364;
	bh=vGaQk5/L/lYmTQP0vG/o6MM0vmT+4jjrN4XpiRarL2U=;
	h=Date:To:From:Subject:From;
	b=1NtCBKFN6S7iQj9xVHExYcEVMwec4rJ1n7X2EWIHcCTZxaQjsbfe3X/Iw78KH2GgV
	 mX1YjPoD5Nj3ZhGmJyUUCkPzx+iKY56dB1xfhaLVTTZf9gpYSjGquFi+INcV2l2/L9
	 uifpDlHyTjMKr02JA8lNN4AQ/++mL9XF1LK/NfuI=
Date: Mon, 11 Mar 2024 12:29:23 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch added to mm-unstable branch
Message-Id: <20240311192924.05F87C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove folio from deferred split list before uncharging it
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove folio from deferred split list before uncharging it
Date: Mon, 11 Mar 2024 19:18:34 +0000

When freeing a large folio, we must remove it from the deferred split list
before we uncharge it as each memcg has its own deferred split list (with
associated lock) and removing a folio from the deferred split list while
holding the wrong lock will corrupt that list and cause various related
problems.

Link: https://lore.kernel.org/linux-mm/367a14f7-340e-4b29-90ae-bc3fcefdd5f4@arm.com/
Link: https://lkml.kernel.org/r/20240311191835.312162-1-willy@infradead.org
Fixes: f77171d241e3 (mm: allow non-hugetlb large folios to be batch processed)
Fixes: 29f3843026cf (mm: free folios directly in move_folios_to_lru())
Fixes: bc2ff4cbc329 (mm: free folios in a batch in shrink_folio_list())
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Debugged-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c   |    3 +++
 mm/vmscan.c |    6 ++++++
 2 files changed, 9 insertions(+)

--- a/mm/swap.c~mm-remove-folio-from-deferred-split-list-before-uncharging-it
+++ a/mm/swap.c
@@ -1012,6 +1012,9 @@ void folios_put_refs(struct folio_batch
 			free_huge_folio(folio);
 			continue;
 		}
+		if (folio_test_large(folio) &&
+		    folio_test_large_rmappable(folio))
+			folio_undo_large_rmappable(folio);
 
 		__page_cache_release(folio, &lruvec, &flags);
 
--- a/mm/vmscan.c~mm-remove-folio-from-deferred-split-list-before-uncharging-it
+++ a/mm/vmscan.c
@@ -1413,6 +1413,9 @@ free_it:
 		 */
 		nr_reclaimed += nr_pages;
 
+		if (folio_test_large(folio) &&
+		    folio_test_large_rmappable(folio))
+			folio_undo_large_rmappable(folio);
 		if (folio_batch_add(&free_folios, folio) == 0) {
 			mem_cgroup_uncharge_folios(&free_folios);
 			try_to_unmap_flush();
@@ -1819,6 +1822,9 @@ static unsigned int move_folios_to_lru(s
 		if (unlikely(folio_put_testzero(folio))) {
 			__folio_clear_lru_flags(folio);
 
+			if (folio_test_large(folio) &&
+			    folio_test_large_rmappable(folio))
+				folio_undo_large_rmappable(folio);
 			if (folio_batch_add(&free_folios, folio) == 0) {
 				spin_unlock_irq(&lruvec->lru_lock);
 				mem_cgroup_uncharge_folios(&free_folios);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch
mm-fix-list-corruption-in-put_pages_list.patch

