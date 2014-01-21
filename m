From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch removed from -mm tree
Date: Tue, 21 Jan 2014 15:30:39 -0800
Message-ID: <52df031f.TLLVhxRUO2YyNLgB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaAUXak (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:30:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmarchan@redhat.com, dave.hansen@linux.intel.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org

Subject: [folded-merged] mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch removed from -mm tree
To: akpm@linux-foundation.org,alan@lxorguk.ukuu.org.uk,dave.hansen@linux.intel.com,jmarchan@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:30:39 -0800


The patch titled
     Subject: mm-add-overcommit_kbytes-sysctl-variable-fix-2
has been removed from the -mm tree.  Its filename was
     mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch

This patch was dropped because it was folded into mm-add-overcommit_kbytes-sysctl-variable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-overcommit_kbytes-sysctl-variable-fix-2

fix nommu build

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   24 ------------------------
 mm/util.c |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff -puN mm/mmap.c~mm-add-overcommit_kbytes-sysctl-variable-fix-2 mm/mmap.c
--- a/mm/mmap.c~mm-add-overcommit_kbytes-sysctl-variable-fix-2
+++ a/mm/mmap.c
@@ -96,30 +96,6 @@ unsigned long sysctl_admin_reserve_kbyte
  */
 struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
 
-int overcommit_ratio_handler(struct ctl_table *table, int write,
-			     void __user *buffer, size_t *lenp,
-			     loff_t *ppos)
-{
-	int ret;
-
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-	if (ret == 0 && write)
-		sysctl_overcommit_kbytes = 0;
-	return ret;
-}
-
-int overcommit_kbytes_handler(struct ctl_table *table, int write,
-			     void __user *buffer, size_t *lenp,
-			     loff_t *ppos)
-{
-	int ret;
-
-	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
-	if (ret == 0 && write)
-		sysctl_overcommit_ratio = 0;
-	return ret;
-}
-
 /*
  * The global memory commitment made in the system can be a metric
  * that can be used to drive ballooning decisions when Linux is hosted
diff -puN mm/util.c~mm-add-overcommit_kbytes-sysctl-variable-fix-2 mm/util.c
--- a/mm/util.c~mm-add-overcommit_kbytes-sysctl-variable-fix-2
+++ a/mm/util.c
@@ -404,6 +404,30 @@ struct address_space *page_mapping(struc
 	return mapping;
 }
 
+int overcommit_ratio_handler(struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp,
+			     loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret == 0 && write)
+		sysctl_overcommit_kbytes = 0;
+	return ret;
+}
+
+int overcommit_kbytes_handler(struct ctl_table *table, int write,
+			     void __user *buffer, size_t *lenp,
+			     loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
+	if (ret == 0 && write)
+		sysctl_overcommit_ratio = 0;
+	return ret;
+}
+
 /*
  * Committed memory limit enforced when OVERCOMMIT_NEVER policy is used
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
posix_acl-uninlining.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-add-overcommit_kbytes-sysctl-variable.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

