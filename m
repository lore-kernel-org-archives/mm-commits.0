Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B064BA2D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 01:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976274; cv=none; b=Lzfm1QncsCXpBhjwkNbnIOwJf1og1gmHIZdVxZ3puKYrAZPMczeGsrBemEAhgf6GMCD+Mldors4RbZVQG5SpiFS5/hrEBu7rTpUlxa5GmNgQqYUmbmtFWoMptWbNLb5Id4Xt8vvG3DanUDr5ivLCqQ5hejmkJ7uP1VKsCOywLJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976274; c=relaxed/simple;
	bh=ZEFgF8rBrbLeUqhO6oth+ORQZ8XxGw1ogbB79OBqvi0=;
	h=Date:To:From:Subject:Message-Id; b=n6V3dbVU6sle4bySzFEeC9WDl8RDjEmyHqw6Ha+ZgUDWDKtRgOvZ1Zd1em94PYTktdGQx7oZsg6CEQeGhypZoTNGfqkoolGiKVaIqaPeU1cUsekoYLsNBaMqAyPp/P4xCsw3inrKW00BgOgIRc28/A2iR0elSlgo1kOQTeYNxUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iGYDReza; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iGYDReza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64771C4CEE3;
	Sun, 20 Jul 2025 01:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976273;
	bh=ZEFgF8rBrbLeUqhO6oth+ORQZ8XxGw1ogbB79OBqvi0=;
	h=Date:To:From:Subject:From;
	b=iGYDRezaeUT5fsxCbsqGR3QAe7wNAMECrCVH46xYr0VU1UvcH4DfUBAyTPB0gba61
	 cEjoNfm+gtkSXs1s+UiDpaQBJtnTffLEDGEqoPmwdzxdgPvahFNxAXwPSJ+HiV7UoB
	 u2XARZ16MmC350I64vfjU0J2hFR/W2zXnAwZeKdQ=
Date: Sat, 19 Jul 2025 18:51:12 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,willy@infradead.org,tj@kernel.org,surenb@google.com,mszeredi@redhat.com,mpatlasov@parallels.com,mhocko@suse.com,kirill.shutemov@linux.intel.com,joannelkoong@gmail.com,jlayton@kernel.org,jefflexu@linux.alibaba.com,jack@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,corbet@lwn.net,axboe@kernel.dk,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix.patch removed from -mm tree
Message-Id: <20250720015113.64771C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix.patch

This patch was dropped because it was folded into mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix
Date: Mon, 7 Jul 2025 16:09:31 +0200

Also remove the mention of NR_WRITEBACK_TEMP implications from a comment
in wb_position_ratio(). The rest of the comment there about fuse setting
bdi->max_ratio to 1% is still correct.

Link: https://lkml.kernel.org/r/5a848e15-6a57-4ecb-a015-d4f358b8a5d3@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page-writeback.c~mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter-fix
+++ a/mm/page-writeback.c
@@ -1101,9 +1101,7 @@ static void wb_position_ratio(struct dir
 	 * such filesystems balance_dirty_pages always checks wb counters
 	 * against wb limits. Even if global "nr_dirty" is under "freerun".
 	 * This is especially important for fuse which sets bdi->max_ratio to
-	 * 1% by default. Without strictlimit feature, fuse writeback may
-	 * consume arbitrary amount of RAM because it is accounted in
-	 * NR_WRITEBACK_TEMP which is not involved in calculating "nr_dirty".
+	 * 1% by default.
 	 *
 	 * Here, in wb_position_ratio(), we calculate pos_ratio based on
 	 * two values: wb_dirty and wb_thresh. Let's consider an example:
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmstat-remove-the-nr_writeback_temp-node_stat_item-counter.patch

