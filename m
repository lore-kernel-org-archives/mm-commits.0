From: akpm@linux-foundation.org
Subject: + mm-memcontrol-support-memory_device_private-v4.patch added to
 -mm tree
Date: Thu, 17 Aug 2017 14:42:01 -0700
Message-ID: <59960da9.p+CZ47QQnq6RQvsG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40566 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753736AbdHQVmD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 17:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhairgrove@nvidia.com, mhocko@kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, sgutti@nvidia.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol: support MEMORY_DEVICE_PRIVATE
has been added to the -mm tree.  Its filename is
     mm-memcontrol-support-memory_device_private-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-support-memory_device_private-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-support-memory_device_private-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/memcontrol: support MEMORY_DEVICE_PRIVATE

HMM pages (private or public device pages) are ZONE_DEVICE page and thus
need special handling when it comes to lru or refcount.  This patch make
sure that memcontrol properly handle those when it face them.  Those pages
are use like regular pages in a process address space either as anonymous
page or as file back page.  So from memcg point of view we want to handle
them like regular page for now at least.

Link: http://lkml.kernel.org/r/20170817000548.32038-11-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sherry Cheung <SCheung@nvidia.com>
Cc: Subhash Gutti <sgutti@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    1 
 mm/memcontrol.c   |   52 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 49 insertions(+), 4 deletions(-)

diff -puN kernel/memremap.c~mm-memcontrol-support-memory_device_private-v4 kernel/memremap.c
--- a/kernel/memremap.c~mm-memcontrol-support-memory_device_private-v4
+++ a/kernel/memremap.c
@@ -504,6 +504,7 @@ void put_zone_device_private_page(struct
 		__ClearPageWaiters(page);
 
 		page->mapping = NULL;
+		mem_cgroup_uncharge(page);
 
 		page->pgmap->page_free(page, page->pgmap->data);
 	} else if (!count)
diff -puN mm/memcontrol.c~mm-memcontrol-support-memory_device_private-v4 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-support-memory_device_private-v4
+++ a/mm/memcontrol.c
@@ -4414,12 +4414,13 @@ enum mc_target_type {
 	MC_TARGET_NONE = 0,
 	MC_TARGET_PAGE,
 	MC_TARGET_SWAP,
+	MC_TARGET_DEVICE,
 };
 
 static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 						unsigned long addr, pte_t ptent)
 {
-	struct page *page = vm_normal_page(vma, addr, ptent);
+	struct page *page = _vm_normal_page(vma, addr, ptent, true);
 
 	if (!page || !page_mapped(page))
 		return NULL;
@@ -4436,7 +4437,7 @@ static struct page *mc_handle_present_pt
 	return page;
 }
 
-#ifdef CONFIG_SWAP
+#if defined(CONFIG_SWAP) || defined(CONFIG_DEVICE_PRIVATE)
 static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 			pte_t ptent, swp_entry_t *entry)
 {
@@ -4445,6 +4446,23 @@ static struct page *mc_handle_swap_pte(s
 
 	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
 		return NULL;
+
+	/*
+	 * Handle MEMORY_DEVICE_PRIVATE which are ZONE_DEVICE page belonging to
+	 * a device and because they are not accessible by CPU they are store
+	 * as special swap entry in the CPU page table.
+	 */
+	if (is_device_private_entry(ent)) {
+		page = device_private_entry_to_page(ent);
+		/*
+		 * MEMORY_DEVICE_PRIVATE means ZONE_DEVICE page and which have
+		 * a refcount of 1 when free (unlike normal page)
+		 */
+		if (!page_ref_add_unless(page, 1, 1))
+			return NULL;
+		return page;
+	}
+
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
 	 * we call find_get_page() with swapper_space directly.
@@ -4605,6 +4623,12 @@ out:
  *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
  *     target for charge migration. if @target is not NULL, the entry is stored
  *     in target->ent.
+ *   3(MC_TARGET_DEVICE): like MC_TARGET_PAGE  but page is MEMORY_DEVICE_PRIVATE
+ *     (so ZONE_DEVICE page and thus not on the lru). For now we such page is
+ *     charge like a regular page would be as for all intent and purposes it is
+ *     just special memory taking the place of a regular page.
+ *
+ *     See Documentations/vm/hmm.txt and include/linux/hmm.h
  *
  * Called with pte lock held.
  */
@@ -4633,6 +4657,8 @@ static enum mc_target_type get_mctgt_typ
 		 */
 		if (page->mem_cgroup == mc.from) {
 			ret = MC_TARGET_PAGE;
+			if (is_device_private_page(page))
+				ret = MC_TARGET_DEVICE;
 			if (target)
 				target->page = page;
 		}
@@ -4700,6 +4726,11 @@ static int mem_cgroup_count_precharge_pt
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
+		/*
+		 * Note their can not be MC_TARGET_DEVICE for now as we do not
+		 * support transparent huge page with MEMORY_DEVICE_PUBLIC or
+		 * MEMORY_DEVICE_PRIVATE but this might change.
+		 */
 		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
 			mc.precharge += HPAGE_PMD_NR;
 		spin_unlock(ptl);
@@ -4915,6 +4946,14 @@ static int mem_cgroup_move_charge_pte_ra
 				putback_lru_page(page);
 			}
 			put_page(page);
+		} else if (target_type == MC_TARGET_DEVICE) {
+			page = target.page;
+			if (!mem_cgroup_move_account(page, true,
+						     mc.from, mc.to)) {
+				mc.precharge -= HPAGE_PMD_NR;
+				mc.moved_charge += HPAGE_PMD_NR;
+			}
+			put_page(page);
 		}
 		spin_unlock(ptl);
 		return 0;
@@ -4926,12 +4965,16 @@ retry:
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; addr += PAGE_SIZE) {
 		pte_t ptent = *(pte++);
+		bool device = false;
 		swp_entry_t ent;
 
 		if (!mc.precharge)
 			break;
 
 		switch (get_mctgt_type(vma, addr, ptent, &target)) {
+		case MC_TARGET_DEVICE:
+			device = true;
+			/* fall through */
 		case MC_TARGET_PAGE:
 			page = target.page;
 			/*
@@ -4942,7 +4985,7 @@ retry:
 			 */
 			if (PageTransCompound(page))
 				goto put;
-			if (isolate_lru_page(page))
+			if (!device && isolate_lru_page(page))
 				goto put;
 			if (!mem_cgroup_move_account(page, false,
 						mc.from, mc.to)) {
@@ -4950,7 +4993,8 @@ retry:
 				/* we uncharge from mc.from later. */
 				mc.moved_charge++;
 			}
-			putback_lru_page(page);
+			if (!device)
+				putback_lru_page(page);
 put:			/* get_mctgt_type() gets the page */
 			put_page(page);
 			break;
_

Patches currently in -mm which might be from jglisse@redhat.com are

hmm-heterogeneous-memory-management-documentation-v3.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short-v5.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v4.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-v5.patch
mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
mm-memcontrol-support-memory_device_private-v4.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-v7.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v5.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
mm-device-public-memory-device-memory-cache-coherent-with-cpu-v5.patch
mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
lib-interval_tree-fast-overlap-detection-fix.patch

