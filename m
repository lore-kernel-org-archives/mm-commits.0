Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37092C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjBCGjY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjBCGh1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6039F8E060
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EB9EB8297E
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0418C433D2;
        Fri,  3 Feb 2023 06:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406200;
        bh=eh9AvaBScOjZ8GNibmbOoqxetxXrKmMmHpqdv5bM0wc=;
        h=Date:To:From:Subject:From;
        b=SmcUEaxhhiFmqSMGWKNAfbd6Csl/UAYClqTYSQ/PjaLXQdpYOBhS6/Pt0O4A9GZQO
         GrBwqxD2JpdDZg9DYbFEcs3OAihrWEfto8irJbtL/N9olLDJePqHvtF5+pimApUtia
         IDapwL3SNQ+Q4aeeIp9zhBzGN9r48VqJ7qVxTxHA=
Date:   Thu, 02 Feb 2023 22:36:40 -0800
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nios2-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063640.A0418C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     nios2-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: nios2/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:14 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by using the yet-unused bit
31.

Link: https://lkml.kernel.org/r/20230113171026.582290-15-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/nios2/include/asm/pgtable-bits.h~nios2-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/nios2/include/asm/pgtable-bits.h
@@ -31,4 +31,7 @@
 #define _PAGE_ACCESSED	(1<<26)	/* page referenced */
 #define _PAGE_DIRTY	(1<<27)	/* dirty page */
 
+/* We borrow bit 31 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	(1<<31)
+
 #endif /* _ASM_NIOS2_PGTABLE_BITS_H */
--- a/arch/nios2/include/asm/pgtable.h~nios2-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/nios2/include/asm/pgtable.h
@@ -239,7 +239,9 @@ static inline unsigned long pmd_page_vad
  *
  *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
  *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
- *   0 < type -> 0 0 0 0 0 0 <-------------- offset --------------->
+ *   E < type -> 0 0 0 0 0 0 <-------------- offset --------------->
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
  *
  * Note that the offset field is always non-zero if the swap type is 0, thus
  * !pte_none() is always true.
@@ -251,6 +253,24 @@ static inline unsigned long pmd_page_vad
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_SWP_EXCLUSIVE;
+	return pte;
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_SWP_EXCLUSIVE;
+	return pte;
+}
+
 extern void __init paging_init(void);
 extern void __init mmu_init(void);
 
_

Patches currently in -mm which might be from david@redhat.com are


