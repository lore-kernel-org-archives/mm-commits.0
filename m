Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B245F1AF0CB
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860860; cv=none; b=l4vEczemF7FdNC59PQP+g/oT7aC++w2Jm9rIEAl/gsbJaUYUn9rmbVrOxOV6oLi9Z52u7ka+ykM842ie8qFAU529FjUXUK7dsg2D1Wy7gz/e99EjNJjW30laRBTPg8wDeQdC8acv9kHxB+6u4qDtAaCGbPyS7ppukVL5POtbCA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860860; c=relaxed/simple;
	bh=Fn5I07QsAWqz6j6xxLgbqswff/PNTb9auCscPdV+JkU=;
	h=Date:To:From:Subject:Message-Id; b=glmR1K9GynIlNTDkLiAFubsN/KwVKXXpTovJKizhBz3A8Niwo0Y3EL0kMSh5zgw/JWz2xkoBk5rVcQfiLf/6qUV4lJY/2waI4xQR8YkZU3sIDNp+JtmURRIe6kb6ADyyOxpl5va3IziBCcqp/rSNg4ImtdiLa3lfvykfNN9a1u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uNiWos3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uNiWos3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D86C4CEE2;
	Tue, 18 Feb 2025 06:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860860;
	bh=Fn5I07QsAWqz6j6xxLgbqswff/PNTb9auCscPdV+JkU=;
	h=Date:To:From:Subject:From;
	b=uNiWos3/FDQopZlzfBYI897qr9Qrka51AzBaGF9V6ACTLaajZK15JVtE5FrUpP/NQ
	 Xvij6Rx11mbN2OTuo6w4ft5dNJ8WUGSg3hizlcphmQlIC6l46WY9tmf/GDgtF3iE6o
	 czzksbpKizR+GecwqghvkNbyJ7r/KKZvm4xEc9Ug=
Date: Mon, 17 Feb 2025 22:40:59 -0800
To: mm-commits@vger.kernel.org,yaozhenguo1@gmail.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,fvdl@google.com,david@redhat.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-avoid-fallback-for-specific-node-allocation-of-1g-pages.patch removed from -mm tree
Message-Id: <20250218064100.31D86C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: avoid fallback for specific node allocation of 1G pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-fallback-for-specific-node-allocation-of-1g-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: hugetlb: avoid fallback for specific node allocation of 1G pages
Date: Mon, 10 Feb 2025 22:48:56 -0500

When using the HugeTLB kernel command-line to allocate 1G pages from a
specific node, such as:

   default_hugepagesz=1G hugepages=1:1

If node 1 happens to not have enough memory for the requested number of 1G
pages, the allocation falls back to other nodes.  A quick way to reproduce
this is by creating a KVM guest with a memory-less node and trying to
allocate 1 1G page from it.  Instead of failing, the allocation will
fallback to other nodes.

This defeats the purpose of node specific allocation.  Also, specific node
allocation for 2M pages don't have this behavior: the allocation will just
fail for the pages it can't satisfy.

This issue happens because HugeTLB calls memblock_alloc_try_nid_raw() for
1G boot-time allocation as this function falls back to other nodes if the
allocation can't be satisfied.  Use memblock_alloc_exact_nid_raw()
instead, which ensures that the allocation will only be satisfied from the
specified node.

Link: https://lkml.kernel.org/r/20250211034856.629371-1-luizcap@redhat.com
Fixes: b5389086ad7b ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Zhenguo Yao <yaozhenguo1@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-fallback-for-specific-node-allocation-of-1g-pages
+++ a/mm/hugetlb.c
@@ -3145,7 +3145,7 @@ int __alloc_bootmem_huge_page(struct hst
 
 	/* do node specific alloc */
 	if (nid != NUMA_NO_NODE) {
-		m = memblock_alloc_try_nid_raw(huge_page_size(h), huge_page_size(h),
+		m = memblock_alloc_exact_nid_raw(huge_page_size(h), huge_page_size(h),
 				0, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
 		if (!m)
 			return 0;
_

Patches currently in -mm which might be from luizcap@redhat.com are


