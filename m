From: akpm@linux-foundation.org
Subject: + mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch added to -mm tree
Date: Fri, 18 Nov 2016 15:01:35 -0800
Message-ID: <582f884f.ZeCQoX9hy/jxdTGS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40856 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbcKRXBg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2016 18:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, gerald.schaefer@de.ibm.com, kaly.xin@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: intruduce a helper huge_nodemask()
has been added to the -mm tree.  Its filename is
     mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-rename-some-allocation-functions.patch
mm-hugetlb-add-a-new-parameter-for-some-functions.patch
mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask-v2.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch
mm-hugetlb-support-gigantic-surplus-pages.patch

