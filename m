Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D2A225403
	for <mm-commits@vger.kernel.org>; Thu,  6 Feb 2025 07:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738828649; cv=none; b=lScgJ7E3j6ldYLH8qh3ivTIiBcQCM3hRDpFf+ul1ikI/C8lVPOANNO7TQQVPLjQV8c5Vn59t3H1ChU/d+iC0EdW85XnA1CdHORpINydzPkQgERBZottVYUlsS8IwyXEXs9UM++NjY+6wBnHWeZspseJnpyhJArizS3KE6ilXVX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738828649; c=relaxed/simple;
	bh=/+Zmbm/2HoGr/aitqd8ksRnLRkUjCdcMSqdfORLicV4=;
	h=Date:To:From:Subject:Message-Id; b=e/fwibt9IRHE7+3NBkZnl1iSXj3FHAmrIJ87xVNZZAIeMiUk35ycFawmHxi0M+4IjaJMtOjfWWvzdlTxtKFiMnJhOkHy2vnaTD1hipP+Mo3vchZYpkerln8BTRMNIhBHUhXZeOiVRrG4H/Bl2UGGs2s9fTAI2iu2A0y9/Y/Y/PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L92D59uL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L92D59uL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F7EC4CEE5;
	Thu,  6 Feb 2025 07:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738828648;
	bh=/+Zmbm/2HoGr/aitqd8ksRnLRkUjCdcMSqdfORLicV4=;
	h=Date:To:From:Subject:From;
	b=L92D59uLM4JZkiK3VyN1EupoGi6DyYGQoLv3qQSJyRmk3r1qjzuzgIshvnlXi+60/
	 50hceExDGE6djnHZ9aAJV1Zx1f1xDZc34T/Bfma1qBhLhd51ovO/kyYvQOOYa5KhMP
	 J5jqcWNqufOFi/T2jDmjAA+FwAbU23vRPiVnr864=
Date: Wed, 05 Feb 2025 23:57:28 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch added to mm-unstable branch
Message-Id: <20250206075728.A7F7EC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap_state.c: optimize the code in clear_shadow_from_swap_cache()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/swap_state.c: optimize the code in clear_shadow_from_swap_cache()
Date: Wed, 5 Feb 2025 17:27:11 +0800

Use ALIGN to achieve the same effect and simplify the code.

Link: https://lkml.kernel.org/r/20250205092721.9395-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chis Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swap_state.c~mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache
+++ a/mm/swap_state.c
@@ -270,9 +270,7 @@ void clear_shadow_from_swap_cache(int ty
 		xa_unlock_irq(&address_space->i_pages);
 
 		/* search the next swapcache until we meet end */
-		curr >>= SWAP_ADDRESS_SPACE_SHIFT;
-		curr++;
-		curr <<= SWAP_ADDRESS_SPACE_SHIFT;
+		curr = ALIGN((curr + 1), SWAP_ADDRESS_SPACE_PAGES);
 		if (curr > end)
 			break;
 	}
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-swap_statec-fix-the-obsolete-code-comment.patch
mm-swap_statec-optimize-the-code-in-clear_shadow_from_swap_cache.patch
mm-swap-remove-swap_flag_prio_shift.patch
mm-swap-skip-scanning-cluster-range-if-its-empty-cluster.patch
mm-swap-rename-swap_is_has_cache-to-swap_only_has_cache.patch
mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch
mm-swapfilec-optimize-code-in-setup_clusters.patch
mm-swap_statec-remove-the-meaningless-code-comment.patch
mm-swapfilec-remove-the-unneeded-checking.patch
mm-swap-rename-swap_swapcount-to-swap_entry_swapped.patch
mm-swapfilec-remove-the-incorrect-code-comment.patch
mm-swapfilec-open-code-cluster_alloc_swap.patch

