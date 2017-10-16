From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-use-page-cluster-as-max-window-of-vma-based-swap-readahead.patch
 removed from -mm tree
Date: Mon, 16 Oct 2017 12:56:04 -0700
Message-ID: <20171016195604.t4W9kJkaY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755892AbdJPT4H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 15:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@intel.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, ying.huang@intel.com


The patch titled
     Subject: mm, swap: use page-cluster as max window of VMA based swap readahead
has been removed from the -mm tree.  Its filename was
     mm-swap-use-page-cluster-as-max-window-of-vma-based-swap-readahead.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: use page-cluster as max window of VMA based swap readahead

When the VMA based swap readahead was introduced, a new knob

  /sys/kernel/mm/swap/vma_ra_max_order

was added as the max window of VMA swap readahead.  This is to make it
possible to use different max window for VMA based readahead and original
physical readahead.  But Minchan Kim pointed out that this will cause a
regression because setting page-cluster sysctl to zero cannot disable swap
readahead with the change.

To fix the regression, the page-cluster sysctl is used as the max window
of both the VMA based swap readahead and original physical swap readahead.
If more fine grained control is needed in the future, more knobs can be
added as the subordinate knobs of the page-cluster sysctl.

The vma_ra_max_order knob is deleted.  Because the knob was introduced in
v4.14-rc1, and this patch is targeting being merged before v4.14
releasing, there should be no existing users of this newly added ABI.

Link: http://lkml.kernel.org/r/20171011070847.16003-1-ying.huang@intel.com
Fixes: ec560175c0b6fce ("mm, swap: VMA based swap readahead")
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-swap |   10 ---
 mm/swap_state.c                                |   41 ++-------------
 2 files changed, 7 insertions(+), 44 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-kernel-mm-swap~mm-swap-use-page-cluster-as-max-window-of-vma-based-swap-readahead Documentation/ABI/testing/sysfs-kernel-mm-swap
--- a/Documentation/ABI/testing/sysfs-kernel-mm-swap~mm-swap-use-page-cluster-as-max-window-of-vma-based-swap-readahead
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-swap
@@ -14,13 +14,3 @@ Description:	Enable/disable VMA based sw
 		still used for tmpfs etc. other users.  If set to
 		false, the global swap readahead algorithm will be
 		used for all swappable pages.
-
-What:		/sys/kernel/mm/swap/vma_ra_max_order
-Date:		August 2017
-Contact:	Linux memory management mailing list <linux-mm@kvack.org>
-Description:	The max readahead size in order for VMA based swap readahead
-
-		VMA based swap readahead algorithm will readahead at
-		most 1 << max_order pages for each readahead.  The
-		real readahead size for each readahead will be scaled
-		according to the estimation algorithm.
diff -puN mm/swap_state.c~mm-swap-use-page-cluster-as-max-window-of-vma-based-swap-readahead mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-use-page-cluster-as-max-window-of-vma-based-swap-readahead
+++ a/mm/swap_state.c
@@ -39,10 +39,6 @@ struct address_space *swapper_spaces[MAX
 static unsigned int nr_swapper_spaces[MAX_SWAPFILES];
 bool swap_vma_readahead = true;
 
-#define SWAP_RA_MAX_ORDER_DEFAULT	3
-
-static int swap_ra_max_order = SWAP_RA_MAX_ORDER_DEFAULT;
-
 #define SWAP_RA_WIN_SHIFT	(PAGE_SHIFT / 2)
 #define SWAP_RA_HITS_MASK	((1UL << SWAP_RA_WIN_SHIFT) - 1)
 #define SWAP_RA_HITS_MAX	SWAP_RA_HITS_MASK
@@ -664,6 +660,13 @@ struct page *swap_readahead_detect(struc
 	pte_t *tpte;
 #endif
 
+	max_win = 1 << min_t(unsigned int, READ_ONCE(page_cluster),
+			     SWAP_RA_ORDER_CEILING);
+	if (max_win == 1) {
+		swap_ra->win = 1;
+		return NULL;
+	}
+
 	faddr = vmf->address;
 	entry = pte_to_swp_entry(vmf->orig_pte);
 	if ((unlikely(non_swap_entry(entry))))
@@ -672,12 +675,6 @@ struct page *swap_readahead_detect(struc
 	if (page)
 		return page;
 
-	max_win = 1 << READ_ONCE(swap_ra_max_order);
-	if (max_win == 1) {
-		swap_ra->win = 1;
-		return NULL;
-	}
-
 	fpfn = PFN_DOWN(faddr);
 	swap_ra_info = GET_SWAP_RA_VAL(vma);
 	pfn = PFN_DOWN(SWAP_RA_ADDR(swap_ra_info));
@@ -786,32 +783,8 @@ static struct kobj_attribute vma_ra_enab
 	__ATTR(vma_ra_enabled, 0644, vma_ra_enabled_show,
 	       vma_ra_enabled_store);
 
-static ssize_t vma_ra_max_order_show(struct kobject *kobj,
-				     struct kobj_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%d\n", swap_ra_max_order);
-}
-static ssize_t vma_ra_max_order_store(struct kobject *kobj,
-				      struct kobj_attribute *attr,
-				      const char *buf, size_t count)
-{
-	int err, v;
-
-	err = kstrtoint(buf, 10, &v);
-	if (err || v > SWAP_RA_ORDER_CEILING || v <= 0)
-		return -EINVAL;
-
-	swap_ra_max_order = v;
-
-	return count;
-}
-static struct kobj_attribute vma_ra_max_order_attr =
-	__ATTR(vma_ra_max_order, 0644, vma_ra_max_order_show,
-	       vma_ra_max_order_store);
