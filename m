Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C012153E0
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188247; cv=none; b=O8iTrPXOFd6L+Mud8WgpTsqaGKbDCcE9iBtNvIr/pTpq1ghvMk1nHmD6iOU4VMNeqEHo0zl8sWXoDj442bbEpIyF/revQNW+5sSz17ocIqEWr1UOf0hYU4RrjQ8CoWTUr5Xtm2kc80/VmdAbDaFu4CwkKBKwa4lNR2JSU8apK0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188247; c=relaxed/simple;
	bh=iQUCMLJ4AlBwYiwkL86TmgDuc1vo2tsasgM1Clw2SZc=;
	h=Date:To:From:Subject:Message-Id; b=nwftc66ID8WaR4oB/HtswbowumEx+cXvYep2JCRKfWx00v7BcGqJZqiaraLrT3+co6464Oy6VRpLXZ58oLlEdNXQB/h2E+3z7DRBgurUXTRbw9hoojh9rXjznMAbCHAykZSdfydj9XvdWZXMXZaNvXtbhr0DvdEI704VnicqTZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sQbMH2vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sQbMH2vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D961C4CEED;
	Mon, 17 Mar 2025 05:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188245;
	bh=iQUCMLJ4AlBwYiwkL86TmgDuc1vo2tsasgM1Clw2SZc=;
	h=Date:To:From:Subject:From;
	b=sQbMH2vvXc6HuM1ylPJnZFowRn3Rmr74Axdy2RApcvyVkSinniIwBbrslCH5S7tSV
	 Kv0rl1xNOZ8OtHlw317VV9IcarmokIprkgebFv+ZIkAFUhuxowbpyoT/rYMV720bDa
	 54nz+iBMfpcp1AhY9A4eNefRLYp02eIna9fyQQe4=
Date: Sun, 16 Mar 2025 22:10:45 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfilec-remove-the-unneeded-checking.patch removed from -mm tree
Message-Id: <20250317051045.8D961C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile.c: remove the unneeded checking
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-remove-the-unneeded-checking.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swapfile.c: remove the unneeded checking
Date: Wed, 5 Feb 2025 17:27:18 +0800

In free_swap_and_cache_nr(), invocation of get_swap_device() has done the
checking if it's a swap entry.  So remove the redundant checking here.

Link: https://lkml.kernel.org/r/20250205092721.9395-10-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-remove-the-unneeded-checking
+++ a/mm/swapfile.c
@@ -1789,9 +1789,6 @@ void free_swap_and_cache_nr(swp_entry_t
 	bool any_only_cache = false;
 	unsigned long offset;
 
-	if (non_swap_entry(entry))
-		return;
-
 	si = get_swap_device(entry);
 	if (!si)
 		return;
_

Patches currently in -mm which might be from bhe@redhat.com are


