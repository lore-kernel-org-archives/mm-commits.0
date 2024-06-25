Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCA0748F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291633; cv=none; b=lvXTMpPmsEHVcsR4eQCtEws82Ka4/8i31HXxwbIRvZRzM34noZo7CtmbBden1wjNnyk4mMluno+XFWQqAFNzKfmh+XXd9rQwmzfMGPQIGnzDr2BhihuEM8CiXdKg1XBAaSV6V/kiRiGbAR/Dor0+43Ik1qW7LBXU5vuQCZ8a4vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291633; c=relaxed/simple;
	bh=4rAjbsY3eNcfhSIGCjhu85hwplM0SnvnMBMMNH1pZrg=;
	h=Date:To:From:Subject:Message-Id; b=BHH5V4W5QfYPSeYu/29XA9ETfI9S+KqON/I/pAunsavQK3huSRkbbLDQj/qupEY3PmYY65Euh6P5Ml0OZTlv2i9nhuHuvcyUH7ntVlzC94syiQmArXCHnZAkAWhbrAZHKi06xPtTQc+L8wzfBKgR8bRVH7CFDRfgvXawx5z6QsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dFFbn4Pf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFFbn4Pf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E7CC32782;
	Tue, 25 Jun 2024 05:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291633;
	bh=4rAjbsY3eNcfhSIGCjhu85hwplM0SnvnMBMMNH1pZrg=;
	h=Date:To:From:Subject:From;
	b=dFFbn4PfiEsFZjoQt0qTNe4uZQsfUNbg250SAoPTa0eF4jY5RTDsJHMQ+cC0YxqRW
	 5GlZ7qKje8vlka2TnMv3hd8JZm3rkJU+jHKk5icAeMnVWHIHqGt9EMTg6uGcqdhDkS
	 4iIEZZ89EIbB3cMQ+qqdpRAHBgCVWaFdeK1YeGFg=
Date: Mon, 24 Jun 2024 22:00:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch removed from -mm tree
Message-Id: <20240625050033.B0E7CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: add multi-size THP sysfs interface for anonymous shmem
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: add multi-size THP sysfs interface for anonymous shmem
Date: Tue, 11 Jun 2024 18:11:07 +0800

To support the use of mTHP with anonymous shmem, add a new sysfs interface
'shmem_enabled' in the '/sys/kernel/mm/transparent_hugepage/hugepages-kB/'
directory for each mTHP to control whether shmem is enabled for that mTHP,
with a value similar to the top level 'shmem_enabled', which can be set
to: "always", "inherit (to inherit the top level setting)", "within_size",
"advise", "never".  An 'inherit' option is added to ensure compatibility
with these global settings, and the options 'force' and 'deny' are
dropped, which are rather testing artifacts from the old ages.

By default, PMD-sized hugepages have enabled="inherit" and all other
hugepage sizes have enabled="never" for
'/sys/kernel/mm/transparent_hugepage/hugepages-xxkB/shmem_enabled'.

In addition, if top level value is 'force', then only PMD-sized hugepages
have enabled="inherit", otherwise configuration will be failed and vice
versa.  That means now we will avoid using non-PMD sized THP to override
the global huge allocation.

[baolin.wang@linux.alibaba.com: fix transhuge.rst indentation]
  Link: https://lkml.kernel.org/r/b189d815-998b-4dfd-ba89-218ff51313f8@linux.alibaba.com
[akpm@linux-foundation.org: reflow transhuge.rst addition to 80 cols]
[baolin.wang@linux.alibaba.com: move huge_shmem_orders_lock under CONFIG_SYSFS]
  Link: https://lkml.kernel.org/r/eb34da66-7f12-44f3-a39e-2bcc90c33354@linux.alibaba.com
[akpm@linux-foundation.org: huge_memory.c needs mm_types.h]
Link: https://lkml.kernel.org/r/ffddfa8b3cb4266ff963099ab78cfd7184c57ac7.1718090413.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   25 ++++
 include/linux/huge_mm.h                    |   10 +
 mm/huge_memory.c                           |   12 --
 mm/shmem.c                                 |   96 +++++++++++++++++++
 4 files changed, 135 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -332,6 +332,31 @@ deny
 force
     Force the huge option on for all - very useful for testing;
 
+Shmem can also use "multi-size THP" (mTHP) by adding a new sysfs knob to
+control mTHP allocation:
+'/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled',
+and its value for each mTHP is essentially consistent with the global
+setting.  An 'inherit' option is added to ensure compatibility with these
+global settings.  Conversely, the options 'force' and 'deny' are dropped,
+which are rather testing artifacts from the old ages.
+
+always
+    Attempt to allocate <size> huge pages every time we need a new page;
+
+inherit
+    Inherit the top-level "shmem_enabled" value. By default, PMD-sized hugepages
+    have enabled="inherit" and all other hugepage sizes have enabled="never";
+
+never
+    Do not allocate <size> huge pages;
+
+within_size
+    Only allocate <size> huge page if it will be fully within i_size.
+    Also respect fadvise()/madvise() hints;
+
+advise
+    Only allocate <size> huge pages if requested with fadvise()/madvise();
+
 Need of application restart
 ===========================
 
--- a/include/linux/huge_mm.h~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem
+++ a/include/linux/huge_mm.h
@@ -6,6 +6,7 @@
 #include <linux/mm_types.h>
 
 #include <linux/fs.h> /* only for vma_is_dax() */
+#include <linux/kobject.h>
 
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
@@ -63,6 +64,7 @@ ssize_t single_hugepage_flag_show(struct
 				  struct kobj_attribute *attr, char *buf,
 				  enum transparent_hugepage_flag flag);
 extern struct kobj_attribute shmem_enabled_attr;
+extern struct kobj_attribute thpsize_shmem_enabled_attr;
 
 /*
  * Mask of all large folio orders supported for anonymous THP; all orders up to
@@ -265,6 +267,14 @@ unsigned long thp_vma_allowable_orders(s
 	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
+struct thpsize {
+	struct kobject kobj;
+	struct list_head node;
+	int order;
+};
+
+#define to_thpsize(kobj) container_of(kobj, struct thpsize, kobj)
+
 enum mthp_stat_item {
 	MTHP_STAT_ANON_FAULT_ALLOC,
 	MTHP_STAT_ANON_FAULT_FALLBACK,
--- a/mm/huge_memory.c~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem
+++ a/mm/huge_memory.c
@@ -20,6 +20,7 @@
 #include <linux/swapops.h>
 #include <linux/backing-dev.h>
 #include <linux/dax.h>
+#include <linux/mm_types.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
 #include <linux/pfn_t.h>
@@ -449,14 +450,6 @@ static void thpsize_release(struct kobje
 static DEFINE_SPINLOCK(huge_anon_orders_lock);
 static LIST_HEAD(thpsize_list);
 
-struct thpsize {
-	struct kobject kobj;
-	struct list_head node;
-	int order;
-};
-
-#define to_thpsize(kobj) container_of(kobj, struct thpsize, kobj)
-
 static ssize_t thpsize_enabled_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *buf)
 {
@@ -517,6 +510,9 @@ static struct kobj_attribute thpsize_ena
 
 static struct attribute *thpsize_attrs[] = {
 	&thpsize_enabled_attr.attr,
+#ifdef CONFIG_SHMEM
+	&thpsize_shmem_enabled_attr.attr,
+#endif
 	NULL,
 };
 
--- a/mm/shmem.c~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem
+++ a/mm/shmem.c
@@ -131,6 +131,13 @@ struct shmem_options {
 #define SHMEM_SEEN_QUOTA 32
 };
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static unsigned long huge_shmem_orders_always __read_mostly;
+static unsigned long huge_shmem_orders_madvise __read_mostly;
+static unsigned long huge_shmem_orders_inherit __read_mostly;
+static unsigned long huge_shmem_orders_within_size __read_mostly;
+#endif
+
 #ifdef CONFIG_TMPFS
 static unsigned long shmem_default_max_blocks(void)
 {
@@ -4672,6 +4679,12 @@ void __init shmem_init(void)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
+
+	/*
+	 * Default to setting PMD-sized THP to inherit the global setting and
+	 * disable all other multi-size THPs.
+	 */
+	huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
 #endif
 	return;
 
@@ -4731,6 +4744,11 @@ static ssize_t shmem_enabled_store(struc
 			huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
 		return -EINVAL;
 
+	/* Do not override huge allocation policy with non-PMD sized mTHP */
+	if (huge == SHMEM_HUGE_FORCE &&
+	    huge_shmem_orders_inherit != BIT(HPAGE_PMD_ORDER))
+		return -EINVAL;
+
 	shmem_huge = huge;
 	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
@@ -4738,6 +4756,84 @@ static ssize_t shmem_enabled_store(struc
 }
 
 struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
+static DEFINE_SPINLOCK(huge_shmem_orders_lock);
+
+static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	int order = to_thpsize(kobj)->order;
+	const char *output;
+
+	if (test_bit(order, &huge_shmem_orders_always))
+		output = "[always] inherit within_size advise never";
+	else if (test_bit(order, &huge_shmem_orders_inherit))
+		output = "always [inherit] within_size advise never";
+	else if (test_bit(order, &huge_shmem_orders_within_size))
+		output = "always inherit [within_size] advise never";
+	else if (test_bit(order, &huge_shmem_orders_madvise))
+		output = "always inherit within_size [advise] never";
+	else
+		output = "always inherit within_size advise [never]";
+
+	return sysfs_emit(buf, "%s\n", output);
+}
+
+static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
+					   struct kobj_attribute *attr,
+					   const char *buf, size_t count)
+{
+	int order = to_thpsize(kobj)->order;
+	ssize_t ret = count;
+
+	if (sysfs_streq(buf, "always")) {
+		spin_lock(&huge_shmem_orders_lock);
+		clear_bit(order, &huge_shmem_orders_inherit);
+		clear_bit(order, &huge_shmem_orders_madvise);
+		clear_bit(order, &huge_shmem_orders_within_size);
+		set_bit(order, &huge_shmem_orders_always);
+		spin_unlock(&huge_shmem_orders_lock);
+	} else if (sysfs_streq(buf, "inherit")) {
+		/* Do not override huge allocation policy with non-PMD sized mTHP */
+		if (shmem_huge == SHMEM_HUGE_FORCE &&
+		    order != HPAGE_PMD_ORDER)
+			return -EINVAL;
+
+		spin_lock(&huge_shmem_orders_lock);
+		clear_bit(order, &huge_shmem_orders_always);
+		clear_bit(order, &huge_shmem_orders_madvise);
+		clear_bit(order, &huge_shmem_orders_within_size);
+		set_bit(order, &huge_shmem_orders_inherit);
+		spin_unlock(&huge_shmem_orders_lock);
+	} else if (sysfs_streq(buf, "within_size")) {
+		spin_lock(&huge_shmem_orders_lock);
+		clear_bit(order, &huge_shmem_orders_always);
+		clear_bit(order, &huge_shmem_orders_inherit);
+		clear_bit(order, &huge_shmem_orders_madvise);
+		set_bit(order, &huge_shmem_orders_within_size);
+		spin_unlock(&huge_shmem_orders_lock);
+	} else if (sysfs_streq(buf, "madvise")) {
+		spin_lock(&huge_shmem_orders_lock);
+		clear_bit(order, &huge_shmem_orders_always);
+		clear_bit(order, &huge_shmem_orders_inherit);
+		clear_bit(order, &huge_shmem_orders_within_size);
+		set_bit(order, &huge_shmem_orders_madvise);
+		spin_unlock(&huge_shmem_orders_lock);
+	} else if (sysfs_streq(buf, "never")) {
+		spin_lock(&huge_shmem_orders_lock);
+		clear_bit(order, &huge_shmem_orders_always);
+		clear_bit(order, &huge_shmem_orders_inherit);
+		clear_bit(order, &huge_shmem_orders_within_size);
+		clear_bit(order, &huge_shmem_orders_madvise);
+		spin_unlock(&huge_shmem_orders_lock);
+	} else {
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+struct kobj_attribute thpsize_shmem_enabled_attr =
+	__ATTR(shmem_enabled, 0644, thpsize_shmem_enabled_show, thpsize_shmem_enabled_store);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SYSFS */
 
 #else /* !CONFIG_SHMEM */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


