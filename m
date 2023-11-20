Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4D8C197A0
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjKTScM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjKTScL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:32:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F0292
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:32:08 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BC8C433C8;
        Mon, 20 Nov 2023 18:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700505128;
        bh=BQ0d7n/VUttSQsWiyp5hYg1Awgrddg4tNTeI02VmjkY=;
        h=Date:To:From:Subject:From;
        b=nHpubDxjOOwqsdENgpLuLd0WJoOQ5QnVWuhQFUNJlkOT5VQskNGhXQrbx4kvT2AE9
         2xNcZKwT3GZhWVPpzF6kJNCTH/4N1k+Yq44Zw+yBpAVH0/TEJ7C2RxKPDHETvEI3TS
         V4VuSxtVrYM1yMheUl6AbGZ+xcB7ssRZ5D+Gxys4=
Date:   Mon, 20 Nov 2023 10:32:07 -0800
To:     mm-commits@vger.kernel.org, osalvador@suse.de, mhocko@suse.com,
        lkp@intel.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com, sumanthk@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-vmem_altmap-code-without-config_zone_device.patch added to mm-unstable branch
Message-Id: <20231120183208.10BC8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vmem_altmap code without CONFIG_ZONE_DEVICE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-vmem_altmap-code-without-config_zone_device.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-vmem_altmap-code-without-config_zone_device.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-memory_hotplug-add-missing-mem_hotplug_lock.patch
mm-memory_hotplug-fix-error-handling-in-add_memory_resource.patch
mm-use-vmem_altmap-code-without-config_zone_device.patch

