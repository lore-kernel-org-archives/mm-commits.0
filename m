From: akpm@linux-foundation.org
Subject: + vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:49:18 -0800
Message-ID: <20130206224918.EDAD65A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:46693 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab3BFWtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:49:19 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so210841yen.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:49:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: vmscan: change type of vm_total_pages to unsigned long
has been added to the -mm tree.  Its filename is
     vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

