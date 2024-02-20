Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25411152E18
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 22:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467746; cv=none; b=DBg5JQTeVssl3b6JxwPZklowVnipU/yHJKbql3Z8uhKrGY0ZrUqFG5mHESAmVQb5fp7A4gXwTXc6bGsJ86e0gepZpkv77layFOsDKUmfcmhYRzV6zDgEUyBXzVUEyxV4zTxqASnXpkzdP3pCfoHrfTgEnch2MO8F3b11sxydhgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467746; c=relaxed/simple;
	bh=hxQYdY1h+LM1Dmn9pGX4ROXOFWaMnuDeKQaVqfmkfRg=;
	h=Date:To:From:Subject:Message-Id; b=KJG+O7MM7zqbpys32mDKYXRrgx6QvFvggwpEL08176kT3AJsI2XNG12yXHlsOGhGfMIFyINhy471dKthCdV9OXzbRwg5UlR6rar0FScbsSMG33NTGTn7Ub62jxy45CANE7MBbnYfJH25okHwWTR0jozprBPCBsVqbnDVTwk3FQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ULo/vwGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ULo/vwGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA1DC43390;
	Tue, 20 Feb 2024 22:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467745;
	bh=hxQYdY1h+LM1Dmn9pGX4ROXOFWaMnuDeKQaVqfmkfRg=;
	h=Date:To:From:Subject:From;
	b=ULo/vwGZ+ctzO1LwQwvhVSl4M8eb4e9pqwmkEpcKISGifs6bPqYF0iYaE/YCrhFoH
	 t0hoNVAi6+AOPCikzzL4rlsXU/L5UbACiC9SXdj5JWBbTGP0GY5Xec6sVkZ+bkeyTd
	 WjkvKa4pj07gfFY+v5Q1XoioJzCOsJp/4+W2jpuU=
Date: Tue, 20 Feb 2024 14:22:25 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,hannes@cmpxchg.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch removed from -mm tree
Message-Id: <20240220222225.8FA1DC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap_state: update zswap LRU's protection range with the folio locked
has been removed from the -mm tree.  Its filename was
     mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm/swap_state: update zswap LRU's protection range with the folio locked
Date: Mon, 5 Feb 2024 15:24:42 -0800

When a folio is swapped in, the protection size of the corresponding zswap
LRU is incremented, so that the zswap shrinker is more conservative with
its reclaiming action.  This field is embedded within the struct lruvec,
so updating it requires looking up the folio's memcg and lruvec.  However,
currently this lookup can happen after the folio is unlocked, for instance
if a new folio is allocated, and swap_read_folio() unlocks the folio
before returning.  In this scenario, there is no stability guarantee for
the binding between a folio and its memcg and lruvec:

* A folio's memcg and lruvec can be freed between the lookup and the
  update, leading to a UAF.
* Folio migration can clear the now-unlocked folio's memcg_data, which
  directs the zswap LRU protection size update towards the root memcg
  instead of the original memcg. This was recently picked up by the
  syzbot thanks to a warning in the inlined folio_lruvec() call.

Move the zswap LRU protection range update above the swap_read_folio()
call, and only when a new page is allocated, to prevent this.

[nphamcs@gmail.com: add VM_WARN_ON_ONCE() to zswap_folio_swapin()]
  Link: https://lkml.kernel.org/r/20240206180855.3987204-1-nphamcs@gmail.com
[nphamcs@gmail.com: remove unneeded if (folio) checks]
  Link: https://lkml.kernel.org/r/20240206191355.83755-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20240205232442.3240571-1-nphamcs@gmail.com
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Reported-by: syzbot+17a611d10af7d18a7092@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000ae47f90610803260@google.com/
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   10 ++++++----
 mm/zswap.c      |    7 +++----
 2 files changed, 9 insertions(+), 8 deletions(-)

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
 
--- a/mm/zswap.c~mm-swap_state-update-zswap-lrus-protection-range-with-the-folio-locked
+++ a/mm/zswap.c
@@ -377,10 +377,9 @@ void zswap_folio_swapin(struct folio *fo
 {
 	struct lruvec *lruvec;
 
-	if (folio) {
-		lruvec = folio_lruvec(folio);
-		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
-	}
+	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	lruvec = folio_lruvec(folio);
+	atomic_long_inc(&lruvec->zswap_lruvec_state.nr_zswap_protected);
 }
 
 /*********************************
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-cachestat-fix-folio-read-after-free-in-cache-walk.patch
selftests-zswap-add-zswap-selftest-file-to-zswap-maintainer-entry.patch
selftests-fix-the-zswap-invasive-shrink-test.patch
selftests-add-zswapin-and-no-zswap-tests.patch

