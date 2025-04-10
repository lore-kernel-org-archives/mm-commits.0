Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2AB2905
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 22:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744324376; cv=none; b=HR+BjpCGxcnhLyBvlr5LU25h0ibJhryzw0mfnJsDOD+PbbBRXK6WnAO8WRluFAQsIbI01fhsi+/6QV7Tf6xIeXOdLmvU+VdDvLyHXgoI3sK2MnXcJwPu9GZUMqabrbC/tzT1wrmezrfbuO1s1qnMneZ1tXN6oEieS1hxuHVe2ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744324376; c=relaxed/simple;
	bh=p4hUdEMim+7YXUqV4tXjf1D2InynWWufg8q0BGEgJv4=;
	h=Date:To:From:Subject:Message-Id; b=UUl2Ty6yZzvGXrWoQagCzX7dutIHrwGcpWsAz1GX6blUxSDzc5t8goABG6c/3+/Hl6rzJ+N6192eyyb1BXTYr66EXLlwh+Rx72iNCFg4Hh4gpkqCUTzVssPCYIJtraMcPj5cLh13ENk4Ux+pCOdn7iKb2ABEBDCRlcy9BcZ9RIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ee7NX7us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ee7NX7us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367A2C4CEDD;
	Thu, 10 Apr 2025 22:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744324376;
	bh=p4hUdEMim+7YXUqV4tXjf1D2InynWWufg8q0BGEgJv4=;
	h=Date:To:From:Subject:From;
	b=ee7NX7usX9O86U06Nd8DmoB44YYjNjqPrXEZuUKLKLqyWFsc/Oc8ttaQdHOTdHQgk
	 KxvXG1VYfFfrsnMhvG9Uox+AYVk57kBayA8B0NMvynsO7xh/EnyHkJs5ewlxZG4507
	 WIQhD4Y2o88F84dshuwVvjIaFDdHPoMDvR6567E0=
Date: Thu, 10 Apr 2025 15:32:55 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch added to mm-new branch
Message-Id: <20250410223256.367A2C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: add __maybe_unused attribute for swap_is_last_ref() and update it's comment
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch

This patch will later appear in the mm-new branch at
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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: add __maybe_unused attribute for swap_is_last_ref() and update it's comment
Date: Thu, 10 Apr 2025 23:39:08 +0800

Add __maybe_unused attribute for swap_is_last_ref ()to fix following build
warning:

mm/swapfile.c:1517:20: warning: function 'swap_is_last_ref' is not needed and will not be emitted [-Wunneeded-internal-declaration]
    1517 | static inline bool swap_is_last_ref(unsigned char count)
         |                    ^~~~~~~~~~~~~~~~
   1 warning generated.

Besides, original comment for swap_entries_free() is placed before
swap_is_last_ref() which may introduce confusion.  Update comment to
address this.

Link: https://lkml.kernel.org/r/20250410153908.612984-1-shikemeng@huaweicloud.com
Fixes: 6bb001b6b64ec ("mm: swap: enable swap_entry_range_free() to drop any kind of last ref")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Suggested-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Tested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix
+++ a/mm/swapfile.c
@@ -1511,15 +1511,19 @@ fallback:
 }
 
 /*
- * Drop the last ref(1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM) of swap entries,
- * caller have to ensure all entries belong to the same cgroup and cluster.
+ * Check if it's the last ref of swap entry in the freeing path.
+ * Qualified vlaue includes 1, SWAP_HAS_CACHE or SWAP_MAP_SHMEM.
  */
-static inline bool swap_is_last_ref(unsigned char count)
+static inline bool __maybe_unused swap_is_last_ref(unsigned char count)
 {
 	return (count == SWAP_HAS_CACHE) || (count == 1) ||
 	       (count == SWAP_MAP_SHMEM);
 }
 
+/*
+ * Drop the last ref of swap entries, caller have to ensure all entries
+ * belong to the same cgroup and cluster.
+ */
 static void swap_entries_free(struct swap_info_struct *si,
 			      struct swap_cluster_info *ci,
 			      swp_entry_t entry, unsigned int nr_pages)
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-rename-__swap__free-to-swap__put.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref.patch
mm-swap-enable-swap_entry_range_free-to-drop-any-kind-of-last-ref-fix.patch
mm-swap-use-swap_entries_free-to-free-swap-entry-in-swap_entry_put_locked.patch
mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch
mm-swap-drop-last-swap_map_shmem-flag-in-batch-in-swap_entries_put_nr.patch
mm-swap-free-each-cluster-individually-in-swap_entries_put_map_nr.patch
mm-swap-factor-out-helper-to-drop-cache-of-entries-within-a-single-cluster.patch
mm-swap-replace-cluster_swap_free_nr-with-swap_entries_put_.patch

