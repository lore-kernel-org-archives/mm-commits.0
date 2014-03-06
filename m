From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-make-first_page-visible-before-pagetail.patch removed from
 -mm tree
Date: Thu, 06 Mar 2014 12:37:24 -0800
Message-ID: <5318dc84.gpzDeRNxSfyse50b%akpm__44045.5750249841$1394138293$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaCFUhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, kirill.shutemov@linux.intel.com, cl@linux.com, aquini@redhat.com, aarcange@redhat.com, Holger.Kiehl@dwd.de, rientjes@google.com

Subject: [merged] mm-page_alloc-make-first_page-visible-before-pagetail.patch removed from -mm tree
To: rientjes@google.com,Holger.Kiehl@dwd.de,aarcange@redhat.com,aquini@redhat.com,cl@linux.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,stable@vger.kernel.org,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:24 -0800


The patch titled
     Subject: mm, page_alloc: make first_page visible before PageTail
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-first_page-visible-before-pagetail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, page_alloc: make first_page visible before PageTail

Commit bf6bddf1924e ("mm: introduce compaction and migration for ballooned
pages") introduces page_count(page) into memory compaction which
dereferences page->first_page if PageTail(page).

This results in a very rare NULL pointer dereference on the aforementioned 
page_count(page).  Indeed, anything that does compound_head(), including 
page_count() is susceptible to racing with prep_compound_page() and seeing 
a NULL or dangling page->first_page pointer.

This patch uses Andrea's implementation of compound_trans_head() that
deals with such a race and makes it the default compound_head()
implementation.  This includes a read memory barrier that ensures that
if PageTail(head) is true that we return a head page that is neither
NULL nor dangling.  The patch then adds a store memory barrier to
prep_compound_page() to ensure page->first_page is set.

Hugetlbfs is the exception, we don't enforce a store memory barrier

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-make-first_page-visible-before-pagetail mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-make-first_page-visible-before-pagetail
+++ a/mm/page_alloc.c
@@ -369,9 +369,11 @@ void prep_compound_page(struct page *pag
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
-		__SetPageTail(p);
 		set_page_count(p, 0);
 		p->first_page = page;
+		/* Make sure p->first_page is always valid for PageTail() */
+		smp_wmb();
+		__SetPageTail(p);
 	}
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
kthread-ensure-locality-of-task_struct-allocations.patch
arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
mmnuma-reorganize-change_pmd_range.patch
mmnuma-reorganize-change_pmd_range-fix.patch
move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
kernel-resourcec-make-reallocate_resource-static.patch
mm-utilc-add-kstrimdup.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
linux-next.patch

