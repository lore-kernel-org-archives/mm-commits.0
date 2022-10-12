Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D894EC4167B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJLW64 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiJLW60 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:58:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7075612792C
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F437B819BB
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4791C433B5;
        Wed, 12 Oct 2022 22:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615468;
        bh=0R74aLvgzuSnfzIayWBuszafMzttISj/nRKP8lifEsE=;
        h=Date:To:From:Subject:From;
        b=Ap8VaOQ0e8ZiPCSA9KDL3lgLJbrob7SywxKMWhdQzT7Ym48lrgtyi1CcifKoYY/z7
         fAblkj8kGX0CbHaqEI+Dz/1Cvsj9hru+PNfGp8+CmTI+1dJmtTzNVwFadQyDUI91hv
         R1T8aprfn4lO2nS/CPM0ZCFysfYisdIMzrf3vRI0=
Date:   Wed, 12 Oct 2022 15:57:48 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, lkp@intel.com, hch@lst.de,
        fmdefrancesco@gmail.com, ira.weiny@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] highmem-fix-kmap_to_page-for-kmap_local_page-addresses.patch removed from -mm tree
Message-Id: <20221012225748.C4791C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: highmem: fix kmap_to_page() for kmap_local_page() addresses
has been removed from the -mm tree.  Its filename was
     highmem-fix-kmap_to_page-for-kmap_local_page-addresses.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ira Weiny <ira.weiny@intel.com>
Subject: highmem: fix kmap_to_page() for kmap_local_page() addresses
Date: Wed, 5 Oct 2022 21:05:55 -0700

kmap_to_page() is used to get the page for a virtual address which may
be kmap'ed.  Unfortunately, kmap_local_page() stores mappings in a
thread local array separate from kmap().  These mappings were not
checked by the call.

Check the kmap_local_page() mappings and return the page if found.

Because it is intended to remove kmap_to_page() add a warn on once to
the kmap checks to flag potential issues early.

NOTE Due to 32bit x86 use of kmap local in iomap atmoic, KMAP_LOCAL does
not require HIGHMEM to be set.  Therefore the support calls required a
new KMAP_LOCAL section to fix 0day build errors.

[akpm@linux-foundation.org: fix warning]
Link: https://lkml.kernel.org/r/20221006040555.1502679-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: kernel test robot <lkp@intel.com>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

--- a/mm/highmem.c~highmem-fix-kmap_to_page-for-kmap_local_page-addresses
+++ a/mm/highmem.c
@@ -30,6 +30,17 @@
 #include <asm/tlbflush.h>
 #include <linux/vmalloc.h>
 
+#ifdef CONFIG_KMAP_LOCAL
+static inline int kmap_local_calc_idx(int idx)
+{
+	return idx + KM_MAX_IDX * smp_processor_id();
+}
+
+#ifndef arch_kmap_local_map_idx
+#define arch_kmap_local_map_idx(idx, pfn)	kmap_local_calc_idx(idx)
+#endif
+#endif /* CONFIG_KMAP_LOCAL */
+
 /*
  * Virtual_count is not a pure "count".
  *  0 means that it is not mapped, and has not been mapped
@@ -142,12 +153,29 @@ pte_t *pkmap_page_table;
 
 struct page *__kmap_to_page(void *vaddr)
 {
+	unsigned long base = (unsigned long) vaddr & PAGE_MASK;
+	struct kmap_ctrl *kctrl = &current->kmap_ctrl;
 	unsigned long addr = (unsigned long)vaddr;
+	int i;
 
-	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
-		int i = PKMAP_NR(addr);
+	/* kmap() mappings */
+	if (WARN_ON_ONCE(addr >= PKMAP_ADDR(0) &&
+			 addr < PKMAP_ADDR(LAST_PKMAP)))
+		return pte_page(pkmap_page_table[PKMAP_NR(addr)]);
+
+	/* kmap_local_page() mappings */
+	if (WARN_ON_ONCE(base >= __fix_to_virt(FIX_KMAP_END) &&
+			 base < __fix_to_virt(FIX_KMAP_BEGIN))) {
+		for (i = 0; i < kctrl->idx; i++) {
+			unsigned long base_addr;
+			int idx;
 
-		return pte_page(pkmap_page_table[i]);
+			idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
+			base_addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+
+			if (base_addr == base)
+				return pte_page(kctrl->pteval[i]);
+		}
 	}
 
 	return virt_to_page(vaddr);
@@ -462,10 +490,6 @@ static inline void kmap_local_idx_pop(vo
 # define arch_kmap_local_post_unmap(vaddr)		do { } while (0)
 #endif
 
-#ifndef arch_kmap_local_map_idx
-#define arch_kmap_local_map_idx(idx, pfn)	kmap_local_calc_idx(idx)
-#endif
-
 #ifndef arch_kmap_local_unmap_idx
 #define arch_kmap_local_unmap_idx(idx, vaddr)	kmap_local_calc_idx(idx)
 #endif
@@ -494,11 +518,6 @@ static inline bool kmap_high_unmap_local
 	return false;
 }
 
-static inline int kmap_local_calc_idx(int idx)
-{
-	return idx + KM_MAX_IDX * smp_processor_id();
-}
-
 static pte_t *__kmap_pte;
 
 static pte_t *kmap_get_pte(unsigned long vaddr, int idx)
_

Patches currently in -mm which might be from ira.weiny@intel.com are


