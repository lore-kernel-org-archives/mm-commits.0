From: akpm@linux-foundation.org
Subject: [merged] vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:25 -0800
Message-ID: <20130225205525.994C25A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:49031 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826Ab3BYUz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:26 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so347150ves.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: change type of vm_total_pages to unsigned long
has been removed from the -mm tree.  Its filename was
     vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: vmscan: change type of vm_total_pages to unsigned long

This variable is calculated from nr_free_pagecache_pages so
change its type to unsigned long.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/vmscan.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~vmscan-change-type-of-vm_total_pages-to-unsigned-long include/linux/swap.h
--- a/include/linux/swap.h~vmscan-change-type-of-vm_total_pages-to-unsigned-long
+++ a/include/linux/swap.h
@@ -275,7 +275,7 @@ extern unsigned long mem_cgroup_shrink_n
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
-extern long vm_total_pages;
+extern unsigned long vm_total_pages;
 
 #ifdef CONFIG_NUMA
 extern int zone_reclaim_mode;
diff -puN mm/vmscan.c~vmscan-change-type-of-vm_total_pages-to-unsigned-long mm/vmscan.c
--- a/mm/vmscan.c~vmscan-change-type-of-vm_total_pages-to-unsigned-long
+++ a/mm/vmscan.c
@@ -128,7 +128,7 @@ struct scan_control {
  * From 0 .. 100.  Higher means more swappy.
  */
 int vm_swappiness = 60;
-long vm_total_pages;	/* The total number of pages which the VM controls */
+unsigned long vm_total_pages;	/* The total number of pages which the VM controls */
 
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch
kexec-prevent-double-free-on-image-allocation-failure.patch
kexec-fix-memory-leak-in-function-kimage_normal_alloc.patch
kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch

