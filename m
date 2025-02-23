Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B28228F4
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 01:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740275133; cv=none; b=gQv2FrnL8636fuvQJRu9cJH7s4UxAv0d6cyF41D9Fah6BW+g9t61bmEbNrMtuWU9rQjD+KvP9+rSuUZZ1NOaM1kV13dw7sQVJqevZqJ25kfcA0ONDEk/j0Du1xiXLB9C6A7qgkngwCaxf512mCKAqRX1XtY3juu9KSRg6D1btP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740275133; c=relaxed/simple;
	bh=9dZQT4hGWWWRb3LnLjUDg331NILs5vwhk05Ahe7EWWQ=;
	h=Date:To:From:Subject:Message-Id; b=J5k3Ecu0mztlANKHrk2sy3P2FOh+pn9LD+ebz0WV+Q7i8cCa8ex2TdFOZv0DUwk3ddIVCK5GXo7Mv4IHny9X9jzinsCUEGN5DAFKfwHhDWYgYL1B334j2EsoLAtEIe7tGZslgsZ3A77b9n333eTDb0akLmCGMAlPf90mSuH83rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EPbtQP0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPbtQP0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4592C4CED1;
	Sun, 23 Feb 2025 01:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740275132;
	bh=9dZQT4hGWWWRb3LnLjUDg331NILs5vwhk05Ahe7EWWQ=;
	h=Date:To:From:Subject:From;
	b=EPbtQP0YNb6IbAQawmtoBg1Xb/MS0Hu6qYdqyANFAnwWJtNAmeV5Z8IgOcailJBVn
	 hUAQpbKmppI8OO8xUO5hTBdacIuJSCdenmlzfazD6y7oxSFsAxvjuVPl1VyF/ELwHp
	 JwkqZ5ZSKIzCYycnyIzkhM5oyt4mLdRk0r4GIur4=
Date: Sat, 22 Feb 2025 17:45:32 -0800
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch added to mm-unstable branch
Message-Id: <20250223014532.B4592C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: remove stale comment of swap_reclaim_full_clusters()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: remove stale comment of swap_reclaim_full_clusters()
Date: Sun, 23 Feb 2025 00:08:50 +0800

swap_reclaim_full_clusters() has no return value now, just remove the
stale comment which says swap_reclaim_full_clusters() wil return a bool
value.

Link: https://lkml.kernel.org/r/20250222160850.505274-7-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters
+++ a/mm/swapfile.c
@@ -820,7 +820,6 @@ out:
 	return found;
 }
 
-/* Return true if reclaimed a whole cluster */
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 {
 	long to_scan = 1;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-avoid-losting-cluster-in-swap_reclaim_full_clusters.patch
mm-swap-use-correct-step-in-loop-to-wait-all-clusters-in-wait_for_allocation.patch
mm-swap-avoid-bug_on-in-relocate_cluster.patch
mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

