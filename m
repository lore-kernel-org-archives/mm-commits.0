Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA6CC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjBCGj6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbjBCGih (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:38:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C758E6A9
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08271B82988
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0C7C4339B;
        Fri,  3 Feb 2023 06:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406209;
        bh=vwPa+we6Poo+eJxhxA/AdUahKUWa3ejUNIxGpuHSh/Q=;
        h=Date:To:From:Subject:From;
        b=2LrYtMIUDAMNC4IoKQTSLa89NPc9F+Lg9yS3o16bo2BYfZbbnrgqDs6wF/8ZPgMhx
         VgEp+ow8TEXUKZ3oxjgp2Th+CdgCn7jXrvNlZSnjumv9eeaqrtyXJsLYgTg6Fi4IUB
         XzTO/9maCmkM5iu2y3BajKWQ9TaXBTstNLTaOhGc=
Date:   Thu, 02 Feb 2023 22:36:49 -0800
To:     mm-commits@vger.kernel.org, richard@nod.at,
        johannes@sipsolutions.net, anton.ivanov@cambridgegreys.com,
        david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] um-mm-support-__have_arch_pte_swp_exclusive.patch removed from -mm tree
Message-Id: <20230203063649.AA0C7C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: um/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
has been removed from the -mm tree.  Its filename was
     um-mm-support-__have_arch_pte_swp_exclusive.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: um/mm: support __HAVE_ARCH_PTE_SWP_EXCLUSIVE
Date: Fri, 13 Jan 2023 18:10:23 +0100

Let's support __HAVE_ARCH_PTE_SWP_EXCLUSIVE by using bit 10, which is yet
unused for swap PTEs.

The pte_mkuptodate() is a bit weird in __pte_to_swp_entry() for a swap PTE
...  but it only messes with bit 1 and 2 and there is a comment in
set_pte(), so leave these bits alone.

While at it, mask the type in __swp_entry().

Link: https://lkml.kernel.org/r/20230113171026.582290-24-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/um/include/asm/pgtable.h~um-mm-support-__have_arch_pte_swp_exclusive
+++ a/arch/um/include/asm/pgtable.h
@@ -21,6 +21,9 @@
 #define _PAGE_PROTNONE	0x010	/* if the user mapped it with PROT_NONE;
 				   pte_present gives true */
 
+/* We borrow bit 10 to store the exclusive marker in swap PTEs. */
+#define _PAGE_SWP_EXCLUSIVE	0x400
+
 #ifdef CONFIG_3_LEVEL_PGTABLES
 #include <asm/pgtable-3level.h>
 #else
@@ -288,16 +291,46 @@ extern pte_t *virt_to_pte(struct mm_stru
 
 #define update_mmu_cache(vma,address,ptep) do {} while (0)
 
-/* Encode and de-code a swap entry */
+/*
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
+ *
+ * Format of swap PTEs:
+ *
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   <--------------- offset ----------------> E < type -> 0 0 0 1 0
+ *
+ *   E is the exclusive marker that is not stored in swap entries.
+ *   _PAGE_NEWPAGE (bit 1) is always set to 1 in set_pte().
+ */
 #define __swp_type(x)			(((x).val >> 5) & 0x1f)
 #define __swp_offset(x)			((x).val >> 11)
 
 #define __swp_entry(type, offset) \
-	((swp_entry_t) { ((type) << 5) | ((offset) << 11) })
+	((swp_entry_t) { (((type) & 0x1f) << 5) | ((offset) << 11) })
 #define __pte_to_swp_entry(pte) \
 	((swp_entry_t) { pte_val(pte_mkuptodate(pte)) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
+#define __HAVE_ARCH_PTE_SWP_EXCLUSIVE
+static inline int pte_swp_exclusive(pte_t pte)
+{
+	return pte_get_bits(pte, _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline pte_t pte_swp_mkexclusive(pte_t pte)
+{
+	pte_set_bits(pte, _PAGE_SWP_EXCLUSIVE);
+	return pte;
+}
+
+static inline pte_t pte_swp_clear_exclusive(pte_t pte)
+{
+	pte_clear_bits(pte, _PAGE_SWP_EXCLUSIVE);
+	return pte;
+}
+
 /* Clear a kernel PTE and flush it from the TLB */
 #define kpte_clear_flush(ptep, vaddr)		\
 do {						\
_

Patches currently in -mm which might be from david@redhat.com are


