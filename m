Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD265C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbjBCGih (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjBCGhD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8D28DAFC
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EA4161DA6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A946CC433EF;
        Fri,  3 Feb 2023 06:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406192;
        bh=F/F3nIW51kCh8sx1qwqXWbFUMjggqRg+wIqMbzwN5DI=;
        h=Date:To:From:Subject:From;
        b=mkntW7LU7P3Xrh6MYzqTLmv6urKwfRL3syy9xP3pPbE79cQsVIUY/NJGsN7UlIySW
         3F8su7elsHypUzOGvAnx5HsXQi45gaE89xLGBm45Q7WFbmj4Jqa9EH+GiWwmlM5+lN
         tSB2aKSSa7qg1IStpBgouBsdEsURyMIn2cdJxI4Y=
Date:   Thu, 02 Feb 2023 22:36:32 -0800
To:     mm-commits@vger.kernel.org, bcain@quicinc.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hexagon-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063632.A946CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hexagon/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     hexagon-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: hexagon/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:06 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by stealing one bit from the
offset.  This reduces the maximum swap space per file to 16 GiB (was 32
GiB).

While at it, mask the type in __swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/hexagon/include/asm/pgtable.h~hexagon-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/hexagon/include/asm/pgtable.h
@@ -61,6 +61,9 @@ extern unsigned long empty_zero_page;
  * So we'll put up with a bit of inefficiency for now...
  */
 
+/* We borrow bit 6 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	(1<<6)
+
 /*
  * Top "FOURTH" level (pgd), which for the Hexagon VM is really
  * only the second from the bottom, pgd and pud both being collapsed.
@@ -359,9 +362,12 @@ static inline unsigned long pmd_page_vad
 #define ZERO_PAGE(vaddr) (virt_to_page(&empty_zero_page))
 
 /*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
  * Swap/file PTE definitions.  If _PAGE_PRESENT is zero, the rest of the PTE is
  * interpreted as swap information.  The remaining free bits are interpreted as
- * swap type/offset tuple.  Rather than have the TLB fill handler test
+ * listed below.  Rather than have the TLB fill handler test
  * _PAGE_PRESENT, we're going to reserve the permissions bits and set them to
  * all zeros for swap entries, which speeds up the miss handler at the cost of
  * 3 bits of offset.  That trade-off can be revisited if necessary, but Hexagon
@@ -371,9 +377,10 @@ static inline unsigned long pmd_page_vad
  * Format of swap PTE:
  *	bit	0:	Present (zero)
  *	bits	1-5:	swap type (arch independent layer uses 5 bits max)
- *	bits	6-9:	bits 3:0 of offset
+ *	bit	6:	exclusive marker
+ *	bits	7-9:	bits 2:0 of offset
  *	bits	10-12:	effectively _PAGE_PROTNONE (all zero)
- *	bits	13-31:  bits 22:4 of swap offset
+ *	bits	13-31:  bits 21:3 of swap offset
  *
  * The split offset makes some of the following macros a little gnarly,
  * but there's plenty of precedent for this sort of thing.
@@ -383,11 +390,29 @@ static inline unsigned long pmd_page_vad
 #define __swp_type(swp_pte)		(((swp_pte).val >> 1) & 0x1f)
 
 #define __swp_offset(swp_pte) \
-	((((swp_pte).val >> 6) & 0xf) | (((swp_pte).val >> 9) & 0x7ffff0))
+	((((swp_pte).val >> 7) & 0x7) | (((swp_pte).val >> 10) & 0x3ffff8))
 
 #define __swp_entry(type, offset) \
 	((swp_entry_t)	{ \
-		((type << 1) | \
-		 ((offset & 0x7ffff0) << 9) | ((offset & 0xf) << 6)) })
+		(((type & 0x1f) << 1) | \
+		 ((offset & 0x3ffff8) << 10) | ((offset & 0x7) << 7)) })
+
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
 
 #endif
_

Patches currently in -mm which might be from david@redhat.com are


