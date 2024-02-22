Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DA7101E8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560074; cv=none; b=Uv/8n8mPMdX11djIpBDH54pl9XRtb/9Hvzl4ftqvNPRX67xPbjXx1KibIZDh21f/Zl2EzPhgTIYt7APWaCQVUpXrKyAhikyuh+8ztWFKoRSgKPAE2sun3eWyOniieUTO+akYZQM0qTqxBixosgi7gg6MMj+FBQ4OkwZtL9KIl4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560074; c=relaxed/simple;
	bh=VmMQCuVq5xlR5Dlv3rT5kEfkZDRW3d6UZW17wOO++lU=;
	h=Date:To:From:Subject:Message-Id; b=W+Ie1O1O0nwlmEw9/8VNu0COCfAzEd5iIpcqFqUthKt1oySD1Cbv3VE16xCARyoiCvJPodiQmy8arpsllKnPFgrdb0wJPLjWxgPG7s9o+B7F79Cs+Jq1sW/DkkKHASnTUPCUUn35DJUXlFoSeXVU/IKQNihH9qRLabQXHNv6WbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jzPvGAmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jzPvGAmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8C6C43394;
	Thu, 22 Feb 2024 00:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560074;
	bh=VmMQCuVq5xlR5Dlv3rT5kEfkZDRW3d6UZW17wOO++lU=;
	h=Date:To:From:Subject:From;
	b=jzPvGAmd5q329zKzeyKUCmirSR3bm+qk+DjooDirghXD3f1ApGp0/tkLhYt5z4dgM
	 tZA4E7OYQ/ZlqPl22ODVp5KBwWqjIe/bnpAOdFvi4lXhvPYHyfCGDlkQriAG3HxdAf
	 VabWWC1okXb2vSQ4dBJLzoLJhd1WEx/Vv0XGSxq4=
Date: Wed, 21 Feb 2024 16:01:13 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-use-pfn_swap_entry_folio-where-obvious.patch removed from -mm tree
Message-Id: <20240222000114.6A8C6C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: use pfn_swap_entry_folio where obvious
has been removed from the -mm tree.  Its filename was
     proc-use-pfn_swap_entry_folio-where-obvious.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc: use pfn_swap_entry_folio where obvious
Date: Thu, 11 Jan 2024 15:24:21 +0000

These callers only pass the result to PageAnon(), so we can save the extra
call to compound_head() by using pfn_swap_entry_folio().

Link: https://lkml.kernel.org/r/20240111152429.3374566-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c~proc-use-pfn_swap_entry_folio-where-obvious
+++ a/fs/proc/task_mmu.c
@@ -1807,7 +1807,7 @@ static unsigned long pagemap_page_catego
 		if (p->masks_of_interest & PAGE_IS_FILE) {
 			swp = pte_to_swp_entry(pte);
 			if (is_pfn_swap_entry(swp) &&
-			    !PageAnon(pfn_swap_entry_to_page(swp)))
+			    !folio_test_anon(pfn_swap_entry_folio(swp)))
 				categories |= PAGE_IS_FILE;
 		}
 		if (pte_swp_soft_dirty(pte))
@@ -1873,7 +1873,7 @@ static unsigned long pagemap_thp_categor
 		if (p->masks_of_interest & PAGE_IS_FILE) {
 			swp = pmd_to_swp_entry(pmd);
 			if (is_pfn_swap_entry(swp) &&
-			    !PageAnon(pfn_swap_entry_to_page(swp)))
+			    !folio_test_anon(pfn_swap_entry_folio(swp)))
 				categories |= PAGE_IS_FILE;
 		}
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

