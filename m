Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493EC2FD1D5
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025816; cv=none; b=npncRR9bOs9ShGVr6llWQTDSv3xWagrRP21m+mX6Udf6xuzATjVsUeAB/ra+8nRERpwThnRw0wx60z4ZeylRjsG9lWQoOWn1aE0q36mhvrIwosXxOAnZc39Hwe85sg0XzIqEal5pRi59R4Dd2QgOcvBhI/2i10AWWH1Zp2gwH+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025816; c=relaxed/simple;
	bh=+5iFcN3UR3KyNpPrTMFDD3P/6duB9vcmbMqh6T62qbQ=;
	h=Date:To:From:Subject:Message-Id; b=hJsbKFcE1y6iI/QFwj6HOzcLwfF0yp5pNLuzq+VUqPeOL0BU0lLVzxkSx7dZodH47ThdBKL45diSTZZOhnNzQIAaUn2vf7YaVZ5mdFS2mwrH48LbXnyxJSs6r2xus9veB7HP3Nf5JJAOE1LZmDP60hyXu5uM7iqJZpH8fJ6pTeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L3xf82Us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L3xf82Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C045BC4CEF1;
	Mon, 24 Nov 2025 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025815;
	bh=+5iFcN3UR3KyNpPrTMFDD3P/6duB9vcmbMqh6T62qbQ=;
	h=Date:To:From:Subject:From;
	b=L3xf82UslKWta9r9evpWagwZ3ym9fBy0IOEpt71IZ0/3AYlWb/aT9ekYCMhTomry0
	 8P0kXhmnPRAL8GKHka1ARf2V0aHtoNjXXf5rxSeqXLhVY5joFybJLUkoai3UcSFX1x
	 xmPZUnCqXvwZY4yq1UrGk+L1QBK6nU6Z8aN5wSJg=
Date: Mon, 24 Nov 2025 15:10:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,weixugc@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,svens@linux.ibm.com,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,nphamcs@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,matthew.brost@intel.com,linmiaohe@huawei.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kasong@tencent.com,joshua.hahnjy@gmail.com,jgg@ziepe.ca,jannh@google.com,jack@suse.cz,imbrenda@linux.ibm.com,hughd@google.com,hca@linux.ibm.com,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,apopple@nvidia.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch removed from -mm tree
Message-Id: <20251124231015.C045BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: eliminate is_swap_pte() when softleaf_from_pte() suffices
has been removed from the -mm tree.  Its filename was
     mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: eliminate is_swap_pte() when softleaf_from_pte() suffices
Date: Mon, 10 Nov 2025 22:21:22 +0000

In cases where we can simply utilise the fact that softleaf_from_pte()
treats present entries as if they were none entries and thus eliminate
spurious uses of is_swap_pte(), do so.

No functional change intended.

Link: https://lkml.kernel.org/r/92ebab9567978155116804c67babc3c64636c403.1762812360.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    7 +++----
 mm/madvise.c    |    8 +++-----
 mm/swap_state.c |   11 +++++------
 mm/swapfile.c   |    9 ++++-----
 4 files changed, 15 insertions(+), 20 deletions(-)

--- a/mm/internal.h~mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices
+++ a/mm/internal.h
@@ -15,7 +15,7 @@
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
 #include <linux/swap.h>
-#include <linux/swapops.h>
+#include <linux/leafops.h>
 #include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
 
@@ -380,13 +380,12 @@ static inline int swap_pte_batch(pte_t *
 {
 	pte_t expected_pte = pte_next_swp_offset(pte);
 	const pte_t *end_ptep = start_ptep + max_nr;
-	swp_entry_t entry = pte_to_swp_entry(pte);
+	const softleaf_t entry = softleaf_from_pte(pte);
 	pte_t *ptep = start_ptep + 1;
 	unsigned short cgroup_id;
 
 	VM_WARN_ON(max_nr < 1);
-	VM_WARN_ON(!is_swap_pte(pte));
-	VM_WARN_ON(non_swap_entry(entry));
+	VM_WARN_ON(!softleaf_is_swap(entry));
 
 	cgroup_id = lookup_swap_cgroup_id(entry);
 	while (ptep < end_ptep) {
--- a/mm/madvise.c~mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices
+++ a/mm/madvise.c
@@ -195,7 +195,7 @@ static int swapin_walk_pmd_entry(pmd_t *
 
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		pte_t pte;
-		swp_entry_t entry;
+		softleaf_t entry;
 		struct folio *folio;
 
 		if (!ptep++) {
@@ -205,10 +205,8 @@ static int swapin_walk_pmd_entry(pmd_t *
 		}
 
 		pte = ptep_get(ptep);
-		if (!is_swap_pte(pte))
-			continue;
-		entry = pte_to_swp_entry(pte);
-		if (unlikely(non_swap_entry(entry)))
+		entry = softleaf_from_pte(pte);
+		if (unlikely(!softleaf_is_swap(entry)))
 			continue;
 
 		pte_unmap_unlock(ptep, ptl);
--- a/mm/swapfile.c~mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices
+++ a/mm/swapfile.c
@@ -44,7 +44,7 @@
 #include <linux/plist.h>
 
 #include <asm/tlbflush.h>
-#include <linux/swapops.h>
+#include <linux/leafops.h>
 #include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
@@ -2257,7 +2257,7 @@ static int unuse_pte_range(struct vm_are
 		struct folio *folio;
 		unsigned long offset;
 		unsigned char swp_count;
-		swp_entry_t entry;
+		softleaf_t entry;
 		int ret;
 		pte_t ptent;
 
@@ -2268,11 +2268,10 @@ static int unuse_pte_range(struct vm_are
 		}
 
 		ptent = ptep_get_lockless(pte);
+		entry = softleaf_from_pte(ptent);
 
-		if (!is_swap_pte(ptent))
+		if (!softleaf_is_swap(entry))
 			continue;
-
-		entry = pte_to_swp_entry(ptent);
 		if (swp_type(entry) != type)
 			continue;
 
--- a/mm/swap_state.c~mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices
+++ a/mm/swap_state.c
@@ -12,7 +12,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
-#include <linux/swapops.h>
+#include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
@@ -736,7 +736,6 @@ static struct folio *swap_vma_readahead(
 	pte_t *pte = NULL, pentry;
 	int win;
 	unsigned long start, end, addr;
-	swp_entry_t entry;
 	pgoff_t ilx;
 	bool page_allocated;
 
@@ -749,6 +748,7 @@ static struct folio *swap_vma_readahead(
 	blk_start_plug(&plug);
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
 		struct swap_info_struct *si = NULL;
+		softleaf_t entry;
 
 		if (!pte++) {
 			pte = pte_offset_map(vmf->pmd, addr);
@@ -756,10 +756,9 @@ static struct folio *swap_vma_readahead(
 				break;
 		}
 		pentry = ptep_get_lockless(pte);
-		if (!is_swap_pte(pentry))
-			continue;
-		entry = pte_to_swp_entry(pentry);
-		if (unlikely(non_swap_entry(entry)))
+		entry = softleaf_from_pte(pentry);
+
+		if (!softleaf_is_swap(entry))
 			continue;
 		pte_unmap(pte);
 		pte = NULL;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


