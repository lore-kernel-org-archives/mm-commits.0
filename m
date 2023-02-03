Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8A4C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjBCGjj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbjBCGhx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641908E069
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 033BAB82984
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA98C4339B;
        Fri,  3 Feb 2023 06:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406203;
        bh=JoFVoUCkSdcRx/HZKU2lcUSVrxmLjlrzJZbabP0B4OY=;
        h=Date:To:From:Subject:From;
        b=k5qwK6NyR7KzOiIwTpbQqWl5aDJsCBoNumO/qzFxHSj7baCjelcYvRD+yYgy61fuU
         Vzc72MwrC7qPiIsy7erseNedHqkWrUE3JjxenZB30u5erBg7UUv+GaumMcSqC2mKlv
         aSfrnKtgqDc6XMfLoORMZtEolBhK68bDMQzM592I=
Date:   Thu, 02 Feb 2023 22:36:43 -0800
To:     mm-commits@vger.kernel.org, npiggin@gmail.com, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s.patch removed from -mm tree
Message-Id: <20230203063643.9BA98C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE on 32bit book3s
has been removed from the -mm tree.  Its filename was
     powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: powerpc/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE on 32bit book3s
Date: Fri, 13 Jan 2023 18:10:17 +0100

We already implemented support for 64bit book3s in commit bff9beaa2e80
("powerpc/pgtable: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE for book3s")

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE also in 32bit by reusing yet
unused LSB 2 / MSB 29.  There seems to be no real reason why that bit
cannot be used, and reusing it avoids having to steal one bit from the
swap offset.

While at it, mask the type in __swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-18-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/powerpc/include/asm/book3s/32/pgtable.h~powerpc-mm-support-__have_arch_pte_swp_exclusive-on-32bit-book3s
+++ a/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -42,6 +42,9 @@
 #define _PMD_PRESENT_MASK (PAGE_MASK)
 #define _PMD_BAD	(~PAGE_MASK)
 
+/* We borrow the _PAGE_USER bit to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	_PAGE_USER
+
 /* And here we include common definitions */
 
 #define _PAGE_KERNEL_RO		0
@@ -363,17 +366,42 @@ static inline void __ptep_set_access_fla
 #define pmd_page(pmd)		pfn_to_page(pmd_pfn(pmd))
 
 /*
- * Encode and decode a swap entry.
- * Note that the bits we use in a PTE for representing a swap entry
- * must not include the _PAGE_PRESENT bit or the _PAGE_HASHPTE bit (if used).
- *   -- paulus
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs (32bit PTEs):
+ *
+ *                         1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3
+ *   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ *   <----------------- offset --------------------> < type -> E H P
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ *   _PAGE_PRESENT (P) and __PAGE_HASHPTE (H) must be 0.
+ *
+ * For 64bit PTEs, the offset is extended by 32bit.
  */
 #define __swp_type(entry)		((entry).val & 0x1f)
 #define __swp_offset(entry)		((entry).val >> 5)
-#define __swp_entry(type, offset)	((swp_entry_t) { (type) | ((offset) << 5) })
+#define __swp_entry(type, offset)	((swp_entry_t) { ((type) & 0x1f) | ((offset) << 5) })
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) >> 3 })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val << 3 })
 
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
 /* Generic accessors to PTE bits */
 static inline int pte_write(pte_t pte)		{ return !!(pte_val(pte) & _PAGE_RW);}
 static inline int pte_read(pte_t pte)		{ return 1; }
_

Patches currently in -mm which might be from david@redhat.com are


