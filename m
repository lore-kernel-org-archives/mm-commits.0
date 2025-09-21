Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395532B9BA
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 00:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758416340; cv=none; b=uO32+a/+scoAp94EqielnbaYRdGyrS8vV/jbM5nncKHuc9NynEo7WaRYRhScxkh2sHlysL092q+OCNoAYFkHZvSgBbWV6XYJiZ9NOsk2u9F3bP2nE8zjazHRiNSD9TIhgueOWYN8U0kGPL4jxSlB9/9aSDweNWFGiHqYe+2pSm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758416340; c=relaxed/simple;
	bh=UhPBSQo2LFMybS4lxBtujhkj0iwSxBlgSj8vZ/Pcrhs=;
	h=Date:To:From:Subject:Message-Id; b=NxHgNawQAkTnOS9HVty0zUskN0DZMJv1MKbtOzoIJJqAvXHBoV0zl2jHYiO12zqOpIQ4qlSLt81V90xMuDY+fm84DvF28gS4sD6/jyV1xu0nycJNClEdHAR4wDDC7gTGgKoHI5qWiCogNxDwn3WNl0ygUsL+5wb7SBzdeS/XQMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SGLboVvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SGLboVvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EDDC4CEEB;
	Sun, 21 Sep 2025 00:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758416339;
	bh=UhPBSQo2LFMybS4lxBtujhkj0iwSxBlgSj8vZ/Pcrhs=;
	h=Date:To:From:Subject:From;
	b=SGLboVvmzywt//oHe9XHGG26wTMevtLWV20UJ0HBMH2dRD40nLWQYKLlT7EOBvEwj
	 XnVR2QBw09wb1zYw3jjQxwPZvDx+rKJyl9Xil7kUfAovaixFSxR9GzGu0TTT/WJNu2
	 GKTbVWbtjFmlIW8IfbcmLEKFrxxSUY42k1K9wBZM=
Date: Sat, 20 Sep 2025 17:58:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yosryahmed@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,sj@kernel.org,shikemeng@huaweicloud.com,oliver.sang@intel.com,nphamcs@gmail.com,lorenzo.stoakes@oracle.com,kasong@tencent.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,chrisl@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-add-document-for-swap-table-fix.patch added to mm-unstable branch
Message-Id: <20250921005859.91EDDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-mm-add-document-for-swap-table-fix
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-add-document-for-swap-table-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-add-document-for-swap-table-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
docs-mm-add-document-for-swap-table-fix.patch

