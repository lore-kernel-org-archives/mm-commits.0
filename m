From: akpm@linux-foundation.org
Subject: + hugetlbfs-add-hugetlbfs_fallocate-fix.patch added to -mm tree
Date: Mon, 27 Jul 2015 12:04:52 -0700
Message-ID: <55b680d4.4I2TQZqAU4QyeWJ4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbbG0TEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 15:04:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, fengguang.wu@intel.com, hillf.zj@alibaba-inc.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mmotm: build fix hugetlbfs fallocate if not CONFIG_NUMA
has been added to the -mm tree.  Its filename is
     hugetlbfs-add-hugetlbfs_fallocate-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-add-hugetlbfs_fallocate-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-add-hugetlbfs_fallocate-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mmotm: build fix hugetlbfs fallocate if not CONFIG_NUMA

Commit 56bb4d795 introduced a build error if CONFIG_NUMA is not
defined.  When fallocate preallocation allocates pages, it will
use the defined numa policy.  However, if numa is not defined
there is no such policy and no code should reference numa policy.
Create wrappers to isolate policy manipulation code that are a
NOOP in the non-NUMA case.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-add-hugetlbfs_fallocate-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-add-hugetlbfs_fallocate-fix
+++ a/fs/hugetlbfs/inode.c
@@ -85,6 +85,29 @@ static const match_table_t tokens = {
 	{Opt_err,	NULL},
 };
 
+#ifdef CONFIG_NUMA
+static inline void hugetlb_set_vma_policy(struct vm_area_struct *vma,
+					struct inode *inode, pgoff_t index)
+{
+	vma->vm_policy = mpol_shared_policy_lookup(&HUGETLBFS_I(inode)->policy,
+							index);
+}
+
+static inline void hugetlb_drop_vma_policy(struct vm_area_struct *vma)
+{
+	mpol_cond_put(vma->vm_policy);
+}
+#else
+static inline void hugetlb_set_vma_policy(struct vm_area_struct *vma,
+					struct inode *inode, pgoff_t index)
+{
+}
+
+static inline void hugetlb_drop_vma_policy(struct vm_area_struct *vma)
+{
+}
+#endif
+
 static void huge_pagevec_release(struct pagevec *pvec)
 {
 	int i;
@@ -546,9 +569,9 @@ static long hugetlbfs_fallocate(struct f
 		goto out;
 
 	/*
-	 * Initialize a pseudo vma that just contains the policy used
-	 * when allocating the huge pages.  The actual policy field
-	 * (vm_policy) is determined based on the index in the loop below.
+	 * Initialize a pseudo vma as this is required by the huge page
+	 * allocation routines.  If NUMA is configured, use page index
+	 * as input to create an allocation policy.
 	 */
 	memset(&pseudo_vma, 0, sizeof(struct vm_area_struct));
 	pseudo_vma.vm_flags = (VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
@@ -574,10 +597,8 @@ static long hugetlbfs_fallocate(struct f
 			break;
 		}
 
-		/* Get policy based on index */
-		pseudo_vma.vm_policy =
-			mpol_shared_policy_lookup(&HUGETLBFS_I(inode)->policy,
-							index);
+		/* Set numa allocation policy based on index */
+		hugetlb_set_vma_policy(&pseudo_vma, inode, index);
 
 		/* addr is the offset within the file (zero based) */
 		addr = index * hpage_size;
@@ -592,13 +613,13 @@ static long hugetlbfs_fallocate(struct f
 		if (page) {
 			put_page(page);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-			mpol_cond_put(pseudo_vma.vm_policy);
+			hugetlb_drop_vma_policy(&pseudo_vma);
 			continue;
 		}
 
 		/* Allocate page and add to page cache */
 		page = alloc_huge_page(&pseudo_vma, addr, avoid_reserve);
-		mpol_cond_put(pseudo_vma.vm_policy);
+		hugetlb_drop_vma_policy(&pseudo_vma);
 		if (IS_ERR(page)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			error = PTR_ERR(page);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-make-the-function-vma_shareable-bool.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-hugetlb-add-region_del-to-delete-a-specific-range-of-entries.patch
mm-hugetlb-expose-hugetlb-fault-mutex-for-use-by-fallocate.patch
hugetlbfs-hugetlb_vmtruncate_list-needs-to-take-a-range-to-delete.patch
hugetlbfs-truncate_hugepages-takes-a-range-of-pages.patch
mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
mm-hugetlb-alloc_huge_page-handle-areas-hole-punched-by-fallocate.patch
hugetlbfs-new-huge_add_to_page_cache-helper-routine.patch
hugetlbfs-add-hugetlbfs_fallocate.patch
hugetlbfs-add-hugetlbfs_fallocate-fix.patch
mm-madvise-allow-remove-operation-for-hugetlbfs.patch

