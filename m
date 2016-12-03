From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-mempolicy-intruduce-a-helper-huge_nodemask.patch removed from -mm tree
Date: Fri, 02 Dec 2016 16:37:16 -0800
Message-ID: <584213bc.CNxg6F/AvTR9ytk1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757020AbcLCAgz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 19:36:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, gerald.schaefer@de.ibm.com, kaly.xin@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: introduce a helper huge_nodemask()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-intruduce-a-helper-huge_nodemask.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: mm: mempolicy: introduce a helper huge_nodemask()

Introduce a new helper huge_nodemask(), we can use it to get the node
mask.

This idea is from init_nodemask_of_mempolicy(): return true if we can
succeed in extracting the node_mask for 'bind' or 'interleave' policy or
initializing the node_mask to contain the single node for 'preferred' or
'local' policy.

Link: http://lkml.kernel.org/r/1479107259-2011-5-git-send-email-shijie.huang@arm.com
Signed-off-by: Huang Shijie <shijie.huang@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill A . Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Kaly Xin <kaly.xin@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    8 ++++++++
 mm/mempolicy.c            |   20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff -puN include/linux/mempolicy.h~mm-mempolicy-intruduce-a-helper-huge_nodemask include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-intruduce-a-helper-huge_nodemask
+++ a/include/linux/mempolicy.h
@@ -145,6 +145,8 @@ extern void mpol_rebind_task(struct task
 				enum mpol_rebind_step step);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 
+extern nodemask_t *huge_nodemask(struct vm_area_struct *vma,
+				unsigned long addr);
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask);
@@ -261,6 +263,12 @@ static inline void mpol_rebind_mm(struct
 {
 }
 
+static inline nodemask_t *huge_nodemask(struct vm_area_struct *vma,
+				unsigned long addr)
+{
+	return NULL;
+}
+
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask)
diff -puN mm/mempolicy.c~mm-mempolicy-intruduce-a-helper-huge_nodemask mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-intruduce-a-helper-huge_nodemask
+++ a/mm/mempolicy.c
@@ -1800,6 +1800,26 @@ static inline unsigned interleave_nid(st
 
 #ifdef CONFIG_HUGETLBFS
 /*
+ * huge_nodemask(@vma, @addr)
+ * @vma: virtual memory area whose policy is sought
+ * @addr: address in @vma for shared policy lookup and interleave policy
+ *
+ * If the effective policy is BIND, returns a pointer to the mempolicy's
+ * @nodemask.
+ */
+nodemask_t *huge_nodemask(struct vm_area_struct *vma, unsigned long addr)
+{
+	nodemask_t *nodes_mask = NULL;
+	struct mempolicy *mpol = get_vma_policy(vma, addr);
+
+	if (mpol->mode == MPOL_BIND)
+		nodes_mask = &mpol->v.nodes;
+	mpol_cond_put(mpol);
+
+	return nodes_mask;
+}
+
+/*
  * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
  * @vma: virtual memory area whose policy is sought
  * @addr: address in @vma for shared policy lookup and interleave policy
_

Patches currently in -mm which might be from shijie.huang@arm.com are

mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2.patch
mm-hugetlb-support-gigantic-surplus-pages.patch
mm-hugetlb-add-description-for-alloc_gigantic_page.patch

