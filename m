Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E588D3D47A5
	for <mm-commits@vger.kernel.org>; Wed,  8 Apr 2026 17:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775669756; cv=none; b=UTLShzLiEKp51RXtflp8FN5lJvyp+Ls99A35ljrB5FpQFd6Afh99tlRI+jfHWWKmGBXH2quVKPMdm5cTetUiHg8KI0LUhb/hZu1psgdv3tS77RoMLpXZ9fL9XEu91Dwng6lNbPI/KJ0EgTh1cDW3YOw2KY+aHoydrTjXUFI64V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775669756; c=relaxed/simple;
	bh=ka9aRT/veR2yJRZIYqQMZME1gG1hY1QiQBw2E52bdic=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=bUuDSQR2x68OG194xH/wz2IlCdV2SRn9XQoycdggyo0p4MyQDSFw6Zp8e71qNgBJd/+ISaeFq099j0fDvIkvexDXi4zoo6EKKTmZDFUK4pcaQOrxsS2RxzAGqUHZUxhK2wz1BVbIRhK+rqODRbS0lxcAEAp/bktmIlkLrGeLxiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x7rPL/KD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x7rPL/KD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF03C19421;
	Wed,  8 Apr 2026 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775669755;
	bh=ka9aRT/veR2yJRZIYqQMZME1gG1hY1QiQBw2E52bdic=;
	h=Date:From:To:Cc:Subject:From;
	b=x7rPL/KD8tG22heS7t+m9wAVz4IiOc8wbVCKgrUGvuSx/0cqPamhuP06IpWwBsG+0
	 5rrciw1s1MYXlQxmtJY1w3ru3b9gkO0uu7EhnjceNQC7oQ7oVRNZIACzA3SdSYsBdJ
	 xVQ7UOs1DOpb55zhQ/WJsUOvTlSJMoTPlVdKeXSg=
Date: Wed, 8 Apr 2026 10:35:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Cc: mm-commits@vger.kernel.org
Subject: mm.git review status at 7.0-rc7
Message-Id: <20260408103554.6221935c7c13c2daf197ecd0@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Thanks everyone for the diligent review - we're doing well.  Apologies for
all the nagging.

I believe it has been useful - several patch series have been updated in
response to the review.  Also 2-3 patches were dropped or deferred -
patches which I expect I would have upstreamed in the ordinary course of
things.

Merge plans: no significant change since last week
(https://lkml.kernel.org/r/20260331213956.2f3925ff0dd12eabf55b7c37@linux-foundation.org).
107 patches are lined up for the second week of the merge window.  Search
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series
for "2nd week of merge window".




mm.git review status for mm-stable-plus-hotfixes..mm-new

Everything:

Total patches:       115
Reviews/patch:       1.93
Reviewed rate:       87%

Excluding DAMON:

Total patches:       107
Reviews/patch:       2.07
Reviewed rate:       93%



Unreviewed patches by author:


Anthony Yznaga <anthony.yznaga@oracle.com> (1 total)
    "selftests/mm: verify droppable mappings cannot be locked"
        Link: https://lkml.kernel.org/r/20260402235933.10588-3-anthony.yznaga@oracle.com

David Carlier <devnexen@gmail.com> (1 total)
    "mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path"
        Link: https://lkml.kernel.org/r/20260322052120.14021-1-devnexen@gmail.com

Breno Leitao <leitao@debian.org> (1 total)
    "kho: fix kho_in_debugfs_init() to handle non-FDT blobs"
        Link: https://lkml.kernel.org/r/20260316-kho-v9-4-ed6dcd951988@debian.org

Lorenzo Stoakes (Oracle) <ljs@kernel.org> (1 total)
    "tools/testing/selftests: add merge test for partial msealed range"
        Link: https://lkml.kernel.org/r/1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local
        Link: https://lkml.kernel.org/r/20260331073627.50010-1-ljs@kernel.org

Mike Rapoport <rppt@kernel.org> (3 total)
    "tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix"
        Link: https://lkml.kernel.org/r/ac_mCIUQWRAbuH8F@kernel.org

SeongJae Park <sj@kernel.org> (7 total)
    "mm/damon/core: fix damon_call() vs kdamond_fn() exit race"
        Link: https://lkml.kernel.org/r/20260327233319.3528-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260327233319.3528-2-sj@kernel.org
        Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org [1]
    "mm/damon/core: fix damos_walk() vs kdamond_fn() exit race"
        Link: https://lkml.kernel.org/r/20260327233319.3528-3-sj@kernel.org
        Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org [1]
    "mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp"
        Link: https://lkml.kernel.org/r/20260329043902.46163-2-sj@kernel.org
        Link: https://lore.kernel.org/20260325073034.140353-1-objecting@objecting.org [1]
        Link: https://lore.kernel.org/20260327040924.68553-1-sj@kernel.org [2]
    "mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp"
        Link: https://lkml.kernel.org/r/20260329043902.46163-3-sj@kernel.org
    "mm/damon/core: use time_in_range_open() for damos quota window start"
        Link: https://lkml.kernel.org/r/20260329152306.45796-1-sj@kernel.org
        Link: https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org [1]
    "Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race"
        Link: https://lkml.kernel.org/r/20260329153052.46657-2-sj@kernel.org
        Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org [1]
        Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [3]
    "Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race"
        Link: https://lkml.kernel.org/r/20260329153052.46657-3-sj@kernel.org
        Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [1]



