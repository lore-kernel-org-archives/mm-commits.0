From: akpm@osdl.org
Subject: - silence-unused-pgdat-warning-from-alloc_bootmem_node-and-friends.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:57:54 -0800
Message-ID: <200612072257.kB7Mvsd5029335@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163648AbWLGW6a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, ak@suse.de, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     silence unused pgdat warning from alloc_bootmem_node and friends
has been removed from the -mm tree.  Its filename was
     silence-unused-pgdat-warning-from-alloc_bootmem_node-and-friends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: silence unused pgdat warning from alloc_bootmem_node and friends
From: Andy Whitcroft <apw@shadowen.org>

x86 NUMA systems only define bootmem for node 0.  alloc_bootmem_node() and
friends therefore ignore the passed pgdat and use NODE_DATA(0) in all
cases.  This leads to the following warnings as we are not using the passed
parameter:

  .../mm/page_alloc.c: In function 'zone_wait_table_init':
  .../mm/page_alloc.c:2259: warning: unused variable 'pgdat'

One option would be to define all variables used with these macros
__attribute__ ((unused)), but this would leave us exposed should these
become genuinely unused.

The key here is that we _are_ using the value, we ignore it but that is a
deliberate action.  This patch adds a nested local variable within the
alloc_bootmem_node helper to which the pgdat parameter is assigned making
it 'used'.  The nested local is marked __attribute__ ((unused)) to silence
this same warning for it.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-i386/mmzone.h |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff -puN include/asm-i386/mmzone.h~silence-unused-pgdat-warning-from-alloc_bootmem_node-and-friends include/asm-i386/mmzone.h
--- a/include/asm-i386/mmzone.h~silence-unused-pgdat-warning-from-alloc_bootmem_node-and-friends
+++ a/include/asm-i386/mmzone.h
@@ -120,13 +120,26 @@ static inline int pfn_valid(int pfn)
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low_pages(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0)
-#define alloc_bootmem_node(ignore, x) \
-	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_pages_node(ignore, x) \
-	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_low_pages_node(ignore, x) \
-	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0)
-
+#define alloc_bootmem_node(pgdat, x)					\
+({									\
+	struct pglist_data  __attribute__ ((unused))			\
+				*__alloc_bootmem_node__pgdat = (pgdat);	\
+	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES,	\
+						__pa(MAX_DMA_ADDRESS));	\
+})
+#define alloc_bootmem_pages_node(pgdat, x)				\
+({									\
+	struct pglist_data  __attribute__ ((unused))			\
+				*__alloc_bootmem_node__pgdat = (pgdat);	\
+	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE,		\
+						__pa(MAX_DMA_ADDRESS))	\
+})
+#define alloc_bootmem_low_pages_node(pgdat, x)				\
+({									\
+	struct pglist_data  __attribute__ ((unused))			\
+				*__alloc_bootmem_node__pgdat = (pgdat);	\
+	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0);		\
+})
 #endif /* CONFIG_NEED_MULTIPLE_NODES */
 
 #endif /* _ASM_MMZONE_H_ */
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
git-acpi.patch
pci-device-ensure-sysdata-initialised-v2.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
optional-zone_dma-in-the-vm.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch

