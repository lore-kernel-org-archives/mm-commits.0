From: akpm@linux-foundation.org
Subject: + mm-swap-add-sysfs-interface-for-vma-based-swap-readahead.patch
 added to -mm tree
Date: Wed, 09 Aug 2017 14:53:06 -0700
Message-ID: <598b8442.kRXTsgcM+bdi93Df%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752244AbdHIVxH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2017 17:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, dave.hansen@intel.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hughd@google.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: Add sysfs interface for VMA based swap readahead
has been added to the -mm tree.  Its filename is
     mm-swap-add-sysfs-interface-for-vma-based-swap-readahead.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-add-sysfs-interface-for-vma-based-swap-readahead.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-add-sysfs-interface-for-vma-based-swap-readahead.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: Add sysfs interface for VMA based swap readahead

The sysfs interface to control the VMA based swap readahead is added as
follow,

/sys/kernel/mm/swap/vma_ra_enabled

Enable the VMA based swap readahead algorithm, or use the original global
swap readahead algorithm.

/sys/kernel/mm/swap/vma_ra_max_order

Set the max order of the readahead window size for the VMA based swap
readahead algorithm.

The corresponding ABI documentation is added too.

Link: http://lkml.kernel.org/r/20170807054038.1843-5-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-swap |   26 ++++
 mm/swap_state.c                                |   80 +++++++++++++++
 2 files changed, 106 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-kernel-mm-swap
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-swap
@@ -0,0 +1,26 @@
+What:		/sys/kernel/mm/swap/
+Date:		August 2017
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Interface for swapping
+
+What:		/sys/kernel/mm/swap/vma_ra_enabled
+Date:		August 2017
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Enable/disable VMA based swap readahead.
+
+		If set to true, the VMA based swap readahead algorithm
+		will be used for swappable anonymous pages mapped in a
+		VMA, and the global swap readahead algorithm will be
+		still used for tmpfs etc. other users.  If set to
+		false, the global swap readahead algorithm will be
+		used for all swappable pages.
+
+What:		/sys/kernel/mm/swap/vma_ra_max_order
+Date:		August 2017
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	The max readahead size in order for VMA based swap readahead
+
+		VMA based swap readahead algorithm will readahead at
+		most 1 << max_order pages for each readahead.  The
+		real readahead size for each readahead will be scaled
+		according to the estimation algorithm.
diff -puN mm/swap_state.c~mm-swap-add-sysfs-interface-for-vma-based-swap-readahead mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-add-sysfs-interface-for-vma-based-swap-readahead
+++ a/mm/swap_state.c
@@ -751,3 +751,83 @@ skip:
 	return read_swap_cache_async(fentry, gfp_mask, vma, vmf->address,
 				     swap_ra->win == 1);
 }
+
+#ifdef CONFIG_SYSFS
+static ssize_t vma_ra_enabled_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", swap_vma_readahead ? "true" : "false");
+}
+static ssize_t vma_ra_enabled_store(struct kobject *kobj,
+				      struct kobj_attribute *attr,
+				      const char *buf, size_t count)
+{
+	if (!strncmp(buf, "true", 4) || !strncmp(buf, "1", 1))
+		swap_vma_readahead = true;
+	else if (!strncmp(buf, "false", 5) || !strncmp(buf, "0", 1))
+		swap_vma_readahead = false;
+	else
+		return -EINVAL;
+
+	return count;
+}
+static struct kobj_attribute vma_ra_enabled_attr =
+	__ATTR(vma_ra_enabled, 0644, vma_ra_enabled_show,
+	       vma_ra_enabled_store);
+
+static ssize_t vma_ra_max_order_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", swap_ra_max_order);
+}
+static ssize_t vma_ra_max_order_store(struct kobject *kobj,
+				      struct kobj_attribute *attr,
+				      const char *buf, size_t count)
+{
+	int err, v;
+
+	err = kstrtoint(buf, 10, &v);
+	if (err || v > SWAP_RA_ORDER_CEILING || v <= 0)
+		return -EINVAL;
+
+	swap_ra_max_order = v;
+
+	return count;
+}
+static struct kobj_attribute vma_ra_max_order_attr =
+	__ATTR(vma_ra_max_order, 0644, vma_ra_max_order_show,
+	       vma_ra_max_order_store);
+
+static struct attribute *swap_attrs[] = {
+	&vma_ra_enabled_attr.attr,
+	&vma_ra_max_order_attr.attr,
+	NULL,
+};
+
+static struct attribute_group swap_attr_group = {
+	.attrs = swap_attrs,
+};
+
+static int __init swap_init_sysfs(void)
+{
+	int err;
+	struct kobject *swap_kobj;
+
+	swap_kobj = kobject_create_and_add("swap", mm_kobj);
+	if (!swap_kobj) {
+		pr_err("failed to create swap kobject\n");
+		return -ENOMEM;
+	}
+	err = sysfs_create_group(swap_kobj, &swap_attr_group);
+	if (err) {
+		pr_err("failed to register swap group\n");
+		goto delete_obj;
+	}
+	return 0;
+
+delete_obj:
+	kobject_put(swap_kobj);
+	return err;
+}
+subsys_initcall(swap_init_sysfs);
+#endif
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-swap-support-to-clear-swap-cache-flag-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out.patch
mm-thp-swap-support-to-reclaim-swap-space-for-thp-swapped-out-fix.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out.patch
mm-thp-swap-make-reuse_swap_page-works-for-thp-swapped-out-fix.patch
mm-thp-swap-dont-allocate-huge-cluster-for-file-backed-swap-device.patch
block-thp-make-block_device_operationsrw_page-support-thp.patch
test-code-to-write-thp-to-swap-device-as-a-whole.patch
mm-thp-swap-support-to-split-thp-for-thp-swapped-out.patch
memcg-thp-swap-support-move-mem-cgroup-charge-for-thp-swapped-out.patch
memcg-thp-swap-avoid-to-duplicated-charge-thp-in-swap-cache.patch
memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch
mm-thp-swap-delay-splitting-thp-after-swapped-out.patch
mm-thp-swap-add-thp-swapping-out-fallback-counting.patch
mm-swap-add-swap-readahead-hit-statistics.patch
mm-swap-fix-swap-readahead-marking.patch
mm-swap-vma-based-swap-readahead.patch
mm-swap-add-sysfs-interface-for-vma-based-swap-readahead.patch
mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap.patch

