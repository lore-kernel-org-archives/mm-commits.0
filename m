Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A003C4167
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439188; cv=none; b=ldUU2zbFUav9tIHOYr6HPTM+G9PYA0bFn4HEKJrc43bsO/Yra+4NvQN3dCOpKs78+zU1bmDsSpwfTRbP9nkwxK0fsdsyKTxsNkptIPbqJfY+AcHpHtsb4PNAQNXbBMT5MGc3CoamC2WS6Q9A2mut9DYWEAah6HtQXGCQ85eV4KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439188; c=relaxed/simple;
	bh=EjK/ti6XWgYb+QyAVmgLmCMdtZ3UJ8fuXE0KXkMbNlY=;
	h=Date:To:From:Subject:Message-Id; b=q+HHxlV536hTbqe1DtI1/hj1BtXEGnYMvncdUHz8pWYR80+Jv4BOKa4lwykvGNLFxfvU4+hUO3sIIniwwK+NZtQR8miTnqx68Om5GuC4UU/4LtHG1jPyVJDFhyBH3ex566PSS9wMOUZeKQep1qshX0i1RHkS3DAfUiJAKER5WDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fqlmcgQ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fqlmcgQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE34E1F00893;
	Tue,  2 Jun 2026 22:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439186;
	bh=nmymaY2lqC9NnfTPYVFBxdDOMQey9YjO40EV1f+zdaA=;
	h=Date:To:From:Subject;
	b=fqlmcgQ7RonwBJVHUZ+CbvCqFo8Bl9/Nbluk1pUWNOqT6IxfmCf2wsIEYwH6BUc7A
	 xluoQkJLM2lo629XfHQTZz6I3NQ/QNosTYL93jrAustbt4k2AfwhGaisoGsl7HJidM
	 88vAAlDULV+PX7iFuqApmx04VtrF2xJFUEDcQx2A=
Date: Tue, 02 Jun 2026 15:26:26 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch removed from -mm tree
Message-Id: <20260602222626.CE34E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: remove redundant swap constrained check upon isolation
has been removed from the -mm tree.  Its filename was
     mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: remove redundant swap constrained check upon isolation
Date: Tue, 28 Apr 2026 02:07:00 +0800

Remove the swap-constrained early reject check upon isolation.  This check
is a micro optimization when swap IO is not allowed, so folios are
rejected early.  But it is redundant and overly broad since
shrink_folio_list() already handles all these cases with proper
granularity.

Notably, this check wrongly rejected lazyfree folios, and it doesn't cover
all rejection cases.  shrink_folio_list() uses may_enter_fs(), which
distinguishes non-SWP_FS_OPS devices from filesystem-backed swap and does
all the checks after folio is locked, so flags like swap cache are stable.

This check also covers dirty file folios, which are not a problem now
since sort_folio() already bumps dirty file folios to the next generation,
but causes trouble for unifying dirty folio writeback handling.

And there should be no performance impact from removing it.  We may have
lost a micro optimization, but unblocked lazyfree reclaim for NOIO
contexts, which is not a common case in the first place.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-9-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/vmscan.c~mm-mglru-remove-redundant-swap-constrained-check-upon-isolation
+++ a/mm/vmscan.c
@@ -4654,12 +4654,6 @@ static bool isolate_folio(struct lruvec
 {
 	bool success;
 
-	/* swap constrained */
-	if (!(sc->gfp_mask & __GFP_IO) &&
-	    (folio_test_dirty(folio) ||
-	     (folio_test_anon(folio) && !folio_test_swapcache(folio))))
-		return false;
-
 	/* raced with release_pages() */
 	if (!folio_try_get(folio))
 		return false;
_

Patches currently in -mm which might be from kasong@tencent.com are


