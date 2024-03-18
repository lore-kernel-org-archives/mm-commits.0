Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC9555C16;
	Mon, 18 Mar 2024 19:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710789915; cv=none; b=Qtm+Ax/X9dd3vbyHQuFde/0mqgHtMIfyQnB8jE7T/d2Hf89gOSUnS2eRscKMPSIHzwi/qosKS/ECr1CGihqYHORNhp1/ntBFkYOX3OFs5cHeet9LrEPy9OMtqA7Aiyr6C6Gq9k2kpTqaRP3DXAeQ70KGHulk+V7eCFa1x5FEvAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710789915; c=relaxed/simple;
	bh=Av/ON1HOSRbDOn3Trqb+akXjfyDeOtmnnvfxi2FEdyM=;
	h=Date:To:From:Subject:Message-Id; b=lwDya6uiPW4jj9OcYimglwzLvbekOXvGoKtXbkcla+11O2LZGNiTR5zyAcyj6SupNf25XGluad6tG2kB934toV753D9b9G/uz/rquZijCiIXpBCo9WFVUn+tx20C5wKezqukUR3Vk/K80FxLHoJf18ynjFi0M3E1R56ctSVQynw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uS5ZK69Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uS5ZK69Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D76AC433F1;
	Mon, 18 Mar 2024 19:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710789915;
	bh=Av/ON1HOSRbDOn3Trqb+akXjfyDeOtmnnvfxi2FEdyM=;
	h=Date:To:From:Subject:From;
	b=uS5ZK69Q2Fb5DtXKHnkIy81U72tUWbkB2djyFJOvCUvDjzUkORPcEOlkYpLF6teDY
	 rR6g3GgS1k+Gr4+eOd0fD6ko1H/Euikc6W2adkrfYpyMaxzVh27o1WBAWydSJe0Ast
	 nMwd4NFFxTKPsreArX3KLfrovXbPZGGHl8QhHysE=
Date: Mon, 18 Mar 2024 12:25:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,nphamcs@gmail.com,jannh@google.com,chengming.zhou@linux.dev,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cachestat-fix-two-shmem-bugs.patch added to mm-hotfixes-unstable branch
Message-Id: <20240318192515.4D76AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: cachestat: fix two shmem bugs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-cachestat-fix-two-shmem-bugs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cachestat-fix-two-shmem-bugs.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: cachestat: fix two shmem bugs
Date: Fri, 15 Mar 2024 05:55:56 -0400

When cachestat on shmem races with swapping and invalidation, there
are two possible bugs:

1) A swapin error can have resulted in a poisoned swap entry in the
   shmem inode's xarray. Calling get_shadow_from_swap_cache() on it
   will result in an out-of-bounds access to swapper_spaces[].

   Validate the entry with non_swap_entry() before going further.

2) When we find a valid swap entry in the shmem's inode, the shadow
   entry in the swapcache might not exist yet: swap IO is still in
   progress and we're before __remove_mapping; swapin, invalidation,
   or swapoff have removed the shadow from swapcache after we saw the
   shmem swap entry.

   This will send a NULL to workingset_test_recent(). The latter
   purely operates on pointer bits, so it won't crash - node 0, memcg
   ID 0, eviction timestamp 0, etc. are all valid inputs - but it's a
   bogus test. In theory that could result in a false "recently
   evicted" count.

   Such a false positive wouldn't be the end of the world. But for
   code clarity and (future) robustness, be explicit about this case.

   Bail on get_shadow_from_swap_cache() returning NULL.

Link: https://lkml.kernel.org/r/20240315095556.GC581298@cmpxchg.org
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Chengming Zhou <chengming.zhou@linux.dev>	[Bug #1]
Reported-by: Jann Horn <jannh@google.com>		[Bug #2]
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>				[v6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/filemap.c~mm-cachestat-fix-two-shmem-bugs
+++ a/mm/filemap.c
@@ -4197,7 +4197,23 @@ static void filemap_cachestat(struct add
 				/* shmem file - in swap cache */
 				swp_entry_t swp = radix_to_swp_entry(folio);
 
+				/* swapin error results in poisoned entry */
+				if (non_swap_entry(swp))
+					goto resched;
+
+				/*
+				 * Getting a swap entry from the shmem
+				 * inode means we beat
+				 * shmem_unuse(). rcu_read_lock()
+				 * ensures swapoff waits for us before
+				 * freeing the swapper space. However,
+				 * we can race with swapping and
+				 * invalidation, so there might not be
+				 * a shadow in the swapcache (yet).
+				 */
 				shadow = get_shadow_from_swap_cache(swp);
+				if (!shadow)
+					goto resched;
 			}
 #endif
 			if (workingset_test_recent(shadow, true, &workingset))
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-cachestat-fix-two-shmem-bugs.patch

