Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4216CC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjBCGjx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbjBCGih (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:38:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E988C411
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2E68B828B2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A164AC433D2;
        Fri,  3 Feb 2023 06:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406208;
        bh=b20VMfSutMDr3RqOV3nGIh3hsYvbDyl1o/+65NknTBY=;
        h=Date:To:From:Subject:From;
        b=G91In/+a76EzmLVnr5xft24xJOWjPNYu7gOMGpVGRibL6iNsAXlGKh4nS/02jfqIi
         qlMpYiC+dWRmIt8aGw70Q25PyfAFoUo7obxcsDMP6COUmMmbL7/f3+uffWIjymPLtw
         gkwRXo/4NGz2U1ByIuWePomBuNvtIo9O19Wc8pHw=
Date:   Thu, 02 Feb 2023 22:36:48 -0800
To:     mm-commits@vger.kernel.org, davem@davemloft.net, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit.patch removed from -mm tree
Message-Id: <20230203063648.A164AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sparc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE on 64bit
has been removed from the -mm tree.  Its filename was
     sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: sparc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE on 64bit
Date: Fri, 13 Jan 2023 18:10:22 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by stealing one bit from the
type.  Generic MM currently only uses 5 bits for the type
(MAX_SWAPFILES_SHIFT), so the stolen bit was effectively unused.

While at it, mask the type in __swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-23-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/sparc/include/asm/pgtable_64.h~sparc-mm-support-__have_arch_pte_swp_exclusive-on-64bit
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -187,6 +187,9 @@ bool kern_addr_valid(unsigned long addr)
 #define _PAGE_SZHUGE_4U	_PAGE_SZ4MB_4U
 #define _PAGE_SZHUGE_4V	_PAGE_SZ4MB_4V
 
+/* We borrow bit 20 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	_AC(0x0000000000100000, UL)
+
 #ifndef __ASSEMBLY__
 
 pte_t mk_pte_io(unsigned long, pgprot_t, int, unsigned long);
@@ -961,18 +964,47 @@ void pgtable_trans_huge_deposit(struct m
 pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 #endif
 
-/* Encode and de-code a swap entry */
-#define __swp_type(entry)	(((entry).val >> PAGE_SHIFT) & 0xffUL)
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   6 6 6 6 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3
+ *   3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2
+ *   <--------------------------- offset ---------------------------
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   --------------------> E <-- type ---> <------- zeroes -------->
+ */
+#define __swp_type(entry)	(((entry).val >> PAGE_SHIFT) & 0x7fUL)
 #define __swp_offset(entry)	((entry).val >> (PAGE_SHIFT + 8UL))
 #define __swp_entry(type, offset)	\
 	( (swp_entry_t) \
 	  { \
-		(((long)(type) << PAGE_SHIFT) | \
+		((((long)(type) & 0x7fUL) << PAGE_SHIFT) | \
                  ((long)(offset) << (PAGE_SHIFT + 8UL))) \
 	  } )
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	return __pte(pte_val(pte) & ~_PAGE_SWP_EXCLUSIVE);
+}
+
 int page_in_phys_avail(unsigned long paddr);
 
 /*
_

Patches currently in -mm which might be from david@redhat.com are


