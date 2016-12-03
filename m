From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch removed from -mm
 tree
Date: Fri, 02 Dec 2016 16:37:19 -0800
Message-ID: <584213bf.Ftvjk7mR1UPgz1FF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757062AbcLCAg6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 19:36:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, gerald.schaefer@de.ibm.com, kaly.xin@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: intruduce a helper huge_nodemask()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Huang Shijie <shijie.huang@arm.com>
Subject: mm: mempolicy: intruduce a helper huge_nodemask()

The previous version does not treat the MPOL_PREFERRED/MPOL_INTERLEAVE
cases.  This patch adds the code to set proper node mask for
MPOL_PREFERRED/MPOL_INTERLEAVE.

Link: http://lkml.kernel.org/r/1479279182-31294-1-git-send-email-shijie.huang@arm.com
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

 include/linux/mempolicy.h |   10 +++----
 mm/mempolicy.c            |   47 ++++++++++++++++++++++++++++--------
 2 files changed, 42 insertions(+), 15 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicy-intruduce-a-helper-huge_nodemask-v2 include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-intruduce-a-helper-huge_nodemask-v2
+++ a/include/linux/mempolicy.h
@@ -145,8 +145,8 @@ extern void mpol_rebind_task(struct task
 				enum mpol_rebind_step step);
 extern void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new);
 
-extern nodemask_t *huge_nodemask(struct vm_area_struct *vma,
-				unsigned long addr);
+extern bool huge_nodemask(struct vm_area_struct *vma,
+				unsigned long addr, nodemask_t *mask);
 extern struct zonelist *huge_zonelist(struct vm_area_struct *vma,
 				unsigned long addr, gfp_t gfp_flags,
 				struct mempolicy **mpol, nodemask_t **nodemask);
@@ -263,10 +263,10 @@ static inline void mpol_rebind_mm(struct
 {
 }
 
-static inline nodemask_t *huge_nodemask(struct vm_area_struct *vma,
-				unsigned long addr)
+static inline bool huge_nodemask(struct vm_area_struct *vma,
+				unsigned long addr, nodemask_t *mask)
 {
-	return NULL;
+	return false;
 }
 
 static inline struct zonelist *huge_zonelist(struct vm_area_struct *vma,
diff -puN mm/mempolicy.c~mm-mempolicy-intruduce-a-helper-huge_nodemask-v2 mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-intruduce-a-helper-huge_nodemask-v2
+++ a/mm/mempolicy.c
@@ -1800,23 +1800,50 @@ static inline unsigned interleave_nid(st
 
 #ifdef CONFIG_HUGETLBFS
 /*
- * huge_nodemask(@vma, @addr)
+ * huge_nodemask(@vma, @addr, @mask)
  * @vma: virtual memory area whose policy is sought
- * @addr: address in @vma for shared policy lookup and interleave policy
+ * @addr: address in @vma
+ * @mask: a nodemask pointer
  *
- * If the effective policy is BIND, returns a pointer to the mempolicy's
- * @nodemask.
+ * Return true if we can succeed in extracting the policy nodemask
+ * for 'bind' or 'interleave' policy into the argument @mask, or
+ * initializing the argument @mask to contain the single node for
+ * 'preferred' or 'local' policy.
  */
-nodemask_t *huge_nodemask(struct vm_area_struct *vma, unsigned long addr)
+bool huge_nodemask(struct vm_area_struct *vma, unsigned long addr,
+			nodemask_t *mask)
 {
-	nodemask_t *nodes_mask = NULL;
-	struct mempolicy *mpol = get_vma_policy(vma, addr);
+	struct mempolicy *mpol;
+	bool ret = true;
+	int nid;
 
-	if (mpol->mode == MPOL_BIND)
-		nodes_mask = &mpol->v.nodes;
+	if (!mask)
+		return false;
+
+	mpol = get_vma_policy(vma, addr);
+
+	switch (mpol->mode) {
+	case MPOL_PREFERRED:
+		if (mpol->flags & MPOL_F_LOCAL)
+			nid = numa_node_id();
+		else
+			nid = mpol->v.preferred_node;
+		init_nodemask_of_node(mask, nid);
+		break;
+
+	case MPOL_BIND:
+		/* Fall through */
+	case MPOL_INTERLEAVE:
+		*mask = mpol->v.nodes;
+		break;
+
+	default:
+		ret = false;
+		break;
+	}
 	mpol_cond_put(mpol);
 
-	return nodes_mask;
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from shijie.huang@arm.com are

mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page-v2.patch
mm-hugetlb-support-gigantic-surplus-pages.patch
mm-hugetlb-add-description-for-alloc_gigantic_page.patch

