Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F5B1EEA47
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119328; cv=none; b=X26GDND+zN7y7jO2vfKEX5wSCW73LFTImpz6ANcQCfN3ADe4BTAZQgdZrXKA9L8o4Eb+Ufi5Amxx/2CiFK7dUkoHH1/SC+OJMeiMhxtHsJT13AJVWj7Ro4+jXV3vLOcBKNGykBNDnPJ1huvXRVmqkLBdVuP2d4vMmpGhDBE3n7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119328; c=relaxed/simple;
	bh=6c3MNRXa7wuAReFG7XCPFvzBMvy0bZJYGBjMvNsn+8g=;
	h=Date:To:From:Subject:Message-Id; b=mVycdMnoUY5hSPp6TObv6ItXCQodaNeH1Ei1GObh2E52xtXNXmqFeo8tSuHOgXNRfHHScAokDP5J2XUGs6a4y43mgvNFhCFzQqFXQQRPhEQNzQgZxV5iXJcMswgNKYsbrYvNH786Hz92z8L3oj1T+dwwNep7N+gjB/kG7RGcL5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KLIS+jCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KLIS+jCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECBDC4CEE4;
	Tue, 13 May 2025 06:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119328;
	bh=6c3MNRXa7wuAReFG7XCPFvzBMvy0bZJYGBjMvNsn+8g=;
	h=Date:To:From:Subject:From;
	b=KLIS+jClvxHnvDNLvp03xzQTOJiwySYS30zifNcGgGToD4oIPQ5t0po5DQZ6TKz+G
	 CK8n8L2oGaOwI63JYT17lf/21jMbryFlCJg1GwLngv2zLlqUQi+DAAXUTMaFlbw/Le
	 phqgQjJxwTu40QtzeoWSSgvxr6OydYyp3syk2fg8=
Date: Mon, 12 May 2025 23:55:27 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-remove-no-longer-used-swap-mapping-helper.patch removed from -mm tree
Message-Id: <20250513065528.5ECBDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: remove no longer used swap mapping helper
has been removed from the -mm tree.  Its filename was
     mm-swap-remove-no-longer-used-swap-mapping-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm, swap: remove no longer used swap mapping helper
Date: Thu, 1 May 2025 02:10:52 +0800

This helper existed to fix the circular header dependency issue but it is
no longer used since commit 0d40cfe63a2f ("fs: remove
folio_file_mapping()"), remove it.

Link: https://lkml.kernel.org/r/20250430181052.55698-7-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 mm/swapfile.c           |    9 ---------
 2 files changed, 10 deletions(-)

--- a/include/linux/pagemap.h~mm-swap-remove-no-longer-used-swap-mapping-helper
+++ a/include/linux/pagemap.h
@@ -533,7 +533,6 @@ static inline void filemap_nr_thps_dec(s
 }
 
 struct address_space *folio_mapping(struct folio *);
-struct address_space *swapcache_mapping(struct folio *);
 
 /**
  * folio_flush_mapping - Find the file mapping this folio belongs to.
--- a/mm/swapfile.c~mm-swap-remove-no-longer-used-swap-mapping-helper
+++ a/mm/swapfile.c
@@ -3663,15 +3663,6 @@ struct swap_info_struct *swp_swap_info(s
 }
 
 /*
- * out-of-line methods to avoid include hell.
- */
-struct address_space *swapcache_mapping(struct folio *folio)
-{
-	return swp_swap_info(folio->swap)->swap_file->f_mapping;
-}
-EXPORT_SYMBOL_GPL(swapcache_mapping);
-
-/*
  * add_swap_count_continuation - called when a swap count is duplicated
  * beyond SWAP_MAP_MAX, it allocates a new page and links that to the entry's
  * page of the original vmalloc'ed swap_map, to hold the continuation count
_

Patches currently in -mm which might be from kasong@tencent.com are


