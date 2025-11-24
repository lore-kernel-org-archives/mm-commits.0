Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C26335092
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025817; cv=none; b=YByB3KtMwTS2x9d2hD1Mk92Nb2uy0rUJmo5JIqqI4XDBUnx2vq9dChINlJF1UFPtCHqwmxO/JVIGZMLyqZ2ygN8QJ3Fwdm3DZ0LG3InHdpsgRxWujlbCB4GYuvEhmlRzRaDLIUsCOcPC9jB4+lilaPfck7G7jdQEBbHfiRdse1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025817; c=relaxed/simple;
	bh=7BGV11H2AznfkGkqSQAmth+ZVS8715amIDwffofYxL4=;
	h=Date:To:From:Subject:Message-Id; b=YLXtzIaXNboNUik9kO3yx4RqvtJnUEshuN7M5Thx1AhU3fJoLG5JFSTKqduJIoxsMSm/BJHQszcGgH+zm6qisCavVcSGV1Dj5dWOBRO3PZgSFcNpIsxiorqAn+tSTUhgm6yPeRsOlXhuSJt97fxLPeGwwXIEdH0lhSuIOL5VQ6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hzBYsLsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hzBYsLsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E3EC4CEF1;
	Mon, 24 Nov 2025 23:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025817;
	bh=7BGV11H2AznfkGkqSQAmth+ZVS8715amIDwffofYxL4=;
	h=Date:To:From:Subject:From;
	b=hzBYsLsKQkS46xe5UpcgMZvi7yZS2Yix8v5r6DazPauw25uziRoynUpQE5EwScwdV
	 aYs0QNRdgd7WddP+mmWUATJGwCdKT/JdEpOOwrc72jg9VGCv/Ifqyqsk/3R0Oae8dx
	 oOSmMPHrF42UwOgJhTsvLB1J3nu5/y3wK9wKHqyA=
Date: Mon, 24 Nov 2025 15:10:16 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,ying.huang@linux.alibaba.com,xu.xin16@zte.com.cn,willy@infradead.org,weixugc@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,svens@linux.ibm.com,surenb@google.com,sj@kernel.org,shikemeng@huaweicloud.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,pasha.tatashin@soleen.com,osalvador@suse.de,nphamcs@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,mhocko@suse.com,matthew.brost@intel.com,linmiaohe@huawei.com,liam.howlett@oracle.com,leon@kernel.org,lance.yang@linux.dev,kasong@tencent.com,joshua.hahnjy@gmail.com,jgg@ziepe.ca,jannh@google.com,jack@suse.cz,imbrenda@linux.ibm.com,hughd@google.com,hca@linux.ibm.com,gourry@gourry.net,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,byungchul@sk.com,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,apopple@nvidia.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch removed from -mm tree
Message-Id: <20251124231017.67E3EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use leaf entries in debug pgtable + remove is_swap_pte()
has been removed from the -mm tree.  Its filename was
     mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: use leaf entries in debug pgtable + remove is_swap_pte()
Date: Mon, 10 Nov 2025 22:21:23 +0000

Remove invocations of is_swap_pte() in mm/debug_vm_pgtable.c and use
softleaf_from_pte() and softleaf_is_swap() as necessary to replace this
usage.

We update the test code to use a 'true' swap entry throughout so we are
guaranteed this is not a non-swap entry, so all asserts continue to
operate correctly.

With this change in place, we no longer use is_swap_pte() anywhere, so
remove it.

Link: https://lkml.kernel.org/r/222f352e7a99191b4bdfa77e835f2fc0dd83fa72.1762812360.git.lorenzo.stoakes@oracle.com
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

 include/linux/swapops.h |    6 -----
 mm/debug_vm_pgtable.c   |   39 +++++++++++++++++++++++---------------
 2 files changed, 24 insertions(+), 21 deletions(-)

--- a/include/linux/swapops.h~mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte
+++ a/include/linux/swapops.h
@@ -120,12 +120,6 @@ static inline unsigned long swp_offset_p
 	return swp_offset(entry) & SWP_PFN_MASK;
 }
 
-/* check whether a pte points to a swap entry */
-static inline int is_swap_pte(pte_t pte)
-{
-	return !pte_none(pte) && !pte_present(pte);
-}
-
 /*
  * Convert the arch-dependent pte representation of a swp_entry_t into an
  * arch-independent swp_entry_t.
--- a/mm/debug_vm_pgtable.c~mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte
+++ a/mm/debug_vm_pgtable.c
@@ -25,7 +25,7 @@
 #include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/swap.h>
-#include <linux/swapops.h>
+#include <linux/leafops.h>
 #include <linux/start_kernel.h>
 #include <linux/sched/mm.h>
 #include <linux/io.h>
@@ -714,14 +714,16 @@ static void __init pte_soft_dirty_tests(
 static void __init pte_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte;
+	softleaf_t entry;
 
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
 		return;
 
 	pr_debug("Validating PTE swap soft dirty\n");
 	pte = swp_entry_to_pte(args->swp_entry);
-	WARN_ON(!is_swap_pte(pte));
+	entry = softleaf_from_pte(pte);
 
+	WARN_ON(!softleaf_is_swap(entry));
 	WARN_ON(!pte_swp_soft_dirty(pte_swp_mksoft_dirty(pte)));
 	WARN_ON(pte_swp_soft_dirty(pte_swp_clear_soft_dirty(pte)));
 }
@@ -768,40 +770,47 @@ static void __init pmd_swap_soft_dirty_t
 
 static void __init pte_swap_exclusive_tests(struct pgtable_debug_args *args)
 {
-	swp_entry_t entry, entry2;
+	swp_entry_t entry;
+	softleaf_t softleaf;
 	pte_t pte;
 
 	pr_debug("Validating PTE swap exclusive\n");
 	entry = args->swp_entry;
 
 	pte = swp_entry_to_pte(entry);
+	softleaf = softleaf_from_pte(pte);
+
 	WARN_ON(pte_swp_exclusive(pte));
-	WARN_ON(!is_swap_pte(pte));
-	entry2 = pte_to_swp_entry(pte);
-	WARN_ON(memcmp(&entry, &entry2, sizeof(entry)));
+	WARN_ON(!softleaf_is_swap(softleaf));
+	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
 
 	pte = pte_swp_mkexclusive(pte);
+	softleaf = softleaf_from_pte(pte);
+
 	WARN_ON(!pte_swp_exclusive(pte));
-	WARN_ON(!is_swap_pte(pte));
+	WARN_ON(!softleaf_is_swap(softleaf));
 	WARN_ON(pte_swp_soft_dirty(pte));
-	entry2 = pte_to_swp_entry(pte);
-	WARN_ON(memcmp(&entry, &entry2, sizeof(entry)));
+	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
 
 	pte = pte_swp_clear_exclusive(pte);
+	softleaf = softleaf_from_pte(pte);
+
 	WARN_ON(pte_swp_exclusive(pte));
-	WARN_ON(!is_swap_pte(pte));
-	entry2 = pte_to_swp_entry(pte);
-	WARN_ON(memcmp(&entry, &entry2, sizeof(entry)));
+	WARN_ON(!softleaf_is_swap(softleaf));
+	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
 }
 
 static void __init pte_swap_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t arch_entry;
+	softleaf_t entry;
 	pte_t pte1, pte2;
 
 	pr_debug("Validating PTE swap\n");
 	pte1 = swp_entry_to_pte(args->swp_entry);
-	WARN_ON(!is_swap_pte(pte1));
+	entry = softleaf_from_pte(pte1);
+
+	WARN_ON(!softleaf_is_swap(entry));
 
 	arch_entry = __pte_to_swp_entry(pte1);
 	pte2 = __swp_entry_to_pte(arch_entry);
@@ -1218,8 +1227,8 @@ static int __init init_args(struct pgtab
 
 	/* See generic_max_swapfile_size(): probe the maximum offset */
 	max_swap_offset = swp_offset(pte_to_swp_entry(swp_entry_to_pte(swp_entry(0, ~0UL))));
-	/* Create a swp entry with all possible bits set */
-	args->swp_entry = swp_entry((1 << MAX_SWAPFILES_SHIFT) - 1, max_swap_offset);
+	/* Create a swp entry with all possible bits set while still being swap. */
+	args->swp_entry = swp_entry(MAX_SWAPFILES - 1, max_swap_offset);
 
 	/*
 	 * Allocate (huge) pages because some of the tests need to access
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


