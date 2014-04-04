From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:35 -0700
Message-ID: <533f0897.+fp4hmzTTp397haC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbaDDTbg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, iamjoonsoo.kim@lge.com, davidlohr@hp.com, rientjes@google.com

Subject: [merged] mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch removed from -mm tree
To: rientjes@google.com,davidlohr@hp.com,iamjoonsoo.kim@lge.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:35 -0700


The patch titled
     Subject: mm, hugetlb: mark some bootstrap functions as __init
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: mark some bootstrap functions as __init

Both prep_compound_huge_page() and prep_compound_gigantic_page() are only
called at bootstrap and can be marked as __init.

The __SetPageTail(page) in prep_compound_gigantic_page() happening before
page->first_page is initialized is not concerning since this is bootstrap.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-mark-some-bootstrap-functions-as-__init mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-mark-some-bootstrap-functions-as-__init
+++ a/mm/hugetlb.c
@@ -689,7 +689,8 @@ static void prep_new_huge_page(struct hs
 	put_page(page); /* free it into the hugepage allocator */
 }
 
-static void prep_compound_gigantic_page(struct page *page, unsigned long order)
+static void __init prep_compound_gigantic_page(struct page *page,
+					       unsigned long order)
 {
 	int i;
 	int nr_pages = 1 << order;
@@ -1319,7 +1320,7 @@ found:
 	return 1;
 }
 
-static void prep_compound_huge_page(struct page *page, int order)
+static void __init prep_compound_huge_page(struct page *page, int order)
 {
 	if (unlikely(order > (MAX_ORDER - 1)))
 		prep_compound_gigantic_page(page, order);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
mmnuma-reorganize-change_pmd_range.patch
mmnuma-reorganize-change_pmd_range-fix.patch
move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-compaction-determine-isolation-mode-only-once.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
mm-utilc-add-kstrimdup.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch

