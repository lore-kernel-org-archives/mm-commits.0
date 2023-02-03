Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1092C6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjBCGjx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbjBCGi2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:38:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B759B8E4B1
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5370861DA5
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69F9C4339B;
        Fri,  3 Feb 2023 06:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406206;
        bh=68fpWUHr11vLfrk54keXvDvSLsfdpndkjdBc0iri6SE=;
        h=Date:To:From:Subject:From;
        b=RrMq3xJBPrGVdyXFfY/pq1maSwiuGiofdZl5FtwSqaeaFtFfBOtrGJcaQ1GCYAUqi
         WT9VtWW7sweSMmSdW86annKfeh+PB4bJ0QbJxA4y4Reei7ooeH8ILsBc+a9QoGolnn
         kH/thKbHfqNOKxi6vlkWNRVIpL1LkMbOAX+mH7Fw=
Date:   Thu, 02 Feb 2023 22:36:46 -0800
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        dalias@libc.org, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063646.A69F9C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     sh-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: sh/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:20 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by using bit 6 in the PTE,
reducing the swap type in the !CONFIG_X2TLB case to 5 bits.  Generic MM
currently only uses 5 bits for the type (MAX_SWAPFILES_SHIFT), so the
stolen bit is effectively unused.

Interrestingly, the swap type in the !CONFIG_X2TLB case could currently
overlap with the _PAGE_PRESENT bit, because there is a sneaky shift by 1
in __pte_to_swp_entry() and __swp_entry_to_pte().  Bit 0-7 in the
architecture specific swap PTE would get shifted to bit 1-8 in the PTE. 
As generic MM uses 5 bits only, this didn't matter so far.

While at it, mask the type in __swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-21-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/sh/include/asm/pgtable_32.h~sh-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -423,40 +423,70 @@ static inline unsigned long pmd_page_vad
 #endif
 
 /*
- * Encode and de-code a swap entry
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
  *
  * Constraints:
  *	_PAGE_PRESENT at bit 8
  *	_PAGE_PROTNONE at bit 9
  *
- * For the normal case, we encode the swap type into bits 0:7 and the
- * swap offset into bits 10:30. For the 64-bit PTE case, we keep the
- * preserved bits in the low 32-bits and use the upper 32 as the swap
- * offset (along with a 5-bit type), following the same approach as x86
- * PAE. This keeps the logic quite simple.
+ * For the normal case, we encode the swap type and offset into the swap PTE
+ * such that bits 8 and 9 stay zero. For the 64-bit PTE case, we use the
+ * upper 32 for the swap offset and swap type, following the same approach as
+ * x86 PAE. This keeps the logic quite simple.
  *
  * As is evident by the Alpha code, if we ever get a 64-bit unsigned
  * long (swp_entry_t) to match up with the 64-bit PTEs, this all becomes
  * much cleaner..
- *
- * NOTE: We should set ZEROs at the position of _PAGE_PRESENT
- *       and _PAGE_PROTNONE bits
  */
+
 #ifdef CONFIG_X2TLB
+/*
+ * Format of swap PTEs:
+ *
+ *   6 6 6 6 5 5 5 5 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 3 3 3 3 3 3 3 3
+ *   3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2
+ *   <--------------------- offset ----------------------> < type ->
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <------------------- zeroes --------------------> E 0 0 0 0 0 0
+ */
 #define __swp_type(x)			((x).val & 0x1f)
 #define __swp_offset(x)			((x).val >> 5)
-#define __swp_entry(type, offset)	((swp_entry_t){ (type) | (offset) << 5})
+#define __swp_entry(type, offset)	((swp_entry_t){ ((type) & 0x1f) | (offset) << 5})
 #define __pte_to_swp_entry(pte)		((swp_entry_t){ (pte).pte_high })
 #define __swp_entry_to_pte(x)		((pte_t){ 0, (x).val })
 
 #else
-#define __swp_type(x)			((x).val & 0xff)
+/*
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <--------------- offset ----------------> 0 0 0 0 E < type -> 0
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ */
+#define __swp_type(x)			((x).val & 0x1f)
 #define __swp_offset(x)			((x).val >> 10)
-#define __swp_entry(type, offset)	((swp_entry_t){(type) | (offset) <<10})
+#define __swp_entry(type, offset)	((swp_entry_t){((type) & 0x1f) | (offset) << 10})
 
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) >> 1 })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val << 1 })
 #endif
 
+/* In both cases, we borrow bit 6 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_USER
+
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte.pte_low & _PAGE_SWP_EXCLUSIVE;
+}
+
+PTE_BIT_FUNC(low, swp_mkexclusive, |= _PAGE_SWP_EXCLUSIVE);
+PTE_BIT_FUNC(low, swp_clear_exclusive, &= ~_PAGE_SWP_EXCLUSIVE);
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_SH_PGTABLE_32_H */
_

Patches currently in -mm which might be from david@redhat.com are


