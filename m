Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F8C1CAA66
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 04:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747023417; cv=none; b=EfBDF9uFz8m9WjcQ85ddnvRG1CTax0sQNRzj4ej/a/vfMq9eRXinRoeFtfQA9xx+6U5/m0E9XwaOdyFPFlyPTqRn6rGEcHgA5g59FcLQ9se14eH4UX41hX6VzSjpKk54doUSnoKSfXVjV1Ocd6WxIZsFwy7I34WhUxQ3NFuiKzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747023417; c=relaxed/simple;
	bh=qM4iffThBt4wlooP6oIyopi5sGhyCANukHzWgWxt8WA=;
	h=Date:To:From:Subject:Message-Id; b=epr/712gGRahb6fvOQA1QubMTjP6ytiw4/qR72TgwjfgOmYn5vTpOwfqzwdUqptOz7GaWYgIgD4zOAECguVAuz0ZScdWOv3RMXX/3cVKWfBQTgKaAb5u1UH2LEJFlCbElXiBdN+UDKNbH96xcFax/WB1rVUOUdgJsD4K2g5Nawk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JsGtWCX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JsGtWCX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F89FC4CEE7;
	Mon, 12 May 2025 04:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747023416;
	bh=qM4iffThBt4wlooP6oIyopi5sGhyCANukHzWgWxt8WA=;
	h=Date:To:From:Subject:From;
	b=JsGtWCX6y6NlBYHPQihrzl7JVb/0c0lNQksC+EU9ec3fHH5zU/wn7jqwP69CQg9sr
	 a/z877SWh5orwoWdrrYyQzkH9uwcRTo/OHE/v5TYbArQWg1qccKC3LFdluZGgwRYeR
	 sO/46fxgleexu7/HV8hGtgoRE7aKPCsVsmQK8tRg=
Date: Sun, 11 May 2025 21:16:55 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@linux.alibaba.com,wqu@suse.com,willy@infradead.org,nphamcs@gmail.com,miklos@szeredi.hu,josef@toxicpanda.com,joannelkoong@gmail.com,jaegeuk@kernel.org,hughd@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@redhat.com,clm@fb.com,chrisl@kernel.org,chao@kernel.org,brauner@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] btrfs-drop-usage-of-folio_index.patch removed from -mm tree
Message-Id: <20250512041656.1F89FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: btrfs: drop usage of folio_index
has been removed from the -mm tree.  Its filename was
     btrfs-drop-usage-of-folio_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: btrfs: drop usage of folio_index
Date: Thu, 1 May 2025 02:10:48 +0800

folio_index is only needed for mixed usage of page cache and swap cache,
for pure page cache usage, the caller can just use folio->index instead.

It can't be a swap cache folio here.  Swap mapping may only call into fs
through `swap_rw` but btrfs does not use that method for swap.

Link: https://lkml.kernel.org/r/20250430181052.55698-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/extent_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c~btrfs-drop-usage-of-folio_index
+++ a/fs/btrfs/extent_io.c
@@ -3508,7 +3508,7 @@ static void btree_clear_folio_dirty_tag(
 	ASSERT(folio_test_locked(folio));
 	xa_lock_irq(&folio->mapping->i_pages);
 	if (!folio_test_dirty(folio))
-		__xa_clear_mark(&folio->mapping->i_pages, folio_index(folio),
+		__xa_clear_mark(&folio->mapping->i_pages, folio->index,
 				PAGECACHE_TAG_DIRTY);
 	xa_unlock_irq(&folio->mapping->i_pages);
 }
_

Patches currently in -mm which might be from kasong@tencent.com are

fuse-drop-usage-of-folio_index.patch
f2fs-drop-usage-of-folio_index.patch
filemap-do-not-use-folio_contains-for-swap-cache-folios.patch
mm-move-folio_index-to-mm-swaph-and-remove-no-longer-needed-helper.patch
mm-swap-remove-no-longer-used-swap-mapping-helper.patch

