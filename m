From: akpm@linux-foundation.org
Subject: [merged] ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:16 -0800
Message-ID: <20130225205516.9FC5531C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:46901 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab3BYUzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:17 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347725ghb.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: use %ld to print pages calculated in nr_free_buffer_pages
has been removed from the -mm tree.  Its filename was
     ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: ia64: use %ld to print pages calculated in nr_free_buffer_pages

Now the function nr_free_buffer_pages returns unsigned long, so use %ld to
print its return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/contig.c    |    2 +-
 arch/ia64/mm/discontig.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/ia64/mm/contig.c~ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages
+++ a/arch/ia64/mm/contig.c
@@ -93,7 +93,7 @@ void show_mem(unsigned int filter)
 	printk(KERN_INFO "%d pages swap cached\n", total_cached);
 	printk(KERN_INFO "Total of %ld pages in page table cache\n",
 	       quicklist_total_size());
-	printk(KERN_INFO "%d free buffer pages\n", nr_free_buffer_pages());
+	printk(KERN_INFO "%ld free buffer pages\n", nr_free_buffer_pages());
 }
 
 
diff -puN arch/ia64/mm/discontig.c~ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages
+++ a/arch/ia64/mm/discontig.c
@@ -666,7 +666,7 @@ void show_mem(unsigned int filter)
 	printk(KERN_INFO "%d pages swap cached\n", total_cached);
 	printk(KERN_INFO "Total of %ld pages in page table cache\n",
 	       quicklist_total_size());
-	printk(KERN_INFO "%d free buffer pages\n", nr_free_buffer_pages());
+	printk(KERN_INFO "%ld free buffer pages\n", nr_free_buffer_pages());
 }
 
 /**
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

