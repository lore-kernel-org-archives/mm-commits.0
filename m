From: akpm@linux-foundation.org
Subject: + mm-cma-split-cma-reserved-in-dmesg-log.patch added to -mm tree
Date: Wed, 22 Oct 2014 13:00:55 -0700
Message-ID: <54480cf7.GJla4Cy+/9S00+ss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbaJVUAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Oct 2014 16:00:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pintu.k@samsung.com, aquini@redhat.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, m.szyprowski@samsung.com, mina86@mina86.com, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: split cma-reserved in dmesg log
has been added to the -mm tree.  Its filename is
     mm-cma-split-cma-reserved-in-dmesg-log.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-split-cma-reserved-in-dmesg-log.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-split-cma-reserved-in-dmesg-log.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pintu Kumar <pintu.k@samsung.com>
Subject: mm: cma: split cma-reserved in dmesg log

When the system boots up, in the dmesg logs we can see the memory
statistics along with total reserved as below.  Memory: 458840k/458840k
available, 65448k reserved, 0K highmem

When CMA is enabled, still the total reserved memory remains the same. 
However, the CMA memory is not considered as reserved.  But, when we see
/proc/meminfo, the CMA memory is part of free memory.  This creates
confusion.  This patch corrects the problem by properly subtracting the
CMA reserved memory from the total reserved memory in dmesg logs.

Below is the dmesg snapshot from an arm based device with 512MB RAM and
12MB single CMA region.

Before this change:
Memory: 458840k/458840k available, 65448k reserved, 0K highmem

After this change:
Memory: 458840k/458840k available, 53160k reserved, 12288k cma-reserved, 0K highmem

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    1 +
 mm/cma.c            |    1 +
 mm/page_alloc.c     |    6 ++++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/cma.h~mm-cma-split-cma-reserved-in-dmesg-log include/linux/cma.h
--- a/include/linux/cma.h~mm-cma-split-cma-reserved-in-dmesg-log
+++ a/include/linux/cma.h
@@ -15,6 +15,7 @@
 
 struct cma;
 
+extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(struct cma *cma);
 extern unsigned long cma_get_size(struct cma *cma);
 
diff -puN mm/cma.c~mm-cma-split-cma-reserved-in-dmesg-log mm/cma.c
--- a/mm/cma.c~mm-cma-split-cma-reserved-in-dmesg-log
+++ a/mm/cma.c
@@ -288,6 +288,7 @@ int __init cma_declare_contiguous(phys_a
 	if (ret)
 		goto err;
 
+	totalcma_pages += (size / PAGE_SIZE);
 	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
 		(unsigned long)base);
 	return 0;
diff -puN mm/page_alloc.c~mm-cma-split-cma-reserved-in-dmesg-log mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-split-cma-reserved-in-dmesg-log
+++ a/mm/page_alloc.c
@@ -110,6 +110,7 @@ static DEFINE_SPINLOCK(managed_page_coun
 
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
+unsigned long totalcma_pages __read_mostly;
 /*
  * When calculating the number of globally allowed dirty pages, there
  * is a certain number of per-zone reserves that should not be
@@ -5520,7 +5521,7 @@ void __init mem_init_print_info(const ch
 
 	pr_info("Memory: %luK/%luK available "
 	       "(%luK kernel code, %luK rwdata, %luK rodata, "
-	       "%luK init, %luK bss, %luK reserved"
+	       "%luK init, %luK bss, %luK reserved, %luK cma-reserved"
 #ifdef	CONFIG_HIGHMEM
 	       ", %luK highmem"
 #endif
@@ -5528,7 +5529,8 @@ void __init mem_init_print_info(const ch
 	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
 	       codesize >> 10, datasize >> 10, rosize >> 10,
 	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
-	       (physpages - totalram_pages) << (PAGE_SHIFT-10),
+	       (physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT-10),
+	       totalcma_pages << (PAGE_SHIFT-10),
 #ifdef	CONFIG_HIGHMEM
 	       totalhigh_pages << (PAGE_SHIFT-10),
 #endif
_

Patches currently in -mm which might be from pintu.k@samsung.com are

vmalloc-replace-printk-with-pr_warn.patch
vmscan-replace-printk-with-pr_err.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

