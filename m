Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B752C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 17:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351522AbiEQRic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 13:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351515AbiEQRia (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 13:38:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5D31FA5D
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 10:38:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DB1660FB7
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 17:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B31C385B8;
        Tue, 17 May 2022 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652809107;
        bh=BsLFg73cORMVFysXJwnCenKXEsCW5JO5oiRezs1XQ6I=;
        h=Date:To:From:Subject:From;
        b=dpfIEt8Qe4Y6XHdoeN9+7DNedemJtyt3jOuIwL7l/GRU+jYIoSNjLN9jKyfa8Mfpk
         Fj26oi2Jz3LqA2v0nAHDI0n7NRaYZ3Oy7R16+hURaQcSqfLalHNZ/Fp9qDJJqz422k
         oRFt3+PNBHWsUBCzN29U9mvmYxBQZxR90tcKJozM=
Date:   Tue, 17 May 2022 10:38:27 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-3.patch added to mm-unstable branch
Message-Id: <20220517173827.A1B31C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix 32b parent pointers
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-3.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix 32b parent pointers
Date: Tue, 17 May 2022 15:22:20 +0000

32 bit parent pointers need an extra bit to account for increased slot
count.  Update the constants and documentation to use the remaining high
bit.

Link: https://lkml.kernel.org/r/20220517152209.3486724-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 +-
 lib/maple_tree.c           |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/maple_tree.h~maple-tree-add-new-data-structure-fix-3
+++ a/include/linux/maple_tree.h
@@ -37,7 +37,7 @@
 #define MAPLE_NODE_SLOTS	63	/* 256 bytes including ->parent */
 #define MAPLE_RANGE64_SLOTS	32	/* 256 bytes */
 #define MAPLE_ARANGE64_SLOTS	21	/* 240 bytes */
-#define MAPLE_ARANGE64_META_MAX	22	/* Out of range for metadata */
+#define MAPLE_ARANGE64_META_MAX	31	/* Out of range for metadata */
 #define MAPLE_ALLOC_SLOTS	(MAPLE_NODE_SLOTS - 2)
 #endif /* defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64) */
 
--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-3
+++ a/lib/maple_tree.c
@@ -354,7 +354,7 @@ static inline bool mt_is_alloc(struct ma
 /*
  * The Parent Pointer
  * Excluding root, the parent pointer is 256B aligned like all other tree nodes.
- * When storing a 32 or 64 bit values, the offset can fit into 4 bits.  The 16
+ * When storing a 32 or 64 bit values, the offset can fit into 5 bits.  The 16
  * bit values need an extra bit to store the offset.  This extra bit comes from
  * a reuse of the last bit in the node type.  This is possible by using bit 1 to
  * indicate if bit 2 is part of the type or the slot.
@@ -366,19 +366,19 @@ static inline bool mt_is_alloc(struct ma
  *  0x110 = 64 bit nodes
  *
  * Slot size and alignment
- *  0x??1 : Root
- *  0x?00 : 16 bit values, type in 0-1, slot in 2-6
- *  0x010 : 32 bit values, type in 0-2, slot in 3-6
- *  0x110 : 64 bit values, type in 0-2, slot in 3-6
+ *  0b??1 : Root
+ *  0b?00 : 16 bit values, type in 0-1, slot in 2-7
+ *  0b010 : 32 bit values, type in 0-2, slot in 3-7
+ *  0b110 : 64 bit values, type in 0-2, slot in 3-7
  */
 
 #define MAPLE_PARENT_ROOT		0x01
 
 #define MAPLE_PARENT_SLOT_SHIFT		0x03
-#define MAPLE_PARENT_SLOT_MASK		0x78
+#define MAPLE_PARENT_SLOT_MASK		0xF8
 
 #define MAPLE_PARENT_16B_SLOT_SHIFT	0x02
-#define MAPLE_PARENT_16B_SLOT_MASK	0x7C
+#define MAPLE_PARENT_16B_SLOT_MASK	0xFC
 
 #define MAPLE_PARENT_RANGE64		0x06
 #define MAPLE_PARENT_RANGE32		0x04
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-remove-the-vma-linked-list-fix.patch

