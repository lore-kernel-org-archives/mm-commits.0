Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0BC8F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560079; cv=none; b=lwHKKf6PTvpQrE38Y1bSxwmi2opgUjH4eaLkJBnlTbCdWBBenSr1GnX/Xe7ZsMOZ95nt4QBJPP6TKJ/jBmoZGDn9QquLSKJ3UKOjC8hTq+fOlJZ7lDhoDTBW57vsULZWmopUgD+PbGiZ+vmOmRjzLNWHBdPczmMJ3W9BIjwJjPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560079; c=relaxed/simple;
	bh=W0K/lCGNIGayg5iciHa/25a4YRGwLzMdsh+mQc8iKM8=;
	h=Date:To:From:Subject:Message-Id; b=fT3SwSB161FOv9vulFpuiuk8xBncRiMBQhLwyQrsOtoXbJ2ZkV2N3Gzg/wndaaVMfvLQ6DKVW/f5SbixUb4KyFSvLA0xt/QBHoyzl6mDUWhqPlEP0F0evX6zC9Qnv4iH8TAtvkPbL1r/BulAiiF0tB5/p7/EXMtyBnMFOcopMO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zR0hV1Cg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zR0hV1Cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6A7C43394;
	Thu, 22 Feb 2024 00:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560079;
	bh=W0K/lCGNIGayg5iciHa/25a4YRGwLzMdsh+mQc8iKM8=;
	h=Date:To:From:Subject:From;
	b=zR0hV1CggYGxPQWUTgVBGjSNxHjQco7kiq28XpRa9fjkTTEe6TxRaihp/qKRF/h6d
	 ChNqIJxyDVOsHNJuwSLLKbQ5UzqUByrawlDpmpKTCe8mJg2P7GcTlft0sg7RIfCDU+
	 /xYy1dQ4A/ES53cSsR1NWq+HJWpKdm/53XAGfGh0=
Date: Wed, 21 Feb 2024 16:01:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch removed from -mm tree
Message-Id: <20240222000118.DC6A7C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use pfn_swap_entry_folio() in copy_nonpresent_pte()
has been removed from the -mm tree.  Its filename was
     mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use pfn_swap_entry_folio() in copy_nonpresent_pte()
Date: Thu, 11 Jan 2024 15:24:26 +0000

Call pfn_swap_entry_folio() as preparation for converting mm counter
functions to take a folio.

Link: https://lkml.kernel.org/r/20240111152429.3374566-8-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte
+++ a/mm/memory.c
@@ -806,9 +806,9 @@ copy_nonpresent_pte(struct mm_struct *ds
 		}
 		rss[MM_SWAPENTS]++;
 	} else if (is_migration_entry(entry)) {
-		page = pfn_swap_entry_to_page(entry);
+		folio = pfn_swap_entry_folio(entry);
 
-		rss[mm_counter(page)]++;
+		rss[mm_counter(&folio->page)]++;
 
 		if (!is_readable_migration_entry(entry) &&
 				is_cow_mapping(vm_flags)) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-compaction-early-termination-in-compact_nodes.patch

