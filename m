Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B19F2857FA
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758485320; cv=none; b=EOZuANm7f0JNkxVwmVoqeiuRpBoKFnB7mbrgxuPnPMRTPKO+MF+YM0VjOSkkLCAe/cwbJ0SPrjJ7EAVqL8ivp3PvoK6rYPVkwfZIT2xQO2ni3iZ2eWto18HDu9K31PWFvU2IUa9mWyKwQ51tjBtsA4Jf/xhgtt+WPBN3O8kZQaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758485320; c=relaxed/simple;
	bh=H+imLxY0rYFmiB5zk1EyIwAVDMEAbKwu2Mf0wQEdn7M=;
	h=Date:To:From:Subject:Message-Id; b=KY7VKFJ0AV5uZeBmXL1Mchu3mv9kCUBbivzOHpr01IuVWa+NcWV8slXx0u2Uu8fg8arIa3uAA53gWB1WD0Es9G/b8p3DVvxoXZ5xGPCT6jkn+a8aahyhUBvVQQlPE02YoaxYjwzDXdN0BDxRX0oUvoTn23i4CNY7DTQeMiW7aV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vgeVR5eO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vgeVR5eO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5366BC4CEE7;
	Sun, 21 Sep 2025 20:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758485320;
	bh=H+imLxY0rYFmiB5zk1EyIwAVDMEAbKwu2Mf0wQEdn7M=;
	h=Date:To:From:Subject:From;
	b=vgeVR5eOgOaDp7ECYNwXkBZu8KC07oP4r/GSgx6JbtNX7VKm33YnQS2z09Pmlqybl
	 rigOx/fmIpmGv9GKD9yxwfek7p2dDaeJ9t5O0BcSsjEkJAGU9cfVOPNC0MqE5BSXBP
	 SpZAjNTR/92QKcJEXKdV0oSTJQaL/ycnpPKGFsM4=
Date: Sun, 21 Sep 2025 13:08:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,sj@kernel.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-mm-add-document-for-swap-table-fix.patch removed from -mm tree
Message-Id: <20250921200840.5366BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs-mm-add-document-for-swap-table-fix
has been removed from the -mm tree.  Its filename was
     docs-mm-add-document-for-swap-table-fix.patch

This patch was dropped because it was folded into docs-mm-add-document-for-swap-table.patch

------------------------------------------------------
From: Chris Li <chrisl@kernel.org>
Subject: docs-mm-add-document-for-swap-table-fix
Date: Sat, 20 Sep 2025 17:11:03 -0700

- Move the swap table document to the mm main section. [SeongJae Park]

- Rewrite the swap table size sentence for easier to understand. [ Barry]

Link: https://lkml.kernel.org/r/CACePvbXjaUyzB_9RSSSgR6BNvz+L9anvn0vcNf_J0jD7-4Yy6Q@mail.gmail.com
Signed-off-by: Chris Li <chrisl@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/index.rst      |    2 +-
 Documentation/mm/swap-table.rst |    9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/Documentation/mm/index.rst~docs-mm-add-document-for-swap-table-fix
+++ a/Documentation/mm/index.rst
@@ -20,6 +20,7 @@ see the :doc:`admin guide <../admin-guid
    highmem
    page_reclaim
    swap
+   swap-table
    page_cache
    shmfs
    oom
@@ -57,7 +58,6 @@ documentation, or deleted if it has serv
    page_table_check
    remap_file_pages
    split_page_table_lock
-   swap-table
    transhuge
    unevictable-lru
    vmalloced-kernel-stacks
--- a/Documentation/mm/swap-table.rst~docs-mm-add-document-for-swap-table-fix
+++ a/Documentation/mm/swap-table.rst
@@ -50,12 +50,9 @@ Swap cache lookup within the cluster can
 
 We give such a per-cluster swap cache value array a name: the swap table.
 
-Each swap cluster contains 512 entries, so a swap table stores one cluster
-worth of swap cache values, which is exactly one page. This is not
-coincidental because the cluster size is determined by the huge page size.
-The swap table is holding an array of pointers. The pointer has the same
-size as the PTE. The size of the swap table should match to the second
-last level of the page table page, exactly one page.
+A swap table is an array of pointers. Each pointer is the same size as a
+PTE. The size of a swap table for one swap cluster typically matches a PTE
+page table, which is one page on modern 64-bit systems.
 
 With swap table, swap cache lookup can achieve great locality, simpler,
 and faster.
_

Patches currently in -mm which might be from chrisl@kernel.org are

docs-mm-add-document-for-swap-table.patch

