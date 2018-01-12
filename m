From: akpm@linux-foundation.org
Subject: [merged]
 provide-useful-debugging-information-for-vm_bug.patch removed from -mm tree
Date: Fri, 12 Jan 2018 13:43:56 -0800
Message-ID: <20180112214356.JWOFZPY5i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965253AbeALVn5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 16:43:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, me@tobin.cc, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug.c: provide useful debugging information for VM_BUG
has been removed from the -mm tree.  Its filename was
     provide-useful-debugging-information-for-vm_bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: mm/debug.c: provide useful debugging information for VM_BUG

With the recent addition of hashed kernel pointers, places which need to
produce useful debug output have to specify %px, not %p.  This patch fixes
all the VM debug to use %px.  This is appropriate because it's debug
output that the user should never be able to trigger, and kernel
developers need to see the actual pointers.

Link: http://lkml.kernel.org/r/20171219133236.GE13680@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: "Tobin C. Harding" <me@tobin.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN mm/debug.c~provide-useful-debugging-information-for-vm_bug mm/debug.c
--- a/mm/debug.c~provide-useful-debugging-information-for-vm_bug
+++ a/mm/debug.c
@@ -50,7 +50,7 @@ void __dump_page(struct page *page, cons
 	 */
 	int mapcount = PageSlab(page) ? 0 : page_mapcount(page);
 
-	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx",
+	pr_emerg("page:%px count:%d mapcount:%d mapping:%px index:%#lx",
 		  page, page_ref_count(page), mapcount,
 		  page->mapping, page_to_pgoff(page));
 	if (PageCompound(page))
@@ -69,7 +69,7 @@ void __dump_page(struct page *page, cons
 
 #ifdef CONFIG_MEMCG
 	if (page->mem_cgroup)
-		pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
+		pr_alert("page->mem_cgroup:%px\n", page->mem_cgroup);
 #endif
 }
 
@@ -84,10 +84,10 @@ EXPORT_SYMBOL(dump_page);
 
 void dump_vma(const struct vm_area_struct *vma)
 {
-	pr_emerg("vma %p start %p end %p\n"
-		"next %p prev %p mm %p\n"
-		"prot %lx anon_vma %p vm_ops %p\n"
-		"pgoff %lx file %p private_data %p\n"
+	pr_emerg("vma %px start %px end %px\n"
+		"next %px prev %px mm %px\n"
+		"prot %lx anon_vma %px vm_ops %px\n"
+		"pgoff %lx file %px private_data %px\n"
 		"flags: %#lx(%pGv)\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
 		vma->vm_prev, vma->vm_mm,
@@ -100,27 +100,27 @@ EXPORT_SYMBOL(dump_vma);
 
 void dump_mm(const struct mm_struct *mm)
 {
-	pr_emerg("mm %p mmap %p seqnum %d task_size %lu\n"
+	pr_emerg("mm %px mmap %px seqnum %d task_size %lu\n"
 #ifdef CONFIG_MMU
-		"get_unmapped_area %p\n"
+		"get_unmapped_area %px\n"
 #endif
 		"mmap_base %lu mmap_legacy_base %lu highest_vm_end %lu\n"
-		"pgd %p mm_users %d mm_count %d pgtables_bytes %lu map_count %d\n"
+		"pgd %px mm_users %d mm_count %d pgtables_bytes %lu map_count %d\n"
 		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
 		"pinned_vm %lx data_vm %lx exec_vm %lx stack_vm %lx\n"
 		"start_code %lx end_code %lx start_data %lx end_data %lx\n"
 		"start_brk %lx brk %lx start_stack %lx\n"
 		"arg_start %lx arg_end %lx env_start %lx env_end %lx\n"
-		"binfmt %p flags %lx core_state %p\n"
+		"binfmt %px flags %lx core_state %px\n"
 #ifdef CONFIG_AIO
-		"ioctx_table %p\n"
+		"ioctx_table %px\n"
 #endif
 #ifdef CONFIG_MEMCG
-		"owner %p "
+		"owner %px "
 #endif
-		"exe_file %p\n"
+		"exe_file %px\n"
 #ifdef CONFIG_MMU_NOTIFIER
-		"mmu_notifier_mm %p\n"
+		"mmu_notifier_mm %px\n"
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 		"numa_next_scan %lu numa_scan_offset %lu numa_scan_seq %d\n"
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

mm-align-struct-page-more-aesthetically.patch
mm-de-indent-struct-page.patch
mm-remove-misleading-alignment-claims.patch
mm-improve-comment-on-page-mapping.patch
mm-introduce-_slub_counter_t.patch
mm-store-compound_dtor-compound_order-as-bytes.patch
mm-store-compound_dtor-compound_order-as-bytes-fix.patch
mm-document-how-to-use-struct-page.patch
mm-remove-reference-to-pg_buddy.patch

