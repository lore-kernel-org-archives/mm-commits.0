From: akpm@linux-foundation.org
Subject: + ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:49:11 -0800
Message-ID: <20130206224912.1975431C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:34625 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab3BFWtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:49:13 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so210972qen.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:49:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: ia64: use %ld to print pages calculated in nr_free_buffer_pages
has been added to the -mm tree.  Its filename is
     ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch

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

mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

