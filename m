Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6CF22089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957110; cv=none; b=jWoQsCnR0myc4OhDt87e9C2w7YPwlMLdnzlzvtlzT9LwytvyRgxHC7y+sTDp4t6l3wP/oKfdaBPf4Vb38HX3Gog16Abh02IQFnIAJrTWyoLggww630Xsc6xJ8pf2/DJ3df6TzGCzzgCoeRn8Fdva0052fNKYB8E2c/EnAiXsnM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957110; c=relaxed/simple;
	bh=C70+i3KlLn39CY1U5ID79MVk+x5J8NzcNge2hObNmM8=;
	h=Date:To:From:Subject:Message-Id; b=EVrh3xiHwemd/XeNv8nTwohZNHYjDyuV3s6fRMbfgfyKz+c5frRBT8t7LLpc7F8RCHeDqO6oStD0RoDsxrgJWXbt56U5qOTwftn3XW4Pcm7UGFEd0VA8V+NmtAk9yyARP91Onakefa8IQXVFP4gQYdm8YMqlQUv7G+aSbZQiwmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vq3sOzDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vq3sOzDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE44C113CC;
	Mon,  6 May 2024 00:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957110;
	bh=C70+i3KlLn39CY1U5ID79MVk+x5J8NzcNge2hObNmM8=;
	h=Date:To:From:Subject:From;
	b=vq3sOzDLdQid19+nxY59q2FXgcNkDk4UDFalfmutYQrPwvE6hllqmrc5PguUJwLWk
	 58oLGEW4+oWwasUYKeo9FndAPlFv34+sZnBv+pUmp8r/asR3zfZouVYMD2tDjl/nu0
	 aae5Pm0sUahsIrGHQF7d2PbSwMinUWgf59aq5abk=
Date: Sun, 05 May 2024 17:58:29 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,r.thapliyal@samsung.com,osalvador@suse.de,maninder1.s@samsung.com,lstoakes@gmail.com,hch@infradead.org,hariom1.p@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-dump-page-owner-info-if-page-is-already-mapped.patch removed from -mm tree
Message-Id: <20240506005829.EFE44C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: dump page owner info if page is already mapped
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-dump-page-owner-info-if-page-is-already-mapped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hariom Panthi <hariom1.p@samsung.com>
Subject: mm: vmalloc: dump page owner info if page is already mapped
Date: Wed, 24 Apr 2024 16:48:38 +0530

In vmap_pte_range, BUG_ON is called when page is already mapped,
It doesn't give enough information to debug further.
Dumping page owner information alongwith BUG_ON will be more useful
in case of multiple page mapping.

Example:
[   14.552875] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10b923
[   14.553440] flags: 0xbffff0000000000(node=0|zone=2|lastcpupid=0x3ffff)
[   14.554001] page_type: 0xffffffff()
[   14.554783] raw: 0bffff0000000000 0000000000000000 dead000000000122 0000000000000000
[   14.555230] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
[   14.555768] page dumped because: remapping already mapped page
[   14.556172] page_owner tracks the page as allocated
[   14.556482] page last allocated via order 0, migratetype Unmovable, gfp_mask 0xcc0(GFP_KERNEL), pid 80, tgid 80 (insmod), ts 14552004992, free_ts 0
[   14.557286]  prep_new_page+0xa8/0x10c
[   14.558052]  get_page_from_freelist+0x7f8/0x1248
[   14.558298]  __alloc_pages+0x164/0x2b4
[   14.558514]  alloc_pages_mpol+0x88/0x230
[   14.558904]  alloc_pages+0x4c/0x7c
[   14.559157]  load_module+0x74/0x1af4
[   14.559361]  __do_sys_init_module+0x190/0x1fc
[   14.559615]  __arm64_sys_init_module+0x1c/0x28
[   14.559883]  invoke_syscall+0x44/0x108
[   14.560109]  el0_svc_common.constprop.0+0x40/0xe0
[   14.560371]  do_el0_svc_compat+0x1c/0x34
[   14.560600]  el0_svc_compat+0x2c/0x80
[   14.560820]  el0t_32_sync_handler+0x90/0x140
[   14.561040]  el0t_32_sync+0x194/0x198
[   14.561329] page_owner free stack trace missing
[   14.562049] ------------[ cut here ]------------
[   14.562314] kernel BUG at mm/vmalloc.c:113!

Link: https://lkml.kernel.org/r/20240424111838.3782931-2-hariom1.p@samsung.com
Signed-off-by: Hariom Panthi <hariom1.p@samsung.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rohit Thapliyal <r.thapliyal@samsung.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-dump-page-owner-info-if-page-is-already-mapped
+++ a/mm/vmalloc.c
@@ -42,6 +42,7 @@
 #include <linux/sched/mm.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
+#include <linux/page_owner.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmalloc.h>
@@ -96,6 +97,7 @@ static int vmap_pte_range(pmd_t *pmd, un
 {
 	pte_t *pte;
 	u64 pfn;
+	struct page *page;
 	unsigned long size = PAGE_SIZE;
 
 	pfn = phys_addr >> PAGE_SHIFT;
@@ -103,7 +105,13 @@ static int vmap_pte_range(pmd_t *pmd, un
 	if (!pte)
 		return -ENOMEM;
 	do {
-		BUG_ON(!pte_none(ptep_get(pte)));
+		if (!pte_none(ptep_get(pte))) {
+			if (pfn_valid(pfn)) {
+				page = pfn_to_page(pfn);
+				dump_page(page, "remapping already mapped page");
+			}
+			BUG();
+		}
 
 #ifdef CONFIG_HUGETLB_PAGE
 		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
_

Patches currently in -mm which might be from hariom1.p@samsung.com are


