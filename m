Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 589CFC433FE
	for <mm-commits@archiver.kernel.org>; Thu,  6 Oct 2022 20:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiJFUe3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Oct 2022 16:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiJFUeU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2022 16:34:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A7CC45BA
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 13:34:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67C5E61AFE
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 20:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6E7C433C1;
        Thu,  6 Oct 2022 20:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665088457;
        bh=OmtDJi8YBxqoxxY3P8bSNDIciCpmNOrsnxqDEwNlnx8=;
        h=Date:To:From:Subject:From;
        b=iLKA0ALZYDjEDO9xFliQk7Aigw8ZhBI8wtdqmYfQ7nLsQwtIuyRplpOnxAyZXtymi
         ZVN72U7edwH+T8Bf1H+G+2utIlUzCELmKlgANXZ2FQ7/oJdSxgZCQs2C1vhNsCANcw
         CR/yR+dRYZh6IApWhap+gz9i6ek2IAhzFtJgkuwY=
Date:   Thu, 06 Oct 2022 13:34:17 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, lkp@intel.com, hch@lst.de,
        fmdefrancesco@gmail.com, ira.weiny@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-fix-kmap_to_page-for-kmap_local_page-addresses.patch added to mm-unstable branch
Message-Id: <20221006203417.BC6E7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: fix kmap_to_page() for kmap_local_page() addresses
has been added to the -mm mm-unstable branch.  Its filename is
     highmem-fix-kmap_to_page-for-kmap_local_page-addresses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-fix-kmap_to_page-for-kmap_local_page-addresses.patch

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

Link: https://lkml.kernel.org/r/20221006040555.1502679-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: kernel test robot <lkp@intel.com>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |   42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

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
@@ -142,14 +153,34 @@ pte_t *pkmap_page_table;
 
 struct page *__kmap_to_page(void *vaddr)
 {
+	unsigned long base = (unsigned long) vaddr & PAGE_MASK;
+	struct kmap_ctrl *kctrl = &current->kmap_ctrl;
 	unsigned long addr = (unsigned long)vaddr;
+	int i;
 
-	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
+	/* kmap() mappings */
+	if (WARN_ON_ONCE(addr >= PKMAP_ADDR(0) &&
+			 addr < PKMAP_ADDR(LAST_PKMAP))) {
 		int i = PKMAP_NR(addr);
 
 		return pte_page(pkmap_page_table[i]);
 	}
 
+	/* kmap_local_page() mappings */
+	if (WARN_ON_ONCE(base >= __fix_to_virt(FIX_KMAP_END) &&
+			 base < __fix_to_virt(FIX_KMAP_BEGIN))) {
+		for (i = 0; i < kctrl->idx; i++) {
+			unsigned long base_addr;
+			int idx;
+
+			idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
+			base_addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+
+			if (base_addr == base)
+				return pte_page(kctrl->pteval[i]);
+		}
+	}
+
 	return virt_to_page(vaddr);
 }
 EXPORT_SYMBOL(__kmap_to_page);
@@ -462,10 +493,6 @@ static inline void kmap_local_idx_pop(vo
 # define arch_kmap_local_post_unmap(vaddr)		do { } while (0)
 #endif
 
-#ifndef arch_kmap_local_map_idx
-#define arch_kmap_local_map_idx(idx, pfn)	kmap_local_calc_idx(idx)
-#endif
-
 #ifndef arch_kmap_local_unmap_idx
 #define arch_kmap_local_unmap_idx(idx, vaddr)	kmap_local_calc_idx(idx)
 #endif
@@ -494,11 +521,6 @@ static inline bool kmap_high_unmap_local
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

highmem-fix-kmap_to_page-for-kmap_local_page-addresses.patch

