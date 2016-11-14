From: akpm@linux-foundation.org
Subject: + mm-mempolicy-intruduce-a-helper-huge_nodemask.patch added to
 -mm tree
Date: Mon, 14 Nov 2016 14:44:49 -0800
Message-ID: <582a3e61.hw4WPsNfr9YYjD/3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934180AbcKNWov (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 17:44:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie.huang@arm.com, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, gerald.schaefer@de.ibm.com, kaly.xin@arm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, steve.capper@arm.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mempolicy: intruduce a helper huge_nodemask()
has been added to the -mm tree.  Its filename is
     mm-mempolicy-intruduce-a-helper-huge_nodemask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-intruduce-a-helper-huge_nodemask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-intruduce-a-helper-huge_nodemask.patch

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

Introduce a new helper huge_nodemask(), we can use it to get the node
mask.

This idea of the function is from huge_zonelist().

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

mm-hugetlb-rename-some-allocation-functions.patch
mm-hugetlb-add-a-new-parameter-for-some-functions.patch
mm-hugetlb-change-the-return-type-for-alloc_fresh_gigantic_page.patch
mm-mempolicy-intruduce-a-helper-huge_nodemask.patch
mm-hugetlb-add-a-new-function-to-allocate-a-new-gigantic-page.patch
mm-hugetlb-support-gigantic-surplus-pages.patch

