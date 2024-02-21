Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E891112D744
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708558885; cv=none; b=RydRYvkkIun0bePe1+7lOUS7URKbBTqrubrVNYMsCoZAIHraBh4FDLO8SjtqmWj8zwSg0JjPpseaYJYG1UhoqYQ6uiBBNy4kGsz8trwRrcR8kHttW1Zd0Hp5eIjVUlfvV4hMYKoPC8AvSXzoeX5ktXXtsyvuCnMWOC/1zIEfKf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708558885; c=relaxed/simple;
	bh=Cyn8eO3hYP5KENHJyWY2tIe4Acg4slj6Y2hCs4Tf/vQ=;
	h=Date:To:From:Subject:Message-Id; b=NXlqnwaEH8V3sVPOWcHd1Ib5UpSCU/MhS1AVpcTbzgzaiKCbNzM2+KLnTyXzVvl/b0m+GKx7Nz/3s5J63/fpiIhdMZmewJjfvl8igRbsOno2oe5y7bzgOhOKdZnA73EYy2fCQwu2Jlq4X/vf5Ym8FdrMD/vbT3CdHqud4qfRX7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jGTyOMH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jGTyOMH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5908CC43390;
	Wed, 21 Feb 2024 23:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708558884;
	bh=Cyn8eO3hYP5KENHJyWY2tIe4Acg4slj6Y2hCs4Tf/vQ=;
	h=Date:To:From:Subject:From;
	b=jGTyOMH7sf9yLSDRwk/3up/dAcdk4qMK+y41ezKY/awPiub6N+G6flI/pE/EGPqLL
	 2XoBWrU1DUUB/Z2KGzU6zuJgUvIGeveqn4Sm87QT8kZLTUcA1Fy1Zv1/y6LF50Uljj
	 HSqBe4o1g7LltUvRvHoB7doC3tkPQx2pbq86mgnY=
Date: Wed, 21 Feb 2024 15:41:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lkp@intel.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-convert-to-should_zap_page-to-should_zap_folio-fix.patch removed from -mm tree
Message-Id: <20240221234124.5908CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-convert-to-should_zap_page-to-should_zap_folio-fix
has been removed from the -mm tree.  Its filename was
     mm-convert-to-should_zap_page-to-should_zap_folio-fix.patch

This patch was dropped because it was folded into mm-convert-to-should_zap_page-to-should_zap_folio.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-convert-to-should_zap_page-to-should_zap_folio-fix
Date: Fri, 12 Jan 2024 18:14:32 +0800

fix used-uninitialized warning

Link: https://lkml.kernel.org/r/962a7993-fce9-4de8-85cd-25e290f25736@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401121250.A221BL2D-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-convert-to-should_zap_page-to-should_zap_folio-fix
+++ a/mm/memory.c
@@ -1435,7 +1435,7 @@ static unsigned long zap_pte_range(struc
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = ptep_get(pte);
-		struct folio *folio;
+		struct folio *folio = NULL;
 		struct page *page;
 
 		if (pte_none(ptent))
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-use-nth_page-in-clear-copy_subpage.patch
s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch
mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch
mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch
mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch
mm-convert-to-should_zap_page-to-should_zap_folio.patch
mm-convert-mm_counter-to-take-a-folio.patch
mm-convert-mm_counter_file-to-take-a-folio.patch
mm-memory-move-mem_cgroup_charge-into-alloc_anon_folio.patch
mm-compaction-refactor-compact_node.patch
mm-compaction-early-termination-in-compact_nodes.patch

