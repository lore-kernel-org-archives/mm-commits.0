Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C3CA59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188180; cv=none; b=m3E8wBK2PgiFlQgc7FNFGF/IcDhpwJ9WlZP2d9f88YT3XUhfqdaNG22N+NO5e2PwkbbcJx1vR5dQ+RRyp4cAJvpInfNstpqXBGEhRZX3ki1EXPJ4+mV2goadOtsEgDaGVbETnefrYmalSDzucqJ51Lid7H2tn4QTh39i9p8WNl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188180; c=relaxed/simple;
	bh=rMOa4j9yiHqlpMMsouRmoCjwR23p5xtmD1GVD8EHq3s=;
	h=Date:To:From:Subject:Message-Id; b=OgpCxpe6nql7SmMTMeEmlrJXzIpfnX1U7qXmVmfaUf4jb80klpzZmyJ4lIEkXD4jRplK18vUXbXOsG/3WdCs87oDz91GblBayH6/kNXdo3fDXVraQ0+BMvV8eK2W7v7qhI0Fwn/ygazD9ZoFFI3ZHMT6e6L1XrdTSL/7u2a9meU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YhRQDg6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YhRQDg6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE87C4CEEC;
	Mon, 17 Mar 2025 05:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188180;
	bh=rMOa4j9yiHqlpMMsouRmoCjwR23p5xtmD1GVD8EHq3s=;
	h=Date:To:From:Subject:From;
	b=YhRQDg6MCcrzIbpeKB/d5im2gCghl3CdeGagZ4X+ttK28zaNUvh04rmjyBaLHy+MW
	 nMK+S5eO3H7NenANZv31dMVvVXAvouCElWr1q/pPehsbZD2YOe0ZAp4hmGaYv2/2wo
	 1Wr0og8X0FAmRuxMZgRToOiB9UdR8ctxD47dnO5U=
Date: Sun, 16 Mar 2025 22:09:40 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch removed from -mm tree
Message-Id: <20250317050940.ACE87C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: allow split shmem large folio to any lower order
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: allow split shmem large folio to any lower order
Date: Wed, 22 Jan 2025 11:19:27 -0500

Commit 4d684b5f92ba ("mm: shmem: add large folio support for tmpfs") has
added large folio support to shmem.  Remove the restriction in
split_huge_page*().

Link: https://lkml.kernel.org/r/20250122161928.1240637-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order
+++ a/mm/huge_memory.c
@@ -3299,7 +3299,7 @@ static void __split_huge_page(struct pag
 		/* Some pages can be beyond EOF: drop them from page cache */
 		if (tail->index >= end) {
 			if (shmem_mapping(folio->mapping))
-				nr_dropped++;
+				nr_dropped += new_nr;
 			else if (folio_test_clear_dirty(tail))
 				folio_account_cleaned(tail,
 					inode_to_wb(folio->mapping->host));
@@ -3465,12 +3465,6 @@ int split_huge_page_to_list_to_order(str
 			return -EINVAL;
 		}
 	} else if (new_order) {
-		/* Split shmem folio to non-zero order not supported */
-		if (shmem_mapping(folio->mapping)) {
-			VM_WARN_ONCE(1,
-				"Cannot split shmem folio to non-0 order");
-			return -EINVAL;
-		}
 		/*
 		 * No split if the file system does not support large folio.
 		 * Note that we might still have THPs in such mappings due to
_

Patches currently in -mm which might be from ziy@nvidia.com are

xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split-fix-2.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-folio_split-in-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

