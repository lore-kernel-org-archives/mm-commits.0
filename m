Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295975246
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q1RmRx2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F98C433C9;
	Mon, 11 Dec 2023 00:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256109;
	bh=0QgvqnmPO+Tg63Fq7fxk0rNMZicyvgtvyv53cHH+k/A=;
	h=Date:To:From:Subject:From;
	b=Q1RmRx2AKYNqf1350uahrFXd0Qvi+xzecKGEA405elh7bQ1l0KVFQlYmg+hBR3AX9
	 qIDrbQNGwws2i/GDxxRgUIi7D7yhOy9TvCSQlGavfd+8pXH1sh2RRyczZEKstrs/Co
	 FxtiFd9ZcMPmAKfEz+e7z09Fv9zV+70F5vD/vFCo=
Date: Sun, 10 Dec 2023 16:55:08 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,mhocko@suse.com,lkp@intel.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-vmem_altmap-code-without-config_zone_device.patch removed from -mm tree
Message-Id: <20231211005508.E7F98C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use vmem_altmap code without CONFIG_ZONE_DEVICE
has been removed from the -mm tree.  Its filename was
     mm-use-vmem_altmap-code-without-config_zone_device.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: mm: use vmem_altmap code without CONFIG_ZONE_DEVICE
Date: Mon, 20 Nov 2023 15:53:54 +0100

vmem_altmap_free() and vmem_altmap_offset() could be utlized without
CONFIG_ZONE_DEVICE enabled.  For example,
mm/memory_hotplug.c:__add_pages() relies on that.  The altmap is no longer
restricted to ZONE_DEVICE handling, but instead depends on
CONFIG_SPARSEMEM_VMEMMAP.

When CONFIG_SPARSEMEM_VMEMMAP is disabled, these functions are defined as
inline stubs, ensuring compatibility with configurations that do not use
sparsemem vmemmap.  Without it, lkp reported the following:

ld: arch/x86/mm/init_64.o: in function `remove_pagetable':
init_64.c:(.meminit.text+0xfc7): undefined reference to
`vmem_altmap_free'

Link: https://lkml.kernel.org/r/20231120145354.308999-4-sumanthk@linux.ibm.com
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311180545.VeyRXEDq-lkp@intel.com/
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   12 ------------
 include/linux/mm.h       |   26 ++++++++++++++++++++++++++
 mm/memremap.c            |   14 +-------------
 3 files changed, 27 insertions(+), 25 deletions(-)

--- a/include/linux/memremap.h~mm-use-vmem_altmap-code-without-config_zone_device
+++ a/include/linux/memremap.h
@@ -196,8 +196,6 @@ struct dev_pagemap *get_dev_pagemap(unsi
 		struct dev_pagemap *pgmap);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
-unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
-void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
 unsigned long memremap_compat_align(void);
 #else
 static inline void *devm_memremap_pages(struct device *dev,
@@ -228,16 +226,6 @@ static inline bool pgmap_pfn_valid(struc
 	return false;
 }
 
-static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
-{
-	return 0;
-}
-
-static inline void vmem_altmap_free(struct vmem_altmap *altmap,
-		unsigned long nr_pfns)
-{
-}
-
 /* when memremap_pages() is disabled all archs can remap a single page */
 static inline unsigned long memremap_compat_align(void)
 {
--- a/include/linux/mm.h~mm-use-vmem_altmap-code-without-config_zone_device
+++ a/include/linux/mm.h
@@ -3871,6 +3871,32 @@ void vmemmap_free(unsigned long start, u
 		struct vmem_altmap *altmap);
 #endif
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
+{
+	/* number of pfns from base where pfn_to_page() is valid */
+	if (altmap)
+		return altmap->reserve + altmap->free;
+	return 0;
+}
+
+static inline void vmem_altmap_free(struct vmem_altmap *altmap,
+				    unsigned long nr_pfns)
+{
+	altmap->alloc -= nr_pfns;
+}
+#else
+static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
+{
+	return 0;
+}
+
+static inline void vmem_altmap_free(struct vmem_altmap *altmap,
+				    unsigned long nr_pfns)
+{
+}
+#endif
+
 #define VMEMMAP_RESERVE_NR	2
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
--- a/mm/memremap.c~mm-use-vmem_altmap-code-without-config_zone_device
+++ a/mm/memremap.c
@@ -7,6 +7,7 @@
 #include <linux/memremap.h>
 #include <linux/pfn_t.h>
 #include <linux/swap.h>
+#include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/swapops.h>
 #include <linux/types.h>
@@ -422,19 +423,6 @@ void devm_memunmap_pages(struct device *
 }
 EXPORT_SYMBOL_GPL(devm_memunmap_pages);
 
-unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
-{
-	/* number of pfns from base where pfn_to_page() is valid */
-	if (altmap)
-		return altmap->reserve + altmap->free;
-	return 0;
-}
-
-void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns)
-{
-	altmap->alloc -= nr_pfns;
-}
-
 /**
  * get_dev_pagemap() - take a new live reference on the dev_pagemap for @pfn
  * @pfn: page frame number to lookup page_map
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are


