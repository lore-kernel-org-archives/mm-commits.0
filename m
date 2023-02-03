Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FAAC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjBCGjX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjBCGh1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:37:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8D98E043
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:36:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E257B828B2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AE0C433EF;
        Fri,  3 Feb 2023 06:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406199;
        bh=ld0tZC53lT7XOUKCPTHAOzIRIxsebVnbXqLxhGShuYM=;
        h=Date:To:From:Subject:From;
        b=chzOVGwEjyFQMengPE0x2UaHCcdJfkbo73+zdpYlCoHcruI86eWaV7j5OK/vxwcRo
         AaT8N+rJRbaRb+NCthAFkBXLmK9goSb5qt9clm78Ou6T0WtFTkYxHCwokyWT6EW/h/
         sRpcS/KidwUfqVpPg20hdijSRw7aLsZX59GVpeHw=
Date:   Thu, 02 Feb 2023 22:36:39 -0800
To:     mm-commits@vger.kernel.org, dinguyen@kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nios2-mm-refactor-swap-pte-layout.patch removed from -mm tree
Message-Id: <20230203063639.A9AE0C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2/mm: refactor swap PTE layout
has been removed from the -mm tree.  Its filename was
     nios2-mm-refactor-swap-pte-layout.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: nios2/mm: refactor swap PTE layout
Date: Fri, 13 Jan 2023 18:10:13 +0100

nios2 disables swap for a good reason: it doesn't even provide sufficient
type bits as required by core MM.  However, swap entries are nowadays also
used for other purposes (migration entries, PTE markers, HWPoison, ...),
and accidential use could be problematic.

Let's properly use 5 bits for the swap type and document the layout.  Bits
26--31 should get ignored by hardware completely, so they can be used.

Link: https://lkml.kernel.org/r/20230113171026.582290-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/nios2/include/asm/pgtable.h~nios2-mm-refactor-swap-pte-layout
+++ a/arch/nios2/include/asm/pgtable.h
@@ -232,19 +232,21 @@ static inline unsigned long pmd_page_vad
 		__FILE__, __LINE__, pgd_val(e))
 
 /*
- * Encode and decode a swap entry (must be !pte_none(pte) && !pte_present(pte):
+ * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
+ * are !pte_none() && !pte_present().
  *
- * 31 30 29 28 27 26 25 24 23 22 21 20 19 18 ...  1  0
- *  0  0  0  0 type.  0  0  0  0  0  0 offset.........
+ * Format of swap PTEs:
  *
- * This gives us up to 2**2 = 4 swap files and 2**20 * 4K = 4G per swap file.
+ *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
+ *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ *   0 < type -> 0 0 0 0 0 0 <-------------- offset --------------->
  *
- * Note that the offset field is always non-zero, thus !pte_none(pte) is always
- * true.
+ * Note that the offset field is always non-zero if the swap type is 0, thus
+ * !pte_none() is always true.
  */
-#define __swp_type(swp)		(((swp).val >> 26) & 0x3)
+#define __swp_type(swp)		(((swp).val >> 26) & 0x1f)
 #define __swp_offset(swp)	((swp).val & 0xfffff)
-#define __swp_entry(type, off)	((swp_entry_t) { (((type) & 0x3) << 26) \
+#define __swp_entry(type, off)	((swp_entry_t) { (((type) & 0x1f) << 26) \
 						 | ((off) & 0xfffff) })
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
_

Patches currently in -mm which might be from david@redhat.com are


