From: akpm@linux-foundation.org
Subject: + mm-introduce-arch_reserved_kernel_pages.patch added to -mm tree
Date: Mon, 29 Aug 2016 16:07:47 -0700
Message-ID: <57c4c043.RCNRvFw27WK7Tf1W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39461 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbcH2XHu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 19:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srikar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dave.hansen@intel.com, hbathini@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, mpe@ellerman.id.au, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce arch_reserved_kernel_pages()
has been added to the -mm tree.  Its filename is
     mm-introduce-arch_reserved_kernel_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-arch_reserved_kernel_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-arch_reserved_kernel_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: mm: introduce arch_reserved_kernel_pages()

Currently arch specific code can reserve memory blocks but
alloc_large_system_hash() may not take it into consideration when sizing
the hashes.  This can lead to bigger hash than required and lead to no
available memory for other purposes.  This is specifically true for
systems with CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled.

One approach to solve this problem would be to walk through the memblock
regions and calculate the available memory and base the size of hash
system on the available memory.

The other approach would be to depend on the architecture to provide the
number of pages that are reserved.  This change provides hooks to allow
the architecture to provide the required info.

Link: http://lkml.kernel.org/r/1472476010-4709-2-git-send-email-srikar@linux.vnet.ibm.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Hari Bathini <hbathini@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +++
 mm/page_alloc.c    |   12 ++++++++++++
 2 files changed, 15 insertions(+)

diff -puN include/linux/mm.h~mm-introduce-arch_reserved_kernel_pages include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-arch_reserved_kernel_pages
+++ a/include/linux/mm.h
@@ -1924,6 +1924,9 @@ extern void show_mem(unsigned int flags)
 extern long si_mem_available(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
+#ifdef __HAVE_ARCH_RESERVED_KERNEL_PAGES
+extern unsigned long arch_reserved_kernel_pages(void);
+#endif
 
 extern __printf(3, 4)
 void warn_alloc_failed(gfp_t gfp_mask, unsigned int order,
diff -puN mm/page_alloc.c~mm-introduce-arch_reserved_kernel_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-arch_reserved_kernel_pages
+++ a/mm/page_alloc.c
@@ -6944,6 +6944,17 @@ static int __init set_hashdist(char *str
 __setup("hashdist=", set_hashdist);
 #endif
 
+#ifndef __HAVE_ARCH_RESERVED_KERNEL_PAGES
+/*
+ * Returns the number of pages that arch has reserved but
+ * is not known to alloc_large_system_hash().
+ */
+static unsigned long __init arch_reserved_kernel_pages(void)
+{
+	return 0;
+}
+#endif
+
 /*
  * allocate a large system hash table from bootmem
  * - it is assumed that the hash table must contain an exact power-of-2
@@ -6968,6 +6979,7 @@ void *__init alloc_large_system_hash(con
 	if (!numentries) {
 		/* round applicable memory size up to nearest megabyte */
 		numentries = nr_kernel_pages;
+		numentries -= arch_reserved_kernel_pages();
 
 		/* It isn't necessary when PAGE_SIZE >= 1MB */
 		if (PAGE_SHIFT < 20)
_

Patches currently in -mm which might be from srikar@linux.vnet.ibm.com are

mm-page_alloc-replace-set_dma_reserve-to-set_memory_reserve.patch
fadump-register-the-memory-reserved-by-fadump.patch
mm-introduce-arch_reserved_kernel_pages.patch
mm-memblock-expose-total-reserved-memory.patch
powerpc-implement-arch_reserved_kernel_pages.patch

