Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF4A18027
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388579; cv=none; b=l1ZcoMjRLwzeBx8n+reZLIEZ5hK+S4uVUfAYKPNPbbfwvYyk5iToqAhYAsjWtq0AEjIKBRxlSUSTc9RrUSkVO99dxPLjwDR3L/f7AS5ZZZDICe8wiVo5yoIoIs2hwQ/91Ynlj6JupBANimx5I9zwIhPwiZndjTsWdv2oR5PkaNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388579; c=relaxed/simple;
	bh=d+OPDJGPWJxOt+utvLOcGQXpjwjqeWxdHPtD6EX2DK4=;
	h=Date:To:From:Subject:Message-Id; b=fwcurluo23Fp1EEyW0aGtRWT6iFkT+Krgs9t2mrxN1/3xC3ybjrGtycpc8suuQWzbDbFNAMuqRgdny2kNBojlfMVWEG6jq/5BIFWdcjtV4BOFXT7ULC8fU9Mnhhcx0I+7BcvU/nsycV+N4As8/VRetfVdkdCHYmwTy9ZwjkPNtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0GNqdi3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0GNqdi3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53276C2BC9E;
	Tue, 24 Mar 2026 21:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388579;
	bh=d+OPDJGPWJxOt+utvLOcGQXpjwjqeWxdHPtD6EX2DK4=;
	h=Date:To:From:Subject:From;
	b=0GNqdi3sa0oNIpGjO7/8gmOJ2Annar8iAU0856+hSZkYFfjENLMZq+NYi77ZI0imN
	 H9iIGLTCD/PVk5G9OOPxVmAN4o1h7D8aB1eB78GJ55XTy2zDszd/ckDSIEwQ1ijD7/
	 9K6/qxcqYB0lU/NE8Wap5Ji/G5ODZBBf4glSsqK8=
Date: Tue, 24 Mar 2026 14:42:58 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,chrisl@kernel.org,chengming.zhou@linux.dev,bhe@redhat.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-remove-swp_synchronous_io-swapcache-bypass-workaround.patch removed from -mm tree
Message-Id: <20260324214259.53276C2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass workaround
has been removed from the -mm tree.  Its filename was
     mm-zswap-remove-swp_synchronous_io-swapcache-bypass-workaround.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/zswap: remove SWP_SYNCHRONOUS_IO swapcache bypass workaround
Date: Mon, 02 Feb 2026 01:47:32 +0800

Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even for
SWP_SYNCHRONOUS_IO"), all swap-in operations go through the swap cache,
including those from SWP_SYNCHRONOUS_IO devices like zram.  Which means
the workaround for swap cache bypassing introduced by commit 25cd241408a2
("mm: zswap: fix data loss on SWP_SYNCHRONOUS_IO devices") is no longer
needed.  Remove it, but keep the comments that are still helpful.

Link: https://lkml.kernel.org/r/20260202-zswap-syncio-cleanup-v1-1-86bb24a64521@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Baoquan He <bhe@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-swp_synchronous_io-swapcache-bypass-workaround
+++ a/mm/zswap.c
@@ -1595,11 +1595,11 @@ int zswap_load(struct folio *folio)
 {
 	swp_entry_t swp = folio->swap;
 	pgoff_t offset = swp_offset(swp);
-	bool swapcache = folio_test_swapcache(folio);
 	struct xarray *tree = swap_zswap_tree(swp);
 	struct zswap_entry *entry;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
+	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
 
 	if (zswap_never_enabled())
 		return -ENOENT;
@@ -1630,22 +1630,15 @@ int zswap_load(struct folio *folio)
 		count_objcg_events(entry->objcg, ZSWPIN, 1);
 
 	/*
-	 * When reading into the swapcache, invalidate our entry. The
-	 * swapcache can be the authoritative owner of the page and
+	 * We are reading into the swapcache, invalidate zswap entry.
+	 * The swapcache is the authoritative owner of the page and
 	 * its mappings, and the pressure that results from having two
 	 * in-memory copies outweighs any benefits of caching the
 	 * compression work.
-	 *
-	 * (Most swapins go through the swapcache. The notable
-	 * exception is the singleton fault on SWP_SYNCHRONOUS_IO
-	 * files, which reads into a private page and may free it if
-	 * the fault fails. We remain the primary owner of the entry.)
 	 */
-	if (swapcache) {
-		folio_mark_dirty(folio);
-		xa_erase(tree, offset);
-		zswap_entry_free(entry);
-	}
+	folio_mark_dirty(folio);
+	xa_erase(tree, offset);
+	zswap_entry_free(entry);
 
 	folio_unlock(folio);
 	return 0;
_

Patches currently in -mm which might be from kasong@tencent.com are


