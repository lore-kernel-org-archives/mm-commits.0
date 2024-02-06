Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3B7818
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 00:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707177988; cv=none; b=OtJWcxe+8VDxoxd0iM8ivgNTVoQgAoi9QwlRcpKok9ZrMImcsGhPbUAsv7m9DSGvawg/mqic1m1Rj7j9xtqvbPNj6nJtpLIlgjLNpQJn++/McnVRcJYZ3npV0aMTqzxU7X06iDIyFStl/E72kQCFTPO7jkc/fu79jLvg6z/20u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707177988; c=relaxed/simple;
	bh=nUMD2IWi9U5GfvoHOInQ8IdXquc6NKbkomkZDwKULfs=;
	h=Date:To:From:Subject:Message-Id; b=WRpeWaiT0AxtzrGlOzz6mGfdZK/Cl5ZyxW+UT2KQszxqFkvw6lUwtyr86XE7HJsCftNcNeuKjKQW97xTsKi7a4UtATyVdXr7tDoG5jpGdLgcJCO0h2uOTbTROSPwjfQqDj1ladctDgtEDzrMbD8RSnmVKoAenmQfvHuFXjhYXRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hh52RBaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hh52RBaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12ECC43390;
	Tue,  6 Feb 2024 00:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707177987;
	bh=nUMD2IWi9U5GfvoHOInQ8IdXquc6NKbkomkZDwKULfs=;
	h=Date:To:From:Subject:From;
	b=Hh52RBazBnQrAEsegYn/edxrJRfapLgB5oZ7EQ6ROAyhPlefvt0+8wNyEHszy1rjg
	 Gnn4bzA5h4L1Jb/51ZCtx68obxX8eXLw8Q73iZRXNy19dcuZLRpPQBodeB2aBV27ta
	 N01Fl7eMZlSk28Rd2FWl8JOS5J2Cik175C9TM6bw=
Date: Mon, 05 Feb 2024 16:06:27 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch added to mm-hotfixes-unstable branch
Message-Id: <20240206000627.C12ECC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap_state: update zswap LRU's protection range with the folio locked
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/swap_state: update zswap LRU's protection range with the folio locked
Date: Mon, 5 Feb 2024 15:24:42 -0800

Move the zswap LRU protection range update above the swap_read_folio()
call, and only when a new page is allocated.  This is the case where
(z)swapin could happen, which is a signal that the zswap shrinker should
be more conservative with its reclaiming action.

It also prevents a race, in which folio migration can clear the memcg_data
of the now unlocked folio, resulting in a warning in the inlined
folio_lruvec() call.

Link: https://lkml.kernel.org/r/20240205232442.3240571-1-nphamcs@gmail.com
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Reported-by: syzbot+17a611d10af7d18a7092@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000ae47f90610803260@google.com/
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/mm/swap_state.c~mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked
+++ a/mm/swap_state.c
@@ -680,9 +680,10 @@ skip:
 	/* The page was likely read above, so no need for plugging here */
 	folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 					&page_allocated, false);
-	if (unlikely(page_allocated))
+	if (unlikely(page_allocated)) {
+		zswap_folio_swapin(folio);
 		swap_read_folio(folio, false, NULL);
-	zswap_folio_swapin(folio);
+	}
 	return folio;
 }
 
@@ -855,9 +856,10 @@ skip:
 	/* The folio was likely read above, so no need for plugging here */
 	folio = __read_swap_cache_async(targ_entry, gfp_mask, mpol, targ_ilx,
 					&page_allocated, false);
-	if (unlikely(page_allocated))
+	if (unlikely(page_allocated)) {
+		zswap_folio_swapin(folio);
 		swap_read_folio(folio, false, NULL);
-	zswap_folio_swapin(folio);
+	}
 	return folio;
 }
 
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch
selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch

