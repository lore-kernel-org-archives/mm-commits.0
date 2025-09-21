Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67D821D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489990; cv=none; b=sBKXbXd5DprUmwj9gc5j4aFLw8txzw9I73mxjB3VpYxeSc1suGj3weDKSiUCLKTPAHgVIRk9nViWwrQTqyCKQQx9rJPnM6i4oUZUTwzKVKEy4PkPuIMr3/86CSvQJ8ihDVeVrX0PjbMIYagFIBkq9iQaAFdVtyBSta7JvOVHqAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489990; c=relaxed/simple;
	bh=BaTrUElmsqhnxYUI4AX8151EMMtihz1pkmfIX2MJe2E=;
	h=Date:To:From:Subject:Message-Id; b=ENMe0pPskJf+fafmdv/kEW3W5PsvUXdQPflKq94LlqgmZV4cSD7bVfR99mQPwSOwPw1J7204strBijoV1ALCOT2zd9iE/AO++8ieuB6kiWVY1OJ6TWHnhh1zwb0jxmFc9q4Dcsi6K5b7qNUlSrQmW/eA9QcpshDC+wU3qxt6zjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dgvE8od5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dgvE8od5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D01CC4CEE7;
	Sun, 21 Sep 2025 21:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489990;
	bh=BaTrUElmsqhnxYUI4AX8151EMMtihz1pkmfIX2MJe2E=;
	h=Date:To:From:Subject:From;
	b=dgvE8od5NMo3pK/OJWimdRJDAhSHPyLBdy/0gSw0eIwy2Lv/o7DlBU1l2KR0icbiT
	 npsLcV2nCiHd8p/7QlwKW6KjBJXK6eJKMEX0RLVM9F+AhRKzTcJ2b+h8gFIWcsqkXo
	 AXPpWpi+aPQZ89arq+QthvpX/a6bpMiVFIMziC+Q=
Date: Sun, 21 Sep 2025 14:26:30 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,yangge1116@126.com,willy@infradead.org,will@kernel.org,weixugc@google.com,vbabka@suse.cz,shivankg@amd.com,riel@surriel.com,peterx@redhat.com,lizhe.67@bytedance.com,koct9i@gmail.com,keirf@google.com,jhubbard@nvidia.com,jgg@ziepe.ca,hch@infradead.org,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,axelrasmussen@google.com,aneesh.kumar@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-lru_add_drain_all-do-local-lru_add_drain-first.patch removed from -mm tree
Message-Id: <20250921212630.7D01CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: lru_add_drain_all() do local lru_add_drain() first
has been removed from the -mm tree.  Its filename was
     mm-lru_add_drain_all-do-local-lru_add_drain-first.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: lru_add_drain_all() do local lru_add_drain() first
Date: Mon, 8 Sep 2025 15:24:54 -0700 (PDT)

No numbers to back this up, but it seemed obvious to me, that if there are
competing lru_add_drain_all()ers, the work will be minimized if each
flushes its own local queues before locking and doing cross-CPU drains.

Link: https://lkml.kernel.org/r/33389bf8-f79d-d4dd-b7a4-680c4aa21b23@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keir Fraser <keirf@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: yangge <yangge1116@126.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/swap.c~mm-lru_add_drain_all-do-local-lru_add_drain-first
+++ a/mm/swap.c
@@ -834,6 +834,9 @@ static inline void __lru_add_drain_all(b
 	 */
 	this_gen = smp_load_acquire(&lru_drain_gen);
 
+	/* It helps everyone if we do our own local drain immediately. */
+	lru_add_drain();
+
 	mutex_lock(&lock);
 
 	/*
_

Patches currently in -mm which might be from hughd@google.com are


