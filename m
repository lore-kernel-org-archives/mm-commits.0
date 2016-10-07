From: akpm@linux-foundation.org
Subject: [patch 049/127] mm: introduce arch_reserved_kernel_pages()
Date: Fri, 07 Oct 2016 16:59:15 -0700
Message-ID: <57f836d3.HM0o6g2A3XWHQGsR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39197 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754882AbcJHAAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, srikar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dave.hansen@intel.com, hbathini@linux.vnet.ibm.com, mahesh@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, mpe@ellerman.id.au, vbabka@suse.cz

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
@@ -6940,6 +6940,17 @@ static int __init set_hashdist(char *str
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
@@ -6964,6 +6975,7 @@ void *__init alloc_large_system_hash(con
 	if (!numentries) {
 		/* round applicable memory size up to nearest megabyte */
 		numentries = nr_kernel_pages;
+		numentries -= arch_reserved_kernel_pages();
 
 		/* It isn't necessary when PAGE_SIZE >= 1MB */
 		if (PAGE_SHIFT < 20)
_
