Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17B42C027B
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489976; cv=none; b=ckSG2Y7ZvFFmn5Pef+s00s5U5wRzhlqPwHfQ4VkhyF8JgN757WV8GYGTCcVZ33y2K6k+Tk9nRU/MfNA2YgAYy4paT94WfHB372d81AA9+lfVGT0+NpvJOcWcLEnMdc6qx1/E/+krk2ISaL6pVcStf7rcJGq7RRUxwqfp5XuaGOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489976; c=relaxed/simple;
	bh=AndMzT6JbFdTofqlqKtE1VQl9RH6cVdJSNjPLlU9mrs=;
	h=Date:To:From:Subject:Message-Id; b=MzY+u5ch4dwdYN9RDQdmmI6pw2PK+BAWdr5zdXEw5KI3tkUVLlyYebqchSbOJ2jMunLLVCbJ1lpQQxuatrz0fOnOu4p/rlkZvT87WtrRmFMkFkfoUBEl3pEXNPbHGtEUw147Z5A6jn6rwEgNxkouOE9AwFecQlqV3hYmN+tJ8Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MIYyNN07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MIYyNN07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36483C4CEE7;
	Sun, 21 Sep 2025 21:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489976;
	bh=AndMzT6JbFdTofqlqKtE1VQl9RH6cVdJSNjPLlU9mrs=;
	h=Date:To:From:Subject:From;
	b=MIYyNN07KtSucn8oahxOq5f5FT0JNIWw097fl3Aw3D4EP+UEdUscxmok+aijEpleL
	 SMYTAo4eEQDYQELWRDOkKlK/arUmq8kvAFw4B27Bmsc2KrVrm4Lq2NmFuFyPXls7FY
	 ZdXbT0Lbsbnr4Ub+H/7W4ih9w1xKgSG30MZj8y0U=
Date: Sun, 21 Sep 2025 14:26:15 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,imbrenda@linux.ibm.com,borntraeger@de.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-fix-handling-of-errors-from-arch_make_folio_accessible-in-follow_page_pte.patch removed from -mm tree
Message-Id: <20250921212616.36483C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: fix handling of errors from arch_make_folio_accessible() in follow_page_pte()
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-handling-of-errors-from-arch_make_folio_accessible-in-follow_page_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: fix handling of errors from arch_make_folio_accessible() in follow_page_pte()
Date: Mon, 8 Sep 2025 11:45:17 +0200

In case we call arch_make_folio_accessible() and it fails, we would
incorrectly return a value that is "!= 0" to the caller, indicating that
we pinned all requested pages and that the caller can keep going.

follow_page_pte() is not supposed to return error values, but instead "0"
on failure and "1" on success -- we'll clean that up separately.

In case we return "!= 0", the caller will just keep going pinning more
pages.  If we happen to pin a page afterwards, we're in trouble, because
we essentially skipped some pages in the requested range.

Staring at the arch_make_folio_accessible() implementation on s390x, I
assume it should actually never really fail unless something unexpected
happens (BUG?).  So let's not CC stable and just fix common code to do the
right thing.

Clean up the code a bit now that there is no reason to store the return
value of arch_make_folio_accessible().

Link: https://lkml.kernel.org/r/20250908094517.303409-1-david@redhat.com
Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-gup-fix-handling-of-errors-from-arch_make_folio_accessible-in-follow_page_pte
+++ a/mm/gup.c
@@ -2898,12 +2898,9 @@ static int gup_fast_pte_range(pmd_t pmd,
 		 * see Documentation/core-api/pin_user_pages.rst for
 		 * details.
 		 */
-		if (flags & FOLL_PIN) {
-			ret = arch_make_folio_accessible(folio);
-			if (ret) {
-				gup_put_folio(folio, 1, flags);
-				goto pte_unmap;
-			}
+		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
+			gup_put_folio(folio, 1, flags);
+			goto pte_unmap;
 		}
 		folio_set_referenced(folio);
 		pages[*nr] = page;
_

Patches currently in -mm which might be from david@redhat.com are


