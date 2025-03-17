Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D768079D2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742185961; cv=none; b=Jn+XzGjr4oii8BAWL558M/kI1v4LFQuRJpdsaDVkM4F4rtdOvAz5I/AvCjFRqZg+0XowjzioteIwh0TwiAHYLHUIc2sJOIx8rTuA934hPn1100tnZEAd259hHYL+VIlZlrJR1tHAVEz+KEyQYFFe2B89HqjHC419lCmOS9UpsE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742185961; c=relaxed/simple;
	bh=Y9o6x3pgHWq5iN8vcvsdN01c3zUnFHYqhhM2LzTlKpU=;
	h=Date:To:From:Subject:Message-Id; b=cx+CPLWgS1phE2RY9v/S7o1utVH6ARuoyuXfCCoEe5PgTpBzljwyKkXr0kTgYT308OHG0N7hinRAtXOT4RdInJVWX39lOTerpuWeF1Baw73BKCXZBh9YUmNYp2tZ+MT24vxtkkdPucZhMG9BJASCt+0cC68W7iTL6rh7Yn5AOkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TmkyBe3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TmkyBe3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840C4C4CEEC;
	Mon, 17 Mar 2025 04:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742185961;
	bh=Y9o6x3pgHWq5iN8vcvsdN01c3zUnFHYqhhM2LzTlKpU=;
	h=Date:To:From:Subject:From;
	b=TmkyBe3i3wWffg5ynBTZAEmntfpyM/ZHTgqRX/3b/hRE3HOHCQVD8rv026TnUG9oL
	 sGFyCrM0diO56kAcT+/WU53qj0qZht9wMPc5Bwe4T+w5ZqRQ90+eMw7DQmGzjz8NoZ
	 DjhU6NnmRZafwAWXpgCxJzlVBPAFolKOcKn+egRQ=
Date: Sun, 16 Mar 2025 21:32:40 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2.patch removed from -mm tree
Message-Id: <20250317043241.840C4C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile.c: update the code comment above swap_count_continued()
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2.patch

This patch was dropped because it was folded into mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swapfile.c: update the code comment above swap_count_continued()
Date: Fri, 7 Feb 2025 10:50:37 +0800

Now, swap_count_continued() has two callers, __swap_duplicate() and
__swap_entry_free_locked(), the relevant code comment is stale.  Update it
to reflect the current situation.

Link: https://lkml.kernel.org/r/Z6V0/UvG1fvkQ4t/@fedora
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfilec-update-the-code-comment-above-swap_count_continued-v2
+++ a/mm/swapfile.c
@@ -3798,7 +3798,7 @@ outer:
  * when the original swap_map count is decremented from 0 with continuation,
  * borrow from the continuation and report whether it still holds more.
  * Called while __swap_duplicate() or caller of __swap_entry_free_locked()
- * holds swap or cluster lock.
+ * holds cluster lock.
  */
 static bool swap_count_continued(struct swap_info_struct *si,
 				 pgoff_t offset, unsigned char count)
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
mm-mmu_gather-remove-unused-__tlb_remove_page.patch
mm-mmu_gather-clean-up-the-stale-code-comment.patch

