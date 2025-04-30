Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BB819307F
	for <mm-commits@vger.kernel.org>; Wed, 30 Apr 2025 21:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047097; cv=none; b=UZxcDmH8H1LSIB9KGbJ3DfVlln5/GpTeZzBfvs646NY16CFbMDlgumvdLuNuVu5eQjizu6w3m3qiXuzG8tSCm/Qwpy3vS56qkvuA+peh+BprJeMtDP4FT9MjUUKyCGndx1sNfSFVucpYMyO1UnEXWu8R/1WRxbu4+EJMzFG10pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047097; c=relaxed/simple;
	bh=91OpLLJDdN2jvxpC1DiWvpLwbi2l7rgE6OjI3TfFY64=;
	h=Date:To:From:Subject:Message-Id; b=k0nPWC537jkBTm5oIRRX8m7M9pATggRMjATYX5ChIOPz9Eg7V0uAjj9cqV/do9Y1FRmq4TWEk+FByv1klQiNXNWQ5XvNgkdgjZnlmsWhk38KhUikursjzSIu2XMk6agOyAyMW4DSQk+W0p9MXEWpOPtWmJ2jMEoWTRxhq67n034=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NEE9Dmmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NEE9Dmmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A84EC4CEE7;
	Wed, 30 Apr 2025 21:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746047096;
	bh=91OpLLJDdN2jvxpC1DiWvpLwbi2l7rgE6OjI3TfFY64=;
	h=Date:To:From:Subject:From;
	b=NEE9DmmollZFkuw/vgx9Bka/G8C68A3KoSJT3ioYe+u0lUBkP2Yp4fRdQxf4nJTXi
	 TNc1WuQ7lAxJFftq2YNHZuDXYTN//sjwxG3M/bcgQt3itunQ6L+pMBHHFJNMm/w/zA
	 ZW9T4qj3vM2D1Tto42d2qJuy2Sk71FruwTffR7zA=
Date: Wed, 30 Apr 2025 14:04:55 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-no-longer-used-swap-mapping-helper.patch added to mm-new branch
Message-Id: <20250430210456.2A84EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: remove no longer used swap mapping helper
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-no-longer-used-swap-mapping-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-no-longer-used-swap-mapping-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-memory-fix-mapcount-refcount-sanity-check-for-mthp-reuse.patch
mm-swap-fix-false-warning-for-large-allocation-with-thp_swap.patch
fuse-drop-usage-of-folio_index.patch
btrfs-drop-usage-of-folio_index.patch
f2fs-drop-usage-of-folio_index.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios.patch
mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch
mm-swap-remove-no-longer-used-swap-mapping-helper.patch

